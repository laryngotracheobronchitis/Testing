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

-- Main container - UKURAN LEBIH KECIL
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 180, 0, 55) -- Lebih kecil
mainContainer.Position = UDim2.new(0.02, 0, 0.85, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Parent = screenGui

-- **TOGGLE BUTTON DI KIRI (UKURAN KECIL)**
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 40, 0, 55) -- Lebar kecil: 40
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
teleportButton.Size = UDim2.new(0, 140, 0, 55) -- 180 - 40 = 140
teleportButton.Position = UDim2.new(0, 40, 0, 0) -- Mulai dari posisi 40
teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Text = "🔝 Teleport Roof"
teleportButton.Font = Enum.Font.GothamSemibold
teleportButton.TextSize = 14
toggleButton.TextScaled = false
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
local activeInputs = {} -- Simpan semua input yang aktif
local lastClickTime = 0
local CLICK_DELAY = 0.2 -- Delay untuk mencegah accidental drag

-- **FUNGSI UNTUK MENGECEK JIKA INPUT MULAI DARI BUTTON**
local function isInputOnButton(input)
    local inputPos = input.Position
    
    -- Cek jika input berada di toggle button
    local toggleAbsPos = toggleButton.AbsolutePosition
    local toggleAbsSize = toggleButton.AbsoluteSize
    
    if inputPos.X >= toggleAbsPos.X and inputPos.X <= toggleAbsPos.X + toggleAbsSize.X and
       inputPos.Y >= toggleAbsPos.Y and inputPos.Y <= toggleAbsPos.Y + toggleAbsSize.Y then
        return "toggle"
    end
    
    -- Cek jika input berada di teleport button (hanya jika visible)
    if teleportButton.Visible then
        local teleportAbsPos = teleportButton.AbsolutePosition
        local teleportAbsSize = teleportButton.AbsoluteSize
        
        if inputPos.X >= teleportAbsPos.X and inputPos.X <= teleportAbsPos.X + teleportAbsSize.X and
           inputPos.Y >= teleportAbsPos.Y and inputPos.Y <= teleportAbsPos.Y + teleportAbsSize.Y then
            return "teleport"
        end
    end
    
    return nil
end

-- **DRAG SYSTEM YANG HANYA AKTIF SAAT TEKAN BUTTON**
local dragConnection = nil

local function startDrag(input)
    -- Hanya mulai drag jika input dimulai dari button
    local buttonType = isInputOnButton(input)
    if not buttonType then return end
    
    -- Cegah accidental drag saat klik cepat
    local currentTime = tick()
    if currentTime - lastClickTime < CLICK_DELAY then
        return
    end
    
    if isDragging then return end
    
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        isDragging = true
        currentDragInput = input
        
        local containerPos = mainContainer.AbsolutePosition
        local inputPos = input.Position
        dragStartOffset = Vector2.new(
            containerPos.X - inputPos.X,
            containerPos.Y - inputPos.Y
        )
        
        -- Visual feedback untuk button yang ditekan
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
                    -- Cari input touch yang sesuai
                    for _, touch in pairs(UserInputService:GetTouches()) do
                        if touch.UserInputType == Enum.UserInputType.Touch then
                            currentInputPos = touch.Position
                            break
                        end
                    end
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

-- **HANDLE INPUT UNTUK BUTTON (TANPA AREA LUAR)**
-- Toggle button events
toggleButton.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        toggleButton.BackgroundColor3 = Color3.fromRGB(44, 62, 80)
        activeInputs[input] = true
        
        -- Mulai drag setelah delay kecil
        task.delay(0.1, function()
            if activeInputs[input] and not isDragging then
                startDrag(input)
            end
        end)
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if activeInputs[input] then
        activeInputs[input] = nil
        
        -- Jika tidak drag, berarti klik
        if not isDragging then
            lastClickTime = tick()
            
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
                toggleButton.Size = UDim2.new(0, 50, 0, 55) -- Sedikit lebih lebar saat hide
            end
        end
        
        toggleButton.BackgroundColor3 = buttonVisible and Color3.fromRGB(52, 73, 94) or Color3.fromRGB(41, 128, 185)
    end
end)

-- Teleport button events
teleportButton.InputBegan:Connect(function(input)
    local isTouch = input.UserInputType == Enum.UserInputType.Touch
    local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
    
    if isTouch or isMouse then
        teleportButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
        activeInputs[input] = true
        
        -- Mulai drag setelah delay
        task.delay(0.15, function()
            if activeInputs[input] and not isDragging then
                startDrag(input)
            end
        end)
    end
end)

teleportButton.InputEnded:Connect(function(input)
    if activeInputs[input] then
        activeInputs[input] = nil
        
        -- Jika tidak drag, teleport
        if not isDragging then
            lastClickTime = tick()
            teleportRoof()
        end
        
        teleportButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

-- **PREVENT DRAG DARI AREA LUAR BUTTON**
-- Non-aktifkan input untuk mainContainer agar tidak trigger drag
mainContainer.InputBegan:Connect(function(input)
    -- Hanya biarkan event melalui jika tidak ada button yang terkena
    local buttonType = isInputOnButton(input)
    if not buttonType then
        -- Jika input di luar button, kita tidak proses
        return
    end
end)

-- **HANDLE TOUCH/MOUSE LEAVE**
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

-- **CLEANUP ACTIVE INPUTS SAAT RELEASE**
UserInputService.InputEnded:Connect(function(input)
    activeInputs[input] = nil
end)

-- **FIX: Reset semua state saat character respawn**
player.CharacterAdded:Connect(function()
    isDragging = false
    currentDragInput = nil
    activeInputs = {}
    
    if dragConnection then
        dragConnection:Disconnect()
        dragConnection = nil
    end
end)

-- **Untuk mobile: handle touch khusus**
teleportButton.TouchTap:Connect(function()
    if not isDragging then
        teleportRoof()
    end
end)

screenGui.DisplayOrder = 999
