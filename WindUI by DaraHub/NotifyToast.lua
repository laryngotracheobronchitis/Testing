if getgenv().NotifyToast then return end

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local CONFIG = {
    SLIDE_IN_TIME = 0.4,
    SLIDE_OUT_TIME = 0.05,
    SCALE_TIME = 0.11,
    SCALE_DOWN = 0.96,
    START_Y = -1,
    END_Y = 59,
    DEFAULT_DURATION = 2,
    BACKGROUND_COLOR = Color3.fromHex("#23262C"),
    TEXT_COLOR = Color3.fromRGB(247,247,248),
    WIDTH_OFFSET = -24,
    TITLE_SIZE = 20,
    SUBTITLE_SIZE = 15,
    ICON_SIZE = 36,
    ICON_TEXT_SIZE = 26,
    REMOVE_PREVIOUS = true,
    CORNER_RADIUS = 6,
    MIN_HEIGHT = 55
}

local currentToast = nil
local imageCounter = 0

local function ensureFolder(path)
    pcall(function()
        if not isfolder(path) then
            makefolder(path)
        end
    end)
end

local function autoDeleteFile(filepath)
    task.delay(10, function()
        pcall(function()
            if isfile(filepath) then
                delfile(filepath)
            end
        end)
    end)
end

local function NotifyToast(config)
    config = config or {}
    
    if CONFIG.REMOVE_PREVIOUS and currentToast and currentToast.Parent then
        currentToast:Destroy()
    end

    local toastId = "Toast_" .. HttpService:GenerateGUID(false)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = toastId
    screenGui.DisplayOrder = 9
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.AutoLocalize = false
    screenGui.ResetOnSpawn = false
    screenGui.ScreenInsets = Enum.ScreenInsets.None
    screenGui.Parent = CoreGui

    currentToast = screenGui

    local container = Instance.new("TextButton")
    container.Name = "ToastContainer"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
    container.BackgroundTransparency = 1
    container.Text = ""
    container.Parent = screenGui

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MaxSize = Vector2.new(400, math.huge)
    sizeConstraint.Parent = container

    local bg = Instance.new("Frame")
    bg.Name = "Toast"
    bg.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0
    bg.Size = UDim2.new(1,0,1,0)
    bg.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
    corner.Parent = bg

    local innerFrame = Instance.new("Frame")
    innerFrame.BackgroundTransparency = 1
    innerFrame.Size = UDim2.new(1,0,1,0)
    innerFrame.Parent = bg

    local hList = Instance.new("UIListLayout")
    hList.Padding = UDim.new(0,12)
    hList.FillDirection = Enum.FillDirection.Horizontal
    hList.SortOrder = Enum.SortOrder.LayoutOrder
    hList.VerticalAlignment = Enum.VerticalAlignment.Center
    hList.Parent = innerFrame

    local msgFrame = Instance.new("Frame")
    msgFrame.BackgroundTransparency = 1
    msgFrame.Size = UDim2.new(1,0,1,0)
    msgFrame.LayoutOrder = 2
    msgFrame.Parent = innerFrame

    local vList = Instance.new("UIListLayout")
    vList.Padding = UDim.new(0,12)
    vList.SortOrder = Enum.SortOrder.LayoutOrder
    vList.VerticalAlignment = Enum.VerticalAlignment.Center
    vList.Parent = msgFrame

    local textFrame = Instance.new("Frame")
    textFrame.BackgroundTransparency = 1
    textFrame.Size = UDim2.new(1,-48,0,0)
    textFrame.AutomaticSize = Enum.AutomaticSize.Y
    textFrame.Parent = msgFrame

    local vList2 = Instance.new("UIListLayout")
    vList2.SortOrder = Enum.SortOrder.LayoutOrder
    vList2.VerticalAlignment = Enum.VerticalAlignment.Center
    vList2.Parent = textFrame

    local title = Instance.new("TextLabel")
    title.Name = "ToastTitle"
    title.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
    title.TextColor3 = CONFIG.TEXT_COLOR
    title.TextSize = CONFIG.TITLE_SIZE
    title.TextWrapped = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1,0,0,0)
    title.AutomaticSize = Enum.AutomaticSize.Y
    title.RichText = true
    title.LayoutOrder = 1
    title.Parent = textFrame

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "ToastSubtitle"
    subtitle.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
    subtitle.TextColor3 = CONFIG.TEXT_COLOR
    subtitle.TextSize = CONFIG.SUBTITLE_SIZE
    subtitle.TextWrapped = true
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.new(1,0,0,0)
    subtitle.AutomaticSize = Enum.AutomaticSize.Y
    subtitle.RichText = true
    subtitle.LayoutOrder = 2
    subtitle.Parent = textFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0,12)
    padding.PaddingRight = UDim.new(0,12)
    padding.PaddingTop = UDim.new(0,12)
    padding.PaddingBottom = UDim.new(0,12)
    padding.Parent = innerFrame

    local scaler = Instance.new("UIScale")
    scaler.Scale = 1
    scaler.Parent = container

    title.Text = config.title or ""
    subtitle.Text = config.content or config.subtitle or ""
    
    local duration = config.duration or CONFIG.DEFAULT_DURATION
    local callback = config.callback or function() end

    local showIcon = config.icon and config.icon ~= ""
    local iconObj = innerFrame:FindFirstChild("ToastIcon")
    if iconObj then iconObj:Destroy() end

    local iconColor = config.iconColor
    if type(iconColor) == "string" and iconColor:match("^#") then
        iconColor = Color3.fromHex(iconColor)
    end

    if showIcon then
        local isUrl = type(config.icon) == "string" and config.icon:match("^https?://")
        local isAsset = type(config.icon) == "string" and (config.icon:match("^rbxassetid://") or config.icon:match("^rbxasset://")) or type(config.icon) == "number"

        if isUrl then
            local req = http_request or (syn and syn.request) or request
            local folderPath = "./temp/img"
            ensureFolder(folderPath)
            imageCounter = imageCounter + 1
            local filename = folderPath .. "/" .. imageCounter .. ".png"
            local success, res = pcall(function()
                return req({Url = config.icon, Method = "GET"}).Body
            end)
            if success and res then
                writefile(filename, res)
                autoDeleteFile(filename)
                local asset = getcustomasset(filename)
                iconObj = Instance.new("ImageLabel")
                iconObj.Image = asset
                iconObj.ImageColor3 = iconColor or Color3.new(1,1,1)
                iconObj.BackgroundTransparency = 1
                iconObj.Size = UDim2.new(0, CONFIG.ICON_SIZE, 0, CONFIG.ICON_SIZE)
                iconObj.LayoutOrder = 1
                iconObj.Parent = innerFrame
            end
        elseif isAsset then
            local id = type(config.icon) == "number" and "rbxassetid://" .. config.icon or config.icon
            iconObj = Instance.new("ImageLabel")
            iconObj.Image = id
            iconObj.ImageColor3 = iconColor or Color3.new(1,1,1)
            iconObj.BackgroundTransparency = 1
            iconObj.Size = UDim2.new(0, CONFIG.ICON_SIZE, 0, CONFIG.ICON_SIZE)
            iconObj.LayoutOrder = 1
            iconObj.Parent = innerFrame
        else
            iconObj = Instance.new("TextLabel")
            iconObj.FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Bold)
            iconObj.Text = config.icon
            iconObj.TextColor3 = iconColor or CONFIG.TEXT_COLOR
            iconObj.TextSize = CONFIG.ICON_TEXT_SIZE
            iconObj.TextXAlignment = Enum.TextXAlignment.Center
            iconObj.TextYAlignment = Enum.TextYAlignment.Center
            iconObj.BackgroundTransparency = 1
            iconObj.Size = UDim2.new(0, CONFIG.ICON_SIZE, 0, CONFIG.ICON_SIZE)
            iconObj.LayoutOrder = 1
            iconObj.Parent = innerFrame
        end

        if iconObj then
            local radius = config.iconCornerRadius or config.iconRadius or config.IconCorner or config.IconRadius or 0
            if radius ~= 0 then
                local iconCorner = Instance.new("UICorner")
                if radius == true or radius == 0.5 or radius >= 18 then
                    iconCorner.CornerRadius = UDim.new(0.5, 0)
                else
                    iconCorner.CornerRadius = UDim.new(0, radius)
                end
                iconCorner.Parent = iconObj
            end
        end
    end

    local textOffset = showIcon and -48 or 0
    textFrame.Size = UDim2.new(1, textOffset, 0, 0)

    local hasTitle = title.Text ~= ""
    local hasSubtitle = subtitle.Text ~= ""
    title.Visible = hasTitle
    subtitle.Visible = hasSubtitle

    container.Size = UDim2.new(1, CONFIG.WIDTH_OFFSET, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    bg.AutomaticSize = Enum.AutomaticSize.Y
    innerFrame.AutomaticSize = Enum.AutomaticSize.Y
    msgFrame.AutomaticSize = Enum.AutomaticSize.Y

    local minHeightConstraint = Instance.new("UISizeConstraint")
    minHeightConstraint.MinSize = Vector2.new(0, CONFIG.MIN_HEIGHT)
    minHeightConstraint.Parent = container

    screenGui.Enabled = true
    container.Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
    scaler.Scale = 1

    task.wait()
    
    local actualHeight = container.AbsoluteSize.Y
    local dynamicShowY = CONFIG.END_Y/2.818 + (actualHeight / 2)
    
    container.Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
    
    TweenService:Create(container, TweenInfo.new(CONFIG.SLIDE_IN_TIME, Enum.EasingStyle.Quint), {
        Position = UDim2.new(0.5,0,0,dynamicShowY)
    }):Play()

    local function hideToast()
        TweenService:Create(container, TweenInfo.new(CONFIG.SLIDE_OUT_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5,0,0,CONFIG.START_Y)
        }):Play()
        task.delay(CONFIG.SLIDE_OUT_TIME, function()
            if currentToast == screenGui then currentToast = nil end
            screenGui:Destroy()
        end)
    end

    task.delay(duration, function()
        if screenGui and screenGui.Parent then 
            hideToast() 
        end
    end)

    container.MouseButton1Down:Connect(function()
        TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = CONFIG.SCALE_DOWN}):Play()
    end)

    container.MouseButton1Up:Connect(function()
        TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = 1}):Play()
    end)

    container.MouseButton1Click:Connect(function()
        hideToast()
        callback()
    end)

    container.MouseLeave:Connect(function()
        TweenService:Create(scaler, TweenInfo.new(CONFIG.SCALE_TIME), {Scale = 1}):Play()
    end)
end

getgenv().NotifyToast = NotifyToast
