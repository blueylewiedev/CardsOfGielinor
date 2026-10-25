-- deck/packs.lua
-- Themed pack types, added to Cards.packTypes (core/cards.lua) next to the standard pack. Each
-- one is made in the Pack Maker (Home window, developer buttons): design it, choose its cards,
-- press Save, then copy its line from the window and paste it into this list.
--
-- A pack type here holds:
--   id, name : id is for code and saving (never change it once the pack is in the game), name is
--              what the player sees
--   filter   : which cards it can give, as in Cards.packTypes, e.g. { regions = "misthalin" }
--   art      : how the pack looks (see ui/packart.lua)
--   and any of the other pack type fields (size, minRarity, and priceFactor: themed packs cost
--   Cards.THEMED_PRICE_FACTOR times the standard price unless they set their own).
--
-- Every pack listed here is offered in the pack window, after the standard pack.

return {
    { id = "misthalin_pack", name = "Misthalin pack", filter = { regions = "misthalin" }, art = { screen = "RS3_LOGINSCREEN_CONCONTRACTS_NXT", front = 0.067, back = 0.553, name = { title = "misthalin", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "kharidian_pack", name = "Kharidian pack", filter = { regions = "kharidian_desert" }, art = { screen = "RS3_LOGINSCREEN_MENAPHOS_CHARS_ALL_NXT", front = 0.600, back = 0.029, name = { title = "kharidian_desert", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "asgarnia_pack", name = "Asgarnia pack", filter = { regions = "asgarnia" }, art = { screen = "RS3_LOGINSCREEN_NEX2_NXT", front = 0.042, back = 0.571, name = { title = "asgarnia", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "kandrian_pack", name = "Kandrian pack", filter = { regions = "kandarin" }, art = { screen = "RS3_LOGINSCREEN_POF_NXT", front = 0.013, back = 0.643, name = { title = "kandarin", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "tirannwn_pack", name = "Tirannwn pack", filter = { regions = "tirannwn" }, art = { screen = "RS3_LOGINSCREEN_SOLAK_NXT", front = 0.558, back = 0.044, name = { title = "tirannwn", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "wilderness_pack", name = "Wilderness pack", filter = { regions = "wilderness" }, art = { screen = "RS3_LOGINSCREEN_EGWD_ZAMORAK_BOSS", front = 0.638, back = 0.033, name = { title = "wilderness", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 32, w = 130 } } },
    { id = "anachronia_pack", name = "Anachronia pack", filter = { regions = "anachronia" }, art = { screen = "RS3_LOGINSCREEN_FARMING120_NXT", front = 0.038, back = 0.627, name = { title = "anachronia", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "morytania_pack", name = "Morytania pack", filter = { regions = "morytania" }, art = { screen = "RS3_LOGINSCREEN_MYQ7_NXT", front = 0.585, back = 0.000, name = { title = "morytania", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "karamja_pack", name = "Karamja pack", filter = { regions = "karamja" }, art = { screen = "RS3_LOGINSCREEN_PIRATE_FINALE_NXT", front = 0.583, back = 0.000, name = { title = "karamja", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 44, w = 130 } } },
    { id = "havenhythe_pack", name = "Havenhythe pack", filter = { regions = "havenhythe" }, art = { screen = "HAVENHYTHE_INTRO_CUTSCENE_SCENE_02_0001_BG", front = 0.469, back = 0.145, name = { title = "havenhythe", x = 0, y = 226, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
    { id = "fremennik_pack", name = "Fremennik pack", filter = { regions = "fremennik_province" }, art = { screen = "RS3_LOGINSCREEN_RUNEPASS_12", front = 0.612, back = 0.062, name = { title = "fremennik_province", x = 0, y = 230, w = 150 }, logo = { sprite = "RS3_LOGO_MEDIUM", x = 0, y = 40, w = 130 } } },
}
