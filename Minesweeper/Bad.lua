-- Minesweeper by timmy (Enhanced Mobile Version)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Minesweeper Mobile+",
   Icon = "monitor",
   LoadingTitle = "Minesweeper Enhanced",
   LoadingSubtitle = "by timmy (Mobile Optimized)",
   ShowText = "Minesweeper Mobile+",
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
   KeySystem = true,
   KeySettings = {
      Title = "Minesweeper",
      Subtitle = "by timmy",
      Note = "Get the key at discord.gg/YPswajCcG",
      FileName = "MinesweeperKeyTimmy",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"TimmyHack"}
   }
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

-- ── PC Tiles Revealer Tab ─────────────────────────────────────────
local RevealSection = RevealTab:CreateSection("PC Tiles Revealer (firetouchinterest)")

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
   Name = "Tiles Revealer (PC Only)",
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
                  and cell.state ~= "number"
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

-- ── Mobile Tiles Revealer Tab ─────────────────────────────────────
local MobileSection = MobileTab:CreateSection("Mobile Teleport Revealer")

local mobileTeleportEnabled = false
local mobileTeleportDelay   = 0.5
local mobileTeleportReach   = 999
local visualGuideEnabled    = false

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

MobileTab:CreateToggle({
   Name = "Visual Guide (Far Tiles)",
   CurrentValue = false,
   Flag = "VisualGuide",
   Callback = function(Value)
      visualGuideEnabled = Value
      if not Value then
         -- Clear visual guides
         for _, guide in pairs(visualGuides) do
            if guide and guide.Parent then
               guide:Destroy()
            end
         end
         visualGuides = {}
      end
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

-- ── Visual Guides ─────────────────────────────────────────────────
local visualGuides = {}

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

local function getToken()
   if cachedToken then return cachedToken end
   local char = lp.Character
   if not char then return nil end
   local tool = char:FindFirstChildOfClass("Tool")
   if not tool then
      local bp = lp:FindFirstChild("Backpack")
      if bp then tool = bp:FindFirstChildOfClass("Tool") end
   end
   if tool then
      local cd = tool:FindFirstChildOfClass(S_ClickDetector)
      if cd then
         local ok, rt = pcall(function() return cd.RemoteToken end)
         if ok and typeof(rt) == "string" then
            cachedToken = rt
            return rt
         end
      end
   end
   return nil
end

-- ── State ─────────────────────────────────────────────────────────
local state = {
   grid         = { w = 0, h = 0 },
   cells        = { grid = {}, numbered = {}, toClear = {}, toFlag = {} },
   lastPartCount = -1
}

local cachedB = nil
local function scanB()
   if cachedB and cachedB.Parent then return cachedB end
   local ws = workspace:FindFirstChild("Workspace")
   if not ws then ws = workspace end
   for _, c in ipairs(ws:GetChildren()) do
      if c.Name == "Board" and c:IsA("Folder") then
         cachedB = c
         return c
      end
   end
   return nil
end

-- ── hasF ──────────────────────────────────────────────────────────
local function hasF(part)
   if not part or not part.Parent then return false end
   for _, c in ipairs(part:GetChildren()) do
      if c.Name == "Flag" then return true end
   end
   return false
end

-- ── Highlight pool ────────────────────────────────────────────────
local hlPool, hlActive = {}, {}

local function getHL()
   local h = table.remove(hlPool)
   if not h then
      h = inst("Highlight")
      h.FillTransparency = 0.6
      h.OutlineTransparency = 0.3
   end
   return h
end

local function retHL(h)
   if h and h.Parent then
      h.Parent = nil
      h.Adornee = nil
      h.Enabled = false
      hlPool[#hlPool+1] = h
   end
end

local function clearAllHL()
   for c, h in pairs(hlActive) do
      retHL(h)
      if c then c.hlPart = nil end
   end
   hlActive = {}
end

-- ── Rebuild grid ──────────────────────────────────────────────────
local BATCH_SIZE = 50

local changeQueue = {}
local queueSet    = {}
local solverDirty = false
local lastSolveTime = 0
local SOLVE_COOLDOWN = 0.2

local signalConns = {}
local autoFlaggedSet = {}

local function rebuildG(folder)
   clearAllHL()
   for _, conn in pairs(signalConns) do conn:Disconnect() end
   signalConns = {}

   local parts = {}
   for _, c in ipairs(folder:GetChildren()) do
      if c:IsA(S_BasePart) then
         tinsert(parts, c)
      end
   end
   if #parts == 0 then return end

   local minX, minZ = huge, huge
   local maxX, maxZ = -huge, -huge
   local sizeX, sizeZ = nil, nil

   for _, p in ipairs(parts) do
      local px, pz = p.Position.X, p.Position.Z
      local sx, sz = p.Size.X, p.Size.Z
      if not sizeX then sizeX = sx end
      if not sizeZ then sizeZ = sz end
      minX = min(minX, px)
      maxX = max(maxX, px)
      minZ = min(minZ, pz)
      maxZ = max(maxZ, pz)
   end

   local w = floor((maxX - minX) / sizeX + 0.5) + 1
   local h = floor((maxZ - minZ) / sizeZ + 0.5) + 1

   state.grid.w = w
   state.grid.h = h

   local grid = {}
   for x = 0, w - 1 do
      grid[x] = {}
      for z = 0, h - 1 do
         grid[x][z] = {
            x = x, z = z,
            part = nil,
            state = "unknown",
            number = nil,
            covered = true,
            neigh = {},
            hlPart = nil,
            _ng = nil,
            _tl = nil
         }
      end
   end

   for _, p in ipairs(parts) do
      local px, pz = p.Position.X, p.Position.Z
      local x = floor((px - minX) / sizeX + 0.5)
      local z = floor((pz - minZ) / sizeZ + 0.5)
      if grid[x] and grid[x][z] then
         grid[x][z].part = p
      end
   end

   for x = 0, w - 1 do
      for z = 0, h - 1 do
         local c = grid[x][z]
         if c.part then
            local neigh = {}
            for dx = -1, 1 do
               for dz = -1, 1 do
                  if not (dx == 0 and dz == 0) then
                     local nx, nz = x + dx, z + dz
                     if grid[nx] and grid[nx][nz] and grid[nx][nz].part then
                        tinsert(neigh, grid[nx][nz])
                     end
                  end
               end
            end
            c.neigh = neigh
            state.cells.toClear[c] = true

            if c.part then
               local ng = c.part:FindFirstChild(S_NumberGui)
               if ng then
                  c._ng = ng
                  local lbl = ng:FindFirstChild(S_TextLabel)
                  if lbl then c._tl = lbl end

                  local ngConn = ng.Changed:Connect(function()
                     if not queueSet[c] then
                        queueSet[c] = true
                        changeQueue[#changeQueue + 1] = c
                     end
                     solverDirty = true
                  end)
                  signalConns[c] = ngConn
               end
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

   state.cells.grid = grid
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
      local limit = math.min(i + BATCH_SIZE - 1, #batch)
      for j = i, limit do
         local c = batch[j]
         if c and c.part and c.state ~= "number" and c.state ~= "flagged" then
            local ng = c._ng or c.part:FindFirstChild(S_NumberGui)
            if ng then
               if not c._ng then c._ng = ng end
               local lbl = c._tl or ng:FindFirstChild(S_TextLabel)
               if lbl and not c._tl then c._tl = lbl end
               if lbl then
                  local t = lbl.Text
                  if t == "" or tonumber(t) then
                     c.number  = tonumber(t) or 0
                     c.covered = false
                     c.state   = "number"
                     state.cells.toClear[c] = nil
                     state.cells.toFlag[c]  = nil
                     if c.hlPart then c.hlPart.Enabled = false end
                     hlActive[c] = nil
                     numberedDirty = true
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
      local grid = state.cells.grid
      for x = 0, state.grid.w - 1 do
         local col = grid[x]
         if col then
            for z = 0, state.grid.h - 1 do
               local c = col[z]
               if c and c.state == "number" then
                  tinsert(numbered, c)
                  state.cells.toClear[c] = nil
                  state.cells.toFlag[c]  = nil
                  if c.hlPart then
                     c.hlPart.Enabled = false
                     hlActive[c] = nil
                  end
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
            elseif not sS[t] and t.state ~= "number" and t.covered ~= false then
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

-- ── Highlight updater ─────────────────────────────────────────────
local function updateH()
   if not solverEnabled then
      clearAllHL()
      return
   end

   local toShow = {}
   for c in pairs(state.cells.toFlag) do
      if c.part and c.part.Parent and c.state ~= "number" and not hasF(c.part) then
         toShow[c] = COLOR_MINE
      end
   end
   for c in pairs(state.cells.toClear) do
      if c.part and c.part.Parent and c.state ~= "number" then
         toShow[c] = COLOR_SAFE
      end
   end

   for c in pairs(hlActive) do
      if not toShow[c] then
         retHL(hlActive[c])
         hlActive[c] = nil
         c.hlPart = nil
      end
   end

   for c, col in pairs(toShow) do
      local h = hlActive[c]
      if not h then
         h = getHL()
         h.Adornee = c.part
         h.Parent = c.part
         c.hlPart = h
         hlActive[c] = h
      end
      h.FillColor = col
      h.OutlineColor = col
      h.Enabled = true
   end
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
            
            for cell in pairs(state.cells.toClear) do
               if cell.part and cell.part.Parent
               and cell.state ~= "number"
               and not state.cells.toFlag[cell] then
                  local dist = (origin - cell.part.Position).Magnitude
                  if dist <= mobileTeleportReach then
                     tinsert(candidates, { cell = cell, dist = dist })
                  end
               end
            end

            tsort(candidates, function(a, b) return a.dist < b.dist end)

            for _, entry in ipairs(candidates) do
               if not mobileTeleportEnabled then break end
               local cell = entry.cell
               if cell.part and cell.part.Parent then
                  -- Teleport to tile
                  local tilePos = cell.part.Position
                  local tileSize = cell.part.Size
                  hrp.CFrame = CFrame.new(
                     tilePos.X,
                     tilePos.Y + tileSize.Y/2 + 2,
                     tilePos.Z
                  )
                  
                  -- Calculate delay based on Auto Guess status
                  local actualDelay = mobileTeleportDelay
                  if autoGuessEnabled then
                     actualDelay = actualDelay * 0.5  -- 50% faster if Auto Guess ON
                  end
                  
                  task.wait(math.max(actualDelay, 0.01))
               end
            end
         else
            task.wait(0.5)
         end
      end
   end
end)

-- ── Visual Guide Updater ──────────────────────────────────────────
task.spawn(function()
   while true do
      task.wait(0.2)
      if visualGuideEnabled and mobileTeleportEnabled then
         local char = lp.Character
         local hrp  = char and char:FindFirstChild(S_HRP)
         if hrp then
            local origin = hrp.Position
            local farTiles = {}
            
            for cell in pairs(state.cells.toClear) do
               if cell.part and cell.part.Parent
               and cell.state ~= "number"
               and not state.cells.toFlag[cell] then
                  local dist = (origin - cell.part.Position).Magnitude
                  if dist > mobileTeleportReach then
                     tinsert(farTiles, { cell = cell, dist = dist })
                  end
               end
            end

            -- Clear old guides
            for _, guide in pairs(visualGuides) do
               if guide and guide.Parent then
                  guide:Destroy()
               end
            end
            visualGuides = {}

            -- Create new guides for closest far tiles (max 5)
            tsort(farTiles, function(a, b) return a.dist < b.dist end)
            for i = 1, math.min(#farTiles, 5) do
               local entry = farTiles[i]
               local beam = Instance.new("Beam")
               local att0 = Instance.new("Attachment", hrp)
               local att1 = Instance.new("Attachment", entry.cell.part)
               
               beam.Attachment0 = att0
               beam.Attachment1 = att1
               beam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
               beam.Width0 = 0.5
               beam.Width1 = 0.5
               beam.FaceCamera = true
               beam.Parent = hrp
               
               tinsert(visualGuides, beam)
               tinsert(visualGuides, att0)
               tinsert(visualGuides, att1)
            end
         end
      else
         -- Clear guides if disabled
         for _, guide in pairs(visualGuides) do
            if guide and guide.Parent then
               guide:Destroy()
            end
         end
         visualGuides = {}
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

      if solverEnabled or autoGuessEnabled or autoFlagToggle or mobileTeleportEnabled then
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
                  task.wait(math.max(flagDelay, 0.05))
                  if not hasF(cell.part) then
                     autoFlaggedSet[cell] = nil
                  end
               end
            end
         end
      end
   end
end)
