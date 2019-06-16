-- class file for Cow class defined - use capital letters (for convenience)
Moon = Class{}
-- init function for Cow class - initializes the object
function Moon:init()
    -- set image for the cow class
    self.image = love.graphics.newImage('moon.png')
    -- set the size of class image with the loaded image size
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    -- position the cow in the middle of the screen
    self.x = 0.05*VIRTUAL_WIDTH - (self.width/2)
    self.y = 0.08*VIRTUAL_HEIGHT - (self.height/2)
end

-- add a render function
function Moon:render()
    -- draw the cow image at "x" and "y" coordinates
    love.graphics.draw(self.image, self.x, self.y)
end
