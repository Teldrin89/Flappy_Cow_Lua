--[[
    Play State Class

    This state is the core of the game, where the actual game is happening - 
    pipes appear on the screen, the gravity is applied to the contolable cow and
    the game stops when both collide. If that happens the game should go back to
    main menu.
]]

-- Play State class creation with BaseState inheritance
PlayState = Class{__includes=BaseState}

-- moved most of the functions from main to Play State class

-- set dimensions to pipes and cow

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

COW_WIDTH = 38
COW_HEIGHT = 24

-- init function for the play state
function PlayState:init()
    -- set the cow object with cow class
    self.cow = Cow()
    -- set pair of pipes object
    self.pipePairs = {}
    -- set initial timer
    self.timer = 0

    -- init last recorded "Y" value for a gap placement to base other pipe pair
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

-- update function
function PlayState:update(dt)
    -- update time - used for pipe pair spwaning
    self.timer = self.timer + dt

    -- spawn new pipe pair if timer has less than 2 seconds
    if self.timer > 2 then
        --[[
            modify the "lastY" coordinate so pipe don't spawn to far and is not
            higher than 10px below the edgeof the screen and no lower than a gap
            length (90px) from the bottom
        ]]
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20,20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        
            -- set lastY with new y value
        self.lastY = y

        -- reset timer
        self.timer = 0
    end
    
    -- loop for every pair of pipes
    for k, pair in pairs(self.pipePairs) do
        -- update position of the pipe pair
        pair:update(dt)
    end

    --[[
        similar as before a second loop is required for removal of the pipe pairs
        because modifying the table in-place without explicit keys would result in
        skip of every next pipe, since all implicit keys (numerical indicies) are
        automatically shifted down after a table removal
    ]]

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- update cow based on gravity and input (jump)
    self.cow:update(dt)

    -- simple AABB collision btween cow and all pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                -- change the state to title state in case of collision
                gStateMachine:change('title')
            end
        end
    end

    -- additional check if cow collides with the ground
    if self.cow.y > VIRTUAL_HEIGHT - 15 then
        -- also change to title state if cow falls to the ground
        gStateMachine:change('title')
    end
end




