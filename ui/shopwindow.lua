-- ui/shopwindow.lua
-- The Shop: every pack on offer as a small picture in a grid, the chosen one shown large beside it with what it is, its
-- price, a drop-down for how many to buy, and the Buy button. Buying takes the credits, rolls the cards and saves
-- (core/packs.lua), then hands the cards to the pack window for the reveal (api.startReveal).
--
-- The pictures in the grid are flat (one sprite per picture tile, PackArt.drawTile); only the large pack is drawn in
-- full (hundreds of parts, PackArt.drawFront), and it is drawn again each time another pack is chosen.
--
-- Set by Shop.toggle(newApi):
--   api.getState()    : the logged-in character's collection, or nil
--   api.saveNow()     : saves it straight away
--   api.busy()        : true while cards from an earlier purchase are still being revealed
--   api.startReveal(results, packTypeId) : shows the cards just bought

local Cards = require("core/cards")
local Format = require("core/format")
local Logger = require("core/logger")
local Packs = require("core/packs")
local PackArt = require("ui/packart")
local Kit = require("ui/kit")

local Shop = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)

local COLUMNS = 4
local TILE_H = 120                                  -- a tile is as wide as the pack's outline, TILE_W
local TILE_W = math.floor(TILE_H * PackArt.OUTLINE.w / PackArt.OUTLINE.h)
local GAP_X = 14
local LABEL_H = 20                                  -- the pack's name under its tile
local ROW_H = TILE_H + LABEL_H + 10
local GRID_W = COLUMNS * TILE_W + (COLUMNS - 1) * GAP_X
local TOP = 28                                      -- the credits line is above this
local DETAIL_X, DETAIL_W = GRID_W + 24, 250
local PACK_H = 190                                  -- the large pack
local DETAIL_H = 440
local WIDTH = DETAIL_X + DETAIL_W + 44              -- the frame and padding take 44 (Kit.contentWidth)

local api = nil
local window, content = nil, nil
local widgets = {}
local tiles = {}                  -- pack type id -> { draw, outline }
local bigPack = nil               -- the large pack: { root, w, destroy() }
local selected = "standard"       -- the pack type chosen (kept while the plugin runs)
local quantity = 1                -- how many packs to buy (kept while the plugin runs)

local function setText(widget, text)
    if widget.content ~= text then
        widget.content = text
    end
end

-- The name as shown under a tile: "Misthalin pack" -> "Misthalin".
local function shortName(packType)
    return (string.gsub(packType.name, " pack$", ""))
end

-- Up to three short lines about a pack type.
local function describe(packType, id)
    local lines = { (packType.size or Packs.PACK_SIZE) .. " cards per pack" }
    local filter = packType.filter
    if filter == nil then
        lines[2] = "Any card in the game"
    elseif filter.regions ~= nil then
        lines[2] = "Only cards from " .. shortName(packType)
    else
        lines[2] = "A themed selection of cards"
    end
    if packType.minRarity ~= nil and Cards.rarities[packType.minRarity] ~= nil then
        lines[3] = Cards.rarities[packType.minRarity].name .. " or better"
    else
        lines[3] = Format.credits(Packs.poolSize(id)) .. " cards to find"
    end
    return lines
end

-- Draws the chosen pack large, and its name and lines.
local function showSelected()
    local packType = Packs.typeById(selected)
    if packType == nil then
        return
    end
    if bigPack ~= nil then
        bigPack.destroy()
        bigPack = nil
    end
    local ok, pack = pcall(PackArt.drawFront, content, selected, PACK_H)
    if ok and pack ~= nil then
        bigPack = pack
        pack.root:SetPos(DETAIL_X + (DETAIL_W - pack.w) // 2, TOP)
    else
        Logger.error("shop: the pack could not be drawn:", tostring(pack))
    end
    setText(widgets.name, packType.name)
    local lines = describe(packType, selected)
    for i = 1, 3 do
        setText(widgets.info[i], lines[i] or "")
    end
    for id, tile in pairs(tiles) do
        tile.outline.hidden = (id ~= selected)
    end
end

-- Chooses a pack.
local function choose(packTypeId)
    if packTypeId == selected and bigPack ~= nil then
        return
    end
    selected = packTypeId
    showSelected()
    Shop.refresh()
end

-- One pack's picture, name and click area, in grid cell `index` (counting from 0).
local function addTile(packType, index)
    local x = (index % COLUMNS) * (TILE_W + GAP_X)
    local y = TOP + (index // COLUMNS) * ROW_H
    local tile = {}
    tile.draw = PackArt.drawTile(content, packType.id, TILE_H)
    tile.draw.root:SetPos(x, y)
    tile.label = Kit.text(content, x - GAP_X // 2, y + TILE_H + 2, TILE_W + GAP_X, LABEL_H, shortName(packType), GREY)
    tile.outline = ui.Rectangle.new(content)
    tile.outline:SetPos(x - 2, y - 2)
    tile.outline:SetSize(TILE_W + 4, TILE_H + 4)
    tile.outline.fill = false
    tile.outline.outlineThickness = 2
    tile.outline.colour = GOLD
    tile.outline.hidden = true
    -- The click area is a layer of its own on top, the way the credits bar takes its clicks.
    tile.grip = ui.Layer.new(content)
    tile.grip:SetPos(x, y)
    tile.grip:SetSize(TILE_W, TILE_H)
    tile.grip.clickthrough = false
    tile.grip:Subscribe(ui.Hook.ONCLICK, function() choose(packType.id) end)
    tiles[packType.id] = tile
end

local function buy()
    local state = api ~= nil and api.getState() or nil
    if state == nil or (api.busy ~= nil and api.busy()) then
        return
    end
    local results, reason = Packs.open(state, selected, quantity)
    if results == nil then
        Logger.debug("shop: not bought:", reason)
        Shop.refresh()
        return
    end
    api.saveNow()
    Shop.hide()
    api.startReveal(results, selected)
end

-- Brings the window up to date with the character's credits and the choices. Called every tick; only changes what
-- is different.
function Shop.refresh()
    if window == nil or widgets.credits == nil then
        return
    end
    local state = api ~= nil and api.getState() or nil
    local price = Packs.priceFor(selected) or 0
    local total = price * quantity
    setText(widgets.credits, state ~= nil and ("Credits: " .. Format.credits(state.credits)) or "Loading your collection...")
    setText(widgets.price, "Price: " .. Format.credits(price) .. " credits each")
    setText(widgets.total, "Total: " .. Format.credits(total) .. " credits")
    local label = "Buy " .. quantity .. (quantity == 1 and " pack" or " packs")
    if widgets.buyLabel ~= label then
        widgets.buyLabel = label
        Kit.setLabel(widgets.buy, label)
    end
    local hint = ""
    local canBuy = state ~= nil
    if state ~= nil then
        if Packs.poolSize(selected) == 0 then
            hint, canBuy = "No cards in this pack yet", false
        elseif api.busy ~= nil and api.busy() then
            hint, canBuy = "Finish opening your cards first", false
        elseif state.credits < total then
            hint, canBuy = "Need " .. Format.credits(total - state.credits) .. " more credits", false
        end
    end
    setText(widgets.hint, hint)
    if widgets.canBuy ~= canBuy then
        widgets.canBuy = canBuy
        Kit.setEnabled(widgets.buy, canBuy)
    end
end

function Shop.isOpen()
    return window ~= nil
end

function Shop.hide()
    if bigPack ~= nil then
        bigPack.destroy()
        bigPack = nil
    end
    for _, tile in pairs(tiles) do
        tile.draw.destroy()
        for _, part in ipairs({ tile.label, tile.outline, tile.grip }) do
            pcall(function() part:Destroy() end)
        end
    end
    tiles = {}
    if widgets.quantity ~= nil then
        widgets.quantity.destroy()
    end
    widgets = {}
    if window ~= nil then
        pcall(function() window:Destroy() end)
        window, content = nil, nil
    end
end

local function build()
    local offered = Packs.offered()
    local rows = math.max(1, (#offered + COLUMNS - 1) // COLUMNS)
    local height = TOP + math.max(DETAIL_H, rows * ROW_H)
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Shop", WIDTH, height + Kit.titleBarHeight(), function() Shop.hide() end,
        0.3, 0.12)

    widgets.credits = Kit.text(content, 0, 0, 260, 22, "", WHITE, ui.AlignMode.TOPLEFT)
    if Packs.typeById(selected) == nil then
        selected = "standard"
    end
    for index, packType in ipairs(offered) do
        addTile(packType, index - 1)
    end
    if #offered > COLUMNS * 4 then
        Logger.error("shop: " .. #offered .. " packs, but the grid shows " .. COLUMNS * 4)
    end

    local y = TOP + PACK_H + 6
    widgets.name = Kit.text(content, DETAIL_X, y, DETAIL_W, 22, "", GOLD)
    widgets.info = {}
    for i = 1, 3 do
        widgets.info[i] = Kit.text(content, DETAIL_X, y + 24 + (i - 1) * 20, DETAIL_W, 20, "", GREY)
    end
    y = y + 24 + 3 * 20 + 8
    widgets.price = Kit.text(content, DETAIL_X, y, DETAIL_W, 22, "", WHITE)
    Kit.text(content, DETAIL_X, y + 28, 80, 26, "Quantity", GREY, ui.AlignMode.TOPLEFT)
    widgets.total = Kit.text(content, DETAIL_X, y + 62, DETAIL_W, 22, "", WHITE)
    widgets.buy = Kit.buttonAt(content, "Buy 1 pack", DETAIL_X, y + 90, DETAIL_W, 34, buy, "positive")
    widgets.hint = Kit.text(content, DETAIL_X, y + 128, DETAIL_W, 20, "", GOLD)
    showSelected()

    -- The drop-down is made last so its list opens on top of the rest.
    local entries = {}
    for _, count in ipairs(Packs.QUANTITIES) do
        entries[#entries + 1] = { label = count .. (count == 1 and " pack" or " packs"), value = count }
    end
    widgets.quantity = Kit.dropdown(content, DETAIL_X + 90, y + 28, 140, 26, entries, quantity, function(count)
        quantity = count
        Shop.refresh()
    end)
    Shop.refresh()
end

-- Opens the Shop, or closes it if it is open. `newApi` is described at the top.
function Shop.toggle(newApi)
    if window ~= nil then
        Shop.hide()
        return
    end
    api = newApi
    local ok, err = pcall(build)
    if not ok then
        Logger.error("shop: could not be built:", tostring(err))
        Shop.hide()
    end
end

return Shop
