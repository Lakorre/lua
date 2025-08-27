-- ========== الإعدادات العامة ==========
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10
local showPlayerIDsESX = false

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- ========== إنشاء القائمة ==========
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- ✅ القسم الأول: ESX Actions
local FirstSection = MachoMenuGroup(MenuWindow, "ESX Actions", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

-- زر إغلاق
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
end)

-- Revive نفسك
MachoMenuButton(FirstSection, "Revive Yourself", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoMenuNotification("ESX", "You have been revived!")
end)

-- فك القيود
MachoMenuButton(FirstSection, "Handcuff Player", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX", "Handcuff triggered!")
end)

-- فك السجن
MachoMenuButton(FirstSection, "UnJail Player", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX", "Player released from jail!")
end)

-- زر: نسخ الملابس مع الملامح
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

-- زر: إعطاء Pump Shotgun
MachoMenuButton(FirstSection, "Give Pump Shotgun", function()
    local playerPed = GetPlayerPed(-1)
    GiveWeaponToPed(playerPed, GetHashKey('weapon_pumpshotgun'), 100, false, true)
    MachoMenuNotification("Weapon", "You received a Pump Shotgun!")
end)

-- ✅ خيار: إظهار معرفات اللاعبين
MachoMenuCheckbox(FirstSection, "Show Player IDs", 
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- ✅ القسم الثاني: التحكم
local SecondSection = MachoMenuGroup(MenuWindow, "Controls", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

local MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Example Checkbox",
    function() print("Enabled") end,
    function() print("Disabled") end
)

-- ✅ القسم الثالث: الإدخال
local ThirdSection = MachoMenuGroup(MenuWindow, "Inputs", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

local InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

local DropDownHandle = MachoMenuDropDown(ThirdSection, "Drop Down", 
    function(Index)
        print("New Value is " .. Index)
    end, 
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
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

-- ✅ ثريد عرض معرفات اللاعبين
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if showPlayerIDsESX then
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
