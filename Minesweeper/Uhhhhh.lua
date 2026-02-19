-- MINESWEEPER HYBRID (Sweep GUI + Minesweeper Detection)
-- Menggunakan sistem deteksi corner dari Minesweeper.lua
-- Dengan GUI dan framework dari Sweep.lua

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
    Size = u(0, 600, 0, 308),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.95 })

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
    Text = "HYBRID: Sweep GUI + Minesweeper Detection",
    TextSize = 18,
    TextColor3 = c(0, 255, 255),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.45, 0, 0.08, 0),
    Position = u(0.53, 0, 0.01, 0),
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

local btnRange  = ico("range", .37886)
local btnAuto   = ico("autoclick", .61352)
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

lbl("Run", .2796, .05033, .06, .15)
lbl("Range", .29895, .28344, .07, .13)
lbl("Flag", .2796, .51656, .08, .12)
lbl("Rotation", .2796, .74967, .06, .09)

local patchedLabel = n("TextLabel", a, {
    Text = "(Minesweeper Detection)",
    TextSize = 11,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.2, 0, 0.06, 0),
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
local boxF    = txt("f", "16", .16398, .40403, .5404, "16")
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
    Text = "HYBRID",
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

-- ==================== MINESWEEPER DETECTION SYSTEM ====================
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

-- Data structure dari Minesweeper.lua
local data = {
    cells = {all = {}, numbered = {}, toFlag = {}, toClear = {}, guess = {}},
    cache = {xs_centers_cached = nil, zs_centers_cached = nil},
    grid = {w = 0, h = 0},
    ui = {PROB_FLAG_THRESHOLD = 0.7, PROB_SAFE_THRESHOLD = 0.3},
    timing = {lastPlanTick = 0, planIntervalMs = 50},
    highlights = {}
}

local abs, floor, huge = math.abs, math.floor, math.huge
local sort = table.sort

local function isNumber(str)
    return tonumber(str) ~= nil
end

local function key(ix, iz)
    return tostring(ix) .. ":" .. tostring(iz)
end

local function clusterSorted(sorted_list, epsilon)
    local clusters = {}
    if #sorted_list == 0 then return clusters end
    
    local current_center = sorted_list[1]
    local current_count = 1
    
    for i = 2, #sorted_list do
        local v = sorted_list[i]
        if abs(v - current_center) <= epsilon then
            current_count = current_count + 1
            current_center = current_center + ((v - current_center) / current_count)
        else
            table.insert(clusters, current_center)
            current_center = v
            current_count = 1
        end
    end
    table.insert(clusters, current_center)
    return clusters
end

local function median(tbl)
    if #tbl == 0 then return nil end
    sort(tbl)
    local mid = floor((#tbl + 1) / 2)
    return tbl[mid]
end

local function typicalSpacing(sorted_centers)
    if #sorted_centers < 2 then return 4 end
    
    local diffs = {}
    for i = 2, #sorted_centers do
        diffs[#diffs + 1] = abs(sorted_centers[i] - sorted_centers[i - 1])
    end
    return median(diffs) or 4
end

local function nearestIndex(v, centers)
    local bestI = 1
    local bestD = huge
    for i = 1, #centers do
        local d = abs(v - centers[i])
        if d < bestD then
            bestD = d
            bestI = i
        end
    end
    return bestI - 1
end

local function isCoveredCell(cell)
    if not cell then return false end
    if cell.state == "number" or cell.state == "flagged" then return false end
    return cell.covered ~= false
end

local function isPartFlagged(part)
    if not part or not part.GetChildren then return false end
    
    local children = part:GetChildren()
    for _, child in pairs(children) do
        local name = child and child.Name
        if name and string.sub(name, 1, 4) == "Flag" then
            return true
        end
    end
    return false
end

-- Fungsi buildGrid dari Minesweeper.lua (yang lebih akurat di corner)
local function buildGrid()
    data.cells.all = {}
    data.cells.numbered = {}
    data.cells.grid = {}
    
    local root = game.Workspace:FindFirstChild("Flag")
    if not root then
        warn("Cannot find workspace.Flag")
        return
    end
    
    local partsFolder = root:FindFirstChild("Parts")
    if not partsFolder then
        warn("Cannot find workspace.Flag.Parts")
        return
    end
    
    local parts = partsFolder:GetChildren()
    print("Found " .. #parts .. " parts")
    
    local raw = {}
    local sumY, countY = 0, 0
    
    for _, part in pairs(parts) do
        local pos = part and part.Position
        if pos then
            table.insert(raw, {part = part, pos = pos})
            sumY = sumY + pos.Y
            countY = countY + 1
        end
    end
    
    local centersX, centersZ = {}, {}
    for _, item in ipairs(raw) do
        centersX[#centersX + 1] = item.pos.X
        centersZ[#centersZ + 1] = item.pos.Z
    end
    
    sort(centersX)
    sort(centersZ)
    
    local typicalWX = typicalSpacing(centersX)
    local typicalWZ = typicalSpacing(centersZ)
    
    local epsX = typicalWX * 0.6
    local epsZ = typicalWZ * 0.6
    
    data.cache.xs_centers_cached = clusterSorted(centersX, epsX)
    data.cache.zs_centers_cached = clusterSorted(centersZ, epsZ)
    
    data.grid.w = #data.cache.xs_centers_cached
    data.grid.h = #data.cache.zs_centers_cached
    
    print("Grid size: " .. data.grid.w .. "x" .. data.grid.h)
    
    local planeY = (countY > 0) and (sumY / countY) or 0
    
    -- Initialize grid cells
    for iz = 0, data.grid.h - 1 do
        for ix = 0, data.grid.w - 1 do
            local k = key(ix, iz)
            local row = data.cells.grid[ix]
            if not row then
                row = {}
                data.cells.grid[ix] = row
            end
            
            local cell = {
                ix = ix,
                iz = iz,
                part = nil,
                pos = Vector3.new(
                    data.cache.xs_centers_cached[ix + 1] or 0,
                    planeY,
                    data.cache.zs_centers_cached[iz + 1] or 0
                ),
                state = "unknown",
                number = nil,
                k = k,
                covered = true,
                neigh = nil
            }
            
            data.cells.all[k] = cell
            row[iz] = cell
        end
    end
    
    -- Map parts to cells
    for _, item in ipairs(raw) do
        local part = item.part
        local pos = item.pos
        local ix = nearestIndex(pos.X, data.cache.xs_centers_cached)
        local iz = nearestIndex(pos.Z, data.cache.zs_centers_cached)
        
        if ix >= 0 and ix < data.grid.w and iz >= 0 and iz < data.grid.h then
            local k = key(ix, iz)
            local cell = data.cells.all[k]
            
            if not cell.part then
                cell.part = part
                cell.pos = pos
            else
                local cur_d = abs(((cell.part and cell.part.Position.X) or cell.pos.X) - data.cache.xs_centers_cached[ix + 1]) +
                             abs(((cell.part and cell.part.Position.Z) or cell.pos.Z) - data.cache.zs_centers_cached[iz + 1])
                local new_d = abs(pos.X - data.cache.xs_centers_cached[ix + 1]) + abs(pos.Z - data.cache.zs_centers_cached[iz + 1])
                if new_d < cur_d then
                    cell.part = part
                    cell.pos = pos
                end
            end
            
            -- Check number
            local ngui = part:FindFirstChild("NumberGui")
            if ngui then
                local textLabel = ngui:FindFirstChild("TextLabel")
                if textLabel and textLabel.Text and isNumber(textLabel.Text) then
                    cell.number = tonumber(textLabel.Text)
                    cell.covered = false
                end
            end
            
            -- Check flagged
            if isPartFlagged(part) then
                cell.state = "flagged"
            end
            
            if cell.number and not cell.covered then
                cell.state = "number"
                table.insert(data.cells.numbered, cell)
            end
        end
    end
    
    print("Found " .. #data.cells.numbered .. " numbered cells")
    
    -- Set neighbors
    for iz = 0, data.grid.h - 1 do
        for ix = 0, data.grid.w - 1 do
            local c = data.cells.grid[ix][iz]
            local neigh = {}
            
            for dz = -1, 1 do
                for dx = -1, 1 do
                    if not (dx == 0 and dz == 0) then
                        local jx, jz = ix + dx, iz + dz
                        if jx >= 0 and jx < data.grid.w and jz >= 0 and jz < data.grid.h then
                            local row = data.cells.grid[jx]
                            local n = row and row[jz]
                            if n then
                                neigh[#neigh + 1] = n
                            end
                        end
                    end
                end
            end
            
            c.neigh = neigh
        end
    end
end

local function neighbors(ix, iz)
    local row = data.cells.grid[ix]
    local c = row and row[iz]
    return (c and c.neigh) or {}
end

-- PLAN MOVE dari Minesweeper.lua (deteksi corner yang akurat)
local function planMove()
    if not data.cache.xs_centers_cached or not data.cache.zs_centers_cached or data.grid.w == 0 or data.grid.h == 0 then
        return
    end
    
    if #data.cells.numbered == 0 then
        data.cells.toFlag = {}
        data.cells.toClear = {}
        data.cells.guess = {}
        return
    end
    
    data.cells.toFlag = {}
    data.cells.toClear = {}
    data.cells.guess = {}
    
    local knownFlag = {}
    for _, cell in pairs(data.cells.all) do
        if cell.state == "flagged" then
            knownFlag[cell] = true
        end
    end
    
    local knownClear = {}
    local scratch = {}
    
    local function computeUnknowns(c)
        local nbs = neighbors(c.ix, c.iz)
        
        for i = 1, #scratch do
            scratch[i] = nil
        end
        
        local flaggedCount = 0
        for i = 1, #nbs do
            local nb = nbs[i]
            if knownFlag[nb] or nb.state == "flagged" then
                flaggedCount = flaggedCount + 1
            elseif not knownClear[nb] and isCoveredCell(nb) then
                scratch[#scratch + 1] = nb
            end
        end
        
        return scratch, flaggedCount
    end
    
    local changed = true
    local guard = 0
    
    while changed and guard < 64 do
        changed = false
        guard = guard + 1
        
        for _, cell in ipairs(data.cells.numbered) do
            local num = cell.number or 0
            local unknowns, flaggedCount = computeUnknowns(cell)
            local remaining = num - flaggedCount
            
            if remaining > 0 and remaining == #unknowns then
                for i = 1, #unknowns do
                    local u = unknowns[i]
                    if not knownFlag[u] then
                        knownFlag[u] = true
                        data.cells.toFlag[u] = true
                        changed = true
                    end
                end
            elseif remaining == 0 and #unknowns > 0 then
                for i = 1, #unknowns do
                    local u = unknowns[i]
                    if not knownClear[u] then
                        knownClear[u] = true
                        data.cells.toClear[u] = true
                        changed = true
                    end
                end
            end
        end
    end
    
    local accum = {}
    for _, cell in ipairs(data.cells.numbered) do
        local num = cell.number or 0
        local unknowns, flaggedCount = computeUnknowns(cell)
        local remaining = num - flaggedCount
        
        if remaining > 0 and #unknowns > 0 then
            local p_each = remaining / #unknowns
            for i = 1, #unknowns do
                local u = unknowns[i]
                if not knownFlag[u] and not knownClear[u] then
                    local e = accum[u]
                    if not e then
                        e = {sum = 0, w = 0}
                        accum[u] = e
                    end
                    e.sum = e.sum + p_each
                    e.w = e.w + 1
                end
            end
        end
    end
    
    local pflag = data.ui.PROB_FLAG_THRESHOLD
    for cell, e in pairs(accum) do
        local p = (e.w > 0 and e.sum / e.w) or 0
        if knownFlag[cell] then
            data.cells.toFlag[cell] = true
        elseif p >= pflag then
            data.cells.toFlag[cell] = true
            knownFlag[cell] = true
        else
            data.cells.guess[cell] = p
        end
    end
    
    for cell, _ in pairs(data.cells.toFlag) do
        data.cells.toClear[cell] = nil
        data.cells.guess[cell] = nil
    end
    
    for cell, _ in pairs(data.cells.toClear) do
        data.cells.toFlag[cell] = nil
        data.cells.guess[cell] = nil
    end
    
    for cell, _ in pairs(data.cells.guess) do
        if knownFlag[cell] then
            data.cells.guess[cell] = nil
        end
    end
end

-- FUNGSI UTAMA SOLVER (menggabungkan semuanya)
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
        r = tonumber(c1) or 0.2,
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 1000, y = tonumber(a1) or 1000 },
        ac = { on = e(x1), rad = tonumber(v1) or 20, intv = tonumber(n1) or 0.05 },
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
        local rot = i.d.rot
        
        -- Rotation control (dari Sweep)
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
        
        -- Auto Click (dari Sweep)
        if ac.on then
            task.spawn(function()
                local l = game:GetService("Players")
                while state and state.b and state.c == q and ac.on do
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
        end
        
        -- Variables untuk GUI (dari Sweep)
        local z = 1e-4
        local A2 = 1e-6
        local A3 = { a = 0, b = nil, c = nil, d = 1, e = nil, f = nil, g = nil, h = 0, i = 0, j = nil, k = 0.5 }
        local A4 = {}
        local lastSeenRun = setmetatable({}, { __mode = "k" })
        local l = game:GetService("Players")
        local A5 = game:GetService("Workspace")
        local cg = game.CoreGui
        local guiCache = {}
        local partCache = {}
        local updateThrottle = 0
        local THROTTLE_INTERVAL = 0.05
        
        -- Fungsi GUI (dari Sweep)
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
            if a2 < 0 then return 0 
            elseif a2 > 1 then return 1 
            else return a2 end 
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
        
        -- MAIN LOOP - Menggunakan buildGrid dan planMove dari Minesweeper
        local lastBuild = 0
        
        local function update()
            if not (state and state.b and state.c == q) then return end
            
            local currentTime = tick()
            if currentTime - updateThrottle < THROTTLE_INTERVAL then
                return
            end
            updateThrottle = currentTime
            
            -- Build grid (dari Minesweeper)
            if (currentTime - lastBuild) > 2 then
                buildGrid()
                lastBuild = currentTime
            end
            
            if data.grid.w == 0 or not data.cache.xs_centers_cached or not data.cache.zs_centers_cached then
                return
            end
            
            -- Plan move (dari Minesweeper)
            local nowMs = currentTime * 1000
            if data.timing.lastPlanTick == 0 or (nowMs - data.timing.lastPlanTick) >= data.timing.planIntervalMs then
                planMove()
                data.timing.lastPlanTick = nowMs
            end
            
            -- Update GUI (dari Sweep)
            local F0 = A6()
            local G = tick()
            local guiUpdates = {}
            
            -- Konversi hasil Minesweeper ke GUI Sweep
            for _, cell in pairs(data.cells.all) do
                if cell.part and cell.part:IsA("BasePart") then
                    local part = cell.part
                    local text = ""
                    local color = nil
                    
                    if data.cells.toFlag[cell] then
                        text = utf8.char(0x1F4A5)  -- Bomb emoji
                    elseif data.cells.toClear[cell] then
                        text = utf8.char(0x2705)  -- Check emoji
                    elseif data.cells.guess[cell] then
                        local prob = data.cells.guess[cell] * 100
                        text = string.format("%.0f%%", prob)
                        color = A8(data.cells.guess[cell])
                    elseif cell.state == "flagged" then
                        text = utf8.char(0x1F4A5)  -- Bomb emoji
                    elseif cell.number then
                        text = tostring(cell.number)
                        color = Color3.fromRGB(255, 255, 255)
                    end
                    
                    if text ~= "" then
                        guiUpdates[#guiUpdates + 1] = {part = part, text = text, color = color}
                    end
                end
            end
            
            -- Apply GUI updates
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
            
            -- Cleanup old GUIs
            for _, I in ipairs(F0:GetChildren()) do
                local K0 = lastSeenRun[I]
                local alive = I.Adornee and I.Adornee.Parent
                if (K0 ~= G) or (not alive) then
                    guiCache[I.Name] = nil
                    I:Destroy()
                end
            end
        end
        
        -- Run loop
        while state and state.b and state.c == q do
            pcall(update)
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

-- ==================== UI CONTROL ====================
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

local toggles = { btnScript, btnRange, btnAuto, btnRot }
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
    local aOn = btnBool(btnAuto)
    local f2  = boxF    and tonum(boxF.Text)    or nil
    local fs  = boxFS   and tonum(boxFS.Text)   or nil
    local roOn = btnBool(btnRot)
    if sOn == false then
        callS(false)
        return
    end
    callS(false)
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
bindToggle(btnAuto)
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

-- Drag functionality
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

print("✅ HYBRID SOLVER loaded!")
print("📌 GUI: Sweep.lua")
print("🎯 Detection: Minesweeper.lua (corner detection)")
print("⚡ Click the ⚡ button to open menu")
