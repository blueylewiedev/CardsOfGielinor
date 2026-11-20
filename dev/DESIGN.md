# Design notes

Why the code is the way it is: measurements made in the client, bugs that shaped a design, and "this used to be X". They used to be
comments in the code; they are here so the code can say what it does and keep only the warnings a reader needs. One section per file,
newest last. Not in the release.

## core/storage.lua

Measured with a throwaway probe (2026-11-12): a table of 2,000 entries is accepted and 3,000 refused; a string of 100,000 letters is
accepted and 131,056 refused. A full collection has thousands of entries, hence the main key plus buckets.

BUCKETS is 32, not 16: a card is kept in up to one entry per finish (normal, foil, holo), so a full three-finish collection of 5,595 cards is
600 entries in the fullest bucket at 32 (1,131 at 16), against the 2,000 known to be accepted. That is room for about 18,600 cards;
dev/check_storage.lua fails when the fullest bucket passes half of the 2,000 (about 9,300 cards at three finishes), the time to think again.

## core/bosses.lua

How a kill is seen (found with the Boss probe, 2026-11-17, in K'ril Tsutsaroth, Corporeal Beast, Rasial and Zemouregal):
- The server counts boss kills in the VarPlayers named BSLAY_BOSS_KILLS<n> (about 45 of them). A kill raises a count inside one of them by exactly 1
  at the count's own place: +1, or +65536 for a count in the high 16 bits, or another power of two for a count in a varbit. Which half is the normal
  count and which hard mode differs from boss to boss, so no half is treated differently.
- The variable does not say which boss it was. The bosses carry a BSLAY_ID parameter. The boss was in view 0 to 2 ticks before the count rose in all
  four tests and left view in the same tick or one after, so the boss that was last in view at the moment of the rise is the one killed.
  (NPCEntityRemoved is no use here: the entities cannot be read when it fires.)
- Activities: the Barrows count rises when the chest is looted, about 90 seconds after the last brother died, and only Verac of the brothers carries
  a BSLAY_ID. Shipped: the Barrows chest (BSLAY_BOSS_KILLS2 rising by 65,536, 1,800 credits). Add one only after seeing the count rise in the game.
- Vindicta stayed in view 10 ticks after her count rose (PAID_BLOCK is 12). Gorvek and Vindicta report levels 0 and 1,000, Har-Aken 800 and 1,600, so the
  highest level of a sighting is the boss's.

Tiers as shipped (Config "bosses.tiers", placeholders to be tuned from play-testing; combat levels run from about 150 to 14,000 and say how hard a boss
is better than how quickly it dies):
    9000 -> 8000    Vorago, Seiryu, Zamorak, Amascut, TzKal-Zuk
    5000 -> 4000    Solak, Rasial, Arch-Glacor, Croesus, Raksha, Nex: Angel of Death, the Ambassador
    1000 -> 1800    Telos, Araxxi, Kalphite King, Nex, Kezalam, Nakatra, and most others of the last years
     500 ->  800    the God Wars bosses, Corporeal Beast, Har-Aken, Queen Black Dragon, TzTok-Jad, Zemouregal
       0 ->  400    King Black Dragon, Giant Mole, Kalphite Queen, Chaos Elemental, the Dagannoth Kings

## core/slayer.lua

How a kill is seen. The server counts the kills, in VarPlayer 183 (SLAYER_COUNT, the kills left): it drops when a task monster is killed.
That alone is not enough, because cancelling a task (or a reset) moves it too, so a drop only counts if Slayer XP arrives within XP_WINDOW server
ticks of it (a kill always gives Slayer XP, a cancel never does), and a drop of more than MAX_DROP is never kills. The count does not say which
monster died. The monster leaves the world a few server ticks later (2 to 6 were seen, once its death animation ends), so after a confirmed drop the
NPCs that leave are looked at for WAIT_TICKS: the first ones that leave after the drop and count for the task are the kills, and each is paid its
own combat level. (Always after the drop: in the same update as it is too soon to be the kill.) A monster that left before the drop died earlier (and a
monster leaving is not always a death: it may only have walked out of view), so it is never matched. A drop of 5 can be one monster (an abyssal lord
counts as five), so the credits are per monster killed, not per unit of the count. A drop with no monster to match still pays one kill, at the level
of the last monster killed for the task (or the task's example monster).

Completion. VarPlayer 10077 (SMKI_MISSION_COUNT, the streak) rises by exactly 1 when a task is completed. Cancelling keeps the streak, and skipping
resets it to 0, so neither is mistaken for a completion. The bonus is "slayer.bonusMultiplier" times the average level of the kills paid on that task,
and is paid once the last kill is.

The credits: a kill pays "slayer.creditsPerLevel" (1) for each combat level, the bonus is "slayer.bonusMultiplier" (5) times that for the average
level. Variable ids (183, 185, 10077) may be moved by a game update. "slayer.levelCap" exists because a few bosses report levels in the thousands.

## ui/cardview.lua

Silhouettes (found in the client, Nov 2026): a model in a ModelGroup ignores any lighting, environment or recolour, so it cannot be darkened, but
models in one group cast shadows on each other from the client's default sun, and the camera's near clip plane can cut a model out while its shadow
stays. So the card's camera is moved to where the sun is, a big flat model (a Varrock single bed, scaled up) stands behind the figure as a screen, and
the figure itself is clipped away: only its grey outline on the screen shows. The numbers (SHADOW) were tuned by eye on the shop, guard and musician
NPCs and on swords, bars, ores and herbs.

Title font steps: about 8.2, 7.0 and 6.2 card units a letter at the 15, 13 and 11 point sizes, measured from cards in the client.

## ui/packart.lua

How a pack is drawn, and why (found in the game with a test plugin):
- Login screens come in 9 tiles (3 x 3), together a 16:9 picture; a cutscene picture is one sprite, taken to be 16:9 as well (the client can't say). The
  picture is fitted to the height of the pack's outline (not its box, which has empty margins), so all of it shows top to bottom, and each side shows an
  outline-wide window of it, about a third.
- There is no masking, but layers clip what is inside them. So the pack's outline is traced by strips (ui/packmask.lua), each a layer showing its part of
  the picture. The crimps are narrow columns shifted up or down a little, so the art looks pinched there.
- The light and shadow (resources/images/pack_shading*.png) go on top; the back is mirrored and has a seal seam.
- Text can't be scaled, so the titles are images (resources/images/title_<id>.png), drawn ahead of time by dev/make_pack_art.py and shrunk to fit the
  banner's inner panel.
- The client says 0 x 0 for a sprite's size, so the shapes of the banner and logos (width / height) are written in the code.
The mask, shading and titles are made by dev/make_pack_art.py.

## ui/kit.lua

Kit.dropdown: PrettyUI's ordered ComboBox filters every entry as it opens, which ran past the client's one-second limit for a list of over about 50
entries (Wiki Fetch's Race list, 2026-11-19); the sorted kind does not. The same limit hit the tag picker's few hundred PrettyUI toggle buttons.

## ui/revealscreen.lua

Handler retention (2026-11-19): the client keeps an event handler after the component it was given is destroyed. A handler whose closure reaches a
card's view and model, or the pack's parts (through a table it holds), keeps them alive, and with them the memory the client holds for them: a pack
opening grew the client by about 650 MB for every ten packs, until the plugin was reloaded. Hence handlers hold only a handle that is emptied when the
parts are destroyed.

## ui/viewer.lua

The category drop-down: PrettyUI's drop-down that can be typed in rebuilds the whole list for each entry when it opens, and gave up after a second on
a list of over 200 entries, so the category list is the plain, sorted kind, which sorts "Any category" in with the rest (the space in front keeps it at the top).

## core/overlayloader.lua

The client crashes when a request is sent from a coroutine or from inside another request's callback (other plugin developers' findings, checked with
dev/httpprobe.lua). So everything runs from Event.Logic ticks (50 a second) and nothing uses a coroutine; a request is only ever started from a tick, and
its callback only records that it finished; the response is read, and the overlay applied (100 lines a tick), on later ticks.

## core/identity.lua

PERMISSION_GRACE_TICKS was 20 (about 12 seconds), which is a long wait for a player who has not granted the permission, with the main window showing its
loading screen all that time; it is 10 now. The dev copy asks for the permission as it loads, and the client may take a moment to apply it.

## core/slayertasks.lua

Owner review 2026-11-15: Greater demons are in Demons, Hellhounds are not (only the Zamorakian Undercity ones count) and Rune dragons are in Dragons.
Checked with kills in the game: an Imp, Lesser demons and Black demons count for Demons; Blue and Bronze dragons for Dragons. The narrower categories
of a broad task are not in any data the client can read, hence the lists.

## core/memory.lua

Paging quickly through the Collection's grid made cards faster than they were freed, and the client's memory spiked from 4.2 GB to 8.7 GB for a few
seconds before falling back by itself. Lua does not feel the pressure since its own heap is small (tens of MB).

## core/earning.lua

Constitution was listed as CONSTITUTION in "earning.combatSkills", which is not a SkillType member (it is HITPOINTS, skill 3), so its XP earned credits
until 2026-11-17.
