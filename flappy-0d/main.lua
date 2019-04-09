--[[
    second game develped in lua with GD50 course using love2d framework
    this time the game will be using the external sprites (instead of the
    single shapes drawn in lua)
]] 

-- New take on the FLAPPY BIRD game

--                      Game 0 updated - load first sprites to the game

-- setup the game window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[
    the function to be used to load image files from disk is graphics.newImage(path) that will then load a selected image, place it using the "x" and "y" coordinates and allow to use it as an object
]]

--[[ 
    use the external push library to apply the virtual resolution allowing for
    more retro look of the game
]]

-- add push library
push = require 'push'
-- setup the virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--[[ 
    background and ground will be scrolling throught the game time with 2 different rates - it's called parallax scrolling
]]

-- define localy used variables for the background and ground images
local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground_night.png')

-- load function - runs 1st in running of the game
function love.load()
    -- adjust the graphics setting filters for better pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- set the window name
    love.window.setTitle('Flappy Cow')
    -- setup the virtual resolution with push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

end

-- setup the resize function using the push resize method
function love.resize(w,h)
    push:resize(w,h)
end

-- define function for definition of user input (keys)
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- love render function
function love.draw()
    -- start the push rendering
    push:start()
    --[[
        use love.graphics.draw and take the background and ground local variables established before (which has to images) at set coordinates
    ]]
    love.graphics.draw(background, 0, 0)
    -- draw ground image at the bottom - the size of the ground image
    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 32)
    -- end push rendering
    push:finish()
end
