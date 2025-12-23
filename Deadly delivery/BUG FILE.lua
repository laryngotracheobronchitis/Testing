local function enableInfiniteStamina()
    -- Method 1: Direct UI manipulation
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                local player = game.Players.LocalPlayer
                local gui = player.PlayerGui
                
                -- Search for stamina UI in all possible locations
                for _, child in pairs(gui:GetDescendants()) do
                    if child.Name:lower():find("stamina") and child:IsA("Frame") then
                        -- Found stamina UI
                        if child:FindFirstChild("Bar") or child:FindFirstChild("Progress") then
                            local bar = child:FindFirstChild("Bar") or child:FindFirstChild("Progress")
                            if bar and bar:IsA("Frame") then
                                bar.Size = UDim2.fromScale(1, 1)
                                child.Visible = false
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- Method 2: Hook network requests
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        -- Block stamina-related remote events
        if method == "InvokeServer" or method == "FireServer" then
            local remoteName = tostring(self)
            if remoteName:lower():find("stamina") then
                return nil  -- Block the call
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- Method 3: Find and freeze stamina values
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                        if obj.Name:lower():find("stamina") then
                            obj.Value = 100  -- Set to max
                        end
                    end
                end
            end)
        end
    end)
end

-- Wait for game to load
task.wait(5)
enableInfiniteStamina()
