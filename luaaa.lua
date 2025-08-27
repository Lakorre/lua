 -- ========== الإعدادات العامة ==========
local MenuSize = vec2(800, 400) -- كبرنا العرض عشان نضيف قسم جديد
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 0
local SectionsCount = 4 -- زدنا عدد الأقسام
local SectionsPadding = 10
local MachoPaneGap = 10
local showPlayerIDsESX = false
local showPlayerIDsVRP = false

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- مواقع الأقسام
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionFourStart = vec2(TabsBarWidth + (SectionsPadding * 4) + (EachSectionWidth * 3), SectionsPadding + MachoPaneGap)
local SectionFourEnd = vec2(SectionFourStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ========== إنشاء القائمة ==========
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)



-- ✅ القسم الأول: ESX Actions
local FirstSection = MachoMenuGroup(MenuWindow, "ESX Actions", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

MachoMenuButton(FirstSection, "Revive Yourself", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoMenuNotification("ESX", "You have been revived!")
end)

MachoMenuButton(FirstSection, "Handcuff Player", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX", "Handcuff triggered!")
end)

MachoMenuButton(FirstSection, "UnJail Player", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX", "Player released from jail!")
end)

MachoMenuButton(FirstSection, "Copy Outfit & Face", function()
    local closestPlayer, distance = GetNearestPlayer()
    if closestPlayer ~= -1 and distance < 3.0 then
        local targetPed = GetPlayerPed(closestPlayer)
        local targetModel = GetEntityModel(targetPed)
        RequestModel(targetModel)
        while not HasModelLoaded(targetModel) do
            Wait(0)
        end
        SetPlayerModel(PlayerId(), targetModel)
        SetModelAsNoLongerNeeded(targetModel)
        Wait(200)
        ClonePedToTarget(targetPed, PlayerPedId())
        MachoMenuNotification("Success", "Outfit & Face copied successfully!")
    else
        MachoMenuNotification("Error", "No player nearby!")
    end
end)

MachoMenuButton(FirstSection, "Give Pump Shotgun", function()
    local playerPed = GetPlayerPed(-1)
    GiveWeaponToPed(playerPed, GetHashKey('weapon_pumpshotgun'), 100, false, true)
    MachoMenuNotification("Weapon", "You received a Pump Shotgun!")
end)

MachoMenuCheckbox(FirstSection, "Show Player IDs (ESX)",
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- ✅ القسم الأول: ESX Actions
local FirstSection = MachoMenuGroup(MenuWindow, "ESX Actions", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

MachoMenuButton(FirstSection, "Revive Yourself", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoMenuNotification("ESX", "You have been revived!")
end)

MachoMenuButton(FirstSection, "Handcuff Player", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX", "Handcuff triggered!")
end)

MachoMenuButton(FirstSection, "UnJail Player", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX", "Player released from jail!")
end)

MachoMenuButton(FirstSection, "Copy Outfit & Face", function()
    local closestPlayer, distance = GetNearestPlayer()
    if closestPlayer ~= -1 and distance < 3.0 then
        local targetPed = GetPlayerPed(closestPlayer)
        local targetModel = GetEntityModel(targetPed)
        RequestModel(targetModel)
        while not HasModelLoaded(targetModel) do
            Wait(0)
        end
        SetPlayerModel(PlayerId(), targetModel)
        SetModelAsNoLongerNeeded(targetModel)
        Wait(200)
        ClonePedToTarget(targetPed, PlayerPedId())
        MachoMenuNotification("Success", "Outfit & Face copied successfully!")
    else
        MachoMenuNotification("Error", "No player nearby!")
    end
end)

MachoMenuButton(FirstSection, "Give Pump Shotgun", function()
    local playerPed = GetPlayerPed(-1)
    GiveWeaponToPed(playerPed, GetHashKey('weapon_pumpshotgun'), 100, false, true)
    MachoMenuNotification("Weapon", "You received a Pump Shotgun!")
end)

MachoMenuCheckbox(FirstSection, "Show Player IDs (ESX)",
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- ✅ القسم الرابع: vRP Actions
local FourthSection = MachoMenuGroup(MenuWindow, "vRP Actions", SectionFourStart.x, SectionFourStart.y, SectionFourEnd.x, SectionFourEnd.y)

MachoMenuButton(FourthSection, "Revive Yourself", function()
    SetEntityHealth(PlayerPedId(-1), 200)
    MachoMenuNotification("vRP", "You have been revived!")
end)

MachoMenuButton(FourthSection, "Teleport to Waypoint", function()
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
        MachoMenuNotification("vRP", "Teleported to waypoint!")
    else
        MachoMenuNotification("Error", "No waypoint set!")
    end
end)

MachoMenuButton(FourthSection, "Give Pump Shotgun", function()
    local playerPed = GetPlayerPed(-1)
    GiveWeaponToPed(playerPed, GetHashKey('weapon_pumpshotgun'), 100, false, true)
    MachoMenuNotification("vRP", "You received a Pump Shotgun!")
end)

MachoMenuCheckbox(FourthSection, "Show Player IDs (vRP)",
    function() showPlayerIDsVRP = true end,
    function() showPlayerIDsVRP = false end
)

-- ✅ دالة جلب أقرب لاعب
function GetNearestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = GetDistanceBetweenCoords(playerCoords, targetCoords, true)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

-- ✅ دالة رسم النصوص فوق اللاعبين
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(x, y, z))
    local scale = math.max(0.35 - (distance / 300), 0.30)

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- ✅ ثريد عرض معرفات اللاعبين (لكل من ESX و vRP)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDsESX or showPlayerIDsVRP then
            for _, playerId in ipairs(GetActivePlayers()) do
                if playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    if ped and DoesEntityExist(ped) then
                        local headCoords = GetPedBoneCoords(ped, 0x796e, 0.0, 0.0, 0.55)
                        local name = GetPlayerName(playerId)
                        local serverId = GetPlayerServerId(playerId)
                        DrawText3D(headCoords.x, headCoords.y, headCoords.z + 0.3, string.format("%s | ID: %d", name, serverId))
                    end
                end
            end
        end
    end
end)





