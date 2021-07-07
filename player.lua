function initPlayer(player)
    player.infiniteAmmoActive = false
    player.godmode = false
    player.menus = 0
    player.menu_open = false
    player.weaponTimer = false
    player.wallHack = false

    local deathListener = player:onnotify("death", 
        function() 
            player.weaponTimer = false
    end);
end