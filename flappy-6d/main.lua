--[[
    second game develped in lua with GD50 course using love2d framework
    this time the game will be using the external sprites (instead of the
    single shapes drawn in lua)
]] 

-- New take on the FLAPPY BIRD game

--                      Game 6 updated - the pairs of pipes

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
    -- handle the increase of timer value
    spawnTimer = spawnTimer + dt
    -- check if the spawn timer is grater than set value (eg. 2) to add new pipe
    if spawnTimer > 2 then
        --[[
            introduction of additional variable "y" that will shift the gap
            between pipes that will be no higher than 10px below the top edge
            and no lower than a gap length (90)
        ]]
        local y = math.max(-PIPE_HEIGHT + 10, math.min(lastY + 
            math.random(-20,20), VIRTUAL_HEIGHT-90-PIPE_HEIGHT))
        lastY = y
        --[[
            instead of workin on individual pipes now the spawn will be for
            pair of pipes, hence use of pair of pipes table with "y" value tha
            is where the gap starts
        ]]
        table.insert(pipePairs, PipePair(y))
        -- reset the spawnTimer to 0 after adding a single pipe
        spawnTimer = 0
    end

    -- run update function in cow class
    cow:update(dt)

    -- iterate over a table with key-value pairs for updated table
    for k, pair in pairs(pipePairs) do
        -- update for each pipe - this will have the effect of scrolling
        pair:update(dt)
    end
    --[[
        a second loop for all pipe pairs that is required for removal of pipes
        because in previous loop with the update function it would result in
        skipping of every second pipe pair
    ]]
    for k, pair in pairs(pipePairs) do
        --[[ 
            remove the pipe once it will be over the left side of the screen,
            check not against 0 (as then it would remove it before it 
            completely gone trhough screen) but against it's width
        ]]
        -- shifted remove condition to a function in pair class
        if pair.remove then
            --[[
                the table.remove function to remove said pipe with the key value
                set in the loop ("k")
            ]]
            table.remove(pipePairs, k)
        end
    end
    -- reset the keyPressed table
    love.keyboard.keysPressed = {}
end

-- love render function
function love.draw()
    -- start the push rendering
    push:start()
    -- update the draw function with scroll position that will be updated
    love.graphics.draw(background, -backgroundScroll, 0)
    --[[
        to have the pipes drawn as if they are sticking out of the ground there
        has to be set a layer order - that's why they have to be drawn in this
        place: after bacground but before ground
    ]]
    -- draw the moon on the background sky - shifted back before the pipe
    moon:render()
    -- use the same iteration of key-value pair for updated table
    for k, pair in pairs(pipePairs) do
        pair:render()
    end
    -- draw ground image at the bottom - the size of the ground image
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 32)
    -- draw the cow using the class function
    cow:render()
    -- end push rendering
    push:finish()
end
