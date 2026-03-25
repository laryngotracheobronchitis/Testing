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
    OpenButton = {
        Enabled = false,
        Scale = 0
    },
})

-- Create tabs
local Tabs = {}
Tabs.Player = Window:Tab({ Title = "Player", Icon = "user" })
Tabs.Auto = Window:Tab({ Title = "Auto", Icon = "zap" })
Tabs.Main = Window:Tab({ Title = "Main", Icon = "home" })

-- ============= CORE VARIABLES =============
RealSpeed = 1500
JumpHeight = 3
AirAcceleration = 1
jumpcap = 1
RotationSpeedMultiplier = 0.5
BaseEmoteRotationSpeed = 0.1
AirStrafeAcceleration = 182

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

InfiniteSlide = false
SlideFriction = -0.1

player = game:GetService("Players").LocalPlayer
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Players = game:GetService("Players")
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

particleTemplate = nil

function createJumpParticle()
    local emitter = Instance.new("ParticleEmitter")
    emitter.Name = "DoubleJumpEffect"
    emitter.EmissionDirection = Enum.NormalId.Bottom
    emitter.Enabled = false
    emitter.Lifetime = NumberRange.new(0.1, 0.3)
    emitter.LightEmission = 1
    emitter.LightInfluence = 1
    emitter.Rate = 500
    emitter.Rotation = NumberRange.new(-180, 180)
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.0617, 1),
        NumberSequenceKeypoint.new(0.864, 0),
        NumberSequenceKeypoint.new(1, 0)
    })
    emitter.Speed = NumberRange.new(0, 8)
    emitter.SpreadAngle = Vector2.new(135, 135)
    emitter.Texture = "rbxassetid://4770542473"
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.199, 0.512),
        NumberSequenceKeypoint.new(1, 1)
    })
    return emitter
end

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

function applyInfiniteSlide(character)
    if not InfiniteSlide then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local movement = character:FindFirstChild("Movement")
    if not movement or not movement:IsA("ModuleScript") then return end

    local movementModule = require(movement)
    if not movementModule then return end

    local originalApplyFriction = movementModule.ApplyFriction
    if not originalApplyFriction then return end

    movementModule.ApplyFriction = function(self, friction, dt)
        originalApplyFriction(self, SlideFriction, dt)
    end
end

function setupModuleWatcher(character)
    local movement = character:WaitForChild("Movement", 5)
    if not movement then return end

    movement.AncestryChanged:Connect(function()
        if movement.Parent then
            local newModule = require(movement)
            if newModule then
                movementModule = newModule
                reapplyModifications()
                applyInfiniteSlide(character)
            end
        end
    end)
end

function setupCharacter(character)
    Character = character
    Humanoid = character:WaitForChild("Humanoid", 5)
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)

    if not particleTemplate then
        particleTemplate = createJumpParticle()
    end

    local movement = character:FindFirstChild("Movement")
    if movement and movement:IsA("ModuleScript") then
        local movementModule = require(movement)

        local originalUpdate = movementModule.Update
        movementModule.Update = function(self, dt)
            local originalSpeed = self.j
            self.j = RealSpeed * (SpringSpeedMultiplier or 1)

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

    applyInfiniteSlide(character)
    setupModuleWatcher(character)

    local hum = character:WaitForChild("Humanoid")
    hum.JumpHeight = JumpHeight
    hum:SetAttribute("RealJumpHeight", JumpHeight)

    local jumpCount = 0
    hum.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            jumpCount = 0
        end
        if newState == Enum.HumanoidStateType.Jumping then
            jumpCount = jumpCount + 1
            if jumpCount >= 2 and jumpcap > 1 then
                local attachment = Instance.new("Attachment")
                attachment.Position = Vector3.new(0, -2, 0)
                attachment.Parent = HumanoidRootPart

                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://6870001835"
                sound.Pitch = 2
                sound.Volume = 0.5
                sound.Parent = attachment
                sound:Play()

                local jumpParticles = particleTemplate:Clone()
                jumpParticles.Parent = attachment
                jumpParticles:Emit(40)

                task.delay(0.6, function()
                    attachment:Destroy()
                end)
            end
        end
    end)

    spawn(function()
        while hum and hum.Parent do
            hum.JumpHeight = JumpHeight
            wait(0.5)
        end
    end)

    local jumps = 0
    local jumpTick = tick()
    hum.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            jumps = 0
        end
    end)

    local jumpConnection = UserInputService.JumpRequest:Connect(function()
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

    local movement = character:WaitForChild("Movement", 5)
    if movement and movement:IsA("ModuleScript") then
        movementModule = require(movement)
        reapplyModifications()
    end

    local EmoteSpeed = StatChanges and StatChanges.Speed and StatChanges.Speed:FindFirstChild("EmoteSpeed")
    local IsDowned = character:WaitForChild("Downed", 5)

    if EmoteSpeed or IsDowned then
        local oldNameCall
        oldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and tostring(self) == "Input" then
                local Alpha = math.clamp(BaseEmoteRotationSpeed * RotationSpeedMultiplier, 0, 1)
                return oldNameCall(self, ..., Alpha)
            end
            return oldNameCall(self, ...)
        end)
    end
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

-- ============= EMOTE MACRO =============
Tabs.Main:Section({Title="Emote Crouch",TextSize=20});Tabs.Main:Divider();local p=game:GetService("Players").LocalPlayer;local emoteData={};function scanEmotes()for i=1,8 do local attr=p:GetAttribute("Emote"..i)emoteData[i]={Slot=i,Name=attr or ""}end end;scanEmotes();local dropdownOptions={};for i=1,8 do if emoteData[i].Name\~=""then table.insert(dropdownOptions,"Slot"..i.." "..emoteData[i].Name)end end;local selectedValues={};local dropdown=Tabs.Main:Dropdown({Title="Select Emote Slot(s)",Options=dropdownOptions,Multi=true,AllowNone=true,Callback=function(values)selectedValues=values end});function updateDropdown()scanEmotes();dropdownOptions={};for i=1,8 do if emoteData[i].Name\~=""then table.insert(dropdownOptions,"Slot"..i.." "..emoteData[i].Name)end end;dropdown:Refresh(dropdownOptions,true)end;function monitorAttributes()while true do task.wait(0.5);for i=1,8 do local attr=p:GetAttribute("Emote"..i)if attr\~=emoteData[i].Name then updateDropdown()break end end end end;task.spawn(monitorAttributes);function triggerRandomEmote()pcall(function()game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire("Crouch",true)end);task.wait(0.1);local validSlots={};if#selectedValues>0 then for _,slotText in pairs(selectedValues)do local slotNum=tonumber(string.match(slotText,"Slot(%d+)"))if slotNum and emoteData[slotNum]and emoteData[slotNum].Name\~=""then table.insert(validSlots,tostring(slotNum))end end else for i=1,8 do if emoteData[i]and emoteData[i].Name\~=""then table.insert(validSlots,tostring(i))end end end;if#validSlots>0 then local randomSlot=validSlots[math.random(1,#validSlots)];pcall(function()game:GetService("ReplicatedStorage").Events.Emote:FireServer(randomSlot)end)end end;ButtonLib.Create:Button({Text="Emote Crouch",Flag="EmoteCrouch",Visible=false,Callback=function()triggerRandomEmote()end}).Position=UDim2.new(0.5,-125,0.2,0);EmoteCrouchToggle=Tabs.Main:Toggle({Title="Emote Crouch",Flag="EmoteCrouchToggle",Desc="Select emote slot(s) or leave empty for random",Value=false,Callback=function(state)EmoteCrouchEnabled=state;if _G.DarahubLibBtn and _G.DarahubLibBtn.EmoteCrouch then _G.DarahubLibBtn.EmoteCrouch.Visible=state end end})

-- ============= PLAYER SETTINGS =============
Tabs.Player:Section({ Title = "Player", TextSize = 40 })
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
Title = "Air Acceleration",
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
Tabs.Auto:Section({ Title = "Auto", TextSize = 40 })
 Tabs.Auto:Space()

Tabs.Auto:Section({Title="Bhop"})

BhopToggle = Tabs.Auto:Toggle({
Title = "Bhop",
Flag = "BhopToggle",
Value = false,
Callback = function(state)
autoJumpEnabled = state
checkBhopState()
reapplyModifications()
end
})

BhopHoldToggle = Tabs.Auto:Toggle({
Title = "Bhop Jump button/Space",
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
Title = "Bhop Button",
Flag = "ShowBunnyHopButton",
Value = false,
Callback = function(state)
if _G.DarahubLibBtn and _G.DarahubLibBtn.BunnyHopToggle then
_G.DarahubLibBtn.BunnyHopToggle.Visible = state
end
end
})

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

-- ================== GUI TOGGLE (Mobile + PC) ==================
local guiVisible = true

local function toggleGUI()
    guiVisible = not guiVisible
    pcall(function()
        if guiVisible then
            Window:Open()
        else
            Window:Close()
        end
    end)
end

-- Tombol Toggle untuk Mobile
local function createToggleButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EvadeLegacyToggle"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 60)
    btn.Position = UDim2.new(1, -80, 0, 80)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.Text = "EL"
    btn.TextColor3 = Color3.fromRGB(0, 255, 120)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 120)
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleGUI()
        end
    end)
end

-- Keybind untuk PC (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGUI()
    end
end)

createToggleButton()

WindUI:Notify({
    Title = "Evade Legacy",
    Content = "Script loaded successfully!\nShow/Hide: Right Shift (PC) atau tap EL (Mobile)",
    Duration = 5
})
