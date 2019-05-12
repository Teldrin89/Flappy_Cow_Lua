-- class file for Pipe class defined - use capital letters (for convenience)
Pipe = Class{}
--[[
    define local variable for a single copy of pipe picture (object) - this
    way it is a sort of "global" object and is loaded once, then can be
    referenced as many times as needed instead of loading it for each pipe on
    the screen - hence do it before init function
]] 
local PIPE_IMAGE = love.graphics.newImage('pipe_yellow.png')
-- add a value for pipe scrolling - arbitrary, updated sign, made global
PIPE_SCROLL = 60
-- set the global values of pipe height and width
PIPE_HEIGHT = 288
PIPE_WIDTH = 70
--[[
    init function for Pipe class - initializes the object, now takes 2
    parameters: the orientation (top, bottom) and "y" value
]]
function Pipe:init(orientation, y)
    -- set the pipe over the right edge
    self.x = VIRTUAL_WIDTH
    -- set the pipe at "y" height (passed parameter)
    self.y = y
    -- set width as a width of a pipe
    self.width = PIPE_IMAGE:getWidth()
    -- set height as the pre-defined value
    self.height = PIPE_HEIGHT
    -- set the orientation of the pipe based on passed parameter
    self.orientation = orientation
end

-- update function has been covered in pair of pipes class
function Pipe:update(dt)

end

-- set up the rendering of pipe object
function Pipe:render()
    --[[
        the draw function is now used with additional parameters that handle
        the rotation (not used) and scale (that will allow to mirror the pipe)
    ]]
    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, -- rotation parameter 
        1, -- X scale (mirror)
        self.orientation == 'top' and -1 or 1) -- Y scale
end
