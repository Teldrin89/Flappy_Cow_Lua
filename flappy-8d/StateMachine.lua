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
        initiate a variable even if there is no value - states
    ]] 
    self.states = states or {}
    self.current = self.empty
end
-- change function - takse a state name and parameters
function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    -- once you want to change state, call the exit function from current state
    self.current:exit()
    -- set new current state
    self.current = self.states[stateName]()
    -- enter new state with additional enter parameters
    self.current:enter(enterParams)
end
-- update function - as it was update function in main file with "dt" input
function StateMachine:update(dt)
    -- update the current state
    self.current:update(dt)
end
-- render function - as it was previously in main
function StateMachine:render()
    -- render the current state
    self.current:render()
end
