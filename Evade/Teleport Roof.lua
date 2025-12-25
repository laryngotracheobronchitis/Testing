local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local buttonVisible = true
local isDragging = false
local currentDragInput -- Hanya simpan 1 input untuk drag
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
mainContainer.Size = UDim2.new(0, 200, 0, 60)
mainContainer.Position = UDim2.new(0.02, 0, 0.85, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Parent = screenGui

-- **TOGGLE BUTTON DI KIRI**
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 60) -- Lebar 50, tinggi sama
toggleButton.Position = UDim2.new(0, 0, 0, 0) -- Posisi kiri
toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "▼"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainContainer

-- **TELEPORT BUTTON DI KANAN (setelah toggle)**
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "RoofTPButton"
teleportButton.Size = UDim2.new(0, 150, 0, 60) -- Lebar 150 (200-50)
teleportButton.Position = UDim2.new(0, 50, 0, 0) -- Mulai dari posisi 50 (setelah toggle)
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 16
teleportButton.TextScaled = true
teleportButton.AutoButtonColor = false
teleportButton.Parent = mainContainer

-- Styling
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 12)
teleportCorner.Parent = teleportButton

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton

-- Stroke/border
local teleportStroke = Instance.new("UIStroke")
teleportStroke.Color = Color3.fromRGB(30, 30, 30)
teleportStroke.Thickness = 2
teleportStroke.Parent = teleportButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(30, 30, 30)
toggleStroke.Thickness = 2
toggleStroke.Parent = toggleButton

-- Efek visual untuk teleport button
teleportButton.MouseButton1Down:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
end)

teleportButton.MouseButton1Up:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    teleportRoof()
end)

teleportButton.MouseLeave:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)

-- Untuk mobile touch
teleportButton.TouchTap:Connect(teleportRoof)

teleportButton.TouchLongPress:Connect(function()
    -- Long press untuk mulai drag (opsional)
end)

-- Efek visual untuk toggle button
toggleButton.MouseButton1Down:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
end)

toggleButton.MouseButton1Up:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    
    -- Toggle show/hide
    buttonVisible = not buttonVisible
    
    if buttonVisible then
        teleportButton.Visible = true
        toggleButton.Text = "▼"
        toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
        teleportButton.Size = UDim2.new(0, 150, 0, 60)
    else
        teleportButton.Visible = false
        toggleButton.Text = "▲"
        toggleButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
        -- Saat hide, toggle button perlu lebih lebar
        toggleButton.Size = UDim2.new(0, 60, 0, 60)
    end
end)

toggleButton.MouseLeave:Connect(function()
    if buttonVisible then
        toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
    end
end)

-- **DRAG SYSTEM YANG FIX UNTUK MOBILE (Anti Multi-Touch)**
local dragConnection

local function startDrag(input)
    -- Hanya proses jika belum ada drag aktif
    if isDragging then return end
    
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        isDragging = true
        currentDragInput = input -- Simpan input yang sedang drag
        
        local containerPos = mainContainer.AbsolutePosition
        local inputPos = input.Position
        dragStartOffset = Vector2.new(
            containerPos.X - inputPos.X,
            containerPos.Y - inputPos.Y
        )
        
        -- Visual feedback
        if teleportButton.Visible then
            teleportButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
        end
        
        -- Gunakan RenderStepped untuk smooth dragging
        dragConnection = RunService.RenderStepped:Connect(function()
            if isDragging and currentDragInput then
                local currentInputPos
                
                -- Dapatkan posisi input yang benar
                if isTouch then
                    -- Untuk touch, gunakan posisi dari input yang disimpan
                    currentInputPos = currentDragInput.Position
                else
                    -- Untuk mouse, gunakan posisi mouse saat ini
                    currentInputPos = UserInputService:GetMouseLocation()
                end
                
                if currentInputPos then
                    -- Hitung posisi baru
                    local newX = currentInputPos.X + dragStartOffset.X
                    local newY = currentInputPos.Y + dragStartOffset.Y
                    
                    -- Pastikan tidak keluar dari layar
                    local screenSize = workspace.CurrentCamera.ViewportSize
                    newX = math.clamp(newX, 0, screenSize.X - mainContainer.AbsoluteSize.X)
                    newY = math.clamp(newY, 0, screenSize.Y - mainContainer.AbsoluteSize.Y)
                    
                    -- Update posisi
                    mainContainer.Position = UDim2.new(0, newX, 0, newY)
                end
            end
        end)
        
        -- Connect end drag
        local endConnection
        endConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                -- Hanya stop drag jika ini adalah input yang sama
                if currentDragInput == input then
                    isDragging = false
                    currentDragInput = nil
                    
                    if dragConnection then
                        dragConnection:Disconnect()
                        dragConnection = nil
                    end
                    
                    -- Kembalikan warna
                    if teleportButton.Visible then
                        teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                    end
                end
                
                if endConnection then
                    endConnection:Disconnect()
                end
            end
        end)
    end
end

-- **DRAG HANYA PADA TOGGLE BUTTON SAAT HIDE**
-- Saat teleport button visible, drag dari mana saja
teleportButton.InputBegan:Connect(function(input)
    if teleportButton.Visible then
        startDrag(input)
    end
end)

-- Saat teleport button hidden, hanya toggle button yang bisa drag
toggleButton.InputBegan:Connect(function(input)
    startDrag(input)
end)

-- Juga bisa drag dari area kosong (jika ada)
mainContainer.InputBegan:Connect(function(input)
    startDrag(input)
end)

-- **FIX: Tangani ketika touch lain muncul saat sedang drag**
UserInputService.TouchStarted:Connect(function(input)
    if isDragging and currentDragInput and currentDragInput ~= input then
        -- Jika sudah ada drag aktif dengan input lain, ignore touch baru
        return
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    if currentDragInput == input then
        isDragging = false
        currentDragInput = nil
        
        if dragConnection then
            dragConnection:Disconnect()
            dragConnection = nil
        end
    end
end)

-- **FIX: Tangani input changed untuk semua input**
UserInputService.InputChanged:Connect(function(input)
    if isDragging and currentDragInput then
        -- Update posisi drag input jika input yang sama
        if input.UserInputType == currentDragInput.UserInputType then
            -- Untuk mouse movement, update posisi
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                currentDragInput = input
            end
        end
    end
end)

-- **Untuk memastikan drag berhenti saat semua touch dilepas**
UserInputService.TouchEnded:Connect(function()
    -- Cek jika masih ada touch aktif
    local touches = UserInputService:GetTouchCount()
    if touches == 0 then
        isDragging = false
        currentDragInput = nil
        
        if dragConnection then
            dragConnection:Disconnect()
            dragConnection = nil
        end
    end
end)

-- **FIX: Reset drag state jika game pause atau lainnya**
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    isDragging = false
    currentDragInput = nil
    
    if dragConnection then
        dragConnection:Disconnect()
        dragConnection = nil
    end
end)

-- Pastikan GUI di atas
screenGui.DisplayOrder = 999
