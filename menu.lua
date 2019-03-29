local composer = require( "composer" )
 
local scene = composer.newScene()

 
local widget = require "widget"
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
local background = {
    type ="image",
    filename="sprites/background_day_backup.png"
}
local icon ={
    type ="image",
    filename ="sprites/flappy_bird_icon.png"
}



local function toGame()
    composer.gotoScene("game","crossFade",1000)
    return true
end
local text = "Ashiap Flap"
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    composer.recycleOnSceneChange = true
    local rect = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
    rect:setFillColor(1,1,1)
    rect.fill = background
    sceneGroup:insert(rect)

    local menuIcon = display.newRect(40,40,150,150)
    menuIcon.fill=icon
    menuIcon.rotation = -30;
    sceneGroup:insert(menuIcon)
    
    local title = display.newText(text,160,160,native.systemFont,48)
    title:setFillColor(1,0,0)
    sceneGroup:insert(title)
    local playBtn= widget.newButton{
        width = 200,
        height = 60,
        defaultFile ="sprites/button_play_normal.png",
        onRelease = toGame
    }
    playBtn.x = 160
    playBtn.y = 280
    sceneGroup:insert(playBtn) 
    
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
       
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene