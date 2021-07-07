function infiniteAmmo(player)
    if player.infiniteAmmoActive == 1 then
        player:notify("endInfiniteAmmo")
        player.infiniteAmmoActive = false
        player:iprintlnbold("Infinite Ammo ^1Disabled")
        return
    end

    local timer = game:oninterval(function ()
        local weapon = player:getcurrentweapon()
        player:givestartammo(weapon)
        player:givemaxammo(weapon)
        player.infiniteAmmoActive = true
    end, 50)

    player:iprintlnbold("Infinite Ammo ^2Enabled")

    timer:endon(player, "disconnect")
    timer:endon(player, "endInfiniteAmmo")
end

function godmode(player)
    if player.godmode == 1 then
        player:notify("endGodmode")
        player.godmode = false
        player:iprintlnbold("Godmode ^1Disabled")
        player.maxhealth = 100
        return
    end

    player:setperk( "specialty_falldamage", false );

    local timer = game:oninterval(function ()
        player.maxhealth = 10000 
        player.health = player.maxhealth
    end, 500)
 
    player.godmode = true
    player:iprintlnbold("Godmode ^2Enabled")

    timer:endon(player, "disconnect")
    timer:endon(player, "endGodmode")
end

function toggleHighJumping(player)
    if game:getdvarint("jump_height") > 39 then
        game:setdvar("jump_height", 39)
        player:iprintlnbold("High Jump ^1Disabled")
    else
        game:setdvar("jump_height", 999)
        player:iprintlnbold("High Jump ^2Enabled")
    end
end

function giveWeapon(player, weaponName)
    player:giveweapon(weaponName)
    player:switchtoweapon(weaponName)
    player:givemaxammo(weaponName)

    if player.weaponTimer == 1 then
        return
    end

    local timer = game:oninterval(function ()
        player:setmovespeedscale(1) --Some weapons disable movement -> this fixes it
    end, 300)

    player.weaponTimer = true

    timer:endon(player, "disconnect")
    timer:endon(player, "death")
end

function maxCash(player)
    local amount = player:getcoopplayerdata("alienSession", "currency")
    player:setcoopplayerdata("alienSession", "currency", (amount + 6000))
end

function maxSkillPoints(player)
    local amount = player:getcoopplayerdata("alienSession", "skill_points")
    player:setcoopplayerdata("alienSession", "skill_points", (amount + 50))
end

function wallhack(player)
    if player.wallHack == 1 then
        player:thermalvisionfofoverlayoff()
        player.wallHack = false
        player:iprintlnbold("Wallhack ^Disabled")
    else
        player:thermalvisionfofoverlayon()
        player.wallHack = true
        player:iprintlnbold("Wallhack ^2Enabled")
    end
end