local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local buttonVisible = true
local isDragging = false
local currentDragInput = nil
local dragStartOffset = Vector2.new(0, 0)

-- Fungsi teleport
local function teleportRoof()
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    if root and humanoid and humanoid.Health > 0 then
        if humanoid.Sit or humanoid.PlatformStand then
            return
        end
        
        local currentPos = root.Position
        root.CFrame = CFrame.new(currentPos.X, currentPos.Y + 500, currentPos.Z)
    end
end

-- Buat GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportRoofGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 180, 0, 55)
mainContainer.Position = UDim2.new(0.02, 0, 0.85, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- **TOGGLE BUTTON DI KIRI**
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 55)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "▼"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 18
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainContainer

-- **TELEPORT BUTTON DI KANAN**
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "RoofTPButton"
teleportButton.Size = UDim2.new(0, 140, 0, 55)
teleportButton.Position = UDim2.new(0, 40, 0, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 14
teleportButton.TextScaled = true
teleportButton.AutoButtonColor = false
teleportButton.Parent = mainContainer

-- Styling
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 10)
teleportCorner.Parent = teleportButton

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- Stroke/border
local teleportStroke = Instance.new("UIStroke")
teleportStroke.Color = Color3.fromRGB(30, 30, 30)
teleportStroke.Thickness = 1.5
teleportStroke.Parent = teleportButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(30, 30, 30)
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggleButton

-- **VARIABEL UNTUK TRACK INPUT**
local activeInputs = {}
local dragConnection = nil
local isInputInsideButton = false -- Flag untuk cek jika input dimulai di dalam button

-- **FUNGSI UNTUK MENGECEK POSISI INPUT**
local function isPositionInsideButton(position)
    -- Cek jika posisi berada di toggle button
    local toggleAbsPos = toggleButton.AbsolutePosition
    local toggleAbsSize = toggleButton.AbsoluteSize
    
    if position.X >= toggleAbsPos.X and position.X <= toggleAbsPos.X + toggleAbsSize.X and
       position.Y >= toggleAbsPos.Y and position.Y <= toggleAbsPos.Y + toggleAbsSize.Y then
        return "toggle"
    end
    
    -- Cek jika posisi berada di teleport button (hanya jika visible)
    if teleportButton.Visible then
        local teleportAbsPos = teleportButton.AbsolutePosition
        local teleportAbsSize = teleportButton.AbsoluteSize
        
        if position.X >= teleportAbsPos.X and position.X <= teleportAbsPos.X + teleportAbsSize.X and
           position.Y >= teleportAbsPos.Y and position.Y <= teleportAbsPos.Y + teleportAbsSize.Y then
            return "teleport"
        end
    end
    
    return nil
end

-- **DRAG SYSTEM YANG HANYA BEKERJA JIKA MULAI DARI BUTTON**
local function startDrag(input)
    -- Pastikan input dimulai dari dalam button
    local buttonType = isPositionInsideButton(input.Position)
    if not buttonType then
        -- Input dimulai dari luar button, ABORT!
        return
    end
    
    if isDragging then return end
    
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        isDragging = true
        currentDragInput = input
        isInputInsideButton = true
        
        local containerPos = mainContainer.AbsolutePosition
        local inputPos = input.Position
        dragStartOffset = Vector2.new(
            containerPos.X - inputPos.X,
            containerPos.Y - inputPos.Y
        )
        
        -- Visual feedback
        if buttonType == "teleport" then
            teleportButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
        elseif buttonType == "toggle" then
            toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
        end
        
        -- Drag dengan RenderStepped
        dragConnection = RunService.RenderStepped:Connect(function()
            if isDragging and currentDragInput then
                local currentInputPos
                
                if isTouch then
                    -- Untuk touch, gunakan posisi input yang sedang drag
                    currentInputPos = currentDragInput.Position
                else
                    currentInputPos = UserInputService:GetMouseLocation()
                end
                
                if currentInputPos then
                    -- Hitung posisi baru
                    local newX = currentInputPos.X + dragStartOffset.X
                    local newY = currentInputPos.Y + dragStartOffset.Y
                    
                    -- Boundary checking
                    local screenSize = workspace.CurrentCamera.ViewportSize
                    newX = math.clamp(newX, 10, screenSize.X - mainContainer.AbsoluteSize.X - 10)
                    newY = math.clamp(newY, 10, screenSize.Y - mainContainer.AbsoluteSize.Y - 10)
                    
                    mainContainer.Position = UDim2.new(0, newX, 0, newY)
                end
            end
        end)
        
        -- Connect end drag
        local endConnection
        endConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if currentDragInput == input then
                    isDragging = false
                    currentDragInput = nil
                    isInputInsideButton = false
                    
                    if dragConnection then
                        dragConnection:Disconnect()
                        dragConnection = nil
                    end
                    
                    -- Kembalikan warna
                    if teleportButton.Visible then
                        teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                    end
                    toggleButton.BackgroundColor3 = buttonVisible and Color3.fromRGB(52, 73, 94) or Color3.fromRGB(41, 128, 185)
                end
                
                if endConnection then
                    endConnection:Disconnect()
                end
            end
        end)
    end
end

-- **TOGGLE BUTTON EVENTS**
toggleButton.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
        activeInputs[input] = "toggle"
        
        -- Tandai bahwa input dimulai dari dalam button
        isInputInsideButton = true
        
        -- Mulai drag setelah delay kecil
        task.delay(0.1, function()
            if activeInputs[input] == "toggle" and not isDragging and isInputInsideButton then
                startDrag(input)
            end
        end)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if activeInputs[input] == "toggle" then
        activeInputs[input] = nil
        
        -- Jika tidak drag, berarti klik
        if not isDragging then
            -- Toggle show/hide
            buttonVisible = not buttonVisible
            
            if buttonVisible then
                teleportButton.Visible = true
                teleportButton.Size = UDim2.new(0, 140, 0, 55)
                toggleButton.Text = "▼"
                toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
                toggleButton.Size = UDim2.new(0, 40, 0, 55)
            else
                teleportButton.Visible = false
                toggleButton.Text = "▲"
                toggleButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
                toggleButton.Size = UDim2.new(0, 50, 0, 55) -- Lebih lebar saat hide
            end
        end
        
        if not isDragging then
            toggleButton.BackgroundColor3 = buttonVisible and Color3.fromRGB(52, 73, 94) or Color3.fromRGB(41, 128, 185)
        end
    end
end)

-- **TELEPORT BUTTON EVENTS**
teleportButton.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        teleportButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        activeInputs[input] = "teleport"
        
        -- Tandai bahwa input dimulai dari dalam button
        isInputInsideButton = true
        
        -- Mulai drag setelah delay
        task.delay(0.15, function()
            if activeInputs[input] == "teleport" and not isDragging and isInputInsideButton then
                startDrag(input)
            end
        end)
    end
end)

teleportButton.InputEnded:Connect(function(input)
    if activeInputs[input] == "teleport" then
        activeInputs[input] = nil
        
        -- Jika tidak drag, teleport
        if not isDragging then
            teleportRoof()
        end
        
        if not isDragging then
            teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        end
    end
end)

-- **CEGAH DRAG DARI AREA LUAR BUTTON**
-- Main container TIDAK BISA trigger drag
mainContainer.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        -- Cek jika posisi input di luar button
        local buttonType = isPositionInsideButton(input.Position)
        if not buttonType then
            -- Input dimulai dari luar button, TANDAI agar tidak bisa drag
            isInputInsideButton = false
            return
        end
    end
end)

-- **HANDLE GLOBAL INPUT UNTUK MENCEGAH DRAG DARI LUAR**
-- Track semua input mulai
UserInputService.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        -- Cek jika input dimulai di dalam button manapun
        local buttonType = isPositionInsideButton(input.Position)
        if not buttonType then
            -- Input dimulai dari LUAR button, set flag ke false
            isInputInsideButton = false
        end
    end
end)

-- **HANDLE MOUSE/TOUCH MOVE GLOBAL**
-- Ini penting: cegah drag jika input bergerak dari luar ke dalam
UserInputService.InputChanged:Connect(function(input)
    if not isDragging then
        -- Jika belum drag tapi ada input movement, cek posisi awal
        local isTouchMove = input.UserInputType == Enum.UserInputType.Touch
        local isMouseMove = input.UserInputType == Enum.UserInputType.MouseMovement
        
        if (isTouchMove or isMouseMove) and not isInputInsideButton then
            -- Input bergerak tapi TIDAK dimulai dari dalam button
            -- Jadi kita ABORT semua kemungkinan drag
            return
        end
    end
end)

-- **FIX: Reset state saat input berakhir**
UserInputService.InputEnded:Connect(function(input)
    activeInputs[input] = nil
    isInputInsideButton = false
end)

-- **HANDLE MOUSE/TOUCH LEAVE**
teleportButton.MouseLeave:Connect(function()
    if not isDragging then
        teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if not isDragging then
        toggleButton.BackgroundColor3 = buttonVisible and Color3.fromRGB(52, 73, 94) or Color3.fromRGB(41, 128, 185)
    end
end)

-- **DRAG BISA DARI TOGGLE BUTTON SAAT HIDE JUGA**
-- Saat hide, toggle button tetap bisa drag karena masih visible

-- **Reset semua saat character respawn**
player.CharacterAdded:Connect(function()
    isDragging = false
    currentDragInput = nil
    isInputInsideButton = false
    activeInputs = {}
    
    if dragConnection then
        dragConnection:Disconnect()
        dragConnection = nil
    end
end)

-- **Untuk mobile tap cepat**
teleportButton.TouchTap:Connect(function()
    if not isDragging then
        teleportRoof()
    end
end)

screenGui.DisplayOrder = 999
