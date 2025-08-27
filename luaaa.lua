local MenuSize = vec2(600, 350)
local MenuStartCoords = vec2(500, 500) 

local TabsBarWidth = 0 -- The width of the tabs bar, height is assumed to be MenuHeight as it goes top to bottom

local SectionChildWidth = MenuSize.x - TabsBarWidth -- The total size for sections on the left hand side
local SectionsCount = 3 
local SectionsPadding = 10 -- pixels between each section (that makes SetionCount + 1 = total padding areas)
local MachoPaneGap = 10 -- Hard coded gap of accent at the top.

-- Therefore each section width must be:
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount


-- Now you have each sections absolute width, you can calculate their X coordinate and Y coordinate
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Create our window, MenuStartCoords is where the menu starts
MenuWindow = MachoMenuWindow(MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y)

MachoMenuSetAccent(MenuWindow, 137, 52, 235)


-- First tab
FirstSection = MachoMenuGroup(MenuWindow, "Section One", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuButton(FirstSection, "Close", function()
    MachoMenuDestroy(MenuWindow)
  end)

-- Second tab
SecondSection = MachoMenuGroup(MenuWindow, "Section Two", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

MenuSliderHandle = MachoMenuSlider(SecondSection, "Slider", 10, 0, 100, "%", 0, function(Value)
    print("Slider updated with value ".. Value)
end)

MachoMenuCheckbox(SecondSection, "Checkbox", 
    function()
        print("Enabled")
    end,
    function()
        print("Disabled")
    end
)

TextHandle = MachoMenuText(SecondSection, "SomeText")

MachoMenuButton(SecondSection, "Change Text Example", function()
    MachoMenuSetText(TextHandle, "ChangedText")
  end)


-- Third tab
ThirdSection = MachoMenuGroup(MenuWindow, "Section Three", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

InputBoxHandle = MachoMenuInputbox(ThirdSection, "Input", "...")
MachoMenuButton(ThirdSection, "Print Input", function()
    local LocatedText = MachoMenuGetInputbox(InputBoxHandle)
    print(LocatedText)
  end)

DropDownHandle = MachoMenuDropDown(ThirdSection, "Drop Down", 
    function(Index)
        print("New Value is " .. Index)
    end, 
    "Selectable 1",
    "Selectable 2",
    "Selectable 3"
)
