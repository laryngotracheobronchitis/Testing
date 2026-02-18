-- bLockerman's Minesweeper Auto Solver + Smart Teleport
-- Fixed UI Drag and Open System

if game:GetService("RunService"):IsStudio() or (game.PlaceId ~= 7871169780 and game.PlaceId ~= 9797651295) then
    -- warn("nice game")
end

local v1 = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")

if v1:GetAttribute("gay") then
    return
end

v1:SetAttribute("gay", true)

task.spawn(function() task.wait(0) end)

local P = v1
local c = Color3.fromRGB
local v = Vector2.new
local u = UDim2.new
local N = NumberSequence.new
local K = NumberSequenceKeypoint.new
local F = Font.new

local function n(t, p, x)
    local o = Instance.new(t)
    if p then o.Parent = p end
    if x then
        for k, w in pairs(x) do
            pcall(function() o[k] = w end)
        end
    end
    return o
end

local s = n("ScreenGui", P, {
    DisplayOrder = 999999,
    Name = "MinesweeperHelperFixed",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false,
    Enabled = true
})

-- Main Open Button (Floating)
local open = n("TextButton", s, {
    Name = "OpenButton",
    Text = "💣",
    TextSize = 24,
    TextColor3 = c(255, 255, 255),
    Font = Enum.Font.SourceSansBold,
    BackgroundColor3 = c(40, 40, 40),
    BorderSizePixel = 2,
    BorderColor3 = c(100, 100, 100),
    Size = u(0, 50, 0, 50),
    Position = u(1, -60, 1, -60),
    AnchorPoint = v(1, 1),
    ZIndex = 100,
    Active = true,
    Draggable = false -- We'll handle drag manually
})

n("UICorner", open, { CornerRadius = UDim.new(0.2, 0) })

-- Drag handle for open button
local dragHandle = n("Frame", open, {
    Name = "DragHandle",
    Size = u(1, 0, 0.3, 0),
    Position = u(0, 0, 0, 0),
    BackgroundTransparency = 0.8,
    BackgroundColor3 = c(100, 100, 100),
    ZIndex = 101
})

-- Main Panel
local panel = n("Frame", s, {
    Name = "MainPanel",
    Visible = false,
    BackgroundColor3 = c(20, 20, 20),
    BorderSizePixel = 0,
    Size = u(0, 550, 0, 400),
    Position = u(0.5, -275, 0.5, -200),
    AnchorPoint = v(0, 0),
    ZIndex = 50,
    Active = true
})

n("UICorner", panel, { CornerRadius = UDim.new(0.02, 0) })

-- Title Bar (for dragging panel)
local titleBar = n("Frame", panel, {
    Name = "TitleBar",
    Size = u(1, 0, 0, 35),
    BackgroundColor3 = c(30, 30, 30),
    BorderSizePixel = 0,
    ZIndex = 51
})

n("UICorner", titleBar, { CornerRadius = UDim.new(0.02, 0) })

local titleLabel = n("TextLabel", titleBar, {
    Text = "🎯 Minesweeper Auto Solver",
    Size = u(0.6, 0, 1, 0),
    Position = u(0.02, 0, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = c(255, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 52
})

-- Close Button
local closeBtn = n("TextButton", titleBar, {
    Name = "CloseBtn",
    Text = "✕",
    Size = u(0, 30, 0, 30),
    Position = u(1, -35, 0.5, -15),
    AnchorPoint = v(0, 0),
    BackgroundColor3 = c(200, 50, 50),
    TextColor3 = c(255, 255, 255),
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    ZIndex = 52
})

n("UICorner", closeBtn, { CornerRadius = UDim.new(0.3, 0) })

-- Content Frame
local content = n("Frame", panel, {
    Name = "Content",
    Size = u(1, -20, 1, -55),
    Position = u(0, 10, 0, 40),
    BackgroundTransparency = 1,
    ZIndex = 51
})

-- Status Label
local statusLabel = n("TextLabel", content, {
    Text = "Status: Ready - Click Auto Run to start",
    Size = u(1, 0, 0, 25),
    Position = u(0, 0, 0, 0),
    BackgroundTransparency = 1,
    TextColor3 = c(100, 255, 100),
    Font = Enum.Font.SourceSansBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51
})

local guessStatusLabel = n("TextLabel", content, {
    Text = "Guess Mode: OFF (Safe Only)",
    Size = u(1, 0, 0, 20),
    Position = u(0, 0, 0, 25),
    BackgroundTransparency = 1,
    TextColor3 = c(255, 100, 100),
    Font = Enum.Font.SourceSansBold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 51
})

-- Button Container
local btnContainer = n("Frame", content, {
    Size = u(0.5, -10, 0, 200),
    Position = u(0, 0, 0, 55),
    BackgroundTransparency = 1,
    ZIndex = 51
})

-- Create Toggle Button Function
local function createToggle(parent, name, label, yPos, defaultState)
    local btn = n("TextButton", parent, {
        Name = name,
        Text = label .. ": OFF",
        Size = u(1, 0, 0, 35),
        Position = u(0, 0, 0, yPos),
        BackgroundColor3 = c(60, 60, 60),
        TextColor3 = c(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        TextSize = 14,
        ZIndex = 52
    })
    n("UICorner", btn, { CornerRadius = UDim.new(0.1, 0) })
    
    local state = defaultState or false
    
    local function updateVisual()
        if state then
            btn.BackgroundColor3 = c(50, 150, 50)
            btn.Text = label .. ": ON"
        else
            btn.BackgroundColor3 = c(150, 50, 50)
            btn.Text = label .. ": OFF"
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if pushState then pushState() end
    end)
    
    updateVisual()
    
    return {
        btn = btn,
        getState = function() return state end,
        setState = function(newState)
            state = newState
            updateVisual()
        end
    }
end

-- Create Toggles
local btnScript = createToggle(btnContainer, "btnScript", "🤖 Auto Run + Flag", 0, false)
local btnRange = createToggle(btnContainer, "btnRange", "👁️ Visual Range", 45, false)
local btnRot = createToggle(btnContainer, "btnRot", "🔄 Rotation", 90, false)
local btnGuess = createToggle(btnContainer, "btnGuess", "🎲 Auto Guess", 135, false)

-- Input Container
local inputContainer = n("Frame", content, {
    Size = u(0.5, -10, 0, 200),
    Position = u(0.5, 10, 0, 55),
    BackgroundTransparency = 1,
    ZIndex = 51
})

-- Create Input Function
local function createInput(parent, name, label, yPos, defaultValue)
    local lbl = n("TextLabel", parent, {
        Text = label,
        Size = u(0.4, 0, 0, 20),
        Position = u(0, 0, 0, yPos),
        BackgroundTransparency = 1,
        TextColor3 = c(200, 200, 200),
        Font = Enum.Font.SourceSans,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52
    })
    
    local box = n("TextBox", parent, {
        Name = name,
        Text = tostring(defaultValue),
        PlaceholderText = defaultValue,
        Size = u(0.55, 0, 0, 25),
        Position = u(0.45, 0, 0, yPos - 2),
        BackgroundColor3 = c(40, 40, 40),
        TextColor3 = c(255, 255, 255),
        Font = Enum.Font.SourceSans,
        TextSize = 12,
        ClearTextOnFocus = false,
        ZIndex = 52
    })
    n("UICorner", box, { CornerRadius = UDim.new(0.1, 0) })
    n("UIPadding", box, { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) })
    
    box.FocusLost:Connect(function()
        if pushState then pushState() end
    end)
    
    return box
end

-- Inputs
local boxMax = createInput(inputContainer, "max", "Max Cluster:", 0, "5000")
local boxUS = createInput(inputContainer, "uspeed", "Update Spd:", 35, "0.1")
local boxPS = createInput(inputContainer, "pspeed", "Process Spd:", 70, "1")
local boxR = createInput(inputContainer, "r", "Visual Range:", 105, "100")
local boxF = createInput(inputContainer, "f", "Flag Range:", 140, "16")
local boxFS = createInput(inputContainer, "fspeed", "Flag Spd:", 175, "0.05")

-- Info Label
local infoLabel = n("TextLabel", content, {
    Text = "💡 Auto Run = Solver + Auto Flag | Guess = Risk Mode",
    Size = u(1, 0, 0, 20),
    Position = u(0, 0, 1, -25),
    BackgroundTransparency = 1,
    TextColor3 = c(150, 150, 150),
    Font = Enum.Font.SourceSansItalic,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 51
})

-- ============================================
-- DRAG SYSTEM (BOTH BUTTON AND PANEL)
-- ============================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Panel Drag Variables
local panelDragging = false
local panelDragStart = nil
local panelStartPos = nil

-- Open Button Drag Variables
local openDragging = false
local openDragStart = nil
local openStartPos = nil

-- Panel Drag
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        panelDragging = true
        panelDragStart = input.Position
        panelStartPos = panel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                panelDragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if panelDragging then
            local delta = input.Position - panelDragStart
            panel.Position = UDim2.new(
                panelStartPos.X.Scale,
                panelStartPos.X.Offset + delta.X,
                panelStartPos.Y.Scale,
                panelStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

-- Open Button Drag (only on drag handle)
dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = open.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                openDragging = false
            end
        end)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if openDragging then
            local delta = input.Position - openDragStart
            open.Position = UDim2.new(
                openStartPos.X.Scale,
                openStartPos.X.Offset + delta.X,
                openStartPos.Y.Scale,
                openStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

-- Open Button Click (not drag)
local clickStartTime = 0
open.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        clickStartTime = tick()
    end
end)

open.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local clickDuration = tick() - clickStartTime
        -- If click was short and we weren't dragging, toggle panel
        if clickDuration < 0.3 and not openDragging then
            panel.Visible = not panel.Visible
            -- Animate
            if panel.Visible then
                panel.Size = u(0, 0, 0, 0)
                TweenService:Create(panel, TweenInfo.new(0.2), {
                    Size = u(0, 550, 0, 400)
                }):Play()
            end
        end
    end
end)

-- Close Button
closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- ============================================
-- SOLVER LOGIC (SAME AS BEFORE)
-- ============================================

local B = "Flags status"
local state = { b = false, c = 0, d = nil, guessMode = false }

local function e(vv)
    if type(vv) == "boolean" then return vv end
    if type(vv) == "string" then
        local s0 = vv:lower()
        return (s0 == "enable" or s0 == "on" or s0 == "true" or s0 == "start")
    end
    return vv and true or false
end

local function tonum(sv)
    if not sv then return nil end
    sv = tostring(sv):match("^%s*(.-)%s*$")
    return tonumber(sv)
end

-- Safe teleport function
local function safeTeleport(safeTiles, playerRoot)
    if not safeTiles or #safeTiles == 0 or not playerRoot then return false end
    
    table.sort(safeTiles, function(a, b)
        local distA = (a.position - playerRoot.Position).Magnitude
        local distB = (b.position - playerRoot.Position).Magnitude
        return distA < distB
    end)
    
    for _, tileData in ipairs(safeTiles) do
        if tileData.prob <= 0.01 then
            pcall(function()
                playerRoot.CFrame = CFrame.new(tileData.part.Position + Vector3.new(0, 3.5, 0))
            end)
            return true, tileData
        end
    end
    return false, nil
end

-- Find best guess
local function findBestGuess(allCoveredTiles, playerRoot)
    if not allCoveredTiles or #allCoveredTiles == 0 or not playerRoot then return nil end
    
    table.sort(allCoveredTiles, function(a, b)
        return a.prob < b.prob
    end)
    
    return allCoveredTiles[1]
end

-- Auto click
local function autoClickTile(tileData, playerRoot)
    if not tileData or not tileData.part or not playerRoot then return end
    
    local part = tileData.part
    if part.Parent then
        local cd = part:FindFirstChildOfClass("ClickDetector", true)
        if cd then
            local alreadyClicked = part:GetAttribute("AutoClicked")
            if not alreadyClicked then
                pcall(function()
                    fireclickdetector(cd)
                    part:SetAttribute("AutoClicked", true)
                end)
                return true
            end
        end
    end
    return false
end

-- Main Solver Function
function S(t, a1, c1, d1, f1, g1, h1, x1, v1, n1, y1, guessEnabled)
    local i = state
    local j = e(t)
    
    local function k()
        local cg = game.CoreGui
        if cg then
            local p0 = cg:FindFirstChild(B)
            if p0 then p0:Destroy() end
        end
    end
    
    local rotOn, rotOpt
    if type(y1) == "table" then
        rotOn = e(y1.on == nil and true or y1.on)
        rotOpt = y1
    else
        rotOn = e(y1)
    end
    
    i.guessMode = e(guessEnabled)
    
    i.d = {
        r = tonumber(c1) or 0.2,
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 1000, y = tonumber(a1) or 1000 },
        ac = { on = true, rad = tonumber(v1) or 16, intv = tonumber(n1) or 0.05 },
        rot = {
            on = rotOn == nil and false or rotOn,
            ro = tonumber(rotOpt and rotOpt.ro) or 180,
            tN = math.max(1, tonumber(rotOpt and rotOpt.tN or 1)),
            uR = (rotOpt and rotOpt.uR == false) and false or true
        }
    }
    
    if not j then
        i.c = i.c + 1
        i.b = false
        k()
        return
    end
    
    i.c = i.c + 1
    local q = i.c
    i.b = true
    
    -- Update status
    pcall(function()
        statusLabel.Text = "Status: Running"
        statusLabel.TextColor3 = c(100, 255, 100)
        if i.guessMode then
            guessStatusLabel.Text = "Guess Mode: ON (Risk Mode)"
            guessStatusLabel.TextColor3 = c(255, 200, 100)
        else
            guessStatusLabel.Text = "Guess Mode: OFF (Safe Only)"
            guessStatusLabel.TextColor3 = c(100, 255, 100)
        end
    end)
    
    task.spawn(function()
        local r = i.d.r
        local s2 = i.d.s
        local t2 = i.d.t
        local u2 = i.d.u
        local vb = i.d.vb
        local w2 = i.d.w
        local ac = i.d.ac
        local rot = i.d.rot
        local guessMode = i.guessMode
        
        -- Auto Flag Thread
        task.spawn(function()
            local l = game:GetService("Players")
            while state and state.b and state.c == q do
                local lp = l.LocalPlayer
                local char = lp and lp.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                local cg = game.CoreGui
                pcall(function()
                    cg = game:FindFirstChildOfClass("CoreGui") or game:GetService("CoreGui")
                end)
                local overlays = cg and cg:FindFirstChild(B)
                if root and overlays then
                    for _, sg2 in ipairs(overlays:GetChildren()) do
                        if sg2:IsA("SurfaceGui") and sg2.Adornee and sg2.Adornee:IsA("BasePart") then
                            local lbl = sg2:FindFirstChild("ValueText")
                            if lbl and lbl:IsA("TextLabel") and lbl.Text == utf8.char(0x1F4A5) then
                                local part = sg2.Adornee
                                if (part.Position - root.Position).Magnitude <= ac.rad then
                                    local isFlagged = false
                                    for _, child in ipairs(part:GetChildren()) do
                                        if child.Name:lower():find("flag") or child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                                            isFlagged = true
                                            break
                                        end
                                    end
                                    if not isFlagged then
                                        local cd = part:FindFirstChildOfClass("ClickDetector", true)
                                        if cd then
                                            local alreadyClicked = part:GetAttribute("AutoClicked")
                                            if not alreadyClicked then
                                                pcall(function()
                                                    fireclickdetector(cd)
                                                    part:SetAttribute("AutoClicked", true)
                                                end)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(ac.intv)
            end
        end)
        
        -- Solver Variables
        local z = 1e-4
        local A2 = 1e-6
        local A3 = { a = 0, b = nil, c = nil, d = 1, e = nil, f = nil, g = nil, h = 0, i = 0, j = nil, k = 0.5 }
        local A4 = {}
        local lastSeenRun = setmetatable({}, { __mode = "k" })
        local l = game:GetService("Players")
        local A5 = game:GetService("Workspace")
        local cg = game.CoreGui
        local guiCache = {}
        local updateThrottle = 0
        local THROTTLE_INTERVAL = 0.05
        local lastTeleportTime = 0
        local TELEPORT_COOLDOWN = 0.5
        
        local function A6()
            local parent = cg or A5
            local p2 = parent:FindFirstChild(B)
            if not p2 then
                p2 = Instance.new("Folder")
                p2.Name = B
                p2.Parent = parent
            end
            return p2
        end
        
        local function T1(sv)
            if type(sv) ~= "string" then return nil end
            local d = sv:match("(%d)")
            return d and tonumber(d) or nil
        end
        
        local function A7(a2) 
            a2 = tonumber(a2) or 0 
            if a2 < 0 then return 0 elseif a2 > 1 then return 1 else return a2 end 
        end
        
        local function A8(pv) 
            pv = A7(pv) 
            if pv <= 0.5 then 
                local q0 = pv / 0.5 
                return Color3.fromRGB(math.floor(250 * q0 + 0.5), 250, 0) 
            else 
                local q0 = (pv - 0.5) / 0.5 
                return Color3.fromRGB(255, math.floor(250 * (1 - q0) + 0.5), 0) 
            end 
        end
        
        local function B0(r0, c0) return tostring(r0) .. ":" .. tostring(c0) end
        local function B1(gx, gy) return tostring(gx) .. ":" .. tostring(gy) end
        
        local function B3(r0, c0, Hn, Wn)
            local o0, i1 = {}, 1
            for dr = -1, 1 do
                for dc = -1, 1 do
                    if not (dr == 0 and dc == 0) then
                        local rr, cc = r0 + dr, c0 + dc
                        if rr >= 1 and rr <= Hn and cc >= 1 and cc <= Wn then
                            o0[i1] = { rr, cc }
                            i1 = i1 + 1
                        end
                    end
                end
            end
            return o0
        end
        
        local function B4(p0) return tostring(p0:GetDebugId()) end
        
        local function B5(Fo, part, G)
            if not (part and part:IsA("BasePart")) then return nil end
            local H = B4(part)
            local I = guiCache[H]
            if not I or not I.Parent then
                I = Fo:FindFirstChild(H)
                if not I then
                    I = Instance.new("SurfaceGui")
                    I.Name = H
                    I.AlwaysOnTop = true
                    I.LightInfluence = 0
                    pcall(function()
                        I.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
                        I.PixelsPerStud = 25
                    end)
                    I.Face = Enum.NormalId.Top
                    I.Parent = Fo
                    I.Adornee = part
                end
                guiCache[H] = I
            end
            
            if I.Adornee ~= part then I.Adornee = part end
            if I.Face ~= Enum.NormalId.Top then I.Face = Enum.NormalId.Top end
            lastSeenRun[I] = G
            
            local J = I:FindFirstChild("ValueText")
            if not (J and J:IsA("TextLabel")) then
                for _, K2 in ipairs(I:GetChildren()) do
                    if K2:IsA("TextLabel") then K2:Destroy() end
                end
                J = Instance.new("TextLabel")
                J.Name = "ValueText"
                J.Size = UDim2.fromScale(1, 1)
                J.Position = UDim2.fromScale(0, 0)
                J.BackgroundTransparency = 1
                J.TextSize = 60
                J.TextWrapped = false
                J.Font = t2
                J.Text = ""
                J.TextColor3 = Color3.fromRGB(255, 255, 255)
                J.TextStrokeTransparency = 0
                J.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                J.Parent = I
            end
            I.Enabled, J.Visible = true, true
            return I, J
        end
        
        local function GridIndex(vDelta, cell, tol)
            tol = math.clamp(tol or .25, 0, .49)
            local raw = vDelta / cell
            local idx = math.floor(raw + 0.5)
            if math.abs(raw - idx) > 0.5 + tol then
                idx = idx + (raw > idx and 1 or -1)
            end
            return idx
        end
        
        local function fd()
            local w = game:GetService("Workspace")
            local d = w:FindFirstChild("Flag")
            if d then
                local u = d:FindFirstChild("Parts")
                if u and u:IsA("Folder") then return u end
            end
            local p = w:FindFirstChild("Parts", true)
            if p and p:IsA("Folder") then return p end
            local b, bC = nil, -1
            for _, i in ipairs(w:GetDescendants()) do
                if i:IsA("Folder") and i.Name == "Parts" then
                    local c = 0
                    for _, ch in ipairs(i:GetChildren()) do
                        if ch:IsA("BasePart") then c += 1 end
                    end
                    if c > bC then b, bC = i, c end
                end
            end
            return b
        end
        
        local lastAction = ""
        
        local function B6()
            if not (state and state.b and state.c) then return end
            local currentTime = tick()
            if currentTime - updateThrottle < THROTTLE_INTERVAL then
                return
            end
            updateThrottle = currentTime
            
            local L = fd()
            if not L then 
                pcall(function()
                    statusLabel.Text = "Status: No Board Found"
                    statusLabel.TextColor3 = c(255, 100, 100)
                end)
                return 
            end
            
            local lp = l.LocalPlayer
            local char = lp and lp.Character
            local playerRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            
            local o0 = l.LocalPlayer
            local M = nil
            if o0 and o0.Character then
                M = o0.Character:FindFirstChild("HumanoidRootPart") or o0.Character:FindFirstChild("Torso")
            end
            if vb and u2 and u2 > 0 and not M then return end
            local N = vb and (u2 and u2 > 0 and M ~= nil)
            local O = N and (u2 * u2) or nil
            local P = {}
            local Q = tick()
            local partsToProcess = L:GetChildren()
            
            for _, R in ipairs(partsToProcess) do
                if R:IsA("BasePart") and (R.Anchored ~= false) then
                    local S3 = false
                    if N then
                        local T = (R.Position - M.Position)
                        if T:Dot(T) > O then S3 = true end
                    end
                    if not S3 then
                        local U = R:GetDebugId()
                        local V = A4[U]
                        if not V then
                            local W
                            local X = R:FindFirstChild("NumberGui", true)
                            if X then
                                if X.FindFirstChildWhichIsA then
                                    W = X:FindFirstChildWhichIsA("TextLabel")
                                end
                                if not W then W = X:FindFirstChild("TextLabel") end
                            end
                            local Y = false
                            if R:FindFirstChild("Flag") or R:FindFirstChild("Flagged") then Y = true end
                            local Z = nil
                            if R.GetAttribute then Z = R:GetAttribute("Flagged") end
                            if Z then Y = true end
                            V = { a = R, b = R.Position, c = R.Size, d = (W and W:IsA("TextLabel")) and W or nil, e = Y, f = Q }
                            A4[U] = V
                        else
                            V.b = R.Position
                            V.c = R.Size
                            V.f = Q
                            local Y = false
                            if R:FindFirstChild("Flag") or R:FindFirstChild("Flagged") then Y = true end
                            local Z = nil
                            if R.GetAttribute then Z = R:GetAttribute("Flagged") end
                            if Z then Y = true end
                            V.e = Y
                            if not V.d then
                                local X = R:FindFirstChild("NumberGui", true)
                                if X then
                                    local W
                                    if X.FindFirstChildWhichIsA then
                                        W = X:FindFirstChildWhichIsA("TextLabel")
                                    end
                                    if not W then W = X:FindFirstChild("TextLabel") end
                                    if W and W:IsA("TextLabel") then V.d = W end
                                end
                            end
                        end
                        P[#P + 1] = V
                    end
                end
            end
            if #P == 0 then return end
            
            local a0 = {}
            local a1, a2, a3 = nil, nil, math.huge
            for _, V in ipairs(P) do
                if V.d then
                    a0[#a0 + 1] = V
                    if M then
                        local a4 = (V.b - M.Position):Dot(V.b - M.Position)
                        if a4 < a3 then
                            a3 = a4
                            a1 = V.a
                            a2 = V.b
                        end
                    end
                end
            end
            
            local Q2 = Q
            local a5 = Q2 - (A3.a or 0)
            local a6 = (a5 >= s2)
            if a6 or (A3.b == nil) then
                A3.a = Q2
                if a1 then
                    A3.b = a1
                    A3.c = a2
                    local sx = math.max(A2, tonumber(a1.Size.X) or 0)
                    local sz = math.max(A2, tonumber(a1.Size.Z) or 0)
                    A3.d = math.max(A2, math.min(sx, sz))
                else
                    local F0 = A6()
                    for _, G in ipairs(F0:GetChildren()) do
                        G.Enabled = false
                    end
                    return
                end
            end
            
            if not A3.b or not A3.c then
                local F0 = A6()
                for _, G in ipairs(F0:GetChildren()) do
                    G.Enabled = false
                end
                return
            end
            
            local cpos = A3.c
            local d0 = A3.d
            local d1 = {}
            local d2, d3, d4, d5 = math.huge, -math.huge, math.huge, -math.huge
            
            local function d6(V0)
                local sx = tonumber(V0.c.X) or 0
                local sz = tonumber(V0.c.Z) or 0
                return math.abs(sx * sz)
            end
            
            for _, V in ipairs(P) do
                local gx = GridIndex(V.b.X - cpos.X, d0, 0.25)
                local gy = GridIndex(V.b.Z - cpos.Z, d0, 0.25)
                if gx < d2 then d2 = gx end
                if gx > d3 then d3 = gx end
                if gy < d4 then d4 = gy end
                if gy > d5 then d5 = gy end
                local K3 = B1(gx, gy)
                local E = d1[K3]
                if not E or d6(V) > d6(E) then
                    d1[K3] = V
                end
            end
            
            d2, d3, d4, d5 = d2 - 1, d3 + 1, d4 - 1, d5 + 1
            local offGX, offGY = (d2 - 1), (d4 - 1)
            local Wc = (d3 - d2 + 1)
            local Hc = (d5 - d4 + 1)
            if Wc <= 0 or Hc <= 0 then return end
            
            local b0 = {}
            for r0 = 1, Hc do
                b0[r0] = {}
                for c0 = 1, Wc do
                    b0[r0][c0] = { a = "covered", b = nil, c = nil }
                end
            end
            
            for _, V in ipairs(a0) do
                local gx = GridIndex(V.b.X - cpos.X, d0, 0.25)
                local gy = GridIndex(V.b.Z - cpos.Z, d0, 0.25)
                local r0 = gy - offGY
                local c0 = gx - offGX
                if r0 >= 1 and r0 <= Hc and c0 >= 1 and c0 <= Wc then
                    b0[r0][c0].a = "revealed"
                    b0[r0][c0].b = (T1(V.d.Text) or tonumber(V.d.Text) or 0)
                    b0[r0][c0].c = V
                end
            end
            
            for gx = d2, d3 do
                for gy = d4, d5 do
                    local V = d1[B1(gx, gy)]
                    if V then
                        local r0 = gy - offGY
                        local c0 = gx - offGX
                        if r0 >= 1 and r0 <= Hc and c0 >= 1 and c0 <= Wc then
                            b0[r0][c0].c = V
                            if b0[r0][c0].a ~= "revealed" then
                                if V.e then b0[r0][c0].a = "flagged" end
                            end
                        end
                    end
                end
            end
            
            -- Simplified solver for classification
            local safeTiles = {}
            local riskyTiles = {}
            local bombTiles = {}
            local unknownTiles = {}
            
            -- Simple constraint propagation
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    if b0[r0][c0].a == "revealed" then
                        local num = b0[r0][c0].b or 0
                        local neighbors = B3(r0, c0, Hc, Wn)
                        local flagged = 0
                        local covered = {}
                        
                        for _, rc in ipairs(neighbors) do
                            local rr, cc = rc[1], rc[2]
                            if b0[rr][cc].a == "flagged" then
                                flagged = flagged + 1
                            elseif b0[rr][cc].a == "covered" then
                                table.insert(covered, {rr, cc, b0[rr][cc]})
                            end
                        end
                        
                        local remaining = num - flagged
                        if remaining == 0 then
                            -- All remaining are safe
                            for _, tile in ipairs(covered) do
                                tile[3].prob = 0
                            end
                        elseif remaining == #covered then
                            -- All remaining are bombs
                            for _, tile in ipairs(covered) do
                                tile[3].prob = 1
                            end
                        end
                    end
                end
            end
            
            -- Classify tiles
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    if b0[r0][c0].a == "covered" then
                        local cellData = b0[r0][c0]
                        local prob = cellData.prob
                        
                        if prob == 0 then
                            table.insert(safeTiles, {
                                part = cellData.c.a,
                                position = cellData.c.b,
                                row = r0,
                                col = c0,
                                prob = 0
                            })
                        elseif prob == 1 then
                            table.insert(bombTiles, {
                                part = cellData.c.a,
                                position = cellData.c.b,
                                row = r0,
                                col = c0,
                                prob = 1
                            })
                        elseif prob then
                            table.insert(riskyTiles, {
                                part = cellData.c.a,
                                position = cellData.c.b,
                                row = r0,
                                col = c0,
                                prob = prob
                            })
                        else
                            table.insert(unknownTiles, {
                                part = cellData.c.a,
                                position = cellData.c.b,
                                row = r0,
                                col = c0,
                                prob = 0.5
                            })
                        end
                    end
                end
            end
            
            -- Auto Flag Bombs
            for _, bombData in ipairs(bombTiles) do
                local part = bombData.part
                if part and part.Parent and not part:FindFirstChild("Flag") and not part:FindFirstChild("Flagged") then
                    local flagged = part:GetAttribute("Flagged")
                    if not flagged then
                        task.spawn(function()
                            pcall(function()
                                local args = {part}
                                game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag"):FireServer(unpack(args))
                                part:SetAttribute("Flagged", true)
                            end)
                        end)
                    end
                end
            end
            
            -- Decision Making
            local actionTaken = false
            
            -- Priority 1: Safe Teleport
            if #safeTiles > 0 and playerRoot then
                local canTeleport = (tick() - lastTeleportTime) > TELEPORT_COOLDOWN
                if canTeleport then
                    local teleported, targetTile = safeTeleport(safeTiles, playerRoot)
                    if teleported then
                        lastTeleportTime = tick()
                        actionTaken = true
                        lastAction = "Safe Teleport"
                        
                        task.delay(0.2, function()
                            autoClickTile(targetTile, playerRoot)
                        end)
                        
                        task.delay(0.5, function()
                            for _, tile in ipairs(safeTiles) do
                                if tile.part ~= targetTile.part then
                                    autoClickTile(tile, playerRoot)
                                end
                            end
                        end)
                    end
                end
            end
            
            -- Priority 2: Guess Mode
            if not actionTaken and guessMode then
                local allRisky = {}
                for _, t in ipairs(riskyTiles) do table.insert(allRisky, t) end
                for _, t in ipairs(unknownTiles) do table.insert(allRisky, t) end
                
                if #allRisky > 0 and playerRoot then
                    local bestGuess = findBestGuess(allRisky, playerRoot)
                    if bestGuess and bestGuess.prob < 0.5 then
                        local canTeleport = (tick() - lastTeleportTime) > TELEPORT_COOLDOWN
                        if canTeleport then
                            pcall(function()
                                playerRoot.CFrame = CFrame.new(bestGuess.part.Position + Vector3.new(0, 3.5, 0))
                            end)
                            lastTeleportTime = tick()
                            actionTaken = true
                            lastAction = "GUESS " .. string.format("%.0f%%", bestGuess.prob * 100)
                            
                            task.delay(0.3, function()
                                autoClickTile(bestGuess, playerRoot)
                            end)
                        end
                    end
                end
            end
            
            -- Update Status
            pcall(function()
                if #safeTiles > 0 then
                    statusLabel.Text = "Status: Safe Tiles: " .. #safeTiles
                    statusLabel.TextColor3 = c(100, 255, 100)
                elseif guessMode and (#riskyTiles > 0 or #unknownTiles > 0) then
                    statusLabel.Text = "Status: GUESSING..."
                    statusLabel.TextColor3 = c(255, 200, 100)
                elseif #riskyTiles > 0 or #unknownTiles > 0 then
                    statusLabel.Text = "Status: Stuck - No Safe Tiles"
                    statusLabel.TextColor3 = c(255, 100, 100)
                else
                    statusLabel.Text = "Status: " .. lastAction
                end
            end)
            
            -- Render GUI
            local F0 = A6()
            local G = tick()
            local guiUpdates = {}
            local da = {}
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    if b0[r0][c0].a == "revealed" then
                        for _, rc in ipairs(B3(r0, c0, Hc, Wc)) do
                            local rr, cc = rc[1], rc[2]
                            if b0[rr][cc].a == "covered" then
                                da[B0(rr, cc)] = true
                            end
                        end
                    end
                end
            end
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    local d8 = b0[r0][c0]
                    local V = d8.c
                    local p3 = V and V.a
                    if p3 and p3:IsA("BasePart") then
                        local draw = false
                        if d8.a == "covered" then draw = da[B0(r0, c0)] == true end
                        
                        if d8.a == "flagged" then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = "💣", color = nil}
                        elseif d8.a == "covered" and draw then
                            if d8.prob == 0 then
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = "✅", color = c(0, 255, 0)}
                            elseif d8.prob == 1 then
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = "💣", color = c(255, 0, 0)}
                            elseif d8.prob then
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = string.format("%.0f%%", d8.prob * 100), color = A8(d8.prob)}
                            else
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = "?", color = c(150, 150, 150)}
                            end
                        else
                            local H2 = B4(p3)
                            local I = F0:FindFirstChild(H2)
                            if I then
                                I.Enabled = false
                                lastSeenRun[I] = G
                            end
                        end
                    end
                end
            end
            
            for _, update in ipairs(guiUpdates) do
                local I, J = B5(F0, update.part, G)
                if I and J then
                    if J.Text ~= update.text then
                        J.Text = update.text
                        if update.color then
                            J.TextColor3 = update.color
                        end
                    end
                end
            end
            
            for _, I in ipairs(F0:GetChildren()) do
                local K0 = lastSeenRun[I]
                local alive = I.Adornee and I.Adornee.Parent
                if (K0 ~= G) or (not alive) then
                    guiCache[I.Name] = nil
                    I:Destroy()
                end
            end
        end
        
        pcall(B6)
        while state and state.b and state.c == q do
            task.wait(r)
            pcall(B6)
            local now = tick()
            if now % 3 < 0.1 then
                for id, V in pairs(A4) do
                    if (now - (V.f or 0)) > 10 then
                        A4[id] = nil
                    end
                end
            end
        end
        
        if not state or state.c == q then 
            k()
            for k in pairs(guiCache) do
                guiCache[k] = nil
            end
            pcall(function()
                statusLabel.Text = "Status: Stopped"
                statusLabel.TextColor3 = c(255, 100, 100)
            end)
        end
    end)
end

Scanningmines = S

-- ============================================
-- STATE MANAGEMENT
-- ============================================

local function pushState()
    local sOn = btnScript.getState()
    local m = tonum(boxMax.Text) or 5000
    local us = tonum(boxUS.Text) or 0.1
    local ps = tonum(boxPS.Text) or 1
    local fe = Enum.Font.Arcade
    local r2 = tonum(boxR.Text) or 100
    local rOn = btnRange.getState()
    local aOn = sOn -- Auto flag always on when run is on
    local f2 = tonum(boxF.Text) or 16
    local fs = tonum(boxFS.Text) or 0.05
    local roOn = btnRot.getState()
    local guessOn = btnGuess.getState()
    
    if sOn == false then
        S(false)
        return
    end
    S(false)
    S(sOn, m, us, ps, fe, r2, rOn, aOn, f2, fs, roOn, guessOn)
end

-- Auto Start
task.delay(3, function()
    -- Auto enable only Run (which includes Auto Flag)
    btnScript.setState(true)
    pushState()
end)

print("✅ Minesweeper Auto Solver Loaded!")
print("💡 Click the 💣 button to open/close UI")
print("🎯 Drag the top part of button to move it")
