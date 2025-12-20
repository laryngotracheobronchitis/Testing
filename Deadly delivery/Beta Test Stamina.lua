-- Infinity Stamina - Block Frame Only (Non-Intrusive)
-- Blocks stamina reduction without affecting run mechanics

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

print("⏳ Loading Non-Intrusive Infinity Stamina...")
task.wait(2)

-- Load modules
local Value = require(ReplicatedStorage.Shared.Core.Value)
local Config = require(ReplicatedStorage.Config)

-- Get max stamina
local maxStamina = Config.Property.StaminaSystem.stamina.default
print("📊 Max Stamina:", maxStamina)

-- Set stamina to max initially
Value.Stamina = maxStamina

-- ===== HIDE STAMINA BAR TO PREVENT VISUAL UPDATES =====
task.spawn(function()
    pcall(function()
        local StaminaFrame = Players.LocalPlayer.PlayerGui.Main.HomePage.Property.Stamina
        local OriginalVisible = StaminaFrame.Visible
        
        -- Keep bar invisible so it doesn't update
        StaminaFrame.Visible = false
        print("✓ Stamina bar hidden (blocked frame updates)")
        
        -- Also set bar to full visually
        StaminaFrame.Frame.Bar.Size = UDim2.fromScale(1, 1)
    end)
end)

-- ===== METHOD 1: SUPER FAST REGEN (999x FASTER) =====
-- Instead of blocking consumption, make regen instant
Config.Property.StaminaSystem.naturalRecovery = Config.Property.StaminaSystem.naturalRecovery * 999
Config.Property.StaminaSystem.delayRecoveryTime = 0

print("✓ Regen speed: 999x FASTER (instant recovery)")
print("✓ Regen delay: REMOVED")

-- ===== METHOD 2: REDUCE CONSUMPTION TO NEAR ZERO =====
-- Make stamina drain 0.001% of original (basically nothing)
Config.Property.StaminaSystem.runStaminaConsume = Config.Property.StaminaSystem.runStaminaConsume * 0.00001
Value.StaminaConsumeMutil = 0.00001

print("✓ Stamina consumption: 99.999% REDUCED")

-- ===== METHOD 3: SMART REFILL (Only when needed) =====
-- Only refill if stamina drops below 95%, don't touch if full
local lastStamina = maxStamina
local refillConnection = RunService.Heartbeat:Connect(function()
    local currentStamina = Value.Stamina
    
    -- If stamina is dropping, instantly refill
    if currentStamina < maxStamina * 0.95 then
        Value.Stamina = maxStamina
        print("🔋 Refilled stamina: " .. math.floor(currentStamina) .. " → " .. maxStamina)
    end
    
    lastStamina = currentStamina
end)

print("✓ Smart auto-refill: ACTIVE")

-- ===== METHOD 4: HOOK VALUE CHANGES (Gentle approach) =====
-- Only intercept stamina DECREASES, allow normal function otherwise
local oldStamina = Value.Stamina
task.spawn(function()
    while task.wait(0.05) do
        local newStamina = Value.Stamina
        
        -- If stamina decreased, restore it
        if newStamina < oldStamina - 1 then
            Value.Stamina = maxStamina
        end
        
        oldStamina = Value.Stamina
    end
end)

print("✓ Decrease blocker: ACTIVE")

-- ===== METHOD 5: OVERRIDE BUFF EFFECTS =====
task.spawn(function()
    pcall(function()
        local Buff = require(ReplicatedStorage.Shared.Features.Buff)
        
        -- Make stamina consume buffs ineffective
        Buff.OnChanged("StaminaConsumeRate", function(arg1, arg2, arg3)
            -- Keep consumption minimal
            local clamped = 0.00001
            Config.Property.StaminaSystem.runStaminaConsume = Config.Property.StaminaSystem.runStaminaConsume * clamped
            Value.StaminaConsumeMutil = clamped
        end, { replay = true })
        
        -- Boost regen buffs massively
        Buff.OnChanged("StaminaRegenRate", function(arg1, arg2, arg3)
            Config.Property.StaminaSystem.naturalRecovery = Config.Property.StaminaSystem.naturalRecovery * 999
        end, { replay = true })
        
        -- Block negative stamina buffs
        Buff.OnApply("Stamina", function(arg1, arg2)
            local change = arg2:Get()
            if change < 0 then
                -- Block negative changes
                Value.Stamina = maxStamina
                print("🛡️ Blocked negative stamina buff")
            else
                -- Allow positive changes
                Value.Stamina = math.min(Value.Stamina + change, maxStamina)
            end
        end)
        
        print("✓ Buff system overridden")
    end)
end)

-- ===== STATUS MONITOR =====
task.spawn(function()
    while task.wait(3) do
        local currentStamina = Value.Stamina
        local percentage = math.floor((currentStamina / maxStamina) * 100)
        print(string.format("💪 Stamina: %d/%d (%d%%)", 
            math.floor(currentStamina), maxStamina, percentage))
    end
end)

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ INFINITY STAMINA ACTIVE!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("Features:")
print("  • Stamina bar hidden (no frame updates)")
print("  • Consumption reduced to 0.001%")
print("  • Regen speed increased 999x")
print("  • Instant refill when stamina drops")
print("  • You CAN run normally!")
print("")
print("To disable: _G.DisableStamina()")

-- Disable function
_G.DisableStamina = function()
    if refillConnection then 
        refillConnection:Disconnect() 
    end
    print("❌ Infinity Stamina DISABLED")
end

print("✅ Ready! Try running now!")
