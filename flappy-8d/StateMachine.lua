--[[
    State Machine module - built to manage states of the game and apply update
    and render functions. States are only created when needed (reduce clean-up 
    bugs and saves memory). Added states have a string identifier, initialisation
    function and when called, will return table with Enter, Update, Render and 
    Exit functions.
]] -- class name definition
StateMachine = Class{}

-- init function
function StateMachine:init(states)
    -- generates empty table - for each of the function key-value table
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    --[[
        if states is set to wrong value then set to empty table - 
        function that returns states
    ]] 
    self.states = states or {}
    self.current = self.empty
end
-- change function
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end
-- update function
function StateMachine:update(dt)
    self.current:update(dt)
end
-- render function
function StateMachine:render()
    self.current:render()
end
