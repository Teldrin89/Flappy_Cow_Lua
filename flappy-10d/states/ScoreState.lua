--[[
    Score State Class

    This state is the score state that will pop up once the player lost, it will
    put some additional text, the score value and on pressing enter will bring 
    player back to title screen state
]]

-- Play State class creation with BaseState inheritance
ScoreState = Class{__includes=BaseState}

-- enter function with passed parameter - score
function ScoreState:enter(params)
    self.score = params.score
end

-- update function
function ScoreState:update(dt)
    -- if enter is pressed go back to play state
    if love.keyboard.wasPressed('enter') or 
    love.keyboard.wasPressed('return') then
        -- updated to change state to countdown instead of play
        gStateMachine:change('countdown')
    end
end

-- render function
function ScoreState:render()
    -- render the score on end of the game screen with flappy font
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Ups! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 
    'center')
end
