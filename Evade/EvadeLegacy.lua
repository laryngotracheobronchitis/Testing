if getgenv().EvadeLegacyExecuted then
    game:GetService("Players").LocalPlayer.PlayerGui.Menu.Messages.Use:Fire("Script Is Already Loaded, rejoin if you want to re-execute", "Error")
    return
end
getgenv().EvadeLegacyExecuted = true

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
local jumpcap = 1
local jumpCooldown = 0.7
local groundFriction = -0.2
local accelerationMethod = "Acceleration"

local autoJumpEnabled = false
local bhopHoldActive = false
local bhopHoldFeature = false

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

local function toggleGUI()
    guiVisible = not guiVisible
    pcall(function()
        Window:Toggle()  -- Method utama WindUI
    end)
end

-- Tombol Toggle untuk Mobile
local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EvadeLegacyToggle"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 55, 0, 55)
    btn.Position = UDim2.new(1, -70, 0, 100)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.Text = "EL"
    btn.TextColor3 = Color3.fromRGB(0, 255, 100)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 100)
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleGUI()
        end
    end)
end

-- Keybind PC (Right Shift)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI()
    end
end)

-- ================== GROUND CHECK & BHOP ==================
local function IsOnGround()
    if not (Character and HumanoidRootPart) then return false end
    local rayOrigin = HumanoidRootPart.Position
    local rayDirection = Vector3.new(0, -GROUND_CHECK_DISTANCE, 0)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {Character}
    params.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(rayOrigin, rayDirection, params)
    if not result then return false end
    local angle = math.deg(math.acos(result.Normal:Dot(Vector3.new(0,1,0))))
    return angle <= MAX_SLOPE_ANGLE
end

local function updateBhop()
    if not bhopLoaded or not Humanoid then return end
    if not (autoJumpEnabled or bhopHoldActive) then return end

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
    if bhopConnection then bhopConnection:Disconnect() end
    bhopLoaded = false
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

    local active = autoJumpEnabled or bhopHoldActive

    if accelerationMethod == "No Acceleration" or not active then
        movementModule.ApplyFriction = originalApplyFriction
        return
    end

    movementModule.ApplyFriction = function(self, friction, dt)
        if accelerationMethod == "Acceleration" then
            originalApplyFriction(self, groundFriction, dt)
        elseif accelerationMethod == "Ground Acceleration" then
            originalApplyFriction(self, IsOnGround() and groundFriction or friction, dt)
        else
            originalApplyFriction(self, friction, dt)
        end
    end
end

local function setupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid", 5)
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart", 5)

    Humanoid.JumpHeight = JumpHeight

    local movement = char:WaitForChild("Movement", 5)
    if movement and movement:IsA("ModuleScript") then
        movementModule = require(movement)

        local oldUpdate = movementModule.Update
        movementModule.Update = function(self, dt)
            local oldJ = self.j
            self.j = RealSpeed

            local oldAir = self.AirMove
            self.AirMove = function(airSelf, ...)
                local oldAccel = airSelf.Accelerate
                airSelf.Accelerate = function(accSelf, dir, targetSpeed, accel)
                    targetSpeed = targetSpeed * AirAcceleration
                    return oldAccel(accSelf, dir, targetSpeed, accel)
                end
                oldAir(airSelf, ...)
                airSelf.Accelerate = oldAccel
            end

            oldUpdate(self, dt)
            self.j = oldJ
            self.AirMove = oldAir
        end

        reapplyModifications()
    end

    -- Jump Cap
    local jumps = 0
    local lastJumpTick = tick()
    UserInputService.JumpRequest:Connect(function()
        if jumps < jumpcap and (tick() - lastJumpTick) > 0.05 then
            lastJumpTick = tick()
            jumps += 1
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

-- ================== EMOTE CROUCH ==================
local selectedEmotes = {}
local emoteData = {}

local function scanEmotes()
    for i = 1, 8 do
        emoteData[i] = player:GetAttribute("Emote"..i) or ""
    end
end
scanEmotes()

local dropdownOptions = {}
for i = 1, 8 do
    if emoteData[i] \~= "" then
        table.insert(dropdownOptions, "Slot " .. i .. " - " .. emoteData[i])
    end
end

Tabs.Main:Section({Title = "Emote Crouch", TextSize = 20})

local emoteDropdown = Tabs.Main:Dropdown({
    Title = "Pilih Emote Slot",
    Options = dropdownOptions,
    Multi = true,
    Callback = function(vals) selectedEmotes = vals end
})

Tabs.Main:Toggle({
    Title = "Aktifkan Emote Crouch (Random)",
    Value = false,
    Callback = function(state)
        if state then
            pcall(function()
                player.PlayerScripts.Events.KeybindUsed:Fire("Crouch", true)
                task.wait(0.15)
                local slots = {}
                if #selectedEmotes > 0 then
                    for _, v in selectedEmotes do
                        local num = tonumber(v:match("%d+"))
                        if num then table.insert(slots, num) end
                    end
                else
                    for i = 1,8 do if emoteData[i] \~= "" then table.insert(slots, i) end end
                end
                if #slots > 0 then
                    local chosen = slots[math.random(1, #slots)]
                    game:GetService("ReplicatedStorage").Events.Emote:FireServer(tostring(chosen))
                end
            end)
        end
    end
})

-- ================== AUTO TAB ==================
Tabs.Auto:Section({Title = "Bhop Settings", TextSize = 20})

Tabs.Auto:Toggle({ Title = "Bhop", Value = false, Callback = function(s) autoJumpEnabled = s checkBhopState() reapplyModifications() end })

Tabs.Auto:Toggle({ Title = "Bhop Hold (Jump Button)", Value = false, Callback = function(s) bhopHoldFeature = s if not s then bhopHoldActive = false checkBhopState() end end })

Tabs.Auto:Dropdown({
    Title = "Bhop Mode",
    Values = {"Acceleration", "Ground Acceleration", "No Acceleration"},
    Value = "Acceleration",
    Callback = function(v) accelerationMethod = v reapplyModifications() end
})

Tabs.Auto:Input({ Title = "Bhop Friction", Placeholder = "-0.2", Numeric = true, Value = "-0.2", Callback = function(v) local n=tonumber(v) if n then groundFriction=n reapplyModifications() end end })

Tabs.Auto:Input({ Title = "Jump Delay", Placeholder = "0.7", Numeric = true, Value = "0.7", Callback = function(v) local n=tonumber(v) if n>0 then jumpCooldown=n end end })

Tabs.Auto:Section({Title = "Movement Settings", TextSize = 20})

Tabs.Auto:Input({ Title = "Air Acceleration", Placeholder = "1", Numeric = true, Value = "1", Callback = function(v) local n=tonumber(v) if n then AirAcceleration = n end end })

Tabs.Auto:Input({ Title = "Jump Cap", Placeholder = "1", Numeric = true, Value = "1", Callback = function(v) local n=tonumber(v) if n then jumpcap = n end end })

-- ================== START ==================
createToggleButton()

WindUI:Notify({
    Title = "Evade Legacy",
    Content = "Script berhasil dimuat!",
    Duration = 4
})
