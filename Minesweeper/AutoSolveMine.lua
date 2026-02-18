-- bLockerman's Minesweeper, NothingNesser's Script Fix + Auto Solver (Run sebagai inti)
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
    Text = "☹️",
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
    Size = u(0, 650, 0, 380),
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
    Text = "Auto Solver (Run sebagai inti, lainnya opsional)",
    TextSize = 16,
    TextColor3 = c(200, 200, 200),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.5, 0, 0.08, 0),
    Position = u(0.48, 0, 0.01, 0),
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

-- 4 toggle: Run (inti), Range, Auto Flag, Rotation
local btnRun    = ico("run", .14419)      -- Run sebagai inti (membuka tile aman)
local btnRange  = ico("range", .37886)    -- Range (opsional)
local btnAutoFlag = ico("autoflag", .61352) -- Auto Flag (opsional)
local btnRot    = ico("rotation", .84818) -- Rotation (opsional)

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
        Size = u(sx, 0, .18773, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txt,
        Position = u(.10693, 0, py, 0)
    })
    pad(L, pt, .05, pb)
    gradL(L)
    return L
end

lbl("Run (Auto Solver)", .35, .05033, .06, .15)  -- Run sebagai inti
lbl("Range (opsional)", .35, .28344, .07, .13)
lbl("Auto Flag (opsional)", .35, .51656, .08, .12)
lbl("Rotation (opsional)", .35, .74967, .06, .09)

local patchedLabel = n("TextLabel", a, {
    Text = "Run: buka tile aman | Auto Flag: tandai mine",
    TextSize = 11,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.4, 0, 0.06, 0),
    Position = u(.10693, 0, .68, 0),
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
        Size = u(sx, 0, .13791, 0),
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
local boxMax     = txt("max", "5000", .16214, .40588, .07417, "5000")
local boxPS      = txt("pspeed", "1", .16214, .79948, .07417, "1")
local boxR       = txt("r", "100", .16214, .40403, .30729, "100")
local boxFlagRange = txt("flagrange", "16", .16398, .40403, .5404, "16")
local boxFS      = txt("fspeed", "0.05", .16398, .60019, .5404, "0.05")
local boxGuess   = txt("guess", "0.5 (Auto Guess)", .35, .40588, .77, "0.5")  -- Auto Guess threshold
local boxUS      = txt("uspeed", "0.2", .16214, .60268, .07417, "0.2")

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
    Text = "Auto Solver",
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

local function e(vv)
    if type(vv) == "boolean" then return vv end
    if type(vv) == "string" then
        local s0 = vv:lower()
        return (s0 == "enable" or s0 == "on" or s0 == "true" or s0 == "start")
    end
    return vv and true or false
end

-- Helper functions
local function getDistance(part1, part2)
    if not part1 or not part2 then return math.huge end
    return (part1.Position - part2.Position).Magnitude
end

local function hasFlag(part)
    if not part then return false end
    for _, child in ipairs(part:GetChildren()) do
        if child.Name:lower():find("flag") or child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
            return true
        end
    end
    if part:GetAttribute("Flagged") then return true end
    return false
end

local function hasBeenClicked(part)
    if not part then return false end
    return part:GetAttribute("Clicked") == true
end

local function clickTile(part, playerChar, range)
    if not part then return false end
    if hasFlag(part) or hasBeenClicked(part) then return false end
    
    if playerChar and range and range > 0 then
        local root = playerChar:FindFirstChild("HumanoidRootPart") or playerChar:FindFirstChild("Torso")
        if root then
            local dist = getDistance(part, root)
            if dist > range then return false end
        end
    end
    
    local cd = part:FindFirstChildOfClass("ClickDetector", true)
    if cd then
        pcall(function()
            fireclickdetector(cd)
            part:SetAttribute("Clicked", true)
            return true
        end)
    end
    return false
end

local function flagTile(part, playerChar, range)
    if not part then return false end
    if hasFlag(part) then return false end
    
    if playerChar and range and range > 0 then
        local root = playerChar:FindFirstChild("HumanoidRootPart") or playerChar:FindFirstChild("Torso")
        if root then
            local dist = getDistance(part, root)
            if dist > range then return false end
        end
    end
    
    pcall(function()
        local args = {part}
        local flagEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if flagEvent then
            local flagEvents = flagEvent:FindFirstChild("FlagEvents")
            if flagEvents then
                local placeFlag = flagEvents:FindFirstChild("PlaceFlag")
                if placeFlag then
                    placeFlag:FireServer(unpack(args))
                    part:SetAttribute("Flagged", true)
                end
            end
        end
    end)
    return true
end

-- Main Auto Solver function
function S(t, a1, c1, d1, f1, g1, h1, runOn, flagRange, fspeed, rotOn, guessThreshold)
    local i = state
    local j = e(t)
    
    local function cleanup()
        local cg = game.CoreGui
        if cg then
            local p0 = cg:FindFirstChild(B)
            if p0 then p0:Destroy() end
        end
    end
    
    -- Parse rotation
    local rotOnBool = e(rotOn)
    local rotOpt = { on = rotOnBool, ro = 180, tN = 1, uR = true }
    
    -- Parse auto guess threshold
    local guessThresh = tonumber(guessThreshold) or 0.5
    
    i.d = {
        r = 0.05,  -- Update cepat
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 1000, y = tonumber(a1) or 1000 },
        run = { 
            on = e(runOn),  -- Run sebagai inti (membuka tile aman)
            range = tonumber(flagRange) or 16
        },
        autoFlag = {
            on = e(flagRange) and e(flagRange) ~= false,  -- Auto Flag opsional
            range = tonumber(flagRange) or 16,
            speed = tonumber(fspeed) or 0.05
        },
        rot = {
            on = rotOnBool,
            ro = 180,
            tN = 1,
            uR = true
        },
        guess = {
            threshold = guessThresh
        }
    }
    
    if not j or not i.d.run.on then  -- Run harus ON untuk menjalankan
        i.c = i.c + 1
        i.b = false
        cleanup()
        return
    end
    
    i.c = i.c + 1
    local q = i.c
    i.b = true
    
    task.spawn(function()
        local r = 0.05
        local s2 = i.d.s
        local t2 = i.d.t
        local u2 = i.d.u
        local vb = i.d.vb
        local w2 = i.d.w
        local run = i.d.run
        local autoFlag = i.d.autoFlag
        local rot = i.d.rot
        local guess = i.d.guess
        
        local function mkRotCtl(opt)
            local th = {}
            local function ha(vv)
                local a0 = math.deg(math.atan2(vv.X, vv.Z))
                if a0 < 0 then a0 = a0 + 360 end
                return a0
            end
            local function add(lbl, part)
                if not lbl or not lbl.Parent or not lbl.IsA or not lbl:IsA("TextLabel") then return end
                if th[lbl] then return end
                local p1 = part
                if not p1 or not p1.IsA or not p1:IsA("BasePart") then
                    local par = lbl.Parent
                    local ok, ad = pcall(function() return par.Adornee end)
                    if not (ok and ad and ad.IsA and ad:IsA("BasePart")) then return end
                    p1 = ad
                end
                local co = coroutine.create(function()
                    local fc = 0
                    while state and state.b and state.c == q and rot.on do
                        if not lbl.Parent or not p1.Parent then break end
                        fc = fc + 1
                        if fc >= opt.tN then
                            fc = 0
                            local okc, cf = pcall(function() return workspace.CurrentCamera and workspace.CurrentCamera.CFrame end)
                            if okc and cf then
                                local cy = ha(cf.LookVector)
                                local okp, rv = pcall(function() return p1.CFrame.RightVector end)
                                if okp and rv then
                                    local by = ha(rv)
                                    local rel = (cy - by) % 360
                                    local rotv = (-rel + opt.ro) % 360
                                    pcall(function() lbl.Rotation = rotv end)
                                end
                            end
                        end
                        task.wait()
                    end
                    th[lbl] = nil
                end)
                th[lbl] = co
                coroutine.resume(co)
            end
            local function stop()
                for lbl, _ in pairs(th) do
                    th[lbl] = nil
                end
            end
            return { add = add, stop = stop }
        end
        
        local RotCtl = mkRotCtl(rot)
        
        -- Variables for board analysis
        local z = 1e-4
        local A2 = 1e-6
        local A3 = { a = 0, b = nil, c = nil, d = 1, e = nil, f = nil, g = nil, h = 0, i = 0, j = nil, k = 0.5 }
        local A4 = {}
        local lastSeenRun = setmetatable({}, { __mode = "k" })
        local l = game:GetService("Players")
        local cg = game.CoreGui
        local guiCache = {}
        local updateThrottle = 0
        local THROTTLE_INTERVAL = 0.02
        
        local function getFolder()
            local parent = cg or workspace
            local p2 = parent:FindFirstChild(B)
            if not p2 then
                p2 = Instance.new("Folder")
                p2.Name = B
                p2.Parent = parent
            end
            return p2
        end
        
        local function getNumber(sv)
            if type(sv) ~= "string" then return nil end
            local d = sv:match("(%d+)")
            return d and tonumber(d) or 0
        end
        
        local function clampProb(a2)
            a2 = tonumber(a2) or 0
            if a2 < 0 then return 0
            elseif a2 > 1 then return 1
            else return a2 end
        end
        
        local function probColor(pv)
            pv = clampProb(pv)
            if pv <= 0.5 then
                local q = pv / 0.5
                return Color3.fromRGB(math.floor(250 * q), 250, 0)
            else
                local q = (pv - 0.5) / 0.5
                return Color3.fromRGB(255, math.floor(250 * (1 - q)), 0)
            end
        end
        
        local function getAdjacent(r, c, H, W)
            local result = {}
            for dr = -1, 1 do
                for dc = -1, 1 do
                    if not (dr == 0 and dc == 0) then
                        local rr, cc = r + dr, c + dc
                        if rr >= 1 and rr <= H and cc >= 1 and cc <= W then
                            table.insert(result, {rr, cc})
                        end
                    end
                end
            end
            return result
        end
        
        local function getDebugId(p) return tostring(p:GetDebugId()) end
        
        local function getOrCreateGui(folder, part, time)
            if not (part and part:IsA("BasePart")) then return nil end
            local id = getDebugId(part)
            local gui = guiCache[id]
            if not gui or not gui.Parent then
                gui = folder:FindFirstChild(id)
                if not gui then
                    gui = Instance.new("SurfaceGui")
                    gui.Name = id
                    gui.AlwaysOnTop = true
                    gui.LightInfluence = 0
                    pcall(function()
                        gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
                        gui.PixelsPerStud = 25
                    end)
                    gui.Face = Enum.NormalId.Top
                    gui.Parent = folder
                    gui.Adornee = part
                end
                guiCache[id] = gui
            end
            
            if gui.Adornee ~= part then gui.Adornee = part end
            if gui.Face ~= Enum.NormalId.Top then gui.Face = Enum.NormalId.Top end
            lastSeenRun[gui] = time
            
            local label = gui:FindFirstChild("ValueText")
            if not (label and label:IsA("TextLabel")) then
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextLabel") then child:Destroy() end
                end
                label = Instance.new("TextLabel")
                label.Name = "ValueText"
                label.Size = UDim2.fromScale(1, 1)
                label.Position = UDim2.fromScale(0, 0)
                label.BackgroundTransparency = 1
                label.TextSize = 60
                label.TextWrapped = false
                label.Font = t2
                label.Text = ""
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.Parent = gui
            end
            gui.Enabled, label.Visible = true, true
            if rot.on then
                pcall(function() RotCtl.add(label, part) end)
            end
            return gui, label
        end
        
        local function getGridIndex(delta, cell, tol)
            tol = math.clamp(tol or 0.25, 0, 0.49)
            local raw = delta / cell
            local idx = math.floor(raw + 0.5)
            if math.abs(raw - idx) > 0.5 + tol then
                idx = idx + (raw > idx and 1 or -1)
            end
            return idx
        end
        
        local function findPartsFolder()
            local w = workspace
            local flag = w:FindFirstChild("Flag")
            if flag then
                local parts = flag:FindFirstChild("Parts")
                if parts and parts:IsA("Folder") then return parts end
            end
            local parts = w:FindFirstChild("Parts", true)
            if parts and parts:IsA("Folder") then return parts end
            local best, bestCount = nil, -1
            for _, obj in ipairs(w:GetDescendants()) do
                if obj:IsA("Folder") and obj.Name == "Parts" then
                    local count = 0
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("BasePart") then count = count + 1 end
                    end
                    if count > bestCount then
                        best, bestCount = obj, count
                    end
                end
            end
            return best
        end
        
        -- Main update function
        local function update()
            if not (state and state.b and state.c == q) then return end
            
            local now = tick()
            if now - updateThrottle < THROTTLE_INTERVAL then return end
            updateThrottle = now
            
            local folder = findPartsFolder()
            if not folder then return end
            
            local player = l.LocalPlayer
            local char = player and player.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
            
            if vb and u2 > 0 and not root then return end
            local useRange = vb and (u2 > 0 and root ~= nil)
            local rangeSq = useRange and (u2 * u2) or nil
            
            -- Collect parts
            local parts = {}
            local time = tick()
            local processList = folder:GetChildren()
            
            for _, part in ipairs(processList) do
                if part:IsA("BasePart") and part.Anchored ~= false then
                    local skip = false
                    if useRange then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist > u2 then skip = true end
                    end
                    if not skip then
                        local id = getDebugId(part)
                        local data = A4[id]
                        if not data then
                            local numGui = part:FindFirstChild("NumberGui", true)
                            local label
                            if numGui then
                                label = numGui:FindFirstChildWhichIsA("TextLabel") or numGui:FindFirstChild("TextLabel")
                            end
                            local flagged = hasFlag(part)
                            data = {
                                part = part,
                                pos = part.Position,
                                size = part.Size,
                                label = (label and label:IsA("TextLabel")) and label or nil,
                                flagged = flagged,
                                time = time
                            }
                            A4[id] = data
                        else
                            data.pos = part.Position
                            data.size = part.Size
                            data.time = time
                            data.flagged = hasFlag(part)
                            if not data.label then
                                local numGui = part:FindFirstChild("NumberGui", true)
                                if numGui then
                                    local label = numGui:FindFirstChildWhichIsA("TextLabel") or numGui:FindFirstChild("TextLabel")
                                    if label and label:IsA("TextLabel") then data.label = label end
                                end
                            end
                        end
                        table.insert(parts, data)
                    end
                end
            end
            
            if #parts == 0 then return end
            
            -- Find revealed parts
            local revealed = {}
            local centerPart, centerPos, minDist = nil, nil, math.huge
            for _, data in ipairs(parts) do
                if data.label then
                    table.insert(revealed, data)
                    if root then
                        local dist = (data.pos - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            centerPart = data.part
                            centerPos = data.pos
                        end
                    end
                end
            end
            
            -- Update center if needed
            local timeDiff = time - (A3.a or 0)
            local needUpdate = (timeDiff >= s2) or (A3.b == nil)
            if needUpdate or (A3.b == nil) then
                A3.a = time
                if centerPart then
                    A3.b = centerPart
                    A3.c = centerPos
                    local sx = math.max(A2, centerPart.Size.X or 0)
                    local sz = math.max(A2, centerPart.Size.Z or 0)
                    A3.d = math.max(A2, math.min(sx, sz))
                else
                    local folder = getFolder()
                    for _, gui in ipairs(folder:GetChildren()) do
                        gui.Enabled = false
                    end
                    return
                end
            end
            
            if not A3.b or not A3.c then
                local folder = getFolder()
                for _, gui in ipairs(folder:GetChildren()) do
                    gui.Enabled = false
                end
                return
            end
            
            -- Build grid
            local cpos = A3.c
            local cellSize = A3.d
            local gridMap = {}
            local minX, maxX, minY, maxY = math.huge, -math.huge, math.huge, -math.huge
            
            for _, data in ipairs(parts) do
                local gx = getGridIndex(data.pos.X - cpos.X, cellSize, 0.25)
                local gy = getGridIndex(data.pos.Z - cpos.Z, cellSize, 0.25)
                if gx < minX then minX = gx end
                if gx > maxX then maxX = gx end
                if gy < minY then minY = gy end
                if gy > maxY then maxY = gy end
                local key = tostring(gx) .. ":" .. tostring(gy)
                if not gridMap[key] then
                    gridMap[key] = data
                end
            end
            
            minX, maxX = minX - 1, maxX + 1
            minY, maxY = minY - 1, maxY + 1
            local offX, offY = (minX - 1), (minY - 1)
            local width = (maxX - minX + 1)
            local height = (maxY - minY + 1)
            
            if width <= 0 or height <= 0 then return end
            
            -- Initialize grid
            local grid = {}
            for y = 1, height do
                grid[y] = {}
                for x = 1, width do
                    grid[y][x] = { state = "covered", number = 0, data = nil }
                end
            end
            
            -- Mark revealed cells
            for _, data in ipairs(revealed) do
                local gx = getGridIndex(data.pos.X - cpos.X, cellSize, 0.25)
                local gy = getGridIndex(data.pos.Z - cpos.Z, cellSize, 0.25)
                local x = gx - offX
                local y = gy - offY
                if x >= 1 and x <= width and y >= 1 and y <= height then
                    grid[y][x].state = "revealed"
                    grid[y][x].number = (getNumber(data.label.Text) or tonumber(data.label.Text) or 0)
                    grid[y][x].data = data
                end
            end
            
            -- Mark all cells
            for gx = minX, maxX do
                for gy = minY, maxY do
                    local data = gridMap[tostring(gx) .. ":" .. tostring(gy)]
                    if data then
                        local x = gx - offX
                        local y = gy - offY
                        if x >= 1 and x <= width and y >= 1 and y <= height then
                            grid[y][x].data = data
                            if grid[y][x].state ~= "revealed" and data.flagged then
                                grid[y][x].state = "flagged"
                            end
                        end
                    end
                end
            end
            
            -- Simple probability analysis
            local prob = {}
            for y = 1, height do
                prob[y] = {}
            end
            
            -- Calculate probabilities
            local totalCovered = 0
            for y = 1, height do
                for x = 1, width do
                    if grid[y][x].state == "covered" then
                        totalCovered = totalCovered + 1
                    end
                end
            end
            
            local globalProb = 0.5
            if totalCovered > 0 then
                -- Simple heuristic: each covered cell has equal probability
                for y = 1, height do
                    for x = 1, width do
                        if grid[y][x].state == "covered" then
                            prob[y][x] = globalProb
                        end
                    end
                end
            end
            
            -- Find safe tiles and mines
            local safeTiles = {}
            local mines = {}
            
            for y = 1, height do
                for x = 1, width do
                    if grid[y][x].state == "revealed" and grid[y][x].number > 0 then
                        local adjacent = getAdjacent(y, x, height, width)
                        local covered = {}
                        local flagged = 0
                        
                        for _, adj in ipairs(adjacent) do
                            local ay, ax = adj[1], adj[2]
                            if grid[ay][ax].state == "flagged" then
                                flagged = flagged + 1
                            elseif grid[ay][ax].state == "covered" then
                                table.insert(covered, {ay, ax})
                            end
                        end
                        
                        local remaining = grid[y][x].number - flagged
                        if #covered > 0 then
                            if remaining == 0 then
                                -- All adjacent are safe
                                for _, cell in ipairs(covered) do
                                    local ay, ax = cell[1], cell[2]
                                    if grid[ay][ax].data and grid[ay][ax].data.part then
                                        table.insert(safeTiles, {
                                            part = grid[ay][ax].data.part,
                                            prob = 0
                                        })
                                    end
                                end
                            elseif remaining == #covered then
                                -- All adjacent are mines
                                for _, cell in ipairs(covered) do
                                    local ay, ax = cell[1], cell[2]
                                    if grid[ay][ax].data and grid[ay][ax].data.part then
                                        table.insert(mines, {
                                            part = grid[ay][ax].data.part,
                                            prob = 1
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- RUN: Click safe tiles (inti dari auto solver)
            if #safeTiles > 0 then
                -- Sort by probability (lowest first)
                table.sort(safeTiles, function(a, b) return a.prob < b.prob end)
                
                for _, tile in ipairs(safeTiles) do
                    local part = tile.part
                    if part and part.Parent then
                        local clicked = clickTile(part, char, run.range)
                        if clicked then
                            -- Berhenti setelah mengklik satu tile
                            break
                        end
                    end
                end
            end
            
            -- AUTO FLAG: Flag mines (opsional)
            if autoFlag.on and #mines > 0 then
                for _, mine in ipairs(mines) do
                    local part = mine.part
                    if part and part.Parent then
                        flagTile(part, char, autoFlag.range)
                        task.wait(autoFlag.speed)
                    end
                end
            end
            
            -- AUTO GUESS: Jika tidak ada safe tiles dan threshold diatur
            if #safeTiles == 0 and #mines == 0 and guess.threshold > 0 then
                -- Cari tile dengan probability terendah
                local lowestProb = 1
                local bestTile = nil
                
                for y = 1, height do
                    for x = 1, width do
                        if grid[y][x].state == "covered" and grid[y][x].data and grid[y][x].data.part then
                            local p = prob[y][x] or globalProb
                            if p < lowestProb then
                                -- Cek jarak
                                local part = grid[y][x].data.part
                                if char and run.range > 0 then
                                    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                                    if root then
                                        local dist = getDistance(part, root)
                                        if dist <= run.range then
                                            lowestProb = p
                                            bestTile = part
                                        end
                                    end
                                else
                                    lowestProb = p
                                    bestTile = part
                                end
                            end
                        end
                    end
                end
                
                if bestTile and lowestProb <= guess.threshold then
                    clickTile(bestTile, char, run.range)
                end
            end
            
            -- Update GUI
            local folderGui = getFolder()
            local guiTime = tick()
            local guiUpdates = {}
            
            for y = 1, height do
                for x = 1, width do
                    local cell = grid[y][x]
                    local data = cell.data
                    local part = data and data.part
                    if part and part:IsA("BasePart") then
                        if cell.state == "flagged" then
                            table.insert(guiUpdates, {part = part, text = "⚑", color = Color3.fromRGB(255, 0, 0)})
                        elseif cell.state == "covered" then
                            local p = prob[y][x] or globalProb or 0.5
                            if p >= 0.95 then
                                table.insert(guiUpdates, {part = part, text = "💣", color = Color3.fromRGB(255, 0, 0)})
                            elseif p <= 0.05 then
                                table.insert(guiUpdates, {part = part, text = "✓", color = Color3.fromRGB(0, 255, 0)})
                            else
                                local pct = math.floor(p * 100)
                                table.insert(guiUpdates, {part = part, text = pct.."%", color = probColor(p)})
                            end
                        else
                            -- Disable GUI for revealed cells
                            local id = getDebugId(part)
                            local gui = folderGui:FindFirstChild(id)
                            if gui then
                                gui.Enabled = false
                                lastSeenRun[gui] = guiTime
                            end
                        end
                    end
                end
            end
            
            for _, update in ipairs(guiUpdates) do
                local gui, label = getOrCreateGui(folderGui, update.part, guiTime)
                if gui and label and label.Text ~= update.text then
                    label.Text = update.text
                    if update.color then
                        label.TextColor3 = update.color
                    end
                end
            end
            
            -- Cleanup old GUIs
            for _, gui in ipairs(folderGui:GetChildren()) do
                local lastTime = lastSeenRun[gui]
                local alive = gui.Adornee and gui.Adornee.Parent
                if (lastTime ~= guiTime) or (not alive) then
                    guiCache[gui.Name] = nil
                    gui:Destroy()
                end
            end
        end
        
        -- Main loop
        while state and state.b and state.c == q do
            pcall(update)
            task.wait(r)
            
            -- Cleanup old data
            local now = tick()
            if now % 3 < 0.1 then
                for id, data in pairs(A4) do
                    if (now - (data.time or 0)) > 10 then
                        A4[id] = nil
                    end
                end
            end
        end
        
        if not state or state.c == q then
            cleanup()
            for k in pairs(guiCache) do
                guiCache[k] = nil
            end
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

-- 4 toggle: Run, Range, Auto Flag, Rotation
local toggles = { btnRun, btnRange, btnAutoFlag, btnRot }
for _, btt in ipairs(toggles) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

local function btnBool(b) return (b and getState(b)) or false end

local function pushState()
    local sOn = btnRun and getState(btnRun) or nil  -- Run sebagai inti
    local m   = boxMax  and tonum(boxMax.Text)  or nil
    local us  = boxUS   and tonum(boxUS.Text)   or nil
    local ps  = boxPS   and tonum(boxPS.Text)   or nil
    local fe  = parseFont(boxText.Text) or Enum.Font.Arcade
    local r2  = boxR    and tonum(boxR.Text)    or nil
    local rOn = btnBool(btnRange)  -- Range opsional
    local flagOn = btnBool(btnAutoFlag)  -- Auto Flag opsional
    local fr  = boxFlagRange and tonum(boxFlagRange.Text) or 16
    local fs  = boxFS and tonum(boxFS.Text) or 0.05
    local guessThresh = boxGuess and tonum(boxGuess.Text) or 0.5
    local roOn = btnBool(btnRot)  -- Rotation opsional
    
    if sOn == false then
        callS(false)
        return
    end
    
    callS(false)
    -- Parameters: scriptOn, max, uspeed, pspeed, font, range, rangeOn, runOn, flagRange, fspeed, rotOn, guessThreshold
    callS(sOn, m, us, ps, fe, r2, rOn, sOn, fr, fs, roOn, guessThresh)
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

bindToggle(btnRun)
bindToggle(btnRange)
bindToggle(btnAutoFlag)
bindToggle(btnRot)

local function bindBox(tb)
    if not tb then return end
    tb.ClearTextOnFocus = false
    tb.FocusLost:Connect(function()
        pushState()
    end)
end

bindBox(boxMax)
bindBox(boxUS)
bindBox(boxPS)
bindBox(boxR)
bindBox(boxFlagRange)
bindBox(boxFS)
bindBox(boxGuess)

-- Drag and drop functionality
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
