-- ui/shopwindow.lua
-- The Shop: every pack on offer as a small picture in a grid, the chosen one large beside it with its price, a
-- drop-down for how many to buy and the Buy button. Buying takes the credits, rolls the cards and saves
-- (core/packs.lua), then hands the cards to the reveal (api.startReveal). The grid pictures are flat
-- (PackArt.drawTile); only the large pack is drawn in full (hundreds of parts, PackArt.drawFront) and again each time
-- another is chosen. Set by Shop.toggle(newApi): api.getState(), api.saveNow(), api.busy() (a reveal is still
-- showing) and api.startReveal(results, packTypeId).

local Cards = require("core/cards")
local Format = require("core/format")
local Logger = require("core/logger")
local Packs = require("core/packs")
local PackArt = require("ui/packart")
local Kit = require("ui/kit")
local ShopLayout = require("ui/shoplayout")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD, PANEL_BACK, PANEL_BORDER = Theme.WHITE, Theme.GREY, Theme.GOLD, Theme.PANEL_BACK, Theme.PANEL_BORDER
local Util = require("ui/util")
local setText = Util.setText

local Shop = {}


local COLUMNS = 4
local TILE_H = 144                                  -- a tile is as wide as the pack's outline, TILE_W
local TILE_W = math.floor(TILE_H * PackArt.OUTLINE.w / PackArt.OUTLINE.h)
local MARGIN = 10                                    -- what is in the window keeps this from all four edges of its content
local LEFT = MARGIN                                  -- room between the window's edge and the first tile
local GAP_X = 28
local LABEL_H = 20                                  -- the pack's name under its tile
local ROW_H = TILE_H + LABEL_H + 26
local GRID_W = LEFT + COLUMNS * TILE_W + (COLUMNS - 1) * GAP_X + 4     -- 4: a tile's shadow
local TOP = MARGIN
local HEADING_H = 34                                 -- the "Packs" heading over the tiles
local HEADING_NUDGE = 0                             -- (the heading is level with the top of the panel)
local GRID_TOP = TOP + HEADING_H + 8
local BOTTOM = MARGIN                                -- room under the panel, above the window's frame
-- The tiles are in a scrolling container (PrettyUI's SimpleView) from GRID_TOP down to the bottom of the right-hand panel, so
-- the window is as tall as the panel however many packs there are. It is GRID_W wide plus its scroll bar (16 and a gap of 2),
-- which only shows when the packs are taller than the container.
local SCROLL_W = 18
local CONTAINER_W = GRID_W + SCROLL_W
local WHEEL_STEP = 32                                -- what one notch of the wheel scrolls, as for the container's own
-- Inside the container: a section's title (the pack titles' lettering at a smaller size, left-justified over the first column),
-- the divider between the sections, and the spaces round them (see ui/shoplayout.lua).
local SECTION_TITLE_H = 20
local SECTION_TITLE_GAP = 12
local DIVIDER_GAP = 14
local GRID_PAD_TOP = 6                               -- (a tile's gold outline sticks out 4 above it)
local GRID_PAD_BOTTOM = 10
-- The right-hand panel (the chosen pack and the buying controls) has a background and border of its own.
local PANEL_X, PANEL_PAD, DETAIL_W = CONTAINER_W + 16, 16, 250
local PANEL_W = DETAIL_W + 2 * PANEL_PAD
local DETAIL_X = PANEL_X + PANEL_PAD
local PACK_H = 340                                  -- the large pack (the tiles are 144)
local PACK_TOP = TOP + PANEL_PAD
local NAME_Y = PACK_TOP + PACK_H + 10
local PRICE_Y = NAME_Y + 24 + 3 * 20 + 8
local PANEL_H = PRICE_Y + 148 + PANEL_PAD - TOP     -- the hint line is the last thing in it
-- The window's content is its width less the frame (8 at each side), and what is in it starts LEFT from the left, so the same
-- is left at the right: the gaps at both sides are equal.
local WIDTH = PANEL_X + PANEL_W + LEFT + 2 * 8

local TILE_SHADOW = Vector4.new(0.0, 0.0, 0.0, 0.55)
local TILE_BORDER = PANEL_BORDER

local api = nil
local window, content = nil, nil
local widgets = {}
local tiles = {}                  -- pack type id -> { draw, outline }
local decor = {}                  -- the section titles and dividers in the grid
local grid = nil                  -- the scrolling container the tiles are in (a PrettyUI SimpleView) while the window is open
local bigPack = nil               -- the large pack: { root, w, destroy() }
local selected = "standard"       -- the pack type chosen (kept while the plugin runs)
local quantity = 1                -- how many packs to buy (kept while the plugin runs)

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
    elseif filter.regions == Cards.NO_TAG then
        lines[2] = "Only cards that are considered global"
    elseif filter.regions ~= nil then
        lines[2] = "Only cards from " .. shortName(packType)
    elseif filter.membership == "f2p" then
        lines[2] = "Only free-to-play cards"
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
        pack.root:SetPos(DETAIL_X + (DETAIL_W - pack.w) // 2, PACK_TOP)
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

-- Scrolls the grid by `delta` notches of the wheel (above 0 is down). The tiles' click areas take the wheel, so they hand it on.
local function scrollGrid(delta)
    if grid ~= nil and type(delta) == "number" and delta ~= 0 then
        pcall(function() grid:ScrollBy(delta * WHEEL_STEP) end)
    end
end

-- One pack's picture, name and click area, at x, y in `parent` (the scrolling grid).
local function addTile(parent, packType, x, y)
    local tile = {}
    -- A shadow, the picture, a thin brown border round it, and (when chosen) a gold outline outside that.
    tile.shadow = ui.Rectangle.new(parent)
    tile.shadow:SetPos(x + 4, y + 4)
    tile.shadow:SetSize(TILE_W, TILE_H)
    tile.shadow.fill = true
    tile.shadow.colour = TILE_SHADOW
    tile.draw = PackArt.drawTile(parent, packType.id, TILE_H)
    tile.draw.root:SetPos(x, y)
    tile.border = ui.Rectangle.new(parent)
    tile.border:SetPos(x - 1, y - 1)
    tile.border:SetSize(TILE_W + 2, TILE_H + 2)
    tile.border.fill = false
    tile.border.outlineThickness = 1
    tile.border.colour = TILE_BORDER
    tile.label = Kit.text(parent, x - GAP_X // 2, y + TILE_H + 6, TILE_W + GAP_X, LABEL_H, shortName(packType), GREY)
    tile.outline = ui.Rectangle.new(parent)
    tile.outline:SetPos(x - 4, y - 4)
    tile.outline:SetSize(TILE_W + 8, TILE_H + 8)
    tile.outline.fill = false
    tile.outline.outlineThickness = 2
    tile.outline.colour = GOLD
    tile.outline.hidden = true
    -- The click area is a layer of its own on top, the way the credits bar takes its clicks.
    tile.grip = ui.Layer.new(parent)
    tile.grip:SetPos(x, y)
    tile.grip:SetSize(TILE_W, TILE_H)
    tile.grip.clickthrough = false
    tile.grip:Subscribe(ui.Hook.ONCLICK, function() choose(packType.id) end)
    Kit.onWheel(tile.grip, scrollGrid)
    tiles[packType.id] = tile
end

-- A title in the pack titles' gold lettering (an image drawn by dev/make_pack_art.py, as text can't be scaled), `h` high, at
-- x, y in `parent`; with `centred` x is its middle instead of its left edge. Plain gold text if the image is missing.
local function addTitle(parent, titleId, text, h, x, y, centred)
    local title = PackArt.titleById(titleId)
    local image = title ~= nil and PackArt.image("title_" .. titleId) or nil
    if image ~= nil then
        local w = math.floor(title.w * h / title.h + 0.5)
        local sprite = ui.Sprite.new(parent)
        sprite.sprite = image
        sprite:SetPos(centred and x - w // 2 or x, y)
        sprite:SetSize(w, h)
        return sprite
    end
    if centred then
        return Kit.text(parent, x - 100, y, 200, h, text, GOLD)
    end
    return Kit.text(parent, x, y, 200, h, text, GOLD, ui.AlignMode.TOPLEFT)
end

-- What the two sections of the grid are called.
local SECTION_TITLES = { general = "General", regions = "Regions" }

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

-- Brings the window up to date with the character's credits and the choices. Called every tick; only changes what is
-- different.
function Shop.refresh()
    if window == nil or widgets.buy == nil then
        return
    end
    local state = api ~= nil and api.getState() or nil
    local price = Packs.priceFor(selected) or 0
    local total = price * quantity
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

-- The component of one of the Shop's controls, for the tutorial's pointer: "buy". nil if the Shop is not open.
function Shop.anchor(name)
    local control = window ~= nil and name == "buy" and widgets.buy or nil
    if control == nil then
        return nil
    end
    return control.root or control
end

function Shop.hide()
    if bigPack ~= nil then
        bigPack.destroy()
        bigPack = nil
    end
    if widgets.heading ~= nil then
        pcall(function() widgets.heading:Destroy() end)
    end
    for _, tile in pairs(tiles) do
        tile.draw.destroy()
        for _, part in ipairs({ tile.shadow, tile.border, tile.label, tile.outline, tile.grip }) do
            pcall(function() part:Destroy() end)
        end
    end
    tiles = {}
    for _, part in ipairs(decor) do
        pcall(function() part:Destroy() end)
    end
    decor = {}
    if grid ~= nil then
        pcall(function() grid:Destroy() end)
        grid = nil
    end
    if widgets.quantity ~= nil then
        widgets.quantity.destroy()
    end
    widgets = {}
    if window ~= nil then
        pcall(function() window:Destroy() end)
        window, content = nil, nil
    end
end

-- Where the tiles, section titles and dividers go in the grid (ui/shoplayout.lua).
local function gridLayout(offered)
    return ShopLayout.place(offered, {
        columns = COLUMNS, tileW = TILE_W, gapX = GAP_X, left = LEFT, top = GRID_PAD_TOP,
        titleH = SECTION_TITLE_H, titleGap = SECTION_TITLE_GAP, rowH = ROW_H, lastRowH = TILE_H + LABEL_H + 6,
        dividerGap = DIVIDER_GAP, bottom = GRID_PAD_BOTTOM,
    })
end

local function build()
    local offered = Packs.offered()
    local layout = gridLayout(offered)
    -- The tiles scroll in a container as tall as the right-hand panel, so the window is as tall as the panel.
    local height = TOP + PANEL_H + BOTTOM
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Shop", WIDTH, height + Kit.titleBarHeight(), function() Shop.hide() end,
        0.3, 0.12)

    if Packs.typeById(selected) == nil then
        selected = "standard"
    end
    -- The heading, centred over the tiles.
    local gridMiddle = (LEFT + GRID_W - 4) // 2
    widgets.heading = addTitle(content, "packs", "Packs", HEADING_H, gridMiddle, TOP + HEADING_NUDGE, true)

    -- The scrolling grid: from under the heading to the bottom of the panel. `parent` is where the tiles go, and `originY`
    -- where its top is in it.
    grid = prettyui.SimpleView.new(content, {
        x = 0, y = GRID_TOP, width = CONTAINER_W, height = TOP + PANEL_H - GRID_TOP,
        contentHeight = layout.height, scrollable = true, scrollStep = WHEEL_STEP, categoryID = "auto",
    })
    local parent, originY = grid.content, 0
    for _, heading in ipairs(layout.headings) do
        decor[#decor + 1] = addTitle(parent, heading.id, SECTION_TITLES[heading.id] or heading.id, SECTION_TITLE_H,
            heading.x, originY + heading.y, false)
    end
    for _, y in ipairs(layout.dividers) do
        local line = ui.Rectangle.new(parent)
        line:SetPos(LEFT, originY + y)
        line:SetSize(layout.width, 1)
        line.fill = true
        line.colour = TILE_BORDER
        decor[#decor + 1] = line
    end
    for index, packType in ipairs(offered) do
        local at = layout.tiles[index]
        addTile(parent, packType, at.x, originY + at.y)
    end

    -- The panel behind the chosen pack and the buying controls: made after the tiles and before what goes on it.
    local back = ui.Rectangle.new(content)
    back:SetPos(PANEL_X, TOP)
    back:SetSize(PANEL_W, PANEL_H)
    back.fill = true
    back.colour = PANEL_BACK
    local border = ui.Rectangle.new(content)
    border:SetPos(PANEL_X, TOP)
    border:SetSize(PANEL_W, PANEL_H)
    border.fill = false
    border.outlineThickness = 1
    border.colour = PANEL_BORDER

    widgets.name = Kit.text(content, DETAIL_X, NAME_Y, DETAIL_W, 22, "", GOLD)
    widgets.info = {}
    for i = 1, 3 do
        widgets.info[i] = Kit.text(content, DETAIL_X, NAME_Y + 24 + (i - 1) * 20, DETAIL_W, 20, "", GREY)
    end
    local y = PRICE_Y
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
