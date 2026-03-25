if getgenv().EvadeLegacyExecuted then
    game:GetService("Players").LocalPlayer.PlayerGui.Menu.Messages.Use:Fire("Script Is Already Loaded, rejoin if you want to re-execute", "Error")
    return
end
getgenv().EvadeLegacyExecuted = true

local ButtonLib = loadstring(game:HttpGet("https://darahub.pages.dev/Module/Button-lib.lua"))()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    NewElements = true,
    Title = "Evade Legacy",
    Size = UDim2.fromOffset(500, 400),
    Theme = "Dark",
    HidePanelBackground = false,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 180,
    OpenButton = { Enabled = false, Scale = 0 }
})

-- ================== TABS ==================
local Tabs = {}
Tabs.Main = Window:Tab({ Title = "Main", Icon = "home" })
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "zap" })

-- ================== VARIABLES ==================
local RealSpeed = 1500
local JumpHeight = 3
local AirAcceleration = 1
local AirStrafeAcceleration = 182
local jumpcap = 1

local autoJumpEnabled = false
local bhopHoldActive = false
local bhopHoldFeature = false
local jumpCooldown = 0.7

local accelerationMethod = "Acceleration"
local groundFriction = -0.2

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Character, Humanoid, HumanoidRootPart
local movementModule = nil
local originalApplyFriction = nil
local bhopConnection = nil
local bhopLoaded = false
local LastJump = 0

local GROUND_CHECK_DISTANCE = 3.5
local MAX_SLOPE_ANGLE = 45

-- ================== GUI TOGGLE (Mobile + PC) ==================
local guiVisible = true
local toggleButton

local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EvadeLegacyToggle"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 60, 0, 60)
    toggleButton.Position = UDim2.new(1, -80, 0, 80)
    toggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    toggleButton.Text = "EL"
    toggleButton.TextColor3 = Color3.fromRGB(0, 255, 120)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = toggleButton

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 120)
    stroke.Thickness = 2
    stroke.Parent = toggleButton

    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            guiVisible = not guiVisible
            pcall(function()
                Window:SetVisible(guiVisible)
            end)
        end
    end)
end

-- Keybind PC (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        guiVisible = not guiVisible
        pcall(function()
            Window:SetVisible(guiVisible)
        end)
    end
end)

-- ================== GROUND CHECK & BHOP ==================
local function IsOnGround()
    if not Character or not HumanoidRootPart then return false end
    local rayOrigin = HumanoidRootPart.Position
    local rayDirection = Vector3.new(0, -GROUND_CHECK_DISTANCE, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if not result then return false end

    local angle = math.deg(math.acos(result.Normal:Dot(Vector3.new(0, 1, 0))))
    return angle <= MAX_SLOPE_ANGLE
end

local function updateBhop()
    if not bhopLoaded or not Character or not Humanoid then return end
    local isBhopActive = autoJumpEnabled or bhopHoldActive
    if not isBhopActive then return end

    if IsOnGround() and (tick() - LastJump) > jumpCooldown then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        LastJump = tick()
    end
end

local function loadBhop()
    if bhopLoaded then return end
    bhopLoaded = true
    bhopConnection = RunService.Heartbeat:Connect(updateBhop)
end

local function unloadBhop()
    if not bhopLoaded then return end
    bhopLoaded = false
    if bhopConnection then bhopConnection:Disconnect() end
    bhopHoldActive = false
end

local function checkBhopState()
    if autoJumpEnabled or bhopHoldActive then
        loadBhop()
    else
        unloadBhop()
    end
end

-- ================== MOVEMENT HOOK ==================
local function reapplyModifications()
    if not movementModule then return end
    if not originalApplyFriction then
        originalApplyFriction = movementModule.ApplyFriction
    end

    local isBhopActive = autoJumpEnabled or bhopHoldActive

    if accelerationMethod == "No Acceleration" or not isBhopActive then
        movementModule.ApplyFriction = originalApplyFriction
        return
    end

    if accelerationMethod == "Acceleration" then
        movementModule.ApplyFriction = function(self, friction, dt)
            originalApplyFriction(self, groundFriction, dt)
        end
    elseif accelerationMethod == "Ground Acceleration" then
        movementModule.ApplyFriction = function(self, friction, dt)
            if IsOnGround() then
                originalApplyFriction(self, groundFriction, dt)
            else
                originalApplyFriction(self, friction, dt)
            end
        end
    end
end

local function setupCharacter(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid", 5)
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

    Humanoid.JumpHeight = JumpHeight

    local movement = character:WaitForChild("Movement", 5)
    if movement and movement:IsA("ModuleScript") then
        movementModule = require(movement)

        local oldUpdate = movementModule.Update
        movementModule.Update = function(self, dt)
            local oldJ = self.j
            self.j = RealSpeed

            local oldAirMove = self.AirMove
            self.AirMove = function(airSelf, ...)
                local oldAccel = airSelf.Accelerate
                airSelf.Accelerate = function(accSelf, direction, targetSpeed, acceleration)
                    targetSpeed = targetSpeed * AirAcceleration
                    return oldAccel(accSelf, direction, targetSpeed, acceleration)
                end
                oldAirMove(airSelf, ...)
                airSelf.Accelerate = oldAccel
            end

            oldUpdate(self, dt)
            self.AirMove = oldAirMove
            self.j = oldJ
        end

        reapplyModifications()
    end

    -- Jump Cap
    local jumps = 0
    local jumpTick = tick()

    UserInputService.JumpRequest:Connect(function()
        if jumps < jumpcap and tick() - jumpTick > 0.05 then
            jumpTick = tick()
            jumps += 1
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

-- ================== EMOTE CROUCH MACRO ==================
local p = player
local emoteData = {}
local function scanEmotes()
    for i = 1, 8 do
        emoteData[i] = {Slot = i, Name = p:GetAttribute("Emote"..i) or ""}
    end
end
scanEmotes()

local selectedValues = {}
local dropdownOptions = {}
for i = 1, 8 do
    if emoteData[i].Name \~= "" then
        table.insert(dropdownOptions, "Slot"..i.." "..emoteData[i].Name)
    end
end

Tabs.Main:Section({Title = "Emote Crouch", TextSize = 20})
local dropdown = Tabs.Main:Dropdown({
    Title = "Select Emote Slot(s)",
    Options = dropdownOptions,
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        selectedValues = values
    end
})

local function updateDropdown()
    scanEmotes()
    dropdownOptions = {}
    for i = 1, 8 do
        if emoteData[i].Name \~= "" then
            table.insert(dropdownOptions, "Slot"..i.." "..emoteData[i].Name)
        end
    end
    dropdown:Refresh(dropdownOptions, true)
end

task.spawn(function()
    while task.wait(0.5) do
        for i = 1, 8 do
            if p:GetAttribute("Emote"..i) \~= emoteData[i].Name then
                updateDropdown()
                break
            end
        end
    end
end)

local function triggerRandomEmote()
    pcall(function()
        game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire("Crouch", true)
    end)
    task.wait(0.1)

    local validSlots = {}
    if #selectedValues > 0 then
        for _, slotText in pairs(selectedValues) do
            local slotNum = tonumber(string.match(slotText, "Slot(%d+)"))
            if slotNum and emoteData[slotNum] and emoteData[slotNum].Name \~= "" then
                table.insert(validSlots, tostring(slotNum))
            end
        end
    else
        for i = 1, 8 do
            if emoteData[i] and emoteData[i].Name \~= "" then
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

Tabs.Main:Toggle({
    Title = "Emote Crouch",
    Value = false,
    Callback = function(state)
        if state then
            triggerRandomEmote()
        end
    end
})

-- ================== AUTO TAB ==================
Tabs.Auto:Section({Title = "Bhop", TextSize = 20})

Tabs.Auto:Toggle({
    Title = "Bhop",
    Value = false,
    Callback = function(state)
        autoJumpEnabled = state
        checkBhopState()
        reapplyModifications()
    end
})

Tabs.Auto:Toggle({
    Title = "Bhop Hold (Jump Button)",
    Value = false,
    Callback = function(state)
        bhopHoldFeature = state
        if not state then
            bhopHoldActive = false
            checkBhopState()
        end
    end
})

Tabs.Auto:Dropdown({
    Title = "Bhop Mode",
    Values = {"No Acceleration", "Ground Acceleration", "Acceleration"},
    Value = "Acceleration",
    Callback = function(value)
        accelerationMethod = value
        reapplyModifications()
    end
})

Tabs.Auto:Input({
    Title = "Bhop Acceleration (Negative)",
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

Tabs.Auto:Input({
    Title = "Auto Jump Delay",
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

Tabs.Auto:Section({Title = "Movement", TextSize = 20})

Tabs.Auto:Input({
    Title = "Air Acceleration",
    Placeholder = "1",
    Numeric = true,
    Value = "1",
    Callback = function(value)
        local n = tonumber(value)
        if n then AirAcceleration = n end
    end
})

Tabs.Auto:Input({
    Title = "Jump Cap",
    Placeholder = "1",
    Numeric = true,
    Value = "1",
    Callback = function(value)
        local n = tonumber(value)
        if n then jumpcap = n end
    end
})

-- Buat Toggle Button di layar
createToggleButton()

WindUI:Notify({
    Title = "Evade Legacy",
    Content = "Script loaded successfully!",
    Duration = 4
})
