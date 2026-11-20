-- deck/packs.lua
-- Themed pack types, added to Cards.packTypes (core/cards.lua) beside the standard pack. Each
-- one is made in the Pack Maker (Dev tools window): design it, choose its cards,
-- press Save, then copy its line from the window and paste it into this list.
--
-- A pack type here holds:
--   id, name : id is for code and saving (never change it once the pack is in the game), name is
--              what the player sees
--   filter   : which cards it can give, as in Cards.packTypes, e.g. { regions = "misthalin" } (or
--              { regions = "none" } for the cards from no one region)
--   art      : how the pack looks (see ui/packart.lua)
--   and any of the other pack type fields (size, minRarity, featured, and priceFactor: themed packs cost
--   the "packs.themedPriceFactor" tuning key (core/config.lua) times the standard price unless they set their own).
--
-- Every pack listed here is offered in the Shop: the featured ones in its General section, in that order, then the rest
-- under Regions by name.
-- The Pack Maker's line keeps the pack's other fields (priceFactor, size, minRarity, featured), so pasting
-- it over a pack's line changes only its name, cards and look.
--
-- A line with the id of a pack type that already exists is not a new pack: it changes that pack's
-- fields. The Pack Maker makes one for the standard pack (choose "All cards" under Cards): it
-- gives it a name and look, and it keeps every card and the standard price.

return {
    { id = "standard", name = "Standard pack", art = { screen = "RS3_LOGINSCREEN_DEFAULT_NXT", front = 0.549, back = 0.040, name = { title = "standard", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "gielinor_pack", name = "Gielinor pack", filter = { regions = "none" }, featured = 3, art = { screen = "RS3_LOGINSCREEN_MEGAMAY_NXT", front = 0.585, back = 0.013, name = { title = "gielinor", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    -- (priceFactor 0.75: cheaper than the standard pack. featured 2: in the Shop's General section, after the standard pack)
    { id = "free_to_play_pack", name = "Free to Play pack", filter = { membership = "f2p" }, priceFactor = 0.75, featured = 2, art = { screen = "RS3_LOGINSCREEN_ANNIVERSARY20_NXT", front = 0.027, back = 0.507, name = { title = "free_to_play", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "misthalin_pack", name = "Misthalin pack", filter = { regions = "misthalin" }, art = { screen = "RS3_LOGINSCREEN_CONCONTRACTS_NXT", front = 0.067, back = 0.553, name = { title = "misthalin", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "kharidian_pack", name = "Kharidian pack", filter = { regions = "kharidian_desert" }, art = { screen = "RS3_LOGINSCREEN_MENAPHOS_CHARS_ALL_NXT", front = 0.600, back = 0.029, name = { title = "kharidian_desert", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "asgarnia_pack", name = "Asgarnia pack", filter = { regions = "asgarnia" }, art = { screen = "RS3_LOGINSCREEN_NEX2_NXT", front = 0.042, back = 0.571, name = { title = "asgarnia", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "kandarin_pack", name = "Kandarin pack", filter = { regions = "kandarin" }, art = { screen = "RS3_LOGINSCREEN_POF_NXT", front = 0.013, back = 0.643, name = { title = "kandarin", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "tirannwn_pack", name = "Tirannwn pack", filter = { regions = "tirannwn" }, art = { screen = "RS3_LOGINSCREEN_SOLAK_NXT", front = 0.558, back = 0.044, name = { title = "tirannwn", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "wilderness_pack", name = "Wilderness pack", filter = { regions = "wilderness" }, art = { screen = "RS3_LOGINSCREEN_EGWD_ZAMORAK_BOSS", front = 0.638, back = 0.033, name = { title = "wilderness", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 32, w = 130 } } },
    { id = "anachronia_pack", name = "Anachronia pack", filter = { regions = "anachronia" }, art = { screen = "RS3_LOGINSCREEN_FARMING120_NXT", front = 0.038, back = 0.627, name = { title = "anachronia", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "morytania_pack", name = "Morytania pack", filter = { regions = "morytania" }, art = { screen = "RS3_LOGINSCREEN_MYQ7_NXT", front = 0.585, back = 0.000, name = { title = "morytania", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "karamja_pack", name = "Karamja pack", filter = { regions = "karamja" }, art = { screen = "RS3_LOGINSCREEN_PIRATE_FINALE_NXT", front = 0.583, back = 0.000, name = { title = "karamja", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "havenhythe_pack", name = "Havenhythe pack", filter = { regions = "havenhythe" }, art = { screen = "HAVENHYTHE_INTRO_CUTSCENE_SCENE_02_0001_BG", front = 0.469, back = 0.145, name = { title = "havenhythe", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "fremennik_pack", name = "Fremennik pack", filter = { regions = "fremennik_province" }, art = { screen = "RS3_LOGINSCREEN_RUNEPASS_12", front = 0.612, back = 0.062, name = { title = "fremennik_province", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
}
