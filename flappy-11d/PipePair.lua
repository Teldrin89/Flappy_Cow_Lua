-- class file for pipe pair
PipePair = Class{}

-- size of the gap variable definition - 90px (arbitrary value)
local GAP_HEIGHT = 90
-- TODO: think on varied gap height

-- init function for pipe pairs
function PipePair:init(y)
    -- set up the pipes over the right side of the screen
    self.x = VIRTUAL_WIDTH + 32
    -- take the "y" value from main.lua and use it for the top pipe
    self.y = y
    -- itiate 2 pipe objects, using the previously created pipe class
    self.pipes = {
        --[[
            both upper and lower pipe use the updated Pipe.lua class that now
            take argument of the pipe location
        ]]
        ['upper'] = Pipe('top', self.y),
        -- the lower pipe is shifted by the pipe height and gap
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    --[[
        if the pipe is ready to be removed from the sceen set remove atribute
        is set to "true"
    ]]
    self.remove = false

    -- additional variable to determine if score shall be increased
    self.scored = false
end

-- update function for pair of pipes
function PipePair:update(dt)
    --[[
        logic for the decision if pipe pair can be removed from the screen (if 
        it is over the left edge of the screen)
    ]]
    if self.x > -PIPE_WIDTH then
        -- update the self.x position with speed and time
        self.x = self.x - PIPE_SCROLL * dt
        -- use the calculated self.x and apply to both lower and upper pipes
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        -- set the remove atribute to true if pipes are over the left side
        self.remove = true
    end
end

-- render function for pipe pair
function PipePair:render()
    -- use the same loop for all pipes in pipe pairs
    for k, pipe in pairs(self.pipes) do
        -- use the render function of pipe class
        pipe:render()
    end
end
