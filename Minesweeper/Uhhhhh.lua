local v1 = game:GetService('Players')
local v3 = v1.LocalPlayer

local data = {
    cells = {all = {}, numbered = {}, toFlag = {}, toClear = {}, guess = {}},
    cache = {xs_centers_cached = nil, zs_centers_cached = nil},
    grid = {w = 0, h = 0},
    ui = {PROB_FLAG_THRESHOLD = 0.7, PROB_SAFE_THRESHOLD = 0.3},
    timing = {lastPlanTick = 0, planIntervalMs = 20} -- Super cepat!
}

local abs, floor, huge = math.abs, math.floor, math.huge
local sort = table.sort
local lastOutput = "" -- Untuk mencegah spam output

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

local function buildGrid()
    data.cells.all = {}
    data.cells.numbered = {}
    data.cells.grid = {}
    
    local root = game.Workspace:FindFirstChild("Flag")
    if not root then return end
    
    local partsFolder = root:FindFirstChild("Parts")
    if not partsFolder then return end
    
    local parts = partsFolder:GetChildren()
    
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
    
    -- Generate output dengan emoji
    local safeSpots = {}
    local mineSpots = {}
    
    for cell, _ in pairs(data.cells.toClear) do
        if cell.part then
            local pos = cell.part.Position
            table.insert(safeSpots, string.format("✅ (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
        end
    end
    
    for cell, _ in pairs(data.cells.toFlag) do
        if cell.part then
            local pos = cell.part.Position
            table.insert(mineSpots, string.format("💣 (%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
        end
    end
    
    -- Tampilkan hanya jika ada perubahan
    local output = ""
    if #safeSpots > 0 or #mineSpots > 0 then
        output = "🔍 Minesweeper Update:\n"
        if #safeSpots > 0 then
            output = output .. "Aman (✅):\n" .. table.concat(safeSpots, "\n") .. "\n"
        end
        if #mineSpots > 0 then
            output = output .. "Bom (💣):\n" .. table.concat(mineSpots, "\n")
        end
        
        if output ~= lastOutput then
            print(output)
            lastOutput = output
        end
    end
end

local lastBuild = 0
local function onUpdate()
    local now = tick()
    
    -- Rebuild grid setiap 2 detik
    if (now - lastBuild) > 2 then
        buildGrid()
        lastBuild = now
    end
    
    if data.grid.w == 0 or not data.cache.xs_centers_cached or not data.cache.zs_centers_cached then
        return
    end
    
    local nowMs = now * 1000
    if data.timing.lastPlanTick == 0 or (nowMs - data.timing.lastPlanTick) >= data.timing.planIntervalMs then
        planMove()
        data.timing.lastPlanTick = nowMs
    end
end

game:GetService("RunService").Heartbeat:Connect(onUpdate)

print("🚀 Minesweeper Solver Active (Emoji Mode)")
print("✅ = Safe to step | 💣 = Mine don't step")
