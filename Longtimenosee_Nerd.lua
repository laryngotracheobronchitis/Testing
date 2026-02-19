-- bLockerman's Minesweeper, NothingNesser's Script Fix (ROBLOX)
-- FIXED DETERMINISTIC VERSION - 8-way detection & Y=3.85 teleport
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
    local o = Instance.new(t, p)
    if x then
        for k, w in pairs(x) do
            pcall(function() o[k] = w end)
        end
    end
    return o
end

local s = n("ScreenGui", P, {
    DisplayOrder = 2147483647,
    Name = "MinesweeperHelper",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false
})

local open = n("TextButton", s, {
    BorderSizePixel = 2,
    TextSize = 16,
    TextColor3 = c(255, 255, 255),
    BackgroundColor3 = c(40, 40, 40),
    FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    AnchorPoint = v(1, 1),
    BackgroundTransparency = 0.6,
    Size = u(0, 60, 0, 60),
    BorderColor3 = c(100, 100, 100),
    Text = "⚡",
    TextScaled = true,
    Name = "open",
    Position = u(1, -10, 1, -10)
})

n("UICorner", open, { CornerRadius = UDim.new(0.15, 0) })
n("UIPadding", open, { PaddingTop = UDim.new(.1, 0), PaddingBottom = UDim.new(.1, 0), PaddingLeft = UDim.new(.1, 0), PaddingRight = UDim.new(.1, 0) })

local panel = n("Frame", s, {
    Visible = false,
    BorderSizePixel = 0,
    BackgroundColor3 = c(0, 0, 0),
    AnchorPoint = v(.5, .5),
    Size = u(0, 600, 0, 350),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.71 })

local a = n("Frame", panel, {
    BorderSizePixel = 0,
    BackgroundColor3 = c(20, 20, 20),
    AnchorPoint = v(.5, .5),
    Size = u(.99, 0, .99, 0),
    Position = u(.5, 0, .505, 0),
    BorderColor3 = c(0, 0, 0)
})

n("UICorner", a, { CornerRadius = UDim.new(.05, 0) })

local creditLabel = n("TextLabel", a, {
    Text = "AUTO SOLVER - Deterministic 8-Way",
    TextSize = 18,
    TextColor3 = c(0, 255, 255),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.4, 0, 0.08, 0),
    Position = u(0.58, 0, 0.01, 0),
    ZIndex = 10
})

local function ico(name, y)
    local i = n("ImageButton", a, {
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        BackgroundColor3 = c(0, 0, 0),
        AnchorPoint = v(.5, .5),
        Image = "rbxassetid://16167594452",
        ImageRectSize = v(90, 90),
        Size = u(.06363, 0, .12408, 0),
        BorderColor3 = c(0, 0, 0),
        Name = name,
        ImageRectOffset = v(862, 472),
        Position = u(.06254, 0, y, 0)
    })
    n("UIAspectRatioConstraint", i)
    return i
end

-- 4 tombol
local btnScript = ico("script", .10419)  -- Auto Solver
local btnRange = ico("range", .27886)    -- Range
local btnAuto = ico("autoclick", .45352) -- Flag
local btnGuess = ico("guess", .62818)    -- Auto Guess

local function gradL(p)
    n("UIGradient", p, { Transparency = N { K(0, 0), K(1, .33125) } })
end

local function pad(p, t, l, bm)
    n("UIPadding", p, {
        PaddingTop = UDim.new(t, 0),
        PaddingLeft = UDim.new(l, 0),
        PaddingBottom = UDim.new(bm, 0)
    })
end

local function lbl(txt, sx, py, pt, pb)
    local L = n("TextLabel", a, {
        TextWrapped = true,
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = true,
        BackgroundColor3 = c(0, 0, 0),
        FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextColor3 = c(255, 255, 255),
        BackgroundTransparency = 1,
        Size = u(sx, 0, .15, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txt,
        Position = u(.10693, 0, py, 0)
    })
    pad(L, pt, .05, pb)
    gradL(L)
    return L
end

lbl("Auto Solver", .2796, .04033, .06, .15)
lbl("Range", .29895, .22344, .07, .13)
lbl("Flag", .2796, .40656, .08, .12)
lbl("Auto Guess", .2796, .58967, .06, .09)

local statusLabel = n("TextLabel", a, {
    Text = "Status: Ready",
    TextSize = 14,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.3, 0, 0.06, 0),
    Position = u(.10693, 0, .78, 0),
    ZIndex = 5
})

local function gradB(p)
    n("UIGradient", p, {
        Rotation = 90,
        Transparency = N { K(0, 0), K(.684, 0), K(.9, .3), K(1, 1) }
    })
end

local function txt(name, ph, sx, px, py, txtv)
    local t = n("TextBox", a, {
        CursorPosition = -1,
        Name = name,
        PlaceholderColor3 = c(190, 190, 190),
        BorderSizePixel = 0,
        TextWrapped = true,
        TextSize = 14,
        TextColor3 = c(0, 0, 0),
        TextScaled = true,
        BackgroundColor3 = c(255, 255, 255),
        FontFace = F("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        PlaceholderText = ph,
        Size = u(sx, 0, .11, 0),
        Position = u(px, 0, py, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txtv or ""
    })
    gradB(t)
    n("UICorner", t, { CornerRadius = UDim.new(.157, 0) })
    n("UIPadding", t, {
        PaddingRight = UDim.new(.05, 0),
        PaddingLeft = UDim.new(.05, 0),
        PaddingBottom = UDim.new(.1, 0)
    })
    return t
end

-- Input boxes
local boxMax  = txt("max", "5000", .16214, .40588, .05417, "5000")
local boxDelay = txt("delay", "0.01", .16214, .60268, .05417, "0.01")
local boxPS   = txt("pspeed", "1", .16214, .79948, .05417, "1")
local boxR    = txt("r", "100", .16214, .40403, .23729, "100")
local boxF    = txt("f", "16", .16398, .40403, .4204, "16")
local boxFS   = txt("fspeed", "0.01", .16398, .60019, .4204, "0.01")
local boxText = txt("text", "Arcade", .55574, .40588, .60351, "Arcade")

local img = n("ImageLabel", a, {
    ZIndex = 9,
    BorderSizePixel = 0,
    BackgroundColor3 = c(255, 255, 255),
    ResampleMode = Enum.ResamplerMode.Pixelated,
    Image = "rbxassetid://91463315015793",
    Size = u(.46942, 0, .90793, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 1,
    Position = u(.53564, 0, .15447, 0)
})

n("TextLabel", img, {
    TextWrapped = true,
    BorderSizePixel = 0,
    TextSize = 14,
    TextScaled = true,
    BackgroundColor3 = c(255, 255, 255),
    FontFace = F("rbxasset://fonts/families/SpecialElite.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    TextColor3 = c(255, 255, 255),
    BackgroundTransparency = 1,
    Size = u(.41045, 0, .0969, 0),
    BorderColor3 = c(0, 0, 0),
    Text = "v3",
    Rotation = -5,
    Position = u(.56212, 0, .14326, 0)
})

local st = n("UIStroke", a, { Color = c(100, 100, 100), Thickness = 2 })

n("ImageLabel", a, {
    ZIndex = -13456,
    BorderSizePixel = 0,
    ScaleType = Enum.ScaleType.Crop,
    BackgroundColor3 = c(255, 255, 255),
    ResampleMode = Enum.ResamplerMode.Pixelated,
    ImageTransparency = .85,
    Image = "rbxassetid://14755021367",
    ImageRectSize = v(195, 84),
    Size = u(1, 0, 1, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 1,
    Rotation = 180,
    ImageRectOffset = v(0, 902)
})

local B = "Flags status"
local state = { b = false, c = 0, d = nil }
local player = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

local function e(vv)
    if type(vv) == "boolean" then return vv end
    if type(vv) == "string" then
        local s0 = vv:lower()
        return (s0 == "enable" or s0 == "on" or s0 == "true" or s0 == "start")
    end
    return vv and true or false
end

-- NEIGHBOR OFFSETS untuk 8 arah (termasuk diagonal)
local neighborOffsets = {
    {1, 0}, {-1, 0}, {0, 1}, {0, -1}, -- Sisi (Kanan, Kiri, Atas, Bawah)
    {1, 1}, {1, -1}, {-1, 1}, {-1, -1} -- DIAGONAL (Pojok/Corner)
}

-- Fungsi teleportasi dengan posisi Y = 3.85 studs di atas tile
local function teleportTo(position)
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not root then return end
    
    -- Teleport 3.85 studs di atas tile (agar tidak menembus lantai)
    root.CFrame = CFrame.new(position + Vector3.new(0, 3.85, 0))
end

-- Fungsi flag bomb
local function flagBomb(part)
    if not part or not part.Parent then return false end
    
    -- Cek apakah sudah ada flag
    if part:FindFirstChild("Flag") or part:FindFirstChild("Flagged") then
        return false
    end
    
    local flagged = part:GetAttribute("Flagged")
    if flagged then return false end
    
    -- Coba flag via ClickDetector dulu
    local cd = part:FindFirstChildOfClass("ClickDetector")
    if cd then
        pcall(function()
            fireclickdetector(cd)
        end)
        task.wait(0.05)
        return true
    end
    
    -- Coba flag via RemoteEvent
    local success = pcall(function()
        local events = replicatedStorage:FindFirstChild("Events")
        if events then
            local flagEvents = events:FindFirstChild("FlagEvents")
            if flagEvents then
                local placeFlag = flagEvents:FindFirstChild("PlaceFlag")
                if placeFlag then
                    placeFlag:FireServer(part)
                    part:SetAttribute("Flagged", true)
                    return true
                end
            end
        end
    end)
    
    return success
end

-- Fungsi membaca angka
local function extractNumber(text)
    if not text or text == "" then return nil end
    
    local num = tonumber(text)
    if num then return num end
    
    local digits = text:match("%d+")
    if digits then return tonumber(digits) end
    
    return nil
end

-- Fungsi mendapatkan tetangga dalam grid (8 arah)
local function getNeighbors(row, col, grid)
    local neighbors = {}
    local height = #grid
    local width = #grid[1]
    
    for _, offset in ipairs(neighborOffsets) do
        local nr = row + offset[1]
        local nc = col + offset[2]
        
        if nr >= 1 and nr <= height and nc >= 1 and nc <= width then
            local cell = grid[nr][nc]
            if cell then
                table.insert(neighbors, cell)
            end
        end
    end
    
    return neighbors
end

function S(t, a1, c1, d1, f1, g1, h1, x1, v1, n1, y1, guessOn, delayVal)
    local i = state
    local j = e(t)
    local function k()
        local cg = game:GetService("CoreGui")
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
    i.d = {
        r = tonumber(c1) or 0.01,
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 1000, y = tonumber(a1) or 1000 },
        ac = { 
            on = e(x1), 
            rad = tonumber(v1) or 20, 
            intv = tonumber(n1) or 0.01, 
            fspd = tonumber(boxFS and boxFS.Text) or 0.01, 
            guess = e(guessOn), 
            delay = tonumber(delayVal) or 0.01 
        },
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
    task.spawn(function()
        local r = i.d.r
        local s2 = i.d.s
        local t2 = i.d.t
        local u2 = i.d.u
        local vb = i.d.vb
        local w2 = i.d.w
        local ac = i.d.ac
        
        local z = 1e-4
        local A2 = 1e-6
        local A3 = { a = 0, b = nil, c = nil, d = 1, e = nil, f = nil, g = nil, h = 0, i = 0, j = nil, k = 0.5 }
        local A4 = {}
        local lastSeenRun = setmetatable({}, { __mode = "k" })
        local l = game:GetService("Players")
        local A5 = game:GetService("Workspace")
        local cg = game:GetService("CoreGui")
        local guiCache = {}
        local updateThrottle = 0
        local THROTTLE_INTERVAL = 0.01
        
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
            return extractNumber(sv)
        end
        local function A7(a2) a2 = tonumber(a2) or 0 if a2 < 0 then return 0 elseif a2 > 1 then return 1 else return a2 end end
        local function A8(pv) pv = A7(pv) if pv <= 0.5 then local q0 = pv / 0.5 return Color3.fromRGB(math.floor(250 * q0 + 0.5), 250, 0) else local q0 = (pv - 0.5) / 0.5 return Color3.fromRGB(255, math.floor(250 * (1 - q0) + 0.5), 0) end end
        local function A9(a2) if a2 >= 0 then return math.floor(a2 + 0.5 + z) else return math.ceil(a2 - 0.5 - z) end end
        local function B0(r0, c0) return tostring(r0) .. ":" .. tostring(c0) end
        local function B1(gx, gy) return tostring(gx) .. ":" .. tostring(gy) end
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
                        if ch:IsA("BasePart") then c = c + 1 end
                    end
                    if c > bC then b, bC = i, c end
                end
            end
            return b
        end
        local function B6()
            if not (state and state.b and state.c == q) then return end
            local currentTime = tick()
            if currentTime - updateThrottle < THROTTLE_INTERVAL then
                return
            end
            updateThrottle = currentTime
            
            local L = fd()
            if not L then return end
            local o0 = l.LocalPlayer
            local M = nil
            if o0 and o0.Character then
                M = o0.Character:FindFirstChild("HumanoidRootPart") or o0.Character:FindFirstChild("Torso")
            end
            if vb and u2 and u2 > 0 and not M then return end
            local useRange = vb and (u2 and u2 > 0 and M ~= nil)
            local rangeSq = useRange and (u2 * u2) or nil
            local parts = {}
            local Q = tick()
            local partsToProcess = L:GetChildren()
            
            for _, R in ipairs(partsToProcess) do
                if R:IsA("BasePart") and (R.Anchored ~= false) then
                    local skip = false
                    if useRange then
                        local distSq = (R.Position - M.Position).MagnitudeSquared
                        if distSq > rangeSq then skip = true end
                    end
                    if not skip then
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
                        parts[#parts + 1] = V
                    end
                end
            end
            if #parts == 0 then return end
            local a0 = {}
            local a1, a2, a3 = nil, nil, math.huge
            for _, V in ipairs(parts) do
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
            for _, V in ipairs(parts) do
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
            
            -- DETERMINISTIC DETECTION (8 arah)
            local mines = {}  -- Bom pasti
            local safes = {}  -- Aman pasti
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    local cell = b0[r0][c0]
                    if cell.a == "revealed" and cell.b and cell.b > 0 then
                        local neighbors = getNeighbors(r0, c0, b0)
                        local covered = {}
                        local flagged = 0
                        
                        for _, nb in ipairs(neighbors) do
                            if nb.a == "flagged" then
                                flagged = flagged + 1
                            elseif nb.a == "covered" then
                                table.insert(covered, nb)
                            end
                        end
                        
                        local remaining = cell.b - flagged
                        
                        -- Jika jumlah ubin tertutup sama dengan angka yang tersisa -> SEMUA BOM
                        if remaining == #covered and #covered > 0 then
                            for _, mineCell in ipairs(covered) do
                                if mineCell.c and mineCell.c.a then
                                    mines[mineCell] = true
                                end
                            end
                        end
                        
                        -- Jika tidak ada sisa angka dan ada ubin tertutup -> SEMUA AMAN
                        if remaining == 0 and #covered > 0 then
                            for _, safeCell in ipairs(covered) do
                                if safeCell.c and safeCell.c.a then
                                    safes[safeCell] = true
                                end
                            end
                        end
                    end
                end
            end
            
            -- AUTO FLAG: Flag bombs
            local bombsToFlag = {}
            for cell, _ in pairs(mines) do
                if cell.c and cell.c.a then
                    table.insert(bombsToFlag, {
                        part = cell.c.a
                    })
                end
            end
            
            if ac and ac.on and #bombsToFlag > 0 then
                local flagSpeed = ac.fspd or 0.01
                statusLabel.Text = "Flagging " .. #bombsToFlag .. " bombs..."
                
                for _, bombData in ipairs(bombsToFlag) do
                    local part = bombData.part
                    if part and part.Parent then
                        local success = flagBomb(part)
                        if success then
                            task.wait(flagSpeed)
                        end
                    end
                end
            end
            
            -- AUTO SOLVER: Teleport ke tile aman
            if state and state.b and state.c == q then
                pcall(function()
                    local root = M
                    if not root then return end
                    
                    local teleportDelay = ac.delay or 0.01
                    local safeTiles = {}
                    
                    for cell, _ in pairs(safes) do
                        if cell.c and cell.c.a then
                            local part = cell.c.a
                            if part and part:IsA("BasePart") then
                                table.insert(safeTiles, {
                                    part = part,
                                    pos = part.Position
                                })
                            end
                        end
                    end
                    
                    if #safeTiles > 0 then
                        local target = safeTiles[1]
                        teleportTo(target.pos)
                        statusLabel.Text = "Teleport to safe tile (Y=3.85)"
                        task.wait(teleportDelay)
                    else
                        statusLabel.Text = "No deterministic safe tiles"
                    end
                end)
            end
            
            -- GUI Updates
            local F0 = A6()
            local G = tick()
            local guiUpdates = {}
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    local d8 = b0[r0][c0]
                    local V = d8.c
                    local p3 = V and V.a
                    if p3 and p3:IsA("BasePart") then
                        if mines[d8] then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = utf8.char(0x1F4A5), color = nil}
                        elseif safes[d8] then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = utf8.char(0x2705), color = nil}
                        elseif d8.a == "flagged" then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = utf8.char(0x1F4A5), color = nil}
                        elseif d8.a == "covered" then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = "?", color = Color3.fromRGB(200, 200, 200)}
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
            A3.f, A3.g = d1, b0
            A3.h, A3.i = Wc, Hc
        end
        
        -- Loop utama
        while state and state.b and state.c == q do
            pcall(B6)
            task.wait(r or 0.01)
        end
        
        if not state or state.c == q then 
            k()
            for k in pairs(guiCache) do
                guiCache[k] = nil
            end
            statusLabel.Text = "Status: Stopped"
        end
    end)
end

Scanningmines = S

local UserInputService = game:GetService("UserInputService")

local ON_IMG = "rbxassetid://16884179507"
local ON_OFF1 = Vector2.new(578, 50)
local ON_OFF2 = Vector2.new(48, 48)
local OFF_IMG = "rbxassetid://16167594452"
local OFF_OFF1 = Vector2.new(862, 472)
local OFF_OFF2 = Vector2.new(90, 90)

local function callS(...)
    if type(S) == "function" then
        pcall(S, ...)
    end
end

local btnState = setmetatable({}, { __mode = "k" })

local function setVis(bx, on)
    if not bx then return end
    if on then
        bx.Image = ON_IMG
        bx.ImageRectOffset = ON_OFF1
        bx.ImageRectSize = ON_OFF2
    else
        bx.Image = OFF_IMG
        bx.ImageRectOffset = OFF_OFF1
        bx.ImageRectSize = OFF_OFF2
    end
    btnState[bx] = on
end

local function getState(bx)
    if not bx then return false end
    if btnState[bx] ~= nil then return btnState[bx] end
    return false
end

local function tonum(sv)
    if not sv then return nil end
    sv = sv:match("^%s*(.-)%s*$")
    return tonumber(sv)
end

local function parseFont(sv)
    if not sv or sv == "" then return nil end
    local input = sv:match("^%s*(.-)%s*$")
    input = input:gsub("^Enum%.Font%.", ""):gsub("%s+", "")
    for _, it in ipairs(Enum.Font:GetEnumItems()) do
        if string.lower(it.Name) == string.lower(input) then
            return it
        end
    end
    return Enum.Font.Arcade
end

local toggles = { btnScript, btnRange, btnAuto, btnGuess }
for _, btt in ipairs(toggles) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

local function btnBool(b) return (b and getState(b)) or false end

local function pushState()
    local sOn = btnScript and getState(btnScript) or nil
    local m = boxMax and tonum(boxMax.Text) or 5000
    local delayVal = boxDelay and tonum(boxDelay.Text) or 0.01
    local ps = boxPS and tonum(boxPS.Text) or 1
    local fe = boxText and parseFont(boxText.Text) or Enum.Font.Arcade
    local r2 = boxR and tonum(boxR.Text) or 100
    local rOn = btnBool(btnRange)
    local aOn = btnBool(btnAuto)
    local f2 = boxF and tonum(boxF.Text) or 16
    local fs = boxFS and tonum(boxFS.Text) or 0.01
    local guessOn = btnBool(btnGuess)
    
    if sOn == false then
        callS(false)
        statusLabel.Text = "Status: Stopped"
        return
    end
    
    callS(false)
    callS(sOn, m, delayVal, ps, fe, r2, rOn, aOn, f2, fs, false, guessOn, delayVal)
    statusLabel.Text = "Status: Running (8-Way Deterministic)"
end

local function bindToggle(bx)
    if not bx then return end
    local function t()
        local nstate = not getState(bx)
        setVis(bx, nstate)
        pushState()
    end
    bx.MouseButton1Click:Connect(t)
end

bindToggle(btnScript)
bindToggle(btnRange)
bindToggle(btnAuto)
bindToggle(btnGuess)

local function bindBox(tb)
    if not tb then return end
    tb.ClearTextOnFocus = false
    tb.FocusLost:Connect(function()
        pushState()
    end)
end

bindBox(boxMax)
bindBox(boxDelay)
bindBox(boxPS)
bindBox(boxR)
bindBox(boxF)
bindBox(boxFS)
bindBox(boxText)

local dragging = false
local dragInput, dragStart, startPos

local draggingOpen = false
local dragInputOpen, dragStartOpen, startPosOpen

local function updateInput(input)
    if dragging and panel.Visible then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

local function updateInputOpen(input)
    if draggingOpen then
        local delta = input.Position - dragStartOpen
        open.Position = UDim2.new(
            startPosOpen.X.Scale,
            startPosOpen.X.Offset + delta.X,
            startPosOpen.Y.Scale,
            startPosOpen.Y.Offset + delta.Y
        )
    end
end

panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

panel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

open.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingOpen = true
        dragStartOpen = input.Position
        startPosOpen = open.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingOpen = false
            end
        end)
    end
end)

open.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputOpen = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateInput(input)
    elseif input == dragInputOpen then
        updateInputOpen(input)
    end
end)

local clickStart = nil
open.MouseButton1Down:Connect(function()
    clickStart = tick()
end)

open.MouseButton1Up:Connect(function()
    if clickStart and (tick() - clickStart) < 0.2 and not draggingOpen then
        panel.Visible = not panel.Visible
    end
    clickStart = nil
end)

print("Auto Solver v3 (Deterministic) loaded!")
print("Fixes: 8-way detection, Y=3.85 teleport, deterministic logic")
print("Green check = Safe, Bomb icon = Mine")
