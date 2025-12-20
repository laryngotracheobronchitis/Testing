-- Infinity Stamina + Fast Regen Script
-- Features: No stamina drain + Instant regeneration

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

print("⏳ Loading Infinity Stamina...")
task.wait(1)

-- Load required modules
local Value = require(ReplicatedStorage.Shared.Core.Value)
local Config = require(ReplicatedStorage.Config)
local Buff = require(ReplicatedStorage.Shared.Features.Buff)

-- Get stamina values
local maxStamina = Config.Property.StaminaSystem.stamina.default
local originalConsumeRate = Config.Property.StaminaSystem.runStaminaConsume
local originalRegenRate = Config.Property.StaminaSystem.naturalRecovery

print("📊 Original Values:")
print("  Max Stamina:", maxStamina)
print("  Consume Rate:", originalConsumeRate)
print("  Regen Rate:", originalRegenRate)

-- ===== FEATURE 1: DISABLE STAMINA CONSUMPTION =====
-- Set stamina consume to 0 (no drain when running)
Config.Property.StaminaSystem.runStaminaConsume = 0
Value.StaminaConsumeMutil = 0

print("✓ Stamina consumption DISABLED")

-- ===== FEATURE 2: SUPER FAST REGENERATION =====
-- Increase regeneration rate by 100x
Config.Property.StaminaSystem.naturalRecovery = originalRegenRate * 100
Config.Property.StaminaSystem.delayRecoveryTime = 0 -- No delay before regen starts

print("✓ Stamina regen speed: 100x FASTER")
print("✓ Regen delay: REMOVED")

-- ===== FEATURE 3: ALWAYS KEEP STAMINA FULL =====
-- Backup method: Force stamina to max every frame
local keepFullConnection = RunService.Heartbeat:Connect(function()
    if Value.Stamina < maxStamina then
        Value.Stamina = maxStamina
    end
end)

print("✓ Auto-refill stamina: ACTIVE")

-- ===== FEATURE 4: MODIFY BUFF SYSTEM =====
-- Override buff effects that might reduce stamina
task.spawn(function()
    pcall(function()
        -- Make stamina consume rate buffs do nothing
        Buff.OnChanged("StaminaConsumeRate", function(arg1, arg2, arg3)
            Config.Property.StaminaSystem.runStaminaConsume = 0
            Value.StaminaConsumeMutil = 0
        end, { replay = true })
        
        -- Boost stamina regen rate buffs
        Buff.OnChanged("StaminaRegenRate", function(arg1, arg2, arg3)
            Config.Property.StaminaSystem.naturalRecovery = originalRegenRate * 100
        end, { replay = true })
    end)
end)

print("✓ Buff system overridden")

-- ===== HIDE STAMINA UI =====
-- Hide the stamina bar since it's always full
task.spawn(function()
    local success = pcall(function()
        local StaminaFrame = Players.LocalPlayer.PlayerGui.Main.HomePage.Property.Stamina
        StaminaFrame.Visible = false
        print("✓ Stamina UI hidden")
    end)
    if not success then
        warn("⚠ Could not hide stamina UI (not critical)")
    end
end)

-- ===== STATUS MONITOR =====
-- Show current stamina every 5 seconds
task.spawn(function()
    while task.wait(5) do
        print(string.format("💪 Current Stamina: %.1f / %d (%.0f%%)", 
            Value.Stamina, maxStamina, (Value.Stamina/maxStamina)*100))
    end
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ INFINITY STAMINA ACTIVATED!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Features enabled:")
print("  • No stamina drain when running")
print("  • 100x faster regeneration")
print("  • Instant regen (no delay)")
print("  • Auto-refill to maximum")
print("")
print("To disable: _G.DisableStamina()")

-- ===== DISABLE FUNCTION =====
_G.DisableStamina = function()
    if keepFullConnection then
        keepFullConnection:Disconnect()
    end
    
    -- Restore original values
    Config.Property.StaminaSystem.runStaminaConsume = originalConsumeRate
    Config.Property.StaminaSystem.naturalRecovery = originalRegenRate
    Value.StaminaConsumeMutil = 1
    
    print("❌ Infinity Stamina DISABLED")
    print("Stamina system restored to normal")
end
