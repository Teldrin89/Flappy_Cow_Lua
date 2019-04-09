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
local background = love.graphics.newImage('background_night.png')
local ground = love.graphics.newImage('ground_night.png')

