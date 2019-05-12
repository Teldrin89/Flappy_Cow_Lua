-- class file for Pipe class defined - use capital letters (for convenience)
Pipe = Class{}
--[[
    define local variable for a single copy of pipe picture (object) - this
    way it is a sort of "global" object and is loaded once, then can be
    referenced as many times as needed instead of loading it for each pipe on
    the screen - hence do it before init function
]] 
local PIPE_IMAGE = love.graphics.newImage('pipe_yellow.png')
-- add a value for pipe scrolling - arbitrary - with "-" to shift left
local PIPE_SCROLL = -60
-- init function for Pipe class - initializes the object
function Pipe:init()
    -- set the pipe over the right edge
    self.x = VIRTUAL_WIDTH
    -- set the pipe at random heights of the bottom side
    self.y = math.random(VIRTUAL_HEIGHT/3.35, VIRTUAL_HEIGHT - 65)
    -- set width as a width of a pipe
    self.width = PIPE_IMAGE:getWidth()
end

-- set up the update function for pipe
function Pipe:update(dt)
    -- setup the update of pipe position by adding the scrolling speed*dt
    self.x = self.x + PIPE_SCROLL*dt
end

-- set up the rendering of pipe object
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end
