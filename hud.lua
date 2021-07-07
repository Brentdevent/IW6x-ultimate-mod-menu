require("overflow")

function drawtext(player, type, font, fontscale, x, y, alignx, aligny, horzalign, vertalign, color, alpha, text)
    local elem = game:newclienthudelem(player)
    elem.elemType = type
    elem.font = font
    elem.fontscale = fontscale
    elem.x = x
    elem.y = y
    elem.alignx = alignx
    elem.aligny = aligny
    elem.horzalign = horzalign
    elem.vertalign = vertalign
    elem.color = color
    elem.alpha = alpha
    elem:settext(text)
    elem.hidewheninmenu = true

    return elem
end

function drawbox(player, type, x, y, alignx, aligny, horzalign, vertalign, color, alpha, material, matwidth, matlength)
    local elem = game:newclienthudelem(player)
    elem.elemType = type
    elem.x = x
    elem.y = y
    elem.alignx = alignx
    elem.aligny = aligny
    elem.horzalign = horzalign
    elem.vertalign = vertalign
    elem.color = color
    elem.alpha = alpha
    elem:setshader(material, matwidth, matlength)
    elem.hidewheninmenu = true

    return elem
end

function drawMaterial(player, x, y)
    local elem = game:newclienthudelem(player)
    elem.elemType = "icon"
    elem.x = x
    elem.y = y
    elem.alignx = "center"
    elem.aligny = "middle"
    elem.horzalign = "center"
    elem.vertalign = "middle"
    --elem.color = vector:new(1.0, 1.0, 1.0)
    elem.alpha = 1
    elem:setshader("white", 25, 25)

    return elem
end

function drawHelpInfo(player)
    local textElems = {}
    local options = {"Press [{vote yes}] to navigate up", 
                     "Press [{vote no}] to navigate down", 
                     "Press [{+activate}] to select option",
                     "Press [{+actionslot 1}] to open/close menu"}
    local box = drawbox(player, "icon", -150, 125, "right", "middle", "center", "middle", background_color, background_alpha, "white", 200, 100)
    
    for option = 1, #options do
        textElems[option] = drawtext(player, "font", "default", 1, -340, 100 + (18 * (option - 1)), "left", "middle", "center", "middle", not_selected_color, 1, options[option])
    end

    local destroyHelp = player:onnotifyonce("destroy_menu", function()
        
        for _, elem in pairs(textElems) do
            elem:destroy()
        end
        
        box:destroy()
    end)
end