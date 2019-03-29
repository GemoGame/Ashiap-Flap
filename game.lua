local composer = require( "composer" )
local widget = require('widget')
local physics = require('physics')
local scene = composer.newScene()
composer.recycleOnSceneChange = true
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
physics.start()
physics.setGravity(0,10)
local atta, score
local callBird = require("bird").new
local Score = require("score").new
local onScore = require("score").onGetScore
local GameOver = require("gameover").new
local go
local scoreSound
local hitSound
local dieSound
local floor ={
     type = "image",
     filename = "sprites/ground.png"
 }
 
local background = {
    type ="image",
    filename="sprites/background_day_backup.png"
}


-- variables
local halfW = display.contentWidth / 2
local halfH = display.contentHeight / 2
local defaultPlayerYOffset = 30
local walkingSpeed = 2500
local pipeYRandomness = 50
local pipeMinDistance = 50
local pipeSpawnDelay = 1500
playing = true

local ground
local groundloop
local spawnTimer
--
-- Groups
local decoration_group = display.newGroup() 
local pipes_group = display.newGroup()
local grounds_group = display.newGroup()
local ui_group = display.newGroup()
local player_group = display.newGroup()
local group
--
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    group = self.view

    local rect = display.newRect(display.contentCenterX,display.contentCenterY,display.contentWidth,display.contentHeight)
    rect:setFillColor(1,1,1)
    rect.fill = background
    decoration_group:insert(rect)

    atta = callBird({x=40,y=100})
    player_group:insert(atta)

    score = Score({x = halfW + 5, y = 15})
    ui_group:insert(score)

    scoreSound = audio.loadSound("sounds/ashiap_200.wav")
    hitSound = audio.loadSound ("sounds/ashiap_050.wav")
    dieSound = audio.loadSound("sounds/ashiap_050.wav")
    -- Ground
    ground = display.newImageRect("sprites/ground.png", 480, 120)
    groundloop = display.newImageRect("sprites/ground.png", 480, 120)
    ground.anchorX, ground.anchorY = 0, 0
    groundloop.anchorX, groundloop.anchorY = 0, 0
    ground.x, ground.y = 0, display.contentHeight - ground.height
    groundloop.x, groundloop.y = ground.width, display.contentHeight - ground.height 

    ground.name, groundloop.name = "ground"

    physics.addBody(ground, "static", { bounce = 0, friction = 1 })
    physics.addBody(groundloop, "static", { bounce = 0, friction = 1 })

    grounds_group:insert(ground)
    grounds_group:insert(groundloop)

    group:insert(decoration_group)
    group:insert(grounds_group)
    group:insert(player_group)

    function groundLoop()
        if not playing then
            return
        end
        if ground.x <= -ground.width+display.contentCenterX then
            ground.x = 0
            groundloop.x = ground.width
        end
        transition.to(ground, {
            time = walkingSpeed,
            x = -ground.width,
            onComplete = groundLoop
        })
        transition.to(groundloop, {
            time = walkingSpeed,
            x = 0
        })
    end
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    function createPipe()
        if not playing then
            return
        end
    
    
        local pipe_top = display.newImageRect("sprites/pipe_green_top.png", 26, 320)
        local pipe_bottom = display.newImageRect("sprites/pipe_green_bottom.png", 26, 320)
        local pipe_trigger = display.newRect(0, 0, 5, pipeMinDistance)
        local rand = math.random(-pipeYRandomness, pipeYRandomness)
    
        pipe_top.anchorY = 1
        pipe_bottom.anchorY = 0
        pipe_trigger.anchorY = 1
    
        physics.addBody(pipe_top, "static", { bounce = 0, friction = 0 })
        physics.addBody(pipe_bottom, "static", { bounce = 0, friction = 0 })
        physics.addBody(pipe_trigger, "static", { bounce = 0, friction = 0 })
    
        pipe_top.x = display.contentWidth + pipe_top.width / 2
        pipe_bottom.x = display.contentWidth + pipe_top.width / 2
        pipe_top.y = (pipe_top.height / 2) + rand
        pipe_bottom.y = pipe_top.y + pipeMinDistance
        pipe_trigger.x = display.contentWidth + pipe_top.width / 2
        pipe_trigger.y = pipe_top.y + pipeMinDistance
    
        pipe_trigger:setFillColor(0, 0, 0, 0)
        pipe_trigger.name = "score_collider"
        pipe_trigger.isSensor = true
    
        pipes_group:insert(pipe_top)
        pipes_group:insert(pipe_bottom)
        pipes_group:insert(pipe_trigger)
        group:insert(pipes_group)
    
        grounds_group:toFront()
        player_group:toFront()
        ui_group:toFront()
    
        transition.to(pipe_top, {
            time = walkingSpeed + 160,
            x = -(pipe_top.width / 2),
            onComplete = function()
                if not playing then return end
                pipe_top:removeSelf()
            end
        })
    
        transition.to(pipe_bottom, {
            time = walkingSpeed + 160,
            x = -(pipe_bottom.width / 2),
            onComplete = function()
                if not playing then return end
                pipe_bottom:removeSelf()
            end
        })
    
        transition.to(pipe_trigger, {
            time = walkingSpeed + 175,
            x = -(pipe_top.width / 2)
        })
    
    end

    function die()
        atta.bodyType = "static"
        playing = false;
        transition.cancel()
        go = GameOver({score=score:getScore()})
        ui_group:insert(go)
        ui_group:toFront()
        score:removeSelf()
        
    end

    function onPipeCollision(self, event)
        if event.other.name == 'score_collider' then
            event.other:removeSelf()
            audio.play(scoreSound)
            score:add(1)
            

            return
        end
        if playing then
            if event.other.name ~= 'ground' then
                audio.play(hitSound)
            else
                audio.play(dieSound)
            end
            --transition.to(atta,{time =0, x = 100, y = 0})
            die()
        
        end
    end
    -- Touch listener
    function onTouchEvent(event)
        if not playing then 
            return
        end
        if event.phase == "began" then
            atta:tap()
        end 
    end
    
    
    -- Bird Rotation
    function birdRotationListener(event)
        if not playing then
            return
        end
        local vx, vy = atta:getLinearVelocity()
        local maxRotation = 80
        local rotationSpeed = 0.025
        if vy <= 0 then
            atta.rotation = atta.rotation + (rotationSpeed * 20) * (-15 - atta.rotation)
        else
            atta.rotation = atta.rotation + rotationSpeed * (maxRotation - atta.rotation)
        end

    end
end       

 
 
-- show()
function scene:show( event )
 
    group  = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        atta:toFront()
        atta.collision = onPipeCollision
        atta:addEventListener('collision')
        grounds_group:toFront()
        
        Runtime:addEventListener("touch", onTouchEvent)
        Runtime:addEventListener("enterFrame", birdRotationListener)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        groundLoop()
        atta:tap()
        spawnTimer = timer.performWithDelay(pipeSpawnDelay, createPipe, 0)
        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    group = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    group = self.view
    -- Code here runs prior to the removal of scene's view
    Runtime:removeEventListener("touch", onTouchEvent)
    Runtime:removeEventListener("enterFrame", birdRotationListener)
    timer.cancel(spawnTimer)
 
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