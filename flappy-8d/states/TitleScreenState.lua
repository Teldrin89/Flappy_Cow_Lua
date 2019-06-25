--[[
    Title Screen State

    Created for the title screen portion of the game handling the startup display,
    "Press Enter to play" message and high score.
]]

-- class creation with BaseState inheritance
TitleScreenState = Class {__includes = BaseState}

-- update function with keyboard pressed functions to start the game
function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or
     love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

-- render function - showing the title screen messages
function TitleScreenState:render()
    -- set font
    love.graphics.setFont(flappyFont)
    -- print game title
    love.graphics.printf('Flappy Cow', 0, 64, VIRTUAL_WIDTH, 'center')
    -- change font
    love.graphics.setFont(mediumFont)
    -- prompt the start of the game message
    love.graphics.printf('Press Enter to start', 0, 100, VIRTUAL_WIDTH, 'center')
end
