local player = game.Players.LocalPlayer
local buttonVisible = true

-- Fungsi teleport
local function teleportRoof()
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        -- Teleport ke atas
        local currentPos = root.Position
        root.CFrame = CFrame.new(currentPos.X, currentPos.Y + 500, currentPos.Z)
    end
end

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main button
local teleportButton = Instance.new("TextButton")
teleportButton.Name = "RoofTPButton"
teleportButton.Size = UDim2.new(0, 160, 0, 40)
teleportButton.Position = UDim2.new(0.5, -80, 0.9, -50)
teleportButton.AnchorPoint = Vector2.new(0.5, 0.5)
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 14
teleportButton.Parent = screenGui

-- Toggle hide/show button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "▼"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 12
toggleButton.Parent = teleportButton

-- Koneksi event
teleportButton.MouseButton1Click:Connect(teleportRoof)

toggleButton.MouseButton1Click:Connect(function()
    buttonVisible = not buttonVisible
    if buttonVisible then
        teleportButton.Visible = true
        toggleButton.Text = "▼"
    else
        teleportButton.Visible = false
        toggleButton.Text = "▲"
    end
end)

-- Tambahkan corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = teleportButton

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

print("Simple Teleport Roof Button created!")
