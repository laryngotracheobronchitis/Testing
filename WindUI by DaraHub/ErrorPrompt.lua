if not getgenv().ErrorPrompt then
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local ContextActionService = game:GetService("ContextActionService")
    local GuiService = game:GetService("GuiService")
    local UserInputService = game:GetService("UserInputService")
    
    local theme = {
        ["Flint"] = Color3.fromRGB(57, 59, 61),
        ["Pumice"] = Color3.fromRGB(189, 190, 190),
        ["Slate"] = Color3.fromRGB(35, 37, 39),
        ["White"] = Color3.fromRGB(255, 255, 255),
    }
    
    local metrics = {
        ["Side Padding"] = 20,
        ["Side Margin"] = 12,
        ["Layout Padding"] = 20,
        ["Button Height"] = 36,
        ["Button Padding"] = 10,
        ["Split Thickness"] = 1,
        ["Max Width"] = 400,
        ["Min Width"] = 200,
        ["Title Height"] = 38,
    }
    
    local buttonTypes = {
        Primary = { Background = theme["White"], Text = theme["Slate"], Stroke = theme["White"], Transparency = 0 },
        Secondary = { Background = theme["Flint"], Text = theme["Pumice"], Stroke = theme["Pumice"], Transparency = 0 },
        Danger = { Background = Color3.fromRGB(196, 58, 58), Text = theme["White"], Stroke = Color3.fromRGB(230, 110, 110), Transparency = 0 },
        Ghost = { Background = theme["Flint"], Text = theme["Pumice"], Stroke = theme["Pumice"], Transparency = 1 },
    }
    
    local defaultConfig = {
        CornerRadius = 0,
        ButtonCornerRadius = 6,
        Animation = true,
        AnimationTime = 0.15,
        Overlay = true,
        OverlayColor = Color3.new(0, 0, 0),
        OverlayTransparency = 0.5,
        DisplayOrder = 2147483647,
        BackgroundColor = theme["Flint"],
        TitleColor = theme["White"],
        MessageColor = theme["Pumice"],
        SplitColor = theme["Pumice"],
    }
    
    local function make(className, properties, children)
        local instance = Instance.new(className)
        for property, value in pairs(properties) do
            instance[property] = value
        end
        for _, child in ipairs(children or {}) do
            child.Parent = instance
        end
        return instance
    end
    
    local function fetchImage(url, filename)
        local ok, result = pcall(function()
            local send = http_request or (syn and syn.request) or request
            local response = send({ Url = url, Method = "GET" })
            if not (response and response.Body) then
                return nil
            end
            if not isfolder(".temp") then
                makefolder(".temp")
            end
            if not isfolder(".temp/img") then
                makefolder(".temp/img")
            end
            local path = ".temp/img/" .. filename
            writefile(path, response.Body)
            local asset = getcustomasset(path)
            task.delay(1, function()
                pcall(function()
                    if isfile(path) then
                        delfile(path)
                    end
                    if isfolder(".temp/img") and #listfiles(".temp/img") == 0 then
                        delfolder(".temp/img")
                    end
                    if isfolder(".temp") and #listfiles(".temp") == 0 then
                        delfolder(".temp")
                    end
                end)
            end)
            return asset
        end)
        if ok then
            return result
        end
        return nil
    end
    
    local Window = {}
    Window.__index = Window
    
    local function createPromptUI(config, options)
        local screenGui = make("ScreenGui", {
            Name = options.Name or "ErrorPromptGui",
            DisplayOrder = options.ZIndex or config.DisplayOrder,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            Enabled = false,
        })
    
        local overlay = make("Frame", {
            Name = "Overlay",
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = config.OverlayColor,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Active = true,
            ZIndex = 1,
            Parent = screenGui,
        })
    
        local scale = make("UIScale", { Name = "PromptScale", Scale = 0 })
    
        local frame = make("Frame", {
            Name = "ErrorPrompt",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, -2 * metrics["Side Margin"], 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = config.BackgroundColor,
            BorderSizePixel = 0,
            ZIndex = 8,
            Parent = overlay,
        }, {
            make("UICorner", { Name = "PromptCorner", CornerRadius = UDim.new(0, config.CornerRadius) }),
            make("UISizeConstraint", {
                MinSize = Vector2.new(metrics["Min Width"], 0),
                MaxSize = Vector2.new(metrics["Max Width"], math.huge),
            }),
            make("UIListLayout", {
                Name = "PromptLayout",
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            }),
            scale,
        })
    
        local titleFrame = make("Frame", {
            Name = "TitleFrame",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 8,
            Parent = frame,
        }, {
            make("UIPadding", {
                PaddingTop = UDim.new(0, 4),
                PaddingBottom = UDim.new(0, 4),
            }),
            make("UIListLayout", {
                Name = "TitleLayout",
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),
            make("UISizeConstraint", { MinSize = Vector2.new(0, metrics["Title Height"]) }),
        })
    
        local title = make("TextLabel", {
            Name = "ErrorTitle",
            LayoutOrder = 2,
            Size = UDim2.new(1, -2 * metrics["Side Padding"], 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSansSemibold,
            TextSize = 25,
            TextColor3 = config.TitleColor,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            Text = "",
            ZIndex = 8,
            Parent = titleFrame,
        })
    
        local split = make("Frame", {
            Name = "SplitLine",
            LayoutOrder = 2,
            Size = UDim2.new(1, -2 * metrics["Side Padding"], 0, metrics["Split Thickness"]),
            BackgroundColor3 = config.SplitColor,
            BorderSizePixel = 0,
            ZIndex = 8,
            Parent = frame,
        })
    
        local messageArea = make("Frame", {
            Name = "MessageArea",
            LayoutOrder = 3,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 8,
            Parent = frame,
        }, {
            make("UIPadding", {
                PaddingTop = UDim.new(0, metrics["Side Padding"]),
                PaddingBottom = UDim.new(0, metrics["Side Padding"]),
                PaddingLeft = UDim.new(0, metrics["Side Padding"]),
                PaddingRight = UDim.new(0, metrics["Side Padding"]),
            }),
            make("UIListLayout", {
                Name = "ErrorFrameLayout",
                Padding = UDim.new(0, metrics["Layout Padding"]),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
            }),
        })
    
        local message = make("TextLabel", {
            Name = "ErrorMessage",
            LayoutOrder = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            TextSize = 20,
            TextColor3 = config.MessageColor,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Top,
            Text = "",
            ZIndex = 8,
            Parent = messageArea,
        })
    
        local buttonArea = make("Frame", {
            Name = "ButtonArea",
            LayoutOrder = 2,
            Size = UDim2.new(1, 0, 0, metrics["Button Height"]),
            BackgroundTransparency = 1,
            SelectionGroup = true,
            ZIndex = 8,
            Parent = messageArea,
        }, {
            make("UIListLayout", {
                Name = "ButtonLayout",
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, metrics["Button Padding"]),
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),
        })
    
        return {
            gui = screenGui,
            overlay = overlay,
            scale = scale,
            frame = frame,
            titleFrame = titleFrame,
            title = title,
            split = split,
            message = message,
            buttonArea = buttonArea,
        }
    end
    
    function Window.new(data, config)
        data = data or {}
        local self = setmetatable({}, Window)
    
        self._open = false
        self._busy = false
        self._destroyed = false
        self._config = {}
        for key, value in pairs(defaultConfig) do
            self._config[key] = value
        end
        for key, value in pairs(config or {}) do
            self._config[key] = value
        end
        for key, value in pairs(data) do
            if defaultConfig[key] ~= nil then
                self._config[key] = value
            end
        end
        if data.Options then
            for key, value in pairs(data.Options) do
                self._config[key] = value
            end
        end
    
        self._connections = {}
        self._glowTweens = {}
        self._tweens = {}
        self._buttons = {}
        self._sinkName = "CustomErrorPromptSink" .. tostring(math.random(1000, 9999))
        self._iconToken = 0
    
        local ui = createPromptUI(self._config, data)
        self._ui = ui
        self._gui = ui.gui
        self._overlay = ui.overlay
        self._scale = ui.scale
        self._frame = ui.frame
        self._titleFrame = ui.titleFrame
        self._title = ui.title
        self._split = ui.split
        self._message = ui.message
        self._buttonArea = ui.buttonArea
    
        ui.gui.Parent = CoreGui
    
        return self
    end
    
    function Window:setTitle(text, color)
        if self._title then
            self._title.Text = text or ""
            if typeof(color) == "Color3" then
                self._title.TextColor3 = color
                self._config.TitleColor = color
            end
        end
    end
    
    function Window:setMessage(text, color)
        if self._message then
            self._message.Text = text or ""
            if typeof(color) == "Color3" then
                self._message.TextColor3 = color
                self._config.MessageColor = color
            end
        end
    end
    
    function Window:setTitleColor(color)
        if self._title and typeof(color) == "Color3" then
            self._title.TextColor3 = color
            self._config.TitleColor = color
        end
    end
    
    function Window:setMessageColor(color)
        if self._message and typeof(color) == "Color3" then
            self._message.TextColor3 = color
            self._config.MessageColor = color
        end
    end
    
    function Window:setBackgroundColor(color)
        if self._frame and typeof(color) == "Color3" then
            self._frame.BackgroundColor3 = color
            self._config.BackgroundColor = color
        end
    end
    
    function Window:setSplitColor(color)
        if self._split and typeof(color) == "Color3" then
            self._split.BackgroundColor3 = color
            self._config.SplitColor = color
        end
    end
    
    function Window:setCornerRadius(promptRadius, buttonRadius)
        if type(promptRadius) == "number" then
            self._config.CornerRadius = promptRadius
            if self._frame then
                local corner = self._frame:FindFirstChild("PromptCorner")
                if corner then
                    corner.CornerRadius = UDim.new(0, promptRadius)
                end
            end
        end
        if type(buttonRadius) == "number" then
            self:setButtonCornerRadius(buttonRadius)
        end
    end
    
    function Window:setButtonCornerRadius(radius)
        if type(radius) ~= "number" then
            return
        end
        self._config.ButtonCornerRadius = radius
        for _, entry in ipairs(self._buttons) do
            if not entry.button:GetAttribute("CustomCorner") then
                entry.corner.CornerRadius = UDim.new(0, radius)
                if entry.fillCorner then
                    entry.fillCorner.CornerRadius = entry.corner.CornerRadius
                end
            end
        end
    end
    
    function Window:setIcon(icon, order, size, color)
        if not self._titleFrame then
            return
        end
        local existing = self._titleFrame:FindFirstChild("Icon")
        if existing then
            existing:Destroy()
        end
        self._iconToken = self._iconToken + 1
        local token = self._iconToken
    
        local hasIcon = type(icon) == "string" and icon ~= ""
        local headerPadding = self._titleFrame:FindFirstChildOfClass("UIPadding")
        if headerPadding then
            headerPadding.PaddingTop = UDim.new(0, hasIcon and 14 or 4)
            headerPadding.PaddingBottom = UDim.new(0, hasIcon and 14 or 4)
        end
        local headerLayout = self._titleFrame:FindFirstChild("TitleLayout")
        if headerLayout then
            headerLayout.Padding = UDim.new(0, hasIcon and 8 or 4)
        end
    
        if not hasIcon then
            return
        end
    
        size = size or 30
        if type(size) == "number" then
            size = UDim2.fromOffset(size, size)
        end
        color = color or Color3.fromRGB(247, 247, 248)
    
        local layoutOrder = order == "Top" and 1 or 3
        local isUrl = icon:find("^https?://") ~= nil
        local isAsset = icon:find("^rbxassetid://") ~= nil or icon:find("^rbxasset://") ~= nil
    
        if isUrl or isAsset then
            local label = make("ImageLabel", {
                Name = "Icon",
                LayoutOrder = layoutOrder,
                BackgroundTransparency = 1,
                ImageColor3 = color,
                Size = size,
                ZIndex = 8,
                Parent = self._titleFrame,
            })
            if isUrl then
                task.spawn(function()
                    local image = fetchImage(icon, "icon_" .. tostring(tick()) .. ".png")
                    if image and token == self._iconToken and label.Parent then
                        label.Image = image
                    end
                end)
            else
                label.Image = icon
            end
        else
            make("TextLabel", {
                Name = "Icon",
                LayoutOrder = layoutOrder,
                BackgroundTransparency = 1,
                Size = size,
                RichText = true,
                Text = "<font family='rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json' weight='Regular' style='Normal'>" .. icon .. "</font>",
                TextColor3 = color,
                TextSize = size.X.Offset,
                ZIndex = 8,
                Parent = self._titleFrame,
            })
        end
    end
    
    function Window:_startGlow(button, definition, baseColor)
        if button:FindFirstChild("GlowFill") then
            return
        end
        local glowColor = definition.GlowColor or Color3.fromRGB(150, 150, 150)
        local speed = definition.GlowSpeed or 1.5
    
        local fill = make("UIGradient", {
            Name = "GlowFill",
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, baseColor),
                ColorSequenceKeypoint.new(0.5, glowColor),
                ColorSequenceKeypoint.new(1, baseColor),
            }),
            Offset = Vector2.new(-1, 0),
            Parent = button,
        })
        local tween = TweenService:Create(
            fill,
            TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false),
            { Offset = Vector2.new(1, 0) }
        )
        tween:Play()
        table.insert(self._glowTweens, tween)
    end
    
    function Window:setButtons(buttons)
        buttons = buttons or {}
        local count = #buttons
        if not self._buttonArea then
            return
        end
    
        if count == 0 then
            self._buttonArea.Visible = false
            return
        end
        self._buttonArea.Visible = true
    
        local gap = metrics["Button Padding"]
        for index, definition in ipairs(buttons) do
            local typeName = definition.Type or (definition.Primary and "Primary") or "Secondary"
            local style = buttonTypes[typeName] or buttonTypes.Secondary
            local baseColor = definition.Color or style.Background
            local textColor = definition.TextColor or style.Text
    
            local slot = make("Frame", {
                Name = (definition.Text or "Button") .. "Slot",
                LayoutOrder = definition.LayoutOrder or index,
                Size = UDim2.new(1 / count, -gap * (count - 1) / count, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 8,
                Parent = self._buttonArea,
            })
    
            local strokeConfig = definition.Stroke
            local strokeThickness = 0
            if strokeConfig then
                local config = type(strokeConfig) == "table" and strokeConfig or {}
                strokeThickness = config.Thickness or 1
            end
    
            local corner = make("UICorner", {
                Name = "ButtonCorner",
                CornerRadius = UDim.new(0, definition.CornerRadius or self._config.ButtonCornerRadius),
            })
    
            local button = make("TextButton", {
                Name = (definition.Text or "Button") .. "Button",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(1, -2 * strokeThickness, 1, -2 * strokeThickness),
                BackgroundColor3 = baseColor,
                BackgroundTransparency = style.Transparency,
                AutoButtonColor = false,
                BorderSizePixel = 0,
                Font = Enum.Font.SourceSans,
                TextSize = definition.TextSize or 20,
                TextColor3 = textColor,
                Text = definition.Text or "OK",
                ZIndex = 8,
                Parent = slot,
            }, { corner })
    
            if definition.CornerRadius ~= nil then
                button:SetAttribute("CustomCorner", true)
            end
    
            if strokeConfig then
                local config = type(strokeConfig) == "table" and strokeConfig or {}
                make("UIStroke", {
                    Name = "ButtonStroke",
                    Color = config.Color or style.Stroke,
                    Thickness = strokeThickness,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Parent = button,
                })
            end
    
            local window = self
            local def = definition
            local btn = button
            local base = baseColor
    
            local connections = {}
            table.insert(connections, btn.Activated:Connect(function()
                if not btn.Active or window._busy or window._destroyed then
                    return
                end
                window._busy = true
                if def.Glow then
                    window:_startGlow(btn, def, base)
                end
                if def.Callback then
                    local ok, err = pcall(def.Callback, window)
                    if not ok then
                        warn("[ErrorPrompt] button callback error: " .. tostring(err))
                    end
                end
                window._busy = false
                window:close()
            end))
    
            local fillCorner
            local waitTime = definition.WaitTimeClick
            if definition.Disabled then
                button.Active = false
                button.TextTransparency = 0.5
            elseif type(waitTime) == "number" and waitTime > 0 then
                button.Active = false
                fillCorner = make("UICorner", { CornerRadius = corner.CornerRadius })
                local fill = make("Frame", {
                    Name = "WaitFill",
                    Size = UDim2.fromScale(1, 1),
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = button,
                }, { fillCorner })
                local gradient = make("UIGradient", { Parent = fill })
                local startTime = os.clock()
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    local progress = (os.clock() - startTime) / waitTime
                    if progress >= 1 then
                        connection:Disconnect()
                        if fill and fill.Parent then
                            fill:Destroy()
                        end
                        if btn and btn.Parent then
                            btn.Active = true
                        end
                        return
                    end
                    local p = math.clamp(progress, 0.001, 0.997)
                    gradient.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 1),
                        NumberSequenceKeypoint.new(p, 1),
                        NumberSequenceKeypoint.new(p + 0.002, 0.6),
                        NumberSequenceKeypoint.new(1, 0.6),
                    })
                end)
                table.insert(connections, connection)
            end
    
            table.insert(self._buttons, { button = button, corner = corner, fillCorner = fillCorner, connections = connections })
        end
    end
    
    local function sink()
        return Enum.ContextActionResult.Sink
    end
    
    function Window:_play(target, properties)
        local tween = TweenService:Create(
            target,
            TweenInfo.new(self._config.AnimationTime, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
            properties
        )
        table.insert(self._tweens, tween)
        tween:Play()
        return tween
    end
    
    function Window:_stopTweens()
        for _, tween in ipairs(self._tweens) do
            tween:Cancel()
            tween:Destroy()
        end
        self._tweens = {}
    end
    
    function Window:show()
        if self._open or self._destroyed then
            return
        end
        self._open = true
    
        local cfg = self._config
        local overlayTarget = cfg.Overlay and cfg.OverlayTransparency or 1
    
        self:_stopTweens()
        if self._overlay then
            self._overlay.Active = cfg.Overlay
        end
        if self._gui then
            self._gui.Enabled = true
        end
    
        if cfg.Animation == true then
            if self._scale then
                self._scale.Scale = 0
                self:_play(self._scale, { Scale = 1 })
            end
            if self._overlay then
                self._overlay.BackgroundTransparency = 1
                self:_play(self._overlay, { BackgroundTransparency = overlayTarget })
            end
        else
            if self._scale then
                self._scale.Scale = 1
            end
            if self._overlay then
                self._overlay.BackgroundTransparency = overlayTarget
            end
        end
    
        ContextActionService:BindActionAtPriority(
            self._sinkName,
            sink,
            false,
            Enum.ContextActionPriority.High.Value,
            Enum.KeyCode.ButtonSelect,
            Enum.KeyCode.ButtonStart
        )
    
        local preferred = UserInputService.PreferredInput
        if preferred == Enum.PreferredInput.Gamepad and self._buttonArea then
            pcall(function()
                GuiService:Select(self._buttonArea)
            end)
        end
    end
    
    function Window:close()
        if not self._open or self._destroyed then
            return
        end
        self._open = false
    
        ContextActionService:UnbindAction(self._sinkName)
        self:_stopTweens()
    
        local cfg = self._config
        local gui = self._gui
        local scale = self._scale
        local overlay = self._overlay
    
        if cfg.Animation == true then
            local finished = false
            local function onDone()
                if finished then return end
                finished = true
                self:destroy()
            end
            local played = false
            if scale then
                local t = self:_play(scale, { Scale = 0 })
                t.Completed:Connect(onDone)
                played = true
            end
            if overlay then
                local t = self:_play(overlay, { BackgroundTransparency = 1 })
                if not played then
                    t.Completed:Connect(onDone)
                end
                played = true
            end
            if not played then
                onDone()
            end
        else
            if scale then
                scale.Scale = 0
            end
            if overlay then
                overlay.BackgroundTransparency = 1
            end
            if gui then
                gui.Enabled = false
            end
            self:destroy()
        end
    end
    
    function Window:destroy()
        if self._destroyed then
            return
        end
        self._destroyed = true
        self._open = false
    
        ContextActionService:UnbindAction(self._sinkName)
    
        for _, tween in ipairs(self._glowTweens) do
            tween:Cancel()
            tween:Destroy()
        end
        self._glowTweens = {}
    
        for _, tween in ipairs(self._tweens) do
            tween:Cancel()
            tween:Destroy()
        end
        self._tweens = {}
    
        for _, entry in ipairs(self._buttons) do
            for _, connection in ipairs(entry.connections) do
                connection:Disconnect()
            end
        end
        self._buttons = {}
    
        for _, connection in ipairs(self._connections) do
            connection:Disconnect()
        end
        self._connections = {}
    
        if self._gui then
            self._gui:Destroy()
            self._gui = nil
        end
    end
    
    local Manager = {}
    Manager.__index = Manager
    
    function Manager.new()
        return setmetatable({ windows = {} }, Manager)
    end
    
    function Manager:show(data)
        data = data or {}
        local window = Window.new(data)
        window:setTitle(data.Title)
        if window._title then
            window._title.TextSize = data.TitleTextSize or 25
        end
        if window._message then
            window._message.TextSize = data.MessageTextSize or data.DescTextSize or 20
        end
        window:setMessage(data.Message or data.Desc or data.Description)
        window:setIcon(data.Icon, data.IconOrder, data.IconSize, data.IconColor)
        window:setButtons(data.Buttons)
    
        table.insert(self.windows, window)
    
        local manager = self
        local connection
        connection = window._gui.Destroying:Connect(function()
            connection:Disconnect()
            for i, w in ipairs(manager.windows) do
                if w == window then
                    table.remove(manager.windows, i)
                    break
                end
            end
        end)
    
        window:show()
        return window
    end
    
    function Manager:setButtonCornerRadius(radius)
        for _, window in ipairs(self.windows) do
            window:setButtonCornerRadius(radius)
        end
    end
    
    function Manager:setCornerRadius(promptRadius, buttonRadius)
        for _, window in ipairs(self.windows) do
            window:setCornerRadius(promptRadius, buttonRadius)
        end
    end
    
    function Manager:closeAll()
        for _, window in ipairs(self.windows) do
            window:close()
        end
    end
    
    function Manager:destroyAll()
        for _, window in ipairs(self.windows) do
            window:destroy()
        end
        self.windows = {}
    end
    
    if getgenv().ErrorPrompt and getgenv().ErrorPrompt.destroyAll then
        pcall(function()
            getgenv().ErrorPrompt:destroyAll()
        end)
    end
    
    local manager = Manager.new()
    
    getgenv().ErrorPrompt = manager
    
    getgenv().ShowErrorPrompt = function(data)
        return manager:show(data)
    end
end
