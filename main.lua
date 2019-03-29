-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setDefault('magTextureFilter', 'nearest')
display.setDefault('minTextureFilter', 'nearest')

local composer = require("composer")

--display.setStatusBar(display.HiddenStatusBar)
composer.recycleOnSceneChange = true
composer.gotoScene("menu")
-- Your code here