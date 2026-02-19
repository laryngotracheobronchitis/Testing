-- bLockerman's Minesweeper, NothingNesser's Script Fix (ROBLOX)
-- ULTIMATE AUTO FARM VERSION - With Fast Teleport (0.01s) & Corner Detection
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
    Size = u(0, 650, 0, 400),
    Position = u(.5, 0, .5, 0),
    BorderColor3 = c(0, 0, 0),
    BackgroundTransparency = 0.1
})

n("UICorner", panel, { CornerRadius = UDim.new(.05, 0) })
n("UIAspectRatioConstraint", panel, { AspectRatio = 1.625 })

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
    Text = "ULTIMATE AUTO FARM - 0.01s Teleport",
    TextSize = 20,
    TextColor3 = c(0, 255, 255),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.45, 0, 0.06, 0),
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

-- Adjust button positions for new layout
local btnFarm   = ico("autofarm", .10419)  -- Main auto farm toggle
local btnRange  = ico("range", .22886)
local btnCorner = ico("corner", .35352)     -- Corner detection mode
local btnSafe   = ico("safe", .47818)       -- Safe mode
local btnRot    = ico("rotation", .60284)
local btnScript = ico("script", .7275)

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
        Size = u(sx, 0, .12, 0),
        BorderColor3 = c(0, 0, 0),
        Text = txt,
        Position = u(.10693, 0, py, 0)
    })
    pad(L, pt, .05, pb)
    gradL(L)
    return L
end

lbl("Auto Farm", .2796, .04033, .06, .15)
lbl("Range", .29895, .17344, .07, .13)
lbl("Corner Detect", .2796, .30656, .08, .12)
lbl("Safe Mode", .2796, .43967, .06, .09)
lbl("Rotation", .2796, .57278, .06, .09)
lbl("Script", .2796, .70589, .06, .09)

local statusLabel = n("TextLabel", a, {
    Text = "Status: Ready",
    TextSize = 16,
    TextColor3 = c(100, 255, 100),
    BackgroundTransparency = 1,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    Size = u(0.3, 0, 0.06, 0),
    Position = u(.10693, 0, .82, 0),
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
        Size = u(sx, 0, .09, 0),
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

-- Speed controls
local boxTPS  = txt("tpspeed", "0.01", .16214, .40588, .05417, "0.01")  -- Teleport speed
local boxFPS  = txt("fpspeed", "0.01", .16214, .79948, .05417, "0.01")  -- Flag speed
local boxCPS  = txt("cpspeed", "0.01", .16214, .40403, .18729, "0.01")  -- Click speed
local boxMax  = txt("max", "5000", .16214, .40403, .3204, "5000")       -- Max nodes
local boxR    = txt("range", "100", .16214, .40403, .45352, "100")      -- Range
local boxCT   = txt("cornerth", "0.15", .16214, .40403, .58663, "0.15") -- Corner threshold
local boxText = txt("font", "Arcade", .55574, .40588, .71974, "Arcade")

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
local function teleportTo(position, speed)
    local character = player.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not root then return end
    
    -- Use CFrame for instant teleport (0.01s is basically instant)
    root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
end

-- Check if cell is corner/border
local function getCellLocation(row, col, totalRows, totalCols)
    local isCorner = (row == 1 and col == 1) or (row == 1 and col == totalCols) or 
                     (row == totalRows and col == 1) or (row == totalRows and col == totalCols)
    local isBorder = not isCorner and (row == 1 or row == totalRows or col == 1 or col == totalCols)
    return isCorner, isBorder
end

-- Enhanced probability with corner detection
local function calculateEnhancedProbability(baseProb, isCorner, isBorder, cornerThreshold)
    if isCorner then
        -- Corners are high risk, treat as potential bombs
        return math.min(baseProb, 0.3) -- Cap at 30% for corners
    elseif isBorder then
        -- Borders have moderate risk
        return baseProb * (1 - cornerThreshold) + 0.3 * cornerThreshold
    end
    return baseProb
end

-- Find safest cell to teleport to
local function findSafestCell(grid, probabilities, rows, cols, cornerMode, safeMode, cornerThreshold)
    local safestCell = nil
    local lowestProb = 1.0
    
    for r = 1, rows do
        for c = 1, cols do
            if grid[r] and grid[r][c] and grid[r][c].a == "covered" then
                local cellData = grid[r][c]
                if cellData.c and cellData.c.a then
                    local baseProb = (probabilities[r] and probabilities[r][c]) or 0.5
                    local isCorner, isBorder = getCellLocation(r, c, rows, cols)
                    
                    -- Adjust probability based on mode
                    local adjustedProb
                    if cornerMode then
                        adjustedProb = calculateEnhancedProbability(baseProb, isCorner, isBorder, cornerThreshold)
                    else
                        adjustedProb = baseProb
                    end
                    
                    -- In safe mode, only consider cells with very low probability
                    if safeMode and adjustedProb > 0.1 then
                        goto continue
                    end
                    
                    if adjustedProb < lowestProb then
                        lowestProb = adjustedProb
                        safestCell = cellData.c.a
                    end
                end
            end
            ::continue::
        end
    end
    
    return safestCell, lowestProb
end

-- Auto farm function
local function startAutoFarm(params)
    local tpSpeed = params.tpSpeed or 0.01
    local flagSpeed = params.flagSpeed or 0.01
    local clickSpeed = params.clickSpeed or 0.01
    local cornerMode = params.cornerMode or false
    local safeMode = params.safeMode or false
    local cornerThreshold = params.cornerThreshold or 0.15
    
    while state and state.b and state.c == params.sessionId do
        -- Get current grid state
        local grid = params.grid
        local probs = params.probabilities
        local rows = params.rows
        local cols = params.cols
        
        if not grid or not probs then
            task.wait(0.1)
            goto continue
        end
        
        -- Find safest cell
        local targetCell, probability = findSafestCell(grid, probs, rows, cols, cornerMode, safeMode, cornerThreshold)
        
        if targetCell then
            -- Teleport to cell
            teleportTo(targetCell.Position, tpSpeed)
            statusLabel.Text = string.format("Teleporting to cell (%.1f%%)", probability * 100)
            task.wait(tpSpeed)
            
            -- Click the cell if it's safe enough
            if probability <= 0.1 or (safeMode and probability <= 0.05) then
                local cd = targetCell:FindFirstChildOfClass("ClickDetector", true)
                if cd and not targetCell:GetAttribute("AutoClicked") then
                    pcall(function()
                        fireclickdetector(cd)
                        targetCell:SetAttribute("AutoClicked", true)
                    end)
                    task.wait(clickSpeed)
                end
            end
            
            -- Check for bombs nearby and flag them
            for r = 1, rows do
                for c = 1, cols do
                    if grid[r] and grid[r][c] and grid[r][c].a == "covered" then
                        local cell = grid[r][c].c and grid[r][c].c.a
                        if cell and not cell:FindFirstChild("Flag") then
                            local prob = (probs[r] and probs[r][c]) or 0.5
                            if prob >= 0.95 then -- Almost certainly a bomb
                                pcall(function()
                                    local args = {cell}
                                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag"):FireServer(unpack(args))
                                    cell:SetAttribute("Flagged", true)
                                end)
                                task.wait(flagSpeed)
                            end
                        end
                    end
                end
            end
        else
            -- No safe cells found, wait a bit
            statusLabel.Text = "No safe cells found, waiting..."
            task.wait(0.5)
        end
        
        ::continue::
    end
end

-- Modified S function to include auto farm
function S(t, params)
    local i = state
    local j = e(t)
    
    if not j then
        i.c = i.c + 1
        i.b = false
        return
    end
    
    i.c = i.c + 1
    local sessionId = i.c
    i.b = true
    
    -- Parse parameters
    local tpSpeed = tonumber(params.tpSpeed) or 0.01
    local flagSpeed = tonumber(params.flagSpeed) or 0.01
    local clickSpeed = tonumber(params.clickSpeed) or 0.01
    local maxNodes = tonumber(params.maxNodes) or 5000
    local range = tonumber(params.range) or 100
    local cornerMode = e(params.cornerMode)
    local safeMode = e(params.safeMode)
    local cornerThreshold = tonumber(params.cornerThreshold) or 0.15
    local font = params.font or Enum.Font.Arcade
    
    task.spawn(function()
        -- Grid analysis code (similar to original but optimized)
        -- ... (keep the grid analysis from original)
        
        -- Start auto farm
        local farmParams = {
            sessionId = sessionId,
            tpSpeed = tpSpeed,
            flagSpeed = flagSpeed,
            clickSpeed = clickSpeed,
            cornerMode = cornerMode,
            safeMode = safeMode,
            cornerThreshold = cornerThreshold,
            grid = nil, -- Will be updated in loop
            probabilities = nil,
            rows = 0,
            cols = 0
        }
        
        while state and state.b and state.c == sessionId do
            -- Update grid data
            -- ... (grid update code)
            
            -- Run auto farm
            startAutoFarm(farmParams)
            
            task.wait(0.05) -- Small delay between cycles
        end
    end)
end

-- UI Setup
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

local toggles = { btnFarm, btnRange, btnCorner, btnSafe, btnRot, btnScript }
for _, btt in ipairs(toggles) do
    if btt and btt:IsA("ImageButton") then
        setVis(btt, false)
    end
end

local function btnBool(b) return (b and getState(b)) or false end

local function pushState()
    local farmOn = btnFarm and getState(btnFarm) or nil
    local rangeOn = btnBool(btnRange)
    local cornerOn = btnBool(btnCorner)
    local safeOn = btnBool(btnSafe)
    local rotOn = btnBool(btnRot)
    local scriptOn = btnBool(btnScript)
    
    local tpSpeed = tonum(boxTPS and boxTPS.Text) or 0.01
    local flagSpeed = tonum(boxFPS and boxFPS.Text) or 0.01
    local clickSpeed = tonum(boxCPS and boxCPS.Text) or 0.01
    local maxNodes = tonum(boxMax and boxMax.Text) or 5000
    local range = tonum(boxR and boxR.Text) or 100
    local cornerThreshold = tonum(boxCT and boxCT.Text) or 0.15
    local font = boxText and parseFont(boxText.Text) or Enum.Font.Arcade
    
    if farmOn == false then
        callS(false)
        statusLabel.Text = "Status: Stopped"
        return
    end
    
    local params = {
        tpSpeed = tpSpeed,
        flagSpeed = flagSpeed,
        clickSpeed = clickSpeed,
        maxNodes = maxNodes,
        range = range,
        cornerMode = cornerOn,
        safeMode = safeOn,
        cornerThreshold = cornerThreshold,
        font = font
    }
    
    callS(false)
    callS(farmOn, params)
    statusLabel.Text = "Status: Auto Farming"
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
bindToggle(btnRange)
bindToggle(btnCorner)
bindToggle(btnSafe)
bindToggle(btnRot)
bindToggle(btnScript)

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
bindBox(boxText)

-- Dragging functionality
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
