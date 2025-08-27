-- إعداد القائمة
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- إنشاء النافذة
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- ✅ القسم الأول
local FirstSection = MachoMenuGroup(MenuWindow, "ESX Actions", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

-- زر إغلاق
MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
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

-- ✅ زر جديد: إعطاء سلاح Pump Shotgun
MachoMenuButton(FirstSection, "Give Pump Shotgun", function()
    local playerPed = GetPlayerPed(-1)
    GiveWeaponToPed(playerPed, GetHashKey('weapon_pumpshotgun'), 100, false, true)
    MachoMenuNotification("Weapon", "You received a Pump Shotgun!")
end)

-- ✅ القسم الثاني
local SecondSection = MachoMenuGroup(MenuWindow, "Controls", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)
local MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Example Checkbox",
    function() print("Enabled") end,
    function() print("Disabled") end
)

-- ✅ القسم الثالث
local ThirdSection = MachoMenuGroup(MenuWindow, "Inputs", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)
local InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
end)

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
