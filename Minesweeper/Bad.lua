-- Minesweeper by timmy (Mobile Enhanced)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Minesweeper",
   Icon = "monitor",
   LoadingTitle = "Minesweeper",
   LoadingSubtitle = "by timmy",
   ShowText = "Minesweeper",
   Theme = "DarkBlue",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "MinesweeperTimmy"
   },
   Discord = {
      Enabled = false,
      Invite = "YPswajCcG",
      RememberJoins = true
   },
   KeySystem = false
})

-- ── Tabs ──────────────────────────────────────────────────────────
local SolverTab  = Window:CreateTab("Solver", "calculator")
local AutoTab    = Window:CreateTab("AutoFlag", "flag")
local RevealTab  = Window:CreateTab("Tiles Revealer", "eye")
local MobileTab  = Window:CreateTab("Mobile Revealer", "smartphone")

-- ── Solver Tab ────────────────────────────────────────────────────
local SolverSection = SolverTab:CreateSection("Highlights")

local solverEnabled    = false
local autoGuessEnabled = false

SolverTab:CreateToggle({
   Name = "Auto Solver",
   CurrentValue = false,
   Flag = "AutoSolver",
   Callback = function(Value)
      solverEnabled = Value
      if not Value then
         clearAllHL()
         state.lastPartCount = -1
      end
   end,
})

SolverTab:CreateToggle({
   Name = "Auto Guess",
   CurrentValue = false,
   Flag = "AutoGuess",
   Callback = function(Value)
      autoGuessEnabled = Value
   end,
})

-- ── Auto Tab ──────────────────────────────────────────────────────
local AutoSection = AutoTab:CreateSection("Auto Flag")

local autoFlagToggle = false
local flagDelay      = 0.02
local flagRange      = 80

AutoTab:CreateToggle({
   Name = "Auto Flag Mines",
   CurrentValue = false,
   Flag = "AutoFlag",
   Callback = function(Value)
      autoFlagToggle = Value
   end,
})

AutoTab:CreateSlider({
   Name = "Flag Delay",
   Range = {0, 10},
   Increment = 1,
   Suffix = "x0.1s",
   CurrentValue = 0,
   Flag = "FlagDelay",
   Callback = function(Value)
      flagDelay = Value * 0.1
   end,
})

AutoTab:CreateSlider({
   Name = "Flag Reach",
   Range = {1, 100},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 80,
   Flag = "FlagRange",
   Callback = function(Value)
      flagRange = Value
   end,
})

-- ── PC Revealer Tab ───────────────────────────────────────────────
local RevealSection = RevealTab:CreateSection("Tiles Revealer")

local touchTilesEnabled = false
local revealReach       = 15

local S_RightFoot       = "RightFoot"
local S_RightLeg        = "Right Leg"
local S_ProximityPrompt = "ProximityPrompt"

local _revealMethod = nil
local function getRevealMethod()
   if _revealMethod then return _revealMethod end
   if typeof(firetouchinterest) == "function" then
      local ok = pcall(firetouchinterest, workspace.Terrain, workspace.Terrain, 0)
      if ok then
         _revealMethod = "touch"
      elseif typeof(fireproximityprompt) == "function" then
         _revealMethod = "proximity"
      else
         _revealMethod = "cframe"
      end
   elseif typeof(fireproximityprompt) == "function" then
      _revealMethod = "proximity"
   else
      _revealMethod = "cframe"
   end
   return _revealMethod
end

RevealTab:CreateToggle({
   Name = "Tiles Revealer",
   CurrentValue = false,
   Flag = "TilesRevealer",
   Callback = function(Value)
      touchTilesEnabled = Value
      if not Value then return end

      task.spawn(function()
         while touchTilesEnabled do
            local char     = lp.Character
            local hrp      = char and char:FindFirstChild(S_HRP)
            local rightleg = char and (
               char:FindFirstChild(S_RightFoot) or
               char:FindFirstChild(S_RightLeg) or
               hrp
            )
            if rightleg and hrp then
               local method = getRevealMethod()
               local origin = hrp.Position
               local safeparts = {}
               for cell in pairs(state.cells.toClear) do
                  if cell.part and cell.part.Parent
                  and not isRevealed(cell)
                  and not state.cells.toFlag[cell] then
                     local dist = (origin - cell.part.Position).Magnitude
                     if dist <= revealReach then
                        safeparts[#safeparts+1] = cell.part
                     end
                  end
               end
               if method == "touch" then
                  for _, tile in ipairs(safeparts) do
                     if not touchTilesEnabled then break end
                     firetouchinterest(rightleg, tile, 0)
                     firetouchinterest(rightleg, tile, 1)
                  end
               elseif method == "proximity" then
                  for _, tile in ipairs(safeparts) do
                     if not touchTilesEnabled then break end
                     local pp = tile:FindFirstChildWhichIsA(S_ProximityPrompt, true)
                     if pp then pcall(fireproximityprompt, pp) end
                  end
               else
                  for _, tile in ipairs(safeparts) do
                     if not touchTilesEnabled then break end
                     hrp.CFrame = CFrame.new(tile.Position.X, tile.Position.Y + tile.Size.Y/2 + 1, tile.Position.Z)
                  end
               end
               task.wait()
            else
               task.wait(0.5)
            end
         end
      end)
   end,
})

RevealTab:CreateSlider({
   Name = "Reveal Reach",
   Range = {1, 30},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 15,
   Flag = "RevealReach",
   Callback = function(Value)
      revealReach = Value
   end,
})

-- ── Mobile Revealer Tab ───────────────────────────────────────────
local MobileSection = MobileTab:CreateSection("Mobile Teleport Revealer")

local mobileTeleportEnabled = false
local mobileTeleportDelay   = 0.5
local mobileTeleportReach   = 999

MobileTab:CreateToggle({
   Name = "Mobile Teleport Revealer",
   CurrentValue = false,
   Flag = "MobileTeleport",
   Callback = function(Value)
      mobileTeleportEnabled = Value
   end,
})

MobileTab:CreateSlider({
   Name = "Teleport Delay",
   Range = {1, 100},
   Increment = 1,
   Suffix = "x0.01s",
   CurrentValue = 50,
   Flag = "TeleportDelay",
   Callback = function(Value)
      mobileTeleportDelay = Value * 0.01
   end,
})

MobileTab:CreateSlider({
   Name = "Teleport Reach",
   Range = {10, 999},
   Increment = 10,
   Suffix = " studs",
   CurrentValue = 999,
   Flag = "TeleportReach",
   Callback = function(Value)
      mobileTeleportReach = Value
   end,
})

local MobileInfoSection = MobileTab:CreateSection("Info")
MobileTab:CreateLabel("Auto Guess ON: Delay x0.5")
MobileTab:CreateLabel("Auto Guess OFF: Normal delay")

-- ── Services ──────────────────────────────────────────────────────
local Players = game:GetService("Players")
local lp      = Players.LocalPlayer

-- ── String upvalues ───────────────────────────────────────────────
local S_NumberGui     = "NumberGui"
local S_TextLabel     = "TextLabel"
local S_BrickColor    = "BrickColor"
local S_HRP           = "HumanoidRootPart"
local S_ClickDetector = "ClickDetector"
local S_BasePart      = "BasePart"
local S_PlaceFlag     = "PlaceFlag"
local S_Part          = "Part"

-- ── Math/table upvalues ───────────────────────────────────────────
local abs, floor, huge, max, min = math.abs, math.floor, math.huge, math.max, math.min
local tsort, tinsert = table.sort, table.insert
local vec3, inst = Vector3.new, Instance.new

-- ── Colours ───────────────────────────────────────────────────────
local COLOR_SAFE  = Color3.fromRGB(0,   255, 80)
local COLOR_MINE  = Color3.fromRGB(255, 0,   0)
local COLOR_GUESS = Color3.fromRGB(0,   220, 255)

-- ── Token ─────────────────────────────────────────────────────────
local cachedToken = nil

pcall(function()
   local oldNamecall
   oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
      local s, method = pcall(getnamecallmethod)
      if not s or not method then return oldNamecall(self, ...) end
      local args = {...}
      if method == "FireServer" then
         local ok2, rname = pcall(function() return self.Name end)
         if ok2 and rname == S_PlaceFlag and typeof(args[2]) == "string" and #args[2] > 10 then
            if not cachedToken then
               cachedToken = args[2]
            end
         end
      end
      return oldNamecall(self, ...)
   end)
end)

task.spawn(function()
   task.wait(1)
   pcall(function()
      local mouse = game.Players.LocalPlayer:GetMouse()
      local con = getconnections(mouse.Button1Down)
      for i, v in next, con do
         if cachedToken then break end
         if v.Function then
            local u = getupvalues(v.Function)
            for l, d in next, u do
               if typeof(d) == "string" and #d >= 8 then
                  cachedToken = d
                  break
               end
            end
         end
      end
   end)
end)

local function getToken()
   return cachedToken
end

-- ── State ─────────────────────────────────────────────────────────
local autoFlaggedSet = {}
local state = {
   cells         = { grid = {}, numbered = {}, toFlag = {}, toClear = {} },
   grid          = { w = 0, h = 0 },
   lastPartCount = -1,
}
local hlActive      = {}
local changeQueue   = {}
local queueSet      = {}
local signalConns   = {}
local solverDirty   = false
local lastSolveTime = 0
local SOLVE_COOLDOWN = 0.15
local BATCH_SIZE     = 50
local cachedB        = nil

-- ── Helpers ───────────────────────────────────────────────────────
local function median(t)
   if #t == 0 then return nil end
   local s = {table.unpack(t)}
   tsort(s)
   return s[floor(#s / 2) + 1]
end

local function cluster(coords, thr)
   if #coords == 0 then return {} end
   local out = {coords[1]}
   for i = 2, #coords do
      if abs(coords[i] - out[#out]) > thr then
         tinsert(out, coords[i])
      end
   end
   return out
end

local function estS(coords)
   if #coords < 3 then return 4 end
   local d = {}
   for i = 2, #coords do d[#d+1] = abs(coords[i] - coords[i-1]) end
   return median(d) or 4
end

local function findI(t, s)
   local bI, bD = 1, huge
   for i = 1, #s do
      local d = abs(t - s[i])
      if d < bD then bD, bI = d, i end
   end
   return bI - 1
end

local function isRevealed(c)
   return c.state == "number" or c.covered == false
end

local function hasF(p)
   return p:FindFirstChildOfClass("Model") ~= nil
end

local function scanB()
   if cachedB and (not cachedB.Parent or #cachedB:GetChildren() == 0) then
      cachedB = nil
      state.lastPartCount = -1
   end
   if cachedB and cachedB.Parent then return cachedB end
   local f = workspace:FindFirstChild("Flag")
   local p = f and f:FindFirstChild("Parts")
   if p then cachedB = p; return p end
   local ch = workspace:GetChildren()
   for i = 1, #ch do
      local v = ch[i]
      if v:IsA("Folder") and #v:GetChildren() > 50 then
         local p1 = v:GetChildren()[1]
         if p1 and p1:IsA(S_BasePart) and p1.Name == S_Part then
            cachedB = v; return v
         end
      end
   end
   return nil
end

-- ── Highlight ─────────────────────────────────────────────────────
local function applyHL(c, col)
   if not c.part then return end
   if not c.hlPart then
      local sg = inst("SurfaceGui")
      sg.Face           = Enum.NormalId.Top
      sg.AlwaysOnTop    = true
      sg.LightInfluence = 0
      sg.SizingMode     = Enum.SurfaceGuiSizingMode.PixelsPerStud
      sg.PixelsPerStud  = 20
      sg.Parent         = c.part
      local frame = inst("Frame")
      frame.Size                   = UDim2.fromScale(1, 1)
      frame.BackgroundTransparency = 0.82
      frame.BackgroundColor3       = col
      frame.BorderSizePixel        = 0
      frame.Parent                 = sg
      local stroke = inst("UIStroke")
      stroke.Color        = col
      stroke.Thickness    = 2
      stroke.Transparency = 0.1
      stroke.Parent       = frame
      c.hlPart    = sg
      c._hlFrame  = frame
      c._hlStroke = stroke
   end
   c._hlFrame.BackgroundColor3       = col
   c._hlFrame.BackgroundTransparency = 0.82
   c._hlStroke.Color                 = col
   c.hlPart.Enabled                  = true
   c.isHL = true
end

local function hideHL(c)
   if c.hlPart then c.hlPart.Enabled = false end
   c.isHL = false
end

function clearAllHL()
   for c in pairs(hlActive) do hideHL(c) end
   hlActive = {}
   if not state.cells.grid then return end
   for x = 0, (state.grid.w or 0) - 1 do
      local col = state.cells.grid[x]
      if col then
         for z = 0, (state.grid.h or 0) - 1 do
            local c = col[z]
            if c then c.hlPart = nil; c.isHL = false end
         end
      end
   end
end

local function updateH()
   local toFlag  = state.cells.toFlag
   local toClear = state.cells.toClear
   for c in pairs(hlActive) do
      if isRevealed(c) or (not toFlag[c] and not toClear[c]) then
         hideHL(c)
         hlActive[c] = nil
      end
   end
   if not solverEnabled then return end
   for c in pairs(toFlag) do
      if not isRevealed(c) and not hlActive[c] and c.part and c.part.Parent then
         applyHL(c, COLOR_MINE)
         hlActive[c] = true
      end
   end
   for c in pairs(toClear) do
      if not isRevealed(c) and not hlActive[c] and c.part and c.part.Parent then
         applyHL(c, COLOR_SAFE)
         hlActive[c] = true
      end
   end
   if autoGuessEnabled and #state.cells.numbered > 0 then
      local best, bestProb = nil, huge
      local W, H = state.grid.w, state.grid.h
      for x = 0, W - 1 do
         local col = state.cells.grid[x]
         if col then
            for z = 0, H - 1 do
               local gc = col[z]
               if gc and gc.part and gc.part.Parent
               and not isRevealed(gc) and not toFlag[gc] and not toClear[gc] then
                  local p = gc._prob or 0.5
                  if p < bestProb then bestProb = p; best = gc end
               end
            end
         end
      end
      if best then applyHL(best, COLOR_GUESS); hlActive[best] = true end
   end
end

-- ── Grid rebuild ──────────────────────────────────────────────────
local function rebuildG(folder)
   clearAllHL()
   state.cells.grid = {}
   state.grid.w     = 0
   state.grid.h     = 0
   local pts        = folder:GetChildren()
   if #pts == 0 then return end

   local pD, sY = {}, 0
   for _, p in ipairs(pts) do
      if p:IsA(S_BasePart) then
         tinsert(pD, { p = p, pos = p.Position })
         sY = sY + p.Position.Y
      end
   end

   local xs, zs = {}, {}
   for i = 1, #pD do xs[i], zs[i] = pD[i].pos.X, pD[i].pos.Z end
   tsort(xs); tsort(zs)

   local w, h = estS(xs) * 0.6, estS(zs) * 0.6
   local ux, uz = cluster(xs, w), cluster(zs, h)
   state.grid.w, state.grid.h = #ux, #uz
   if state.grid.w == 0 or state.grid.h == 0 then return end

   local ay = sY / #pD
   for x = 0, state.grid.w - 1 do
      state.cells.grid[x] = {}
      for z = 0, state.grid.h - 1 do
         state.cells.grid[x][z] = {
            ix = x, iz = z,
            pos = vec3(ux[x+1], ay, uz[z+1]),
            part = nil, state = "unknown",
            covered = true, neigh = {},
            hlPart = nil, isHL = false,
         }
      end
   end

   for _, d in ipairs(pD) do
      local xi, zi = findI(d.pos.X, ux), findI(d.pos.Z, uz)
      local c = state.cells.grid[xi][zi]
      if not c.part or (d.pos - vec3(ux[xi+1], d.pos.Y, uz[zi+1])).Magnitude
         < (c.part.Position - vec3(ux[xi+1], c.part.Position.Y, uz[zi+1])).Magnitude then
         c.part, c.pos = d.p, d.pos
      end
   end

   for z = 0, state.grid.h - 1 do
      for x = 0, state.grid.w - 1 do
         local c = state.cells.grid[x][z]
         for dz = -1, 1 do
            for dx = -1, 1 do
               if dx ~= 0 or dz ~= 0 then
                  local nx, nz = x + dx, z + dz
                  if nx >= 0 and nx < state.grid.w and nz >= 0 and nz < state.grid.h then
                     tinsert(c.neigh, state.cells.grid[nx][nz])
                  end
               end
            end
         end
      end
   end

   for _, conn in pairs(signalConns) do conn:Disconnect() end
   signalConns = {}
   changeQueue = {}
   queueSet    = {}

   for x = 0, state.grid.w - 1 do
      local col = state.cells.grid[x]
      if col then
         for z = 0, state.grid.h - 1 do
            local c = col[z]
            if c and c.part then
               local part = c.part
               local conn = part:GetPropertyChangedSignal(S_BrickColor):Connect(function()
                  if not queueSet[c] then
                     queueSet[c] = true
                     changeQueue[#changeQueue + 1] = c
                  end
                  solverDirty = true
               end)
               signalConns[part] = conn
               local ngConn = part.ChildAdded:Connect(function(child)
                  if child.Name == S_NumberGui then
                     c._ng = child
                     if c.hlPart then c.hlPart.Enabled = false end
                     if hlActive then hlActive[c] = nil end
                     if state.cells.toClear then state.cells.toClear[c] = nil end
                     if state.cells.toFlag  then state.cells.toFlag[c]  = nil end
                     if not queueSet[c] then
                        queueSet[c] = true
                        changeQueue[#changeQueue + 1] = c
                     end
                     solverDirty = true
                  end
               end)
               signalConns[c] = ngConn
            end
         end
      end
   end

   for x = 0, state.grid.w - 1 do
      local col = state.cells.grid[x]
      if col then
         for z = 0, state.grid.h - 1 do
            local c = col[z]
            if c and not queueSet[c] then
               queueSet[c] = true
               changeQueue[#changeQueue + 1] = c
            end
         end
      end
   end
   solverDirty = true
end

-- ── processQueue ──────────────────────────────────────────────────
local function processQueue()
   if #changeQueue == 0 then return end
   local batch = changeQueue
   changeQueue = {}
   queueSet    = {}

   local numberedDirty = false
   local i = 1
   while i <= #batch do
      local limit = min(i + BATCH_SIZE - 1, #batch)
      for j = i, limit do
         local c = batch[j]
         if c and c.part and c.state ~= "number" and c.state ~= "flagged" then
            if hasF(c.part) then
               c.covered = true
               c.state = "flagged"
            else
               local ng = c._ng or c.part:FindFirstChild(S_NumberGui)
               if ng then
                  c._ng = ng
                  local lbl = ng:FindFirstChild(S_TextLabel)
                  if lbl then
                     c._tl = lbl
                     local t = lbl.Text
                     if t == "" or tonumber(t) then
                        c.number  = tonumber(t) or 0
                        c.covered = false
                        c.state   = "number"
                        numberedDirty = true
                     end
                  end
               end
            end
         end
      end
      i = limit + 1
      if i <= #batch then task.wait() end
   end

   if numberedDirty then
      local numbered = {}
      for x = 0, state.grid.w - 1 do
         local col = state.cells.grid[x]
         if col then
            for z = 0, state.grid.h - 1 do
               local c = col[z]
               if c and c.state == "number" then
                  tinsert(numbered, c)
               end
            end
         end
      end
      state.cells.numbered = numbered
   end
end

-- ── Solver ────────────────────────────────────────────────────────
local function updateL()
   if state.grid.w == 0 then
      state.cells.toFlag, state.cells.toClear = {}, {}
      return
   end
   local num = state.cells.numbered
   if #num == 0 then return end

   local fS, sS = {}, {}
   local changed = true
   local iters   = 0
   while changed and iters < 10 do
      changed = false
      iters   = iters + 1
      for j = 1, #num do
         local c        = num[j]
         local unk, flg = {}, 0
         for _, t in ipairs(c.neigh) do
            if fS[t] then
               flg = flg + 1
            elseif not sS[t] and not isRevealed(t) then
               unk[#unk+1] = t
            end
         end
         local r = (c.number or 0) - flg
         if r > 0 and r == #unk then
            for _, t in ipairs(unk) do
               if not fS[t] then fS[t] = true; changed = true end
            end
         elseif r == 0 and #unk > 0 then
            for _, t in ipairs(unk) do
               if not sS[t] then sS[t] = true; changed = true end
            end
         end
      end
   end

   state.cells.toFlag  = fS
   state.cells.toClear = sS
end

-- ── FlagRemote ────────────────────────────────────────────────────
local FlagRemote = nil
task.spawn(function()
   local ok, remote = pcall(function()
      return game:GetService("ReplicatedStorage")
         :WaitForChild("Events", 10)
         :WaitForChild("FlagEvents", 10)
         :WaitForChild("PlaceFlag", 10)
   end)
   if ok and remote then FlagRemote = remote end
end)

-- ── Mobile Teleport Revealer Loop ─────────────────────────────────
task.spawn(function()
   while true do
      task.wait(0.05)
      if mobileTeleportEnabled then
         local char = lp.Character
         local hrp  = char and char:FindFirstChild(S_HRP)
         if hrp then
            local origin = hrp.Position
            local candidates = {}
            
            -- Add safe tiles (green)
            for cell in pairs(state.cells.toClear) do
               if cell.part and cell.part.Parent
               and not isRevealed(cell)
               and not state.cells.toFlag[cell] then
                  local dist = (origin - cell.part.Position).Magnitude
                  if dist <= mobileTeleportReach then
                     tinsert(candidates, { cell = cell, dist = dist, priority = 1 })
                  end
               end
            end
            
            -- Add auto guess tile (blue) - highest priority
            if autoGuessEnabled and #state.cells.numbered > 0 then
               local best, bestProb = nil, huge
               local W, H = state.grid.w, state.grid.h
               for x = 0, W - 1 do
                  local col = state.cells.grid[x]
                  if col then
                     for z = 0, H - 1 do
                        local gc = col[z]
                        if gc and gc.part and gc.part.Parent
                        and not isRevealed(gc) and not state.cells.toFlag[gc] and not state.cells.toClear[gc] then
                           local p = gc._prob or 0.5
                           if p < bestProb then bestProb = p; best = gc end
                        end
                     end
                  end
               end
               if best and best.part then
                  local dist = (origin - best.part.Position).Magnitude
                  if dist <= mobileTeleportReach then
                     tinsert(candidates, { cell = best, dist = dist, priority = 0 })
                  end
               end
            end

            -- Sort: priority first (0=guess, 1=safe), then distance
            tsort(candidates, function(a, b)
               if a.priority ~= b.priority then
                  return a.priority < b.priority
               end
               return a.dist < b.dist
            end)

            for _, entry in ipairs(candidates) do
               if not mobileTeleportEnabled then break end
               local cell = entry.cell
               if cell.part and cell.part.Parent then
                  local tilePos = cell.part.Position
                  local tileSize = cell.part.Size
                  hrp.CFrame = CFrame.new(
                     tilePos.X,
                     tilePos.Y + tileSize.Y/2 + 2,
                     tilePos.Z
                  )
                  
                  local actualDelay = mobileTeleportDelay
                  if autoGuessEnabled then
                     actualDelay = actualDelay * 0.5
                  end
                  
                  task.wait(max(actualDelay, 0.01))
               end
            end
         else
            task.wait(0.5)
         end
      end
   end
end)

-- ── Solver loop ───────────────────────────────────────────────────
task.spawn(function()
   while true do
      task.wait(0.1)

      if cachedB and not cachedB.Parent then
         cachedB = nil
         state.lastPartCount  = -1
         state.grid.w         = 0
         state.grid.h         = 0
         state.cells.grid     = {}
         state.cells.numbered = {}
         state.cells.toFlag   = {}
         state.cells.toClear  = {}
         autoFlaggedSet       = {}
         hlActive             = {}
         changeQueue          = {}
         queueSet             = {}
         solverDirty          = false
         lastSolveTime        = 0
         for _, conn in pairs(signalConns) do conn:Disconnect() end
         signalConns = {}
      end

      if solverEnabled or autoGuessEnabled or autoFlagToggle or touchTilesEnabled or mobileTeleportEnabled then
         local folder = scanB()
         if folder then
            local pc = #folder:GetChildren()
            local needRebuild = state.grid.w == 0 or pc ~= state.lastPartCount
            if needRebuild then
               state.lastPartCount = pc
               for _, conn in pairs(signalConns) do conn:Disconnect() end
               signalConns  = {}
               changeQueue  = {}
               queueSet     = {}
               hlActive     = {}
               state.cells.toFlag   = {}
               state.cells.toClear  = {}
               state.cells.numbered = {}
               autoFlaggedSet       = {}
               solverDirty          = false
               lastSolveTime        = 0
               pcall(rebuildG, folder)
               task.wait()
            end

            local now = tick()
            if state.grid.w > 0 then
               if solverDirty and (now - lastSolveTime) >= SOLVE_COOLDOWN then
                  solverDirty   = false
                  lastSolveTime = now
                  pcall(processQueue)
                  task.wait()
                  pcall(updateL)
               end
               pcall(updateH)
            end
         end
      end
   end
end)

-- ── Auto Flag loop ────────────────────────────────────────────────
task.spawn(function()
   while true do
      task.wait(0.05)
      if autoFlagToggle then
         local token = getToken()
         if token and FlagRemote then
            local char   = lp.Character
            local hrp    = char and char:FindFirstChild(S_HRP)
            local origin = hrp and hrp.Position

            local candidates = {}
            for cell in pairs(state.cells.toFlag) do
               if cell.part and cell.part.Parent
               and not autoFlaggedSet[cell]
               and not hasF(cell.part) then
                  local dist = origin and (origin - cell.part.Position).Magnitude or 0
                  if dist <= flagRange then
                     tinsert(candidates, { cell = cell, dist = dist })
                  end
               end
            end

            tsort(candidates, function(a, b) return a.dist < b.dist end)

            for _, entry in ipairs(candidates) do
               local cell = entry.cell
               if not autoFlagToggle then break end
               if cell.part and cell.part.Parent
               and not autoFlaggedSet[cell]
               and not hasF(cell.part) then
                  autoFlaggedSet[cell] = true
                  pcall(function()
                     FlagRemote:FireServer(cell.part, token, true)
                  end)
                  task.wait(max(flagDelay, 0.05))
                  if not hasF(cell.part) then
                     autoFlaggedSet[cell] = nil
                  end
               end
            end
         end
      end
   end
end)
