-- Infinity Stamina Method 2 - Direct Hook
-- Ini method lebih agresif yang langsung modify function

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

task.wait(1)

-- Load modules
local Value = require(ReplicatedStorage.Shared.Core.Value)
local Config = require(ReplicatedStorage.Config)
local maxStamina = Config.Property.StaminaSystem.stamina.default

print("Starting Infinity Stamina Hack...")

-- Method 1: Keep setting stamina to max
spawn(function()
    while true do
        Value.Stamina = maxStamina
        task.wait()
    end
end)

-- Method 2: Disable stamina consumption
Value.StaminaConsumeMutil = 0

-- Method 3: Hook the Run value to never disable
local mt = getrawmetatable(Value)
setreadonly(mt, false)
local oldNewIndex = mt.__newindex

mt.__newindex = newcclosure(function(t, k, v)
    if k == "Stamina" and v < maxStamina then
        v = maxStamina
    end
    if k == "StaminaConsumeMutil" and v > 0 then
        v = 0
    end
    return oldNewIndex(t, k, v)
end)

setreadonly(mt, true)

print("✓ Infinity Stamina ACTIVE!")
print("✓ Stamina will never decrease")
print("✓ You can run forever!")

-- Disable with: _G.StopStamina = true
_G.StopStamina = false
