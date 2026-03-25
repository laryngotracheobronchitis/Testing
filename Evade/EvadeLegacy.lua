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
AirAcceleration = 1
AirStrafeAcceleration = 182
jumpcap = 1
SpringSpeedMultiplier = 1

autoJumpEnabled = false
bhopHoldActive = false
bhopHoldFeature = false
jumpCooldown = 0.7
autoJumpType = "Bounce"

accelerationMethod = "Acceleration"
groundFriction = -0.5
AutoAccelerationEnabled = false
MaxAcceleration = 3
MinAcceleration = -1
MaxSpeed = 70

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

function reapplyModifications()
    if not movementModule then return end

    if not originalApplyFriction then
        originalApplyFriction = movementModule.ApplyFriction
    end

    local isBhopActive = autoJumpEnabled or bhopHoldActive

    if accelerationMethod == "No Acceleration" or not isBhopActive then
        movementModule.ApplyFriction = originalApplyFriction
        return
    end

    if AutoAccelerationEnabled and isBhopActive then
        movementModule.ApplyFriction = function(self, friction, dt)
            local currentSpeed = getCurrentSpeed()
            local speedFraction = math.clamp((currentSpeed - 16) / (MaxSpeed - 16), 0, 1)
            local dynamicAccel = MinAcceleration + (MaxAcceleration - MinAcceleration) * speedFraction
            originalApplyFriction(self, dynamicAccel, dt)
        end
    elseif accelerationMethod == "Ground Acceleration" then
        movementModule.ApplyFriction = function(self, friction, dt)
            if IsOnGround() then
                originalApplyFriction(self, groundFriction, dt)
            else
                originalApplyFriction(self, friction, dt)
            end
        end
    elseif accelerationMethod == "Acceleration" then
        movementModule.ApplyFriction = function(self, friction, dt)
            originalApplyFriction(self, groundFriction, dt)
        end
    end
end

function setupModuleWatcher(character)
    local movement = character:WaitForChild("Movement", 5)
    if not movement then return end

    local function applyToModule()
        local success, module = pcall(require, movement)
        if success and module then
            movementModule = module
            reapplyModifications()
        end
    end

    applyToModule()

    spawn(function()
        while character and character.Parent do
            wait(1)
            local success, module = pcall(require, movement)
            if success and module and module ~= movementModule then
                movementModule = module
                reapplyModifications()
            end
        end
    end)
end

function setupCharacter(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid", 5)
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

    -- Speed & Strafe Acceleration
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
                
                -- Air Strafe Acceleration
                local originalStrafe = airSelf.Strafe
                if originalStrafe then
                    airSelf.Strafe = function(strSelf, direction, ...)
                        direction = direction * (AirStrafeAcceleration / 182)
                        return originalStrafe(strSelf, direction, ...)
                    end
                end
                
                originalAirMove(airSelf, ...)
                airSelf.Accelerate = originalAccelerate
                if originalStrafe then
                    airSelf.Strafe = originalStrafe
                end
            end

            originalUpdate(self, dt)
            self.AirMove = originalAirMove
            self.j = originalSpeed
        end
    end

    setupModuleWatcher(character)

    -- Jump Cap (NO particle effects, NO sound)
    local jumps = 0
    local jumpTick = tick()

    Humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            jumps = 0
        end
    end)

    local jumpConnection
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if jumps < jumpcap and tick() - jumpTick > 0.05 then
            jumpTick = tick()
            jumps = jumps + 1
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    character.AncestryChanged:Connect(function()
        if not character.Parent then
            jumpConnection:Disconnect()
        end
    end)

    setupBhopJumpBtn()
    checkBhopState()

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
        player.PlayerScripts.Events.KeybindUsed:Fire("Crouch", false)
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

AirStrafeAccelerationInput = Tabs.Player:Input({
    Title = "Air Strafe Acceleration",
    Flag = "AirStrafeAccelerationInput",
    Placeholder = "182",
    Numeric = true,
    Value = "182",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            AirStrafeAcceleration = n
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
        reapplyModifications()
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
            reapplyModifications()
        end
    end
})

ShowBunnyHopButtonToggle = Tabs.Auto:Toggle({
    Title = "Show Bhop Button",
    Flag = "ShowBunnyHopButton",
    Value = false,
    Callback = function(state)
        if _G.DarahubLibBtn and _G.DarahubLibBtn.BunnyHopToggle then
            _G.DarahubLibBtn.BunnyHopToggle.Visible = state
        end
    end
})

ButtonLib.Create:Toggle({
    Text = "Bunny Hop",
    Flag = "BunnyHopToggle",
    Default = false,
    Visible = false,
    Callback = function(s)
        if BhopToggle then
            BhopToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

Tabs.Auto:Space()
Tabs.Auto:Section({Title="Bhop Acceleration"})

AccelerationDropdown = Tabs.Auto:Dropdown({
    Title = "Bhop Mode",
    Flag = "AccelerationDropdown",
    Values = {"No Acceleration", "Ground Acceleration", "Acceleration"},
    Value = "Acceleration",
    Callback = function(value)
        accelerationMethod = value
        reapplyModifications()
    end
})

AccelerationInput = Tabs.Auto:Input({
    Title = "Bhop Acceleration (Negative Only)",
    Flag = "AccelerationInput",
    Placeholder = "-0.2",
    Numeric = true,
    Value = "-0.2",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            groundFriction = n
            reapplyModifications()
        end
    end
})

Tabs.Auto:Section({Title="Auto Acceleration (Legit)"})

AutoAccelerationToggle = Tabs.Auto:Toggle({
    Title = "Auto Acceleration (Legit)",
    Flag = "AutoAccelerationToggle",
    Value = false,
    Callback = function(state)
        AutoAccelerationEnabled = state
        reapplyModifications()
    end
})

MaxAccelerationInput = Tabs.Auto:Input({
    Title = "Max Acceleration",
    Flag = "MaxAccelerationInput",
    Placeholder = "3",
    Numeric = true,
    Value = "3",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            MaxAcceleration = n
            reapplyModifications()
        end
    end
})

MinAccelerationInput = Tabs.Auto:Input({
    Title = "Min Acceleration",
    Flag = "MinAccelerationInput",
    Placeholder = "-1",
    Numeric = true,
    Value = "-1",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            MinAcceleration = n
            reapplyModifications()
        end
    end
})

MaxSpeedInput = Tabs.Auto:Input({
    Title = "Max Speed",
    Flag = "MaxSpeedInput",
    Placeholder = "70",
    Numeric = true,
    Value = "70",
    Callback = function(value)
        local n = tonumber(value)
        if n then
            MaxSpeed = n
            reapplyModifications()
        end
    end
})

Tabs.Auto:Space()
Tabs.Auto:Section({Title="Jump Settings"})

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

UncrouchKeybind = Tabs.Settings:Keybind({
    Title = "Uncrouch Keybind",
    Desc = "Press to uncrouch",
    Value = "",
    Flag = "UncrouchKeybind",
    Callback = function()
        uncrouch()
    end
})

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
    Content = "Script loaded! Features: Speed, Jump Cap, Air Strafe, Auto Jump (with Acceleration), Emote Macro",
    Duration = 4
})
