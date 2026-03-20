-- Moon UI Library
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local LP               = Players.LocalPlayer

local T = {
    Bg      = Color3.fromRGB(12, 12, 14),
    Surface = Color3.fromRGB(20, 20, 24),
    SurfHov = Color3.fromRGB(30, 30, 36),
    Border  = Color3.fromRGB(45, 45, 55),
    Accent  = Color3.fromRGB(255, 255, 255),
    Text    = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 130),
    TogOn   = Color3.fromRGB(255, 255, 255),
    TogOff  = Color3.fromRGB(50, 50, 60),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 180, 60),
    Danger  = Color3.fromRGB(255, 80, 80),
}

local function N(cls, p)
    local o = Instance.new(cls)
    for k, v in pairs(p) do
        if k ~= "Par" then
            pcall(function() o[k] = v end)
        end
    end
    if p.Par then o.Parent = p.Par end
    return o
end

local function Crn(r)
    return N("UICorner", { CornerRadius = UDim.new(0, r), Par = nil })
end

local function getGui()
    local name = "MoonUIv2"
    -- clean up old instances
    pcall(function()
        local cg = game:GetService("CoreGui")
        local old = cg:FindFirstChild(name)
        if old then old:Destroy() end
    end)
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            local old = pg:FindFirstChild(name)
            if old then old:Destroy() end
        end
    end)
    if gethui then
        pcall(function()
            local old = gethui():FindFirstChild(name)
            if old then old:Destroy() end
        end)
    end

    local sg = Instance.new("ScreenGui")
    sg.Name          = name
    sg.ResetOnSpawn  = false
    sg.DisplayOrder  = 999
    pcall(function() sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    pcall(function() sg.IgnoreGuiInset = true end)

    if gethui then
        sg.Parent = gethui()
    else
        local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not ok then
            local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
            if pg then sg.Parent = pg end
        end
    end
    return sg
end

-- Simple drag: attach to any Frame, moves target
-- Touch: locks to the first finger only, ignores additional fingers
local function makeDraggable(handle, target, blockList)
    local dragging    = false
    local startMouse  = Vector2.zero
    local startPos    = Vector2.zero
    local touchId     = nil  -- KeyCode of the locked finger

    handle.InputBegan:Connect(function(i)
        -- Mouse: only left button; Touch: only if no finger locked yet
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            -- blocklist check
            if blockList then
                local mp = UserInputService:GetMouseLocation()
                for _, b in ipairs(blockList) do
                    local ap, as = b.AbsolutePosition, b.AbsoluteSize
                    if mp.X >= ap.X and mp.X <= ap.X + as.X
                    and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y then return end
                end
            end
            dragging  = true
            touchId   = nil
            startMouse = UserInputService:GetMouseLocation()
        elseif i.UserInputType == Enum.UserInputType.Touch and touchId == nil then
            -- lock to this finger only
            if blockList then
                local mp = Vector2.new(i.Position.X, i.Position.Y)
                for _, b in ipairs(blockList) do
                    local ap, as = b.AbsolutePosition, b.AbsoluteSize
                    if mp.X >= ap.X and mp.X <= ap.X + as.X
                    and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y then return end
                end
            end
            dragging  = true
            touchId   = i.KeyCode  -- unique per finger
            startMouse = Vector2.new(i.Position.X, i.Position.Y)
        else
            return
        end
        local parentAbs = target.Parent and target.Parent.AbsolutePosition or Vector2.zero
        local abs = target.AbsolutePosition
        startPos = Vector2.new(abs.X - parentAbs.X, abs.Y - parentAbs.Y)
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        elseif i.UserInputType == Enum.UserInputType.Touch and i.KeyCode == touchId then
            dragging = false
            touchId  = nil
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        local m
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            m = UserInputService:GetMouseLocation()
        elseif i.UserInputType == Enum.UserInputType.Touch and i.KeyCode == touchId then
            m = Vector2.new(i.Position.X, i.Position.Y)
        else
            return  -- ignore other fingers
        end
        local d = m - startMouse
        target.Position = UDim2.fromOffset(startPos.X + d.X, startPos.Y + d.Y)
    end)
end

-- Quick-press: only fire callback if button released within 0.3s of press
local function quickPress(btn, cb)
    local pressTime = 0
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            pressTime = tick()
        end
    end)
    btn.MouseButton1Up:Connect(function()
        if tick() - pressTime <= 0.3 then cb() end
    end)
end

local Moon = {}

function Moon:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Moon"
    local W, H  = 300, 280
    local gui   = getGui()

    -- ── Root ─────────────────────────────────────────────────────────────────
    local Root = N("Frame", {
        Size             = UDim2.fromOffset(W, H),
        Position         = UDim2.new(0.5, -W/2, 0.5, -H/2),
        BackgroundColor3 = T.Bg,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        Par              = gui,
    })
    Crn(10).Parent = Root

    -- ── Header (drag zone) ───────────────────────────────────────────────────
    local Header = N("Frame", {
        Size             = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        Par              = Root,
    })
    Crn(10).Parent = Header
    -- fill bottom corners of header
    N("Frame", {
        Size             = UDim2.new(1, 0, 0, 10),
        Position         = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        Par              = Header,
    })

    N("TextLabel", {
        Size                 = UDim2.new(1, -80, 1, 0),
        Position             = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1,
        Text                 = title,
        TextColor3           = T.Text,
        TextSize             = 14,
        Font                 = Enum.Font.GothamBold,
        TextXAlignment       = Enum.TextXAlignment.Left,
        Par                  = Header,
    })

    -- Minimize button
    local MinBtn = N("TextButton", {
        Size                 = UDim2.fromOffset(28, 28),
        Position             = UDim2.new(1, -62, 0.5, -14),
        BackgroundTransparency = 1,
        Text                 = "–",
        TextColor3           = T.TextDim,
        TextSize             = 18,
        Font                 = Enum.Font.GothamBold,
        Par                  = Header,
    })

    -- Close button
    local CloseBtn = N("TextButton", {
        Size                 = UDim2.fromOffset(28, 28),
        Position             = UDim2.new(1, -32, 0.5, -14),
        BackgroundTransparency = 1,
        Text                 = "X",
        TextColor3           = T.TextDim,
        TextSize             = 13,
        Font                 = Enum.Font.GothamBold,
        Par                  = Header,
    })

    -- Tab bar
    local TabBar = N("Frame", {
        Size             = UDim2.new(1, 0, 0, 28),
        Position         = UDim2.fromOffset(0, 38),
        BackgroundColor3 = T.Surface,
        BorderSizePixel  = 0,
        Par              = Root,
    })
    N("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.Border,
        BorderSizePixel  = 0,
        Par              = TabBar,
    })
    local TabHolder = N("Frame", {
        Size             = UDim2.new(1, -12, 1, 0),
        Position         = UDim2.fromOffset(6, 0),
        BackgroundTransparency = 1,
        Par              = TabBar,
    })
    N("UIListLayout", {
        Padding           = UDim.new(0, 2),
        SortOrder         = Enum.SortOrder.LayoutOrder,
        FillDirection     = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Par               = TabHolder,
    })

    -- Content
    local ContentArea = N("Frame", {
        Size             = UDim2.new(1, 0, 1, -66),
        Position         = UDim2.fromOffset(0, 66),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Par              = Root,
    })

    -- Reopen button (shown when closed)
    local ReopenBtn = N("TextButton", {
        Size                 = UDim2.fromOffset(70, 26),
        Position             = UDim2.new(0.5, -35, 0, 8),
        BackgroundColor3     = T.Surface,
        BackgroundTransparency = 0.3,
        Text                 = "Moon",
        TextColor3           = T.Text,
        TextSize             = 12,
        Font                 = Enum.Font.GothamBold,
        ZIndex               = 100,
        Visible              = false,
        Par                  = gui,
    })
    Crn(13).Parent = ReopenBtn

    -- ── Wire drag: use an invisible TextButton as drag handle ──────────────
    -- Frames don't reliably fire InputBegan in executors without Active=true.
    -- A TextButton always receives input. ZIndex 1 means MinBtn/CloseBtn (higher)
    -- still get their clicks first.
    local DragHandle = N("TextButton", {
        Size                 = UDim2.new(1, -70, 1, 0),
        BackgroundTransparency = 1,
        Text                 = "",
        ZIndex               = 1,
        Par                  = Header,
    })
    makeDraggable(DragHandle, Root, nil)
    -- ReopenBtn drags itself
    makeDraggable(ReopenBtn, ReopenBtn)

    -- ── Minimize ─────────────────────────────────────────────────────────────
    local minimized = false
    local function doMinimize()
        minimized = not minimized
        TabBar.Visible      = not minimized
        ContentArea.Visible = not minimized
        Root.Size = UDim2.fromOffset(W, minimized and 38 or H)
    end
    quickPress(MinBtn, doMinimize)

    -- ── Close ─────────────────────────────────────────────────────────────────
    local function doClose()
        Root.Visible      = false
        ReopenBtn.Visible = true
    end
    quickPress(CloseBtn, doClose)

    -- ── Reopen ────────────────────────────────────────────────────────────────
    local function doReopen()
        minimized           = false
        TabBar.Visible      = true
        ContentArea.Visible = true
        Root.Size           = UDim2.fromOffset(W, H)
        Root.Visible        = true
        ReopenBtn.Visible   = false
    end
    quickPress(ReopenBtn, doReopen)

    -- ── Window object ─────────────────────────────────────────────────────────
    local Win     = {}
    local tabs    = {}
    local activeTab = nil

    function Win:Notify(nc)
        nc = nc or {}
        local cols = { info=T.Accent, success=T.Success, warning=T.Warning, error=T.Danger }
        local col  = cols[nc.Type or "info"] or T.Accent
        local t = N("Frame", {
            Size             = UDim2.fromOffset(260, 60),
            Position         = UDim2.new(1, 10, 1, -70),
            BackgroundColor3 = T.Surface,
            ZIndex           = 200,
            Par              = gui,
        })
        Crn(8).Parent = t
        N("Frame", { Size=UDim2.new(0,3,0.6,0), Position=UDim2.new(0,0,0.2,0), BackgroundColor3=col, BorderSizePixel=0, ZIndex=201, Par=t })
        N("TextLabel", { Size=UDim2.new(1,-18,0,18), Position=UDim2.fromOffset(14,8), BackgroundTransparency=1, Text=nc.Title or "", TextColor3=col, TextSize=12, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201, Par=t })
        N("TextLabel", { Size=UDim2.new(1,-18,0,14), Position=UDim2.fromOffset(14,28), BackgroundTransparency=1, Text=nc.Message or "", TextColor3=T.TextDim, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201, Par=t })
        TweenService:Create(t, TweenInfo.new(0.25, Enum.EasingStyle.Quart), { Position=UDim2.new(1,-270,1,-70) }):Play()
        task.delay(nc.Duration or 4, function()
            if t and t.Parent then
                TweenService:Create(t, TweenInfo.new(0.2, Enum.EasingStyle.Quart), { Position=UDim2.new(1,10,1,-70) }):Play()
                task.delay(0.22, function() if t and t.Parent then t:Destroy() end end)
            end
        end)
    end

    function Win:CreateTab(name)
        local scroll = N("ScrollingFrame", {
            Size                 = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel      = 0,
            ScrollBarThickness   = 3,
            ScrollBarImageColor3 = T.Border,
            ScrollingDirection   = Enum.ScrollingDirection.Y,
            CanvasSize           = UDim2.fromOffset(0, 0),
            Visible              = false,
            Par                  = ContentArea,
        })
        N("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,8), PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Par=scroll })
        local layout = N("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder, FillDirection=Enum.FillDirection.Vertical, HorizontalAlignment=Enum.HorizontalAlignment.Center, Par=scroll })
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
        end)

        local tabBtn = N("TextButton", {
            Size                 = UDim2.fromOffset(0, 22),
            AutomaticSize        = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Text                 = name,
            TextColor3           = T.TextDim,
            TextSize             = 11,
            Font                 = Enum.Font.GothamSemibold,
            Par                  = TabHolder,
        })
        N("UIPadding", { PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), Par=tabBtn })
        Crn(5).Parent = tabBtn

        local function activate()
            for _, td in ipairs(tabs) do
                td.s.Visible = false
                td.b.TextColor3 = T.TextDim
                td.b.BackgroundTransparency = 1
            end
            scroll.Visible = true
            tabBtn.TextColor3 = T.Text
            tabBtn.BackgroundTransparency = 0.85
            activeTab = name
        end
        quickPress(tabBtn, activate)
        tabBtn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.Touch then activate() end
        end)
        table.insert(tabs, { b=tabBtn, s=scroll })
        if #tabs == 1 then activate() end

        local Tab = {}

        function Tab:Hide()
            tabBtn.Visible  = false
            scroll.Visible  = false
        end
        function Tab:Show()
            tabBtn.Visible = true
        end
        function Tab:Activate()
            activate()
        end

        function Tab:CreateSection(label)
            local f = N("Frame", { Size=UDim2.new(1,0,0,18), BackgroundTransparency=1, Par=scroll })
            N("TextLabel", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text=label:upper(), TextColor3=T.TextDim, TextSize=10, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
        end

        function Tab:CreateButton(bc)
            bc = bc or {}
            local h = bc.Description and 46 or 32
            local baseColor = bc._color or T.Surface
            local f = N("Frame", { Size=UDim2.new(1,0,0,h), BackgroundColor3=baseColor, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(1,-16,0,16), Position=UDim2.fromOffset(10, bc.Description and 6 or 8), BackgroundTransparency=1, Text=bc.Name or "Button", TextColor3=bc._color and Color3.new(1,1,1) or T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            if bc.Description then
                N("TextLabel", { Size=UDim2.new(1,-16,0,12), Position=UDim2.fromOffset(10,23), BackgroundTransparency=1, Text=bc.Description, TextColor3=bc._color and Color3.fromRGB(220,220,220) or T.TextDim, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            end
            local btn = N("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Par=f })
            btn.MouseEnter:Connect(function() if not bc._color then f.BackgroundColor3 = T.SurfHov end end)
            btn.MouseLeave:Connect(function() f.BackgroundColor3 = bc._color or T.Surface end)
            quickPress(btn, function() if bc.Callback then bc.Callback() end end)
            btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch and bc.Callback then bc.Callback() end end)
        end

        function Tab:CreateToggle(tc)
            tc = tc or {}
            local state = tc.Default == true
            local h = tc.Description and 46 or 32
            local f = N("Frame", { Size=UDim2.new(1,0,0,h), BackgroundColor3=T.Surface, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(1,-52,0,16), Position=UDim2.fromOffset(10, tc.Description and 6 or 8), BackgroundTransparency=1, Text=tc.Name or "Toggle", TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            if tc.Description then
                N("TextLabel", { Size=UDim2.new(1,-52,0,12), Position=UDim2.fromOffset(10,23), BackgroundTransparency=1, Text=tc.Description, TextColor3=T.TextDim, TextSize=10, Font=Enum.Font.Gotham, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            end
            local track = N("Frame", { Size=UDim2.fromOffset(34,17), Position=UDim2.new(1,-42,0.5,-8), BackgroundColor3=state and T.TogOn or T.TogOff, Par=f })
            Crn(9).Parent = track
            local knob = N("Frame", { Size=UDim2.fromOffset(12,12), Position=state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6), BackgroundColor3=Color3.fromRGB(20,20,24), Par=track })
            Crn(6).Parent = knob
            local btn = N("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", Par=f })
            local obj = {}
            local function set(s)
                state = s
                track.BackgroundColor3 = s and T.TogOn or T.TogOff
                knob.Position = s and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)
            end
            local function toggle()
                set(not state)
                if tc.Callback then tc.Callback(state) end
            end
            quickPress(btn, toggle)
            function obj:SetState(s) set(s) end
            function obj:GetState() return state end
            return obj
        end

        function Tab:CreateSlider(sc)
            sc = sc or {}
            local mn, mx = sc.Min or 0, sc.Max or 100
            local val = math.clamp(sc.Default or mn, mn, mx)
            local suf = sc.Suffix or ""
            local f = N("Frame", { Size=UDim2.new(1,0,0,46), BackgroundColor3=T.Surface, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(1,-55,0,16), Position=UDim2.fromOffset(10,5), BackgroundTransparency=1, Text=sc.Name or "Slider", TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            local vl = N("TextLabel", { Size=UDim2.fromOffset(44,16), Position=UDim2.new(1,-50,0,5), BackgroundTransparency=1, Text=tostring(val)..suf, TextColor3=T.TextDim, TextSize=11, Font=Enum.Font.GothamBold, TextXAlignment=Enum.TextXAlignment.Right, Par=f })
            local track = N("Frame", { Size=UDim2.new(1,-20,0,4), Position=UDim2.fromOffset(10,30), BackgroundColor3=T.Border, Par=f })
            Crn(2).Parent = track
            local pct = (val-mn)/math.max(mx-mn,1)
            local fill = N("Frame", { Size=UDim2.new(pct,0,1,0), BackgroundColor3=T.Accent, Par=track })
            Crn(2).Parent = fill
            local thumb = N("Frame", { Size=UDim2.fromOffset(12,12), Position=UDim2.new(pct,-6,0.5,-6), BackgroundColor3=T.Text, ZIndex=2, Par=track })
            Crn(6).Parent = thumb
            local hit = N("TextButton", { Size=UDim2.new(1,0,0,24), Position=UDim2.new(0,0,0.5,-12), BackgroundTransparency=1, Text="", ZIndex=3, Par=track })
            local sd = false
            local function upd(x)
                local r = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X,1), 0, 1)
                local nv = math.floor(mn + r*(mx-mn) + 0.5)
                if nv == val then return end
                val = nv; vl.Text = tostring(nv)..suf
                fill.Size = UDim2.new(r,0,1,0); thumb.Position = UDim2.new(r,-6,0.5,-6)
                if sc.Callback then sc.Callback(nv) end
            end
            hit.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    sd=true; upd(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not sd then return end
                if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then upd(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=false end
            end)
        end

        function Tab:CreateDropdown(dc)
            dc = dc or {}
            local opts = dc.Options or {}
            local sel = dc.Default or (opts[1] or "None")
            local open = false
            local f = N("Frame", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Surface, ClipsDescendants=false, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(0.55,0,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=dc.Name or "Dropdown", TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            local sb = N("TextButton", { Size=UDim2.fromOffset(108,22), Position=UDim2.new(1,-114,0.5,-11), BackgroundColor3=T.Bg, Text=sel.." -", TextColor3=T.TextDim, TextSize=10, Font=Enum.Font.GothamSemibold, ZIndex=20, Par=f })
            Crn(5).Parent = sb
            -- parent df to Root so it isn't clipped by ScrollingFrame
            local df = N("Frame", { Size=UDim2.fromOffset(108,0), BackgroundColor3=T.Bg, ClipsDescendants=true, ZIndex=50, Visible=false, Par=Root })
            Crn(5).Parent = df
            N("UIListLayout", { SortOrder=Enum.SortOrder.LayoutOrder, Par=df })
            for _,opt in ipairs(opts) do
                local item = N("TextButton", { Size=UDim2.new(1,0,0,24), BackgroundTransparency=1, Text=opt, TextColor3=opt==sel and T.Text or T.TextDim, TextSize=10, Font=Enum.Font.Gotham, ZIndex=51, Par=df })
                N("UIPadding", { PaddingLeft=UDim.new(0,8), Par=item })
                local function pick()
                    sel=opt; sb.Text=opt.." -"; open=false
                    TweenService:Create(df,TweenInfo.new(0.1),{Size=UDim2.fromOffset(108,0)}):Play()
                    task.delay(0.11,function() df.Visible=false end)
                    if dc.Callback then dc.Callback(opt) end
                end
                quickPress(item, pick)
                item.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then pick() end end)
            end
            local function tog()
                open = not open
                if open then
                    -- position df just below the sb button in screen space
                    local absPos = sb.AbsolutePosition
                    local absSize = sb.AbsoluteSize
                    df.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 2)
                    df.Size = UDim2.fromOffset(108, 0)
                    df.Visible = true
                    TweenService:Create(df,TweenInfo.new(0.1),{Size=UDim2.fromOffset(108,#opts*24)}):Play()
                else
                    TweenService:Create(df,TweenInfo.new(0.1),{Size=UDim2.fromOffset(108,0)}):Play()
                    task.delay(0.11,function() df.Visible=false end)
                end
            end
            quickPress(sb, tog)
            sb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then tog() end end)
        end

        function Tab:CreateInput(ic)
            ic = ic or {}
            local f = N("Frame", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Surface, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(0.5,0,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=ic.Name or "Input", TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            local box = N("TextBox", { Size=UDim2.fromOffset(108,22), Position=UDim2.new(1,-114,0.5,-11), BackgroundColor3=T.Bg, Text=ic.Default or "", PlaceholderText=ic.Placeholder or "...", PlaceholderColor3=T.TextDim, TextColor3=T.Text, TextSize=10, Font=Enum.Font.Gotham, ClearTextOnFocus=true, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            Crn(5).Parent = box
            N("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), Par=box })
            local function fireCallback() if ic.Callback then ic.Callback(box.Text) end end
            box.FocusLost:Connect(fireCallback)
            box.Changed:Connect(function(prop) if prop == "Text" then ic._lastText = box.Text end end)
        end

        function Tab:CreateKeybind(kc)
            kc = kc or {}
            local key = kc.Default or Enum.KeyCode.F
            local waiting = false
            local f = N("Frame", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.Surface, Par=scroll })
            Crn(6).Parent = f
            N("TextLabel", { Size=UDim2.new(0.6,0,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=kc.Name or "Keybind", TextColor3=T.Text, TextSize=12, Font=Enum.Font.GothamSemibold, TextXAlignment=Enum.TextXAlignment.Left, Par=f })
            local kb = N("TextButton", { Size=UDim2.fromOffset(76,22), Position=UDim2.new(1,-82,0.5,-11), BackgroundColor3=T.Bg, Text="["..key.Name.."]", TextColor3=T.TextDim, TextSize=10, Font=Enum.Font.GothamBold, Par=f })
            Crn(5).Parent = kb
            quickPress(kb, function() waiting=true; kb.Text="[...]" end)
            UserInputService.InputBegan:Connect(function(i, gp)
                if gp then return end
                if waiting and i.UserInputType==Enum.UserInputType.Keyboard then
                    waiting=false; key=i.KeyCode; kb.Text="["..key.Name.."]"
                elseif not waiting and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==key then
                    if kc.Callback then kc.Callback() end
                end
            end)
        end

        return Tab
    end

    return Win
end

-- ══════════════════════════════════════════════════════════════════
--  Minesweeper Auto Solver — Moon UI
--  Game: bLockerman's Minesweeper
--  Green highlight = safe tile   |   Red highlight = mine
-- ══════════════════════════════════════════════════════════════════

local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local lp           = Players.LocalPlayer

local abs, floor, huge, sqrt, max, min, clock = math.abs, math.floor, math.huge, math.sqrt, math.max, math.min, os.clock
local tsort, tinsert, tremove = table.sort, table.insert, table.remove
local bit_extract  = bit32.extract
local vec3, cfnew, inst = Vector3.new, CFrame.new, Instance.new

-- ── Highlight colours (non-neon, slightly transparent) ────────────
local COLOR_SAFE       = Color3.fromRGB(0,   140, 50)   -- dark green = safe
local COLOR_MINE       = Color3.fromRGB(220, 50,  50)   -- red = mine
local COLOR_GUESS      = Color3.fromRGB(40,  120, 220)  -- blue = best guess safe
local COLOR_GUESS_MINE = Color3.fromRGB(255, 140, 0)    -- orange = best guess mine
local TRANSPARENCY = 0.35

-- ── Solver state ──────────────────────────────────────────────────
local solverEnabled    = false
local autoGuessEnabled = false
local autoGuessMineEnabled = false
local autoGuessSafeEnabled = false
local teleportGuessEnabled = false

local state = {
    cells         = { grid = {}, numbered = {}, toFlag = {}, toClear = {} },
    grid          = { w = 0, h = 0 },
    lastPartCount = -1,
    dirtyFlag     = true,
    bestGuessCell = nil,
    bestGuessMineCell = nil,
    lastF         = {},
    lastS       = {},
}

-- ==============================================
-- ============= DEBUG FUNCTIONS ================
-- ==============================================

-- Debug print dengan timestamp
local function debugLog(...)
    local args = {...}
    local timestamp = os.date("%H:%M:%S")
    local msg = "[" .. timestamp .. "] " .. table.concat(args, " ")
    print(msg)
end

-- Enhanced scanB dengan debug
local cachedB = nil
local function scanB()
    -- Clear cache jika perlu
    if cachedB and (not cachedB.Parent or #cachedB:GetChildren() == 0) then
        debugLog("Cache expired, clearing...")
        cachedB = nil
        state.lastPartCount = -1
    end
    
    if cachedB and cachedB.Parent then 
        debugLog("Using cachedB:", cachedB:GetFullName())
        return cachedB 
    end
    
    debugLog("Scanning for board folder...")
    
    -- Strategy 1: Cari di struktur Flag/Parts
    local flag = workspace:FindFirstChild("Flag")
    if flag then
        debugLog("Found Flag folder")
        local parts = flag:FindFirstChild("Parts")
        if parts then
            debugLog("Found Parts folder with", #parts:GetChildren(), "children")
            cachedB = parts
            return parts
        end
    end
    
    -- Strategy 2: Cari folder dengan banyak BasePart
    debugLog("Scanning workspace for potential board...")
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Folder") then
            local count = #child:GetChildren()
            if count > 30 then  -- Board biasanya punya banyak parts
                debugLog(string.format("Found folder '%s' with %d children", child.Name, count))
                
                -- Cek apakah isinya BasePart
                if count > 0 then
                    local first = child:GetChildren()[1]
                    if first and first:IsA("BasePart") then
                        debugLog("SUCCESS: Found board folder:", child:GetFullName())
                        cachedB = child
                        return child
                    end
                end
            end
        end
    end
    
    -- Strategy 3: Cari berdasarkan nama umum
    local commonNames = {"Board", "Tiles", "Grid", "Mines", "Parts", "Tileset"}
    for _, name in ipairs(commonNames) do
        local obj = workspace:FindFirstChild(name)
        if obj and obj:IsA("Folder") and #obj:GetChildren() > 0 then
            debugLog("Found by name:", name, "with", #obj:GetChildren(), "children")
            cachedB = obj
            return obj
        end
    end
    
    debugLog("WARNING: No board folder found!")
    return nil
end

-- Grid helpers
local function cluster(vals, d)
    local res = {}
    if #vals == 0 then return res end
    local cur, count = vals[1], 1
    for i = 2, #vals do
        if abs(vals[i] - cur) <= d then
            count = count + 1
            cur   = cur + (vals[i] - cur) / count
        else
            tinsert(res, cur)
            cur, count = vals[i], 1
        end
    end
    tinsert(res, cur)
    return res
end

local function median(vals)
    if #vals == 0 then return nil end
    tsort(vals)
    return vals[floor((#vals + 1) / 2)]
end

local function estS(coords)
    if #coords < 3 then return 4 end
    local d = {}
    for i = 2, #coords do d[#d+1] = abs(coords[i] - coords[i-1]) end
    return median(d) or 4
end

local function findI(t, s)
    local bI, bD = 1, huge
    for i = 1, #s do
        local d = abs(t - s[i])
        if d < bD then bD, bI = d, i end
    end
    return bI - 1
end

local function hasF(p)
    return p:FindFirstChildOfClass("Model") ~= nil
end

-- ── Highlight system ─────────────────────────────
local hlFolder = nil
local function getHLFolder()
    if hlFolder and hlFolder.Parent then return hlFolder end
    hlFolder = workspace:FindFirstChild("MoonMineHL") or inst("Folder")
    hlFolder.Name   = "MoonMineHL"
    hlFolder.Parent = workspace
    return hlFolder
end

local function clearAllHL()
    local f = workspace:FindFirstChild("MoonMineHL")
    if f then f:Destroy() end
    hlFolder = nil
    if not state.cells.grid then return end
    for x = 0, (state.grid.w or 0) - 1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, (state.grid.h or 0) - 1 do
                local c = col[z]
                if c then
                    c.hlPart = nil
                    c.isHL   = false
                end
            end
        end
    end
    state.cells.toFlag  = {}
    state.cells.toClear = {}
    state.lastF         = {}
    state.lastS         = {}
end

local function applyHL(c, col)
    if not c.part then return end
    -- Create a flat slab sitting just on top of the tile
    if not c.hlPart then
        local hl = inst("Part")
        hl.Anchored       = true
        hl.CanCollide     = false
        hl.CanQuery       = false
        hl.CanTouch       = false
        hl.CastShadow     = false
        hl.Material       = Enum.Material.SmoothPlastic  -- no neon
        local sz          = c.part.Size
        hl.Size           = vec3(sz.X - 0.1, 0.08, sz.Z - 0.1)
        hl.CFrame         = c.part.CFrame * cfnew(0, sz.Y / 2 + 0.05, 0)
        hl.Parent         = getHLFolder()
        c.hlPart          = hl
    end
    c.hlPart.Color        = col
    c.hlPart.Transparency = TRANSPARENCY
    c.isHL                = true
end

local function hideHL(c)
    if c.hlPart then
        c.hlPart:Destroy()
        c.hlPart = nil
    end
    c.isHL = false
end

-- ── Grid rebuild ──────────────────────────────────
local function rebuildG(folder)
    debugLog("=== REBUILDING GRID ===")
    clearAllHL()
    state.cells.grid  = {}
    state.grid.w      = 0
    state.grid.h      = 0
    local pts         = folder:GetChildren()
    debugLog("Total parts in folder:", #pts)
    
    if #pts == 0 then 
        debugLog("No parts found!")
        return 
    end

    local pD, sY = {}, 0
    for _, p in ipairs(pts) do
        if p:IsA("BasePart") then
            tinsert(pD, { p = p, pos = p.Position })
            sY = sY + p.Position.Y
        end
    end
    
    debugLog("Valid BaseParts found:", #pD)

    local xs, zs = {}, {}
    for i = 1, #pD do xs[i], zs[i] = pD[i].pos.X, pD[i].pos.Z end
    tsort(xs); tsort(zs)

    local w, h = estS(xs) * 0.6, estS(zs) * 0.6
    debugLog("Estimated spacing - X:", w, "Z:", h)
    
    local ux, uz = cluster(xs, w), cluster(zs, h)
    state.grid.w, state.grid.h = #ux, #uz
    
    debugLog("Grid dimensions:", state.grid.w, "x", state.grid.h)

    if state.grid.w == 0 or state.grid.h == 0 then 
        debugLog("Grid dimensions invalid!")
        return 
    end

    local ay = sY / #pD
    for x = 0, state.grid.w - 1 do
        state.cells.grid[x] = {}
        for z = 0, state.grid.h - 1 do
            state.cells.grid[x][z] = {
                ix = x, iz = z,
                pos = vec3(ux[x+1], ay, uz[z+1]),
                part = nil, state = "unknown",
                covered = true, neigh = {},
                hlPart = nil, isHL = false,
            }
        end
    end

    local matched = 0
    for _, d in ipairs(pD) do
        local xi, zi = findI(d.pos.X, ux), findI(d.pos.Z, uz)
        if xi >= 0 and xi < state.grid.w and zi >= 0 and zi < state.grid.h then
            local c = state.cells.grid[xi][zi]
            if not c.part or (d.pos - vec3(ux[xi+1], d.pos.Y, uz[zi+1])).Magnitude
                < (c.part.Position - vec3(ux[xi+1], c.part.Position.Y, uz[zi+1])).Magnitude then
                c.part, c.pos = d.p, d.pos
                matched = matched + 1
            end
        end
    end
    debugLog("Parts matched to grid:", matched, "/", #pD)

    -- Build neighbors
    for z = 0, state.grid.h - 1 do
        for x = 0, state.grid.w - 1 do
            local c = state.cells.grid[x][z]
            for dz = -1, 1 do
                for dx = -1, 1 do
                    if dx ~= 0 or dz ~= 0 then
                        local nx, nz = x + dx, z + dz
                        if nx >= 0 and nx < state.grid.w and nz >= 0 and nz < state.grid.h then
                            tinsert(c.neigh, state.cells.grid[nx][nz])
                        end
                    end
                end
            end
        end
    end
    
    debugLog("=== GRID REBUILD COMPLETE ===")
end

-- ── State update ───────────────────────────────
local function updateS()
    state.cells.numbered = {}
    local grid = state.cells.grid
    if state.grid.w == 0 or not grid then 
        debugLog("updateS: Grid not ready")
        return 
    end

    local numberedCount = 0
    for x = 0, state.grid.w - 1 do
        local col = grid[x]
        if col then
            for z = 0, state.grid.h - 1 do
                local c = col[z]
                if c.part then
                    if c.state == "number" then
                        tinsert(state.cells.numbered, c)
                        numberedCount = numberedCount + 1
                    else
                        c.state, c.number, c.covered = "unknown", nil, true
                        local ng = c._ng or c.part:FindFirstChild("NumberGui")
                        if ng then
                            c._ng = ng
                            local lbl = c._tl or ng:FindFirstChild("TextLabel")
                            if lbl then
                                c._tl = lbl
                                local t = lbl.Text
                                if t ~= "" then
                                    local n = tonumber(t)
                                    if n then
                                        c.number, c.covered, c.state = n, false, "number"
                                        tinsert(state.cells.numbered, c)
                                        numberedCount = numberedCount + 1
                                    end
                                end
                            end
                        end
                        if c.state ~= "number" then
                            if c.covered then
                                -- A tile is revealed if its NumberGui TextLabel exists
                                -- but is empty (blank revealed tile, no number)
                                local ng = c._ng or c.part:FindFirstChild("NumberGui")
                                if ng then
                                    c._ng = ng
                                    local lbl = ng:FindFirstChildWhichIsA("TextLabel")
                                    -- empty text = revealed blank tile (treat as number:0)
                                    if lbl and lbl.Text == "" then
                                        c.covered = false
                                        c.number  = 0
                                        c.state   = "number"
                                        tinsert(state.cells.numbered, c)
                                        numberedCount = numberedCount + 1
                                    end
                                end
                            end
                            if c.covered and hasF(c.part) then
                                c.state = "flagged"
                            end
                        end
                    end
                end
            end
        end
    end
    debugLog("updateS: Numbered cells found:", numberedCount)
end

-- ── Logic helpers ─────────────────────────────────
local function countR(c, fS)
    local r = c.number or 0
    for _, n in ipairs(c.neigh) do if fS[n] then r = r - 1 end end
    return r
end

local function getC(num, fS, sS)
    local bds, map = {}, {}
    for j = 1, #num do
        local nc = num[j]
        local ns, n = {}, nc.neigh
        for k = 1, #n do
            local t = n[k]
            if not fS[t] and t.state ~= "number" and t.covered ~= false and not sS[t] then
                tinsert(ns, t)
                if not map[t] then map[t] = true; tinsert(bds, t) end
            end
        end
        nc._cn = ns
    end

    local adj, vis, comps = {}, {}, {}
    for j = 1, #bds do adj[bds[j]] = {} end
    for j = 1, #num do
        local ns = num[j]._cn
        for i = 1, #ns do
            for k = i+1, #ns do
                local u, v = ns[i], ns[k]
                adj[u][v], adj[v][u] = true, true
            end
        end
    end
    for j = 1, #bds do
        local u = bds[j]
        if not vis[u] then
            local comp, q = {}, {u}
            vis[u] = true
            while #q > 0 do
                local cur = tremove(q)
                tinsert(comp, cur)
                for nb in pairs(adj[cur] or {}) do
                    if not vis[nb] then vis[nb] = true; tinsert(q, nb) end
                end
            end
            tinsert(comps, comp)
        end
    end
    return comps
end

local function solveCSP(fS, sS)
    local num, tS = state.cells.numbered, clock()
    for j = 1, #num do
        local nc = num[j]
        local r, n = nc.number or 0, nc.neigh
        for k = 1, #n do if fS[n[k]] then r = r - 1 end end
        nc._cr = r
    end

    local comps = getC(num, fS, sS)
    if #comps == 0 then return end

    local bgt = 0.02
    for i = 1, #comps do
        if clock() - tS > bgt then break end
        local v  = comps[i]
        local nV = #v
        if nV == 0 then continue end

        local deg = {}
        for j = 1, nV do deg[v[j]] = 0 end
        for j = 1, #num do
            for k = 1, #num[j]._cn do
                if deg[num[j]._cn[k]] then deg[num[j]._cn[k]] = deg[num[j]._cn[k]] + 1 end
            end
        end
        tsort(v, function(a, b) return deg[a] > deg[b] end)

        local map, cts, cCts = {}, {}, {}
        for j = 1, nV do map[v[j]], cCts[j] = j, {} end

        local cons = {}
        for j = 1, #num do
            local nc, cv = num[j], {}
            for k = 1, #nc._cn do
                local m = map[nc._cn[k]]
                if m then cv[#cv+1] = m end
            end
            if #cv > 0 then
                tsort(cv)
                cons[#cons+1] = { v = cv, r = nc._cr, cur = 0, un = #cv }
            end
        end

        local vT = {}
        for j = 1, nV do vT[j] = {} end
        for j = 1, #cons do
            for _, vi in ipairs(cons[j].v) do tinsert(vT[vi], cons[j]) end
        end

        local cur, solC, abrt = {}, 0, false
        local function bt(idx)
            if solC >= 50000 or abrt then return end
            if (solC % 512 == 0) and (clock() - tS > bgt) then abrt = true; return end
            if idx > nV then
                solC = solC + 1
                for j = 1, nV do
                    if cur[j] == 1 then cCts[j][1] = (cCts[j][1] or 0) + 1 end
                end
                return
            end
            local t = vT[idx]
            for val = 0, 1 do
                local ok = true
                for j = 1, #t do
                    local c  = t[j]
                    local ns = c.cur + val
                    if ns > c.r or (ns + c.un - 1) < c.r then ok = false; break end
                end
                if ok then
                    cur[idx] = val
                    for j = 1, #t do t[j].cur, t[j].un = t[j].cur + val, t[j].un - 1 end
                    bt(idx + 1)
                    if abrt then return end
                    for j = 1, #t do t[j].cur, t[j].un = t[j].cur - val, t[j].un + 1 end
                end
            end
        end

        if nV <= 14 then
            for m = 0, 2^nV - 1 do
                local ok = true
                for j = 1, #cons do
                    local sVal, cV = 0, cons[j].v
                    for k = 1, #cV do
                        if bit_extract(m, cV[k]-1) == 1 then sVal = sVal + 1 end
                    end
                    if sVal ~= cons[j].r then ok = false; break end
                end
                if ok then
                    solC = solC + 1
                    for j = 1, nV do
                        if bit_extract(m, j-1) == 1 then cCts[j][1] = (cCts[j][1] or 0) + 1 end
                    end
                end
            end
        else
            bt(1)
        end

        if solC > 0 then
            for vi = 1, #v do
                local mc = cCts[vi][1] or 0
                if mc == solC     then fS[v[vi]] = true end
                if mc == 0        then sS[v[vi]] = true end
                v[vi]._prob = mc / solC
            end
        end
    end
end

local function applyS(cA, cB, uA, uB, fS, sS)
    local sA, sB, iS = {}, {}, 0
    for _, u in ipairs(uA) do sA[u] = true end
    for _, u in ipairs(uB) do
        if sA[u] then iS = iS + 1; sA[u] = false; sB[u] = false
        else sB[u] = true end
    end
    local oA, oB, iL = {}, {}, {}
    for _, u in ipairs(uA) do
        if sA[u] ~= false then oA[#oA+1] = u else iL[#iL+1] = u end
    end
    for _, u in ipairs(uB) do if sB[u] then oB[#oB+1] = u end end
    if #iL == 0 then return end
    local rA, rB     = countR(cA, fS), countR(cB, fS)
    local minI, maxI = max(0, rA - #oA, rB - #oB), min(rA, rB, #iL)
    if minI == maxI then
        if rA - minI == 0      then for _, u in ipairs(oA) do sS[u] = true end
        elseif rA - minI == #oA then for _, u in ipairs(oA) do fS[u] = true end end
        if rB - minI == 0      then for _, u in ipairs(oB) do sS[u] = true end
        elseif rB - minI == #oB then for _, u in ipairs(oB) do fS[u] = true end end
        return true
    end
    return false
end

-- ── Main logic update ─────────────────────────────
local function updateL()
    if state.grid.w == 0 then
        state.cells.toFlag, state.cells.toClear = {}, {}
        return
    end
    local num = state.cells.numbered
    if #num == 0 then return end

    local fS, sS, ch, it, tS = {}, {}, true, 0, clock()
    for x = 0, state.grid.w-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, state.grid.h-1 do
                local c = col[z]
                if c then c._prob = nil end
            end
        end
    end

    while ch and it < 32 and (clock() - tS < 0.05) do
        ch, it = false, it + 1
        for j = 1, #num do
            local c         = num[j]
            local unk, flg, n = {}, 0, c.neigh
            for k = 1, #n do
                local t = n[k]
                if fS[t] then
                    flg = flg + 1
                elseif not sS[t] and t.state ~= "number" and t.covered ~= false then
                    tinsert(unk, t)
                end
            end
            local r = (c.number or 0) - flg
            if r > 0 and r == #unk then
                for k = 1, #unk do
                    if not fS[unk[k]] then fS[unk[k]], ch = true, true end
                end
            elseif r == 0 and #unk > 0 then
                for k = 1, #unk do
                    if not sS[unk[k]] then sS[unk[k]], ch = true, true end
                end
            end
        end

        if it % 2 == 0 then
            for i = 1, #num do
                local a  = num[i]
                local uA, n1 = {}, a.neigh
                for k = 1, #n1 do
                    local t = n1[k]
                    if not fS[t] and not sS[t] and t.state ~= "number" and t.covered ~= false then
                        uA[#uA+1] = t
                    end
                end
                if #uA > 0 then
                    local checked = {}
                    for k = 1, #n1 do
                        local nb = n1[k]
                        if nb.state == "number" and nb ~= a and not checked[nb] then
                            checked[nb] = true
                            local uB, n2 = {}, nb.neigh
                            for m = 1, #n2 do
                                local t = n2[m]
                                if not fS[t] and not sS[t] and t.state ~= "number" and t.covered ~= false then
                                    uB[#uB+1] = t
                                end
                            end
                            if #uB > 0 and applyS(a, nb, uA, uB, fS, sS) then ch = true end
                        end
                    end
                end
            end
        end

        if not ch then
            local oldF, oldS = 0, 0
            for _ in pairs(fS) do oldF = oldF + 1 end
            for _ in pairs(sS) do oldS = oldS + 1 end
            solveCSP(fS, sS)
            local newF, newS = 0, 0
            for _ in pairs(fS) do newF = newF + 1 end
            for _ in pairs(sS) do newS = newS + 1 end
            if newF ~= oldF or newS ~= oldS then ch = true end
        end
    end

    local changed = false
    for c in pairs(fS) do if not state.lastF[c] then changed = true; break end end
    if not changed then for c in pairs(state.lastF) do if not fS[c] then changed = true; break end end end
    if not changed then for c in pairs(sS) do if not state.lastS[c] then changed = true; break end end end
    if not changed then for c in pairs(state.lastS) do if not sS[c] then changed = true; break end end end

    if changed then
        debugLog("updateL: Found", #fS, "mines and", #sS, "safe cells")
        state.cells.toFlag  = fS
        state.cells.toClear = sS
        state.lastF         = fS
        state.lastS         = sS
        state.dirtyFlag     = true
    end
end

-- ── Pick best guess cell ────────────────────────
local function updateG()
    state.bestGuessCell = nil
    state.bestGuessMineCell = nil
    if state.grid.w == 0 then return end

    local W, H = state.grid.w, state.grid.h

    -- Step 1: count unknowns and flagged globally
    local totalUnknown, totalFlagged = 0, 0
    for x = 0, W-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, H-1 do
                local c = col[z]
                if c then
                    if state.cells.toFlag[c] then
                        totalFlagged = totalFlagged + 1
                    elseif c.covered ~= false and c.state ~= "number"
                    and not state.cells.toClear[c] then
                        totalUnknown = totalUnknown + 1
                    end
                end
            end
        end
    end

    local TOTAL_MINES = 100
    local remaining  = math.max(0, TOTAL_MINES - totalFlagged)
    local globalProb = totalUnknown > 0 and (remaining / totalUnknown) or 0.5

    -- Step 2: per-cell probability from local constraints
    -- For each numbered tile, compute local mine prob among its unknowns
    local probSum = {}
    local probCnt = {}
    local probMin = {}  -- track minimum prob seen (most certain safe estimate)
    local probMax = {}  -- track maximum prob seen (most certain mine estimate)

    for x = 0, W-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, H-1 do
                local c = col[z]
                if c and c.state == "number" and c.number then
                    local unknowns, flagged = {}, 0
                    for _, nb in ipairs(c.neigh) do
                        if state.cells.toFlag[nb] then
                            flagged = flagged + 1
                        elseif nb.covered ~= false and nb.state ~= "number"
                        and not state.cells.toClear[nb] then
                            table.insert(unknowns, nb)
                        end
                    end
                    local minesLeft = c.number - flagged
                    if #unknowns > 0 and minesLeft >= 0 then
                        local lp2 = math.min(1, minesLeft / #unknowns)
                        for _, nb in ipairs(unknowns) do
                            probSum[nb] = (probSum[nb] or 0) + lp2
                            probCnt[nb] = (probCnt[nb] or 0) + 1
                            if probMin[nb] == nil or lp2 < probMin[nb] then probMin[nb] = lp2 end
                            if probMax[nb] == nil or lp2 > probMax[nb] then probMax[nb] = lp2 end
                        end
                    end
                end
            end
        end
    end

    -- Step 3: constraint subtraction pass
    -- If constraint A's unknowns are a subset of constraint B's unknowns,
    -- we can derive tighter bounds on the difference set
    local constraints = {}
    for x = 0, W-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, H-1 do
                local c = col[z]
                if c and c.state == "number" and c.number then
                    local unknowns, flagged = {}, 0
                    local unknownSet = {}
                    for _, nb in ipairs(c.neigh) do
                        if state.cells.toFlag[nb] then
                            flagged = flagged + 1
                        elseif nb.covered ~= false and nb.state ~= "number"
                        and not state.cells.toClear[nb] then
                            table.insert(unknowns, nb)
                            unknownSet[nb] = true
                        end
                    end
                    local minesLeft = c.number - flagged
                    if #unknowns > 0 and minesLeft >= 0 then
                        table.insert(constraints, { cells = unknowns, set = unknownSet, mines = minesLeft })
                    end
                end
            end
        end
    end

    -- subset subtraction: if A ⊆ B, then B-A has (B.mines - A.mines) mines
    for i = 1, #constraints do
        for j = 1, #constraints do
            if i ~= j then
                local A, B = constraints[i], constraints[j]
                -- check if A is subset of B
                local isSubset = true
                for _, c in ipairs(A.cells) do
                    if not B.set[c] then isSubset = false; break end
                end
                if isSubset and #B.cells > #A.cells then
                    local diffMines = B.mines - A.mines
                    local diffCells = {}
                    for _, c in ipairs(B.cells) do
                        if not A.set[c] then table.insert(diffCells, c) end
                    end
                    if #diffCells > 0 and diffMines >= 0 then
                        local dp = math.min(1, diffMines / #diffCells)
                        for _, c in ipairs(diffCells) do
                            probSum[c] = (probSum[c] or 0) + dp
                            probCnt[c] = (probCnt[c] or 0) + 1
                            if probMin[c] == nil or dp < probMin[c] then probMin[c] = dp end
                            if probMax[c] == nil or dp > probMax[c] then probMax[c] = dp end
                        end
                    end
                end
            end
        end
    end

    -- Step 4: final prob per cell
    -- Safe guess: use maximum probability from all constraints (pessimistic = safest)
    -- Mine guess: use maximum probability weighted heavily (aggressive mine detection)
    local function getProb(c)
        if not probCnt[c] or probCnt[c] == 0 then
            return c._prob or globalProb
        end
        local avg = probSum[c] / probCnt[c]
        local mn  = probMin[c]
        local mx  = probMax[c]
        if probCnt[c] >= 3 then
            -- many constraints: trust the average heavily, penalise high max
            return avg * 0.6 + mn * 0.3 + mx * 0.1
        elseif probCnt[c] == 2 then
            return avg * 0.5 + mn * 0.35 + mx * 0.15
        end
        return avg
    end

    local function getMineProb(c)
        if not probCnt[c] or probCnt[c] == 0 then
            return c._prob or globalProb
        end
        local avg = probSum[c] / probCnt[c]
        local mn  = probMin[c]
        local mx  = probMax[c]
        if probCnt[c] >= 3 then
            -- many constraints pointing high = very likely mine
            return avg * 0.4 + mx * 0.5 + mn * 0.1
        elseif probCnt[c] == 2 then
            return avg * 0.45 + mx * 0.45 + mn * 0.1
        end
        return avg
    end

    -- Step 5: pick best safe guess (lowest mine prob)
    local best, bestScore = nil, math.huge
    for x = 0, W-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, H-1 do
                local c = col[z]
                if c and c.part and c.covered ~= false
                and c.state ~= "number"
                and not state.cells.toFlag[c]
                and not state.cells.toClear[c] then
                    local prob = getProb(c)
                    local edgePenalty = 0
                    if x == 0 or x == W-1 then edgePenalty = edgePenalty + 0.04 end
                    if z == 0 or z == H-1 then edgePenalty = edgePenalty + 0.04 end
                    local numNeigh, unkNeigh = 0, 0
                    for _, nb in ipairs(c.neigh) do
                        if nb.state == "number" then numNeigh = numNeigh + 1 end
                        if nb.covered ~= false and nb.state ~= "number"
                        and not state.cells.toFlag[nb] then unkNeigh = unkNeigh + 1 end
                    end
                    local infoBonus   = numNeigh > 0 and (-0.03 * numNeigh) or 0.1
                    local openBonus   = unkNeigh > 4 and -0.04 or 0
                    local blindPenalty = numNeigh == 0 and 0.25 or 0
                    local multiBonus  = (probCnt[c] or 0) >= 2 and -0.06 or 0
                    local score = prob + edgePenalty + infoBonus + openBonus + blindPenalty + multiBonus
                    if score < bestScore then bestScore = score; best = c end
                end
            end
        end
    end
    if best ~= state.bestGuessCell then
        if best then
            debugLog("updateG: Best guess cell found at", best.ix, best.iz)
        end
        state.bestGuessCell = best
        state.dirtyFlag = true
    end

    -- Step 6: pick best mine guess (highest mine prob)
    local bestMine, bestMineScore = nil, -math.huge
    for x = 0, W-1 do
        local col = state.cells.grid[x]
        if col then
            for z = 0, H-1 do
                local c = col[z]
                if c and c.part and c.covered ~= false
                and c.state ~= "number"
                and not state.cells.toFlag[c]
                and not state.cells.toClear[c] then
                    local prob = getMineProb(c)
                    local multiBonus = (probCnt[c] or 0) >= 2 and 0.06 or 0
                    local mineScore = prob + multiBonus
                    if mineScore > bestMineScore then bestMineScore = mineScore; bestMine = c end
                end
            end
        end
    end
    if bestMine ~= state.bestGuessMineCell then
        if bestMine then
            debugLog("updateG: Best mine guess cell found at", bestMine.ix, bestMine.iz)
        end
        state.bestGuessMineCell = bestMine
        state.dirtyFlag = true
    end
end

-- ── Apply highlights to grid ──────────────────────
local function updateH()
    if not state.dirtyFlag then return end
    state.dirtyFlag = false
    local grid = state.cells.grid
    if not grid then return end

    local highlighted = 0
    for x = 0, state.grid.w - 1 do
        local col = grid[x]
        if col then
            for z = 0, state.grid.h - 1 do
                local c = col[z]
                if c and c.part then
                    local isMine      = solverEnabled         and state.cells.toFlag[c]  ~= nil
                    local isSafe      = solverEnabled         and state.cells.toClear[c] ~= nil
                    local isGuess     = autoGuessEnabled      and c == state.bestGuessCell
                    local isGuessMine = autoGuessMineEnabled  and c == state.bestGuessMineCell
                    local shouldShow = c.state ~= "number"
                        and (isMine or isSafe or isGuess or isGuessMine)

                    if shouldShow then
                        local col3 = isMine      and COLOR_MINE
                            or isSafe      and COLOR_SAFE
                            or isGuessMine and COLOR_GUESS_MINE
                            or COLOR_GUESS
                        applyHL(c, col3)
                        highlighted = highlighted + 1
                    else
                        hideHL(c)
                    end
                end
            end
        end
    end
    if highlighted > 0 then
        debugLog("updateH: Highlighted", highlighted, "cells")
    end
end

-- ── Anti Mines ───────────────────────────────────
local antiMinesEnabled = false
local antiMineBarriers = {}

local function clearBarriers()
    for _, b in pairs(antiMineBarriers) do
        pcall(function() b:Destroy() end)
    end
    antiMineBarriers = {}
end

local function updateBarriers()
    -- remove barriers for cells no longer mines
    for cell, b in pairs(antiMineBarriers) do
        if not state.cells.toFlag[cell] or not b.Parent then
            pcall(function() b:Destroy() end)
            antiMineBarriers[cell] = nil
        end
    end
    -- add barriers for new mine cells
    for cell in pairs(state.cells.toFlag) do
        if not antiMineBarriers[cell] and cell.part and cell.part.Parent then
            local p = cell.part
            local b = Instance.new("Part")
            b.Size         = Vector3.new(p.Size.X + 0.8, 0.6, p.Size.Z + 0.8)
            b.CFrame       = p.CFrame * CFrame.new(0, p.Size.Y / 2 + 0.3, 0)
            b.Anchored     = true
            b.CanCollide   = true
            b.Transparency = 1
            b.CanTouch     = false
            b.CastShadow   = false
            b.Name         = "AntiBorder"
            b.Parent       = workspace
            antiMineBarriers[cell] = b
        end
    end
end

-- Pushback: teleport player away if they get within 3 studs of a mine tile
local _lastPush = 0
game:GetService("RunService").Heartbeat:Connect(function()
    if not antiMinesEnabled then return end
    local char = lp.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local now = tick()
    if now - _lastPush < 0.1 then return end
    for cell in pairs(state.cells.toFlag) do
        if cell.part and cell.part.Parent then
            local dist = (hrp.Position - cell.part.Position).Magnitude
            if dist < 4 then
                _lastPush = now
                -- push away from the mine
                local dir = (hrp.Position - cell.part.Position)
                dir = Vector3.new(dir.X, 0, dir.Z)
                if dir.Magnitude > 0 then
                    dir = dir.Unit * 6
                else
                    dir = Vector3.new(6, 0, 0)
                end
                hrp.CFrame = CFrame.new(cell.part.Position + Vector3.new(0, hrp.Position.Y - cell.part.Position.Y, 0) + dir)
                break
            end
        end
    end
end)

-- ── Auto Win ─────────────────────────────────────
local autoWinEnabled = false
local teleportDelay  = 0.5
local teleportGuessEnabled = false

-- ── Auto Flag ────────────────────────────────────
local autoFlagEnabled  = false
local flaggedCells     = {}
local autoFlagToggle   = false
local autoFlaggedSet   = {}
local flagDelay        = 0.02

local FlagRemote  = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    :WaitForChild("FlagEvents"):WaitForChild("PlaceFlag")
local SelectRemote = game:GetService("ReplicatedStorage"):WaitForChild("Events")
    :WaitForChild("FlagEvents"):WaitForChild("SelectFlag")

-- Read token from ClickDetector upvalue 3 (set by MouseControl at startup)
local cachedToken = nil

-- Hook PlaceFlag namecall to sniff token from first manual flag
pcall(function()
    local FlagRemoteHook = game:GetService("ReplicatedStorage")
        :WaitForChild("Events"):WaitForChild("FlagEvents"):WaitForChild("PlaceFlag")
    if typeof(getrawmetatable) ~= "function" then return end
    local mt = getrawmetatable(game)
    if not mt then return end
    local oldNamecall = mt.__namecall
    if not oldNamecall then return end
    pcall(function() if typeof(setreadonly) == "function" then setreadonly(mt, false) end end)
    mt.__namecall = function(self, ...)
        local args = {...}
        pcall(function()
            local method = typeof(getnamecallmethod) == "function" and getnamecallmethod() or ""
            if method == "FireServer" and self == FlagRemoteHook then
                local token = args[2]
                if typeof(token) == "string" and #token > 5 then
                    cachedToken = token
                    debugLog("AutoFlag: Token captured:", token:sub(1,10).."...")
                end
            end
        end)
        return oldNamecall(self, table.unpack(args))
    end
    pcall(function() if typeof(setreadonly) == "function" then setreadonly(mt, true) end end)
end)

local function getToken()
    if cachedToken then return cachedToken end
    -- fallback: UserId (works on Delta and some others)
    if typeof(getconnections) == "function" and typeof(getupvalues) == "function" then
        local board = workspace:FindFirstChild("Flag")
        board = board and board:FindFirstChild("Parts")
        if board then
            for _, tile in ipairs(board:GetChildren()) do
                if tile:IsA("BasePart") then
                    local cd = tile:FindFirstChildOfClass("ClickDetector")
                    if cd then
                        local ok, conns = pcall(getconnections, cd.MouseClick)
                        if ok and conns and conns[1] then
                            local ok2, uv = pcall(getupvalues, conns[1].Function)
                            if ok2 and uv then
                                for _, v in ipairs(uv) do
                                    if typeof(v) == "string" and #v > 5 and tonumber(v) then
                                        cachedToken = v
                                        debugLog("AutoFlag: Token found via getupvalues:", v:sub(1,10).."...")
                                        return cachedToken
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return cachedToken
end

local flagRange = 50

-- Runs in its own loop, independent of solver
task.spawn(function()
    while true do
        task.wait(0.05)
        if not autoFlagToggle then continue end
        local token = getToken()
        if not token then 
            debugLog("AutoFlag: No token available")
            continue 
        end
        local char = lp.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")

        -- collect eligible mines and sort by distance to player
        local candidates = {}
        for cell in pairs(state.cells.toFlag) do
            if not (cell.part and cell.part.Parent) then continue end
            if autoFlaggedSet[cell] then continue end
            if hasF(cell.part) then continue end
            local dist = hrp and (cell.part.Position - hrp.Position).Magnitude or 0
            if dist <= flagRange then
                table.insert(candidates, {cell = cell, dist = dist})
            end
        end
        table.sort(candidates, function(a, b) return a.dist < b.dist end)

        local flagged = 0
        for _, entry in ipairs(candidates) do
            if not autoFlagToggle then break end
            local cell = entry.cell
            if not (cell.part and cell.part.Parent) then continue end
            if autoFlaggedSet[cell] then continue end
            -- always skip if already flagged (prevent unflag/reflag cycle)
            if hasF(cell.part) then
                autoFlaggedSet[cell] = true
                continue
            end
            autoFlaggedSet[cell] = true
            pcall(function() FlagRemote:FireServer(cell.part, token, true) end)
            flagged = flagged + 1
            task.wait(math.max(flagDelay, 0.05))
            -- if flag didn't appear, retry next loop
            if not hasF(cell.part) then
                autoFlaggedSet[cell] = nil
            end
        end
        if flagged > 0 then
            debugLog("AutoFlag: Placed", flagged, "flags")
        end
    end
end)

-- ==============================================
-- ============= MANUAL TEST FUNCTIONS ==========
-- ==============================================

-- Fungsi test manual (panggil di console)
function testManualDetection()
    print("\n=== MANUAL TEST DETECTION ===")
    
    -- 1. Coba scan folder
    local folder = scanB()
    if not folder then
        print("❌ FAIL: scanB() returned nil")
        return
    end
    print("✅ SUCCESS: scanB() found folder:", folder:GetFullName())
    
    -- 2. Rebuild grid manually
    rebuildG(folder)
    
    -- 3. Cek hasil grid
    print("\n📊 Grid size:", state.grid.w, "x", state.grid.h)
    
    if state.grid.w > 0 and state.grid.h > 0 then
        print("✅ SUCCESS: Grid terbentuk!")
        
        -- Cek beberapa cell
        print("\n📌 Sample cells (first 3x3):")
        for x = 0, math.min(2, state.grid.w-1) do
            for z = 0, math.min(2, state.grid.h-1) do
                local cell = state.cells.grid[x][z]
                if cell then
                    print(string.format("  Cell[%d,%d]: part=%s, pos=(%.1f, %.1f, %.1f)", 
                        x, z, 
                        cell.part and "✅" or "❌",
                        cell.pos.X, cell.pos.Y, cell.pos.Z))
                end
            end
        end
    else
        print("❌ FAIL: Grid gagal terbentuk")
    end
    print("===============================\n")
end

-- Fungsi untuk trigger solver manual
function triggerSolver()
    print("\n=== TRIGGERING SOLVER ===")
    
    local folder = scanB()
    if not folder then
        print("❌ No board folder!")
        return
    end
    
    print("Rebuilding grid...")
    rebuildG(folder)
    
    if state.grid.w == 0 then
        print("❌ Grid rebuild failed!")
        return
    end
    
    print("Updating state...")
    updateS()
    print("📊 Numbered cells:", #state.cells.numbered)
    
    print("Running logic...")
    updateL()
    print("🚩 To Flag:", #state.cells.toFlag)
    print("✅ To Clear:", #state.cells.toClear)
    
    updateG()
    if state.bestGuessCell then
        print("🎯 Best guess at:", state.bestGuessCell.ix, state.bestGuessCell.iz)
    end
    if state.bestGuessMineCell then
        print("💣 Best mine guess at:", state.bestGuessMineCell.ix, state.bestGuessMineCell.iz)
    end
    
    updateH()
    print("=== DONE ===\n")
end

-- Fungsi untuk cek status
function checkStatus()
    print("\n=== CURRENT STATUS ===")
    print("Solver Enabled:", solverEnabled)
    print("Auto Guess:", autoGuessEnabled)
    print("Auto Guess Mine:", autoGuessMineEnabled)
    print("Grid Size:", state.grid.w, "x", state.grid.h)
    print("Numbered Cells:", #state.cells.numbered)
    print("Mines Found:", #state.cells.toFlag)
    print("Safe Cells:", #state.cells.toClear)
    print("Token Available:", cachedToken and "✅" or "❌")
    print("Auto Flag Enabled:", autoFlagToggle)
    print("=====================\n")
end

-- ==============================================
-- ============= KEY & WINDOW SETUP =============
-- ==============================================

local VALID_KEY   = "MoonKey_A9sHdq1Sx7Pr7e3s"
local DISCORD_URL = "https://discord.gg/dqw8P684K"
local keyVerified = false
local enteredKey  = ""

local Window  = Moon:CreateWindow({ Title = "Minesweeper" })
local KeyTab  = Window:CreateTab("Key")
local MainTab = Window:CreateTab("Solver")
MainTab:Hide()   -- hidden until key verified
KeyTab:Activate()

-- Auto-load saved key
pcall(function()
    local saved = readfile("MoonMinesweeperKey.txt")
    if saved == VALID_KEY then
        keyVerified = true
        enteredKey  = saved
        MainTab:Show()
        MainTab:Activate()
        KeyTab:Hide()
        debugLog("Key loaded from file")
    end
end)

KeyTab:CreateSection("Key System")

local keyBox = nil  -- direct reference to the TextBox for Verify to read
local keyInput = {
    Name        = "Enter Key",
    Description = "Paste your key here.",
    Placeholder = "MoonKey_...",
    Callback    = function(v)
        enteredKey = v
    end,
}
KeyTab:CreateInput(keyInput)

KeyTab:CreateButton({
    Name        = "Get Key",
    Description = "Copies the Discord link to your clipboard.",
    Callback    = function()
        pcall(function() setclipboard(DISCORD_URL) end)
        debugLog("Discord link copied to clipboard")
    end,
})

KeyTab:CreateButton({
    Name        = "Verify Key",
    Description = "Verifies your entered key.",
    Callback    = function()
        -- fallback: read directly from input's last tracked text
        local k = (keyInput._lastText and keyInput._lastText ~= "") and keyInput._lastText or enteredKey
        if k == VALID_KEY then
            keyVerified = true
            enteredKey  = k
            pcall(function() writefile("MoonMinesweeperKey.txt", k) end)
            MainTab:Show()
            MainTab:Activate()
            KeyTab:Hide()
            debugLog("Key verified successfully!")
            Window:Notify({
                Title = "Success",
                Message = "Key verified! Solver unlocked.",
                Type = "success",
                Duration = 3
            })
        else
            debugLog("Invalid key entered:", k)
            Window:Notify({
                Title = "Error",
                Message = "Invalid key!",
                Type = "error",
                Duration = 3
            })
        end
    end,
})

-- ── Main tab (locked behind key) ─────────────────────────────────
local Tab = MainTab

Tab:CreateSection("Highlights")

Tab:CreateToggle({
    Name        = "Auto Solver",
    Description = "Green = safe. Red = mine.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        solverEnabled = v
        state.dirtyFlag = true
        debugLog("Auto Solver:", v and "ON" or "OFF")
        if not v then
            if not autoGuessEnabled then
                clearAllHL()
                state.lastPartCount = -1
            end
            state.dirtyFlag = true
        end
    end,
})

Tab:CreateSection("Anti Mines")

Tab:CreateToggle({
    Name        = "Anti Mines",
    Description = "Invisible barrier on mine tiles so you can't walk on them.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        antiMinesEnabled = v
        debugLog("Anti Mines:", v and "ON" or "OFF")
        if not v then clearBarriers() end
    end,
})

Tab:CreateSection("Guess")

Tab:CreateToggle({
    Name        = "Auto Guess Safe",
    Description = "Blue = safest tile to click.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        autoGuessEnabled = v
        autoGuessSafeEnabled = v
        state.dirtyFlag = true
        debugLog("Auto Guess Safe:", v and "ON" or "OFF")
        if not v then
            state.bestGuessCell = nil
            if not solverEnabled and not autoGuessMineEnabled then
                clearAllHL()
                state.lastPartCount = -1
            end
            state.dirtyFlag = true
        end
    end,
})

Tab:CreateToggle({
    Name        = "Auto Guess Mine",
    Description = "Orange = most likely mine.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        autoGuessMineEnabled = v
        state.dirtyFlag = true
        debugLog("Auto Guess Mine:", v and "ON" or "OFF")
        if not v then
            state.bestGuessMineCell = nil
            if not solverEnabled and not autoGuessEnabled then
                clearAllHL()
                state.lastPartCount = -1
            end
            state.dirtyFlag = true
        end
    end,
})

Tab:CreateSection("Auto Win")

Tab:CreateSlider({
    Name        = "Teleport Delay",
    Description = "Seconds between each tile teleport.",
    Min         = 0, Max = 3, Default = 1, Suffix = "s",
    Callback    = function(v) teleportDelay = v end,
})

Tab:CreateToggle({
    Name        = "Auto Win",
    Description = "Teleports you to every safe tile automatically.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        autoWinEnabled = v
        debugLog("Auto Win:", v and "ON" or "OFF")
        if v then
            task.spawn(function()
                while autoWinEnabled do
                    local hasSafe = false
                    for cell in pairs(state.cells.toClear) do
                        if not autoWinEnabled then break end
                        if cell.part and cell.part.Parent
                        and cell.covered ~= false and cell.state ~= "number"
                        and not state.cells.toFlag[cell] then
                            hasSafe = true
                            local char = lp.Character
                            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = cell.part.CFrame * CFrame.new(0, cell.part.Size.Y, 0)
                                task.wait(0.1)
                            end
                            task.wait(teleportDelay)
                            if not autoWinEnabled then break end
                        end
                    end
                    -- no safe tiles left — teleport to best guess if enabled
                    -- only if solver has actually run (numbered tiles exist) to avoid pre-game teleport
                    local solverHasData = next(state.cells.numbered) ~= nil
                    if not hasSafe and teleportGuessEnabled and state.bestGuessCell and solverHasData then
                        local g = state.bestGuessCell
                        if g.part and g.part.Parent then
                            local char = lp.Character
                            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = g.part.CFrame * CFrame.new(0, g.part.Size.Y, 0)
                                task.wait(0.1)
                            end
                            task.wait(teleportDelay)
                        end
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

Tab:CreateToggle({
    Name        = "Teleport to Guess",
    Description = "Teleports to safest guess when no safe tiles remain.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        teleportGuessEnabled = v
        debugLog("Teleport to Guess:", v and "ON" or "OFF")
    end,
})

Tab:CreateSection("Auto Flag")

-- Hooking support indicator
do
    local hasHook = typeof(getrawmetatable) == "function"
                 or typeof(hookfunction) == "function"
                 or typeof(replaceclosure) == "function"
    Tab:CreateButton({
        Name        = hasHook and "Hooking: Supported" or "Hooking: Not Supported",
        Description = hasHook
            and "Your executor has hooking support, auto flag will work."
            or  "Your executor has no hooking support, auto flag won't work.",
        Callback    = function() end,
        _color      = hasHook and Color3.fromRGB(30,180,80) or Color3.fromRGB(200,50,50),
    })
    debugLog("Hooking support:", hasHook and "✅" or "❌")
end

Tab:CreateSlider({
    Name        = "Flag Range",
    Description = "Only flags mines within this distance from you (studs).",
    Min         = 5, Max = 200, Default = 50, Suffix = " studs",
    Callback    = function(v) flagRange = v end,
})

Tab:CreateSlider({
    Name        = "PlaceFlag Delay",
    Description = "Delay between each flag placement (seconds).",
    Min         = 0, Max = 10, Default = 0, Suffix = "x0.1s",
    Callback    = function(v) flagDelay = v * 0.1 end,
})

Tab:CreateToggle({
    Name        = "Auto Flag Mines",
    Description = "Auto flags all detected mines.",
    Default     = false,
    Callback    = function(v)
        if not keyVerified then return end
        autoFlagToggle = v
        debugLog("Auto Flag:", v and "ON" or "OFF")
    end,
})

-- ── Auto-detect board reset ─────────────────────────────────────
workspace.DescendantRemoving:Connect(function(desc)
    if cachedB and desc == cachedB then
        debugLog("Board folder removed, resetting state...")
        cachedB              = nil
        state.lastPartCount  = -1
        state.grid.w         = 0
        state.grid.h         = 0
        state.cells.grid     = {}
        state.cells.numbered = {}
        state.cells.toFlag   = {}
        state.cells.toClear  = {}
        autoFlaggedSet       = {}
        clearBarriers()
        state.lastF          = {}
        state.lastS          = {}
        local f = workspace:FindFirstChild("MoonMineHL")
        if f then f:Destroy() end
        hlFolder = nil
    end
end)

-- ── Heartbeat loop ────────────────────────────────────────────────
-- Solver runs in task.defer so it never stalls the render frame.
-- Solve interval: 0.1s for snappy updates.
local lastSolve  = -math.huge  -- fire immediately on first heartbeat
local solving    = false  -- guard: only one solve running at a time
RunService.Heartbeat:Connect(function()
    if not solverEnabled and not autoGuessEnabled and not autoGuessMineEnabled then return end

    local folder = scanB()
    if not folder then return end

    local pc     = #folder:GetChildren()
    local now    = tick()
    local rebuild = pc ~= state.lastPartCount

    if rebuild then
        debugLog("Board changed: parts", state.lastPartCount or 0, "->", pc)
        state.lastPartCount = pc
        rebuildG(folder)
    end

    if state.grid.w == 0 then
        -- Only warn occasionally
        if not state._warned or tick() - state._warned > 10 then
            debugLog("WARNING: Grid width = 0, board not detected!")
            state._warned = tick()
        end
        return
    end

    if not solving and (rebuild or (now - lastSolve) >= 0.1) then
        lastSolve = now
        solving   = true
        task.defer(function()
            pcall(updateS)
            pcall(updateL)
            pcall(updateG)
            solving = false
        end)
    end

    if antiMinesEnabled then pcall(updateBarriers) end
    updateH()
end)

-- Initial debug
debugLog("Script loaded! Use testManualDetection() to check board detection.")
debugLog("Use triggerSolver() to manually run solver.")
debugLog("Use checkStatus() to see current state.")
