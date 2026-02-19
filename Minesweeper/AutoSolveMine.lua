-- bLockerman's Minesweeper, NothingNesser's Script Fix (ROBLOX)
-- ULTIMATE AUTO FARM WITH CORNER DETECTION & AUTO GUESS
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
    Size = u(0, 700, 0, 450),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.55 })

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
    Text = "AUTO FARM + CORNER DETECTION + AUTO GUESS",
    TextSize = 18,
    TextColor3 = c(0, 255, 255),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.5, 0, 0.06, 0),
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

-- Reorganize buttons for new features
local btnFarm   = ico("autofarm", .10419)     -- Auto Farm toggle
local btnCorner = ico("corner", .22886)        -- Corner Detection
local btnGuess  = ico("guess", .35352)         -- Auto Guess
local btnAuto   = ico("autoclick", .47818)     -- Auto Click
local btnRange  = ico("range", .60284)         -- Range
local btnScript = ico("script", .7275)         -- Script
local btnRot    = ico("rotation", .85216)      -- Rotation

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

lbl("Auto Farm", .2796, .04033, .06, .15)
lbl("Corner Detect", .29895, .17344, .07, .13)
lbl("Auto Guess", .2796, .30656, .08, .12)
lbl("Auto Click", .2796, .43967, .06, .09)
lbl("Range", .2796, .57278, .06, .09)
lbl("Script", .2796, .70589, .06, .09)
lbl("Rotation", .2796, .839, .06, .09)

local statusLabel = n("TextLabel", a, {
    Text = "Status: Ready",
    TextSize = 16,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.3, 0, 0.05, 0),
    Position = u(.10693, 0, .91, 0),
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
        Size = u(sx, 0, .1, 0),
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

-- Speed and threshold controls
local boxTPS  = txt("tpspeed", "0.01", .16214, .40588, .05417, "0.01")  -- Teleport speed
local boxFPS  = txt("fpspeed", "0.01", .16214, .79948, .05417, "0.01")  -- Flag speed
local boxCPS  = txt("cpspeed", "0.01", .16214, .40403, .18729, "0.01")  -- Click speed
local boxMax  = txt("max", "5000", .16214, .40403, .3204, "5000")       -- Max nodes
local boxR    = txt("range", "100", .16214, .40403, .45352, "100")      -- Range
local boxCT   = txt("cornerth", "0.2", .16214, .40403, .58663, "0.2")   -- Corner threshold
local boxGT   = txt("guessth", "0.4", .16214, .40403, .71974, "0.4")    -- Guess threshold
local boxText = txt("font", "Arcade", .55574, .40588, .85285, "Arcade")

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
    Text = "0.01s",
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
local tweenService = game:GetService("TweenService")

local function e(vv)
    if type(vv) == "boolean" then return vv end
    if type(vv) == "string" then
        local s0 = vv:lower()
        return (s0 == "enable" or s0 == "on" or s0 == "true" or s0 == "start")
    end
    return vv and true or false
end

-- Fast teleport function
local function teleportTo(position)
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not root then return end
    
    -- Instant teleport
    root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
end

-- Advanced corner detection
local function detectCornerCell(row, col, totalRows, totalCols, grid)
    local isCorner = (row == 1 and col == 1) or (row == 1 and col == totalCols) or 
                     (row == totalRows and col == 1) or (row == totalRows and col == totalCols)
    
    if not isCorner then
        -- Check if it's actually a corner based on revealed cells
        local adjacentRevealed = 0
        for dr = -1, 1 do
            for dc = -1, 1 do
                if not (dr == 0 and dc == 0) then
                    local rr, cc = row + dr, col + dc
                    if rr >= 1 and rr <= totalRows and cc >= 1 and cc <= totalCols then
                        if grid[rr] and grid[rr][cc] and grid[rr][cc].a == "revealed" then
                            adjacentRevealed = adjacentRevealed + 1
                        end
                    end
                end
            end
        end
        -- If surrounded by revealed cells, it's not a corner
        isCorner = adjacentRevealed <= 2
    end
    
    return isCorner
end

-- Advanced probability calculation with corner override
local function calculateFinalProbability(baseProb, row, col, totalRows, totalCols, grid, cornerMode, cornerThreshold)
    local isCorner = detectCornerCell(row, col, totalRows, totalCols, grid)
    
    if isCorner and cornerMode then
        -- CORNER OVERRIDE: If we can visually see it's a bomb, force probability
        -- Check if there's any visual indicator of bomb
        local cell = grid[row] and grid[row][col] and grid[row][col].c and grid[row][col].c.a
        if cell then
            -- Check for bomb indicators (visual cues)
            if cell:FindFirstChild("Flag") or cell:GetAttribute("Flagged") then
                return 1.0 -- Definitely a bomb
            end
            
            -- Check surrounding numbers to confirm corner
            local surroundingBombs = 0
            local surroundingCells = 0
            for dr = -1, 1 do
                for dc = -1, 1 do
                    if not (dr == 0 and dc == 0) then
                        local rr, cc = row + dr, col + dc
                        if rr >= 1 and rr <= totalRows and cc >= 1 and cc <= totalCols then
                            if grid[rr] and grid[rr][cc] and grid[rr][cc].a == "revealed" then
                                surroundingCells = surroundingCells + 1
                                surroundingBombs = surroundingBombs + (grid[rr][cc].b or 0)
                            end
                        end
                    end
                end
            end
            
            -- If numbers indicate it must be a bomb
            if surroundingBombs >= surroundingCells then
                return 1.0
            end
        end
        
        -- If not confirmed, use adjusted probability
        return math.min(baseProb, 0.3) -- Cap at 30% for corners
    end
    
    return baseProb
end

-- Auto guess function for 50/50 situations
local function autoGuess(grid, probabilities, rows, cols, guessThreshold)
    local candidates = {}
    
    for r = 1, rows do
        for c = 1, cols do
            if grid[r] and grid[r][c] and grid[r][c].a == "covered" then
                local prob = (probabilities[r] and probabilities[r][c]) or 0.5
                
                -- Check if this is a 50/50 situation
                if math.abs(prob - 0.5) < 0.1 then
                    -- Check adjacent revealed cells
                    local adjacentNumbers = {}
                    for dr = -1, 1 do
                        for dc = -1, 1 do
                            if not (dr == 0 and dc == 0) then
                                local rr, cc = r + dr, c + dc
                                if rr >= 1 and rr <= rows and cc >= 1 and cc <= cols then
                                    if grid[rr] and grid[rr][cc] and grid[rr][cc].a == "revealed" then
                                        table.insert(adjacentNumbers, grid[rr][cc].b or 0)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- If adjacent numbers suggest it's a pattern
                    if #adjacentNumbers >= 2 then
                        table.insert(candidates, {
                            row = r,
                            col = c,
                            cell = grid[r][c].c and grid[r][c].c.a,
                            prob = prob
                        })
                    end
                end
            end
        end
    end
    
    -- Choose the best candidate (lowest probability)
    if #candidates > 0 then
        table.sort(candidates, function(a, b) return a.prob < b.prob end)
        return candidates[1]
    end
    
    return nil
end

-- Find safest cell to click
local function findSafestCell(grid, probabilities, rows, cols, cornerMode, cornerThreshold)
    local safestCell = nil
    local lowestProb = 1.0
    local cornerCells = {}
    
    for r = 1, rows do
        for c = 1, cols do
            if grid[r] and grid[r][c] and grid[r][c].a == "covered" then
                local cellData = grid[r][c]
                if cellData.c and cellData.c.a then
                    local baseProb = (probabilities[r] and probabilities[r][c]) or 0.5
                    local finalProb = calculateFinalProbability(baseProb, r, c, rows, cols, grid, cornerMode, cornerThreshold)
                    
                    -- Store corner cells separately
                    if finalProb < 0.3 then
                        table.insert(cornerCells, {
                            cell = cellData.c.a,
                            prob = finalProb,
                            row = r,
                            col = c
                        })
                    end
                    
                    if finalProb < lowestProb then
                        lowestProb = finalProb
                        safestCell = cellData.c.a
                    end
                end
            end
        end
    end
    
    -- Prefer corner cells if they exist and are safe
    if #cornerCells > 0 and lowestProb > 0.1 then
        table.sort(cornerCells, function(a, b) return a.prob < b.prob end)
        return cornerCells[1].cell, cornerCells[1].prob
    end
    
    return safestCell, lowestProb
end

-- Main auto farm function
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
    
    -- Get auto farm parameters
    local autoFarm = e(x1)  -- Using x1 as auto farm toggle
    local cornerMode = e(v1) -- Using v1 as corner mode
    local autoGuess = e(n1)  -- Using n1 as auto guess
    
    -- Get speed settings
    local tpSpeed = tonumber(boxTPS and boxTPS.Text) or 0.01
    local flagSpeed = tonumber(boxFPS and boxFPS.Text) or 0.01
    local clickSpeed = tonumber(boxCPS and boxCPS.Text) or 0.01
    local cornerThreshold = tonumber(boxCT and boxCT.Text) or 0.2
    local guessThreshold = tonumber(boxGT and boxGT.Text) or 0.4
    
    i.d = {
        r = tonumber(c1) or 0.01,
        s = tonumber(d1) or 3,
        t = f1 or Enum.Font.Arcade,
        u = tonumber(g1) or 100,
        vb = e(h1),
        w = { x = tonumber(a1) or 5000, y = tonumber(a1) or 5000 },
        ac = { 
            on = autoFarm,
            rad = 100,
            intv = 0.01,
            tpSpeed = tpSpeed,
            flagSpeed = flagSpeed,
            clickSpeed = clickSpeed,
            cornerMode = cornerMode,
            autoGuess = autoGuess,
            cornerThreshold = cornerThreshold,
            guessThreshold = guessThreshold
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
        local rot = i.d.rot
        
        -- Original grid analysis code (keep as is)
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
        
        local function B4(p0) return tostring(p0:GetDebugId()) end
        
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
        
        -- Main auto farm loop
        while state and state.b and state.c == q do
            pcall(function()
                -- Get current grid state
                local L = fd()
                if not L then return end
                
                -- Build grid representation (simplified version of original B6)
                local parts = {}
                for _, part in ipairs(L:GetChildren()) do
                    if part:IsA("BasePart") then
                        table.insert(parts, part)
                    end
                end
                
                if #parts == 0 then return end
                
                -- Find reference cell for grid alignment
                local refPart = nil
                local refPos = nil
                local minDist = math.huge
                local char = player.Character
                local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
                
                if root then
                    for _, part in ipairs(parts) do
                        local dist = (part.Position - root.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            refPart = part
                            refPos = part.Position
                        end
                    end
                end
                
                if not refPart then
                    refPart = parts[1]
                    refPos = refPart.Position
                end
                
                -- Determine grid cell size
                local cellSize = math.min(refPart.Size.X, refPart.Size.Z)
                if cellSize <= 0 then cellSize = 4 end
                
                -- Build grid
                local grid = {}
                local minX, maxX = math.huge, -math.huge
                local minZ, maxZ = math.huge, -math.huge
                
                for _, part in ipairs(parts) do
                    local gx = GridIndex(part.Position.X - refPos.X, cellSize, 0.25)
                    local gz = GridIndex(part.Position.Z - refPos.Z, cellSize, 0.25)
                    
                    if gx < minX then minX = gx end
                    if gx > maxX then maxX = gx end
                    if gz < minZ then minZ = gz end
                    if gz > maxZ then maxZ = gz end
                    
                    local key = tostring(gx) .. ":" .. tostring(gz)
                    grid[key] = grid[key] or {}
                    grid[key].part = part
                    grid[key].gx = gx
                    grid[key].gz = gz
                    
                    -- Check if revealed
                    local numGui = part:FindFirstChild("NumberGui", true)
                    if numGui then
                        local textLabel = numGui:FindFirstChildWhichIsA("TextLabel") or numGui:FindFirstChild("TextLabel")
                        if textLabel and textLabel:IsA("TextLabel") then
                            local num = T1(textLabel.Text) or tonumber(textLabel.Text)
                            if num then
                                grid[key].revealed = true
                                grid[key].number = num
                            end
                        end
                    end
                    
                    -- Check if flagged
                    if part:FindFirstChild("Flag") or part:FindFirstChild("Flagged") or part:GetAttribute("Flagged") then
                        grid[key].flagged = true
                    end
                end
                
                -- Convert to 2D array
                local cols = maxX - minX + 1
                local rows = maxZ - minZ + 1
                local grid2D = {}
                local probabilities = {}
                
                for r = 1, rows do
                    grid2D[r] = {}
                    probabilities[r] = {}
                    for c = 1, cols do
                        local gx = minX + c - 1
                        local gz = minZ + r - 1
                        local key = tostring(gx) .. ":" .. tostring(gz)
                        local cell = grid[key]
                        
                        if cell then
                            if cell.revealed then
                                grid2D[r][c] = { a = "revealed", b = cell.number, c = { a = cell.part } }
                            elseif cell.flagged then
                                grid2D[r][c] = { a = "flagged", c = { a = cell.part } }
                            else
                                grid2D[r][c] = { a = "covered", c = { a = cell.part } }
                            end
                            
                            -- Simple probability calculation
                            probabilities[r][c] = 0.5
                            
                            -- Adjust based on adjacent numbers
                            if grid2D[r][c].a == "covered" then
                                local adjacentNumbers = 0
                                local totalAdjacent = 0
                                for dr = -1, 1 do
                                    for dc = -1, 1 do
                                        if not (dr == 0 and dc == 0) then
                                            local rr, cc = r + dr, c + dc
                                            if rr >= 1 and rr <= rows and cc >= 1 and cc <= cols then
                                                if grid2D[rr] and grid2D[rr][cc] and grid2D[rr][cc].a == "revealed" then
                                                    adjacentNumbers = adjacentNumbers + (grid2D[rr][cc].b or 0)
                                                    totalAdjacent = totalAdjacent + 1
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if totalAdjacent > 0 then
                                    probabilities[r][c] = adjacentNumbers / (totalAdjacent * 8)
                                end
                            end
                        else
                            grid2D[r][c] = { a = "covered", c = nil }
                            probabilities[r][c] = 0.5
                        end
                    end
                end
                
                -- AUTO FARM LOGIC
                if ac.on then
                    -- First, flag confirmed bombs
                    local bombsToFlag = {}
                    for r = 1, rows do
                        for c = 1, cols do
                            if grid2D[r] and grid2D[r][c] and grid2D[r][c].a == "covered" then
                                local finalProb = calculateFinalProbability(
                                    probabilities[r][c], r, c, rows, cols, grid2D, 
                                    ac.cornerMode, ac.cornerThreshold
                                )
                                
                                if finalProb >= 0.99 then
                                    local cell = grid2D[r][c].c and grid2D[r][c].c.a
                                    if cell and not cell:FindFirstChild("Flag") and not cell:GetAttribute("Flagged") then
                                        table.insert(bombsToFlag, cell)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Flag bombs
                    for _, cell in ipairs(bombsToFlag) do
                        pcall(function()
                            local args = {cell}
                            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag"):FireServer(unpack(args))
                            cell:SetAttribute("Flagged", true)
                        end)
                        task.wait(ac.flagSpeed)
                    end
                    
                    -- Find safest cell to click
                    local targetCell, prob = findSafestCell(grid2D, probabilities, rows, cols, ac.cornerMode, ac.cornerThreshold)
                    
                    if targetCell then
                        -- Teleport to cell
                        teleportTo(targetCell.Position)
                        statusLabel.Text = string.format("Teleporting (%.1f%%)", prob * 100)
                        task.wait(ac.tpSpeed)
                        
                        -- Click if safe enough
                        if prob <= 0.1 then
                            local cd = targetCell:FindFirstChildOfClass("ClickDetector", true)
                            if cd and not targetCell:GetAttribute("AutoClicked") then
                                pcall(function()
                                    fireclickdetector(cd)
                                    targetCell:SetAttribute("AutoClicked", true)
                                end)
                                task.wait(ac.clickSpeed)
                            end
                        end
                    else
                        -- No safe cells found, try auto guess if enabled
                        if ac.autoGuess then
                            local guess = autoGuess(grid2D, probabilities, rows, cols, ac.guessThreshold)
                            if guess and guess.cell then
                                teleportTo(guess.cell.Position)
                                statusLabel.Text = string.format("Auto Guess (%.1f%%)", guess.prob * 100)
                                task.wait(ac.tpSpeed)
                                
                                local cd = guess.cell:FindFirstChildOfClass("ClickDetector", true)
                                if cd and not guess.cell:GetAttribute("AutoClicked") then
                                    pcall(function()
                                        fireclickdetector(cd)
                                        guess.cell:SetAttribute("AutoClicked", true)
                                    end)
                                end
                            else
                                statusLabel.Text = "No moves available"
                                task.wait(0.5)
                            end
                        else
                            statusLabel.Text = "Waiting for safe cells"
                            task.wait(0.5)
                        end
                    end
                end
                
                -- Cleanup old GUI
                local F0 = A6()
                for _, I in ipairs(F0:GetChildren()) do
                    if not I.Adornee or not I.Adornee.Parent then
                        I:Destroy()
                    end
                end
            end)
            
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
        bx.ImageRectSize = ON_OFF2
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

local toggles = { btnFarm, btnCorner, btnGuess, btnAuto, btnRange, btnScript, btnRot }
for _, btt in ipairs(toggles) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

local function btnBool(b) return (b and getState(b)) or false end

local function pushState()
    local farmOn = btnFarm and getState(btnFarm) or nil
    local cornerOn = btnCorner and getState(btnCorner) or nil
    local guessOn = btnGuess and getState(btnGuess) or nil
    local autoOn = btnAuto and getState(btnAuto) or nil
    local rangeOn = btnRange and getState(btnRange) or nil
    local scriptOn = btnScript and getState(btnScript) or nil
    local rotOn = btnRot and getState(btnRot) or nil
    
    local m = boxMax and tonum(boxMax.Text) or 5000
    local us = boxUS and tonum(boxUS.Text) or 0.2
    local ps = boxPS and tonum(boxPS.Text) or 1
    local fe = boxText and parseFont(boxText.Text) or Enum.Font.Arcade
    local r2 = boxR and tonum(boxR.Text) or 100
    local ct = boxCT and tonum(boxCT.Text) or 0.2
    local gt = boxGT and tonum(boxGT.Text) or 0.4
    
    if farmOn == false then
        callS(false)
        return
    end
    
    callS(false)
    -- Parameters: t, a1, c1, d1, f1, g1, h1, x1, v1, n1, y1
    -- x1 = auto farm, v1 = corner mode, n1 = auto guess
    callS(farmOn, m, us, ps, fe, r2, rangeOn, autoOn, cornerOn, guessOn, rotOn)
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

bindToggle(btnFarm)
bindToggle(btnCorner)
bindToggle(btnGuess)
bindToggle(btnAuto)
bindToggle(btnRange)
bindToggle(btnScript)
bindToggle(btnRot)

local function bindBox(tb)
    if not tb then return end
    tb.ClearTextOnFocus = false
    tb.FocusLost:Connect(function()
        pushState()
    end)
end

bindBox(boxTPS)
bindBox(boxFPS)
bindBox(boxCPS)
bindBox(boxMax)
bindBox(boxR)
bindBox(boxCT)
bindBox(boxGT)
bindBox(boxText)

-- Dragging functionality (keep original)
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
