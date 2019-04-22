-- class file for Cow class defined - use capital letters (for convenience)
Cow = Class{}
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
end

-- add a render function
function Cow:render()
    -- draw the cow image at "x" and "y" coordinates
    love.graphics.draw(self.image, self.x, self.y)
end
