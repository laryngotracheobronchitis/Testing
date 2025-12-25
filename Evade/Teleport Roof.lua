local player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local buttonVisible = true
local isDragging = false
local dragStartPos, buttonStartPos

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

-- GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportRoofGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main container
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 180, 0, 50)
mainContainer.Position = UDim2.new(0.02, 0, 0.9, 0) -- Bawah kiri dekat logo Roblox
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "RoofTPButton"
teleportButton.Size = UDim2.new(1, 0, 1, 0)
teleportButton.Position = UDim2.new(0, 0, 0, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 14
teleportButton.Parent = mainContainer

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "▼"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = mainContainer

-- Styling dengan UICorner
local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportButton

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Efek hover untuk teleport button
teleportButton.MouseEnter:Connect(function()
    if buttonVisible then
        teleportButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    end
end)

teleportButton.MouseLeave:Connect(function()
    if buttonVisible then
        teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

-- Efek hover untuk toggle button
toggleButton.MouseEnter:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
end)

toggleButton.MouseLeave:Connect(function()
    toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
end)

-- Fungsi drag
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        buttonStartPos = mainContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
            end
        end)
    end
end

local function updateDrag(input)
    if isDragging then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        local newPosition = UDim2.new(
            buttonStartPos.X.Scale, 
            buttonStartPos.X.Offset + delta.X,
            buttonStartPos.Y.Scale, 
            buttonStartPos.Y.Offset + delta.Y
        )
        mainContainer.Position = newPosition
    end
end

-- Koneksi drag events
mainContainer.InputBegan:Connect(startDrag)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

-- Toggle show/hide
toggleButton.MouseButton1Click:Connect(function()
    buttonVisible = not buttonVisible
    
    if buttonVisible then
        teleportButton.Visible = true
        toggleButton.Text = "▼"
        toggleButton.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
        
        -- Animasi fade in
        teleportButton.BackgroundTransparency = 0.3
        local tween = TweenService:Create(
            teleportButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        )
        tween:Play()
    else
        teleportButton.Visible = false
        toggleButton.Text = "▲"
        toggleButton.BackgroundColor3 = Color3.fromRGB(41, 128, 185)
    end
end)

-- Teleport function
teleportButton.MouseButton1Click:Connect(teleportRoof)

-- Optional: Tambahkan stroke/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(30, 30, 30)
stroke.Thickness = 1.5
stroke.Parent = teleportButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(30, 30, 30)
toggleStroke.Thickness = 1
toggleStroke.Parent = toggleButton
