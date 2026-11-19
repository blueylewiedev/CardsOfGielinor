-- core/tutorial.lua
-- The in-game tutorial's steps and when each one is finished. Pure logic: it draws nothing and calls no windows (ui/tutorial.lua
-- does the drawing, and looks at the windows).
--
-- A step has
--   text    what the help panel says (friendly sentences, two lines at most: about 150 characters at the panel's small font; dev/check_tutorial.lua enforces it)
--   target  which control the gold pointer is over: the name of an anchor ("shop", "buy", "collection", "grid", "sets", "settings";
--           ui/tutorial.lua turns a name into a component), or nil for no pointer. A function of the observations, so a step
--           can point back at the Shop button if the player closed the Shop
--   done    whether the player has done what the step asks, from the observations; nil means the step is only left with Next
--
-- The observations are what the tutorial can see without hooking any window: { shopOpen, revealActive, collectionOpen, gridView,
-- setsOpen }, all true/false. `mem` is a table the step may keep between looks (it is new for each step, and for each time a step is shown).

local Config = require("core/config")

local Tutorial = {}

local function xpPerCredit()
    return Config.get("earning.xpPerCredit")
end

Tutorial.STEPS = {
    {
        id = "shop",
        text = function() return "Welcome! You start with enough credits to buy two packs of cards. To begin, click the \"Open the Shop\" button on the main window." end,
        target = function() return "shop" end,
        done = function(obs) return obs.shopOpen or obs.revealActive end,
    },
    {
        id = "buy",
        text = function() return "Pick a pack you like, choose how many to buy, then press the Buy button. Each type of pack draws from a different set of cards." end,
        target = function(obs) return obs.shopOpen and "buy" or "shop" end,
        done = function(obs) return obs.revealActive end,
    },
    {
        id = "reveal",
        text = function() return "Click the pack to tear it open, then click each card to turn it over. Foil and holo cards are the rarer finishes. Press Done when you are finished." end,
        target = function() return nil end,
        -- Finished when the opening has been seen and then closed. (If it was never seen, only Next leaves the step.)
        done = function(obs, mem)
            if obs.revealActive then
                mem.seen = true
            end
            return mem.seen == true and not obs.revealActive
        end,
    },
    {
        id = "collection",
        text = function() return "Now click the Collection button to see every card you own. Click any card for its details, or use the search and filters to find one." end,
        target = function() return "collection" end,
        done = function(obs) return obs.collectionOpen end,
    },
    {
        id = "grid",
        text = function() return "The swap button in the Collection window's title bar switches between the list and the grid, which shows many more cards at once." end,
        target = function(obs) return obs.collectionOpen and "grid" or "collection" end,
        done = function(obs) return obs.gridView end,
    },
    {
        id = "sets",
        text = function() return "The Sets button groups cards into themed sets, shows how far through each one you are, and tells you which packs a missing card can come from." end,
        target = function() return "sets" end,
        done = function(obs) return obs.setsOpen end,
    },
    {
        id = "earn",
        text = function()
            return string.format("You earn credits from XP in non-combat skills (1 credit for every %d XP), Slayer kills and boss kills. The cog opens settings. Enjoy collecting!",
                xpPerCredit())
        end,
        target = function() return "settings" end,
        done = nil,
    },
}

-- How many steps there are.
function Tutorial.count()
    return #Tutorial.STEPS
end

-- The words for step `index`, or "" if there is no such step.
function Tutorial.text(index)
    local step = Tutorial.STEPS[index]
    return step ~= nil and step.text() or ""
end

-- The name of the control step `index` points at given what is open, or nil for none.
function Tutorial.target(index, obs)
    local step = Tutorial.STEPS[index]
    return step ~= nil and step.target(obs) or nil
end

-- True if step `index` is finished by what the player has done (false for a step that is only left with Next).
function Tutorial.isDone(index, obs, mem)
    local step = Tutorial.STEPS[index]
    if step == nil or step.done == nil then
        return false
    end
    return step.done(obs, mem) == true
end

return Tutorial
