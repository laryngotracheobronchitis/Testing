-- =========================================================
-- RELOAD SYSTEM: cleanup instance lama dulu
-- =========================================================
if type(getgenv().DaraHubCleanup) == "function" then
    pcall(getgenv().DaraHubCleanup)
    getgenv().DaraHubCleanup = nil
end
getgenv().DaraHubExecuted = true

local BaseURL = "https://darahub.pages.dev"
WindUI = loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/WindUI-Moded/main.lua"))()
loadstring(game:HttpGet(BaseURL .. "/Module/Library/GUI/LoadAll.lua"))()

Window = WindUI:CreateWindow({
    Title = "Darahub | Trimmed",
    Icon = BaseURL .. "/icon.png",
    Author = "Trimmed by request",
    Folder = "Darahub/Trimmed",
    Size = UDim2.fromOffset(580, 490),
    Theme = "Dark",
    HidePanelBackground = false,
    NewElements = true,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
    OpenButton = { ShowIconOnly = true }
})

-- ============ FIX WindUI SHOW/HIDE ============
WindUI.TransparencyValue = 0.7
Window:ToggleTransparency(true)
Window:SetToggleKey(Enum.KeyCode.RightControl)
pcall(function() Window:DisableTopbarButtons({ "Fullscreen" }) end)
Window:Tag({ Title = "v1.4" })

Tabs = {
    Combat  = Window:Tab({ Title = "Combat",  Icon = "sword" }),
    Visuals = Window:Tab({ Title = "Visuals", Icon = "camera" }),
    Player  = Window:Tab({ Title = "Player",  Icon = "user" }),
    Misc    = Window:Tab({ Title = "Misc",    Icon = "star" }),
    ESP     = Window:Tab({ Title = "ESP",     Icon = "eye" }),
}

local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local VirtualUser        = game:GetService("VirtualUser")
local Lighting           = game:GetService("Lighting")
local UserInputService   = game:GetService("UserInputService")
local CoreGui            = game:GetService("CoreGui")
local LocalPlayer        = Players.LocalPlayer

local Character, Humanoid, HumanoidRootPart
local function setupCharacter(c)
    Character = c
    Humanoid = c:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = c:FindFirstChild("HumanoidRootPart")
end
if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- Lighting snapshot untuk restore
local lightingSnapshot = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ColorShift_Top = Lighting.ColorShift_Top,
    ColorShift_Bottom = Lighting.ColorShift_Bottom,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
}

-- =========================================================
-- AIMBOT (PROFILE 2 + FOV 55)
-- =========================================================
local AimbotEnabled      = false
local ShowFOV            = false
local FOVThickness       = 2
local FOVColor           = Color3.fromRGB(0, 255, 0)
local aimPart            = "Head"
local aimLockType        = "Realistic"
local smoothnessValue    = 8
local wallCheckEnabled   = true
local fovRadius          = 55
local lockFOVToCenter    = true
local maxDistance        = 300
local teamCheckEnabled   = true
local targetTypes        = { "Player" }

local AimbotCircle, aimbotRenderConnection, aimbotRunning, aimbotConnection
local cameraLockEnabled, lockedTarget, cameraLockConnection
local npcCache, lastNPCCacheTime = {}, 0

local function updateNPCCache()
    if tick() - lastNPCCacheTime < 2 then return end
    lastNPCCacheTime = tick()
    npcCache = {}
    local playerChars = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then playerChars[p.Character] = true end
    end
    local function scan(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Model") and not playerChars[child] then
                local hum  = child:FindFirstChildOfClass("Humanoid")
                local root = child:FindFirstChild("HumanoidRootPart")
                    or child:FindFirstChild("Torso")
                    or child:FindFirstChild("UpperTorso")
                if hum and hum.Health > 0 and root then
                    table.insert(npcCache, { character = child, rootPart = root, humanoid = hum })
                end
            end
            if child:IsA("Folder") or child:IsA("Model") then scan(child) end
        end
    end
    scan(workspace)
end

local function getAimPart(character)
    if not character then return nil end
    if aimPart == "Head" then return character:FindFirstChild("Head")
    elseif aimPart == "Body" then
        return character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("UpperTorso")
    elseif aimPart == "Legs" then
        return character:FindFirstChild("HumanoidRootPart")
            or character:FindFirstChild("LowerTorso")
            or character:FindFirstChild("Left Leg")
            or character:FindFirstChild("Right Leg")
    end
    return character:FindFirstChild("Head")
end

local function isVisible(part)
    if not wallCheckEnabled or not part then return true end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local origin, target = hrp.Position, part.Position
    local dir = target - origin
    if dir.Magnitude <= 0 then return true end
    local ray = Ray.new(origin, dir.Unit * dir.Magnitude)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, { char, part.Parent })
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

local function getAllTargets()
    local targets   = {}
    local char      = LocalPlayer.Character
    local playerPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position
    local localTeam = LocalPlayer.Team
    for _, targetType in ipairs(targetTypes) do
        if targetType == "Player" then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not (teamCheckEnabled and localTeam and player.Team == localTeam) then
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local ap = getAimPart(player.Character)
                            if ap and (not playerPos or (ap.Position - playerPos).Magnitude <= maxDistance) then
                                table.insert(targets, { type = "Player", character = player.Character, aimPart = ap, humanoid = hum })
                            end
                        end
                    end
                end
            end
        elseif targetType == "NPC" then
            updateNPCCache()
            for _, npcData in ipairs(npcCache) do
                if npcData.humanoid and npcData.humanoid.Health > 0 then
                    local ap = getAimPart(npcData.character)
                    if ap and (not playerPos or (ap.Position - playerPos).Magnitude <= maxDistance) then
                        table.insert(targets, { type = "NPC", character = npcData.character, aimPart = ap, humanoid = npcData.humanoid })
                    end
                end
            end
        end
    end
    return targets
end

local function getClosestEnemyInFOV()
    local Camera = workspace.CurrentCamera
    if not Camera then return nil end
    local screenCenter = lockFOVToCenter
        and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        or UserInputService:GetMouseLocation()
    local closestTarget, closestDistance = nil, math.huge
    for _, td in ipairs(getAllTargets()) do
        if td.aimPart then
            local sp, onScreen = Camera:WorldToViewportPoint(td.aimPart.Position)
            if onScreen then
                local d = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                if d < fovRadius and d < closestDistance and isVisible(td.aimPart) then
                    closestDistance = d
                    closestTarget = td
                end
            end
        end
    end
    return closestTarget
end

local function createFOVCircle()
    if AimbotCircle then AimbotCircle:Remove(); AimbotCircle = nil end
    if not ShowFOV then return end
    local Camera = workspace.CurrentCamera
    if not Camera then return end
    local circle = Drawing.new("Circle")
    circle.Visible = true
    circle.Radius = fovRadius
    circle.Color = FOVColor
    circle.Thickness = FOVThickness
    circle.Filled = false
    circle.NumSides = 60
    circle.Position = lockFOVToCenter
        and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        or UserInputService:GetMouseLocation()
    AimbotCircle = circle
    if aimbotRenderConnection then aimbotRenderConnection:Disconnect() end
    aimbotRenderConnection = RunService.RenderStepped:Connect(function()
        if AimbotCircle and ShowFOV then
            local cam = workspace.CurrentCamera
            if cam then
                AimbotCircle.Position = lockFOVToCenter
                    and Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
                    or UserInputService:GetMouseLocation()
            end
        end
    end)
end

local function updateFOVCircle()
    if AimbotCircle then
        AimbotCircle.Radius = fovRadius
        AimbotCircle.Color = FOVColor
        AimbotCircle.Thickness = FOVThickness
        AimbotCircle.Visible = ShowFOV
    elseif ShowFOV then
        createFOVCircle()
    end
end

local function unlockCamera()
    cameraLockEnabled = false
    lockedTarget = nil
    if cameraLockConnection then cameraLockConnection:Disconnect(); cameraLockConnection = nil end
end

local function lockCameraToTarget(target)
    if not target or not target.aimPart then unlockCamera(); return end
    lockedTarget = target
    cameraLockEnabled = true
    if cameraLockConnection then cameraLockConnection:Disconnect() end
    cameraLockConnection = RunService.RenderStepped:Connect(function(dt)
        if not cameraLockEnabled or not lockedTarget or not lockedTarget.aimPart then unlockCamera(); return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local camPos = cam.CFrame.Position
        local targetCF = CFrame.new(camPos, lockedTarget.aimPart.Position)
        local smooth = math.clamp(1 - (smoothnessValue / 20), 0.001, 1)
        if aimLockType == "Realistic" then
            cam.CFrame = cam.CFrame:Lerp(targetCF, smooth)
        else
            cam.CFrame = cam.CFrame:Lerp(targetCF, smooth * math.min(dt * 60, 1))
        end
    end)
end

local function startAimbot()
    if aimbotRunning then return end
    createFOVCircle()
    aimbotRunning = true
    aimbotConnection = RunService.RenderStepped:Connect(function()
        if not AimbotEnabled or not aimbotRunning then
            if cameraLockEnabled then unlockCamera() end
            return
        end
        if not workspace.CurrentCamera then return end
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        if #targetTypes == 0 then
            if cameraLockEnabled then unlockCamera() end
            return
        end
        local t = getClosestEnemyInFOV()
        if t and t.aimPart then
            if not cameraLockEnabled or lockedTarget ~= t then lockCameraToTarget(t) end
        else
            unlockCamera()
        end
    end)
end

local function stopAimbot()
    aimbotRunning = false
    unlockCamera()
    if aimbotConnection then aimbotConnection:Disconnect(); aimbotConnection = nil end
    if AimbotCircle then AimbotCircle:Remove(); AimbotCircle = nil end
    if aimbotRenderConnection then aimbotRenderConnection:Disconnect(); aimbotRenderConnection = nil end
end

Tabs.Combat:Section({ Title = "Aimbot" })
AimbotToggle = Tabs.Combat:Toggle({
    Title = "Aimbot (F8)",
    Flag = "AimbotToggle",
    Value = false,
    Callback = function(s) AimbotEnabled = s; if s then startAimbot() else stopAimbot() end end
})
Tabs.Combat:Dropdown({ Title = "Aim Part", Flag = "AimPartDropdown", Values = { "Head", "Body", "Legs" }, Value = "Head", Callback = function(v) aimPart = v end })
Tabs.Combat:Dropdown({ Title = "Target Type", Flag = "TargetTypeDropdown", Values = { "Player", "NPC" }, Value = { "Player" }, Multi = true, AllowNone = true, Callback = function(v) targetTypes = v end })
Tabs.Combat:Dropdown({ Title = "Aim Lock Type", Flag = "AimLockTypeDropdown", Values = { "Realistic", "Stimulate" }, Value = "Realistic", Callback = function(v) aimLockType = v; if cameraLockEnabled then unlockCamera() end end })

Tabs.Combat:Input({
    Title = "Smoothness", Flag = "SmoothnessInput",
    Value = "8", Placeholder = "0.01 - 20",
    NumbersOnly = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0.01 and n <= 20 then smoothnessValue = n end
    end
})
Tabs.Combat:Input({
    Title = "Max Distance", Flag = "MaxDistanceInput",
    Value = "300", Placeholder = "angka jarak",
    NumbersOnly = true,
    Callback = function(v) local n = tonumber(v); if n then maxDistance = n end end
})
Tabs.Combat:Toggle({ Title = "Team Check", Flag = "TeamCheckToggle", Value = true, Callback = function(s) teamCheckEnabled = s end })
Tabs.Combat:Toggle({ Title = "Wall Check", Flag = "WallCheckToggle", Value = true, Callback = function(s) wallCheckEnabled = s end })

Tabs.Combat:Section({ Title = "FOV" })
Tabs.Combat:Toggle({ Title = "Show FOV Circle",  Flag = "ShowFOVToggle", Value = false, Callback = function(s) ShowFOV = s; updateFOVCircle() end })
Tabs.Combat:Toggle({ Title = "Lock FOV To Center", Flag = "LockFOVToggle", Value = true, Callback = function(s) lockFOVToCenter = s; updateFOVCircle() end })

Tabs.Combat:Input({
    Title = "FOV Radius", Flag = "FOVRadiusInput",
    Value = "55", Placeholder = "10 - 500",
    NumbersOnly = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 10 and n <= 500 then fovRadius = n; updateFOVCircle() end
    end
})
Tabs.Combat:Colorpicker({ Title = "FOV Color", Flag = "FOVColorPicker", Default = Color3.fromRGB(0, 255, 0), Callback = function(c) FOVColor = c; updateFOVCircle() end })
Tabs.Combat:Input({
    Title = "FOV Thickness", Flag = "FOVThicknessInput",
    Value = "2", Placeholder = "1 - 10",
    NumbersOnly = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 1 and n <= 10 then FOVThickness = n; updateFOVCircle() end
    end
})

local f8Connection = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F8 and AimbotToggle then
        AimbotToggle:Set(not AimbotToggle.Value)
    end
end)

-- =========================================================
-- HITBOX
-- =========================================================
local HitboxSettings = {
    Enabled = false, Size = 10, ShowVisual = false,
    VisualColor = Color3.new(1, 0, 0),
    OriginalSizes = {}, VisualAdornments = {}
}

local function ExpandHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            if chr and HitboxSettings.Enabled then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root then
                    if HitboxSettings.OriginalSizes[plr] == nil then
                        HitboxSettings.OriginalSizes[plr] = root.Size
                    end
                    root.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                end
            end
        end
    end
end

local function UpdateVisualHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            local visual = HitboxSettings.VisualAdornments[plr]
            if chr and HitboxSettings.ShowVisual and HitboxSettings.Enabled then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root then
                    if not visual then
                        visual = Instance.new("BoxHandleAdornment")
                        visual.Adornee = root
                        visual.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        visual.Color3 = HitboxSettings.VisualColor
                        visual.Transparency = 0.3
                        visual.ZIndex = 10
                        visual.AlwaysOnTop = true
                        visual.Parent = root
                        HitboxSettings.VisualAdornments[plr] = visual
                    else
                        visual.Size = Vector3.new(HitboxSettings.Size, HitboxSettings.Size, HitboxSettings.Size)
                        visual.Color3 = HitboxSettings.VisualColor
                    end
                end
            elseif visual then
                visual:Destroy()
                HitboxSettings.VisualAdornments[plr] = nil
            end
        end
    end
end

local function ResetHitboxes()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local chr = plr.Character
            if chr then
                local root = chr:FindFirstChild("HumanoidRootPart")
                if root and HitboxSettings.OriginalSizes[plr] then
                    root.Size = HitboxSettings.OriginalSizes[plr]
                elseif root then
                    root.Size = Vector3.new(3, 3, 3)
                end
            end
        end
    end
    HitboxSettings.OriginalSizes = {}
end

local function ClearVisualAdornments()
    for _, v in pairs(HitboxSettings.VisualAdornments) do
        if v then v:Destroy() end
    end
    HitboxSettings.VisualAdornments = {}
end

local hitboxPlayerAddedConn = Players.PlayerAdded:Connect(function(plr)
    if HitboxSettings.Enabled then
        task.wait(0.5); ExpandHitboxes()
        if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
    end
    plr.CharacterAdded:Connect(function()
        if HitboxSettings.Enabled then
            task.wait(0.5); ExpandHitboxes()
            if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
        end
    end)
end)
local hitboxPlayerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
    HitboxSettings.OriginalSizes[plr] = nil
    if HitboxSettings.VisualAdornments[plr] then
        HitboxSettings.VisualAdornments[plr]:Destroy()
        HitboxSettings.VisualAdornments[plr] = nil
    end
end)
local hitboxCharAddedConns = {}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        table.insert(hitboxCharAddedConns, plr.CharacterAdded:Connect(function()
            if HitboxSettings.Enabled then
                task.wait(0.5); ExpandHitboxes()
                if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
            end
        end))
    end
end
local hitboxLoopConnection = RunService.Heartbeat:Connect(function()
    if HitboxSettings.Enabled then
        ExpandHitboxes()
        if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
    end
end)

-- =========================================================
-- VISUAL SERVER DESYNC (original Darahub)
-- =========================================================
local vsdCharacter, vsdHumanoid, vsdRoot = nil, nil, nil
local vsdParts = {}
local vsdEnabled = false
local vsdHeartbeatConn = nil

local function vsdRefresh()
    vsdCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    vsdHumanoid = vsdCharacter:WaitForChild("Humanoid")
    vsdRoot = vsdCharacter:WaitForChild("HumanoidRootPart")
    vsdParts = {}
    for _, v in pairs(vsdCharacter:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency == 0 then
            vsdParts[#vsdParts + 1] = v
        end
    end
end

local function vsdApplyTransparency(state)
    for _, v in pairs(vsdParts) do
        if state then
            v.Transparency = v.Transparency == 0 and 0.5 or 0
        else
            v.Transparency = 0
        end
    end
end

local function vsdStartHeartbeat()
    if vsdHeartbeatConn then return end
    vsdHeartbeatConn = RunService.Heartbeat:Connect(function()
        if not vsdEnabled then return end
        if not (vsdRoot and vsdRoot.Parent and vsdHumanoid and vsdHumanoid.Parent) then return end
        local savedCFrame = vsdRoot.CFrame
        local savedOffset = vsdHumanoid.CameraOffset
        local newCFrame   = savedCFrame * CFrame.new(0, 50000, 0)
        vsdRoot.CFrame = newCFrame
        vsdHumanoid.CameraOffset = newCFrame:ToObjectSpace(CFrame.new(savedCFrame.Position)).Position
        RunService.RenderStepped:Wait()
        if vsdRoot and vsdRoot.Parent and vsdHumanoid and vsdHumanoid.Parent then
            vsdRoot.CFrame = savedCFrame
            vsdHumanoid.CameraOffset = savedOffset
        end
    end)
end

local function vsdStopHeartbeat()
    if vsdHeartbeatConn then
        vsdHeartbeatConn:Disconnect()
        vsdHeartbeatConn = nil
    end
end

local function toggleVisualServerDesync(state)
    vsdEnabled = state
    if state then
        vsdApplyTransparency(true)
        vsdStartHeartbeat()
    else
        vsdApplyTransparency(false)
        vsdStopHeartbeat()
    end
end

task.spawn(vsdRefresh)

LocalPlayer.CharacterAdded:Connect(function()
    vsdEnabled = false
    vsdStopHeartbeat()
    task.wait(0.5)
    vsdRefresh()
end)

-- =========================================================
-- ANTI AFK / ANTI KILL PARTS
-- =========================================================
local antiAFKConnection = nil
local function startAntiAFK()
    if antiAFKConnection then return end
    antiAFKConnection = RunService.Heartbeat:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
local function stopAntiAFK()
    if antiAFKConnection then antiAFKConnection:Disconnect(); antiAFKConnection = nil end
end

local AntiKillPartsEnabled = false
local function toggleAntiKillParts(state)
    AntiKillPartsEnabled = state
    if state then
        coroutine.wrap(function()
            while AntiKillPartsEnabled and task.wait() do
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, part in ipairs(workspace:GetPartBoundsInRadius(hrp.Position, 10)) do
                        part.CanTouch = false
                    end
                end
            end
        end)()
    else
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, part in ipairs(workspace:GetPartBoundsInRadius(hrp.Position, 15000)) do
                part.CanTouch = true
            end
        end
    end
end

-- =========================================================
-- LIGHTING
-- =========================================================
local FullBright, NoFog, globalShadowsEnabled = false, false, false
local function setFullBright(s)
    FullBright = s
    if s then
        Lighting.Brightness        = 1
        Lighting.Ambient           = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient    = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Top    = Color3.fromRGB(255, 255, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness        = lightingSnapshot.Brightness
        Lighting.Ambient           = lightingSnapshot.Ambient
        Lighting.OutdoorAmbient    = lightingSnapshot.OutdoorAmbient
        Lighting.ColorShift_Top    = lightingSnapshot.ColorShift_Top
        Lighting.ColorShift_Bottom = lightingSnapshot.ColorShift_Bottom
    end
end
local function setNoFog(s)
    NoFog = s
    Lighting.FogEnd = s and 100000 or lightingSnapshot.FogEnd
end
local function toggleGlobalShadows(s)
    globalShadowsEnabled = s
    Lighting.GlobalShadows = s
end
local function setBrightness(v) Lighting.Brightness = v end

-- =========================================================
-- FLOATING
-- =========================================================
local floatingEnabled = false
local floatPart, floatConnection, floatBeganCon, floatEndCon, floatDiedCon
local floatUpDown = -3.1
local function toggleFloating(state)
    floatingEnabled = state
    if state then
        if not LocalPlayer.Character then return end
        local char = LocalPlayer.Character
        if not char:FindFirstChild("HumanoidRootPart") then return end
        floatPart = Instance.new("Part")
        floatPart.Name = "FloatPart"
        floatPart.Size = Vector3.new(2, 0.2, 1.5)
        floatPart.Transparency = 1
        floatPart.Anchored = true
        floatPart.CanCollide = false
        floatPart.Parent = workspace
        floatConnection = RunService.Heartbeat:Connect(function()
            if floatPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                floatPart.Position = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, floatUpDown, 0)
            end
        end)
        floatBeganCon = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Q then floatUpDown = floatUpDown - 0.5
            elseif input.KeyCode == Enum.KeyCode.E then floatUpDown = floatUpDown + 1.5 end
        end)
        floatEndCon = UserInputService.InputEnded:Connect(function(input, gp)
            if gp then return end
            if input.KeyCode == Enum.KeyCode.Q then floatUpDown = floatUpDown + 0.5
            elseif input.KeyCode == Enum.KeyCode.E then floatUpDown = floatUpDown - 1.5 end
        end)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then floatDiedCon = hum.Died:Connect(function() toggleFloating(false) end) end
    else
        if floatConnection then floatConnection:Disconnect(); floatConnection = nil end
        if floatPart then floatPart:Destroy(); floatPart = nil end
        if floatBeganCon then floatBeganCon:Disconnect(); floatBeganCon = nil end
        if floatEndCon then floatEndCon:Disconnect(); floatEndCon = nil end
        if floatDiedCon then floatDiedCon:Disconnect(); floatDiedCon = nil end
    end
end

-- =========================================================
-- GOD MODE (2 metode)
-- =========================================================
local godModeEnabled, godModeConnection = false, nil
local godModeMethod = "Health Math.huge"
local godModeAppliedMethod = nil
local godModeOriginalMaxHealth = nil

local function applyHumanoidReplacement()
    local char = LocalPlayer.Character
    local Human = char and char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    if godModeOriginalMaxHealth == nil then godModeOriginalMaxHealth = Human.MaxHealth end
    local nHuman = Human:Clone()
    nHuman.Parent = char
    LocalPlayer.Character = nil
    pcall(function()
        nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        nHuman:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
    nHuman.BreakJointsOnDeath = true
    nHuman.MaxHealth = math.huge
    nHuman.Health = math.huge
    Human:Destroy()
    LocalPlayer.Character = char
    nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local anim = char:FindFirstChild("Animate")
    if anim then
        anim.Disabled = true
        task.wait()
        anim.Disabled = false
    end
    godModeAppliedMethod = "replacement"
end

local function applyHealthMathHuge()
    local char = LocalPlayer.Character
    local Human = char and char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    if godModeOriginalMaxHealth == nil then godModeOriginalMaxHealth = Human.MaxHealth end
    Human.MaxHealth = math.huge
    Human.Health = math.huge
    godModeAppliedMethod = "health"
end

local function applyGodMode()
    if godModeMethod == "Humanoid Replacement (Very buggy)" then
        applyHumanoidReplacement()
    else
        applyHealthMathHuge()
    end
end

local function startGodMode()
    if godModeConnection then return end
    godModeConnection = RunService.Heartbeat:Connect(function()
        if godModeEnabled then
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health < math.huge then
                applyGodMode()
            end
        end
    end)
end

local function stopGodMode()
    if godModeConnection then godModeConnection:Disconnect(); godModeConnection = nil end
end

local function restoreGodMode()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    if hum and godModeOriginalMaxHealth then
        pcall(function()
            hum.MaxHealth = godModeOriginalMaxHealth
            if hum.Health > godModeOriginalMaxHealth then
                hum.Health = godModeOriginalMaxHealth
            end
        end)
    end
    godModeOriginalMaxHealth = nil
    godModeAppliedMethod = nil
end

-- =========================================================
-- ESP PLAYER & TOOL (2D + 3D box)
-- =========================================================
local playerBoxes, playerNames, playerDistance, playerHealth, playerHighlights = false, false, false, false, false
local toolBoxes, toolNames, toolDistance, toolHighlights = false, false, false, false
local playerBoxType, toolBoxType = "2D", "2D"
local playerESPData, toolESPData = {}, {}

local function getESPBoxScale(dist)
    if dist <= 17 then return 1 end
    return math.max(17 / dist, 0.013)
end

local function createESPBox(part, color)
    if not part then return nil end
    local existing = part:FindFirstChild("DaraESP_Box")
    if existing then existing:Destroy() end
    local bill = Instance.new("BillboardGui")
    bill.Name = "DaraESP_Box"
    bill.Adornee = part
    bill.Parent = part
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 60, 0, 80)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    frame.Parent = bill
    return { bill = bill, stroke = stroke }
end

local function updateESPBox(data, color, scale)
    if not data then return end
    data.bill.Size = UDim2.new(0, 60 * scale, 0, 80 * scale)
    data.stroke.Color = color
    data.stroke.Thickness = math.max(2 * scale, 1)
end

local function removeESPBox(part)
    if part then
        local b = part:FindFirstChild("DaraESP_Box")
        if b then b:Destroy() end
    end
end

local function create3DBox(part, color, size)
    if not part then return nil end
    local existing = part:FindFirstChild("DaraESP_3DBox")
    if existing then existing:Destroy() end
    local adorn = Instance.new("BoxHandleAdornment")
    adorn.Name = "DaraESP_3DBox"
    adorn.Adornee = part
    adorn.Size = size or Vector3.new(4, 5, 3)
    adorn.Color3 = color
    adorn.Transparency = 0.5
    adorn.AlwaysOnTop = true
    adorn.ZIndex = 5
    adorn.Parent = part
    return adorn
end

local function remove3DBox(part)
    if part then
        local a = part:FindFirstChild("DaraESP_3DBox")
        if a then a:Destroy() end
    end
end

local function createESPBillboard(part, color)
    if not part then return nil end
    local existing = part:FindFirstChild("DaraESP_Billboard")
    if existing then existing:Destroy() end
    local bill = Instance.new("BillboardGui")
    bill.Name = "DaraESP_Billboard"
    bill.Adornee = part
    bill.Parent = part
    bill.AlwaysOnTop = true
    bill.Size = UDim2.new(0, 220, 0, 70)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextStrokeTransparency = 0
    label.RichText = true
    label.Parent = bill
    return { bill = bill, label = label }
end

local function updateESPBillboard(data, text, color)
    if data then
        data.label.Text = text
        data.label.TextColor3 = color
    end
end

local function removeESPBillboard(part)
    if part then
        local b = part:FindFirstChild("DaraESP_Billboard")
        if b then b:Destroy() end
    end
end

local function createESPHighlight(model, color)
    local existing = model:FindFirstChild("DaraESP_Highlight")
    if existing then existing:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "DaraESP_Highlight"
    h.Adornee = model
    h.FillColor = color
    h.OutlineColor = color
    h.FillTransparency = 0.5
    h.OutlineTransparency = 0.3
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = model
    return h
end

local function removeESPHighlight(model)
    local h = model:FindFirstChild("DaraESP_Highlight")
    if h then h:Destroy() end
end

local function updatePlayerESP()
    if not workspace.CurrentCamera then return end
    local alive = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if char and hrp and hum and hum.Health > 0 then
                alive[char] = true
                local data = playerESPData[char]
                if not data then data = {}; playerESPData[char] = data end
                local dist = (hrp.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                local scale = getESPBoxScale(dist)
                local color = (plr.TeamColor and plr.TeamColor.Color) or Color3.fromRGB(255, 255, 255)

                if playerBoxes then
                    if playerBoxType == "2D" then
                        if not data.box2D then data.box2D = createESPBox(hrp, color) end
                        updateESPBox(data.box2D, color, scale)
                        if data.box3D then remove3DBox(hrp); data.box3D = nil end
                    else
                        if data.box2D then removeESPBox(hrp); data.box2D = nil end
                        local boxSize = Vector3.new(4, (hum.HipHeight or 2) + 5, 3)
                        if not data.box3D then data.box3D = create3DBox(hrp, color, boxSize) end
                        if data.box3D then
                            data.box3D.Color3 = color
                            data.box3D.Size = boxSize
                        end
                    end
                else
                    if data.box2D then removeESPBox(hrp); data.box2D = nil end
                    if data.box3D then remove3DBox(hrp); data.box3D = nil end
                end

                if playerHighlights then
                    if not data.highlight then data.highlight = createESPHighlight(char, color) end
                    data.highlight.FillColor = color
                    data.highlight.OutlineColor = color
                elseif data.highlight then
                    removeESPHighlight(char); data.highlight = nil
                end

                local needBill = playerNames or playerDistance or playerHealth
                if needBill then
                    if not data.bill then data.bill = createESPBillboard(hrp, color) end
                    local lines = {}
                    if playerNames    then table.insert(lines, plr.Name) end
                    if playerDistance then table.insert(lines, string.format("Distance: %.0f", dist)) end
                    if playerHealth   then table.insert(lines, string.format("Health: %.0f/%.0f", hum.Health, hum.MaxHealth)) end
                    updateESPBillboard(data.bill, table.concat(lines, "\n"), color)
                elseif data.bill then
                    removeESPBillboard(hrp); data.bill = nil
                end
            end
        end
    end
    for char, data in pairs(playerESPData) do
        if not alive[char] then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if data.box2D then removeESPBox(hrp) end
            if data.box3D then remove3DBox(hrp) end
            if data.highlight then removeESPHighlight(char) end
            if data.bill then removeESPBillboard(hrp) end
            playerESPData[char] = nil
        end
    end
end

local function findAllTools()
    local tools = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local h = obj:FindFirstChild("Handle")
            if h then table.insert(tools, { tool = obj, part = h }) end
        elseif obj:IsA("Model") and not obj:FindFirstChildOfClass("Humanoid") then
            local h = obj:FindFirstChild("Handle")
            if h then table.insert(tools, { tool = obj, part = h }) end
        end
    end
    return tools
end

local function updateToolESP()
    if not workspace.CurrentCamera then return end
    local alive = {}
    for _, entry in ipairs(findAllTools()) do
        local tool, part = entry.tool, entry.part
        if tool and part and part:IsA("BasePart") then
            alive[tool] = true
            local data = toolESPData[tool]
            if not data then data = {}; toolESPData[tool] = data end
            data.part = part
            local dist  = (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
            local scale = getESPBoxScale(dist)
            local color = Color3.fromRGB(0, 255, 255)

            if toolBoxes then
                if toolBoxType == "2D" then
                    if not data.box2D then data.box2D = createESPBox(part, color) end
                    updateESPBox(data.box2D, color, scale)
                    if data.box3D then remove3DBox(part); data.box3D = nil end
                else
                    if data.box2D then removeESPBox(part); data.box2D = nil end
                    if not data.box3D then
                        data.box3D = create3DBox(part, color, Vector3.new(part.Size.X, part.Size.Y, part.Size.Z))
                    end
                    if data.box3D then data.box3D.Color3 = color end
                end
            else
                if data.box2D then removeESPBox(part); data.box2D = nil end
                if data.box3D then remove3DBox(part); data.box3D = nil end
            end

            if toolHighlights then
                if not data.highlight then data.highlight = createESPHighlight(tool, color) end
                data.highlight.FillColor = color
                data.highlight.OutlineColor = color
            elseif data.highlight then
                removeESPHighlight(tool); data.highlight = nil
            end

            local needBill = toolNames or toolDistance
            if needBill then
                if not data.bill then data.bill = createESPBillboard(part, color) end
                local lines = {}
                if toolNames    then table.insert(lines, tool.Name) end
                if toolDistance then table.insert(lines, string.format("Distance: %.0f", dist)) end
                updateESPBillboard(data.bill, table.concat(lines, "\n"), color)
            elseif data.bill then
                removeESPBillboard(part); data.bill = nil
            end
        end
    end
    for tool, data in pairs(toolESPData) do
        if not alive[tool] then
            if data.box2D and data.part then removeESPBox(data.part) end
            if data.box3D and data.part then remove3DBox(data.part) end
            if data.highlight then removeESPHighlight(tool) end
            if data.bill and data.part then removeESPBillboard(data.part) end
            toolESPData[tool] = nil
        end
    end
end

local function cleanupPlayerESP()
    for char, data in pairs(playerESPData) do
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if data.box2D then removeESPBox(hrp) end
        if data.box3D then remove3DBox(hrp) end
        if data.highlight then removeESPHighlight(char) end
        if data.bill then removeESPBillboard(hrp) end
    end
    playerESPData = {}
end

local function cleanupToolESP()
    for tool, data in pairs(toolESPData) do
        if data.box2D and data.part then removeESPBox(data.part) end
        if data.box3D and data.part then remove3DBox(data.part) end
        if data.highlight then removeESPHighlight(tool) end
        if data.bill and data.part then removeESPBillboard(data.part) end
    end
    toolESPData = {}
end

local espRenderConnection = RunService.RenderStepped:Connect(function()
    if playerBoxes or playerNames or playerDistance or playerHealth or playerHighlights then
        updatePlayerESP()
    else
        cleanupPlayerESP()
    end
    if toolBoxes or toolNames or toolDistance or toolHighlights then
        updateToolESP()
    else
        cleanupToolESP()
    end
end)

-- =========================================================
-- FORCE UNLOCK MOUSE (HOLD LEFT ALT)
-- =========================================================
local mouseUnlockConnection = nil
local isHoldingAlt = false

local function startMouseUnlock()
    if isHoldingAlt then return end
    isHoldingAlt = true
    if mouseUnlockConnection then mouseUnlockConnection:Disconnect() end
    pcall(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
    mouseUnlockConnection = RunService.Heartbeat:Connect(function()
        if isHoldingAlt then
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            end)
        end
    end)
end

local function stopMouseUnlock()
    if not isHoldingAlt then return end
    isHoldingAlt = false
    if mouseUnlockConnection then
        mouseUnlockConnection:Disconnect()
        mouseUnlockConnection = nil
    end
end

local altBeginConn = UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        startMouseUnlock()
    end
end)

local altEndConn = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        stopMouseUnlock()
    end
end)

-- =========================================================
-- UI: VISUALS
-- =========================================================
Tabs.Visuals:Section({ Title = "Lighting" })
Tabs.Visuals:Toggle({ Title = "Full Bright", Value = false, Callback = function(s) setFullBright(s) end })
Tabs.Visuals:Toggle({ Title = "No Fog",      Value = false, Callback = function(s) setNoFog(s) end })
Tabs.Visuals:Toggle({ Title = "Global Shadows", Value = false, Callback = function(s) toggleGlobalShadows(s) end })
Tabs.Visuals:Input({
    Title = "Brightness", Flag = "BrightnessInput",
    Value = "1", Placeholder = "0 - 10",
    NumbersOnly = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 0 and n <= 10 then setBrightness(n) end
    end
})

-- =========================================================
-- UI: PLAYER
-- =========================================================
Tabs.Player:Section({ Title = "Player" })
Tabs.Player:Toggle({
    Title = "Floating", Desc = "Q = turun, E = naik", Value = false,
    Callback = function(s) toggleFloating(s) end
})

GodModeToggle = Tabs.Player:Toggle({
    Title = "God Mode", Value = false,
    Callback = function(s)
        godModeEnabled = s
        if s then applyGodMode(); startGodMode()
        else stopGodMode(); restoreGodMode() end
    end
})
Tabs.Player:Dropdown({
    Title = "God Mode Method", Flag = "GodModeMethodDropdown",
    Values = { "Health Math.huge", "Humanoid Replacement (Very buggy)" },
    Value = "Health Math.huge",
    Callback = function(v)
        godModeMethod = v
        if godModeEnabled then
            stopGodMode()
            applyGodMode()
            startGodMode()
        end
    end
})

-- =========================================================
-- UI: MISC
-- =========================================================
Tabs.Misc:Section({ Title = "Misc" })
Tabs.Misc:Toggle({ Title = "Anti AFK", Value = false, Callback = function(s) if s then startAntiAFK() else stopAntiAFK() end end })
Tabs.Misc:Toggle({ Title = "Anti Kill Parts", Value = false, Callback = function(s) toggleAntiKillParts(s) end })
Tabs.Misc:Toggle({
    Title = "Visual Server Desync",
    Desc = "Desync visual/server + karakter semi-transparan",
    Value = false,
    Callback = function(s) toggleVisualServerDesync(s) end
})

Tabs.Misc:Section({ Title = "Hitbox" })
Tabs.Misc:Toggle({
    Title = "Hitbox Expanding", Value = false,
    Callback = function(s)
        HitboxSettings.Enabled = s
        if s then ExpandHitboxes(); if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
        else ResetHitboxes(); ClearVisualAdornments() end
    end
})
Tabs.Misc:Input({
    Title = "Hitbox Size", Flag = "HitboxSizeInput",
    Value = "10", Placeholder = "3 - 30",
    NumbersOnly = true,
    Callback = function(v)
        local n = tonumber(v)
        if n and n >= 3 and n <= 30 then
            HitboxSettings.Size = n
            if HitboxSettings.Enabled then
                ExpandHitboxes()
                if HitboxSettings.ShowVisual then UpdateVisualHitboxes() end
            end
        end
    end
})
Tabs.Misc:Toggle({
    Title = "Show Hitbox", Value = false,
    Callback = function(s)
        HitboxSettings.ShowVisual = s
        if s and HitboxSettings.Enabled then UpdateVisualHitboxes()
        elseif not s then ClearVisualAdornments() end
    end
})
Tabs.Misc:Colorpicker({
    Title = "Hitbox Color", Default = Color3.new(1, 0, 0),
    Callback = function(c)
        HitboxSettings.VisualColor = c
        if HitboxSettings.ShowVisual and HitboxSettings.Enabled then UpdateVisualHitboxes() end
    end
})

Tabs.Misc:Section({ Title = "UI Settings" })
Tabs.Misc:Button({
    Title = "Hide UI",
    Desc = "Tekan RightControl untuk show lagi / klik OpenButton",
    Callback = function()
        pcall(function() Window:Close() end)
    end
})
Tabs.Misc:Keybind({
    Title = "Toggle UI",
    Desc = "Keybind untuk show/hide UI",
    Value = "RightControl",
    Callback = function(v)
        if v and Enum.KeyCode[v] then
            Window:SetToggleKey(Enum.KeyCode[v])
        end
    end
})

-- =========================================================
-- UI: ESP
-- =========================================================
Tabs.ESP:Section({ Title = "Player ESP" })
Tabs.ESP:Toggle({ Title = "Player Boxes",      Value = false, Callback = function(s) playerBoxes = s end })
Tabs.ESP:Dropdown({
    Title = "Player Box Type", Flag = "PlayerBoxTypeDropdown",
    Values = { "2D", "3D" }, Value = "2D",
    Callback = function(v) playerBoxType = v end
})
Tabs.ESP:Toggle({ Title = "Player Names",      Value = false, Callback = function(s) playerNames = s end })
Tabs.ESP:Toggle({ Title = "Player Distance",   Value = false, Callback = function(s) playerDistance = s end })
Tabs.ESP:Toggle({ Title = "Player Health",     Value = false, Callback = function(s) playerHealth = s end })
Tabs.ESP:Toggle({ Title = "Player Highlights", Value = false, Callback = function(s) playerHighlights = s end })

Tabs.ESP:Section({ Title = "Tool ESP" })
Tabs.ESP:Toggle({ Title = "Tool Boxes",      Value = false, Callback = function(s) toolBoxes = s end })
Tabs.ESP:Dropdown({
    Title = "Tool Box Type", Flag = "ToolBoxTypeDropdown",
    Values = { "2D", "3D" }, Value = "2D",
    Callback = function(v) toolBoxType = v end
})
Tabs.ESP:Toggle({ Title = "Tool Names",      Value = false, Callback = function(s) toolNames = s end })
Tabs.ESP:Toggle({ Title = "Tool Distance",   Value = false, Callback = function(s) toolDistance = s end })
Tabs.ESP:Toggle({ Title = "Tool Highlights", Value = false, Callback = function(s) toolHighlights = s end })

-- =========================================================
-- FULL CLEANUP (dipanggil saat reload / OnDestroy)
-- =========================================================
local function fullCleanup()
    AimbotEnabled = false
    pcall(stopAimbot)
    if f8Connection then pcall(function() f8Connection:Disconnect() end); f8Connection = nil end

    HitboxSettings.Enabled = false
    pcall(ResetHitboxes)
    pcall(ClearVisualAdornments)
    if hitboxLoopConnection       then pcall(function() hitboxLoopConnection:Disconnect() end); hitboxLoopConnection = nil end
    if hitboxPlayerAddedConn      then pcall(function() hitboxPlayerAddedConn:Disconnect() end); hitboxPlayerAddedConn = nil end
    if hitboxPlayerRemovingConn   then pcall(function() hitboxPlayerRemovingConn:Disconnect() end); hitboxPlayerRemovingConn = nil end
    for _, c in ipairs(hitboxCharAddedConns) do pcall(function() c:Disconnect() end) end
    hitboxCharAddedConns = {}

    -- Visual Server Desync cleanup
    vsdEnabled = false
    pcall(function() vsdApplyTransparency(false) end)
    pcall(vsdStopHeartbeat)

    pcall(stopAntiAFK)
    if AntiKillPartsEnabled then pcall(function() toggleAntiKillParts(false) end) end

    pcall(function()
        Lighting.Brightness        = lightingSnapshot.Brightness
        Lighting.Ambient           = lightingSnapshot.Ambient
        Lighting.OutdoorAmbient    = lightingSnapshot.OutdoorAmbient
        Lighting.ColorShift_Top    = lightingSnapshot.ColorShift_Top
        Lighting.ColorShift_Bottom = lightingSnapshot.ColorShift_Bottom
        Lighting.FogEnd            = lightingSnapshot.FogEnd
        Lighting.GlobalShadows     = lightingSnapshot.GlobalShadows
    end)
    FullBright, NoFog, globalShadowsEnabled = false, false, false

    if floatingEnabled then pcall(function() toggleFloating(false) end) end

    godModeEnabled = false
    pcall(stopGodMode)
    pcall(restoreGodMode)

    pcall(cleanupPlayerESP)
    pcall(cleanupToolESP)
    if espRenderConnection then pcall(function() espRenderConnection:Disconnect() end); espRenderConnection = nil end

    isHoldingAlt = false
    if mouseUnlockConnection then pcall(function() mouseUnlockConnection:Disconnect() end); mouseUnlockConnection = nil end
    if altBeginConn        then pcall(function() altBeginConn:Disconnect() end); altBeginConn = nil end
    if altEndConn          then pcall(function() altEndConn:Disconnect() end); altEndConn = nil end
    pcall(function() UserInputService.MouseBehavior = Enum.MouseBehavior.Default end)

    pcall(function() Window:Destroy() end)
    pcall(function()
        local g = CoreGui:FindFirstChild("Darahub")
        if g then g:Destroy() end
    end)
end

getgenv().DaraHubCleanup = fullCleanup

Window:OnDestroy(function()
    pcall(fullCleanup)
end)
