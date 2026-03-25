if getgenv().DaraHubExecuted then
    game:GetService("Players").LocalPlayer.PlayerGui.Menu.Messages.Use:Fire("Script Is Already Loaded, rejoin if you want to re-execute", "Error")
    return
end
getgenv().DaraHubExecuted = true

local ButtonLib = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Button-lib.lua"))()
WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

Window = WindUI:CreateWindow({
    NewElements = true,
    Title = "EmoteMacro",
    Icon = "",
    Author = "",
    Folder = "Macro",
    Size = UDim2.fromOffset(400, 300),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = true,
    SideBarWidth = 150,
    OpenButton = {
        Enabled = false,
        Scale = 0
    },
})

-- Create tabs
Tabs = {}
Tabs.Main = Window:Tab({ Title = "Main", Icon = "home" })

-- ============= EMOTE MACRO WITH UNCROUCH =============
Tabs.Main:Section({Title="Emote Crouch", TextSize=20})
Tabs.Main:Divider()

local p = game:GetService("Players").LocalPlayer
local emoteData = {}
local uncrouchEnabled = true

function scanEmotes()
    for i=1,8 do
        local attr = p:GetAttribute("Emote"..i)
        emoteData[i] = {Slot=i, Name=attr or ""}
    end
end

scanEmotes()

local dropdownOptions = {}
for i=1,8 do
    if emoteData[i].Name ~= "" then
        table.insert(dropdownOptions, "Slot"..i.." "..emoteData[i].Name)
    end
end

local selectedValues = {}

local dropdown = Tabs.Main:Dropdown({
    Title = "Select Emote Slot(s)",
    Options = dropdownOptions,
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedValues = values
    end
})

function updateDropdown()
    scanEmotes()
    dropdownOptions = {}
    for i=1,8 do
        if emoteData[i].Name ~= "" then
            table.insert(dropdownOptions, "Slot"..i.." "..emoteData[i].Name)
        end
    end
    dropdown:Refresh(dropdownOptions, true)
end

function monitorAttributes()
    while true do
        task.wait(0.5)
        for i=1,8 do
            local attr = p:GetAttribute("Emote"..i)
            if attr ~= emoteData[i].Name then
                updateDropdown()
                break
            end
        end
    end
end

task.spawn(monitorAttributes)

function triggerRandomEmote()
    pcall(function()
        game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire("Crouch", true)
    end)
    task.wait(0.1)
    
    local validSlots = {}
    if #selectedValues > 0 then
        for _, slotText in pairs(selectedValues) do
            local slotNum = tonumber(string.match(slotText, "Slot(%d+)"))
            if slotNum and emoteData[slotNum] and emoteData[slotNum].Name ~= "" then
                table.insert(validSlots, tostring(slotNum))
            end
        end
    else
        for i=1,8 do
            if emoteData[i] and emoteData[i].Name ~= "" then
                table.insert(validSlots, tostring(i))
            end
        end
    end
    
    if #validSlots > 0 then
        local randomSlot = validSlots[math.random(1, #validSlots)]
        pcall(function()
            game:GetService("ReplicatedStorage").Events.Emote:FireServer(randomSlot)
        end)
    end
end

function uncrouch()
    if uncrouchEnabled then
        p.PlayerScripts.Events.KeybindUsed:Fire("Crouch", false)
    end
end

ButtonLib.Create:Button({
    Text = "Emote Crouch",
    Flag = "EmoteCrouch",
    Visible = false,
    Callback = function()
        triggerRandomEmote()
    end
}).Position = UDim2.new(0.5, -125, 0.2, 0)

EmoteCrouchToggle = Tabs.Main:Toggle({
    Title = "Emote Crouch",
    Flag = "EmoteCrouchToggle",
    Desc = "Select emote slot(s) or leave empty for random",
    Value = false,
    Callback = function(state)
        EmoteCrouchEnabled = state
        if _G.DarahubLibBtn and _G.DarahubLibBtn.EmoteCrouch then
            _G.DarahubLibBtn.EmoteCrouch.Visible = state
        end
    end
})

ShowUncrouchButtonToggle = Tabs.Main:Toggle({
    Title = "Show Uncrouch Button",
    Flag = "ShowUncrouchButton",
    Value = false,
    Callback = function(state)
        if _G.DarahubLibBtn and _G.DarahubLibBtn.UncrouchButton then
            _G.DarahubLibBtn.UncrouchButton.Visible = state
        end
    end
})

ButtonLib.Create:Button({
    Text = "Uncrouch",
    Flag = "UncrouchButton",
    Visible = false,
    Callback = function()
        uncrouch()
    end
}).Position = UDim2.new(0.5, -125, 0.45, 0)

-- ============= KEYBINDS =============
Tabs.Main:Space()
Tabs.Main:Section({Title="Keybinds", TextSize=20})
Tabs.Main:Divider()

Tabs.Main:Keybind({
    Flag = "EmoteCrouchKeybind",
    Title = "Trigger Random Emote",
    Desc = "Keybind to trigger random emote with crouch",
    Value = "J",
    Callback = function()
        if EmoteCrouchEnabled then
            triggerRandomEmote()
        end
    end
})

Tabs.Main:Space()

UncrouchKeybind = Tabs.Main:Keybind({
    Title = "Uncrouch Keybind",
    Desc = "Press to uncrouch",
    Value = "",
    Flag = "UncrouchKeybind",
    Callback = function()
        uncrouch()
    end
})

-- ============= SHOW/HIDE UI BUTTON =============
Tabs.Main:Space()
Tabs.Main:Section({Title="UI Settings", TextSize=20})
Tabs.Main:Divider()

Tabs.Main:Toggle({
    Title = "Show Mobile UI Button",
    Flag = "ShowMobileUIButton",
    Desc = "Show button to open UI on mobile",
    Value = false,
    Callback = function(state)
        if state then
            Window:SetOpenButton({ Enabled = true, Scale = 1 })
        else
            Window:SetOpenButton({ Enabled = false, Scale = 0 })
        end
    end
})

Tabs.Main:Space()

Tabs.Main:Keybind({
    Flag = "WinKeybind",
    Title = "UI Keybind",
    Desc = "Keybind to open UI",
    Value = "RightControl",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})

WindUI:Notify({
    Title = "Evade Legacy",
    Content = "Emote Macro loaded! Select emote slots and enable Emote Crouch",
    Duration = 4
})
