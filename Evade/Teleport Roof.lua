local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local buttonVisible = true
local isDragging = false
local dragStartOffset = Vector2.new(0, 0)

-- Fungsi teleport 
local function teleportRoof()
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChild("Humanoid")
    
    if root and humanoid and humanoid.Health > 0 then
        -- Cek jika karakter sedang duduk/terbaring
        if humanoid.Sit or humanoid.PlatformStand then
            return
        end
        
        -- Teleport ke atas
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

-- Main container - Lebih besar untuk mobile touch
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 200, 0, 60) -- Lebih besar untuk mobile
mainContainer.Position = UDim2.new(0.02, 0, 0.85, 0) -- Posisi lebih ke atas
mainContainer.BackgroundTransparency = 1
mainContainer.Active = true
mainContainer.Selectable = true
mainContainer.Parent = screenGui

-- Background untuk area drag
local dragArea = Instance.new("Frame")
dragArea.Name = "DragArea"
dragArea.Size = UDim2.new(1, 0, 1, 0)
dragArea.BackgroundTransparency = 1
dragArea.Parent = mainContainer

-- Teleport button (lebih besar untuk mobile)
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "RoofTPButton"
teleportButton.Size = UDim2.new(0.85, 0, 1, 0) -- 85% width
teleportButton.Position = UDim2.new(0, 0, 0, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 16 -- Lebih besar untuk mobile
teleportButton.TextScaled = true -- Auto scale text
teleportButton.AutoButtonColor = false -- Manual hover effect
teleportButton.Parent = mainContainer

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.15, 0, 1, 0) -- 15% width
toggleButton.Position = UDim2.new(0.85, 0, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "▼"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 20 -- Lebih besar
toggleButton.AutoButtonColor = false
toggleButton.Parent = mainContainer

-- Styling dengan UICorner
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 12) -- Corner lebih besar
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

-- Efek hover untuk teleport button
teleportButton.MouseButton1Down:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
end)

teleportButton.MouseButton1Up:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)

teleportButton.MouseLeave:Connect(function()
    teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
end)

-- Efek hover untuk toggle button
toggleButton.MouseButton1Down:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
end)

toggleButton.MouseButton1Up:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
end)

toggleButton.MouseLeave:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
end)

-- **DRAG SYSTEM YANG SUPPORT MOBILE**
local function startDrag(input)
    -- Cek jika input adalah touch atau mouse click
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        isDragging = true
        
        -- Hitung offset antara posisi klik dan posisi container
        local containerPos = mainContainer.AbsolutePosition
        local inputPos = input.Position
        dragStartOffset = Vector2.new(
            containerPos.X - inputPos.X,
            containerPos.Y - inputPos.Y
        )
        
        -- Visual feedback saat drag
        teleportButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
        
        -- Connect untuk end drag
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

local function updateDrag(input)
    if isDragging then
        -- Update posisi container berdasarkan input posisi + offset
        local newX = input.Position.X + dragStartOffset.X
        local newY = input.Position.Y + dragStartOffset.Y
        
        -- Konversi ke UDim2
        local screenSize = workspace.CurrentCamera.ViewportSize
        local newUDim2 = UDim2.new(
            0, newX,
            0, newY
        )
        
        mainContainer.Position = newUDim2
    end
end

-- Untuk drag area (seluruh container)
dragArea.InputBegan:Connect(startDrag)

-- Untuk teleport button (juga bisa drag)
teleportButton.InputBegan:Connect(startDrag)

-- Update drag position
UserInputService.InputChanged:Connect(function(input)
    if isDragging then
        local isTouchMove = input.UserInputType == Enum.UserInputType.Touch
        local isMouseMove = input.UserInputType == Enum.UserInputType.MouseMovement
        
        if isTouchMove or isMouseMove then
            updateDrag(input)
        end
    end
end)

-- **ALTERNATIVE: Drag dengan RenderStepped (lebih smooth untuk mobile)**
local dragConnection
dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or 
       input.UserInputType == Enum.UserInputType.MouseButton1 then
        
        isDragging = true
        local startPos = mainContainer.Position
        local startInputPos = input.Position
        
        dragConnection = RunService.RenderStepped:Connect(function()
            if isDragging then
                local currentInput = UserInputService:GetMouseLocation()
                if not currentInput then return end
                
                local delta = Vector2.new(
                    currentInput.X - startInputPos.X,
                    currentInput.Y - startInputPos.Y
                )
                
                mainContainer.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        local endConnection
        endConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                if dragConnection then
                    dragConnection:Disconnect()
                end
                if endConnection then
                    endConnection:Disconnect()
                end
                teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            end
        end)
    end
end)

-- Toggle show/hide
toggleButton.MouseButton1Click:Connect(function()
    buttonVisible = not buttonVisible
    
    if buttonVisible then
        teleportButton.Visible = true
        toggleButton.Text = "▼"
        toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
    else
        teleportButton.Visible = false
        toggleButton.Text = "▲"
        toggleButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
    end
end)

-- Teleport function
teleportButton.MouseButton1Click:Connect(teleportRoof)

-- mobile touch, juga support tap
teleportButton.TouchTap:Connect(teleportRoof)

-- button tidak terhalang oleh elemen lain
screenGui.DisplayOrder = 999
