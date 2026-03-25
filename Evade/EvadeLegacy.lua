if getgenv().DaraHubExecuted then
    game:GetService("Players").LocalPlayer.PlayerGui.Menu.Messages.Use:Fire("Script Is Already Loaded, rejoin if you want to re-execute", "Error")
    return
end
getgenv().DaraHubExecuted = true

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

Window = WindUI:CreateWindow({
    NewElements = true,
    Title = "Evade Legacy",
    Icon = "",
    Author = "",
    Folder = "Evade-Legacy",
    Size = UDim2.fromOffset(500, 450),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 180,
    OpenButton = {
        Enabled = false,
        Scale = 0
    },
})

-- Create tabs
Tabs = {}
Tabs.Player = Window:Tab({ Title = "Player", Icon = "user" })
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "zap" })
Tabs.Main = Window:Tab({ Title = "Main", Icon = "home" })
Tabs.Settings = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ============= CORE VARIABLES =============
RealSpeed = 1500
JumpHeight = 3
AirAcceleration = 1
jumpcap = 1
SpringSpeedMultiplier = 1

autoJumpEnabled = false
bhopHoldActive = false
bhopHoldFeature = false
jumpCooldown = 0.7
autoJumpType = "Bounce"

player = game:GetService("Players").LocalPlayer
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
bhopConnection = nil
bhopLoaded = false
Character = nil
Humanoid = nil
HumanoidRootPart = nil
LastJump = 0
GROUND_CHECK_DISTANCE = 3.5
MAX_SLOPE_ANGLE = 45

movementModule = nil
originalApplyFriction = nil

function IsOnGround()
    if not Character or not HumanoidRootPart or not Humanoid then return false end
    local success, result = pcall(function()
        local rayOrigin = HumanoidRootPart.Position
        local rayDirection = Vector3.new(0, -GROUND_CHECK_DISTANCE, 0)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if not raycastResult then return false end
        local angle = math.deg(math.acos(raycastResult.Normal:Dot(Vector3.new(0, 1, 0))))
        return angle <= MAX_SLOPE_ANGLE
    end)
    return success and result
end

function updateBhop()
    if not bhopLoaded then return end
    pcall(function()
        if not Character or not Humanoid then return end
        local isBhopActive = autoJumpEnabled or bhopHoldActive
        if isBhopActive then
            local now = tick()
            if IsOnGround() and (now - LastJump) > jumpCooldown then
                if autoJumpType == "Realistic" then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    task.wait(0.1)
                else
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
                LastJump = now
            end
        end
    end)
end

function loadBhop()
    if bhopLoaded then return end
    bhopLoaded = true
    if bhopConnection then bhopConnection:Disconnect() end
    bhopConnection = RunService.Heartbeat:Connect(updateBhop)
end

function unloadBhop()
    if not bhopLoaded then return end
    bhopLoaded = false
    if bhopConnection then
        bhopConnection:Disconnect()
        bhopConnection = nil
    end
    bhopHoldActive = false
end

function checkBhopState()
    if autoJumpEnabled or bhopHoldActive then
        loadBhop()
    else
        unloadBhop()
    end
end

function setupBhopJumpBtn()
    pcall(function()
        local playerGui = player:WaitForChild("PlayerGui", 5)
        local touchGui = playerGui:WaitForChild("TouchGui", 5)
        local jumpButton = touchGui:FindFirstChild("JumpButton", true)
        if not jumpButton then return end
        jumpButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if bhopHoldFeature then
                    bhopHoldActive = true
                    checkBhopState()
                end
            end
        end)
        jumpButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                bhopHoldActive = false
                checkBhopState()
            end
        end)
    end)
end

function getCurrentSpeed()
    if HumanoidRootPart then
        return (HumanoidRootPart.Velocity * Vector3.new(1, 0, 1)).Magnitude
    end
    return 0
end

function setupCharacter(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid", 5)
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

    local movement = character:FindFirstChild("Movement")
    if movement and movement:IsA("ModuleScript") then
        local movementModule = require(movement)

        local originalUpdate = movementModule.Update
        movementModule.Update = function(self, dt)
            local originalSpeed = self.j
            self.j = RealSpeed * SpringSpeedMultiplier

            local originalAirMove = self.AirMove
            self.AirMove = function(airSelf, ...)
                local originalAccelerate = airSelf.Accelerate
                airSelf.Accelerate = function(accSelf, direction, targetSpeed, acceleration)
                    targetSpeed = targetSpeed * AirAcceleration
                    return originalAccelerate(accSelf, direction, targetSpeed, acceleration)
                end
                originalAirMove(airSelf, ...)
                airSelf.Accelerate = originalAccelerate
            end

            originalUpdate(self, dt)
            self.AirMove = originalAirMove
            self.j = originalSpeed
        end
    end

    local hum = character:WaitForChild("Humanoid")
    hum.JumpHeight = JumpHeight

    spawn(function()
        while hum and hum.Parent do
            hum.JumpHeight = JumpHeight
            wait(0.5)
        end
    end)

    -- Jump Cap (no effects)
    local jumps = 0
    local jumpTick = tick()

    hum.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            jumps = 0
        end
    end)

    local jumpConnection
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if jumps < jumpcap and tick() - jumpTick > 0.05 then
            jumpTick = tick()
            jumps = jumps + 1
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    character.AncestryChanged:Connect(function()
        if not character.Parent then
            jumpConnection:Disconnect()
        end
    end)

    setupBhopJumpBtn()

    task.wait(0.5)

    local StatChanges = character:WaitForChild("StatChanges", 5)
    if StatChanges then
        local Speed = StatChanges:WaitForChild("Speed", 5)
        if Speed then
            local Spring = Speed:WaitForChild("Spring", 5)
            if Spring and Spring:IsA("NumberValue") then
                Spring:GetPropertyChangedSignal("Value"):Connect(function()
                    SpringSpeedMultiplier = Spring.Value
                end)
                SpringSpeedMultiplier = Spring.Value
            end
        end
    end
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

-- ============= EMOTE MACRO =============
Tabs.Main:Section({Title="Emote Crouch", TextSize=20})
Tabs.Main:Divider()

local p = game:GetService("Players").LocalPlayer
local emoteData = {}

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

EmoteCrouchToggle = Tabs.Main:Toggle({
    Title = "Emote Crouch",
    Flag = "EmoteCrouchToggle",
    Desc = "Select emote slot(s) or leave empty for random",
    Value = false,
    Callback = function(state)
        EmoteCrouchEnabled = state
    end
})

-- ============= PLAYER SETTINGS =============
Tabs.Player:Section({ Title = "Player Settings", TextSize = 40 })
Tabs.Player:Space()

SpeedInput = Tabs.Player:Input({
    Title = "Speed",
    Flag = "SpeedInput",
    Placeholder = "1500",
    Numeric = true,
    Value = "1500",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            RealSpeed = n
        end
    end
})

Tabs.Player:Space()

JumpCapInput = Tabs.Player:Input({
    Title = "Jump Cap",
    Flag = "JumpCapInput",
    Placeholder = "1",
    Numeric = true,
    Value = "1",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            jumpcap = n
        end
    end
})

Tabs.Player:Space()

AirAccelerationInput = Tabs.Player:Input({
    Title = "Air Acceleration (Strafe)",
    Flag = "AirAccelerationInput",
    Placeholder = "1",
    Numeric = true,
    Value = "1",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            AirAcceleration = n
        end
    end
})

Tabs.Player:Space()

JumpHeightInput = Tabs.Player:Input({
    Title = "Jump Height",
    Flag = "JumpHeightInput",
    Placeholder = "3",
    Numeric = true,
    Value = "3",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            JumpHeight = n
        end
    end
})

-- ============= AUTO JUMP =============
Tabs.Auto:Section({ Title = "Auto Jump", TextSize = 40 })
Tabs.Auto:Space()

BhopToggle = Tabs.Auto:Toggle({
    Title = "Auto Jump (Bhop)",
    Flag = "BhopToggle",
    Value = false,
    Callback = function(state)
        autoJumpEnabled = state
        checkBhopState()
    end
})

BhopHoldToggle = Tabs.Auto:Toggle({
    Title = "Hold to Bhop (Space/Jump Button)",
    Flag = "BhopHoldToggle",
    Value = false,
    Callback = function(state)
        bhopHoldFeature = state
        if not state then
            bhopHoldActive = false
            checkBhopState()
        end
    end
})

AutoJumpTypeDropdown = Tabs.Auto:Dropdown({
    Title = "Auto Jump Mode",
    Flag = "AutoJumpTypeDropdown",
    Values = {"Bounce", "Realistic"},
    Value = "Bounce",
    Callback = function(value)
        autoJumpType = value
    end
})

JumpCooldownInput = Tabs.Auto:Input({
    Title = "Auto Jump Delay",
    Flag = "JumpCooldownInput",
    Placeholder = "0.7",
    Numeric = true,
    Value = "0.7",
    Callback = function(value)
        local n = tonumber(value)
        if n and n > 0 then
            jumpCooldown = n
        end
    end
})

-- ============= SETTINGS =============
Tabs.Settings:Section({ Title = "UI Settings" })

Tabs.Settings:Toggle({
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

Tabs.Settings:Space()

Tabs.Settings:Section({ Title = "Keybinds" })

Tabs.Settings:Keybind({
    Flag = "WinKeybind",
    Title = "UI Keybind",
    Desc = "Keybind to open UI",
    Value = "RightControl",
    Callback = function(key)
        Window:SetToggleKey(Enum.KeyCode[key])
    end
})

Tabs.Settings:Space()

EmoteCrouchKeybind = Tabs.Settings:Keybind({
    Title = "Trigger Random Emote",
    Desc = "Keybind to trigger random emote with crouch",
    Value = "J",
    Flag = "EmoteCrouchKeybind",
    Callback = function()
        if EmoteCrouchEnabled then
            triggerRandomEmote()
        end
    end
})

WindUI:Notify({
    Title = "Evade Legacy",
    Content = "Script loaded! Features: Auto Jump, Strafe, Jump Cap, Speed, Emote Macro",
    Duration = 4
})
