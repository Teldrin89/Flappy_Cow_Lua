-- class file for Cow class defined - use capital letters (for convenience)
Cow = Class{}
-- additional constant deffinitions for cow class
-- gravity value set to 20, is completely arbitrary value (found with tuning)
local GRAVITY = 20
-- set jump value to 5 (arbitrary value) - changed to 4 for adjustment
local JUMP = 4
-- init function for Cow class - initializes the object
function Cow:init()
    -- set image for the cow class
    self.image = love.graphics.newImage('cow.png')
    -- set the size of class image with the loaded image size
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    -- position the cow in the middle of the screen
    self.x = VIRTUAL_WIDTH/2 - (self.width/2)
    self.y = VIRTUAL_HEIGHT/2 - (self.height/2)
    -- init the "y" velocity of a cow
    self.dy = 0
end
--[[
    adding the AABB collision detection function that is then referenced in main
    file, takes pipe as parameter
]]
function Cow:collides(pipe)
    --[[
        to add make the game less "punishing" for players there are 2 offset
        values added in both Y and X direction (2 and 4)
    ]]
    if (self.x + 2) + (self.width - 4) >= pipe.x and 
    self.x + 2 <=pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and 
        self.y + 2 <= pipe.y + PIPE_HEIGHT then
            -- if the collision is detected function returns true
            return true
        end
    end
    -- if no collision the return false
    return false
end

-- add an update function - refered to in main.lua
function Cow:update(dt)
    -- apply gravity as a velocity increas in "y" direction
    self.dy = self.dy + GRAVITY*dt
    -- update the "y" position of  cow with calculated speed
    self.y = self.y + self.dy
    --[[
        using the table with keyspressed from main.lua use the space bar key
        pressed check to apply the velocity to the cow unit in y direction that
        will counter the gravity
    ]]
    if love.keyboard.wasPressed('space') then
        -- applying the jump as a velocity for the cow sprite in opposite dir.
        self.dy = -JUMP
        -- add sound efect to jump
        sounds['jump']:play()
    end

end

-- add a render function
function Cow:render()
    -- draw the cow image at "x" and "y" coordinates
    love.graphics.draw(self.image, self.x, self.y)
end
