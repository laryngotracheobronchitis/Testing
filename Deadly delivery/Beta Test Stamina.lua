-- Advanced Infinity Stamina - Metamethod Hook
-- This prevents stamina from EVER decreasing

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

print("⏳ Loading Advanced Infinity Stamina...")
task.wait(2)

-- Load modules
local Value = require(ReplicatedStorage.Shared.Core.Value)
local Config = require(ReplicatedStorage.Config)

-- Get max stamina
local maxStamina = Config.Property.StaminaSystem.stamina.default
print("📊 Max Stamina:", maxStamina)

-- Set initial stamina to max
Value.Stamina = maxStamina

-- ===== METHOD 1: METATABLE HOOK (MOST POWERFUL) =====
print("🔧 Hooking metatable...")

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex

setreadonly(mt, false)

-- Hook __newindex to prevent stamina from being set below max
mt.__newindex = newcclosure(function(self, key, value)
    if self == Value and key == "Stamina" then
        -- Force stamina to always be max
        if value < maxStamina then
            value = maxStamina
        end
        print("🛡️ Blocked stamina decrease. Kept at:", maxStamina)
    end
    
    if self == Value and key == "StaminaConsumeMutil" then
        -- Force consume multiplier to 0
        value = 0
    end
    
    return oldNewIndex(self, key, value)
end)

setreadonly(mt, true)
print("✓ Metatable hook installed")

-- ===== METHOD 2: DIRECT CONFIG MANIPULATION =====
-- Make stamina consume absolutely zero
Config.Property.StaminaSystem.runStaminaConsume = 0
Config.Property.StaminaSystem.naturalRecovery = 999999 -- Insane regen speed
Config.Property.StaminaSystem.delayRecoveryTime = 0

print("✓ Config modified:")
print("  - Consume: 0")
print("  - Regen: 999999")
print("  - Delay: 0")

-- ===== METHOD 3: CONTINUOUS FORCED REFILL =====
-- Aggressively refill stamina every frame
local refillConnection = RunService.RenderStepped:Connect(function()
    -- Force stamina to max using rawset to bypass hooks
    rawset(Value, "Stamina", maxStamina)
end)

print("✓ Continuous refill active")

-- ===== METHOD 4: OVERRIDE THE STAMINA SCRIPT =====
-- Find and modify the stamina consumption calculation
task.spawn(function()
    local success = pcall(function()
        -- Set all consumption variables to 0
        local stamVars = {
            "runStaminaConsume_upvw",
            "var17_upvw",
            "var16_upvw"
        }
        
        -- Try to access and zero out these variables
        for i, varName in ipairs(stamVars) do
            pcall(function()
                getgenv()[varName] = 0
            end)
        end
    end)
end)

-- ===== METHOD 5: BLOCK STAMINA DECREASE IN BUFF SYSTEM =====
task.spawn(function()
    pcall(function()
        local Buff = require(ReplicatedStorage.Shared.Features.Buff)
        
        -- Override Stamina buff to only allow increases
        Buff.OnApply("Stamina", function(arg1, arg2)
            local change = arg2:Get()
            if change > 0 then
                -- Allow stamina increase
                Value.Stamina = math.min(Value.Stamina + change, maxStamina)
            else
                -- Block stamina decrease
                Value.Stamina = maxStamina
                print("🛡️ Blocked stamina decrease from buff")
            end
        end)
        
        print("✓ Buff system overridden")
    end)
end)

-- ===== METHOD 6: ALTERNATIVE HEARTBEAT REFILL =====
local heartbeatConnection = RunService.Heartbeat:Connect(function()
    if Value.Stamina ~= maxStamina then
        Value.Stamina = maxStamina
    end
end)

-- ===== STATUS DISPLAY =====
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ ADVANCED INFINITY STAMINA!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Active protections:")
print("  ✓ Metatable hook")
print("  ✓ Config override") 
print("  ✓ Continuous refill")
print("  ✓ Buff system block")
print("  ✓ Multi-layer protection")
print("")
print("Your stamina CANNOT decrease!")
print("Press F9 to monitor status")

-- Monitor stamina changes
task.spawn(function()
    local lastStamina = Value.Stamina
    while task.wait(0.5) do
        local currentStamina = Value.Stamina
        if currentStamina ~= lastStamina then
            print(string.format("💪 Stamina: %.1f → %.1f", lastStamina, currentStamina))
            lastStamina = currentStamina
        end
    end
end)

-- Disable function
_G.DisableStamina = function()
    if refillConnection then refillConnection:Disconnect() end
    if heartbeatConnection then heartbeatConnection:Disconnect() end
    print("❌ Infinity Stamina DISABLED")
end

print("Ready! Run and your stamina stays full!")
