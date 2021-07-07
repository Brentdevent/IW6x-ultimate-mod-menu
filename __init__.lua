require("hud")
require("functions")
require("player")

-- Customize color, alpha, and title. (Color uses RGB values divided by 255 iirc)
selected_color        = vector:new(0.2, 0.2, 0.7) -- blue
not_selected_color    = vector:new(1.0, 1.0, 1.0) -- white
background_color      = vector:new(0.0, 0.0, 0.0) -- black
background_alpha      = 0.3;                      -- 30/100% transparent
outline_box_color     = vector:new(0.0, 0.0, 0.0) -- blueish purple
menu_text_color       = vector:new(0.2, 0.2, 0.7) -- blue
menu_title            = "IW6x Ultimate Menu"

main_menu_options = {"Main mods", "Fun weapons"}

function player_connected(player)
    player:notifyonplayercommand("toggle_menu", "+actionslot 1")
    player:onnotify("spawned_player", function() player_spawned(player) end)
    initPlayer(player)

    player:onnotify("toggle_menu", function()
        if player.menus == 1 then
            player:notify("close_menu")
            return
        elseif player.menu_open == 1 then
            return
        end

        -- setup main menu function
        main_menu(player)
        player.menus = player.menus + 1
        player.menu_open = true
        drawHelpInfo(player) -- There is probably a better way to draw the help info
                             -- but yea couldn't care less.¯\_(ツ)_/¯
    end)
end

function main_menu(player)
    new_menu(player, main_menu_options,
    {
        function() 
            mainModsMenu(player)
            player.menus = player.menus + 1
            drawHelpInfo(player)
        end,
        function()
            weaponMenu(player)
            player.menus = player.menus + 1
            drawHelpInfo(player)
        end,
        function() 
            killstreakMenu(player) 
            player.menus = player.menus + 1
            drawHelpInfo(player)
        end,
        -- add more here
    }, function() 
        player:notify("destroy_menu")
        player.menus = player.menus - 1
        player.menu_open = false
    end)
end

function player_spawned(player) 
    player:freezecontrols(false)
    drawHelpInfo(player)
end

function new_menu(player, options, actions, backaction)
    player:notify("destroy_menu")

    -- setup controls & notifies
    player:notifyonplayercommand("scroll_up", "vote yes")
    player:notifyonplayercommand("scroll_down", "vote no")
    player:notifyonplayercommand("do_option", "+activate")

    -- draw boxes
    local boxes = {}
    boxes[1] = drawbox(player, "icon", 200, -20, "center", "middle", "center", "middle", background_color, background_alpha, "white", 200, 330) -- background box
    boxes[2] = drawbox(player, "icon", 200, -180, "center", "middle", "center", "middle", outline_box_color, 1, "white", 200, 10) -- top box
    boxes[3] = drawbox(player, "icon", 200, 149, "center", "middle", "center", "middle", outline_box_color, 1, "white", 200, 10) -- bottom box 

    -- menu array & menu title at top
    local menu = {}
    local title = drawtext(player, "font", "default", 1.7, 200, -200, "center", "middle", "center", "middle", menu_text_color, 1, menu_title)

    local text_index = 1

    -- draw every option
    for option = 1, #options do
        if option > 10 then
            break
        end
        menu[option] = drawtext(player, "font", "default", 1.5, 200, -150 + (30 * (option - 1)), "center", "middle", "center", "middle", not_selected_color, 1, options[option])
    end
    menu[1].color = selected_color

    local scroll_up = player:onnotify("scroll_up", function()
        menu[text_index].color = not_selected_color
        text_index = ((text_index - 2) % #options) + 1;
        menu[text_index].color = selected_color
        end
    )

    local scroll_down = player:onnotify("scroll_down", function()
        menu[text_index].color = not_selected_color
        text_index = (text_index % #options) + 1;
        menu[text_index].color = selected_color
        end
    )

    local do_option = player:onnotify("do_option", function() actions[text_index]() end)
    local close_menu = player:onnotify("toggle_menu", function() backaction() end)
    local destroymenu = player:onnotifyonce("destroy_menu", function()
        for elem = 1, #menu do
            menu[elem]:reset()
            menu[elem]:destroy()
        end

        for elem = 1, #boxes do
            boxes[elem]:reset()
            boxes[elem]:destroy()
        end

        title:clearalltextafterhudelem()
        title:destroy()
    end)

    scroll_up:endon(player, "destroy_menu")
    scroll_down:endon(player, "destroy_menu")
    do_option:endon(player, "destroy_menu")
    close_menu:endon(player, "destroy_menu")
end


function mainModsMenu(player)
    if(game:getdvar("g_gametype") == "aliens") then
        new_menu(player, {"Infinite Ammo", "Demi Godmode", "Add Cash", "Add Skillpoints", "High Jumping", "Wallhack", "Remove all weapons"}, {
            function() infiniteAmmo(player) end,
            function() godmode(player) end,
            function() maxCash(player) end,
            function() maxSkillPoints(player) end,
            function() toggleHighJumping(player) end,
            function() wallhack(player) end,
            function() player:takeallweapons() end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
            drawHelpInfo(player)
        end)
    else
        new_menu(player, {"Infinite Ammo", "Demi Godmode", "Wallhack", "High Jumping", "Remove all weapons"}, {
            function() infiniteAmmo(player) end,
            function() godmode(player) end,
            function() wallhack(player) end,
            function() toggleHighJumping(player) end,
            function() player:takeallweapons() end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
            drawHelpInfo(player)
        end)
    end
end

function weaponMenu(player)
    if(game:getdvar("g_gametype") == "aliens") then
        new_menu(player, {"Minigun", "Minigun upgrade", "Useless Javelin", "Tac insertion", "SOFLAM", "Default Weapon"}, {
            function() giveWeapon(player, "iw6_alienminigun_mp") end,
            function() giveWeapon(player, "iw6_alienminigun3_mp") end,
            function() giveWeapon(player, "switchblade_babyfast_mp") end,
            function() giveWeapon(player, "alienflare_mp") end,
            function() giveWeapon(player, "aliensoflam_mp") end,
            function() giveWeapon(player, "defaultweapon_mp") end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
            drawHelpInfo(player)
        end)
    else  
        new_menu(player, {"Minigun", "Magnum", "Minigun Juggernaut", "Jugg Combat Knife", "Default Weapon"}, {
            function() giveWeapon(player, "iw6_minigun_mp") end,
            function() giveWeapon(player, "iw6_magnumhorde_mp") end,
            function() giveWeapon(player, "iw6_minigunjugg_mp") end,
            function() giveWeapon(player, "iw6_knifeonlyjugg_`mamp") end,
            function() giveWeapon(player, "defaultweapon_mp") end
        }, function() 
            player.menus = player.menus - 1
            main_menu(player)
            drawHelpInfo(player)
        end)
    end
end

-- entry point
if game:getdvar("gamemode") == "mp" then
    level:onnotify("connected", player_connected)
    print("Mod menu by ^1brentdevent")
    print("Special thanks to ^1mjkzy ^7for the menubase")
end