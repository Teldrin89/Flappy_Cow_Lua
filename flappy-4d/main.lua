--[[
    second game develped in lua with GD50 course using love2d framework
    this time the game will be using the external sprites (instead of the
    single shapes drawn in lua)
]] 

-- New take on the FLAPPY BIRD game

--                      Game 4 updated - the counteranti-gravity update

-- setup the game window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- add push library
push = require 'push'
-- add class library
Class = require 'class'
-- add Bird class file
require 'Cow'
-- add Moon class file
require 'Moon'
-- setup the virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288
--[[
    to counter act on the gravity that has been already taken into account there
    need to be some jump velocity applied but at the same time later gravity
    still should be applied as well to the cow model 
]]
-- define localy used variables for the background and ground images
local background = love.graphics.newImage('background_night_no_moon.png')
-- define the variable to track the scroll of images
local backgroundScroll = 0
local ground = love.graphics.newImage('ground_night.png')
local groundScroll = 0
--[[ 
    define the values of speed for both ground and background - one shall be 
    faster than the other to create the ilussion of moving also to avoid ending
    of each of the images both of them will be looped with
    looping points
]]
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
-- set a looping point for both images
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 559
-- create a local variable for cow
local cow = Cow()
local moon = Moon()

--[[
    to make the main file as compact and organised as possiblle it's a good
    practice to shift some of the functions and properties of elements of
    the game to the elemnt class - in this case the input handling will be
    delegated to the cow class
]]

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

    -- add the empty table of keypressed to the load function
    love.keyboard.keysPressed = {}
end

-- setup the resize function using the push resize method
function love.resize(w,h)
    push:resize(w,h)
end

-- define function for definition of user input (keys)
function love.keypressed(key)
    -- keep track of the pressed keys
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

--[[
    additional function that will test if any key as pressed during last 
    frame update - can help in order to avoid for example the love.keypressed
    function to be overlaped in some other class sepcific files
]]
function love.keyboard.wasPressed(key)
    --[[
        return true if a key was pressed and false if not (checking a table 
        established in load)
    ]] 
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- love update function
function love.update(dt)
    -- apply the speed of image scrolling with dt
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    --[[ 
        "%" defines the modulo operation that will prevent from sudden cuts in 
        image scrolling
    ]]
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT
    --[[
        to simulate gravity in 2D game apply an ever increasing speed to the cow
        object (as in real life it also has acceleration)
        this will be done with update function of cow class
    ]]
    -- run update function in cow class
    cow:update(dt)
    -- reset the keyPressed table
    love.keyboard.keysPressed = {}
end

-- love render function
function love.draw()
    -- start the push rendering
    push:start()
    -- update the draw function with scroll position that will be updated
    love.graphics.draw(background, -backgroundScroll, 0)
    -- draw ground image at the bottom - the size of the ground image
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 32)
    -- draw the cow using the class function
    cow:render()
    -- draw the moon on the background sky
    moon:render()
    -- end push rendering
    push:finish()
end
