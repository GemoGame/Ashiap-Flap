local widget = require("widget")
local composer = require("composer")


_M = {}

    local ui_group = display.newGroup()
    local Loselbl
    local Scorelbl
    local quitBtn
    local score
function _M.new(params)
    
        
         
        score = params.score
        score = tostring(score)

        Loselbl = display.newText("Game Over",160,280,native.systemFont,32)
        ui_group:insert(Loselbl)

        Scorelbl = display.newText("Score : " .. score,160,360,native.systemFont,32)
        ui_group:insert(Scorelbl)

        quitBtn = widget.newButton({
            width = 100,
            height = 30,
            defaultFile = "sprites/button_menu.png",
            overFile = "sprites/button_menu.png",
            onEvent = function(event)
                if(event.phase == 'ended') then
                    Loselbl:removeSelf()
                    quitBtn:removeSelf()
                    Scorelbl:removeSelf()
                    composer.gotoScene('menu', {
                        effect = "fromBottom",
                        time = 1000 })
                    
                end
            end
        })
        
        quitBtn.x = 160
        quitBtn.y = 320
        ui_group:insert(quitBtn)
        return ui_group

end

return _M

