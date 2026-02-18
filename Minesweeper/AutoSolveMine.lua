-- bLockerman's Minesweeper, NothingNesser's Script Fix + Auto Solver Fixed (ROBLOX)
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
    Size = u(0, 650, 0, 350),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.86 })

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
    Text = "Auto Solver Fixed (Run + Flag Integrated)",
    TextSize = 18,
    TextColor3 = c(200, 200, 200),
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

-- Masih 4 toggle sesuai original
local btnRange  = ico("range", .37886)
local btnAutoSolver = ico("autosolver", .61352)  -- Mengganti autoclick jadi autosolver
local btnScript = ico("script", .14419)
local btnRot    = ico("rotation", .84818)

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

lbl("Auto Solver", .2796, .05033, .06, .15)  -- Run + Flag jadi satu
lbl("Range", .29895, .28344, .07, .13)
lbl("Flag Range", .2796, .51656, .08, .12)   -- Label untuk flag range
lbl("Rotation", .2796, .74967, .06, .09)

local patchedLabel = n("TextLabel", a, {
    Text = "(Fixed: Only flag mines, click safe tiles)",
    TextSize = 11,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.3, 0, 0.06, 0),
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

local boxMax  = txt("max", "5000", .16214, .40588, .07417, "5000")
local boxPS   = txt("pspeed", "1", .16214, .79948, .07417, "1")
local boxR    = txt("r", "100", .16214, .40403, .30729, "100")
local boxF    = txt("f", "16", .16398, .40403, .5404, "16")  -- Flag range
local boxFS   = txt("fspeed", "0.05", .16398, .60019, .5404, "0.05")
local boxText = txt("text", "Arcade", .55574, .40588, .77, "Arcade")
local boxUS = txt("uspeed", "0.2", .16214, .60268, .07417, "0.2")

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

-- Fungsi untuk mengecek jarak
local function getDistance(part1, part2)
    if not part1 or not part2 then return math.huge end
    return (part1.Position - part2.Position).Magnitude
end

-- Fungsi untuk mengecek apakah tile sudah memiliki flag
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

-- Fungsi untuk mengecek apakah tile sudah pernah diklik
local function hasBeenClicked(part)
    if not part then return false end
    return part:GetAttribute("Clicked") == true
end

-- Fungsi untuk mengklik tile aman
local function clickSafeTile(part, playerChar, flagRange)
    if not part then return false end
    if hasFlag(part) or hasBeenClicked(part) then return false end
    
    if playerChar and flagRange and flagRange > 0 then
        local root = playerChar:FindFirstChild("HumanoidRootPart") or playerChar:FindFirstChild("Torso")
        if root then
            local dist = getDistance(part, root)
            if dist > flagRange then return false end
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

-- Fungsi untuk memberi flag pada mine
local function flagMine(part, playerChar, flagRange)
    if not part then return false end
    if hasFlag(part) then return false end
    
    if playerChar and flagRange and flagRange > 0 then
        local root = playerChar:FindFirstChild("HumanoidRootPart") or playerChar:FindFirstChild("Torso")
        if root then
            local dist = getDistance(part, root)
            if dist > flagRange then return false end
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

-- Fungsi utama Auto Solver (Run + Flag terintegrasi)
function S(t, a1, c1, d1, f1, g1, h1, x1, v1, n1, y1)
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
    
    i.d = {
        r = 0.05,  -- Update lebih cepat
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 1000, y = tonumber(a1) or 1000 },
        ac = { 
            on = e(x1),  -- Auto Solver toggle (menggabungkan Run + Flag)
            rad = tonumber(v1) or 20, 
            intv = tonumber(n1) or 0.05,
            fspd = tonumber(boxFS.Text) or 0.05,
            flagRange = tonumber(boxF.Text) or 16  -- Flag range dari input
        },
        rot = {
            on = rotOn == nil and false or rotOn,
            ro = tonumber(rotOpt and rotOpt.ro) or 180,
            tN = math.max(1, tonumber(rotOpt and rotOpt.tN or 1)),
            uR = (rotOpt and rotOpt.uR == false) and false or true
        }
    }
    
    if not j or not i.d.ac.on then  -- Mati jika auto solver nonaktif
        i.c = i.c + 1
        i.b = false
        k()
        return
    end
    
    i.c = i.c + 1
    local q = i.c
    i.b = true
    
    task.spawn(function()
        local r = 0.05  -- Update cepat
        local s2 = i.d.s
        local t2 = i.d.t
        local u2 = i.d.u
        local vb = i.d.vb
        local w2 = i.d.w
        local ac = i.d.ac
        local rot = i.d.rot
        local flagRange = ac.flagRange
        
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
        local THROTTLE_INTERVAL = 0.02
        
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
            return d and tonumber(d) or 0
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
            if rot.on then
                pcall(function() RotCtl.add(J, part) end)
            end
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
            local w=game:GetService("Workspace")
            local d=w:FindFirstChild("Flag")
            if d then
                local u=d:FindFirstChild("Parts")
                if u and u:IsA("Folder")then return u end
            end
            local p=w:FindFirstChild("Parts",true)
            if p and p:IsA("Folder")then return p end
            local b,bC=nil,-1
            for _,i in ipairs(w:GetDescendants())do
                if i:IsA("Folder") and i.Name=="Parts" then
                    local c=0
                    for _,ch in ipairs(i:GetChildren())do
                        if ch:IsA("BasePart")then c+=1 end
                    end
                    if c>bC then b,bC=i,c end
                end
            end
            return b
        end
        
        local function B6()
            if not (state and state.b and state.c == q) then return end
            
            local currentTime = tick()
            if currentTime - updateThrottle < THROTTLE_INTERVAL then return end
            updateThrottle = currentTime
            
            local L = fd()
            if not L then return end
            
            local o0 = l.LocalPlayer
            local M = nil
            local playerChar = nil
            if o0 and o0.Character then
                playerChar = o0.Character
                M = playerChar:FindFirstChild("HumanoidRootPart") or playerChar:FindFirstChild("Torso")
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
                            local Y = hasFlag(R)
                            V = { a = R, b = R.Position, c = R.Size, d = (W and W:IsA("TextLabel")) and W or nil, e = Y, f = Q }
                            A4[U] = V
                        else
                            V.b = R.Position
                            V.c = R.Size
                            V.f = Q
                            V.e = hasFlag(R)
                            if not V.d then
                                local X = R:FindFirstChild("NumberGui", true)
                                if X then
                                    local W = X:FindFirstChildWhichIsA("TextLabel") or X:FindFirstChild("TextLabel")
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
                    local sx = math.max(1e-6, tonumber(a1.Size.X) or 0)
                    local sz = math.max(1e-6, tonumber(a1.Size.Z) or 0)
                    A3.d = math.max(1e-6, math.min(sx, sz))
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
            
            for _, V in ipairs(P) do
                local gx = GridIndex(V.b.X - cpos.X, d0, 0.25)
                local gy = GridIndex(V.b.Z - cpos.Z, d0, 0.25)
                if gx < d2 then d2 = gx end
                if gx > d3 then d3 = gx end
                if gy < d4 then d4 = gy end
                if gy > d5 then d5 = gy end
                local K3 = B1(gx, gy)
                if not d1[K3] then
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
                            if b0[r0][c0].a ~= "revealed" and V.e then
                                b0[r0][c0].a = "flagged"
                            end
                        end
                    end
                end
            end
            
            -- Fungsi analisis probability (sama seperti original)
            local function B3n(E0, Wn, Hn, total, cfg)
                cfg = cfg or {}
                local x0 = cfg.maxClusterSize or w2.x
                local x1 = cfg.hardCapNodes or w2.y
                local c1, c2 = 0, 0
                for r0 = 1, Hn do
                    for c0 = 1, Wn do
                        local s0 = E0[r0][c0].a
                        if s0 == "covered" then c1 = c1 + 1
                        elseif s0 == "flagged" then c2 = c2 + 1 end
                    end
                end
                
                -- Algoritma probability (sama seperti original)
                local vI, iV, cs = {}, {}, {}
                local function K2(r1, c1x) return tostring(r1) .. ":" .. tostring(c1x) end
                
                for r0 = 1, Hn do
                    for c0 = 1, Wn do
                        if E0[r0][c0].a == "revealed" then
                            local u0 = {}
                            local need = E0[r0][c0].b or 0
                            for _, rc in ipairs(B3(r0, c0, Hn, Wn)) do
                                local rr, cc = rc[1], rc[2]
                                local s1 = E0[rr][cc].a
                                if s1 == "flagged" then
                                    need = need - 1
                                elseif s1 == "covered" then
                                    local k2 = K2(rr, cc)
                                    if not vI[k2] then
                                        vI[k2] = #iV + 1
                                        iV[#iV + 1] = { rr, cc }
                                    end
                                    u0[#u0 + 1] = vI[k2]
                                end
                            end
                            if #u0 > 0 then
                                cs[#cs + 1] = { vars = u0, need = need }
                            end
                        end
                    end
                end
                
                -- Hasil probability
                local pr = {}
                for r0 = 1, Hn do pr[r0] = {} end
                
                -- Isi default probability
                for _, cell in ipairs(iV) do
                    pr[cell[1]][cell[2]] = 0.5
                end
                
                local knownTotal = (total ~= nil)
                local rem = nil
                if knownTotal then
                    rem = math.max((total or 0) - c2, 0)
                end
                
                local gP = 0.5
                if knownTotal and rem then
                    local tc = 0
                    for r0 = 1, Hn do
                        for c0 = 1, Wn do
                            if E0[r0][c0].a == "covered" then tc = tc + 1 end
                        end
                    end
                    if rem > 0 then gP = rem / math.max(tc, 1) end
                end
                
                return { a = pr, b = gP, c = Wn, d = Hn }
            end
            
            local d9 = B3n(b0, Wc, Hc, nil, { maxClusterSize = w2.x, hardCapNodes = w2.y })
            local pr = d9.a or {}
            local gP = d9.b
            
            local bombsToFlag = {}      -- Hanya untuk mine (probability tinggi)
            local safeTilesToClick = {}  -- Hanya untuk tile aman (probability rendah)
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    if b0[r0][c0].a == "revealed" then
                        for _, rc in ipairs(B3(r0, c0, Hc, Wc)) do
                            local rr, cc = rc[1], rc[2]
                            if b0[rr][cc].a == "covered" then
                                local v0 = (pr[rr] and pr[rr][cc]) or gP or 0.5
                                
                                -- PASTI MINE (probability tinggi)
                                if v0 >= 0.95 then
                                    local cellData = b0[rr][cc]
                                    if cellData and cellData.c and cellData.c.a then
                                        if not hasFlag(cellData.c.a) then
                                            table.insert(bombsToFlag, {
                                                part = cellData.c.a,
                                                prob = v0
                                            })
                                        end
                                    end
                                -- PASTI AMAN (probability rendah)  
                                elseif v0 <= 0.05 then
                                    local cellData = b0[rr][cc]
                                    if cellData and cellData.c and cellData.c.a then
                                        if not hasBeenClicked(cellData.c.a) and not hasFlag(cellData.c.a) then
                                            table.insert(safeTilesToClick, {
                                                part = cellData.c.a,
                                                prob = v0
                                            })
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- FLAG MINES: Hanya flag tile probability tinggi (>95%)
            if #bombsToFlag > 0 then
                for _, bombData in ipairs(bombsToFlag) do
                    local part = bombData.part
                    if part and part.Parent then
                        flagMine(part, playerChar, flagRange)
                    end
                end
            end
            
            -- CLICK SAFE TILES: Hanya klik tile probability rendah (<5%)
            if #safeTilesToClick > 0 then
                -- Urutkan dari yang paling aman
                table.sort(safeTilesToClick, function(a, b) return a.prob < b.prob end)
                
                for _, safeData in ipairs(safeTilesToClick) do
                    local part = safeData.part
                    if part and part.Parent then
                        local clicked = clickSafeTile(part, playerChar, flagRange)
                        if clicked then
                            break  -- Berhenti setelah mengklik satu tile
                        end
                    end
                end
            end
            
            -- Update GUI
            local F0 = A6()
            local G = tick()
            local guiUpdates = {}
            
            for r0 = 1, Hc do
                for c0 = 1, Wc do
                    local d8 = b0[r0][c0]
                    local V = d8.c
                    local p3 = V and V.a
                    if p3 and p3:IsA("BasePart") then
                        if d8.a == "flagged" then
                            guiUpdates[#guiUpdates + 1] = {part = p3, text = utf8.char(0x1F4A5), color = nil}
                        elseif d8.a == "covered" then
                            local v0 = (pr[r0] and pr[r0][c0]) or gP or 0.5
                            if v0 >= 0.95 then
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = "💣", color = Color3.fromRGB(255, 0, 0)}
                            elseif v0 <= 0.05 then
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = "✓", color = Color3.fromRGB(0, 255, 0)}
                            else
                                local pct = math.floor(v0 * 100)
                                guiUpdates[#guiUpdates + 1] = {part = p3, text = pct.."%", color = A8(v0)}
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
            
            A3.f, A3.g = d1, b0
            A3.h, A3.i = Wc, Hc
            A3.j, A3.k = pr, gP
        end
        
        -- Loop utama dengan update cepat
        while state and state.b and state.c == q do
            pcall(B6)
            task.wait(r)
        end
        
        if not state or state.c == q then 
            k()
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

-- 4 toggle sesuai original
local toggles = { btnScript, btnRange, btnAutoSolver, btnRot }
for _, btt in ipairs(toggles) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

local function btnBool(b) return (b and getState(b)) or false end

local function pushState()
    local sOn = btnScript and getState(btnScript) or nil
    local m   = boxMax  and tonum(boxMax.Text)  or nil
    local us  = boxUS   and tonum(boxUS.Text)   or nil
    local ps  = boxPS   and tonum(boxPS.Text)   or nil
    local fe  = boxText and parseFont(boxText.Text) or nil
    local r2  = boxR    and tonum(boxR.Text)    or nil
    local rOn = btnBool(btnRange)
    local aOn = btnBool(btnAutoSolver)  -- Auto Solver (Run + Flag)
    local f2  = boxF    and tonum(boxF.Text)    or 16
    local fs  = boxFS   and tonum(boxFS.Text)   or 0.05
    local roOn = btnBool(btnRot)
    
    if sOn == false then
        callS(false)
        return
    end
    
    callS(false)
    -- Parameter: script, max, uspeed, pspeed, font, range, rangeOn, autoSolverOn, flagRange, fspeed, rotOn
    callS(sOn, m, us, ps, fe, r2, rOn, aOn, f2, fs, roOn)
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
bindToggle(btnAutoSolver)
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
bindBox(boxF)
bindBox(boxFS)
bindBox(boxText)

-- Drag and drop functionality (sama seperti original)
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
