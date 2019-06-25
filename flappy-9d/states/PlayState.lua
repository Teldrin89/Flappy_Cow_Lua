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

-- set dimensions to pipes and cow - the same as dimensions of sprites

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

    -- add keeping track of score, init with 0
    self.score = 0

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

        -- add a new pipe pair at the end of the screen at new "Y"
        table.insert(self.pipePairs, PipePair(y))
        
        -- reset timer
        self.timer = 0
    end
    
    -- loop for every pair of pipes
    for k, pair in pairs(self.pipePairs) do
        --[[
            condition check and score update - if the pipe has gone past the cow
            to the left all the way, be sure to ignore it once the point has been
            given
        ]]
        -- check the pair scored condition -> continue if false
        if not pair.scored then
            -- check if cow passed the pipe pair width
            if pair.x + PIPE_WIDTH < self.cow.x then
                -- increment the score
                self.score = self.score + 1
                -- change scored condition to true to avoid extra points
                pair.scored = true
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
            if self.cow:collides(pipe) then
                -- change the state to score state in case of collision
                gStateMachine:change('score', {
                    -- pass the score value
                    score = self.score
                })
            end
        end
    end

    -- additional check if cow collides with the ground
    if self.cow.y > VIRTUAL_HEIGHT - 15 then
        -- also change to score state if cow falls to the ground
        gStateMachine:change('score', {
            -- pass the score value
            score = self.score
        })
    end
end

-- render function
function PlayState:render()
    -- render pipe pairs
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- set the score font and printout the score value in top right corner
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    -- render the cow
    self.cow:render()
end
