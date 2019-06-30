--[[
    Countdown State Class

    Puts on the screen countdown before play state, going 3, 2, 1 to allow player
    some time after hitting enter to prompt the game
]]

-- Countdown State class creation
-- inherit the Base State class
CountdownState = Class {__includes = BaseState}

-- create a variable for time between each of the 3, 2 and 1 - set to 0.8s
COUNTDOWN_TIME = 0.8

-- init function for Countdown State
function CountdownState:init()
    -- set the count value
    self.count = 3
    -- init timer with 0
    self.timer = 0
end

-- update function for Countdown State class
function CountdownState:update(dt)
    -- update timer vriable with time passed
    self.timer = self.timer + dt
    -- if the timer is bigger than the set value of countdown
    if self.timer > COUNTDOWN_TIME then
        -- round the time back to loop it back to 0
        self.timer = self.timer % COUNTDOWN_TIME
        -- reduce the count by 1
        self.count = self.count - 1
        -- if the count get's down all the way to 0
        if self.count == 0 then
            -- change state to play
            gStateMachine:change('play')
        end
    end
end

-- render function of Countdown State
function CountdownState:render()
    -- change for to the biggest one
    love.graphics.setFont(hugeFont)
    -- render the countdown in the middle of the screen
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
