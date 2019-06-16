--[[
    second game develped in lua with GD50 course using love2d framework
    this time the game will be using the external sprites (instead of the
    single shapes drawn in lua)
]] 

-- New take on the FLAPPY BIRD game

--                      Game 8 updated - the game state update

--[[
    the state game update will divide the game into several states: starting on 
    the title screen state the game will proceed according to the game state 
    diagram (to the countdown state first and then to play state that then can go
    back to coundtown)
]]
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
-- add a Pipe class
require 'Pipe'
-- require a composite class - pipe pair
require 'PipePair'
-- additional module with state machine library
require 'StateMachine'
-- additional modules for each of the game states - in seperate folder
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

-- setup the virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

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
-- added local variable for moon sprite
local moon = Moon()
-- substitute local table of pipes with the one for pairs of pipes
local pipePairs = {}
-- add timer variable to determine when to spawn next pipe
local spawnTimer = 0
--[[
    add aditional variable that will keep track of the top end Y value so that
    the gap can bee similar with the next pipe pair and that will result in
    smooth transition between next pipes
]]
local lastY = -PIPE_HEIGHT + math.random(80) + 20
--[[
    in order to detect the collision there is a need for some variable that
    will be set to true as default and if there is a collision it will change
    to false
]]
local scrolling = true
-- load function - runs 1st in running of the game
function love.load()
    -- adjust the graphics setting filters for better pixel art
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- set the window name
    love.window.setTitle('Flappy Cow')
    -- initialize external tex fonts for with different formats and several sizes
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- setup the virtual resolution with push
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    --[[
        initialize game state with state-returnin function, the "g" in front of 
        some of the variables below indicates the global variable
    ]] 
    gStateMachine = StateMachine {
        --[[
            from StateMachine class use some functions based on the key-value 
            tables that will return some states
        ]] 
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
    }
    -- setting up the state with change function from StateMachine class
    gStateMachine: change('title')
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
    --[[
        update function has been exported to the game state library - the only
        part that was left in main is related to background and ground scrolling
        as it is going to be present all the time
    ]]
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    
    --[[ 
        "%" defines the modulo operation that will prevent from sudden cuts in 
        image scrolling
    ]]
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % GROUND_LOOPING_POINT
    
    -- the update part of this function is called from game state module
    gStateMachine:update(dt)

    -- reset the keyPressed table
    love.keyboard.keysPressed = {}
end

-- love render function
function love.draw()
    -- start the push rendering
    push:start()
    
    -- update the draw function with scroll position that will be updated
    love.graphics.draw(background, -backgroundScroll, 0)
    -- draw the moon on the background sky - shifted back before the pipe
    moon:render()
    -- the rendering of pipes and cow is taken care in state module
    gStateMachine:render()
    -- draw ground image at the bottom - the size of the ground image
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 32)
    
    -- end push rendering
    push:finish()
end
