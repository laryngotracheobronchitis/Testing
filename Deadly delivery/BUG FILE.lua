local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvents = {}

-- Cari semua RemoteEvent/RemoteFunction dan stamina
local function findStaminaRemotes()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
            if obj.Name:lower():find("stamina") then
                table.insert(remoteEvents, obj)
            end
        end
    end
    
    -- Cari di Workspace dan lainnya
    for _, location in pairs({workspace, game:GetService("Players")}) do
        for _, obj in pairs(location:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                if obj.Name:lower():find("stamina") then
                    table.insert(remoteEvents, obj)
                end
            end
        end
    end
end

-- Hook FireServer/InvokeServer
local function hookRemotes()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        -- Intercept stamina-related calls
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = self.Name:lower()
            
            -- Block stamina consumption calls
            if remoteName:find("stamina") or remoteName:find("energy") then
                -- Cek argumen
                local args = {...}
                local firstArg = tostring(args[1] or ""):lower()
                
                if firstArg:find("consume") or firstArg:find("use") or 
                   firstArg:find("drain") or firstArg:find("reduce") then
                    return nil  -- Block call
                end
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
end

-- Main
task.wait(3)
findStaminaRemotes()
hookRemotes()

-- UI Control
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local gui = Players.LocalPlayer.PlayerGui
            local stamina = gui:FindFirstChild("Main") and 
                           gui.Main.HomePage.Property.Stamina
            
            if stamina then
                stamina.Frame.Bar.Size = UDim2.fromScale(1, 1)
                stamina.Visible = false
            end
        end)
    end
end)
