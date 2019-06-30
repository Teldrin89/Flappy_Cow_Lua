--[[
    Base State Class

    Created and used as the base state class for all other states classes with
    initial and required in states methods - with inheritance option next they
    only have to be created once.
]]

-- Base State class creation
BaseState = Class{}

-- init and other functions, all just empty templates
function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update() end
function BaseState:render() end
