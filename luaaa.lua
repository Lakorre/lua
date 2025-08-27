-- ====== الإعدادات العامة ======
local showPlayerIDsESX = false
local showSelfID = false -- خيار جديد لإظهار نفسك أو لا

-- ====== حجم القائمة وموقعها ======
local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500)

local TabsBarWidth = 0
local SectionsCount = 3
local SectionsPadding = 10
local MachoPaneGap = 10

local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- إحداثيات الأقسام
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- إنشاء النافذة
local MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)
MachoMenuSetAccent(MenuWindow, 137, 52, 235)

-- ====== القسم الأول (أوامر ESX) ======
local FirstSection = MachoMenuGroup(MenuWindow, "EsSX Actions", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuButton(FirstSection, "Revive Yourself", function()
    TriggerEvent('esx_ambulancejob:revive')
    MachoMenuNotification("ESX", "You have been revived!")
end)

MachoMenuButton(FirstSection, "Handcuff Player", function()
    TriggerEvent('esx_misc:handcuff')
    MachoMenuNotification("ESX", "Handcuff triggered!")
end)

MachoMenuButton(FirstSection, "Grant txAdmin Permissions", function()
    local playerId = PlayerId()
    local perms = {"all_permissions"}
    TriggerEvent('txcl:setAdmin', GetPlayerName(playerId), perms)
    TriggerEvent('txAdmin:events:adminAuth', {
        netid = playerId,
        isAdmin = true,
        username = GetPlayerName(playerId),
    })
    MachoMenuNotification("ESX", "txAdmin permissions granted!")
end)

MachoMenuButton(FirstSection, "UnJail Player", function()
    TriggerEvent("esx_jail:unJailPlayer")
    MachoMenuNotification("ESX", "Player released from jail!")
end)

-- Checkbox لإظهار معرفات اللاعبين
MachoMenuCheckbox(FirstSection, "Show Player IDs",
    function() showPlayerIDsESX = true end,
    function() showPlayerIDsESX = false end
)

-- Checkbox لإظهار نفسك
MachoMenuCheckbox(FirstSection, "Show My ID",
    function() showSelfID = true end,
    function() showSelfID = false end
)

-- زر إغلاق
MachoMenuButton(FirstSection, "Close Menu", function()
    MachoMenuDestroy(MenuWindow)
end)

-- ====== القسم الثاني (Slider و Checkbox) ======
local SecondSection = MachoMenuGroup(MenuWindow, "Controls", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

local MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Example Checkbox",
    function() print("Enabled") end,
    function() print("Disabled") end
)

local TextHandle = MachoMenuText(SecondSection, "SomeText")

MachoMenuButton(SecondSection, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
end)

-- ====== القسم الثالث (Input و Dropdown) ======
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

-- ====== دالة لعرض النص ثلاثي الأبعاد مع خلفية ======
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local distance = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(x, y, z))
    local scale = math.max(0.35 - (distance / 300), 0.30)

    if onScreen then
        -- إعدادات النص
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextOutline()
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)

        -- خلفية للنص
        local width = (string.len(text)) / 350
        DrawRect(_x, _y + 0.0125, width, 0.03, 0, 0, 0, 150)
    end
end

-- ====== خيط لعرض معرفات اللاعبين فوق الرأس ======
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) -- تحسين الأداء

        if showPlayerIDsESX then
            for _, playerId in ipairs(GetActivePlayers()) do
                if showSelfID or playerId ~= PlayerId() then
                    local ped = GetPlayerPed(playerId)
                    if ped and DoesEntityExist(ped) then
                        -- إحداثيات الرأس
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

