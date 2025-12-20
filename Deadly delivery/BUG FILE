-- Infinity Stamina Script
-- Path: game:GetService("Players").LocalPlayer.PlayerGui.Main.HomePage.Property.Stamina

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Tunggu hingga player dan GUI siap
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Main = PlayerGui:WaitForChild("Main")
local HomePage = Main:WaitForChild("HomePage")
local Property = HomePage:WaitForChild("Property")
local StaminaFrame = Property:WaitForChild("Stamina")
local Bar = StaminaFrame:WaitForChild("Frame"):WaitForChild("Bar")

-- Akses Value module
local Value = require(ReplicatedStorage.Shared.Core.Value)
local Config = require(ReplicatedStorage.Config)

-- Dapatkan nilai stamina maksimal
local maxStamina = Config.Property.StaminaSystem.stamina.default

-- Fungsi untuk set infinity stamina
local function setInfinityStamina()
    -- Set stamina ke maksimal
    Value.Stamina = maxStamina
    
    -- Sembunyikan stamina bar (karena selalu penuh)
    StaminaFrame.Visible = false
    
    -- Set ukuran bar ke penuh
    Bar.Size = UDim2.fromScale(1, 1)
end

-- Hook RunService untuk terus mengisi stamina
local connection = RunService.PreRender:Connect(function()
    -- Selalu set stamina ke maksimal
    Value.Stamina = maxStamina
    
    -- Pastikan running selalu enabled (tidak kehabisan stamina)
    if Value.Run then
        Value.Run = Value.Run
    end
    
    -- Set bar size ke penuh
    Bar.Size = UDim2.fromScale(1, 1)
end)

-- Set infinity stamina pertama kali
setInfinityStamina()

print("Infinity Stamina Activated!")
print("Press F9 to see console messages")

-- Fungsi untuk disable (opsional)
local function disableInfinityStamina()
    if connection then
        connection:Disconnect()
        print("Infinity Stamina Disabled!")
    end
end

-- Return fungsi disable jika ingin dimatikan nanti
return {
    Disable = disableInfinityStamina
}
