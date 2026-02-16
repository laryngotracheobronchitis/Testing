
if getgenv().DaraHubExecuted then
 return
end
getgenv().DaraHubExecuted = true
--[[-------------------------------------------------------
 CONTROLLING THE UI EXAMPLE
-----------------------------------------------------------

    _G.DarahubLibBtn.{Flag}.Visible = true
    _G.DarahubLibBtn.{Flag}:Set(true)
    _G.DarahubLibBtn.{Flag}:Destroy()
    _G.DarahubLibBtn.{Flag}:Destroy()
    
    
    local ButtonLib = loadstring(game:HttpGet("https://darahub.vercel.app/Module/Button-lib.lua"))()

-- 1. Create a Button that starts INVISIBLE
ButtonLib.Create:Button({
    Text = "SECRET BUTTON",
    Flag = "SecretBtn",
    Visible = false, -- Starts hidden
    Callback = function() print("You found me!") end
}).Position = UDim2.new(0.5, -125, 0.2, 0)

-- 2. Create a Toggle
ButtonLib.Create:Toggle({
    Text = "AUTO CARRY",
    Flag = "CarryToggle",
    Default = false,
    Visible = true,
    Callback = function(s) print("Carry is:", s) end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

]]
local ButtonLib = loadstring(game:HttpGet("https://darahub.vercel.app/Module/Button-lib.lua"))()

--macro command gui
Players = game:GetService("Players") UserInputService = game:GetService("UserInputService") RunService = game:GetService("RunService") ReplicatedStorage = game:GetService("ReplicatedStorage") HttpService = game:GetService("HttpService") Player = Players.LocalPlayer PlayerGui = Player:WaitForChild("PlayerGui") CoreGui = game:GetService("CoreGui") function getDpiScale() local gui = Instance.new("ScreenGui", PlayerGui) local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 100, 0, 100) task.wait() local scale = frame.AbsoluteSize.X / 100 gui:Destroy() return math.clamp(math.round(scale * 10) / 10, 1, 3) end DPI = getDpiScale() FILLED = "●" OPEN = "○" function safeReadFile(path) if not readfile then return nil end local success, content = pcall(readfile, path) return success and content or nil end function safeWriteFile(path, data) if not writefile then return false end local success, err = pcall(writefile, path, data) return success end CONFIG_DIR = "DaraHub" CONFIG_FILE = CONFIG_DIR .. "/Evade-LegacyMacroVipCMD.json" if isfolder and not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end Presets = {} function serializeMacro(macro) local ser = table.clone(macro) ser.keybind = macro.keybind.Name return ser end function deserializeMacro(ser) local macro = table.clone(ser) macro.keybind = ser.keybind and Enum.KeyCode[ser.keybind] or Enum.KeyCode.F return macro end function loadPresets() local data = safeReadFile(CONFIG_FILE) if data then local success, decoded = pcall(HttpService.JSONDecode, HttpService, data) if success and typeof(decoded) == "table" then Presets = {} for name, arr in pairs(decoded) do Presets[name] = {} for i, ser in ipairs(arr) do Presets[name][i] = deserializeMacro(ser) end end end end end function savePresets() local toSave = {} for name, macros in pairs(Presets) do toSave[name] = {} for i, macro in ipairs(macros) do toSave[name][i] = serializeMacro(macro) end end local json = HttpService:JSONEncode(toSave) safeWriteFile(CONFIG_FILE, json) end loadPresets() ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "MacroManagerGUI" ScreenGui.ResetOnSpawn = false ScreenGui.Enabled = false ScreenGui.Parent = CoreGui Main = Instance.new("Frame") Main.Name = "MainFrame" Main.Size = UDim2.new(0, 380 * DPI, 0, 480 * DPI) Main.Position = UDim2.new(0.5, 0, 0.5, 0) Main.AnchorPoint = Vector2.new(0.5, 0.5) Main.BackgroundColor3 = Color3.fromRGB(25, 25, 35) Main.ClipsDescendants = true Main.Parent = ScreenGui Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12) TitleBar = Instance.new("Frame") TitleBar.Name = "TitleBar" TitleBar.Size = UDim2.new(1, 0, 0, 36 * DPI) TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45) TitleBar.Parent = Main Title = Instance.new("TextLabel") Title.Name = "TitleLabel" Title.Size = UDim2.new(1, -84, 1, 0) Title.Position = UDim2.new(0, 8, 0, 0) Title.BackgroundTransparency = 1 Title.Text = "Macro Manager" Title.TextColor3 = Color3.new(1, 1, 1) Title.Font = Enum.Font.GothamBold Title.TextSize = 16 * DPI Title.TextXAlignment = Enum.TextXAlignment.Left Title.Parent = TitleBar ConfigBtn = Instance.new("TextButton") ConfigBtn.Name = "ConfigButton" ConfigBtn.Size = UDim2.new(0, 28, 0, 28) ConfigBtn.Position = UDim2.new(1, -68, 0, 4) ConfigBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255) ConfigBtn.Text = "🗂️" ConfigBtn.TextColor3 = Color3.new(1, 1, 1) ConfigBtn.Font = Enum.Font.GothamBold ConfigBtn.TextSize = 16 * DPI ConfigBtn.Parent = TitleBar Instance.new("UICorner", ConfigBtn).CornerRadius = UDim.new(0, 6) Close = Instance.new("TextButton") Close.Name = "CloseButton" Close.Size = UDim2.new(0, 28, 0, 28) Close.Position = UDim2.new(1, -32, 0, 4) Close.BackgroundColor3 = Color3.fromRGB(255, 50, 50) Close.Text = "X" Close.TextColor3 = Color3.new(1, 1, 1) Close.Font = Enum.Font.GothamBold Close.TextSize = 14 * DPI Close.Parent = TitleBar Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6) Close.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end) Scroll = Instance.new("ScrollingFrame") Scroll.Name = "MacroScroll" Scroll.Size = UDim2.new(1, -16, 1, -88) Scroll.Position = UDim2.new(0, 8, 0, 44) Scroll.BackgroundTransparency = 1 Scroll.ScrollBarThickness = 5 Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y Scroll.Parent = Main Layout = Instance.new("UIListLayout", Scroll) Layout.Name = "MacroListLayout" Layout.Padding = UDim.new(0, 6) NoMacrosLabel = Instance.new("TextLabel") NoMacrosLabel.Name = "NoMacrosLabel" NoMacrosLabel.Size = UDim2.new(1, -32, 1, -100) NoMacrosLabel.Position = UDim2.new(0, 16, 0, 50) NoMacrosLabel.BackgroundTransparency = 1 NoMacrosLabel.Text = "No VIP Command macros available" NoMacrosLabel.TextColor3 = Color3.fromRGB(150, 150, 150) NoMacrosLabel.Font = Enum.Font.Gotham NoMacrosLabel.TextSize = 16 * DPI NoMacrosLabel.TextWrapped = true NoMacrosLabel.Visible = true NoMacrosLabel.Parent = Main CreateBtn = Instance.new("TextButton") CreateBtn.Name = "CreateButton" CreateBtn.Size = UDim2.new(1, -16, 0, 36) CreateBtn.Position = UDim2.new(0, 8, 1, -44) CreateBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) CreateBtn.Text = "+ New Macro" CreateBtn.TextColor3 = Color3.new(1, 1, 1) CreateBtn.Font = Enum.Font.GothamBold CreateBtn.TextSize = 15 * DPI CreateBtn.Parent = Main Instance.new("UICorner", CreateBtn).CornerRadius = UDim.new(0, 8) DelayUnits = {"Ms", "Sec", "Minute", "Hour", "Day", "Week", "Year"} function toMs(v, u) local m = {Ms = 1, Sec = 1000, Minute = 60000, Hour = 3600000, Day = 86400000, Week = 604800000, Year = 31536000000} return (v or 0) * (m[u] or 1) end TimeUnits = {"Ms", "Second", "Minute", "Hour", "Day", "Week", "Month", "Year"} function toSeconds(v, u) local m = {Ms = 0.001, Second = 1, Minute = 60, Hour = 3600, Day = 86400, Week = 604800, Month = 2629800, Year = 31557600} return (v or 0) * (m[u] or 1) end function formatTimeRemaining(seconds) if seconds <= 0 then return "Done" end local years = math.floor(seconds / 31557600); seconds = seconds % 31557600 local months = math.floor(seconds / 2629800); seconds = seconds % 2629800 local weeks = math.floor(seconds / 604800); seconds = seconds % 604800 local days = math.floor(seconds / 86400); seconds = seconds % 86400 local hours = math.floor(seconds / 3600); seconds = seconds % 3600 local mins = math.floor(seconds / 60); seconds = seconds % 60 local parts = {} if years > 0 then table.insert(parts, years .. "y") end if months > 0 then table.insert(parts, months .. "mo") end if weeks > 0 then table.insert(parts, weeks .. "w") end if days > 0 then table.insert(parts, days .. "d") end if hours > 0 then table.insert(parts, hours .. "h") end if mins > 0 then table.insert(parts, mins .. "m") end if seconds > 0 and (#parts > 0 and seconds >= 1 or #parts == 0) then local sec_str = seconds < 1 and string.format("%.1fs", seconds) or math.floor(seconds) .. "s" table.insert(parts, sec_str) end return table.concat(parts, " ") end Macros = {} function updateNoMacrosLabel() NoMacrosLabel.Visible = #Macros == 0 end function updateCanvas() task.defer(function() Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10) end) end ConfirmPopup = nil function showDeleteConfirm(data, idx, entryFrame) if ConfirmPopup then ConfirmPopup:Destroy() end ConfirmPopup = Instance.new("Frame") ConfirmPopup.Name = "DeleteConfirmPopup" ConfirmPopup.Size = UDim2.new(0, 260 * DPI, 0, 130 * DPI) ConfirmPopup.Position = UDim2.new(0.5, 0, 0.5, 0) ConfirmPopup.AnchorPoint = Vector2.new(0.5, 0.5) ConfirmPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) ConfirmPopup.ZIndex = 20 ConfirmPopup.Parent = ScreenGui Instance.new("UICorner", ConfirmPopup).CornerRadius = UDim.new(0, 12) local msg = Instance.new("TextLabel") msg.Text = "Delete this macro?" msg.Size = UDim2.new(1, -20, 0, 50) msg.Position = UDim2.new(0, 10, 0, 10) msg.BackgroundTransparency = 1 msg.TextColor3 = Color3.new(1, 1, 1) msg.Font = Enum.Font.GothamBold msg.TextSize = 15 * DPI msg.ZIndex = 21 msg.Parent = ConfirmPopup local yes = Instance.new("TextButton") yes.Size = UDim2.new(0.45, 0, 0, 32) yes.Position = UDim2.new(0.05, 0, 1, -40) yes.BackgroundColor3 = Color3.fromRGB(255, 50, 50) yes.Text = "Yes" yes.TextColor3 = Color3.new(1, 1, 1) yes.Font = Enum.Font.GothamBold yes.TextSize = 13 * DPI yes.ZIndex = 21 yes.Parent = ConfirmPopup Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 8) local no = Instance.new("TextButton") no.Size = UDim2.new(0.45, 0, 0, 32) no.Position = UDim2.new(0.5, 0, 1, -40) no.BackgroundColor3 = Color3.fromRGB(100, 100, 100) no.Text = "No" no.TextColor3 = Color3.new(1, 1, 1) no.Font = Enum.Font.GothamBold no.TextSize = 13 * DPI no.ZIndex = 21 no.Parent = ConfirmPopup Instance.new("UICorner", no).CornerRadius = UDim.new(0, 8) no.MouseButton1Click:Connect(function() ConfirmPopup:Destroy(); ConfirmPopup = nil end) yes.MouseButton1Click:Connect(function() if data.running and data.stopMacro then data.stopMacro() end if data.connections then for _, c in ipairs(data.connections) do if c.Connected then pcall(c.Disconnect, c) end end end entryFrame:Destroy() table.remove(Macros, idx) updateNoMacrosLabel() updateCanvas() ConfirmPopup:Destroy(); ConfirmPopup = nil end) end function makeEntry(data, idx) local f = Instance.new("Frame") f.Name = "MacroEntry_" .. idx f.Size = UDim2.new(1, 0, 0, 135) f.BackgroundColor3 = Color3.fromRGB(35, 35, 50) f.ZIndex = 2 f.Parent = Scroll Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8) local name = Instance.new("TextLabel") name.Name = "MacroNameLabel" name.Size = UDim2.new(0.6, 0, 0, 22) name.Position = UDim2.new(0, 8, 0, 4) name.BackgroundTransparency = 1 name.Text = data.name ~= "" and data.name or ("Macro " .. idx) name.TextColor3 = Color3.new(1, 1, 1) name.Font = Enum.Font.GothamBold name.TextSize = 13 * DPI name.TextXAlignment = Enum.TextXAlignment.Left name.ZIndex = 3 name.Parent = f local cmd = Instance.new("TextLabel") cmd.Name = "CommandLabel" cmd.Size = UDim2.new(1, -16, 0, 18) cmd.Position = UDim2.new(0, 8, 0, 26) cmd.BackgroundTransparency = 1 cmd.Text = data.command cmd.TextColor3 = Color3.fromRGB(180, 180, 180) cmd.Font = Enum.Font.Gotham cmd.TextSize = 11 * DPI cmd.TextXAlignment = Enum.TextXAlignment.Left cmd.ZIndex = 3 cmd.Parent = f local info = Instance.new("TextLabel") info.Name = "InfoLabel" info.Size = UDim2.new(1, -16, 0, 20) info.Position = UDim2.new(0, 8, 0, 44) info.BackgroundTransparency = 1 info.Text = string.format("Delay: %d %s | Key: %s", data.delayValue, data.delayUnit, (data.keybind and data.keybind.Name) or "F") info.TextColor3 = Color3.fromRGB(120, 200, 255) info.Font = Enum.Font.Gotham info.TextSize = 10 * DPI info.TextXAlignment = Enum.TextXAlignment.Left info.ZIndex = 3 info.Parent = f local repeatLabel = Instance.new("TextLabel") repeatLabel.Name = "RepeatLabel" repeatLabel.Size = UDim2.new(1, -16, 0, 18) repeatLabel.Position = UDim2.new(0, 8, 0, 66) repeatLabel.BackgroundTransparency = 1 repeatLabel.Text = data.stopMode == "indefinitely" and "Run indefinitely" or data.stopMode == "time" and "Amount of time" or "Number of cycles" repeatLabel.TextColor3 = Color3.fromRGB(255, 200, 100) repeatLabel.Font = Enum.Font.Gotham repeatLabel.TextSize = 11 * DPI repeatLabel.TextXAlignment = Enum.TextXAlignment.Left repeatLabel.ZIndex = 3 repeatLabel.Parent = f local countdown = Instance.new("TextLabel") countdown.Name = "CountdownLabel" countdown.Size = UDim2.new(1, -16, 0, 18) countdown.Position = UDim2.new(0, 8, 0, 84) countdown.BackgroundTransparency = 1 countdown.Text = "Ready" countdown.TextColor3 = Color3.fromRGB(255, 200, 100) countdown.Font = Enum.Font.GothamBold countdown.TextSize = 12 * DPI countdown.TextXAlignment = Enum.TextXAlignment.Left countdown.ZIndex = 3 countdown.Parent = f local status = Instance.new("TextLabel") status.Name = "StatusLabel" status.Size = UDim2.new(0, 70, 0, 18) status.Position = UDim2.new(1, -78, 0, 4) status.BackgroundTransparency = 1 status.Text = "OFF" status.TextColor3 = Color3.fromRGB(255, 100, 100) status.Font = Enum.Font.GothamBold status.TextSize = 11 * DPI status.ZIndex = 3 status.Parent = f local function btn(txt, col, x, name) local b = Instance.new("TextButton") b.Name = name .. "Button" b.Size = UDim2.new(0, 52, 0, 22) b.Position = UDim2.new(0, x, 1, -31) b.BackgroundColor3 = col b.Text = txt b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.GothamBold b.TextSize = 11 * DPI b.ZIndex = 4 b.Parent = f Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6) return b end local startBtn = btn("START", Color3.fromRGB(0, 200, 0), 8, "Start") local editBtn = btn("Edit", Color3.fromRGB(255, 170, 0), 68, "Edit") local dupBtn = btn("Dup", Color3.fromRGB(0, 170, 255), 128, "Duplicate") local delBtn = btn("Del", Color3.fromRGB(255, 50, 50), 188, "Delete") local running = false local conn, countdownConn, keyConn = nil, nil, nil data.connections = {} local startTime, cycleCount, maxCycles = nil, nil, nil local function updateCountdown() if countdownConn and countdownConn.Connected then countdownConn:Disconnect() end if data.stopMode == "indefinitely" then countdown.Visible = false return else countdown.Visible = true end if not running then countdown.Text = "Ready" countdown.TextColor3 = Color3.fromRGB(255, 200, 100) return end countdownConn = RunService.Heartbeat:Connect(function() if not running then countdown.Text = "Ready" countdown.TextColor3 = Color3.fromRGB(255, 200, 100) if countdownConn.Connected then countdownConn:Disconnect() end return end local elapsed = tick() - startTime local delaySec = toMs(data.delayValue, data.delayUnit) / 1000 local nextInSec = delaySec - (elapsed % delaySec) if data.stopMode == "time" then local remaining = math.max(0, data.stopTime - elapsed) countdown.Text = formatTimeRemaining(remaining) countdown.TextColor3 = remaining <= 0 and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 255, 100) elseif data.stopMode == "cycles" then local left = math.max(0, (maxCycles or 0) - cycleCount) countdown.Text = left .. " cycle" .. (left == 1 and "" or "s") .. " left | " .. formatTimeRemaining(nextInSec) countdown.TextColor3 = Color3.fromRGB(100, 255, 100) else countdown.Text = formatTimeRemaining(nextInSec) countdown.TextColor3 = Color3.fromRGB(100, 255, 100) end end) table.insert(data.connections, countdownConn) end local function stopMacro() if conn and conn.Connected then conn:Disconnect(); conn = nil end if countdownConn and countdownConn.Connected then countdownConn:Disconnect(); countdownConn = nil end if keyConn and keyConn.Connected then keyConn:Disconnect(); keyConn = nil end running = false startBtn.Text = "START" startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) status.Text = "OFF" status.TextColor3 = Color3.fromRGB(255, 100, 100) countdown.Text = "Ready" countdown.TextColor3 = Color3.fromRGB(255, 200, 100) data.connections = {} updateCountdown() end data.stopMacro = stopMacro local function startMacro() if running then return end running = true startBtn.Text = "STOP" startBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) status.Text = "ON" status.TextColor3 = Color3.fromRGB(0, 255, 0) startTime = tick() cycleCount = 0 maxCycles = (data.stopMode == "cycles") and data.stopCycles or nil local delaySec = toMs(data.delayValue, data.delayUnit) / 1000 local nextRun = 0 if conn and conn.Connected then conn:Disconnect() end conn = RunService.Heartbeat:Connect(function() if not running then return end local now = tick() if data.stopMode == "time" and (now - startTime >= data.stopTime) then stopMacro(); return end if data.stopMode == "cycles" and cycleCount >= maxCycles then stopMacro(); return end if now >= nextRun then pcall(function() local Event = game:GetService("ReplicatedStorage").Events.Admin Event:FireServer("Command", data.command) end) cycleCount = cycleCount + 1 nextRun = now + delaySec end end) table.insert(data.connections, conn) updateCountdown() end startBtn.MouseButton1Click:Connect(function() if running then stopMacro() else startMacro() end end) local function connectKeybind() if keyConn and keyConn.Connected then keyConn:Disconnect() end keyConn = UserInputService.InputBegan:Connect(function(inp, gp) if gp or inp.KeyCode ~= data.keybind then return end if running then stopMacro() else startMacro() end end) table.insert(data.connections, keyConn) end connectKeybind() data.connectKeybind = connectKeybind dupBtn.MouseButton1Click:Connect(function() local copy = table.clone(data) copy.name = (copy.name ~= "" and copy.name or "Macro") .. " (Copy)" table.insert(Macros, copy) makeEntry(copy, #Macros) updateNoMacrosLabel() updateCanvas() end) delBtn.MouseButton1Click:Connect(function() showDeleteConfirm(data, idx, f) end) editBtn.MouseButton1Click:Connect(function() CmdEditMacro(data, idx, f) end) data.running = running data.entryFrame = f data.startBtn = startBtn data.status = status data.countdown = countdown data.repeatLabel = repeatLabel data.updateCountdown = updateCountdown updateCountdown() updateNoMacrosLabel() updateCanvas() return f end Popup, activeDropdown, overlay = nil, nil, nil function closeAllDropdowns() if activeDropdown then activeDropdown.Visible = false; activeDropdown = nil end if overlay then overlay:Destroy(); overlay = nil end end function createOverlay() if overlay then overlay:Destroy() end overlay = Instance.new("TextButton") overlay.Size = UDim2.new(1, 0, 1, 0) overlay.BackgroundTransparency = 0.7 overlay.BackgroundColor3 = Color3.new(0, 0, 0) overlay.Text = "" overlay.ZIndex = 14 overlay.Parent = Popup overlay.MouseButton1Click:Connect(closeAllDropdowns) end function makeDropdown(btn, list, options, default, cb) btn.Text = default list.Visible = false list.ZIndex = 15 for i, opt in ipairs(options) do local o = Instance.new("TextButton") o.Size = UDim2.new(1, 0, 0, 28) o.Position = UDim2.new(0, 0, 0, (i - 1) * 28) o.BackgroundColor3 = Color3.fromRGB(50, 50, 70) o.Text = opt o.TextColor3 = Color3.new(1, 1, 1) o.Font = Enum.Font.Gotham o.TextSize = 13 * DPI o.ZIndex = 16 o.Parent = list Instance.new("UICorner", o).CornerRadius = UDim.new(0, 6) o.MouseButton1Click:Connect(function() btn.Text = opt cb(opt) closeAllDropdowns() end) end btn.ZIndex = 11 btn.MouseButton1Click:Connect(function() if activeDropdown == list then closeAllDropdowns() else closeAllDropdowns() list.Visible = true activeDropdown = list createOverlay() end end) end function CmdEditMacro(editData, oldIdx, oldFrame) if Popup then Popup:Destroy() end local isEdit = editData ~= nil local data = isEdit and table.clone(editData) or { name = "", command = "", delayValue = 1, delayUnit = "Ms", keybind = Enum.KeyCode.F, stopMode = "indefinitely", stopTime = 5, stopTimeUnit = "Second", stopCycles = 10 } Popup = Instance.new("Frame") Popup.Name = "EditMacroPopup" Popup.Size = UDim2.new(0, 360 * DPI, 0, 460 * DPI) Popup.Position = UDim2.new(0.5, 0, 0.5, 0) Popup.AnchorPoint = Vector2.new(0.5, 0.5) Popup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) Popup.ZIndex = 10 Popup.Parent = ScreenGui Instance.new("UICorner", Popup).CornerRadius = UDim.new(0, 12) local pTitle = Instance.new("TextLabel") pTitle.Size = UDim2.new(1, 0, 0, 36) pTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 55) pTitle.Text = isEdit and "Edit Macro" or "New Macro" pTitle.TextColor3 = Color3.new(1, 1, 1) pTitle.Font = Enum.Font.GothamBold pTitle.TextSize = 16 * DPI pTitle.ZIndex = 11 pTitle.Parent = Popup Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0, 12) local nameBox = Instance.new("TextBox") nameBox.Size = UDim2.new(1, -16, 0, 32) nameBox.Position = UDim2.new(0, 8, 0, 44) nameBox.PlaceholderText = "Enter Name" nameBox.Text = data.name nameBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55) nameBox.TextColor3 = Color3.new(1, 1, 1) nameBox.Font = Enum.Font.Gotham nameBox.TextSize = 13 * DPI nameBox.ClearTextOnFocus = false nameBox.ZIndex = 11 nameBox.Parent = Popup Instance.new("UICorner", nameBox) local cmdBox = Instance.new("TextBox") cmdBox.Size = UDim2.new(1, -16, 0, 32) cmdBox.Position = UDim2.new(0, 8, 0, 82) cmdBox.PlaceholderText = "Enter command here" cmdBox.Text = data.command cmdBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55) cmdBox.TextColor3 = Color3.new(1, 1, 1) cmdBox.Font = Enum.Font.Gotham cmdBox.TextSize = 13 * DPI cmdBox.ClearTextOnFocus = false cmdBox.ZIndex = 11 cmdBox.Parent = Popup Instance.new("UICorner", cmdBox) local delayVal = Instance.new("TextBox") delayVal.Size = UDim2.new(0, 90, 0, 32) delayVal.Position = UDim2.new(0, 8, 0, 120) delayVal.PlaceholderText = "Delay" delayVal.Text = tostring(data.delayValue or 1) delayVal.BackgroundColor3 = Color3.fromRGB(40, 40, 55) delayVal.TextColor3 = Color3.new(1, 1, 1) delayVal.Font = Enum.Font.Gotham delayVal.TextSize = 13 * DPI delayVal.ClearTextOnFocus = false delayVal.ZIndex = 11 delayVal.Parent = Popup Instance.new("UICorner", delayVal) local delayDrop = Instance.new("TextButton") delayDrop.Size = UDim2.new(0, 90, 0, 32) delayDrop.Position = UDim2.new(0, 106, 0, 120) delayDrop.BackgroundColor3 = Color3.fromRGB(50, 50, 70) delayDrop.TextColor3 = Color3.new(1, 1, 1) delayDrop.Font = Enum.Font.GothamBold delayDrop.TextSize = 13 * DPI delayDrop.Text = data.delayUnit or "Ms" delayDrop.ZIndex = 11 delayDrop.Parent = Popup Instance.new("UICorner", delayDrop) local dropList = Instance.new("Frame") dropList.Size = UDim2.new(0, 90, 0, 196) dropList.Position = UDim2.new(0, 106, 0, 152) dropList.BackgroundColor3 = Color3.fromRGB(40, 40, 55) dropList.Visible = false dropList.ZIndex = 15 dropList.Parent = Popup Instance.new("UICorner", dropList) makeDropdown(delayDrop, dropList, DelayUnits, data.delayUnit or "Ms", function(u) data.delayUnit = u end) local keyBtn = Instance.new("TextButton") keyBtn.Size = UDim2.new(1, -16, 0, 32) keyBtn.Position = UDim2.new(0, 8, 0, 162) keyBtn.Text = "Key: " .. (data.keybind and data.keybind.Name or "F") keyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55) keyBtn.TextColor3 = Color3.new(1, 1, 1) keyBtn.Font = Enum.Font.Gotham keyBtn.TextSize = 13 * DPI keyBtn.ZIndex = 11 keyBtn.Parent = Popup Instance.new("UICorner", keyBtn) local waiting = false keyBtn.MouseButton1Click:Connect(function() if waiting then return end waiting = true keyBtn.Text = "Press any key..." local c = nil c = UserInputService.InputBegan:Connect(function(inp) if inp.KeyCode ~= Enum.KeyCode.Unknown then data.keybind = inp.KeyCode keyBtn.Text = "Key: " .. inp.KeyCode.Name waiting = false c:Disconnect() end end) end) local stopAfterLabel = Instance.new("TextLabel") stopAfterLabel.Size = UDim2.new(1, -16, 0, 24) stopAfterLabel.Position = UDim2.new(0, 8, 0, 196) stopAfterLabel.BackgroundTransparency = 1 stopAfterLabel.Text = "Stop after" stopAfterLabel.TextColor3 = Color3.fromRGB(200, 200, 200) stopAfterLabel.Font = Enum.Font.GothamBold stopAfterLabel.TextSize = 14 * DPI stopAfterLabel.TextXAlignment = Enum.TextXAlignment.Left stopAfterLabel.ZIndex = 11 stopAfterLabel.Parent = Popup local radioRows = {} local function updateRadios() for _, row in ipairs(radioRows) do local radio = row:FindFirstChild("RadioBtn") local bg = row:FindFirstChild("CircleBg") local mode = row:FindFirstChild("Mode") if radio and bg and mode then local sel = mode.Value == data.stopMode radio.Text = sel and FILLED or OPEN bg.BackgroundColor3 = sel and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 70, 70) end end end local function makeRadio(y, txt, mode) local row = Instance.new("Frame") row.Size = UDim2.new(1, -16, 0, 32) row.Position = UDim2.new(0, 8, 0, y) row.BackgroundTransparency = 1 row.ZIndex = 11 row.Parent = Popup local bg = Instance.new("Frame") bg.Name = "CircleBg" bg.Size = UDim2.new(0, 28, 0, 28) bg.Position = UDim2.new(0, 0, 0, 2) bg.BackgroundColor3 = data.stopMode == mode and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(70, 70, 70) bg.ZIndex = 11 bg.Parent = row Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 14) local radio = Instance.new("TextButton") radio.Name = "RadioBtn" radio.Size = UDim2.new(0, 28, 0, 28) radio.Position = UDim2.new(0, 0, 0, 2) radio.BackgroundTransparency = 1 radio.Text = data.stopMode == mode and FILLED or OPEN radio.TextColor3 = Color3.new(1, 1, 1) radio.Font = Enum.Font.Code radio.TextSize = 22 * DPI radio.ZIndex = 12 radio.Parent = row local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, -36, 1, 0) lbl.Position = UDim2.new(0, 36, 0, 0) lbl.BackgroundTransparency = 1 lbl.Text = txt lbl.TextColor3 = Color3.new(1, 1, 1) lbl.Font = Enum.Font.Gotham lbl.TextSize = 13 * DPI lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 11 lbl.Parent = row radio.MouseButton1Click:Connect(function() data.stopMode = mode updateRadios() end) local modeVal = Instance.new("StringValue") modeVal.Name = "Mode" modeVal.Value = mode modeVal.Parent = row table.insert(radioRows, row) return row end local timeRow = makeRadio(220, "Amount of time", "time") local cycleRow = makeRadio(256, "Number of cycles", "cycles") makeRadio(292, "Run indefinitely", "indefinitely") local timeInput = Instance.new("TextBox") timeInput.Size = UDim2.new(0, 70, 0, 28) timeInput.Position = UDim2.new(0, 130, 0, 2) timeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55) timeInput.TextColor3 = Color3.new(1, 1, 1) timeInput.Font = Enum.Font.Gotham timeInput.TextSize = 13 * DPI if data.stopMode == "time" and data.stopTime then local unit = data.stopTimeUnit or "Second" local val = data.stopTime / toSeconds(1, unit) timeInput.Text = tostring(math.floor(val + 0.5)) else timeInput.Text = "5" timeInput.PlaceholderText = "Time value" end timeInput.ClearTextOnFocus = false timeInput.ZIndex = 11 timeInput.Parent = timeRow Instance.new("UICorner", timeInput) local timeDrop = Instance.new("TextButton") timeDrop.Size = UDim2.new(0, 70, 0, 28) timeDrop.Position = UDim2.new(0, 208, 0, 2) timeDrop.BackgroundColor3 = Color3.fromRGB(50, 50, 70) timeDrop.TextColor3 = Color3.new(1, 1, 1) timeDrop.Font = Enum.Font.GothamBold timeDrop.TextSize = 13 * DPI timeDrop.Text = data.stopTimeUnit or "Second" timeDrop.ZIndex = 11 timeDrop.Parent = timeRow Instance.new("UICorner", timeDrop) local tList = Instance.new("Frame") tList.Size = UDim2.new(0, 70, 0, 224) tList.Position = UDim2.new(0, 208, 0, 30) tList.BackgroundColor3 = Color3.fromRGB(40, 40, 55) tList.Visible = false tList.ZIndex = 15 tList.Parent = timeRow Instance.new("UICorner", tList) makeDropdown(timeDrop, tList, TimeUnits, data.stopTimeUnit or "Second", function(u) data.stopTimeUnit = u end) local cycleInput = Instance.new("TextBox") cycleInput.Size = UDim2.new(0, 100, 0, 28) cycleInput.Position = UDim2.new(0, 150, 0, 2) cycleInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55) cycleInput.TextColor3 = Color3.new(1, 1, 1) cycleInput.Font = Enum.Font.Gotham cycleInput.TextSize = 13 * DPI cycleInput.Text = tostring(data.stopCycles or 10) cycleInput.ClearTextOnFocus = false cycleInput.ZIndex = 11 cycleInput.Parent = cycleRow Instance.new("UICorner", cycleInput) local save = Instance.new("TextButton") save.Size = UDim2.new(0.5, -12, 0, 36) save.Position = UDim2.new(0, 8, 1, -44) save.BackgroundColor3 = Color3.fromRGB(0, 200, 0) save.Text = isEdit and "Update" or "Create" save.TextColor3 = Color3.new(1, 1, 1) save.Font = Enum.Font.GothamBold save.TextSize = 15 * DPI save.ZIndex = 11 save.Parent = Popup Instance.new("UICorner", save) local cancel = Instance.new("TextButton") cancel.Size = UDim2.new(0.5, -12, 0, 36) cancel.Position = UDim2.new(0.5, 4, 1, -44) cancel.BackgroundColor3 = Color3.fromRGB(150, 150, 150) cancel.Text = "Cancel" cancel.TextColor3 = Color3.new(1, 1, 1) cancel.Font = Enum.Font.GothamBold cancel.TextSize = 15 * DPI cancel.ZIndex = 11 cancel.Parent = Popup Instance.new("UICorner", cancel) cancel.MouseButton1Click:Connect(function() closeAllDropdowns() Popup:Destroy(); Popup = nil end) local function updateSaveBtn() local hasCmd = cmdBox.Text:match("^%s*(.-)%s*$") ~= "" save.BackgroundColor3 = hasCmd and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100) save.TextColor3 = hasCmd and Color3.new(1, 1, 1) or Color3.fromRGB(180, 180, 180) end cmdBox:GetPropertyChangedSignal("Text"):Connect(updateSaveBtn) updateSaveBtn() save.MouseButton1Click:Connect(function() local cmd = cmdBox.Text:match("^%s*(.-)%s*$") if cmd == "" then return end local name = nameBox.Text ~= "" and nameBox.Text or "Macro" local dVal = tonumber(delayVal.Text) or 1 local newData = { name = name, command = cmd, delayValue = dVal, delayUnit = delayDrop.Text, keybind = data.keybind, stopMode = data.stopMode, stopTime = nil, stopTimeUnit = nil, stopCycles = nil, } if data.stopMode == "time" then local val = tonumber(timeInput.Text) or 5 local unit = timeDrop.Text newData.stopTime = toSeconds(val, unit) newData.stopTimeUnit = unit elseif data.stopMode == "cycles" then newData.stopCycles = tonumber(cycleInput.Text) or 10 end if isEdit then if editData.running and editData.stopMacro then editData.stopMacro() end if editData.connections then for _, c in ipairs(editData.connections) do if c.Connected then pcall(c.Disconnect, c) end end end oldFrame:Destroy() table.remove(Macros, oldIdx) end table.insert(Macros, newData) makeEntry(newData, #Macros) updateNoMacrosLabel() updateCanvas() closeAllDropdowns() Popup:Destroy(); Popup = nil end) updateRadios() local cam = workspace.CurrentCamera local scale = math.min(1, cam.ViewportSize.X * 0.7 / (360 * DPI), cam.ViewportSize.Y * 0.7 / (460 * DPI)) Instance.new("UIScale", Popup).Scale = scale end ConfigPopup = nil ConfigScroll = nil PresetConfirmPopup = nil SaveAsPopup = nil selectedPresetRow = nil function highlightPresetRow(row, selected) if selected then row.BackgroundColor3 = Color3.fromRGB(0, 120, 255) else row.BackgroundColor3 = Color3.fromRGB(40, 40, 55) end end function showPresetDeleteConfirm(presetName, row) if PresetConfirmPopup then PresetConfirmPopup:Destroy() end PresetConfirmPopup = Instance.new("Frame") PresetConfirmPopup.Name = "PresetDeleteConfirm" PresetConfirmPopup.Size = UDim2.new(0, 260 * DPI, 0, 130 * DPI) PresetConfirmPopup.Position = UDim2.new(0.5, 0, 0.5, 0) PresetConfirmPopup.AnchorPoint = Vector2.new(0.5, 0.5) PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) PresetConfirmPopup.ZIndex = 40 PresetConfirmPopup.Parent = ScreenGui Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0, 12) local msg = Instance.new("TextLabel") msg.Text = "Delete preset '" .. presetName .. "'?" msg.Size = UDim2.new(1, -20, 0, 50) msg.Position = UDim2.new(0, 10, 0, 10) msg.BackgroundTransparency = 1 msg.TextColor3 = Color3.new(1, 1, 1) msg.Font = Enum.Font.GothamBold msg.TextSize = 15 * DPI msg.TextWrapped = true msg.ZIndex = 41 msg.Parent = PresetConfirmPopup local yes = Instance.new("TextButton") yes.Size = UDim2.new(0.45, 0, 0, 32) yes.Position = UDim2.new(0.05, 0, 1, -40) yes.BackgroundColor3 = Color3.fromRGB(255, 50, 50) yes.Text = "Yes" yes.TextColor3 = Color3.new(1, 1, 1) yes.Font = Enum.Font.GothamBold yes.TextSize = 13 * DPI yes.ZIndex = 41 yes.Parent = PresetConfirmPopup Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 8) local no = Instance.new("TextButton") no.Size = UDim2.new(0.45, 0, 0, 32) no.Position = UDim2.new(0.5, 0, 1, -40) no.BackgroundColor3 = Color3.fromRGB(100, 100, 100) no.Text = "No" no.TextColor3 = Color3.new(1, 1, 1) no.Font = Enum.Font.GothamBold no.TextSize = 13 * DPI no.ZIndex = 41 no.Parent = PresetConfirmPopup Instance.new("UICorner", no).CornerRadius = UDim.new(0, 8) no.MouseButton1Click:Connect(function() PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil end) yes.MouseButton1Click:Connect(function() Presets[presetName] = nil savePresets() row:Destroy() PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil end) end function showPresetLoadConfirm(presetName, presetData) if PresetConfirmPopup then PresetConfirmPopup:Destroy() end PresetConfirmPopup = Instance.new("Frame") PresetConfirmPopup.Name = "PresetLoadConfirm" PresetConfirmPopup.Size = UDim2.new(0, 260 * DPI, 0, 130 * DPI) PresetConfirmPopup.Position = UDim2.new(0.5, 0, 0.5, 0) PresetConfirmPopup.AnchorPoint = Vector2.new(0.5, 0.5) PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) PresetConfirmPopup.ZIndex = 40 PresetConfirmPopup.Parent = ScreenGui Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0, 12) local msg = Instance.new("TextLabel") msg.Text = "Loading '" .. presetName .. "' will replace current macros. Continue?" msg.Size = UDim2.new(1, -20, 0, 50) msg.Position = UDim2.new(0, 10, 0, 10) msg.BackgroundTransparency = 1 msg.TextColor3 = Color3.new(1, 1, 1) msg.Font = Enum.Font.GothamBold msg.TextSize = 15 * DPI msg.TextWrapped = true msg.ZIndex = 41 msg.Parent = PresetConfirmPopup local yes = Instance.new("TextButton") yes.Size = UDim2.new(0.45, 0, 0, 32) yes.Position = UDim2.new(0.05, 0, 1, -40) yes.BackgroundColor3 = Color3.fromRGB(0, 170, 255) yes.Text = "Yes" yes.TextColor3 = Color3.new(1, 1, 1) yes.Font = Enum.Font.GothamBold yes.TextSize = 13 * DPI yes.ZIndex = 41 yes.Parent = PresetConfirmPopup Instance.new("UICorner", yes).CornerRadius = UDim.new(0, 8) local no = Instance.new("TextButton") no.Size = UDim2.new(0.45, 0, 0, 32) no.Position = UDim2.new(0.5, 0, 1, -40) no.BackgroundColor3 = Color3.fromRGB(100, 100, 100) no.Text = "No" no.TextColor3 = Color3.new(1, 1, 1) no.Font = Enum.Font.GothamBold no.TextSize = 13 * DPI no.ZIndex = 41 no.Parent = PresetConfirmPopup Instance.new("UICorner", no).CornerRadius = UDim.new(0, 8) no.MouseButton1Click:Connect(function() PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil end) yes.MouseButton1Click:Connect(function() Macros = table.clone(presetData) for _, c in ipairs(Scroll:GetChildren()) do if c:IsA("Frame") and c.Name:match("^MacroEntry_") then c:Destroy() end end for i, m in ipairs(Macros) do makeEntry(m, i) end updateNoMacrosLabel() updateCanvas() ConfigPopup:Destroy(); ConfigPopup = nil PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil end) end function showPresetSaveConflict(presetName, input, saveBtn, defaultName) if PresetConfirmPopup then PresetConfirmPopup:Destroy() end PresetConfirmPopup = Instance.new("Frame") PresetConfirmPopup.Name = "PresetSaveConflict" PresetConfirmPopup.Size = UDim2.new(0, 280 * DPI, 0, 150 * DPI) PresetConfirmPopup.Position = UDim2.new(0.5, 0, 0.5, 0) PresetConfirmPopup.AnchorPoint = Vector2.new(0.5, 0.5) PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) PresetConfirmPopup.ZIndex = 50 PresetConfirmPopup.Parent = ScreenGui Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0, 12) local msg = Instance.new("TextLabel") msg.Text = "Preset '" .. presetName .. "' already exists." msg.Size = UDim2.new(1, -20, 0, 40) msg.Position = UDim2.new(0, 10, 0, 10) msg.BackgroundTransparency = 1 msg.TextColor3 = Color3.new(1, 1, 1) msg.Font = Enum.Font.GothamBold msg.TextSize = 15 * DPI msg.TextWrapped = true msg.ZIndex = 51 msg.Parent = PresetConfirmPopup local replace = Instance.new("TextButton") replace.Size = UDim2.new(0.3, 0, 0, 32) replace.Position = UDim2.new(0.05, 0, 1, -40) replace.BackgroundColor3 = Color3.fromRGB(255, 170, 0) replace.Text = "Replace" replace.TextColor3 = Color3.new(1, 1, 1) replace.Font = Enum.Font.GothamBold replace.TextSize = 13 * DPI replace.ZIndex = 51 replace.Parent = PresetConfirmPopup Instance.new("UICorner", replace).CornerRadius = UDim.new(0, 8) local rename = Instance.new("TextButton") rename.Size = UDim2.new(0.35, 0, 0, 32) rename.Position = UDim2.new(0.36, 0, 1, -40) rename.BackgroundColor3 = Color3.fromRGB(0, 170, 255) rename.Text = "Rename" rename.TextColor3 = Color3.new(1, 1, 1) rename.Font = Enum.Font.GothamBold rename.TextSize = 13 * DPI rename.ZIndex = 51 rename.Parent = PresetConfirmPopup Instance.new("UICorner", rename).CornerRadius = UDim.new(0, 8) local cancel = Instance.new("TextButton") cancel.Size = UDim2.new(0.3, 0, 0, 32) cancel.Position = UDim2.new(0.72, 0, 1, -40) cancel.BackgroundColor3 = Color3.fromRGB(100, 100, 100) cancel.Text = "Cancel" cancel.TextColor3 = Color3.new(1, 1, 1) cancel.Font = Enum.Font.GothamBold cancel.TextSize = 13 * DPI cancel.ZIndex = 51 cancel.Parent = PresetConfirmPopup Instance.new("UICorner", cancel).CornerRadius = UDim.new(0, 8) cancel.MouseButton1Click:Connect(function() input:Destroy() saveBtn:Destroy() PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil end) local function performSave(finalName) Presets[finalName] = table.clone(Macros) savePresets() input:Destroy() saveBtn:Destroy() PresetConfirmPopup:Destroy(); PresetConfirmPopup = nil openConfigPopup() end replace.MouseButton1Click:Connect(function() performSave(presetName) end) rename.MouseButton1Click:Connect(function() local newName = presetName local i = 1 while Presets[newName] do newName = presetName .. " (" .. i .. ")" i = i + 1 end performSave(newName) end) end function showSaveAsPopup() if SaveAsPopup then SaveAsPopup:Destroy() end if ConfigPopup then ConfigPopup:Destroy() end selectedPresetRow = nil local defaultName = "Preset " .. os.date("%H-%M-%S") SaveAsPopup = Instance.new("Frame") SaveAsPopup.Name = "SaveAsPopup" SaveAsPopup.Size = UDim2.new(0, 360 * DPI, 0, 400 * DPI) SaveAsPopup.Position = UDim2.new(0.5, 0, 0.5, 0) SaveAsPopup.AnchorPoint = Vector2.new(0.5, 0.5) SaveAsPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) SaveAsPopup.ZIndex = 30 SaveAsPopup.Parent = ScreenGui Instance.new("UICorner", SaveAsPopup).CornerRadius = UDim.new(0, 12) local pTitle = Instance.new("TextLabel") pTitle.Size = UDim2.new(1, 0, 0, 36) pTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 55) pTitle.Text = "Save As" pTitle.TextColor3 = Color3.new(1, 1, 1) pTitle.Font = Enum.Font.GothamBold pTitle.TextSize = 16 * DPI pTitle.ZIndex = 31 pTitle.Parent = SaveAsPopup Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0, 12) local existingScroll = Instance.new("ScrollingFrame") existingScroll.Name = "ExistingPresetsScroll" existingScroll.Size = UDim2.new(1, -16, 0, 200) existingScroll.Position = UDim2.new(0, 8, 0, 44) existingScroll.BackgroundTransparency = 1 existingScroll.ScrollBarThickness = 5 existingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y existingScroll.ZIndex = 31 existingScroll.Parent = SaveAsPopup local existingLayout = Instance.new("UIListLayout", existingScroll) existingLayout.Padding = UDim.new(0, 6) local input = nil for presetName, _ in pairs(Presets) do local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 30) row.BackgroundColor3 = Color3.fromRGB(40, 40, 55) row.ZIndex = 32 row.Parent = existingScroll Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6) local label = Instance.new("TextButton") label.Text = presetName label.Size = UDim2.new(1, -16, 1, 0) label.Position = UDim2.new(0, 8, 0, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.Font = Enum.Font.Gotham label.TextSize = 13 * DPI label.TextXAlignment = Enum.TextXAlignment.Left label.ZIndex = 33 label.Parent = row label.MouseButton1Click:Connect(function() if selectedPresetRow then highlightPresetRow(selectedPresetRow, false) end selectedPresetRow = row highlightPresetRow(row, true) input.Text = presetName end) end local inputLabel = Instance.new("TextLabel") inputLabel.Text = "Enter preset name" inputLabel.Size = UDim2.new(1, -16, 0, 24) inputLabel.Position = UDim2.new(0, 8, 0, 260) inputLabel.BackgroundTransparency = 1 inputLabel.TextColor3 = Color3.fromRGB(200, 200, 200) inputLabel.Font = Enum.Font.Gotham inputLabel.TextSize = 14 * DPI inputLabel.ZIndex = 31 inputLabel.Parent = SaveAsPopup input = Instance.new("TextBox") input.Text = "" input.ClearTextOnFocus = false input.PlaceholderText = defaultName input.Size = UDim2.new(1, -16, 0, 32) input.Position = UDim2.new(0, 8, 0, 284) input.BackgroundColor3 = Color3.fromRGB(50, 50, 70) input.TextColor3 = Color3.new(1, 1, 1) input.Font = Enum.Font.Gotham input.TextSize = 13 * DPI input.ZIndex = 31 input.Parent = SaveAsPopup Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8) local saveBtn = Instance.new("TextButton") saveBtn.Size = UDim2.new(0.5, -12, 0, 36) saveBtn.Position = UDim2.new(0, 8, 1, -44) saveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) saveBtn.Text = "Save" saveBtn.TextColor3 = Color3.new(1, 1, 1) saveBtn.Font = Enum.Font.GothamBold saveBtn.TextSize = 15 * DPI saveBtn.ZIndex = 31 saveBtn.Parent = SaveAsPopup Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8) local cancelBtn = Instance.new("TextButton") cancelBtn.Size = UDim2.new(0.5, -12, 0, 36) cancelBtn.Position = UDim2.new(0.5, 4, 1, -44) cancelBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150) cancelBtn.Text = "Cancel" cancelBtn.TextColor3 = Color3.new(1, 1, 1) cancelBtn.Font = Enum.Font.GothamBold cancelBtn.TextSize = 15 * DPI cancelBtn.ZIndex = 31 cancelBtn.Parent = SaveAsPopup Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0, 8) cancelBtn.MouseButton1Click:Connect(function() SaveAsPopup:Destroy(); SaveAsPopup = nil openConfigPopup() end) saveBtn.MouseButton1Click:Connect(function() local presetName = input.Text:match("^%s*(.-)%s*$") if presetName == "" then presetName = defaultName end if Presets[presetName] then showPresetSaveConflict(presetName, input, saveBtn, defaultName) else Presets[presetName] = table.clone(Macros) savePresets() SaveAsPopup:Destroy(); SaveAsPopup = nil openConfigPopup() end end) local cam = workspace.CurrentCamera local scale = math.min(1, cam.ViewportSize.X * 0.7 / (360 * DPI), cam.ViewportSize.Y * 0.7 / (400 * DPI)) Instance.new("UIScale", SaveAsPopup).Scale = scale end function openConfigPopup() if ConfigPopup then ConfigPopup:Destroy() end ConfigPopup = Instance.new("Frame") ConfigPopup.Size = UDim2.new(0, 360 * DPI, 0, 400 * DPI) ConfigPopup.Position = UDim2.new(0.5, 0, 0.5, 0) ConfigPopup.AnchorPoint = Vector2.new(0.5, 0.5) ConfigPopup.BackgroundColor3 = Color3.fromRGB(30, 30, 40) ConfigPopup.ZIndex = 30 ConfigPopup.Parent = ScreenGui Instance.new("UICorner", ConfigPopup).CornerRadius = UDim.new(0, 12) local pTitle = Instance.new("TextLabel") pTitle.Size = UDim2.new(1, 0, 0, 36) pTitle.BackgroundColor3 = Color3.fromRGB(35, 35, 55) pTitle.Text = "Macro Presets" pTitle.TextColor3 = Color3.new(1, 1, 1) pTitle.Font = Enum.Font.GothamBold pTitle.TextSize = 16 * DPI pTitle.ZIndex = 31 pTitle.Parent = ConfigPopup Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0, 12) ConfigScroll = Instance.new("ScrollingFrame") ConfigScroll.Size = UDim2.new(1, -16, 1, -88) ConfigScroll.Position = UDim2.new(0, 8, 0, 44) ConfigScroll.BackgroundTransparency = 1 ConfigScroll.ScrollBarThickness = 5 ConfigScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y ConfigScroll.ZIndex = 31 ConfigScroll.Parent = ConfigPopup local cfgLayout = Instance.new("UIListLayout", ConfigScroll) cfgLayout.Padding = UDim.new(0, 6) local saveAsBtn = Instance.new("TextButton") saveAsBtn.Size = UDim2.new(0.5, -12, 0, 36) saveAsBtn.Position = UDim2.new(0, 8, 1, -44) saveAsBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255) saveAsBtn.Text = "Save As" saveAsBtn.TextColor3 = Color3.new(1, 1, 1) saveAsBtn.Font = Enum.Font.GothamBold saveAsBtn.TextSize = 15 * DPI saveAsBtn.ZIndex = 31 saveAsBtn.Parent = ConfigPopup Instance.new("UICorner", saveAsBtn).CornerRadius = UDim.new(0, 8) local closeCfgBtn = Instance.new("TextButton") closeCfgBtn.Size = UDim2.new(0.5, -12, 0, 36) closeCfgBtn.Position = UDim2.new(0.5, 4, 1, -44) closeCfgBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150) closeCfgBtn.Text = "Close" closeCfgBtn.TextColor3 = Color3.new(1, 1, 1) closeCfgBtn.Font = Enum.Font.GothamBold closeCfgBtn.TextSize = 15 * DPI closeCfgBtn.ZIndex = 31 closeCfgBtn.Parent = ConfigPopup Instance.new("UICorner", closeCfgBtn).CornerRadius = UDim.new(0, 8) closeCfgBtn.MouseButton1Click:Connect(function() ConfigPopup:Destroy(); ConfigPopup = nil end) saveAsBtn.MouseButton1Click:Connect(function() showSaveAsPopup() end) for presetName, presetData in pairs(Presets) do local row = Instance.new("Frame") row.Size = UDim2.new(1, 0, 0, 40) row.BackgroundColor3 = Color3.fromRGB(40, 40, 55) row.ZIndex = 32 row.Parent = ConfigScroll Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8) local label = Instance.new("TextLabel") label.Text = presetName label.Size = UDim2.new(0.6, 0, 1, 0) label.Position = UDim2.new(0, 8, 0, 0) label.BackgroundTransparency = 1 label.TextColor3 = Color3.new(1, 1, 1) label.Font = Enum.Font.Gotham label.TextSize = 13 * DPI label.TextXAlignment = Enum.TextXAlignment.Left label.ZIndex = 33 label.Parent = row local loadBtn = Instance.new("TextButton") loadBtn.Size = UDim2.new(0, 60, 0, 28) loadBtn.Position = UDim2.new(1, -130, 0, 6) loadBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0) loadBtn.Text = "Load" loadBtn.TextColor3 = Color3.new(1, 1, 1) loadBtn.Font = Enum.Font.GothamBold loadBtn.TextSize = 12 * DPI loadBtn.ZIndex = 33 loadBtn.Parent = row Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6) local delBtn = Instance.new("TextButton") delBtn.Size = UDim2.new(0, 60, 0, 28) delBtn.Position = UDim2.new(1, -65, 0, 6) delBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) delBtn.Text = "Delete" delBtn.TextColor3 = Color3.new(1, 1, 1) delBtn.Font = Enum.Font.GothamBold delBtn.TextSize = 12 * DPI delBtn.ZIndex = 33 delBtn.Parent = row Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6) loadBtn.MouseButton1Click:Connect(function() showPresetLoadConfirm(presetName, presetData) end) delBtn.MouseButton1Click:Connect(function() showPresetDeleteConfirm(presetName, row) end) end local cam = workspace.CurrentCamera local scale = math.min(1, cam.ViewportSize.X * 0.7 / (360 * DPI), cam.ViewportSize.Y * 0.7 / (400 * DPI)) Instance.new("UIScale", ConfigPopup).Scale = scale end ConfigBtn.MouseButton1Click:Connect(openConfigPopup) CreateBtn.MouseButton1Click:Connect(function() CmdEditMacro() end) updateNoMacrosLabel() updateCanvas() local cam = workspace.CurrentCamera local scale = math.min(1, cam.ViewportSize.X * 0.7 / (380 * DPI), cam.ViewportSize.Y * 0.7 / (480 * DPI)) local uiScale = Instance.new("UIScale", Main) uiScale.Scale = scale
-- Top bar buttons
local TopbarSettings = {TopbarAnimation = false, TopbarLockValue = false} local isButtonLocked = {} local currentMouseHold = {} local activeKeybinds = {} local createdButtons = {} function UpdateAllButtons() if not TopbarSettings.TopbarLockValue then for key, _ in pairs(isButtonLocked) do if isButtonLocked[key] then game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(key, false) end isButtonLocked[key] = nil activeKeybinds[key] = nil end else for key, _ in pairs(currentMouseHold) do if currentMouseHold[key] then game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(key, false) end currentMouseHold[key] = nil end end for key, buttonData in pairs(createdButtons) do if buttonData and buttonData.updateVisualState then pcall(buttonData.updateVisualState) end end end local player = game.Players.LocalPlayer local starterGui = game:GetService("StarterGui") local TweenService = game:GetService("TweenService") local playerGui = player:WaitForChild("PlayerGui") if playerGui:FindFirstChild("CustomTopGui") then playerGui:FindFirstChild("CustomTopGui"):Destroy() end starterGui:SetCore("TopbarEnabled", false) local screenGui = Instance.new("ScreenGui") screenGui.Name = "CustomTopGui" screenGui.IgnoreGuiInset = false screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets screenGui.DisplayOrder = 100 screenGui.ResetOnSpawn = false screenGui.Parent = playerGui local frame = Instance.new("Frame") frame.Parent = screenGui frame.BackgroundTransparency = 1 frame.BorderSizePixel = 0 frame.Position = UDim2.new(0, 0, 0, 0) frame.Size = UDim2.new(1, 0, 1, -2) local scrollingFrame = Instance.new("ScrollingFrame") scrollingFrame.Name = "Right" scrollingFrame.Parent = frame scrollingFrame.BackgroundTransparency = 1 scrollingFrame.BorderSizePixel = 0 scrollingFrame.Position = UDim2.new(0, 12, 0, 0) scrollingFrame.Size = UDim2.new(1, -24, 1, 0) scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X scrollingFrame.ScrollBarThickness = 0 scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X scrollingFrame.ScrollingEnabled = false local uiListLayout = Instance.new("UIListLayout") uiListLayout.Parent = scrollingFrame uiListLayout.Padding = UDim.new(0, 12) uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder uiListLayout.FillDirection = Enum.FillDirection.Horizontal uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom local keybindButtonsConfig = { { name = "ReloadButton", layoutOrder = 997, icon = "rbxassetid://78648212535999", label = "Look Behind/Reload", width = 173, labelWidth = 118, key = "Reload", enablesLockValue = true }, { name = "LeaderboardButton", layoutOrder = 998, icon = "rbxassetid://5107166345", label = "Leaderboard", width = 143, labelWidth = 88, key = "Leaderboard", enablesLockValue = true }, { name = "SecondaryButton", layoutOrder = 999, icon = "rbxassetid://126943351764139", label = "Zoom", width = 100, labelWidth = 45, key = "Secondary", enablesLockValue = true } } if player:GetAttribute("CommandsAccess") == true then table.insert( keybindButtonsConfig, 1, { name = "VIPMenuButton", layoutOrder = 999, icon = "", label = "VIP", width = 80, labelWidth = 35, key = "VIPMenu", enablesLockValue = true, alwaysShowText = true } ) end function createKeybindButton(config) local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) local Button = Instance.new("Frame") Button.Name = config.name Button.Parent = scrollingFrame Button.BackgroundTransparency = 1 Button.ClipsDescendants = true Button.LayoutOrder = config.layoutOrder if config.alwaysShowText then Button.Size = UDim2.new(0, config.width, 0, 44) else Button.Size = UDim2.new(0, 44, 0, 44) end Button.ZIndex = 20 local IconButton = Instance.new("Frame") IconButton.Name = "IconButton" IconButton.Parent = Button IconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) IconButton.BackgroundTransparency = 0.3 IconButton.BorderSizePixel = 0 IconButton.ClipsDescendants = true IconButton.Size = UDim2.new(1, 0, 1, 0) IconButton.ZIndex = 2 local UICorner = Instance.new("UICorner") UICorner.CornerRadius = UDim.new(1, 0) UICorner.Parent = IconButton local Menu = Instance.new("ScrollingFrame") Menu.Name = "Menu" Menu.Parent = IconButton Menu.BackgroundTransparency = 1 Menu.BorderSizePixel = 0 Menu.Position = UDim2.new(0, 4, 0, 0) Menu.Selectable = false Menu.Size = UDim2.new(1, 0, 1, 0) Menu.ZIndex = 20 Menu.BottomImage = "" Menu.CanvasSize = UDim2.new(0, 0, 1, -1) Menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always Menu.ScrollBarThickness = 0 Menu.TopImage = "" local MenuUIListLayout = Instance.new("UIListLayout") MenuUIListLayout.Name = "MenuUIListLayout" MenuUIListLayout.Parent = Menu MenuUIListLayout.FillDirection = Enum.FillDirection.Horizontal MenuUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder MenuUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center local IconSpot = Instance.new("Frame") IconSpot.Name = "IconSpot" IconSpot.Parent = Menu IconSpot.AnchorPoint = Vector2.new(0, 0.5) IconSpot.BackgroundColor3 = Color3.fromRGB(255, 255, 255) IconSpot.BackgroundTransparency = 1 IconSpot.Position = UDim2.new(0, 4, 0.5, 0) if config.alwaysShowText then IconSpot.Size = UDim2.new(0, config.width - 8, 1, -8) else IconSpot.Size = UDim2.new(0, 36, 1, -8) end IconSpot.ZIndex = 5 local UICorner_2 = Instance.new("UICorner") UICorner_2.CornerRadius = UDim.new(1, 0) UICorner_2.Parent = IconSpot local IconOverlay = Instance.new("Frame") IconOverlay.Name = "IconOverlay" IconOverlay.Parent = IconSpot IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255) IconOverlay.BackgroundTransparency = 0.925 IconOverlay.Size = UDim2.new(1, 0, 1, 0) IconOverlay.Visible = false IconOverlay.ZIndex = 6 local UICorner_3 = Instance.new("UICorner") UICorner_3.CornerRadius = UDim.new(1, 0) UICorner_3.Parent = IconOverlay local ClickRegion = Instance.new("TextButton") ClickRegion.Name = "ClickRegion" ClickRegion.Parent = IconSpot ClickRegion.BackgroundTransparency = 1 ClickRegion.Size = UDim2.new(1, 0, 1, 0) ClickRegion.ZIndex = 20 ClickRegion.Text = "" local UICorner_4 = Instance.new("UICorner") UICorner_4.CornerRadius = UDim.new(1, 0) UICorner_4.Parent = ClickRegion local Contents = Instance.new("Frame") Contents.Name = "Contents" Contents.Parent = IconSpot Contents.BackgroundTransparency = 1 Contents.Size = UDim2.new(1, 0, 1, 0) local ContentsList = Instance.new("UIListLayout") ContentsList.Name = "ContentsList" ContentsList.Parent = Contents ContentsList.FillDirection = Enum.FillDirection.Horizontal ContentsList.HorizontalAlignment = Enum.HorizontalAlignment.Center ContentsList.SortOrder = Enum.SortOrder.LayoutOrder ContentsList.VerticalAlignment = Enum.VerticalAlignment.Center ContentsList.Padding = UDim.new(0, 3) local IconLabelContainer = Instance.new("Frame") IconLabelContainer.Name = "IconLabelContainer" IconLabelContainer.Parent = Contents IconLabelContainer.AnchorPoint = Vector2.new(0, 0.5) IconLabelContainer.BackgroundTransparency = 1 IconLabelContainer.LayoutOrder = 4 IconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0) if config.alwaysShowText then IconLabelContainer.Size = UDim2.new(0, config.labelWidth, 1, 0) IconLabelContainer.Visible = true else IconLabelContainer.Size = UDim2.new(0, 0, 1, 0) IconLabelContainer.Visible = false end IconLabelContainer.ZIndex = 3 local IconLabel = Instance.new("TextLabel") IconLabel.Name = "IconLabel" IconLabel.Parent = IconLabelContainer IconLabel.BackgroundTransparency = 1 IconLabel.LayoutOrder = 4 IconLabel.Size = UDim2.new(1, 0, 1, 0) IconLabel.ZIndex = 15 IconLabel.Font = Enum.Font.GothamMedium IconLabel.Text = config.label IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255) IconLabel.TextSize = 16 IconLabel.TextWrapped = false if config.alwaysShowText then IconLabel.TextXAlignment = Enum.TextXAlignment.Center IconLabel.Visible = true else IconLabel.TextXAlignment = Enum.TextXAlignment.Left IconLabel.Visible = false end if config.icon ~= "" then local IconImage = Instance.new("ImageLabel") IconImage.Name = "IconImage" IconImage.Parent = Contents IconImage.AnchorPoint = Vector2.new(0, 0.5) IconImage.BackgroundTransparency = 1 IconImage.LayoutOrder = 2 IconImage.Position = UDim2.new(0, 11, 0.5, 0) IconImage.Size = UDim2.new(0.7, 0, 0.7, 0) IconImage.ZIndex = 15 IconImage.Image = config.icon local IconImageRatio = Instance.new("UIAspectRatioConstraint") IconImageRatio.Name = "IconImageRatio" IconImageRatio.Parent = IconImage IconImageRatio.DominantAxis = Enum.DominantAxis.Height end local IconSpotGradient = Instance.new("UIGradient") IconSpotGradient.Color = ColorSequence.new { ColorSequenceKeypoint.new(0.00, Color3.fromRGB(96, 98, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(77, 78, 80)) } IconSpotGradient.Rotation = 45 IconSpotGradient.Name = "IconSpotGradient" IconSpotGradient.Parent = IconSpot local isHovering = false local smallButtonSize = UDim2.new(0, 44, 0, 44) local largeButtonSize = UDim2.new(0, config.width, 0, 44) local smallIconSpotSize = UDim2.new(0, 36, 1, -8) local largeIconSpotSize = UDim2.new(0, config.width - 8, 1, -8) local smallLabelSize = UDim2.new(0, 0, 1, 0) local largeLabelSize = UDim2.new(0, config.labelWidth, 1, 0) local function getIsActive() if TopbarSettings.TopbarLockValue then return isButtonLocked[config.key] or false else return currentMouseHold[config.key] or false end end local function updateVisualState() if config.alwaysShowText then IconOverlay.Visible = getIsActive() else IconOverlay.Visible = getIsActive() or isHovering end end local function hideTextWithDelay() if config.alwaysShowText then return end task.spawn( function() task.wait(0.2) if not isHovering and not getIsActive() then IconLabel.Visible = false IconLabelContainer.Visible = false end end ) end local function expand() if config.alwaysShowText then return end isHovering = true updateVisualState() IconLabel.Visible = true IconLabelContainer.Visible = true if TopbarSettings.TopbarAnimation then TweenService:Create(Button, tweenInfo, {Size = largeButtonSize}):Play() TweenService:Create(IconSpot, tweenInfo, {Size = largeIconSpotSize}):Play() TweenService:Create(IconLabelContainer, tweenInfo, {Size = largeLabelSize}):Play() else IconLabel.Visible = false IconLabelContainer.Visible = false end end local function contract() if config.alwaysShowText then return end isHovering = false updateVisualState() if TopbarSettings.TopbarAnimation then TweenService:Create(Button, tweenInfo, {Size = smallButtonSize}):Play() TweenService:Create(IconSpot, tweenInfo, {Size = smallIconSpotSize}):Play() TweenService:Create(IconLabelContainer, tweenInfo, {Size = smallLabelSize}):Play() hideTextWithDelay() else IconLabel.Visible = false IconLabelContainer.Visible = false end end if not config.alwaysShowText then ClickRegion.MouseEnter:Connect(expand) ClickRegion.MouseLeave:Connect( function() contract() if not TopbarSettings.TopbarLockValue and currentMouseHold[config.key] then currentMouseHold[config.key] = false game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(config.key, false) end end ) end if config.enablesLockValue then ClickRegion.MouseButton1Click:Connect( function() if TopbarSettings.TopbarLockValue then isButtonLocked[config.key] = not isButtonLocked[config.key] game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire( config.key, isButtonLocked[config.key] ) activeKeybinds[config.key] = isButtonLocked[config.key] or nil updateVisualState() end end ) ClickRegion.MouseButton1Down:Connect( function() if not TopbarSettings.TopbarLockValue then currentMouseHold[config.key] = true game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(config.key, true) updateVisualState() end end ) ClickRegion.MouseButton1Up:Connect( function() if not TopbarSettings.TopbarLockValue and currentMouseHold[config.key] then currentMouseHold[config.key] = false game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire(config.key, false) updateVisualState() end end ) end createdButtons[config.key] = {Button = Button, updateVisualState = updateVisualState} end for _, config in ipairs(keybindButtonsConfig) do createKeybindButton(config) end
 WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Localization setup
-- Set WindUI properties
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Create WindUI window
 Window = WindUI:CreateWindow({
 NewElements = true,
 Title = "Dara Hub | Evade Legacy",
 Icon = "rbxassetid://137330250139083",
 Author = [[Made by: Pnsdg And Yomka.
  Rewiring from Overhaul.lua]],
 Folder = "DaraHub/Games/Evade-Legacy",
 Size = UDim2.fromOffset(580, 490),
 Theme = "Dark",
 HidePanelBackground = false,
 Acrylic = false,
 HideSearchBar = false,
 SideBarWidth = 200,
 OpenButton = {
 Enabled = false,
  Scale = 0
 },
})

Window:SetIconSize(48)
Window:Tag({
 Title = "V1.0.1",
 Color = Color3.fromHex("#30ff6a")
})
executor = identifyexecutor()
if type(executor) == "table" then
 for key, value in pairs(executor) do
  print(key .. ": " .. tostring(value))
 end
elseif type(executor) == "string" then
 Window:Tag({
  Title = "" .. executor
 })
else
 print("The injector does not support identifyexecutor()")
end
--[[
Window:Tag({
Title = "Beta",
Color = Color3.fromHex("#000111")
})
]]
Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "layout-grid" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Auto = Window:Tab({ Title = "Auto", Icon = "repeat-2" }),
    Combat = Window:Tab({ Title = "Combat", Icon = "sword" }),
    Visuals = Window:Tab({ Title = "Visuals", Icon = "camera" }),
    ESP = Window:Tab({ Title = "ESP", Icon = "eye" }),
    Utility = Window:Tab({ Title = "Utility", Icon = "wrench" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "navigation" }),
    Settings = Window:Tab({ Title = "Settings", Icon = "settings" }),
    info = Window:Tab({ Title = "info", Icon = "info" })
}
local socialsModule = loadstring(game:HttpGet("https://darahub.vercel.app/Module/info.lua"))()

socialsModule(Tabs)

Window:OnOpen(function()
game:GetService("CoreGui").Darahub.FloatingButton_Darahub.Visible = false
end)
Window:OnClose(function()
    game:GetService("CoreGui").Darahub.FloatingButton_Darahub.Visible = true
end)
Window:OnDestroy(function()
    game:GetService("CoreGui").Darahub.FloatingButton_Darahub:Destroy()
end)
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local originalGameGravity = workspace.Gravity
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local placeId = game.PlaceId
local jobId = game.JobId
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local featureStates = {
 AutoWhistle = false,
 CustomGravity = false,
 GravityValue = originalGameGravity,
 InfiniteJump = false,
 Fly = false,
 TPWALK = false,
 JumpBoost = false,
 AntiAFK = false,
 AutoCarry = false,
 NoFog = false,
 AutoVote = false,
 AutoSelfRevive = false,
 AutoRevive = false,
 FastRevive = false,
 PlayerESP = {
  boxes = false,
  tracers = false,
  names = false,
  distance = false,
  rainbowBoxes = false,
  rainbowTracers = false,
  boxType = "2D",
 },
 EnemyESP = {
  boxes = false,
  tracers = false,
  names = false,
  distance = false,
  rainbowBoxes = false,
  rainbowTracers = false,
  boxType = "2D",
 },
 DownedBoxESP = false,
 DownedTracer = false,
 DownedNameESP = false,
 DownedDistanceESP = false,
 DownedBoxType = "2D",
 FlySpeed = 5,
 TpwalkValue = 1,
 JumpPower = 5,
 JumpMethod = "Hold",
 SelectedMap = 1,
 ZoomValue = 1,
 TimerDisplay = false
}
-- Variables
local character, humanoid, rootPart
local bodyVelocity, bodyGyro
local ToggleTpwalk = false
local TpwalkConnection
if not featureStates.AntiEnemyDistance then
 featureStates.AntiEnemyDistance = 50
end

local farmsSuppressedByAntiEnemy = false
local antiEnemyConnection = nil
local jumpCount = 0
local MAX_JUMPS = math.huge

local AntiAFKConnection

local AutoCarryConnection

-- Visual Variables
local originalBrightness = Lighting.Brightness
local originalFogEnd = Lighting.FogEnd
local originalOutdoorAmbient = Lighting.OutdoorAmbient
local originalAmbient = Lighting.Ambient
local originalGlobalShadows = Lighting.GlobalShadows
local originalAtmospheres = {}

for _, v in pairs(Lighting:GetDescendants()) do
 if v:IsA("Atmosphere") then
  table.insert(originalAtmospheres, v)
 end
end
function startNoFog()
 originalFogEnd = Lighting.FogEnd
 Lighting.FogEnd = 1000000
 for _, v in pairs(Lighting:GetDescendants()) do
  if v:IsA("Atmosphere") then
  v:Destroy()
  end
 end
end

function isPlayerDowned(pl)
 if not pl or not pl.Character then return false end
 local char = pl.Character
 local humanoid = char:FindFirstChild("Humanoid")
 if humanoid and humanoid.Health <= 0 then
  return true
 end
 if char.GetAttribute and char:GetAttribute("Downed") == true then
  return true
 end
 return false
end
function isPlayerDowned(pl)
 local char = pl.Character
 if char and char:FindFirstChild("Humanoid") then
  local humanoid = char.Humanoid
  return humanoid.Health <= 0 or char:GetAttribute("Downed") == true
 end
 return false
end

function Tpwalking()
 if ToggleTpwalk and character and humanoid and rootPart then
  local moveDirection = humanoid.MoveDirection
  local moveDistance = featureStates.TpwalkValue
  local origin = rootPart.Position
  local direction = moveDirection * moveDistance
  local targetPosition = origin + direction
  local raycastParams = RaycastParams.new()
  raycastParams.FilterDescendantsInstances = {character}
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude
  local raycastResult = workspace:Raycast(origin, direction, raycastParams)
  if raycastResult then
  local hitPosition = raycastResult.Position
  local distanceToHit = (hitPosition - origin).Magnitude
  if distanceToHit < math.abs(moveDistance) then
 targetPosition = origin + (direction.Unit * (distanceToHit - 0.1))
  end
  end
  rootPart.CFrame = CFrame.new(targetPosition) * rootPart.CFrame.Rotation
  rootPart.CanCollide = true
 end
end

function startTpwalk()
 ToggleTpwalk = true
 if TpwalkConnection then
  TpwalkConnection:Disconnect()
 end
 TpwalkConnection = RunService.Heartbeat:Connect(Tpwalking)
end

function stopTpwalk()
 ToggleTpwalk = false
 if TpwalkConnection then
  TpwalkConnection:Disconnect()
  TpwalkConnection = nil
 end
 if rootPart then
  rootPart.CanCollide = false
 end
end

function setupJumpBoost()
 if not character or not humanoid then return end
 humanoid.StateChanged:Connect(function(oldState, newState)
  if newState == Enum.HumanoidStateType.Landed then
  jumpCount = 0
  end
 end)
 humanoid.Jumping:Connect(function(isJumping)
  if isJumping and featureStates.JumpBoost and jumpCount < MAX_JUMPS then
  jumpCount = jumpCount + 1
  humanoid.JumpHeight = featureStates.JumpPower
  if jumpCount > 1 then
 rootPart:ApplyImpulse(Vector3.new(0, featureStates.JumpPower * rootPart.Mass, 0))
  end
  end
 end)
end
if featureStates.CustomGravity then
 workspace.Gravity = featureStates.GravityValue
else
 workspace.Gravity = originalGameGravity
end
if not featureStates.GravityValue or type(featureStates.GravityValue) ~= "number" then
 featureStates.GravityValue = originalGameGravity
end
function reapplyFeatures()
    if featureStates.AutoWhistle then
        stopAutoWhistle()
        startAutoWhistle()
    end
end
function startJumpBoost()
 if humanoid then
  humanoid.JumpPower = featureStates.JumpPower
 end
end

function stopJumpBoost()
 jumpCount = 0
 if humanoid then
  humanoid.JumpPower = 50
 end
end

function startAntiAFK()
 AntiAFKConnection = player.Idled:Connect(function()
  VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
  task.wait(1)
  VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
 end)
end

function stopAntiAFK()
 if AntiAFKConnection then
  AntiAFKConnection:Disconnect()
  AntiAFKConnection = nil
 end
end
function stopNoFog()
 Lighting.FogEnd = originalFogEnd
 for _, atmosphere in pairs(originalAtmospheres) do
  if not atmosphere.Parent then
  local newAtmosphere = Instance.new("Atmosphere")
  for _, prop in pairs({"Density", "Offset", "Color", "Decay", "Glare", "Haze"}) do
 if atmosphere[prop] then
  newAtmosphere[prop] = atmosphere[prop]
 end
  end
  newAtmosphere.Parent = Lighting
  end
 end
end


function getServerLink()
 local placeId = game.PlaceId
 local jobId = game.JobId
 return string.format("https://darahub.vercel.app/roblox-launch.html?placeId=%d&gameInstanceId=%s", placeId, jobId)
end
function getLaunchID()
 local placeId = game.PlaceId
 local jobId = game.JobId
 return string.format("roblox://placeId=%d&gameInstanceId=%s", placeId, jobId)
end
 local request = request({
  Url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=100",
  Method = "GET",
 })

 if request.StatusCode == 200 then
  local serverData = HttpService:JSONDecode(request.Body)
  local serverList = {}

  for _, server in pairs(serverData.data) do
  if server.id ~= jobId and server.playing < server.maxPlayers then
 local serverInfo = {
  serverId = server.id or "N/A",
  players = server.playing or 0,
  maxPlayers = server.maxPlayers or 0,
  ping = server.ping or "N/A",
 }
 table.insert(serverList, serverInfo)
  end
  end
  return serverList
 else
  return {}
 end

function serverHop()

local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local S_T = game:GetService("TeleportService")
local S_H = game:GetService("HttpService")

local File = pcall(function()
	AllIDs = S_H:JSONDecode(readfile("server-hop-temp.json"))
end)
if not File then
	table.insert(AllIDs, actualHour)
	pcall(function()
		writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
	end)

end
function TPReturner(placeId)
	local Site;
	if foundAnything == "" then
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
	else
		Site = S_H:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
	end
	local ID = ""
	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
		foundAnything = Site.nextPageCursor
	end
	local num = 0;
	for i,v in pairs(Site.data) do
		local Possible = true
		ID = tostring(v.id)
		if tonumber(v.maxPlayers) > tonumber(v.playing) then
			for _,Existing in pairs(AllIDs) do
				if num ~= 0 then
					if ID == tostring(Existing) then
						Possible = false
					end
				else
					if tonumber(actualHour) ~= tonumber(Existing) then
						local delFile = pcall(function()
							delfile("server-hop-temp.json")
							AllIDs = {}
							table.insert(AllIDs, actualHour)
						end)
					end
				end
				num = num + 1
			end
			if Possible == true then
				table.insert(AllIDs, ID)
				wait()
				pcall(function()
					writefile("server-hop-temp.json", S_H:JSONEncode(AllIDs))
					wait()
					S_T:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
				end)
				wait(4)
			end
		end
	end
end
local module = {}
function module:Teleport(placeId)
	while wait() do
		pcall(function()
			TPReturner(placeId)
			if foundAnything ~= "" then
				TPReturner(placeId)
			end
		end)
	end
end
module:Teleport(game.PlaceId)
return module
end


function rejoinServer()

local player = Players.LocalPlayer

TeleportService:Teleport(game.PlaceId, player)
end

-- Main Tab
Tabs.Main:Section({ Title = "Server Info", TextSize = 20 })
Tabs.Main:Divider()

local placeName = "Unknown"
local success, productInfo = pcall(function()
 return MarketplaceService:GetProductInfo(placeId)
end)
if success and productInfo then
 placeName = productInfo.Name
end

Tabs.Main:Paragraph({
 Title = "Game Mode",
 Desc = placeName
})


Tabs.Main:Button({
 Title = "Copy Server Link",
 Desc = "Copy the current server's join link",
 Icon = "link",
 Callback = function()
 local serverLink = getServerLink()
 pcall(function()
 setclipboard(serverLink)
 end)
 WindUI:Notify({
 Icon = "link",
 Title = "Link Copied",
 Content = "The server invite link has been copied to your clipborad",
 Duration = 3
 })
 end
})
Tabs.Main:Button({
 Title = "Copy  Launch ID",
 Desc = "Copy the current server's join link",
 Icon = "link",
 Callback = function()
 local  LaunchID = get LaunchID()
 pcall(function()
 setclipboard( LaunchID)
 end)
 WindUI:Notify({
 Icon = "link",
 Title = "Link Copied",
 Content = "The server invite launch id has been copied to your clipborad",
 Duration = 3
 })
 end
})
local numPlayers = #Players:GetPlayers()
local maxPlayers = Players.MaxPlayers

Tabs.Main:Paragraph({
 Title = "Current Players",
 Desc = numPlayers .. " / " .. maxPlayers
})

Tabs.Main:Paragraph({
 Title = "Server ID",
 Desc = jobId
})

Tabs.Main:Paragraph({
 Title = "Place ID",
 Desc = tostring(placeId)
})

Tabs.Main:Section({ Title = "Server Tools", TextSize = 20 })
Tabs.Main:Divider()

Tabs.Main:Button({
 Title = "Rejoin",
 Desc = "Rejoin the current server",
 Icon = "refresh-cw",
 Callback = function()
  rejoinServer()
 end
})

Tabs.Main:Button({
 Title = "Server Hop",
 Desc = "Hop to a random server",
 Icon = "shuffle",
 Callback = function()
  serverHop()
 end
})

Tabs.Main:Button({
 Title = "Hop to Small Server",
 Desc = "Hop to the smallest available server",
 Icon = "minimize",
 Callback = function()
  hopToSmallServer()
 end
})

Tabs.Main:Button({
 Title = "Advanced Server Hop",
 Desc = "Finding a Server inside your game",
 Icon = "server",
 Callback = function()
 local success, result = pcall(function()
   local script = loadstring(game:HttpGet("https://raw.githubusercontent.com/Pnsdgsa/Script-kids/refs/heads/main/Advanced%20Server%20Hop.lua"))()
 end)
 if not success then
   WindUI:Notify({
 Title = "Error",
 Content = "Oopsie Daisy Some thing wrong happening with the Github Repository link, Unfortunately this script no longer exsit: " .. tostring(result),
 Duration = 4
   })
 else
   WindUI:Notify({
 Title = "Success",
 Content = "All server are Loaded",
 Duration = 3
   })
 end
 end
   })
   AutoServerHopEnabled = false
AutoServerHopInterval = 30
AutoServerHopTimer = nil
AutoServerHopType = "Random"
lastHopTime = 0

function stopAutoServerHop()
 if AutoServerHopTimer then
  AutoServerHopTimer:Disconnect()
  AutoServerHopTimer = nil
 end
 AutoServerHopEnabled = false
end

function startAutoServerHop()
 if AutoServerHopTimer then
  AutoServerHopTimer:Disconnect()
 end
 AutoServerHopEnabled = true
 lastHopTime = tick()
 AutoServerHopTimer = game:GetService("RunService").Heartbeat:Connect(function()
  if tick() - lastHopTime >= AutoServerHopInterval then
  lastHopTime = tick()
  if AutoServerHopType == "Small" then
 pcall(function()
  if type(hopToSmallServer) == "function" then
  hopToSmallServer()
  else
  serverHop()
  end
 end)
  else
 pcall(serverHop)
  end
  WindUI:Notify({
 Title = "Auto Server Hop",
 Content = "Hopping to " .. (AutoServerHopType == "Small" and "small" or "random") .. " server...",
 Duration = 3
  })
  end
 end)
end
Tabs.Main:Space()
AutoServerHopToggle = Tabs.Main:Toggle({
 Title = "Auto Server Hop",
 Flag = "AutoServerHopToggle",
 Value = false,
 Callback = function(state)
  if state then
  if AutoServerHopInterval < 20 then
 WindUI:Notify({
  Title = "Auto Server Hop",
  Content = "Interval must be at least 20 seconds!",
  Duration = 3
 })
 if AutoServerHopToggle and AutoServerHopToggle.Set then
  AutoServerHopToggle:Set(false)
 end
 return
  end
  startAutoServerHop()
  else
  stopAutoServerHop()
  end
 end
})

AutoServerHopTypeDropdown = Tabs.Main:Dropdown({
 Title = "Server Hop Type",
 Flag = "AutoServerHopTypeDropdown",
 Desc = "Choose between small or random server hopping",
 Values = {"Random", "Small"},
 Value = "Random",
 Callback = function(value)
  AutoServerHopType = value
  if AutoServerHopEnabled then
  stopAutoServerHop()
  startAutoServerHop()
  end
 end
})

AutoServerHopIntervalInput = Tabs.Main:Input({
 Title = "Hop Interval (seconds)",
 Flag = "AutoServerHopIntervalInput",
 Desc = "Minimum 20 seconds",
 Placeholder = "30",
 NumbersOnly = true,
 Value = "30",
 Callback = function(value)
  local num = tonumber(value)
  if num and num >= 20 then
  AutoServerHopInterval = num
  if AutoServerHopEnabled then
 stopAutoServerHop()
 startAutoServerHop()
  end
  else
  WindUI:Notify({
 Title = "Auto Server Hop",
 Content = "Interval must be at least 20 seconds!",
 Duration = 3
  })
  AutoServerHopIntervalInput:Set("30")
  AutoServerHopInterval = 30
  end
 end
})
Tabs.Main:Section({ Title = "Misc", TextSize = 20 })
Tabs.Main:Divider()

 AntiAFKToggle = Tabs.Main:Toggle({
  Title = "Anti AFK",
  Flag = "AntiAFKToggle",
  Value = false,
  Callback = function(state)
  featureStates.AntiAFK = state
  if state then
 startAntiAFK()
  else
 stopAntiAFK()
  end
  end
 })
 local PathfindingService=game:GetService("PathfindingService")featureStates.AntiEnemy=false;featureStates.AntiEnemyDistance=50;local function isEnemyModel(model)return model:FindFirstChild("Humanoid")and not game.Players:GetPlayerFromCharacter(model)end;local function handleAntiEnemy()if not featureStates.AntiEnemy then return end;local character=game.Players.LocalPlayer.Character;local humanoidRootPart=character and character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return end;local Enemys={};local NPCStorageFolder=workspace:FindFirstChild("NPCStorage")if NPCStorageFolder then for _,model in ipairs(NPCStorageFolder:GetChildren())do if model:IsA("Model")and isEnemyModel(model)then local hrp=model:FindFirstChild("HumanoidRootPart")if hrp then table.insert(Enemys,model)end end end end;local playersFolder=workspace:FindFirstChild("Game")and workspace.Game:FindFirstChild("Players")if playersFolder then for _,model in ipairs(playersFolder:GetChildren())do if model:IsA("Model")and isEnemyModel(model)then local hrp=model:FindFirstChild("HumanoidRootPart")if hrp then table.insert(Enemys,model)end end end end;for _,Enemy in ipairs(Enemys)do local EnemyHrp=Enemy:FindFirstChild("HumanoidRootPart")if EnemyHrp then local distance=(humanoidRootPart.Position-EnemyHrp.Position).Magnitude;if distance<=featureStates.AntiEnemyDistance then local direction=(humanoidRootPart.Position-EnemyHrp.Position).Unit;local targetPos=humanoidRootPart.Position+direction*30;local path=PathfindingService:CreatePath({AgentRadius=2,AgentHeight=5,AgentCanJump=true})local success,errorMessage=pcall(function()path:ComputeAsync(humanoidRootPart.Position,targetPos)end)if success and path.Status==Enum.PathStatus.Success then local waypoints=path:GetWaypoints()if#waypoints>1 then local lastValidPos=waypoints[#waypoints].Position;humanoidRootPart.CFrame=CFrame.new(lastValidPos+Vector3.new(0,3,0))end else humanoidRootPart.CFrame=CFrame.new(targetPos+Vector3.new(0,3,0))end;break end end end end;task.spawn(function()while true do if featureStates.AntiEnemy then pcall(handleAntiEnemy)end;task.wait(0.1)end end)Tabs.Main:Space()AntiEnemyToggle=Tabs.Main:Toggle({Title="Anti-Enemy",Flag="AntiEnemyToggle",Desc="Automatically teleport away from nearby enemies",Value=false,Callback=function(state)featureStates.AntiEnemy=state end})AntiEnemyDistanceInput=Tabs.Main:Input({Title="Anti-Enemy Distance",Flag="AntiEnemyDistanceInput",Desc="Distance threshold for enemy detection",Placeholder="50",NumbersOnly=true,Callback=function(value)local num=tonumber(value)if num and num>0 then featureStates.AntiEnemyDistance=num end end})
featureStates.AntiNPCSpawn=false;featureStates.AntiNPCSpawnType="Spawn";featureStates.AntiNPCSpawnDistance=40;featureStates.AntiNPCTeleportDistance=20;local NPCSpawnConnection=nil;local lastAvoidanceTime=0;local avoidanceCooldown=2;local function findSafeTeleportPositionReverse(startPos,targetPos)local raycastParams=RaycastParams.new()raycastParams.FilterType=Enum.RaycastFilterType.Blacklist;raycastParams.FilterDescendantsInstances={game.Players.LocalPlayer.Character}local direction=(targetPos-startPos).Unit;local maxDistance=(targetPos-startPos).Magnitude;for distance=maxDistance,0,-5 do local testPos=startPos+(direction*distance)local downRay=workspace:Raycast(testPos+Vector3.new(0,10,0),Vector3.new(0,-20,0),raycastParams)if downRay then local groundPos=downRay.Position+Vector3.new(0,3,0)local upRay=workspace:Raycast(groundPos,Vector3.new(0,6,0),raycastParams)if not upRay then local sideRays={Vector3.new(3,0,0),Vector3.new(-3,0,0),Vector3.new(0,0,3),Vector3.new(0,0,-3)}local isSafe=true;for _,sideDir in ipairs(sideRays)do local sideRay=workspace:Raycast(groundPos,sideDir,raycastParams)if sideRay and sideRay.Instance.CanCollide then isSafe=false;break end end;if isSafe then return groundPos end end end end;return nil end;local function teleportToSpawn()local spawnsFolder=workspace:FindFirstChild("Game")and workspace.Game:FindFirstChild("Map")and workspace.Game.Map:FindFirstChild("Parts")and workspace.Game.Map.Parts:FindFirstChild("Spawns")if spawnsFolder then local spawnLocations=spawnsFolder:GetChildren()if#spawnLocations>0 then local character=game.Players.LocalPlayer.Character;local humanoidRootPart=character and character:FindFirstChild("HumanoidRootPart")if humanoidRootPart then for i=1,math.min(3,#spawnLocations)do local randomSpawn=spawnLocations[math.random(1,#spawnLocations)]local targetPosition=randomSpawn.CFrame.Position+Vector3.new(0,3,0)local safePosition=findSafeTeleportPositionReverse(humanoidRootPart.Position,targetPosition)if safePosition then humanoidRootPart.CFrame=CFrame.new(safePosition)return true end end end end end;return false end;local function teleportToPlayer()local players=game:GetService("Players"):GetPlayers()local validPlayers={}for _,plr in ipairs(players)do if plr~=game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")then table.insert(validPlayers,plr)end end;if#validPlayers>0 then local character=game.Players.LocalPlayer.Character;local humanoidRootPart=character and character:FindFirstChild("HumanoidRootPart")if humanoidRootPart then for i=1,math.min(3,#validPlayers)do local randomPlayer=validPlayers[math.random(1,#validPlayers)]local targetPosition=randomPlayer.Character.HumanoidRootPart.Position+Vector3.new(0,3,0)local safePosition=findSafeTeleportPositionReverse(humanoidRootPart.Position,targetPosition)if safePosition then humanoidRootPart.CFrame=CFrame.new(safePosition)return true end end end end;return false end;local function teleportToDistance()local spawnMarker=workspace:FindFirstChild("Game")and workspace.Game:FindFirstChild("Effects")and workspace.Game.Effects:FindFirstChild("BotSpawnMarker")if not spawnMarker then return teleportToSpawn()end;local character=game.Players.LocalPlayer.Character;local humanoidRootPart=character and character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return false end;local direction=(humanoidRootPart.Position-spawnMarker.Position).Unit;local targetPos=humanoidRootPart.Position+direction*featureStates.AntiNPCTeleportDistance;local safePosition=findSafeTeleportPositionReverse(humanoidRootPart.Position,targetPos)if safePosition then humanoidRootPart.CFrame=CFrame.new(safePosition)return true else return teleportToSpawn()end end;local function isPlayerNearSpawn()local spawnMarker=workspace:FindFirstChild("Game")and workspace.Game:FindFirstChild("Effects")and workspace.Game.Effects:FindFirstChild("BotSpawnMarker")if not spawnMarker or not game.Players.LocalPlayer.Character then return false end;local humanoidRootPart=game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")if not humanoidRootPart then return false end;local distance=(humanoidRootPart.Position-spawnMarker.Position).Magnitude;return distance<=featureStates.AntiNPCSpawnDistance end;local function performAvoidance()if not game.Players.LocalPlayer.Character then return end;local success=false;if featureStates.AntiNPCSpawnType=="Spawn"then success=teleportToSpawn()elseif featureStates.AntiNPCSpawnType=="Player"then success=teleportToPlayer()else success=teleportToDistance()end end;local function startAntiNPC()if NPCSpawnConnection then NPCSpawnConnection:Disconnect()end;NPCSpawnConnection=game:GetService("RunService").Heartbeat:Connect(function()if not featureStates.AntiNPCSpawn or not game.Players.LocalPlayer.Character then return end;if tick()-lastAvoidanceTime<avoidanceCooldown then return end;if isPlayerNearSpawn()then performAvoidance()lastAvoidanceTime=tick()end end)end;AntiNPCSpawnToggle=Tabs.Main:Toggle({Title="Anti NPC Spawn",Flag="AntiNPCSpawnToggle",Desc="Automatically avoid NPC spawn areas",Value=false,Callback=function(state)featureStates.AntiNPCSpawn=state;if state then startAntiNPC()else if NPCSpawnConnection then NPCSpawnConnection:Disconnect()NPCSpawnConnection=nil end end end})AntiNPCSpawnTypeDropdown=Tabs.Main:Dropdown({Title="Avoidance Mode",Flag="AntiNPCSpawnTypeDropdown",Desc="Choose how to avoid NPC spawn",Values={"Spawn","Player","Distance"},Value="Spawn",Callback=function(value)featureStates.AntiNPCSpawnType=value end})AntiNPCSpawnDistanceInput=Tabs.Main:Input({Title="Avoidance Distance",Flag="AntiNPCSpawnDistanceInput",Desc="Distance to trigger avoidance (studs)",Placeholder="40",NumbersOnly=true,Callback=function(value)local distance=tonumber(value)if distance and distance>0 then featureStates.AntiNPCSpawnDistance=distance end end})AntiNPCTeleportDistanceInput=Tabs.Main:Input({Title="Teleport Distance",Flag="AntiNPCTeleportDistanceInput",Desc="How far to teleport in Distance mode (studs)",Placeholder="20",NumbersOnly=true,Callback=function(value)local distance=tonumber(value)if distance and distance>0 then featureStates.AntiNPCTeleportDistance=distance end end})game.Players.LocalPlayer.CharacterAdded:Connect(function()if featureStates.AntiNPCSpawn then task.wait(1)if not NPCSpawnConnection then startAntiNPC()end end end)
Tabs.Main:Section({Title="Emote Crouch",TextSize=20});Tabs.Main:Divider();local p=game:GetService("Players").LocalPlayer;local emoteData={};local function scanEmotes()for i=1,8 do local attr=p:GetAttribute("Emote"..i)emoteData[i]={Slot=i,Name=attr or ""}end end;scanEmotes();local dropdownOptions={};for i=1,8 do if emoteData[i].Name~=""then table.insert(dropdownOptions,"Slot"..i.." "..emoteData[i].Name)end end;local selectedValues={};local dropdown=Tabs.Main:Dropdown({Title="Select Emote Slot(s)",Options=dropdownOptions,Multi=true,AllowNone=true,Callback=function(values)selectedValues=values end});local function updateDropdown()scanEmotes();dropdownOptions={};for i=1,8 do if emoteData[i].Name~=""then table.insert(dropdownOptions,"Slot"..i.." "..emoteData[i].Name)end end;dropdown:Refresh(dropdownOptions,true)end;local function monitorAttributes()while true do task.wait(0.5);for i=1,8 do local attr=p:GetAttribute("Emote"..i)if attr~=emoteData[i].Name then updateDropdown()break end end end end;task.spawn(monitorAttributes);local function triggerRandomEmote()pcall(function()game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed:Fire("Crouch",true)end);task.wait(0.1);local validSlots={};if#selectedValues>0 then for _,slotText in pairs(selectedValues)do local slotNum=tonumber(string.match(slotText,"Slot(%d+)"))if slotNum and emoteData[slotNum]and emoteData[slotNum].Name~=""then table.insert(validSlots,tostring(slotNum))end end else for i=1,8 do if emoteData[i]and emoteData[i].Name~=""then table.insert(validSlots,tostring(i))end end end;if#validSlots>0 then local randomSlot=validSlots[math.random(1,#validSlots)];pcall(function()game:GetService("ReplicatedStorage").Events.Emote:FireServer(randomSlot)end)end end;ButtonLib.Create:Button({Text="Emote Crouch",Flag="EmoteCrouch",Visible=false,Callback=function()triggerRandomEmote()end}).Position=UDim2.new(0.5,-125,0.2,0);EmoteCrouchToggle=Tabs.Main:Toggle({Title="Emote Crouch",Flag="EmoteCrouchToggle",Desc="Select emote slot(s) or leave empty for random",Value=false,Callback=function(state)featureStates.EmoteCrouchEnabled=state;if _G.DarahubLibBtn and _G.DarahubLibBtn.EmoteCrouch then _G.DarahubLibBtn.EmoteCrouch.Visible=state end end})

Tabs.Main:Section({ Title = "TAS", TextSize = 20 })
Tabs.Main:Divider()
Running = false
Frames = {}
TimeStart = tick()

Player = game:GetService("Players").LocalPlayer
getChar = function()
 Character = Player.Character
 if Character then
  return Character
 else
  Player.CharacterAdded:Wait()
  return getChar()
 end
end

StartRecord = function()
 Frames = {}
 Running = true
 TimeStart = tick()
 while Running == true do
  game:GetService("RunService").Heartbeat:wait()
  Character = getChar()
  table.insert(Frames, {
  Character.HumanoidRootPart.CFrame,
  Character.Humanoid:GetState().Value,
  tick() - TimeStart
  })
 end
end

StopRecord = function()
 Running = false
end

PlayTAS = function()
 Character = getChar()
 TimePlay = tick()
 FrameCount = #Frames
 OldFrame = 1
 TASLoop = game:GetService("RunService").Heartbeat:Connect(function()
  CurrentTime = tick()
  if (CurrentTime - TimePlay) >= Frames[FrameCount][3] then
  TASLoop:Disconnect()
  return
  end
  for i = OldFrame, math.min(OldFrame + 60, FrameCount) do
  Frame = Frames[i]
  if Frame and Frame[3] <= (CurrentTime - TimePlay) then
 OldFrame = i
 Character.HumanoidRootPart.CFrame = Frame[1]
 Character.Humanoid:ChangeState(Frame[2])
  end
  end
 end)
end



Tabs.Main:Button({ Title = "Start recording", Color = Color3.fromHex("#30FF6A"), Callback = StartRecord })
Tabs.Main:Button({ Title = "Stop recording",  Color = Color3.fromHex("#ff4830"), Callback = StopRecord })
Tabs.Main:Button({ Title = "Play",  Color = Color3.fromHex("#30FF6A"), Callback = PlayTAS })
   -- Player Tabs
   Tabs.Player:Section({ Title = "Player", TextSize = 40 })
 Tabs.Player:Divider()
BounceSystem = {
    Config = {
        VelocityMultiplier = 80,
        MinSpeed = 20,
        MinPartDistance = 0.5,
        MaxPartBelow = 0.4,
        Cooldown = 0.5,
        Enabled = false
    },
    
    State = {
        LastBoostTime = 0,
        Player = nil,
        Character = nil,
        Humanoid = nil
    }
}

Tabs.Player:Section({ Title = "Bounce: IDk how to make it better like draconic", TextSize = 15 })
Tabs.Player:Divider()
BounceToggle = Tabs.Player:Toggle({
    Title = "Bounce Multiplier",
    Flag = "BounceEnabled",
    Value = BounceSystem.Config.Enabled,
    Callback = function(state)
        BounceSystem.Config.Enabled = state
        if state then
            BounceSystem:Initialize()
        end
    end
})

VelocityMultiplierInput = Tabs.Player:Input({
    Title = "Multiplier value",
    Flag = "VelocityMultiplier",
    Placeholder = "80",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BounceSystem.Config.VelocityMultiplier = num
        end
    end
})

MinSpeedInput = Tabs.Player:Input({
    Title = "Minimum Speed",
    Flag = "MinSpeed",
    Placeholder = "20",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BounceSystem.Config.MinSpeed = num
        end
    end
})

CooldownInput = Tabs.Player:Input({
    Title = "Bounce Cooldown",
    Flag = "BounceCooldown",
    Placeholder = "0.5",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            BounceSystem.Config.Cooldown = num
        end
    end
})

MinDistanceInput = Tabs.Player:Input({
    Title = "Min Edge Distance",
    Flag = "MinEdgeDistance",
    Placeholder = "0.5",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BounceSystem.Config.MinPartDistance = num
        end
    end
})

MaxIgnoreInput = Tabs.Player:Input({
    Title = "Max Ignore Height",
    Flag = "MaxIgnoreHeight",
    Placeholder = "0.4",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            BounceSystem.Config.MaxPartBelow = num
        end
    end
})
Tabs.Player:Space()
function BounceSystem:GetHorizontalSpeed()
    if not self.State.Humanoid or not self.State.Humanoid.RootPart then return 0 end
    local velocity = self.State.Humanoid.RootPart.Velocity
    return Vector3.new(velocity.X, 0, velocity.Z).Magnitude
end

function BounceSystem:ShouldIgnorePart(part)
    if part.CanCollide == false then return true end
    if part.Transparency > 0.9 then return true end
    if part.Size.Magnitude < 1 then return true end
    if part:GetAttribute("NoBoost") == true then return true end
    return false
end

function BounceSystem:ApplyVelocityBoost()
    if not self.Config.Enabled then return end
    
    local currentTime = tick()
    if currentTime - self.State.LastBoostTime < self.Config.Cooldown then return end
    
    local rootPart = self.State.Humanoid.RootPart
    if not rootPart then return end
    
    local currentVelocity = rootPart.Velocity
    local boostAmount = self.Config.VelocityMultiplier
    
    local newYVelocity = currentVelocity.Y + boostAmount
    
    rootPart.Velocity = Vector3.new(
        currentVelocity.X,
        newYVelocity,
        currentVelocity.Z
    )
    
    self.State.LastBoostTime = currentTime
end

function BounceSystem:OnPartTouched(otherPart)
    if not self.Config.Enabled then return end
    if otherPart:IsDescendantOf(self.State.Character) then return end
    if self:ShouldIgnorePart(otherPart) then return end
    
    local currentTime = tick()
    if currentTime - self.State.LastBoostTime < self.Config.Cooldown then return end
    if self:GetHorizontalSpeed() < self.Config.MinSpeed then return end
    
    local rootPart = self.State.Humanoid.RootPart
    if not rootPart then return end
    
    local playerPosition = rootPart.Position
    local partPosition = otherPart.Position
    local partSize = otherPart.Size
    
    local partTopY = partPosition.Y + (partSize.Y / 2)
    local playerBottomY = playerPosition.Y - self.State.Humanoid.HipHeight
    
    local heightDifference = playerBottomY - partTopY
    if heightDifference > 0 and heightDifference <= self.Config.MaxPartBelow then return end
    
    if playerBottomY > partTopY then
        local foundEdge = false
        
        local rayDirections = {
            Vector3.new(2, 0, 0),
            Vector3.new(-2, 0, 0),
            Vector3.new(0, 0, 2),
            Vector3.new(0, 0, -2),
        }
        
        for _, direction in ipairs(rayDirections) do
            local rayStart = Vector3.new(
                partPosition.X + direction.X,
                partTopY + 2,
                partPosition.Z + direction.Z
            )
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {self.State.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            
            local ray = workspace:Raycast(rayStart, Vector3.new(0, -5, 0), raycastParams)
            
            if ray then
                if ray.Instance and ray.Instance.CanCollide == false then
                    continue
                end
                
                local groundY = ray.Position.Y
                local heightDiff = math.abs(partTopY - groundY)
                
                if heightDiff >= self.Config.MinPartDistance then
                    foundEdge = true
                    break
                end
            else
                foundEdge = true
                break
            end
        end
        
        if foundEdge then
            self:ApplyVelocityBoost()
        end
    end
end

function BounceSystem:SetupTouchEvents()
    for _, part in ipairs(self.State.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Touched:Connect(function(otherPart)
                self:OnPartTouched(otherPart)
            end)
        end
    end
    
    if self.State.Humanoid.RootPart then
        self.State.Humanoid.RootPart.Touched:Connect(function(otherPart)
            self:OnPartTouched(otherPart)
        end)
    end
end

function BounceSystem:Initialize()
    if not self.Config.Enabled then return end
    
    self.State.Player = game.Players.LocalPlayer
    self.State.Character = self.State.Player.Character or self.State.Player.CharacterAdded:Wait()
    self.State.Humanoid = self.State.Character:WaitForChild("Humanoid")
    
    self:SetupTouchEvents()
    
    self.State.Player.CharacterAdded:Connect(function(newCharacter)
        self.State.Character = newCharacter
        self.State.Humanoid = newCharacter:WaitForChild("Humanoid")
        self:SetupTouchEvents()
    end)
end

if BounceSystem.Config.Enabled then
    BounceSystem:Initialize()
end
local player = game:GetService("Players").LocalPlayer

Tabs.Player:Section({ Title = "Supper Bounce", TextSize = 20 })
Tabs.Player:Divider()

featureStates.BounceHeight = 190

local BounceInput = Tabs.Player:Input({
    Title = "Bounce Height",
    Placeholder = "190",
    Callback = function(value)
        featureStates.BounceHeight = tonumber(value) or 50
    end
})

function triggerSuperBounce()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        rootPart.Velocity = Vector3.new(rootPart.Velocity.X, featureStates.BounceHeight, rootPart.Velocity.Z)
    end
end

SuperBounceToggle = Tabs.Player:Toggle({
    Title = "Supper Bounce",
    Flag = "SuperBounceToggle",
    Desc = "Click to bounce with set height",
    Value = false,
    Callback = function(state)
        featureStates.SuperBounceEnabled = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.SuperBounce then
            _G.DarahubLibBtn.SuperBounce.Visible = state
        end
    end
})

if ButtonLib and ButtonLib.Create then
    _G.DarahubLibBtn = _G.DarahubLibBtn or {}
    _G.DarahubLibBtn.SuperBounce = ButtonLib.Create:Button({
        Text = "Supper Bounce",
        Flag = "SuperBounce",
        Visible = false,
        Callback = function()
            triggerSuperBounce()
        end
    })
    _G.DarahubLibBtn.SuperBounce.Position = UDim2.new(0.5, -125, 0.2, 0)
end
Tabs.Player:Space()
getgenv().EasyTrimp = {
    Enabled = false,
    BaseSpeed = 50,
    ExtraSpeed = 100,
    FloorDrop = 0
}

extra = getgenv().EasyTrimp.ExtraSpeed
floorDrop = getgenv().EasyTrimp.FloorDrop
last = tick()
airTick = 0
airSum = 0
airborne = false
push = nil
speed = getgenv().EasyTrimp.BaseSpeed
allow = false

Player = game.Players.LocalPlayer
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Debris = game:GetService("Debris")
camera = workspace.CurrentCamera

function cut(n)
    return math.floor(n*10)/10
end

function meter()
    ok, v = pcall(function()
        return Player.PlayerGui.Shared.HUD.Overlay.Default.CharacterInfo.Item.Speedometer.Players
    end)
    if ok then return v end
end

RunService.RenderStepped:Connect(function()
    dt = tick() - last
    last = tick()

    ch = Player.Character
    if not ch then return end

    hrp = ch:FindFirstChild("HumanoidRootPart")
    hum = ch:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    spd = meter()
    inAir = hum.FloorMaterial == Enum.Material.Air

    if airborne and not inAir then
        speed = math.max(getgenv().EasyTrimp.BaseSpeed - floorDrop, speed - 10)
        if spd then spd.Text = cut(speed) end
        airSum = 0
    end
    airborne = inAir

    if getgenv().EasyTrimp.Enabled then
        if inAir then
            airSum += dt
            airTick += dt
            while airTick >= 0.04 do
                airTick -= 0.04
                add = math.max(0.1, 2.5 * (0.04 / 1))
                speed = math.min(getgenv().EasyTrimp.BaseSpeed + extra, speed + add)
            end
        else
            airTick = 0
            airSum = 0
            speed = math.max(getgenv().EasyTrimp.BaseSpeed - floorDrop, speed - (2.5 * dt))
        end

        if push then push:Destroy() end

        look = camera.CFrame.LookVector
        moveDir = Vector3.new(look.X, 0, look.Z)
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end

        bv = Instance.new("BodyVelocity")
        bv.Velocity = moveDir * speed
        bv.MaxForce = Vector3.new(4e5, 0, 4e5)
        bv.P = 1250
        bv.Parent = hrp
        Debris:AddItem(bv, 0.1)
        push = bv

        allow = true
        if spd then spd.Text = cut(speed) end
    else
        if push then push:Destroy() push = nil end
        speed = getgenv().EasyTrimp.BaseSpeed
        allow = false
        airTick = 0
        airSum = 0
        airborne = false
    end
end)
EasyTrimpToggle = Tabs.Player:Toggle({
    Title = "Easy Trimp",
    Flag = "EasyTrimpToggle",
    Value = false,
    Callback = function(state)
        getgenv().EasyTrimp.Enabled = state
    end
})

ButtonLib.Create:Toggle({
    Text = "EasyTrimp",
    Flag = "EasyTrimpToggle",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if AutoCarryToggle then
            EasyTrimpToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)


ShowCarryButtonToggle = Tabs.Player:Toggle({
    Title = "Show EasyTrimp Button",
    Flag = "ShowEasyTrimpButton",
    Value = false,
    Callback = function(state)
        featureStates.ShowEasyTrimpButton = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.EasyTrimpToggle then
            _G.DarahubLibBtn.EasyTrimpToggle.Visible = state
        end
    end
})
BaseSpeedInput = Tabs.Player:Input({
    Title = "Base Speed",
    Flag = "EasyTrimpBaseSpeed",
    Placeholder = "50",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            getgenv().EasyTrimp.BaseSpeed = num
            speed = num
        end
    end
})

ExtraSpeedInput = Tabs.Player:Input({
    Title = "Extra Speed",
    Flag = "EasyTrimpExtraSpeed",
    Placeholder = "100",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            getgenv().EasyTrimp.ExtraSpeed = num
            extra = num
        end
    end
})

FloorDropInput = Tabs.Player:Input({
    Title = "Floor Drop",
    Flag = "EasyTrimpFloorDrop",
    Placeholder = "0",
    NumbersOnly = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            getgenv().EasyTrimp.FloorDrop = num
            floorDrop = num
        end
    end
})

coroutine.resume(coroutine.create(function()
Tabs.Player:Space()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local jumpTick = tick()
    local featureStates = {
        InfiniteJump = false
    }

    local UIS = game:GetService("UserInputService")

    UIS.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Space then
            if featureStates.InfiniteJump then
                if tick() - jumpTick > 0.01 then
                    jumpTick = tick()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end
    end)

    UIS.JumpRequest:Connect(function()
        if featureStates.InfiniteJump then
            if tick() - jumpTick > 0.01 then
                jumpTick = tick()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    function onCharacterAdded(newCharacter)
        character = newCharacter
        humanoid = character:WaitForChild("Humanoid")
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    InfiniteJumpToggle = Tabs.Player:Toggle({
        Title = "Infinite Jump",
        Flag = "InfiniteJumpToggle",
        Value = false,
        Callback = function(state)
            featureStates.InfiniteJump = state
        end
    })
end))
  Tabs.Player:Space()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local flying = false
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil
local character = nil
local humanoid = nil
local rootPart = nil
featureStates.Fly = false
featureStates.FlySpeed = 50

function setupCharacter()
    local player = Players.LocalPlayer
    if player.Character then
        character = player.Character
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
    end
end

setupCharacter()

Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    if featureStates.Fly then
        task.wait(0.5)
        startFlying()
    end
end)

function startFlying()
    if not character or not humanoid or not rootPart then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    humanoid.PlatformStand = true
end

function stopFlying()
    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if humanoid then
        humanoid.PlatformStand = false
    end
end

function updateFly()
    if not flying or not bodyVelocity or not bodyGyro or not character or not humanoid or not rootPart then
        if flying then stopFlying() end
        return
    end
    
    local camera = workspace.CurrentCamera
    local cameraCFrame = camera.CFrame
    local direction = Vector3.new(0, 0, 0)
    local moveDirection = humanoid.MoveDirection
    
    if moveDirection.Magnitude > 0 then
        local forwardVector = cameraCFrame.LookVector
        local rightVector = cameraCFrame.RightVector
        local forwardComponent = moveDirection:Dot(forwardVector) * forwardVector
        local rightComponent = moveDirection:Dot(rightVector) * rightVector
        direction = direction + (forwardComponent + rightComponent).Unit * moveDirection.Magnitude
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) or humanoid.Jump then
        direction = direction + Vector3.new(0, 1, 0)
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * (featureStates.FlySpeed * 2) or Vector3.new(0, 0, 0)
    bodyGyro.CFrame = cameraCFrame
end

FlyToggle = Tabs.Player:Toggle({
    Title = "Fly",
    Flag = "FlyToggle",
    Value = featureStates.Fly,
    Callback = function(state)
        featureStates.Fly = state
        if state then
            if not character or not humanoid or not rootPart then
                setupCharacter()
            end
            if character and humanoid and rootPart then
                startFlying()
                if flyConnection then flyConnection:Disconnect() end
                flyConnection = RunService.Heartbeat:Connect(updateFly)
            else
                featureStates.Fly = false
                FlyToggle:Set(false)
            end
        else
            stopFlying()
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
        end
    end
})

FlySpeedSlider = Tabs.Player:Slider({
    Title = "Fly Speed",
    Flag = "FlySpeedSlider",
    Value = { Min = 1, Max = 200, Default = featureStates.FlySpeed, Step = 1 },
    Desc = "Adjust fly speed",
    Callback = function(value)
        featureStates.FlySpeed = value
    end
})

function reapplyFly()
    if featureStates.Fly then
        if flying then
            stopFlying()
        end
        startFlying()
    end
end
 Tabs.Player:Space()
local p = game.Players.LocalPlayer local rs = game:GetService("RunService") local function gc() return p.Character or p.CharacterAdded:Wait() end local function sc(c) local h = c:WaitForChild("HumanoidRootPart", 8) if not h then return nil, nil end local hum = c:WaitForChild("Humanoid") return h, hum end local slideSpeed = 55 local slideDir = Vector3.zero local slideOn = false local slideCon = nil local hm = {} local of = {} local lastValidDir = Vector3.new(0, 0, 1) local initialDirSet = false local function hmm(ms, h, hum) if hm[ms] then return end local ok, m = pcall(require, ms) if not ok or not m or not m.SlideMove then return end of[ms] = m.SlideMove m.SlideMove = function(s, dt) if hum and hum.Health > 0 and slideOn then if slideDir == Vector3.zero then slideDir = h.CFrame.LookVector * Vector3.new(1, 0, 1) slideDir = slideDir.Unit lastValidDir = slideDir initialDirSet = true end local currentVel = s.d or Vector3.zero local targetVel = lastValidDir * slideSpeed * 100 local acceleration = 5000 * dt local velDiff = targetVel - currentVel local accelForce = velDiff.Unit * math.min(acceleration, velDiff.Magnitude) s.d = currentVel + accelForce if s.d.Magnitude > slideSpeed * 150 then s.d = s.d.Unit * slideSpeed * 150 end end return of[ms](s, dt) end hm[ms] = true end local function uhm(ms) if of[ms] then local ok, m = pcall(require, ms) if ok and m and m.SlideMove then m.SlideMove = of[ms] end of[ms] = nil hm[ms] = nil end end local function famm(c, h, hum) for ms in pairs(hm) do uhm(ms) end local pf = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players") if pf then local pp = pf:FindFirstChild(p.Name) if pp then local m1 = pp:FindFirstChild("Movement", true) if m1 and m1:IsA("ModuleScript") then hmm(m1, h, hum) end end end if c then local m2 = c:FindFirstChild("Movement", true) if m2 and m2:IsA("ModuleScript") then hmm(m2, h, hum) end end local ps = p:FindFirstChild("PlayerScripts") if ps then local m3 = ps:FindFirstChild("Movement", true) if m3 and m3:IsA("ModuleScript") then hmm(m3, h, hum) end end end local function shb(h, hum) if slideCon then slideCon:Disconnect() end slideCon = rs.Heartbeat:Connect(function() if not slideOn or not h or not h.Parent or not hum or hum.Health <= 0 then slideDir = Vector3.zero initialDirSet = false return end if hum.MoveDirection.Magnitude > 0.1 then lastValidDir = hum.MoveDirection.Unit * Vector3.new(1, 0, 1) lastValidDir = lastValidDir.Unit slideDir = lastValidDir elseif not initialDirSet then lastValidDir = h.CFrame.LookVector * Vector3.new(1, 0, 1) lastValidDir = lastValidDir.Unit slideDir = lastValidDir initialDirSet = true end if slideDir ~= Vector3.zero then local currentCF = h.CFrame local targetCF = CFrame.new(currentCF.Position, currentCF.Position + slideDir) local newCF = CFrame.new( currentCF.Position, Vector3.new(targetCF.LookVector.X, 0, targetCF.LookVector.Z) + currentCF.Position ) h.CFrame = newCF end end) end local function oca(c) local h, hum = sc(c) if not h then return end if slideOn then famm(c, h, hum) shb(h, hum) end end task.spawn(function() oca(gc()) end) p.CharacterAdded:Connect(oca) slideToggle = Tabs.Player:Toggle({ Title = "Infinite Slide", Flag = "infiniteSlideToggle", Value = false, Callback = function(s) slideOn = s if s then local c = gc() local h, hum = sc(c) if not h then slideOn = false return end famm(c, h, hum) shb(h, hum) else if slideCon then slideCon:Disconnect() slideCon = nil end for ms in pairs(hm) do uhm(ms) end slideDir = Vector3.zero initialDirSet = false end end }) SpeedInput = Tabs.Player:Input({ Title = "Slide Speed", Flag = "SlideSpeed", Placeholder = "55", NumbersOnly = true, Value = "55", Callback = function(v) local n = tonumber(v) if n and n > 0 then slideSpeed = n end end }) game:GetService("Players").PlayerRemoving:Connect(function(lp) if lp == p then if slideCon then slideCon:Disconnect() end for ms in pairs(hm) do uhm(ms) end end end)
Tabs.Player:Space()
Noclip = Tabs.Player:Toggle({
 Title = "Noclip",
 Desc = "Walk Passthrough walls with cframespeed",
 Flag = "Noclip",
 Value = false,
 Callback = function(state)
  if state then
  local Players = game:GetService("Players")
  local RunService = game:GetService("RunService")
  
  local LocalPlayer = Players.LocalPlayer
  local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
  local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
  
  local noclip = 1
  local NoclipEnabled = false
  local movementConnection
  
  NoclipEnabled = true
  
  movementConnection = RunService.RenderStepped:Connect(function()
 if Character and HumanoidRootPart then
  for _, part in pairs(Character:GetDescendants()) do
  if part:IsA("BasePart") then
 part.CanCollide = false
  end
  end
  
  local MoveDirection = Character.Humanoid.MoveDirection
  if MoveDirection.Magnitude > 0 then
  HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + MoveDirection * (noclip / 10)
  end
 end
  end)
  
  LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
 Character = NewCharacter
 HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
  end)
  
  getgenv().NoclipConnection = movementConnection
  else
  if getgenv().NoclipConnection then
 getgenv().NoclipConnection:Disconnect()
 getgenv().NoclipConnection = nil
  end
  
  local Players = game:GetService("Players")
  local LocalPlayer = Players.LocalPlayer
  local Character = LocalPlayer.Character
  
  if Character then
 for _, part in pairs(Character:GetDescendants()) do
  if part:IsA("BasePart") then
  part.CanCollide = true
  end
 end
  end
  end
 end
})
Tabs.Player:Space()
 TPWALKToggle = Tabs.Player:Toggle({
  Title = "TP WALK",
  Flag = "TPWALKToggle",
  Value = false,
  Callback = function(state)
  featureStates.TPWALK = state
  if state then
 startTpwalk()
  else
 stopTpwalk()
  end
  end
 })

 TPWALKSlider = Tabs.Player:Slider({
  Title = "TPWALK VALUE",
  Flag = "TPWALKSlider",
   Desc = "Adjust TPWALK speed",
  Value = { Min = 1, Max = 200, Default = 1, Step = 1 },
  Callback = function(value)
  featureStates.TpwalkValue = value
  end
 })
Tabs.Player:Space()

 JumpBoostToggle = Tabs.Player:Toggle({
  Title = "Jump Height",
  Flag = "JumpBoostToggle",
  Value = false,
  Callback = function(state)
  featureStates.JumpBoost = state
  if state then
 startJumpBoost()
  else
 stopJumpBoost()
  end
  end
 })

 JumpBoostSlider = Tabs.Player:Slider({
  Title = "Jump Height",
  Flag = "JumpBoostSlider",
  Desc = "Adjust jump height",
  Value = { Min = 1, Max = 200, Default = 5, Step = 1 },
  Callback = function(value)
  featureStates.JumpPower = value
  if featureStates.JumpBoost then
 if humanoid then
  humanoid.JumpPower = featureStates.JumpPower
 end
  end
  end
 })
Tabs.Player:Section({ Title = "Modifications" })

SpeedChangerInput = Tabs.Player:Input({
    Title = "Speed Changer",
    Flag = "SpeedChangerInput",
    Placeholder = "1500",
    NumbersOnly = true,
    Value = "1500",
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            _G.RealSpeedOverride = num
        end
    end
})

_G.RealSpeedOverride = 1500

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char.Humanoid:GetAttributeChangedSignal("RealSpeed"):Connect(function()
        if char.Humanoid:GetAttribute("RealSpeed") ~= _G.RealSpeedOverride then
            char.Humanoid:SetAttribute("RealSpeed", _G.RealSpeedOverride)
        end
    end)
    
    char.Humanoid:SetAttribute("RealSpeed", _G.RealSpeedOverride)
    
    if char:FindFirstChild("Communicator") and char.Communicator:IsA("RemoteEvent") then
        local oldFire = char.Communicator.FireServer
        char.Communicator.FireServer = function(self, ...)
            local args = {...}
            if args[1] == "update" then
                wait()
                if char.Humanoid then
                    char.Humanoid:SetAttribute("RealSpeed", _G.RealSpeedOverride)
                    char.Humanoid:SetAttribute("RealJumpHeight", char.Humanoid:GetAttribute("RealJumpHeight") or 0)
                end
                return _G.RealSpeedOverride, char.Humanoid:GetAttribute("RealJumpHeight")
            else
                return oldFire(self, unpack(args))
            end
        end
    end
end)

spawn(function()
    while true do
        wait(0.5)
        local plr = game.Players.LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            local hum = plr.Character.Humanoid
            if hum:GetAttribute("RealSpeed") ~= _G.RealSpeedOverride then
                hum:SetAttribute("RealSpeed", _G.RealSpeedOverride)
            end
        end
    end
end)

if script:FindFirstAncestor("Movement") then
    getupvalue(module_upvr.Update, 1).j = _G.RealSpeedOverride
    getupvalue(module_upvr.Update, 1).q = _G.RealSpeedOverride
    getupvalue(module_upvr.Update, 1).Character.Humanoid:SetAttribute("RealSpeed", _G.RealSpeedOverride)
end

 Tabs.Player:Space()
 local player = game.Players.LocalPlayer
local DEFAULT_STRAFE_ACC = 187
local currentStrafeAcc = DEFAULT_STRAFE_ACC
local movementModules = {}

local function patchMovementModule(movModule)
    if not movModule then return end
    
    local success, mod = pcall(require, movModule)
    if not success then return end
    
    if mod.AirMove then
        mod.AirMove = function(self)
            if not self.a then
                if self.d then
                    local cam = workspace.CurrentCamera
                    if cam then
                        local moveVec = self.b:GetMoveVector()
                        
                        if moveVec.X ~= 0 then
                            local right = cam.CFrame.RightVector * Vector3.new(1, 0, 1)
                            local strafeDir = right.Unit * (moveVec.X > 0 and 1 or -1)
                            
                            local accel = strafeDir * currentStrafeAcc * (self.i or 1/60)
                            self.d = Vector3.new(
                                self.d.X + accel.X,
                                self.d.Y,
                                self.d.Z + accel.Z
                            )
                        end
                    end
                end
                if self.ApplyFriction then
                    self:ApplyFriction(0)
                end
            end
        end
    end
end

local function setupCharacter(character)
    task.wait(0.5)
    
    local localMov = character:FindFirstChild("Movement", true)
    if localMov then
        if not table.find(movementModules, localMov) then
            table.insert(movementModules, localMov)
        end
        local success, err = pcall(patchMovementModule, localMov)
        if not success then
            warn("Failed to patch local movement module:", err)
        end
    else
        warn("Local character movement module not found")
    end
    
    local serverChar
    local success, err = pcall(function()
        if workspace.Game and workspace.Game.Players and player then
            serverChar = workspace.Game.Players:FindFirstChild(player.Name)
        end
    end)
    
    if not success then
        warn("Error finding server character:", err)
        return
    end
    
    if serverChar then
        local serverMov = serverChar:FindFirstChild("Movement", true)
        if serverMov then
            if not table.find(movementModules, serverMov) then
                table.insert(movementModules, serverMov)
            end
            local patchSuccess, patchErr = pcall(patchMovementModule, serverMov)
            if not patchSuccess then
                warn("Failed to patch server movement module:", patchErr)
            end
        else
            warn("Server character movement module not found")
        end
    end
end
StrafeInput = Tabs.Player:Input({
    Title = "Strafe Acceleration",
    Flag = "StrafeInput",
    Icon = "wind",
    Placeholder = tostring(DEFAULT_STRAFE_ACC),
    Value = tostring(currentStrafeAcc),
    Callback = function(value)
        local num = tonumber(value)
        if num then
            currentStrafeAcc = num
            for _, module in pairs(movementModules) do
                if module and module.Parent then
                    patchMovementModule(module)
                end
            end
        end
    end
})

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(function(character)
    setupCharacter(character)
end)
 Tabs.Player:Space()
 _G.MaxJumpOverride = 1

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    
    local humanoid = char.Humanoid
    local jumps = 0
    local jumpTick = tick()
    
    humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            jumps = 0
        end
    end)
    
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if jumps < _G.MaxJumpOverride and tick() - jumpTick > 0 then
            jumpTick = tick()
            jumps += 1
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end)

if game.Players.LocalPlayer.Character then
    local char = game.Players.LocalPlayer.Character
    local humanoid = char:WaitForChild("Humanoid")
    local jumps = 0
    local jumpTick = tick()
    
    humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed then
            jumps = 0
        end
    end)
    
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if jumps < _G.MaxJumpOverride and tick() - jumpTick > 0.05 then
            jumpTick = tick()
            jumps += 1
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
JumpCapChangerInput = Tabs.Player:Input({
    Title = "Jump Cap",
    Flag = "JumpCapChangerInput",
    Placeholder = "1",
    NumbersOnly = true,
    Value = "1",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 then
            _G.MaxJumpOverride = num
        end
    end
})
Tabs.Player:Section({ Title = "Useable" }) Players = game:GetService("Players") localPlayer = Players.LocalPlayer desiredSpeed = 1000 / 1000 desiredPadSpeed = 1000 / 1000 boostObject = nil padObject = nil function getObject(name) gameFolder = workspace:FindFirstChild("Game") if not gameFolder then return nil end for _, obj in ipairs(gameFolder:GetDescendants()) do if obj.Name == name and obj:IsA("NumberValue") then return obj end end return nil end task.spawn(function() while true do boostObject = boostObject or getObject("ColaBoost") if boostObject and boostObject.Value ~= desiredSpeed then boostObject.Value = desiredSpeed end padObject = padObject or getObject("SpeedPad") if padObject and padObject.Value ~= desiredPadSpeed then padObject.Value = desiredPadSpeed end task.wait(0.1) end end) Tabs.Player:Input({ Title = "Cola Speed", Value = "1000", Type = "Input", Placeholder = "1000", Callback = function(input) num = tonumber(input) if num then adjustedValue = num / 1000 desiredSpeed = adjustedValue boostObject = getObject("ColaBoost") if boostObject then boostObject.Value = adjustedValue end end end }) Tabs.Player:Input({ Title = "SpeedPad Power", Value = "1000", Type = "Input", Placeholder = "1000", Callback = function(input) num = tonumber(input) if num then adjustedValue = num / 1000 desiredPadSpeed = adjustedValue padObject = getObject("SpeedPad") if padObject then padObject.Value = adjustedValue end end end }) localPlayer.CharacterAdded:Connect(function() boostObject = nil padObject = nil end) Tabs.Player:Section({ Title = "Emote Speed" }) local Players = game:GetService("Players") local RunService = game:GetService("RunService") local lp = Players.LocalPlayer local emoteMode = "Nah" local speedValue = 1000 local cachedController = nil local blatantConnection = nil local function getController() if cachedController and cachedController.Character == lp.Character then return cachedController end local char = lp.Character if not char then return nil end for _, v in pairs(getgc(true)) do if type(v) == "table" and rawget(v, "h") and rawget(v, "Character") == char then cachedController = v return v end end return nil end local function ResetEmoteSpeed() if blatantConnection then blatantConnection:Disconnect() blatantConnection = nil end local controller = getController() if controller and controller.h then controller.h.MaxForce = 1500000 end end Tabs.Player:Input({ Title = "Speed Value", Default = "1000", Callback = function(val) speedValue = tonumber(val) or 1000 end }) Tabs.Player:Dropdown({ Title = "Speed Toggle", Values = { "Nah", "Legit", "Blatant" }, Default = "Nah", Callback = function(option) ResetEmoteSpeed() emoteMode = option end }) RunService.Heartbeat:Connect(function() if emoteMode == "Nah" then return end local char = lp.Character if not char then return end local statChanges = char:FindFirstChild("StatChanges") local speedFolder = statChanges and statChanges:FindFirstChild("Speed") local emoteObject = speedFolder and speedFolder:FindFirstChild("EmoteSpeed") if emoteObject then if emoteMode == "Legit" then emoteObject.Value = speedValue / 1000 elseif emoteMode == "Blatant" then local v5 = getController() if v5 then v5.j = speedValue v5.c = 1 if v5.h then v5.h.MaxForce = math.huge end char:SetAttribute("CurrentMoveSpeed", 16) end end else if emoteMode == "Blatant" then local v5 = getController() if v5 and v5.h and v5.h.MaxForce ~= 1500000 then v5.h.MaxForce = 1500000 end end end end)
 -- Auto Tab
  Tabs.Auto:Section({ Title = "Auto", TextSize = 40 })
 Tabs.Auto:Space()
local function safeExecute(func, errorMessage)
 local success, err = pcall(func)
 if not success then
 warn(errorMessage .. ":", err)
 return false
 end
 return true
end

local function initializeEnvironment() local success, envErr = pcall(function() getgenv().autoJumpType = "Bounce" getgenv().bhopMode = "Acceleration" getgenv().bhopAccelValue = -0.5 getgenv().bhopHoldActive = false getgenv().autoJumpEnabled = false getgenv().jumpCooldown = 0.7 featureStates = featureStates or {} featureStates.Bhop = false featureStates.BhopHold = false featureStates.AutoCrouch = false featureStates.AutoCrouchMode = "Air" featureStates.AutoCarry = false end) if not success then warn("Failed to initialize environment:", envErr) return false end return true end local function main() local player, RunService, UserInputService, Players local success, serviceErr = pcall(function() player = game:GetService("Players").LocalPlayer RunService = game:GetService("RunService") UserInputService = game:GetService("UserInputService") Players = game:GetService("Players") end) if not success then warn("Failed to get services:", serviceErr) return end if not player then warn("Player not found") return end Tabs = Tabs or {Auto = {}} isMobile = isMobile or UserInputService.TouchEnabled bhopConnection = nil bhopLoaded = false characterConnection = nil Character = nil Humanoid = nil HumanoidRootPart = nil LastJump = 0 GROUND_CHECK_DISTANCE = 3.5 MAX_SLOPE_ANGLE = 45 AIR_RANGE = 0.1 local patchedModules = {} local originalFunctions = {} local GROUND_FRICTION = -0.5 local function setGroundAccelStrength(multiplier) if type(multiplier) ~= "number" then warn("Invalid multiplier type:", type(multiplier)) return end GROUND_FRICTION = -0.5 * multiplier for movModule, oldFunc in pairs(originalFunctions) do local success, mod = pcall(require, movModule) if success and mod and mod.ApplyFriction then local newFriction = GROUND_FRICTION mod.ApplyFriction = function(self, frictionAmt) if getgenv().bhopMode == "Acceleration" and (getgenv().autoJumpEnabled or getgenv().bhopHoldActive) then if self.a then local peakSpeed = 0 local currentMag = self.d.Magnitude if currentMag > peakSpeed then peakSpeed = currentMag end local decayTime = 0 local decayThreshold = 0.85 local decayFric = 3.0 local decayDuration = 0.2 local isSpeedLoss = currentMag < (peakSpeed * decayThreshold) if isSpeedLoss and (tick() - decayTime) >= decayDuration then frictionAmt = decayFric decayTime = tick() else frictionAmt = newFriction end end end return oldFunc(self, frictionAmt) end end end end local function makeFaster(factor) local success = pcall(setGroundAccelStrength, factor or 0.1) if not success then warn("Failed to make faster with factor:", factor) end end local function restoreOriginalFriction() for movModule, oldFunc in pairs(originalFunctions) do local success, mod = pcall(require, movModule) if success and mod then mod.ApplyFriction = oldFunc else warn("Failed to restore friction for module:", movModule) end end patchedModules = {} originalFunctions = {} end local function applyAccelerationSetting() if getgenv().bhopMode ~= "Acceleration" then restoreOriginalFriction() return end for movModule, oldFunc in pairs(originalFunctions) do local success, mod = pcall(require, movModule) if success and mod and mod.ApplyFriction then local newFriction = GROUND_FRICTION mod.ApplyFriction = function(self, frictionAmt) if getgenv().bhopMode == "Acceleration" and (getgenv().autoJumpEnabled or getgenv().bhopHoldActive) then if self.a then local peakSpeed = 0 local currentMag = self.d.Magnitude if currentMag > peakSpeed then peakSpeed = currentMag end local decayTime = 0 local decayThreshold = 0.85 local decayFric = 3.0 local decayDuration = 0.2 local isSpeedLoss = currentMag < (peakSpeed * decayThreshold) if isSpeedLoss and (tick() - decayTime) >= decayDuration then frictionAmt = decayFric decayTime = tick() else frictionAmt = newFriction end end end return oldFunc(self, frictionAmt) end end end end local function patchModule(movModule) if not movModule or not movModule:IsA("ModuleScript") then return end if patchedModules[movModule] then return end local success, mod = pcall(require, movModule) if not success then warn("Failed to require module:", movModule) return end if not mod.ApplyFriction then warn("Module missing ApplyFriction:", movModule) return end originalFunctions[movModule] = mod.ApplyFriction patchedModules[movModule] = true pcall(applyAccelerationSetting) end local function patchAllAvailableModules() local function searchAndPatch(parent) if not parent then return end local success, movScript = pcall(function() return parent:FindFirstChild("Movement", true) end) if success and movScript and movScript:IsA("ModuleScript") then pcall(patchModule, movScript) end end if player.Character then pcall(searchAndPatch, player.Character) end local playerFolder local success, folderErr = pcall(function() if workspace.Game and workspace.Game.Players then playerFolder = workspace.Game.Players:FindFirstChild(player.Name) end end) if success and playerFolder then pcall(searchAndPatch, playerFolder) end end local function onCharacterSpawn(char) local attempts = 0 local maxAttempts = 10 local checkInterval = 0.1 local function checkAndPatch() attempts = attempts + 1 if char and char.Parent then pcall(patchAllAvailableModules) if next(originalFunctions) ~= nil then return true end end if attempts < maxAttempts then task.wait(checkInterval) return checkAndPatch() end return false end coroutine.wrap(function() local success = pcall(checkAndPatch) if not success then warn("Failed to check and patch for character") end end)() end local function setupCharacterEvents() local success, err = pcall(function() player.CharacterAdded:Connect(function(char) pcall(onCharacterSpawn, char) end) if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then pcall(onCharacterSpawn, player.Character) end end) if not success then warn("Failed to setup character events:", err) end end local function IsOnGround() if not Character or not HumanoidRootPart or not Humanoid then return false end local state, raycastResult, surfaceNormal, angle local success, err = pcall(function() state = Humanoid:GetState() if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Swimming then return false end local raycastParams = RaycastParams.new() raycastParams.FilterType = Enum.RaycastFilterType.Blacklist raycastParams.FilterDescendantsInstances = {Character} raycastParams.IgnoreWater = true local rayOrigin = HumanoidRootPart.Position local rayDirection = Vector3.new(0, -GROUND_CHECK_DISTANCE, 0) raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams) if not raycastResult then return false end surfaceNormal = raycastResult.Normal angle = math.deg(math.acos(surfaceNormal:Dot(Vector3.new(0, 1, 0)))) return angle <= MAX_SLOPE_ANGLE end) if not success then warn("IsOnGround error:", err) return false end return angle and angle <= MAX_SLOPE_ANGLE end local function updateBhop() if not bhopLoaded then return end local character, humanoid local success, err = pcall(function() character = player.Character humanoid = character and character:FindFirstChild("Humanoid") if not character or not humanoid then return end local isBhopActive = getgenv().autoJumpEnabled or getgenv().bhopHoldActive if isBhopActive then local now = tick() if IsOnGround() and (now - LastJump) > getgenv().jumpCooldown then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) LastJump = now end end end) if not success then warn("updateBhop error:", err) end end local function loadBhop() if bhopLoaded then return end bhopLoaded = true local success, err = pcall(function() if bhopConnection then bhopConnection:Disconnect() end bhopConnection = RunService.Heartbeat:Connect(updateBhop) applyAccelerationSetting() end) if not success then warn("loadBhop error:", err) bhopLoaded = false end end local function unloadBhop() if not bhopLoaded then return end bhopLoaded = false local success, err = pcall(function() if bhopConnection then bhopConnection:Disconnect() bhopConnection = nil end getgenv().bhopHoldActive = false end) if not success then warn("unloadBhop error:", err) end end local function checkBhopState() local shouldLoad = getgenv().autoJumpEnabled or getgenv().bhopHoldActive local success, err = pcall(function() if shouldLoad then loadBhop() else unloadBhop() end applyAccelerationSetting() end) if not success then warn("checkBhopState error:", err) end end local function reapplyBhopOnRespawn() local success, err = pcall(function() if getgenv().autoJumpEnabled or getgenv().bhopHoldActive then checkBhopState() end end) if not success then warn("reapplyBhopOnRespawn error:", err) end end local function setupJumpButton() local success, err = pcall(function() local touchGui = player:WaitForChild("PlayerGui", 5):WaitForChild("TouchGui", 5) if not touchGui then return end local touchControlFrame = touchGui:WaitForChild("TouchControlFrame", 5) if not touchControlFrame then return end local jumpButton = touchControlFrame:WaitForChild("JumpButton", 5) if not jumpButton then return end jumpButton.MouseButton1Down:Connect(function() if featureStates.BhopHold then getgenv().bhopHoldActive = true checkBhopState() end end) jumpButton.MouseButton1Up:Connect(function() getgenv().bhopHoldActive = false checkBhopState() end) end) if not success then warn("setupJumpButton error:", err) end end local function initializeCharacterTracking() local success, err = pcall(function() RunService.Heartbeat:Connect(function() if not Character or not Character:IsDescendantOf(workspace) then Character = player.Character or player.CharacterAdded:Wait() if Character then Humanoid = Character:FindFirstChildOfClass("Humanoid") HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") end end end) if characterConnection then characterConnection:Disconnect() end characterConnection = player.CharacterAdded:Connect(function(character) Character = character local success2, err2 = pcall(function() Humanoid = character:WaitForChild("Humanoid") HumanoidRootPart = character:WaitForChild("HumanoidRootPart") setupJumpButton() reapplyBhopOnRespawn() end) if not success2 then warn("CharacterAdded handler error:", err2) end end) end) if not success then warn("initializeCharacterTracking error:", err) end end local function initializeUI() local success, err = pcall(function() if Tabs and Tabs.Auto then Tabs.Auto:Space() AutoJumpTypeDropdown = Tabs.Auto:Dropdown({ Title = "Auto Jump type", Flag = "AutoJumpTypeDropdown", Values = {"Bounce", "Realistic"}, Value = "Bounce", Callback = function(value) getgenv().autoJumpType = value end }) BhopToggle = Tabs.Auto:Toggle({ Title = "Bhop", Flag = "BhopToggle", Value = false, Callback = function(state) featureStates.Bhop = state getgenv().autoJumpEnabled = state checkBhopState() end }) if ButtonLib and ButtonLib.Create then local toggle = ButtonLib.Create:Toggle({ Text = "Bunny Hop", Flag = "BunnyHopToggle", Default = false, Visible = false, Callback = function(s) if BhopToggle then BhopToggle:Set(s) end end }) toggle.Position = UDim2.new(0.5, -125, 0.4, 0) end ShowBunnyHopButtonToggle = Tabs.Auto:Toggle({ Title = "Show Bunny Hop Button", Flag = "ShowBunnyHopButton", Value = false, Callback = function(state) featureStates.ShowBunnyHopButton = state if _G.DarahubLibBtn and _G.DarahubLibBtn.BunnyHopToggle then _G.DarahubLibBtn.BunnyHopToggle.Visible = state end end }) BhopHoldToggle = Tabs.Auto:Toggle({ Title = "Bhop (Hold Space/Jump)", Flag = "BhopHoldToggle", Value = false, Callback = function(state) featureStates.BhopHold = state if not state then getgenv().bhopHoldActive = false checkBhopState() end end }) BhopModeDropdown = Tabs.Auto:Dropdown({ Title = "Bhop Mode", Flag = "BhopModeDropdown", Values = {"Acceleration", "No Acceleration"}, Value = "Acceleration", Callback = function(value) getgenv().bhopMode = value if value ~= "Acceleration" then restoreOriginalFriction() else applyAccelerationSetting() end end }) BhopAccelInput = Tabs.Auto:Input({ Title = "Bhop Acceleration (Negative Only)", Flag = "BhopAccelInput", Placeholder = "-0.5", Numeric = true, Callback = function(value) if tostring(value):sub(1,1) == "-" then local n = tonumber(value) if n then makeFaster(math.abs(n)/0.5) applyAccelerationSetting() end end end }) JumpCooldownInput = Tabs.Auto:Input({ Title = "Jump Cooldown (Seconds)", Flag = "JumpCooldownInput", Placeholder = "0.7", Numeric = true, Callback = function(value) local n = tonumber(value) if n and n > 0 then getgenv().jumpCooldown = n end end }) end end) if not success then warn("initializeUI error:", err) end end local function setupCleanup() local success, err = pcall(function() Players.PlayerRemoving:Connect(function(leavingPlayer) if leavingPlayer == player then unloadBhop() restoreOriginalFriction() if characterConnection then characterConnection:Disconnect() end end end) end) if not success then warn("setupCleanup error:", err) end end if not initializeEnvironment() then return end setupCharacterEvents() initializeCharacterTracking() pcall(setupJumpButton) pcall(checkBhopState) initializeUI() setupCleanup() warn(" Autojump Script initialized successfully") end local success, err = pcall(main) if not success then warn("Critical script error:", err) end
Tabs.Auto:Space()
AutoCrouchToggle = Tabs.Auto:Toggle({
    Title = "Auto Crouch",
    Flag = "AutoCrouchToggle",
    Value = false,
    Callback = function(state)
        featureStates.AutoCrouch = state
        if not state then
            previousAutoCrouch = false
        end
    end
})
ButtonLib.Create:Toggle({
    Text = "Auto Crouch",
    Flag = "AutoCrouchToggle",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if AutoCrouchToggle then
            AutoCrouchToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

ShowAutoCrouchButtonToggle = Tabs.Auto:Toggle({
    Title = "Show Auto Crouch Button",
    Flag = "ShowAutoCrouchButton",
    Value = false,
    Callback = function(state)
        featureStates.ShowAutoCrouchButton = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.AutoCrouchToggle then
            _G.DarahubLibBtn.AutoCrouchToggle.Visible = state
        end
    end
})
AutoCrouchModeDropdown = Tabs.Auto:Dropdown({
    Title = "Auto Crouch Mode",
    Flag = "AutoCrouchModeDropdown",
    Values = {"Air", "Spam", "Ground", "Normal"},
    Value = "Air",
    Callback = function(value)
        featureStates.AutoCrouchMode = value
    end
})

Tabs.Auto:Space()
function startAutoCarry()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local player = Players.LocalPlayer
    
    local lastCarryTime = 0
    
    AutoCarryConnection = RunService.Heartbeat:Connect(function()
        if not featureStates.AutoCarry then return end
        
        if os.clock() - lastCarryTime < 0.3 then return end
        
        local char = player.Character
        if not char then return end
        
        if char:GetAttribute("Carrying") == true then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= player and other.Character then
                local otherHRP = other.Character:FindFirstChild("HumanoidRootPart")
                local otherHum = other.Character:FindFirstChild("Humanoid")
                
                if otherHRP and otherHum then
                    local isDowned = other.Character:GetAttribute("Downed") == true
                    
                    if isDowned then
                        local dist = (hrp.Position - otherHRP.Position).Magnitude
                        if dist <= 20 then
                            lastCarryTime = os.clock()
                            
                            local args = { other.Name }
                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("Events")
                                    :WaitForChild("Revive"):WaitForChild("CarryPlayer")
                                    :FireServer(unpack(args))
                            end)
                            
                            return
                        end
                    end
                end
            end
        end
    end)
end
function stopAutoCarry()
    if AutoCarryConnection then
        AutoCarryConnection:Disconnect()
        AutoCarryConnection = nil
    end
end

AutoCarryToggle = Tabs.Auto:Toggle({
    Title = "Auto Carry",
    Flag = "AutoCarryToggle",
    Value = false,
    Callback = function(state)
        featureStates.AutoCarry = state
        if state then
            startAutoCarry()
        else
            stopAutoCarry()
        end
    end
})


ButtonLib.Create:Toggle({
    Text = "AUTO CARRY",
    Flag = "CarryToggle",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if AutoCarryToggle then
            AutoCarryToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)


ShowCarryButtonToggle = Tabs.Auto:Toggle({
    Title = "Show Carry Button",
    Flag = "ShowCarryButton",
    Value = false,
    Callback = function(state)
        featureStates.ShowCarryButton = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.CarryToggle then
            _G.DarahubLibBtn.CarryToggle.Visible = state
        end
    end
})

 Tabs.Auto:Space()
--[[
local fastreviveRange = 10
local loopDelay = 0.15
local revivefastLoopHandle = nil
featureStates.FastRevive = false

local function startAutofastRevive()
    if revivefastLoopHandle then return end
    
    revivefastLoopHandle = task.spawn(function()
        while featureStates.FastRevive do
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do
                    if pl ~= LocalPlayer then
                        local char = pl.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local success, dist = pcall(function()
                                return (myHRP.Position - hrp.Position).Magnitude
                            end)
                            if success and dist and dist <= fastreviveRange then
                                pcall(function()
                                    local Event = game:GetService("ReplicatedStorage").Events.Revive.RevivePlayer
                                    Event:FireServer(pl.Name, true)
                                end)
                            end
                        end
                    end
                end
            end
            task.wait(loopDelay)
        end
        revivefastLoopHandle = nil
    end)
end

local function stopAutofastRevive()
    if revivefastLoopHandle then
        task.cancel(revivefastLoopHandle)
        revivefastLoopHandle = nil
    end
end

FastReviveToggle = Tabs.Auto:Toggle({
    Title = "Fast Revive",
    Flag = "FastReviveToggle",
    
 Desc = "It's not even do anything idk why:(",
 
    Value = false,
    Callback = function(state)
        featureStates.FastRevive = state
        if state then
            startAutofastRevive()
        else
            stopAutofastRevive()
        end
    end
})]]
local reviveRange = 10
local loopDelay = 0.15
local reviveLoopHandle = nil
featureStates.FastRevive = false

local function startAutoRevive()
    if reviveLoopHandle then return end
    
    reviveLoopHandle = task.spawn(function()
        while featureStates.FastRevive do
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do
                    if pl ~= LocalPlayer then
                        local char = pl.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hrp = char.HumanoidRootPart
                            local success, dist = pcall(function()
                                return (myHRP.Position - hrp.Position).Magnitude
                            end)
                            if success and dist and dist <= reviveRange then
                                pcall(function()

local Event = game:GetService("Players").LocalPlayer.PlayerScripts.Events.KeybindUsed
Event:Fire(
    "Interact",
    true
)
                                end)
                            end
                        end
                    end
                end
            end
            task.wait(loopDelay)
        end
        reviveLoopHandle = nil
    end)
end

local function stopAutoRevive()
    if reviveLoopHandle then
        task.cancel(reviveLoopHandle)
        reviveLoopHandle = nil
    end
end

FastReviveToggle = Tabs.Auto:Toggle({
    Title = "Auto Revive Teammate",
    Flag = "FastReviveToggle", 
    Value = false,
    Callback = function(state)
        featureStates.FastRevive = state
        if state then
            startAutoRevive()
        else
            stopAutoRevive()
        end
    end
})

 Tabs.Auto:Space()

function fireVoteServer(mapNumber)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
    
    if eventsFolder then
        local voteEvent = eventsFolder:WaitForChild("Vote", 10)
        if voteEvent and voteEvent:IsA("RemoteEvent") then
            local args = {mapNumber}
            voteEvent:FireServer(unpack(args))
        end
    end
end

function startAutoVote()
 AutoVoteConnection = RunService.Heartbeat:Connect(function()
  fireVoteServer(featureStates.SelectedMap)
 end)
end

function stopAutoVote()
 if AutoVoteConnection then
  AutoVoteConnection:Disconnect()
  AutoVoteConnection = nil
 end
end
 AutoVoteDropdown = Tabs.Auto:Dropdown({
  Title = "Auto Vote Map",
  Flag = "AutoVoteDropdown",
  Values = {"Map 1", "Map 2", "Map 3", "Map 4"},
  Value = "Map 1",
  Callback = function(value)
  if value == "Map 1" then
 featureStates.SelectedMap = 1
  elseif value == "Map 2" then
 featureStates.SelectedMap = 2
  elseif value == "Map 3" then
 featureStates.SelectedMap = 3
  elseif value == "Map 4" then
 featureStates.SelectedMap = 4
  end
  end
 })

 AutoVoteToggle = Tabs.Auto:Toggle({
  Title = "Auto Vote",
  Flag = "AutoVoteToggle",
  Value = false,
  Callback = function(state)
  featureStates.AutoVote = state
  if state then
 startAutoVote()
  else
 stopAutoVote()
  end
  end
 })

featureStates.SelfReviveMethod = "Spawnpoint"
local lastSavedPosition = nil
local respawnConnection = nil
local AutoSelfReviveConnection = nil
local hasRevived = false
local isReviving = false

 Tabs.Auto:Space()
AutoSelfReviveToggle = Tabs.Auto:Toggle({
 Title = "Auto Self Revive",
 Flag = "AutoSelfReviveToggle",
 Value = false,
 Callback = function(state)
  featureStates.AutoSelfRevive = state
  if state then
  if AutoSelfReviveConnection then
 AutoSelfReviveConnection:Disconnect()
  end
  if respawnConnection then
 respawnConnection:Disconnect()
  end
  
  local character = player.Character
  if character then
 local humanoid = character:WaitForChild("Humanoid")
 local hrp = character:WaitForChild("HumanoidRootPart")
 
 AutoSelfReviveConnection = character:GetAttributeChangedSignal("Downed"):Connect(function()
  local isDowned = character:GetAttribute("Downed")
  if isDowned and not isReviving then
  isReviving = true
  
  if featureStates.SelfReviveMethod == "Spawnpoint" then
 if not hasRevived then
  hasRevived = true
  pcall(function()
  local Event = game:GetService("ReplicatedStorage").Events.Respawn
Event:FireServer()
  end)
  task.delay(10, function()
  hasRevived = false
  end)
  task.delay(1, function()
  isReviving = false
  end)
 else
  isReviving = false
 end
  elseif featureStates.SelfReviveMethod == "Fake Revive" then
 if hrp then
  lastSavedPosition = hrp.Position
 end
 
 task.spawn(function()
  pcall(function()
  ReplicatedStorage:WaitForChild("Events"):WaitForChild("Respawn"):FireServer()
  end)
  
  local newCharacter
  repeat
  newCharacter = player.Character
  task.wait()
  until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= character
  
  if newCharacter then
  local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
  if lastSavedPosition and newHRP then
 newHRP.CFrame = CFrame.new(lastSavedPosition)
  end
  end
  
  isReviving = false
 end)
  end
  end
 end)
  end
  
  respawnConnection = player.CharacterAdded:Connect(function(newChar)
 task.wait(0.5)
 local newHumanoid = newChar:WaitForChild("Humanoid")
 local newHRP = newChar:WaitForChild("HumanoidRootPart")
 
 if featureStates.AutoSelfRevive then
  AutoSelfReviveConnection = newChar:GetAttributeChangedSignal("Downed"):Connect(function()
  local isDowned = newChar:GetAttribute("Downed")
  if isDowned and not isReviving then
 isReviving = true
 
 if featureStates.SelfReviveMethod == "Spawnpoint" then
  if not hasRevived then
  hasRevived = true
  pcall(function()
 local Event = game:GetService("ReplicatedStorage").Events.Respawn
Event:FireServer()
  end)
  task.delay(10, function()
 hasRevived = false
  end)
  task.delay(1, function()
 isReviving = false
  end)
  else
  isReviving = false
  end
 elseif featureStates.SelfReviveMethod == "Fake Revive" then
  if newHRP then
  lastSavedPosition = newHRP.Position
  end
  
  task.spawn(function()
  pcall(function()
 ReplicatedStorage:WaitForChild("Events"):WaitForChild("Respawn"):FireServer()
  end)
  
  local freshCharacter
  repeat
 freshCharacter = player.Character
 task.wait()
  until freshCharacter and freshCharacter:FindFirstChild("HumanoidRootPart") and freshCharacter ~= newChar
  
  if freshCharacter then
 local freshHRP = freshCharacter:FindFirstChild("HumanoidRootPart")
 if lastSavedPosition and freshHRP then
  freshHRP.CFrame = CFrame.new(lastSavedPosition)
 end
  end
  
  isReviving = false
  end)
 end
  end
  end)
 end
  end)
  else
  if AutoSelfReviveConnection then
 AutoSelfReviveConnection:Disconnect()
 AutoSelfReviveConnection = nil
  end
  if respawnConnection then
 respawnConnection:Disconnect()
 respawnConnection = nil
  end
  hasRevived = false
  isReviving = false
  lastSavedPosition = nil
  end
 end
})

SelfReviveMethodDropdown = Tabs.Auto:Dropdown({
 Title = "Self Revive Method",
 Flag = "SelfReviveMethodDropdown",
 Values = {"Spawnpoint", "Fake Revive"},
 Value = "Spawnpoint",
 Callback = function(value)
  featureStates.SelfReviveMethod = value
 end
})

if player.Character and featureStates.AutoSelfRevive then
 local char = player.Character
 local humanoid = char:WaitForChild("Humanoid")
 local hrp = char:WaitForChild("HumanoidRootPart")
 AutoSelfReviveConnection = char:GetAttributeChangedSignal("Downed"):Connect(function()
 end)
end

function manualRevive()
 local character = player.Character
 if not character then return end
 local hrp = character:FindFirstChild("HumanoidRootPart")
 local isDowned = character:GetAttribute("Downed")
 if not isDowned then return end
 
 if featureStates.SelfReviveMethod == "Spawnpoint" then
  if not hasRevived then
  hasRevived = true
  pcall(function()
 local Event = game:GetService("ReplicatedStorage").Events.Respawn
Event:FireServer()
  end)
  task.delay(10, function()
 hasRevived = false
  end)
  end
 elseif featureStates.SelfReviveMethod == "Fake Revive" then
  if hrp then
  lastSavedPosition = hrp.Position
  end
  task.spawn(function()
  pcall(function()
 ReplicatedStorage:WaitForChild("Events"):WaitForChild("Respawn"):FireServer()
  end)
  
  local newCharacter
  repeat
 newCharacter = player.Character
 task.wait()
  until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= character
  
  if newCharacter then
 local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
 if lastSavedPosition and newHRP then
  newHRP.CFrame = CFrame.new(lastSavedPosition)
 end
  end
  end)
 end
end
Tabs.Auto:Button({
 Title = "Manual Revive",
 Desc = "Manually revive yourself",
 Icon = "heart",
 Callback = function()
  manualRevive()
 end
})

 Tabs.Auto:Space()
 AutoWhistleToggle = Tabs.Auto:Toggle({
 Title = "Auto Whistle",
 Flag = "AutoWhistleToggle",
 Value = false,
 Callback = function(state)
  featureStates.AutoWhistle = state
  if state then
  startAutoWhistle()
  else
  stopAutoWhistle()
  end
 end
})
local autoWhistleHandle = nil

function startAutoWhistle()
 if autoWhistleHandle then return end  
 autoWhistleHandle = task.spawn(function()
  while featureStates.AutoWhistle do
  pcall(function() 
 local Event = game:GetService("ReplicatedStorage").Events.Whistle
Event:FireServer()
  end)
  task.wait(1)
  end
 end)
end

function stopAutoWhistle()
 featureStates.AutoWhistle = false
 if autoWhistleHandle then
  task.cancel(autoWhistleHandle)
  autoWhistleHandle = nil
 end
end
Tabs.Auto:Section({ Title = "Afk Farm", TextSize = 20 })
Tabs.Auto:Divider()
Tabs.Auto:Paragraph({ 
Title = [[ Sorry but afk farm is Unsupported
 Your data is not begin saved in Legacy Evade don't waste your time :) ]],
 TextSize = 15 })
Tabs.Auto:Toggle({ Title = "AFK Farm", Value = false, Locked = true })
AFKType = Tabs.Auto:Dropdown({
    Title = "Farm Types",
    Flag = "AFKFarmType",
    Values = {"Not Available"},
    Value = "Not Available",
    Locked = true, 
    Callback = function(value)
return
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

AimbotEnabled = false
ShowFOV = false
FOVThickness = 2
FOVColor = Color3.new(0, 1, 0)
LocalPlayer = Players.LocalPlayer
Cam = workspace.CurrentCamera

targetTypes = {}
aimPart = "Head"
smoothnessValue = 10
wallCheckEnabled = false
fovRadius = 100
lockFOVToCenter = true
AimbotCircle = nil
aimbotRenderConnection = nil
aimbotRunning = false

function getAimPart(character)
    if aimPart == "Head" then
        return character:FindFirstChild("Head")
    elseif aimPart == "Body" then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    elseif aimPart == "Legs" then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return character:FindFirstChild("Head")
end

function isVisible(part)
    if not wallCheckEnabled then
        return true
    end
    
    character = LocalPlayer.Character
    if not character then return false end
    
    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    origin = humanoidRootPart.Position
    target = part.Position
    direction = (target - origin).Unit
    ray = Ray.new(origin, direction * (target - origin).Magnitude)
    hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {character, part.Parent})
    
    return hit == nil or hit:IsDescendantOf(part.Parent)
end

function lookAt(pos)
    currentCFrame = Cam.CFrame
    lookVector = (pos - currentCFrame.Position).Unit
    targetCFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + lookVector)
    
    Cam.CFrame = currentCFrame:Lerp(targetCFrame, 1 / smoothnessValue)
end

function isEnemyNPC(model)
    if not model:IsA("Model") then return false end
    local humanoid = model:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    -- Check for NPC indicators
    if model:GetAttribute("IsEnemy") then return true end
    if model:GetAttribute("IsNPC") then return true end
    if humanoid:GetAttribute("Team") == "Enemy" then return true end
    if model:FindFirstChild("NPC") or model:FindFirstChild("Enemy") then return true end
    
    -- Check for NPC storage location
    local npcStorage = workspace:FindFirstChild("NPCStorage")
    if npcStorage and model:IsDescendantOf(npcStorage) then return true end
    
    return false
end

function getAllTargets()
    local targets = {}
    
    -- Get player targets
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(targets, {type = "Player", object = player})
        end
    end
    
    -- Get NPC targets
    local npcStorage = workspace:FindFirstChild("NPCStorage")
    if npcStorage then
        for _, model in ipairs(npcStorage:GetChildren()) do
            if isEnemyNPC(model) then
                table.insert(targets, {type = "NPC", object = model})
            end
        end
    end
    
    -- Check in workspace for NPCs
    for _, model in ipairs(workspace:GetChildren()) do
        if isEnemyNPC(model) then
            table.insert(targets, {type = "NPC", object = model})
        end
    end
    
    return targets
end

function getClosestEnemyInFOV()
    local closestTarget = nil
    local closestDistance = math.huge
    
    local screenCenter = lockFOVToCenter and Cam.ViewportSize / 2 or UserInputService:GetMouseLocation()
    
    local allTargets = getAllTargets()
    
    for _, targetData in ipairs(allTargets) do
        local shouldTarget = false
        
        -- Check if target type is selected
        if #targetTypes == 0 then
            shouldTarget = true
        else
            for _, selectedType in ipairs(targetTypes) do
                if targetData.type == selectedType then
                    shouldTarget = true
                    break
                end
            end
        end
        
        if shouldTarget then
            local character = nil
            if targetData.type == "Player" then
                character = targetData.object.Character
            else -- NPC
                character = targetData.object
            end
            
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local aimPartInstance = getAimPart(character)
                if aimPartInstance then
                    local screenPos, visible = Cam:WorldToViewportPoint(aimPartInstance.Position)
                    if visible then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        if distance < fovRadius and distance < closestDistance and isVisible(aimPartInstance) then
                            closestDistance = distance
                            closestTarget = {
                                character = character,
                                type = targetData.type
                            }
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget
end

function createFOVCircle()
    if AimbotCircle then 
        AimbotCircle:Remove() 
        AimbotCircle = nil
    end
    
    if not ShowFOV then return end
    
    local circle = Drawing.new("Circle")
    circle.Visible = ShowFOV
    circle.Radius = fovRadius
    circle.Color = FOVColor
    circle.Thickness = FOVThickness
    circle.Filled = false
    
    if lockFOVToCenter then
        local viewportSize = Cam.ViewportSize
        circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    else
        circle.Position = UserInputService:GetMouseLocation()
    end
    
    AimbotCircle = circle
    
    if aimbotRenderConnection then
        aimbotRenderConnection:Disconnect()
    end
    
    aimbotRenderConnection = RunService.RenderStepped:Connect(function()
        if circle then
            circle.Radius = fovRadius
            circle.Visible = ShowFOV
            circle.Color = FOVColor
            circle.Thickness = FOVThickness
            
            if lockFOVToCenter then
                local viewportSize = Cam.ViewportSize
                circle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            else
                circle.Position = UserInputService:GetMouseLocation()
            end
        end
    end)
end

function updateDrawings()
    if ShowFOV and not AimbotCircle then
        createFOVCircle()
    elseif not ShowFOV and AimbotCircle then
        AimbotCircle:Remove()
        AimbotCircle = nil
    elseif AimbotCircle then
        AimbotCircle.Radius = fovRadius
        AimbotCircle.Color = FOVColor
        AimbotCircle.Thickness = FOVThickness
        
        if lockFOVToCenter then
            local viewportSize = Cam.ViewportSize
            AimbotCircle.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
        else
            AimbotCircle.Position = UserInputService:GetMouseLocation()
        end
    end
end

function startAimbot()
    createFOVCircle()
    
    aimbotRunning = true
    
    while AimbotEnabled and aimbotRunning do
        RunService.RenderStepped:Wait()
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then
            continue
        end
        
        local closestTarget = getClosestEnemyInFOV()
        if closestTarget then
            local character = closestTarget.character
            if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                local aimPartInstance = getAimPart(character)
                if aimPartInstance then
                    lookAt(aimPartInstance.Position)
                end
            end
        end
    end
end

function stopAimbot()
    aimbotRunning = false
    
    if AimbotCircle then
        AimbotCircle:Remove()
        AimbotCircle = nil
    end
    
    if aimbotRenderConnection then
        aimbotRenderConnection:Disconnect()
        aimbotRenderConnection = nil
    end
end

function handleCharacterRespawn()
    if AimbotEnabled then
        task.wait(1)
        if AimbotCircle then
            AimbotCircle:Remove()
            AimbotCircle = nil
        end
        createFOVCircle()
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    handleCharacterRespawn()
end)

Tabs.Combat:Section({ Title = "Aimbot Settings" })

AimbotToggle = Tabs.Combat:Toggle({
    Title = "Aimbot",
    Flag = "AimbotToggle",
    Value = false,
    Callback = function(state)
        AimbotEnabled = state
        if state then
            coroutine.wrap(startAimbot)()
        else
            stopAimbot()
        end
    end
})

AimPartDropdown = Tabs.Combat:Dropdown({
    Title = "Aim Part",
    Flag = "AimPartDropdown",
    Desc = "Select which part to aim at",
    Values = { "Head", "Body", "Legs" },
    Value = "Head",
    Callback = function(value)
        aimPart = value
    end
})

TargetTypeDropdown = Tabs.Combat:Dropdown({
    Title = "Target Type",
    Flag = "TargetTypeDropdown",
    Desc = "Select which types to target",
    Values = { "Player", "NPC" },
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(values)
        targetTypes = values
    end
})

SmoothnessSlider = Tabs.Combat:Slider({
    Title = "Smoothness",
    Flag = "SmoothnessSlider",
    Desc = "Higher = smoother aim, Lower = snappier aim",
    Value = { Min = 1, Max = 20, Default = 10, Step = 1 },
    Callback = function(value)
        smoothnessValue = value
    end
})

WallCheckToggle = Tabs.Combat:Toggle({
    Title = "Wall Check",
    Flag = "WallCheckToggle",
    Value = false,
    Callback = function(state)
        wallCheckEnabled = state
    end
})

Tabs.Combat:Section({ Title = "FOV Settings" })

ShowFOVToggle = Tabs.Combat:Toggle({
    Title = "Show FOV Circle",
    Flag = "ShowFOVToggle",
    Value = false,
    Callback = function(state)
        ShowFOV = state
        updateDrawings()
    end
})

LockFOVToggle = Tabs.Combat:Toggle({
    Title = "Lock FOV On Middle Screen",
    Flag = "LockFOVToggle",
    Value = true,
    Callback = function(state)
        lockFOVToCenter = state
        updateDrawings()
    end
})

FOVRadiusSlider = Tabs.Combat:Slider({
    Title = "FOV Radius",
    Flag = "FOVRadiusSlider",
    Desc = "Size of the targeting area",
    Value = { Min = 10, Max = 500, Default = 100, Step = 5 },
    Callback = function(value)
        fovRadius = value
        updateDrawings()
    end
})

FOVColorPicker = Tabs.Combat:Colorpicker({
    Title = "FOV Color",
    Flag = "FOVColorPicker",
    Desc = "FOV Circle Color",
    Default = Color3.fromRGB(0, 255, 0),
    Locked = false,
    Callback = function(color)
        FOVColor = color
        updateDrawings()
    end
})

FOVThicknessSlider = Tabs.Combat:Slider({
    Title = "FOV Thickness",
    Flag = "FOVThicknessSlider",
    Desc = "Thickness of the FOV circle",
    Value = { Min = 1, Max = 10, Default = 2, Step = 1 },
    Callback = function(value)
        FOVThickness = value
        updateDrawings()
    end
})

 -- Visuals Tab
 Tabs.Visuals:Section({ Title = "Visual", TextSize = 20 })
 Tabs.Visuals:Divider()
 local cameraStretchConnection
function setupCameraStretch()
 cameraStretchConnection = nil
 local stretchHorizontal = 0.80
 local stretchVertical = 0.80
 CameraStretchToggle = Tabs.Visuals:Toggle({
  Title = "Camera Stretch",
  Flag = "CameraStretchToggle",
  Value = false,
  Callback = function(state)
  if state then
 if cameraStretchConnection then cameraStretchConnection:Disconnect() end
 cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
  local Camera = workspace.CurrentCamera
  Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
 end)
  else
 if cameraStretchConnection then
  cameraStretchConnection:Disconnect()
  cameraStretchConnection = nil
 end
  end
  end
 })

 CameraStretchHorizontalInput = Tabs.Visuals:Input({
  Title = "Camera Stretch Horizontal",
  Flag = "CameraStretchHorizontalInput",
  Placeholder = "0.80",
  Numeric = true,
  Value = tostring(stretchHorizontal),
  Callback = function(value)
  local num = tonumber(value)
  if num then
 stretchHorizontal = num
 if cameraStretchConnection then
  cameraStretchConnection:Disconnect()
  cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
  local Camera = workspace.CurrentCamera
  Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
  end)
 end
  end
  end
 })

 CameraStretchVerticalInput = Tabs.Visuals:Input({
  Title = "Camera Stretch Vertical",
  Flag = "CameraStretchVerticalInput",
  Placeholder = "0.80",
  Numeric = true,
  Value = tostring(stretchVertical),
  Callback = function(value)
  local num = tonumber(value)
  if num then
 stretchVertical = num
 if cameraStretchConnection then
  cameraStretchConnection:Disconnect()
  cameraStretchConnection = game:GetService("RunService").RenderStepped:Connect(function()
  local Camera = workspace.CurrentCamera
  Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, stretchHorizontal, 0, 0, 0, stretchVertical, 0, 0, 0, 1)
  end)
 end
  end
  end
 })
end

setupCameraStretch()
FearScriptToggle = Tabs.Visuals:Toggle({
    Title = "Disable Fear Effect",
    Desc = "Remove View Bob fear effect/sounds including disable camshake",
    Flag = "FearScriptToggle",
    Value = false,
    Callback = function(state)
        local HUD = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HUD")
        if HUD then
            local FearScript = HUD:FindFirstChild("Fear")
            if FearScript then
                FearScript.Disabled = state
            end
        end
        
        if state then
            task.spawn(function()
                while FearScriptToggle.Value do
                    local HUD = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HUD")
                    if HUD then
                        local FearScript = HUD:FindFirstChild("Fear")
                        if FearScript then
                            FearScript.Disabled = true
                        end
                    end
                end
            end)
        end
    end
})
Tabs.Visuals:Space()

	 FullBrightToggle = Tabs.Visuals:Toggle({
 Title = "Full Bright",
 Flag = "FullBrightToggle",
 Desc = "Ya Like drinking Night Vision while mining in da cave and sceard of creeper blow you up dawg?",
 Value = false,
 Callback = function(state)
  featureStates.FullBright = state
  if state then
  
  featureStates.originalBrightness = Lighting.Brightness
  featureStates.originalAmbient = Lighting.Ambient
  featureStates.originalOutdoorAmbient = Lighting.OutdoorAmbient
  featureStates.originalColorShiftBottom = Lighting.ColorShift_Bottom
  featureStates.originalColorShiftTop = Lighting.ColorShift_Top
  
  function applyFullBright()
 if Lighting.Brightness ~= 1 then
  Lighting.Brightness = 1
 end
 if Lighting.Ambient ~= Color3.new(1, 1, 1) then
  Lighting.Ambient = Color3.new(1, 1, 1)
 end
 if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
  Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
 end
 if Lighting.ColorShift_Bottom ~= Color3.new(1, 1, 1) then
  Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
 end
 if Lighting.ColorShift_Top ~= Color3.new(1, 1, 1) then
  Lighting.ColorShift_Top = Color3.new(1, 1, 1)
 end
  end
  
  applyFullBright()
  
  if featureStates.fullBrightConnection then
 featureStates.fullBrightConnection:Disconnect()
  end
  
  featureStates.fullBrightConnection = RunService.Heartbeat:Connect(function()
 if featureStates.FullBright then
  applyFullBright()
 end
  end)
  
  featureStates.fullBrightCharConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
 task.wait(1)
 if featureStates.FullBright then
  applyFullBright()
 end
  end)
  
  else
  if featureStates.fullBrightConnection then
 featureStates.fullBrightConnection:Disconnect()
 featureStates.fullBrightConnection = nil
  end
  
  if featureStates.fullBrightCharConnection then
 featureStates.fullBrightCharConnection:Disconnect()
 featureStates.fullBrightCharConnection = nil
  end
  
  if featureStates.originalBrightness then
 Lighting.Brightness = featureStates.originalBrightness
 Lighting.Ambient = featureStates.originalAmbient
 Lighting.OutdoorAmbient = featureStates.originalOutdoorAmbient
 Lighting.ColorShift_Bottom = featureStates.originalColorShiftBottom
 Lighting.ColorShift_Top = featureStates.originalColorShiftTop
  end
  end
 end
})
Tabs.Visuals:Space()

NoFogToggle = Tabs.Visuals:Toggle({
 Title = "Remove Fog",
 Flag = "NoFogToggle",
 Value = false,
 Callback = function(state)
  featureStates.NoFog = state
  if state then
  startNoFog()
  else
  stopNoFog()
  end
 end
})
Tabs.Visuals:Space()

Tabs.Visuals:Button({
 Title = "Shit Render", 
 Callback = function()
  Lighting = game:GetService("Lighting")
  Terrain = workspace:FindFirstChildOfClass("Terrain")
  Players = game:GetService("Players")
  LocalPlayer = Players.LocalPlayer

  Lighting.GlobalShadows = false
  Lighting.FogEnd = 1e10
  Lighting.Brightness = 1

  if Terrain then
  Terrain.WaterWaveSize = 0
  Terrain.WaterWaveSpeed = 0
  Terrain.WaterReflectance = 0
  Terrain.WaterTransparency = 1
  end

  for _, obj in ipairs(workspace:GetDescendants()) do
  if obj:IsA("BasePart") then
 obj.Material = Enum.Material.Plastic
 obj.Reflectance = 0
  elseif obj:IsA("Decal") or obj:IsA("Texture") then
 obj:Destroy()
  elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
 obj:Destroy()
  elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
 obj:Destroy()
  end
  end

  for _, player in ipairs(Players:GetPlayers()) do
  local char = player.Character
  if char then
 for _, part in ipairs(char:GetDescendants()) do
  if part:IsA("Accessory") or part:IsA("Clothing") then
  part:Destroy()
  end
 end
  end
  end
 end
})
-- local originalFOV = workspace.CurrentCamera.FieldOfView
--[[local FOVSlider = Tabs.Visuals:Slider({
 Title = "Field of View",
 Flag = "FOVSlider",
 Desc = "Old fov has been moved to settings, will be add back in here soon",
 Value = { Min = 10, Max = 120, Default = originalFOV, Step = 1 },
 Callback = function(value)
  workspace.CurrentCamera.FieldOfView = tonumber(value)
 end
})
]]
Tabs.Visuals:Space()
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MainInterface = PlayerGui:FindFirstChild("MainInterface")
local TimerContainer, TimerLabel, StatusLabel

if MainInterface then
    TimerContainer = MainInterface:WaitForChild("Center"):WaitForChild("RoundTimer")
    local RoundTimerFrame = TimerContainer:WaitForChild("RoundTimer")
    TimerLabel = RoundTimerFrame:WaitForChild("Timer")
    StatusLabel = RoundTimerFrame:WaitForChild("About")
    
    local InnerFrame = RoundTimerFrame:WaitForChild("RoundTimer")
    if InnerFrame then
        local existingCorner = InnerFrame:FindFirstChild("UICorner")
        if not existingCorner then
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 8)
            UICorner.Parent = InnerFrame
        end
    end
else
    MainInterface = Instance.new("ScreenGui")
    MainInterface.Name = "MainInterface"
    MainInterface.Parent = PlayerGui
    MainInterface.ResetOnSpawn = false
    MainInterface.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MainInterface.Enabled = true
    MainInterface.DisplayOrder = 2
    
    TimerContainer = Instance.new("Frame")
    TimerContainer.Name = "Center"
    TimerContainer.Parent = MainInterface
    TimerContainer.AnchorPoint = Vector2.new(0.5, 1)
    TimerContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimerContainer.BackgroundTransparency = 1
    TimerContainer.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TimerContainer.Position = UDim2.new(0.5, 0, 1, 0)
    TimerContainer.Size = UDim2.new(1, 0, 1, 0)
    
    local AspectRatio = Instance.new("UIAspectRatioConstraint")
    AspectRatio.Parent = TimerContainer
    
    local RoundTimerFrame = Instance.new("Frame")
    RoundTimerFrame.Name = "RoundTimer"
    RoundTimerFrame.Parent = TimerContainer
    RoundTimerFrame.AnchorPoint = Vector2.new(0.5, 0)
    RoundTimerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    RoundTimerFrame.BackgroundTransparency = 1
    RoundTimerFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
    RoundTimerFrame.BorderSizePixel = 0
    RoundTimerFrame.Position = UDim2.new(0.5, 0, 0.02, 0)
    RoundTimerFrame.Size = UDim2.new(0.2, 0, 0.08, 0)
    RoundTimerFrame.ZIndex = 26
    
    local InnerFrame = Instance.new("Frame")
    InnerFrame.Name = "RoundTimer"
    InnerFrame.Parent = RoundTimerFrame
    InnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    InnerFrame.BackgroundTransparency = 0.6
    InnerFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
    InnerFrame.BorderSizePixel = 0
    InnerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    InnerFrame.Size = UDim2.new(1, 0, 1, 0)
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = InnerFrame
    
    TimerLabel = Instance.new("TextLabel")
    TimerLabel.Name = "Timer"
    TimerLabel.Parent = InnerFrame
    TimerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TimerLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimerLabel.BackgroundTransparency = 1
    TimerLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
    TimerLabel.Position = UDim2.new(0.5, 0, 0.65, 0)
    TimerLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    TimerLabel.ZIndex = 3
    TimerLabel.Font = Enum.Font.GothamBold
    TimerLabel.Text = "0:00"
    TimerLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
    TimerLabel.TextScaled = true
    TimerLabel.TextSize = 14
    TimerLabel.TextStrokeTransparency = 0.95
    TimerLabel.TextWrapped = true
    
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "About"
    StatusLabel.Parent = InnerFrame
    StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
    StatusLabel.Position = UDim2.new(0.5, 0, 0.25, 0)
    StatusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
    StatusLabel.ZIndex = 3
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.Text = "INTERMISSION"
    StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
    StatusLabel.TextScaled = true
    StatusLabel.TextSize = 14
    StatusLabel.TextStrokeTransparency = 0.95
    StatusLabel.TextWrapped = true
    
    local Background = Instance.new("ImageLabel")
    Background.Name = "Background"
    Background.Parent = InnerFrame
    Background.AnchorPoint = Vector2.new(0.5, 0.5)
    Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Background.BackgroundTransparency = 1
    Background.BorderColor3 = Color3.fromRGB(27, 42, 53)
    Background.Position = UDim2.new(0.5, 0, 0.5, 0)
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.ZIndex = 0
    Background.Image = "rbxassetid://196969716"
    Background.ImageColor3 = Color3.fromRGB(21, 21, 21)
    Background.ImageTransparency = 0.7
    
    local BackgroundCorner = Instance.new("UICorner")
    BackgroundCorner.CornerRadius = UDim.new(0, 8)
    BackgroundCorner.Parent = Background
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Transparency = 0.8
    UIStroke.Parent = InnerFrame
    
    local OverlayImage = Instance.new("ImageLabel")
    OverlayImage.Parent = InnerFrame
    OverlayImage.AnchorPoint = Vector2.new(0.5, 0.5)
    OverlayImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    OverlayImage.BackgroundTransparency = 1
    OverlayImage.BorderColor3 = Color3.fromRGB(27, 42, 53)
    OverlayImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    OverlayImage.Size = UDim2.new(0.8, 0, 1, 0)
    OverlayImage.ZIndex = 2
    OverlayImage.Image = "rbxassetid://6761866149"
    OverlayImage.ImageColor3 = Color3.fromRGB(165, 194, 255)
    OverlayImage.ImageTransparency = 0.9
    OverlayImage.ScaleType = Enum.ScaleType.Crop
    
    local OverlayCorner = Instance.new("UICorner")
    OverlayCorner.CornerRadius = UDim.new(0, 4)
    OverlayCorner.Parent = OverlayImage
end

local isTimerEnabled = false
local activeConnections = {}
local folderAddedConnection
local spectateMonitorConnection

function formatTime(seconds)
    if not seconds then return "0:00" end
    
    seconds = math.floor(tonumber(seconds) or 0)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    
    return string.format("%d:%02d", minutes, remainingSeconds)
end

function checkSpectateVisibility()
    local Menu = PlayerGui:FindFirstChild("Menu")
    if Menu then
        local Spectate = Menu:FindFirstChild("Spectate")
        if Spectate and Spectate.Visible then
            return true
        end
    end
    return false
end

function updateTimerDisplay()
    if checkSpectateVisibility() then
        TimerContainer.Visible = false
        return
    end
    
    if not isTimerEnabled then
        TimerContainer.Visible = false
        return
    end
    
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then 
        TimerContainer.Visible = false
        return
    end
    
    local statsFolder = gameFolder:FindFirstChild("Stats")
    if not statsFolder then 
        TimerContainer.Visible = false
        return
    end
    
    TimerContainer.Visible = true
    
    local timeRemaining = statsFolder:GetAttribute("TimeRemaining") or statsFolder:GetAttribute("Timer")
    local roundStarted = statsFolder:GetAttribute("RoundStarted")
    local ready = statsFolder:GetAttribute("Ready")
    
    if timeRemaining then
        TimerLabel.Text = formatTime(timeRemaining)
        
        if timeRemaining <= 5 then
            TimerLabel.TextColor3 = Color3.fromRGB(215, 100, 100)
            StatusLabel.TextColor3 = Color3.fromRGB(215, 100, 100)
        else
            TimerLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
            StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
        end
    end
    
    -- New logic: Check both RoundStarted and Ready attributes
    if roundStarted == true then
        StatusLabel.Text = "ROUND ACTIVE"
    elseif ready == true then
        StatusLabel.Text = "INTERMISSION"
    else
        StatusLabel.Text = "ROUND INACTIVE"
    end
end

function setupTimerConnection()
    for _, connection in pairs(activeConnections) do
        connection:Disconnect()
    end
    activeConnections = {}
    
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return end
    
    local statsFolder = gameFolder:FindFirstChild("Stats")
    if not statsFolder then return end
    
    table.insert(activeConnections, statsFolder:GetAttributeChangedSignal("TimeRemaining"):Connect(updateTimerDisplay))
    table.insert(activeConnections, statsFolder:GetAttributeChangedSignal("Timer"):Connect(updateTimerDisplay))
    table.insert(activeConnections, statsFolder:GetAttributeChangedSignal("RoundStarted"):Connect(updateTimerDisplay))
    table.insert(activeConnections, statsFolder:GetAttributeChangedSignal("Ready"):Connect(updateTimerDisplay))
    
    updateTimerDisplay()
end

function cleanupTimer()
    for _, connection in pairs(activeConnections) do
        connection:Disconnect()
    end
    activeConnections = {}
    
    if folderAddedConnection then
        folderAddedConnection:Disconnect()
        folderAddedConnection = nil
    end
    
    if spectateMonitorConnection then
        spectateMonitorConnection:Disconnect()
        spectateMonitorConnection = nil
    end
end

function monitorSpectateVisibility()
    local Menu = PlayerGui:FindFirstChild("Menu")
    if Menu then
        local Spectate = Menu:FindFirstChild("Spectate")
        if Spectate then
            spectateMonitorConnection = Spectate:GetPropertyChangedSignal("Visible"):Connect(function()
                updateTimerDisplay()
            end)
        end
    end
end

folderAddedConnection = workspace.ChildAdded:Connect(function(child)
    if child.Name == "Game" then
        if isTimerEnabled then
            setupTimerConnection()
        end
    end
end)

local statsMonitorConnection
statsMonitorConnection = workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Stats" and descendant.Parent and descendant.Parent.Name == "Game" then
        if isTimerEnabled then
            setupTimerConnection()
        end
    end
end)

if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Stats") then
    setupTimerConnection()
end

monitorSpectateVisibility()

TimerDisplayToggle = Tabs.Visuals:Toggle({
    Title = "Timer Display",
    Flag = "TimerDisplayToggle",
    Value = false,
    Callback = function(state)
        isTimerEnabled = state
        
        if state then
            if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Stats") then
                setupTimerConnection()
            end
            updateTimerDisplay()
        else
            TimerContainer.Visible = false
            cleanupTimer()
        end
    end
})

local RunService = game:GetService("RunService")
local lastUpdateTime = 0

local updateLoop = RunService.Heartbeat:Connect(function()
    if not isTimerEnabled then return end
    
    local currentTime = tick()
    if currentTime - lastUpdateTime > 0.5 then
        lastUpdateTime = currentTime
        pcall(updateTimerDisplay)
    end
end)

game:GetService("Players").LocalPlayer.AncestryChanged:Connect(function()
    cleanupTimer()
    if statsMonitorConnection then
        statsMonitorConnection:Disconnect()
    end
    if updateLoop then
        updateLoop:Disconnect()
    end
end)
Tabs.Visuals:Section({ Title = "Emote Changer", TextSize = 20 })
Tabs.Visuals:Divider()

originalEmotes = {}
for i = 1, 8 do
    originalEmotes[i] = game:GetService("Players").LocalPlayer:GetAttribute("Emote" .. i) or ""
end

hookInstalled = false
blockRemote = false
emoteSpeedConnection = nil
tpcameraConnection = nil
emotingAttributeConnection = nil
pendingEmoteChanges = {}
emoteSpeedCache = {}

function GetPlayerTagData()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if character then
        return character:GetAttribute("Tag")
    end
    
    return nil
end

function TriggerTagEmote(emoteSlot)
    if not blockRemote then return end
    
    local emoteName = pendingEmoteChanges[emoteSlot] or game:GetService("Players").LocalPlayer:GetAttribute("Emote" .. emoteSlot)
    if not emoteName or emoteName == "" then return end
    
    local tagData = GetPlayerTagData()
    if not tagData then return end
    
    local characterEvent = game:GetService("ReplicatedStorage").Events.Character.Emote
    firesignal(characterEvent.OnClientEvent, tagData, emoteName)
end

function GetEmoteSpeedFromModule(emoteName)
    if emoteSpeedCache[emoteName] then
        return emoteSpeedCache[emoteName]
    end
    
    local replicatedStorage = game:GetService("ReplicatedStorage")
    if not replicatedStorage then return 1 end
    
    local itemsFolder = replicatedStorage:FindFirstChild("Items")
    if not itemsFolder then return 1 end
    
    local emotesFolder = itemsFolder:FindFirstChild("Emotes")
    if not emotesFolder then return 1 end
    
    local emoteModule = emotesFolder:FindFirstChild(emoteName)
    if not emoteModule or not emoteModule:IsA("ModuleScript") then return 1 end
    
    local success, emoteData = pcall(require, emoteModule)
    if not success or not emoteData then return 1 end
    
    local speedMult = emoteData.SpeedMult or emoteData.EmoteInfo and emoteData.EmoteInfo.SpeedMult or 1
    emoteSpeedCache[emoteName] = speedMult
    return speedMult
end

function SetupEmoteSpeedChange(apply)
    if emoteSpeedConnection then
        emoteSpeedConnection:Disconnect()
        emoteSpeedConnection = nil
    end
    
    local playerModel = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
    if playerModel then
        local localPlayerModel = playerModel:FindFirstChild(game.Players.LocalPlayer.Name)
        if localPlayerModel then
            local isEmoting = localPlayerModel:GetAttribute("Emoting")
            
            if isEmoting == true then
                local emoteName = nil
                for i = 1, 8 do
                    local currentEmote = game:GetService("Players").LocalPlayer:GetAttribute("Emote" .. i)
                    if currentEmote and currentEmote ~= "" then
                        emoteName = currentEmote
                        break
                    end
                end
                
                if emoteName then
                    local speedMult = GetEmoteSpeedFromModule(emoteName)
                    local statChanges = localPlayerModel:FindFirstChild("StatChanges")
                    if statChanges then
                        local speed = statChanges:FindFirstChild("Speed")
                        if speed then
                            local emoteSpeed = speed:FindFirstChild("EmoteSpeed")
                            
                            if apply then
                                if emoteSpeed then
                                    emoteSpeed.Value = speedMult
                                else
                                    emoteSpeed = Instance.new("NumberValue")
                                    emoteSpeed.Name = "EmoteSpeed"
                                    emoteSpeed.Value = speedMult
                                    emoteSpeed.Parent = speed
                                end
                            else
                                if emoteSpeed then
                                    emoteSpeed:Destroy()
                                end
                            end
                        end
                    end
                end
            else
                local statChanges = localPlayerModel:FindFirstChild("StatChanges")
                if statChanges then
                    local speed = statChanges:FindFirstChild("Speed")
                    if speed then
                        local emoteSpeed = speed:FindFirstChild("EmoteSpeed")
                        if emoteSpeed then
                            emoteSpeed:Destroy()
                        end
                    end
                end
            end
            
            if apply then
                emoteSpeedConnection = localPlayerModel:GetAttributeChangedSignal("Emoting"):Connect(function()
                    local newIsEmoting = localPlayerModel:GetAttribute("Emoting")
                    local statChanges = localPlayerModel:FindFirstChild("StatChanges")
                    
                    if statChanges then
                        local speed = statChanges:FindFirstChild("Speed")
                        if speed then
                            local emoteSpeed = speed:FindFirstChild("EmoteSpeed")
                            
                            if newIsEmoting == true then
                                local emoteName = nil
                                for i = 1, 8 do
                                    local currentEmote = game:GetService("Players").LocalPlayer:GetAttribute("Emote" .. i)
                                    if currentEmote and currentEmote ~= "" then
                                        emoteName = currentEmote
                                        break
                                    end
                                end
                                
                                if emoteName then
                                    local speedMult = GetEmoteSpeedFromModule(emoteName)
                                    if not emoteSpeed then
                                        emoteSpeed = Instance.new("NumberValue")
                                        emoteSpeed.Name = "EmoteSpeed"
                                        emoteSpeed.Value = speedMult
                                        emoteSpeed.Parent = speed
                                    else
                                        emoteSpeed.Value = speedMult
                                    end
                                end
                            else
                                if emoteSpeed then
                                    emoteSpeed:Destroy()
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end

function SetupTPCameraOnEmoting(apply)
    if tpcameraConnection then
        tpcameraConnection:Disconnect()
        tpcameraConnection = nil
    end
    
    if emotingAttributeConnection then
        emotingAttributeConnection:Disconnect()
        emotingAttributeConnection = nil
    end
    
    if apply then
        local playerModel = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
        if playerModel then
            local localPlayerModel = playerModel:FindFirstChild(game.Players.LocalPlayer.Name)
            if localPlayerModel then
                emotingAttributeConnection = localPlayerModel:GetAttributeChangedSignal("Emoting"):Connect(function()
                    local isEmoting = localPlayerModel:GetAttribute("Emoting")
                    if isEmoting == true then
                        local Event = game:GetService("Players").LocalPlayer.Character.Client
                        firesignal(Event.OnClientEvent, "TPCamera", {Zoom = 10})
                    end
                end)
            end
        end
    end
end

function InstallHook()
    local Event = game:GetService("ReplicatedStorage").Events.Emote
    
    if hookInstalled then return end
    
    local success, errorMsg = pcall(function()
        local mt = getrawmetatable(Event)
        if mt and mt.__namecall then
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            
            mt.__namecall = function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" then
                    local args = {...}
                    local emoteNum = tostring(args[1])
                    if blockRemote and emoteNum:match("^[1-8]$") then
                        TriggerTagEmote(tonumber(emoteNum))
                        return
                    end
                end
                return oldNamecall(self, ...)
            end
            
            setreadonly(mt, true)
            hookInstalled = true
            WindUI:Notify({
                Title = "Hook Status",
                Content = "Emote hook installed successfully",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Hook Status",
                Content = "Could not get metatable, using fallback",
                Duration = 3
            })
        end
    end)
    
    if not success then
        WindUI:Notify({
            Title = "Hook Error",
            Content = "Failed to install hook: " .. tostring(errorMsg),
            Duration = 3
        })
    end
    
    if not hookInstalled then
        WindUI:Notify({
            Title = "Hook Status",
            Content = "Using fallback method",
            Duration = 3
        })
    end
end

function ScanReplicatedStorageEmotes()
    emotes = {}
    replicatedStorage = game:GetService("ReplicatedStorage")
    
    if replicatedStorage then
        itemsFolder = replicatedStorage:FindFirstChild("Items")
        if itemsFolder then
            emotesFolder = itemsFolder:FindFirstChild("Emotes")
            if emotesFolder then
                for _, item in pairs(emotesFolder:GetChildren()) do
                    table.insert(emotes, item.Name)
                end
            end
        end
    end
    
    return #emotes > 0 and emotes or {"No emotes found"}
end

emoteValues = ScanReplicatedStorageEmotes()

emoteDropdowns = {}

for i = 1, 8 do
    currentEmote = game:GetService("Players").LocalPlayer:GetAttribute("Emote" .. i) or ""
    
    emoteDropdowns[i] = Tabs.Visuals:Dropdown({
        Title = "Emote Slot " .. i,
        Flag = "EmoteSlot" .. i,
        Desc = "Current: " .. currentEmote,
        Values = emoteValues,
        Value = currentEmote,
        Multi = false,
        AllowNone = true,
        Callback = function(value)
            pendingEmoteChanges[i] = value
            emoteDropdowns[i].Desc = "Pending: " .. (value or "Not set")
        end
    })
end

Tabs.Visuals:Space()

Tabs.Visuals:Button({
    Title = "Apply All Emotes",
    Desc = "Apply current emote settings",
    Callback = function()
        blockRemote = true
        local success, errorMsg = pcall(function()
            for i = 1, 8 do
                if pendingEmoteChanges[i] then
                    game:GetService("Players").LocalPlayer:SetAttribute("Emote" .. i, pendingEmoteChanges[i])
                    emoteDropdowns[i].Desc = "Applied: " .. (pendingEmoteChanges[i] or "Not set")
                end
            end
            pendingEmoteChanges = {}
            SetupEmoteSpeedChange(true)
            SetupTPCameraOnEmoting(true)
            InstallHook()
        end)
        
        if success then
            WindUI:Notify({
                Title = "Emotes Applied",
                Content = "Custom emotes are now active",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Apply Error",
                Content = "Failed to apply emotes: " .. tostring(errorMsg),
                Duration = 3
            })
        end
    end
})

Tabs.Visuals:Button({
    Title = "Reset All Emotes",
    Desc = "Restore original emote state",
    Callback = function()
        blockRemote = false
        local success, errorMsg = pcall(function()
            SetupEmoteSpeedChange(false)
            SetupTPCameraOnEmoting(false)
            pendingEmoteChanges = {}
            for i = 1, 8 do
                game:GetService("Players").LocalPlayer:SetAttribute("Emote" .. i, originalEmotes[i])
                emoteDropdowns[i]:Set(originalEmotes[i])
                emoteDropdowns[i].Desc = "Current: " .. (originalEmotes[i] or "Not set")
            end
        end)
        
        if success then
            WindUI:Notify({
                Title = "Emotes Reset",
                Content = "All emotes restored to original",
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "Reset Error",
                Content = "Failed to reset emotes: " .. tostring(errorMsg),
                Duration = 3
            })
        end
    end
})

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    
    if blockRemote then
        local success = pcall(function()
            SetupEmoteSpeedChange(true)
            SetupTPCameraOnEmoting(true)
        end)
    end
end)

if game:GetService("Players").LocalPlayer.Character then
    if blockRemote then
        task.wait(1)
        local success = pcall(function()
            SetupEmoteSpeedChange(true)
            SetupTPCameraOnEmoting(true)
        end)
    end
end

InstallHook()
Players = game:GetService("Players")
ReplicatedStorage = game:GetService("ReplicatedStorage")
player = Players.LocalPlayer

if not player:FindFirstChild("Cosmetics") then
    player.Cosmetics = Instance.new("Folder")
end
if not player.Cosmetics:FindFirstChild("Equipped") then
    player.Cosmetics.Equipped = Instance.new("Folder")
end

CosmeticsFolder = ReplicatedStorage:FindFirstChild("Items") and ReplicatedStorage.Items:FindFirstChild("Cosmetics")

ScriptAddedCosmetics = {}

function isValidCosmetic(cosmeticName)
    return CosmeticsFolder and CosmeticsFolder:FindFirstChild(cosmeticName) ~= nil
end

function isCosmeticEquipped(cosmeticName)
    return player.Cosmetics:GetAttribute(cosmeticName) ~= nil
end

Tabs.Visuals:Section({ Title = "Cosmetics Spawner", TextSize = 20 })
Tabs.Visuals:Divider()

Tabs.Visuals:Paragraph({
    Title = "Head's up! This Feature may broken, in able to solve bugs or glitches you may have to rejoin.",
    TextSize = 14
})

CosmeticNameInput = Tabs.Visuals:Input({
    Title = "Cosmetic Name",
    Placeholder = "Exact name from ReplicatedStorage",
    Callback = function(inputText)
        CosmeticNameInput.currentValue = inputText
    end
})

Tabs.Visuals:Button({
    Title = "Add Cosmetic",
    Icon = "plus-circle",
    Callback = function()
        name = CosmeticNameInput.currentValue
        if not name or name == "" then
            WindUI:Notify({ Title = "Error", Content = "Name is empty!", Duration = 3 })
            return
        end
        if not isValidCosmetic(name) then
            WindUI:Notify({ Title = "Invalid", Content = "'" .. name .. "' not found!", Duration = 3 })
            return
        end
        if isCosmeticEquipped(name) then
            WindUI:Notify({ Title = "Duplicate", Content = "'" .. name .. "' is already equipped!", Duration = 3 })
            return
        end
        player.Cosmetics:SetAttribute(name, name)
        player.Cosmetics.Equipped:SetAttribute(name, name)
        table.insert(ScriptAddedCosmetics, name)
        WindUI:Notify({ Title = "Success", Content = "Equipped: " .. name, Duration = 3 })
    end
})

Tabs.Visuals:Button({
    Title = "Remove Cosmetic",
    Icon = "minus-circle",
    Callback = function()
        name = CosmeticNameInput.currentValue
        if not name or name == "" then
            WindUI:Notify({ Title = "Error", Content = "Name is empty!", Duration = 3 })
            return
        end
        if not isCosmeticEquipped(name) then
            WindUI:Notify({ Title = "Not Found", Content = "'" .. name .. "' isn't equipped!", Duration = 3 })
            return
        end
        player.Cosmetics:SetAttribute(name, nil)
        player.Cosmetics.Equipped:SetAttribute(name, nil)
        for i = #ScriptAddedCosmetics, 1, -1 do
            if ScriptAddedCosmetics[i] == name then
                table.remove(ScriptAddedCosmetics, i)
            end
        end
        WindUI:Notify({ Title = "Removed", Content = "Unequipped: " .. name, Duration = 3 })
    end
})

Tabs.Visuals:Button({
    Title = "Reset Script Cosmetics",
    Icon = "rotate-ccw",
    Color = Color3.fromRGB(255, 165, 0),
    Callback = function()
        for _, name in ipairs(ScriptAddedCosmetics) do
            player.Cosmetics:SetAttribute(name, nil)
            player.Cosmetics.Equipped:SetAttribute(name, nil)
        end
        ScriptAddedCosmetics = {}
        WindUI:Notify({ Title = "Reset", Content = "All script-added cosmetics cleared.", Duration = 3 })
    end
}) 
Tabs.Visuals:Section({ Title = "Cosmetics Changer", TextSize = 20 })
 Tabs.Visuals:Divider()
 
 local cosmetic1, cosmetic2 = "" --made by @.scv8 discord server https://discord.gg/RBZVmT6UKs
 local originalCosmetic1, originalCosmetic2 = "", ""
 local isSwapped = false
 
 Tabs.Visuals:Input({
  Title = "Current Cosmetics",
  Placeholder = "",
  Callback = function(v) 
  cosmetic1 = v
  if not isSwapped then
 originalCosmetic1 = v
  end
  end
 })
 
 Tabs.Visuals:Input({
  Title = "Select Cosmetics",
  Placeholder = "",
  Callback = function(v) 
  cosmetic2 = v
  if not isSwapped then
 originalCosmetic2 = v
  end
  end
 })
 
 Tabs.Visuals:Button({
  Title = "Apply Cosmetics",
  Callback = function()
  pcall(function()
 if cosmetic1 == "" or cosmetic2 == "" or cosmetic1 == cosmetic2 then return end
 
 local Cosmetics = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Cosmetics") 
 
 function normalize(str) 
  return str:gsub("%s+", ""):lower() 
 end 
 
 function levenshtein(s, t) 
  local m, n = #s, #t 
  local d = {} 
  for i = 0, m do d[i] = {[0] = i} end 
  for j = 0, n do d[0][j] = j end 
  
  for i = 1, m do 
  for j = 1, n do 
 local cost = (s:sub(i,i) == t:sub(j,j)) and 0 or 1 
 d[i][j] = math.min( 
  d[i-1][j] + 1, 
  d[i][j-1] + 1, 
  d[i-1][j-1] + cost 
 ) 
  end 
  end 
  return d[m][n] 
 end 
 
 function similarity(s, t) 
  local nS, nT = normalize(s), normalize(t) 
  local dist = levenshtein(nS, nT) 
  return 1 - dist / math.max(#nS, #nT) 
 end 
 
 function findSimilar(name) 
  local bestMatch = name 
  local bestScore = 0.5 
  for _, c in ipairs(Cosmetics:GetChildren()) do 
  local score = similarity(name, c.Name) 
  if score > bestScore then 
 bestScore = score 
 bestMatch = c.Name 
  end 
  end 
  return bestMatch 
 end 
 
 cosmetic1 = findSimilar(cosmetic1) 
 cosmetic2 = findSimilar(cosmetic2) 
 
 local a = Cosmetics:FindFirstChild(cosmetic1) 
 local b = Cosmetics:FindFirstChild(cosmetic2) 
 if not a or not b then return end 
 
 if not isSwapped then
  originalCosmetic1 = cosmetic1
  originalCosmetic2 = cosmetic2
 end
 
 local tempRoot = Instance.new("Folder", Cosmetics) 
 tempRoot.Name = "__temp_swap_" .. tostring(tick()):gsub("%.", "_") 
 
 local tempA = Instance.new("Folder", tempRoot) 
 local tempB = Instance.new("Folder", tempRoot) 
 
 for _, c in ipairs(a:GetChildren()) do c.Parent = tempA end 
 for _, c in ipairs(b:GetChildren()) do c.Parent = tempB end 
 
 for _, c in ipairs(tempA:GetChildren()) do c.Parent = b end 
 for _, c in ipairs(tempB:GetChildren()) do c.Parent = a end 
 
 tempRoot:Destroy()
 
 isSwapped = true
 
 WindUI:Notify({
  Title = "Cosmetics Changer",
  Content = "Successfully swapped " .. cosmetic1 .. " with " .. cosmetic2,
  Duration = 3
 })
  end) 
  end
 })
 
 Tabs.Visuals:Button({
  Title = "Reset Cosmetics",
  Desc = "Restore cosmetics to their original state",
  Callback = function()
  pcall(function()
 if not isSwapped then
  WindUI:Notify({
  Title = "Cosmetics Changer",
  Content = "No cosmetics have been swapped yet",
  Duration = 3
  })
  return
 end
 
 if originalCosmetic1 == "" or originalCosmetic2 == "" then
  WindUI:Notify({
  Title = "Cosmetics Changer",
  Content = "Original cosmetic names not found",
  Duration = 3
  })
  return
 end
 
 local Cosmetics = ReplicatedStorage:WaitForChild("Items"):WaitForChild("Cosmetics") 
 
 function normalize(str) 
  return str:gsub("%s+", ""):lower() 
 end 
 
 function findSimilar(name) 
  local bestMatch = name 
  local bestScore = 0.5 
  for _, c in ipairs(Cosmetics:GetChildren()) do 
  local normalizedInput = normalize(name)
  local normalizedCosmetic = normalize(c.Name)
  if normalizedInput == normalizedCosmetic then
 return c.Name
  end
  end 
  return name
 end 
 
 local resetCosmetic1 = findSimilar(originalCosmetic1)
 local resetCosmetic2 = findSimilar(originalCosmetic2)
 
 local a = Cosmetics:FindFirstChild(cosmetic1) 
 local b = Cosmetics:FindFirstChild(cosmetic2) 
 
 if a and b then
  local tempRoot = Instance.new("Folder", Cosmetics) 
  tempRoot.Name = "__temp_reset_" .. tostring(tick()):gsub("%.", "_") 
  
  local tempA = Instance.new("Folder", tempRoot) 
  local tempB = Instance.new("Folder", tempRoot) 
  
  for _, c in ipairs(a:GetChildren()) do c.Parent = tempA end 
  for _, c in ipairs(b:GetChildren()) do c.Parent = tempB end 
  
  for _, c in ipairs(tempA:GetChildren()) do c.Parent = b end 
  for _, c in ipairs(tempB:GetChildren()) do c.Parent = a end 
  
  tempRoot:Destroy()
  
  isSwapped = false
  
  WindUI:Notify({
  Title = "Cosmetics Changer",
  Content = "Successfully reset cosmetics to original state",
  Duration = 3
  })
 else
  WindUI:Notify({
  Title = "Cosmetics Changer",
  Content = "Could not find swapped cosmetics to reset",
  Duration = 3
  })
 end
  end)
  end
 })
currentCarryAnim = ""
selectedCarryAnim = ""
lastCurrentCarryAnim = ""
lastSelectedCarryAnim = ""
isSwapped = false

currentPerk = ""
selectedPerk = ""
lastCurrentPerk = ""
lastSelectedPerk = ""
isPerkSwapped = false

currentPerk2 = ""
selectedPerk2 = ""
lastCurrentPerk2 = ""
lastSelectedPerk2 = ""
isPerkSwapped2 = false

currentTool = ""
currentSkin = ""
selectedSkin = ""
lastCurrentTool = ""
lastCurrentSkin = ""
lastSelectedSkin = ""
isSkinSwapped = false

function normalizeString(str)
 return str:gsub("%s+", ""):lower()
end

function isValidCarryAnimation(name)
 carryAnimations = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not carryAnimations then return false end
 carryAnimations = carryAnimations:FindFirstChild("CarryAnimations")
 if not carryAnimations then return false end
 
 normalizedInput = normalizeString(name)
 for _, anim in ipairs(carryAnimations:GetChildren()) do
  if normalizeString(anim.Name) == normalizedInput then
  return true, anim.Name
  end
 end
 return false
end

function revertPreviousSwap()
 if lastCurrentCarryAnim ~= "" and lastSelectedCarryAnim ~= "" and isSwapped then
  carryAnimations = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
  if carryAnimations then
  carryAnimations = carryAnimations:FindFirstChild("CarryAnimations")
  if carryAnimations then
 lastCurrentValid, lastCurrentActual = isValidCarryAnimation(lastCurrentCarryAnim)
 lastSelectedValid, lastSelectedActual = isValidCarryAnimation(lastSelectedCarryAnim)
 
 if lastCurrentValid and lastSelectedValid then
  pcall(function()
  currentFolder = carryAnimations:FindFirstChild(lastCurrentActual)
  selectedFolder = carryAnimations:FindFirstChild(lastSelectedActual)
  
  if currentFolder and selectedFolder then
 tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_revert_swap_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = carryAnimations
 
 tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot
 
 tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot
 
 for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
 end
 
 for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
 end
 
 for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
 end
 
 for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
 end
 
 tempRoot:Destroy()
  end
  end)
 end
  end
  end
  isSwapped = false
 end
end

function swapCarryAnimations(current, selected)
 revertPreviousSwap()
 
 currentNorm = normalizeString(current)
 selectedNorm = normalizeString(selected)
 
 if currentNorm == "" or selectedNorm == "" then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "Both animation names must be filled",
  Duration = 3
  })
  return
 end
 
 if currentNorm == selectedNorm then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "Animation names cannot be the same",
  Duration = 3
  })
  return
 end
 
 carryAnimations = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not carryAnimations then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "CarryAnimations folder not found",
  Duration = 3
  })
  return
 end
 
 carryAnimations = carryAnimations:FindFirstChild("CarryAnimations")
 if not carryAnimations then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "CarryAnimations folder not found",
  Duration = 3
  })
  return
 end
 
 currentAnim, currentActualName = isValidCarryAnimation(current)
 selectedAnim, selectedActualName = isValidCarryAnimation(selected)
 
 if not currentAnim then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "Current animation not found: " .. current,
  Duration = 3
  })
  return
 end
 
 if not selectedAnim then
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "Selected animation not found: " .. selected,
  Duration = 3
  })
  return
 end
 
 pcall(function()
  currentFolder = carryAnimations:FindFirstChild(currentActualName)
  selectedFolder = carryAnimations:FindFirstChild(selectedActualName)
  
  if not currentFolder or not selectedFolder then
  WindUI:Notify({
 Title = "CarryAnimation Replacer",
 Content = "One or both animations not found in folder",
 Duration = 3
  })
  return
  end
  
  tempRoot = Instance.new("Folder")
  tempRoot.Name = "__temp_carry_swap_" .. tostring(tick()):gsub("%.", "_")
  tempRoot.Parent = carryAnimations
  
  tempCurrent = Instance.new("Folder")
  tempCurrent.Name = "tempCurrent"
  tempCurrent.Parent = tempRoot
  
  tempSelected = Instance.new("Folder")
  tempSelected.Name = "tempSelected"
  tempSelected.Parent = tempRoot
  
  for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
  end
  
  for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
  end
  
  for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
  end
  
  for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
  end
  
  tempRoot:Destroy()
  
  lastCurrentCarryAnim = current
  lastSelectedCarryAnim = selected
  isSwapped = true
  
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "Successfully swapped " .. currentActualName .. " with " .. selectedActualName,
  Duration = 3
  })
 end)
end

function isValidPerk(name)
 perks = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not perks then return false end
 perks = perks:FindFirstChild("Perks")
 if not perks then return false end
 
 normalizedInput = normalizeString(name)
 for _, perk in ipairs(perks:GetChildren()) do
  if normalizeString(perk.Name) == normalizedInput then
  return true, perk.Name
  end
 end
 return false
end

function revertPreviousPerkSwap()
 if lastCurrentPerk ~= "" and lastSelectedPerk ~= "" and isPerkSwapped then
  perks = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
  if perks then
  perks = perks:FindFirstChild("Perks")
  if perks then
 lastCurrentValid, lastCurrentActual = isValidPerk(lastCurrentPerk)
 lastSelectedValid, lastSelectedActual = isValidPerk(lastSelectedPerk)
 
 if lastCurrentValid and lastSelectedValid then
  pcall(function()
  currentFolder = perks:FindFirstChild(lastCurrentActual)
  selectedFolder = perks:FindFirstChild(lastSelectedActual)
  
  if currentFolder and selectedFolder then
 tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_perk_revert_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = perks
 
 tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot
 
 tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot
 
 for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
 end
 
 for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
 end
 
 for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
 end
 
 for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
 end
 
 tempRoot:Destroy()
  end
  end)
 end
  end
  end
  isPerkSwapped = false
 end
end

function swapPerks(current, selected)
 revertPreviousPerkSwap()
 
 currentNorm = normalizeString(current)
 selectedNorm = normalizeString(selected)
 
 if currentNorm == "" or selectedNorm == "" then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Both perk names must be filled",
  Duration = 3
  })
  return
 end
 
 if currentNorm == selectedNorm then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Perk names cannot be the same",
  Duration = 3
  })
  return
 end
 
 perks = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not perks then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Perks folder not found",
  Duration = 3
  })
  return
 end
 
 perks = perks:FindFirstChild("Perks")
 if not perks then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Perks folder not found",
  Duration = 3
  })
  return
 end
 
 currentPerkValid, currentActualName = isValidPerk(current)
 selectedPerkValid, selectedActualName = isValidPerk(selected)
 
 if not currentPerkValid then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Current perk not found: " .. current,
  Duration = 3
  })
  return
 end
 
 if not selectedPerkValid then
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Selected perk not found: " .. selected,
  Duration = 3
  })
  return
 end
 
 pcall(function()
  currentFolder = perks:FindFirstChild(currentActualName)
  selectedFolder = perks:FindFirstChild(selectedActualName)
  
  if not currentFolder or not selectedFolder then
  WindUI:Notify({
 Title = "Perk Replacer",
 Content = "One or both perks not found in folder",
 Duration = 3
  })
  return
  end
  
  tempRoot = Instance.new("Folder")
  tempRoot.Name = "__temp_perk_swap_" .. tostring(tick()):gsub("%.", "_")
  tempRoot.Parent = perks
  
  tempCurrent = Instance.new("Folder")
  tempCurrent.Name = "tempCurrent"
  tempCurrent.Parent = tempRoot
  
  tempSelected = Instance.new("Folder")
  tempSelected.Name = "tempSelected"
  tempSelected.Parent = tempRoot
  
  for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
  end
  
  for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
  end
  
  for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
  end
  
  for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
  end
  
  tempRoot:Destroy()
  
  lastCurrentPerk = current
  lastSelectedPerk = selected
  isPerkSwapped = true
  
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "Successfully swapped " .. currentActualName .. " with " .. selectedActualName,
  Duration = 3
  })
 end)
end

function revertPreviousPerkSwap2()
 if lastCurrentPerk2 ~= "" and lastSelectedPerk2 ~= "" and isPerkSwapped2 then
  perks = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
  if perks then
  perks = perks:FindFirstChild("Perks")
  if perks then
 lastCurrentValid, lastCurrentActual = isValidPerk(lastCurrentPerk2)
 lastSelectedValid, lastSelectedActual = isValidPerk(lastSelectedPerk2)
 
 if lastCurrentValid and lastSelectedValid then
  pcall(function()
  currentFolder = perks:FindFirstChild(lastCurrentActual)
  selectedFolder = perks:FindFirstChild(lastSelectedActual)
  
  if currentFolder and selectedFolder then
 tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_perk_revert2_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = perks
 
 tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot
 
 tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot
 
 for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
 end
 
 for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
 end
 
 for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
 end
 
 for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
 end
 
 tempRoot:Destroy()
  end
  end)
 end
  end
  end
  isPerkSwapped2 = false
 end
end

function swapPerks2(current, selected)
 revertPreviousPerkSwap2()
 
 currentNorm = normalizeString(current)
 selectedNorm = normalizeString(selected)
 
 if currentNorm == "" or selectedNorm == "" then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Both perk names must be filled",
  Duration = 3
  })
  return
 end
 
 if currentNorm == selectedNorm then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Perk names cannot be the same",
  Duration = 3
  })
  return
 end
 
 perks = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not perks then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Perks folder not found",
  Duration = 3
  })
  return
 end
 
 perks = perks:FindFirstChild("Perks")
 if not perks then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Perks folder not found",
  Duration = 3
  })
  return
 end
 
 currentPerkValid, currentActualName = isValidPerk(current)
 selectedPerkValid, selectedActualName = isValidPerk(selected)
 
 if not currentPerkValid then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Current perk not found: " .. current,
  Duration = 3
  })
  return
 end
 
 if not selectedPerkValid then
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Selected perk not found: " .. selected,
  Duration = 3
  })
  return
 end
 
 pcall(function()
  currentFolder = perks:FindFirstChild(currentActualName)
  selectedFolder = perks:FindFirstChild(selectedActualName)
  
  if not currentFolder or not selectedFolder then
  WindUI:Notify({
 Title = "Perk Replacer 2",
 Content = "One or both perks not found in folder",
 Duration = 3
  })
  return
  end
  
  tempRoot = Instance.new("Folder")
  tempRoot.Name = "__temp_perk_swap2_" .. tostring(tick()):gsub("%.", "_")
  tempRoot.Parent = perks
  
  tempCurrent = Instance.new("Folder")
  tempCurrent.Name = "tempCurrent"
  tempCurrent.Parent = tempRoot
  
  tempSelected = Instance.new("Folder")
  tempSelected.Name = "tempSelected"
  tempSelected.Parent = tempRoot
  
  for _, child in ipairs(currentFolder:GetChildren()) do
  child.Parent = tempCurrent
  end
  
  for _, child in ipairs(selectedFolder:GetChildren()) do
  child.Parent = tempSelected
  end
  
  for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedFolder
  end
  
  for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentFolder
  end
  
  tempRoot:Destroy()
  
  lastCurrentPerk2 = current
  lastSelectedPerk2 = selected
  isPerkSwapped2 = true
  
  WindUI:Notify({
  Title = "Perk Replacer 2",
  Content = "Successfully swapped " .. currentActualName .. " with " .. selectedActualName,
  Duration = 3
  })
 end)
end

function isValidTool(toolName)
 tools = game:GetService("ReplicatedStorage"):FindFirstChild("Tools")
 if not tools then return false end
 tool = tools:FindFirstChild(toolName)
 if not tool then return false end
 variants = tool:FindFirstChild("Variants")
 if not variants then return false end
 return true, tool, variants
end

function isValidSkin(toolName, skinName)
 toolValid, tool, variants = isValidTool(toolName)
 if not toolValid then return false end
 skin = variants:FindFirstChild(skinName)
 if not skin then return false end
 return true, tool, variants, skin
end

function revertPreviousSkinSwap()
 if lastCurrentTool ~= "" and lastCurrentSkin ~= "" and lastSelectedSkin ~= "" and isSkinSwapped then
  currentValid, currentTool, currentVariants, currentSkin = isValidSkin(lastCurrentTool, lastCurrentSkin)
  selectedValid, selectedTool, selectedVariants, selectedSkin = isValidSkin(lastCurrentTool, lastSelectedSkin)
  
  if currentValid and selectedValid then
  pcall(function()
 tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_skin_revert_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = currentVariants
 
 tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot
 
 tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot
 
 for _, child in ipairs(currentSkin:GetChildren()) do
  child.Parent = tempCurrent
 end
 
 for _, child in ipairs(selectedSkin:GetChildren()) do
  child.Parent = tempSelected
 end
 
 for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedSkin
 end
 
 for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentSkin
 end
 
 tempRoot:Destroy()
  end)
  end
  isSkinSwapped = false
 end
end

function swapSkins(toolName, currentSkinName, selectedSkinName)
 if currentTool ~= "" and currentTool ~= toolName then
  revertPreviousSkinSwap()
 end
 
 currentNorm = normalizeString(currentSkinName)
 selectedNorm = normalizeString(selectedSkinName)
 
 if toolName == "" or currentNorm == "" or selectedNorm == "" then
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "All fields must be filled",
  Duration = 3
  })
  return
 end
 
 if currentNorm == selectedNorm then
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "Skin names cannot be the same",
  Duration = 3
  })
  return
 end
 
 currentValid, currentTool, currentVariants, currentSkin = isValidSkin(toolName, currentSkinName)
 selectedValid, selectedTool, selectedVariants, selectedSkin = isValidSkin(toolName, selectedSkinName)
 
 if not currentValid then
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "Current skin not found: " .. currentSkinName,
  Duration = 3
  })
  return
 end
 
 if not selectedValid then
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "Selected skin not found: " .. selectedSkinName,
  Duration = 3
  })
  return
 end
 
 pcall(function()
  tempRoot = Instance.new("Folder")
  tempRoot.Name = "__temp_skin_swap_" .. tostring(tick()):gsub("%.", "_")
  tempRoot.Parent = currentVariants
  
  tempCurrent = Instance.new("Folder")
  tempCurrent.Name = "tempCurrent"
  tempCurrent.Parent = tempRoot
  
  tempSelected = Instance.new("Folder")
  tempSelected.Name = "tempSelected"
  tempSelected.Parent = tempRoot
  
  for _, child in ipairs(currentSkin:GetChildren()) do
  child.Parent = tempCurrent
  end
  
  for _, child in ipairs(selectedSkin:GetChildren()) do
  child.Parent = tempSelected
  end
  
  for _, child in ipairs(tempCurrent:GetChildren()) do
  child.Parent = selectedSkin
  end
  
  for _, child in ipairs(tempSelected:GetChildren()) do
  child.Parent = currentSkin
  end
  
  tempRoot:Destroy()
  
  lastCurrentTool = toolName
  lastCurrentSkin = currentSkinName
  lastSelectedSkin = selectedSkinName
  isSkinSwapped = true
  
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "Successfully swapped " .. currentSkinName .. " with " .. selectedSkinName .. " for " .. toolName,
  Duration = 3
  })
 end)
end

Tabs.Visuals:Section({ Title = "CarryAnimation Replacer", TextSize = 15 })
Tabs.Visuals:Divider()

Tabs.Visuals:Input({
 Title = "Current CarryAnimation",
 Placeholder = "Enter current carry animation name",
 Callback = function(value)
  if value ~= currentCarryAnim and currentCarryAnim ~= "" then
  revertPreviousSwap()
  end
  currentCarryAnim = value
 end
})

Tabs.Visuals:Input({
 Title = "Selected CarryAnimation",
 Placeholder = "Enter selected carry animation name",
 Callback = function(value)
  if value ~= selectedCarryAnim and selectedCarryAnim ~= "" then
  revertPreviousSwap()
  end
  selectedCarryAnim = value
 end
})

Tabs.Visuals:Button({
 Title = "Apply CarryAnimation Swap",
 Callback = function()
  swapCarryAnimations(currentCarryAnim, selectedCarryAnim)
 end
})

Tabs.Visuals:Button({
 Title = "Reset All CarryAnimations",
 Callback = function()
  revertPreviousSwap()
  currentCarryAnim = ""
  selectedCarryAnim = ""
  lastCurrentCarryAnim = ""
  lastSelectedCarryAnim = ""
  isSwapped = false
  WindUI:Notify({
  Title = "CarryAnimation Replacer",
  Content = "All animations reset to original",
  Duration = 3
  })
 end
})

Tabs.Visuals:Section({ Title = "Perk Replacer", TextSize = 15 })
Tabs.Visuals:Divider()

Tabs.Visuals:Input({
 Title = "Current Perk",
 Placeholder = "Enter current perk name",
 Callback = function(value)
  if value ~= currentPerk and currentPerk ~= "" then
  revertPreviousPerkSwap()
  end
  currentPerk = value
 end
})

Tabs.Visuals:Input({
 Title = "Selected Perk",
 Placeholder = "Enter selected perk name",
 Callback = function(value)
  if value ~= selectedPerk and selectedPerk ~= "" then
  revertPreviousPerkSwap()
  end
  selectedPerk = value
 end
})

Tabs.Visuals:Button({
 Title = "Apply Perk Swap",
 Callback = function()
  swapPerks(currentPerk, selectedPerk)
 end
})

Tabs.Visuals:Section({ Title = "Perk Replacer 2", TextSize = 15 })
Tabs.Visuals:Divider()

Tabs.Visuals:Input({
 Title = "Current Perk 2",
 Placeholder = "Enter current perk name",
 Callback = function(value)
  if value ~= currentPerk2 and currentPerk2 ~= "" then
  revertPreviousPerkSwap2()
  end
  currentPerk2 = value
 end
})

Tabs.Visuals:Input({
 Title = "Selected Perk 2",
 Placeholder = "Enter selected perk name",
 Callback = function(value)
  if value ~= selectedPerk2 and selectedPerk2 ~= "" then
  revertPreviousPerkSwap2()
  end
  selectedPerk2 = value
 end
})

Tabs.Visuals:Button({
 Title = "Apply Perk Swap 2",
 Callback = function()
  swapPerks2(currentPerk2, selectedPerk2)
 end
})

Tabs.Visuals:Button({
 Title = "Reset All Perks",
 Callback = function()
  revertPreviousPerkSwap()
  revertPreviousPerkSwap2()
  currentPerk = ""
  selectedPerk = ""
  lastCurrentPerk = ""
  lastSelectedPerk = ""
  isPerkSwapped = false
  currentPerk2 = ""
  selectedPerk2 = ""
  lastCurrentPerk2 = ""
  lastSelectedPerk2 = ""
  isPerkSwapped2 = false
  WindUI:Notify({
  Title = "Perk Replacer",
  Content = "All perks reset to original",
  Duration = 3
  })
 end
})

Tabs.Visuals:Section({ Title = "Item Skin Changer", TextSize = 15 })
Tabs.Visuals:Divider()

Tabs.Visuals:Input({
 Title = "Current Tool Name",
 Placeholder = "Enter tool name",
 Callback = function(value)
  currentTool = value
 end
})

Tabs.Visuals:Input({
 Title = "Current Skin",
 Placeholder = "Enter current skin name",
 Callback = function(value)
  currentSkin = value
 end
})

Tabs.Visuals:Input({
 Title = "Select Skin",
 Placeholder = "Enter selected skin name",
 Callback = function(value)
  selectedSkin = value
 end
})

Tabs.Visuals:Button({
 Title = "Apply Skin",
 Callback = function()
  swapSkins(currentTool, currentSkin, selectedSkin)
 end
})

Tabs.Visuals:Button({
 Title = "Reset Tool",
 Desc = "Not working? Try resetting tool",
 Callback = function()
  revertPreviousSkinSwap()
  currentTool = ""
  currentSkin = ""
  selectedSkin = ""
  lastCurrentTool = ""
  lastCurrentSkin = ""
  lastSelectedSkin = ""
  isSkinSwapped = false
  WindUI:Notify({
  Title = "Item Skin Changer",
  Content = "Tool skins reset to original",
  Duration = 3
  })
 end
})
Tabs.Visuals:Section({ Title = "Fake Streaks", TextSize = 15 })

FakeStreaksInput = Tabs.Visuals:Input({
 Title = "Fake Streaks",
 Flag = "FakeStreaksInput",
 Placeholder = "Enter streak value",
 Callback = function(value)
  num = tonumber(value)
  if num then
  game:GetService("Players").LocalPlayer:SetAttribute("Streak", num)
  end
 end
})
Tabs.Visuals:Section({ Title = "Emote Swapper (buggy)", TextSize = 20 })
Tabs.Visuals:Section({ Title = [[What's different of emote Swapper and emote changer?
  Well it's different because emote swap is gonna sawp emote from ReplicatedStorage and emote changer is gonna fetch Animationid then execute clientside remote]], TextSize = 10 })
Tabs.Visuals:Divider()

EmoteSwapper = {
 CurrentEmotes = {},
 SelectedEmotes = {},
 SwappedPairs = {},
 InputFields = {},
 PendingApply = false,
 PendingSwaps = {}
}

for i = 1, 12 do
 EmoteSwapper.CurrentEmotes[i] = ""
 EmoteSwapper.SelectedEmotes[i] = ""
end

Tabs.Visuals:Section({ Title = "Current Emotes", TextSize = 16 })

for i = 1, 12 do
 EmoteSwapper.InputFields["CurrentEmote" .. i] = Tabs.Visuals:Input({
  Title = "Current Emote " .. i,
  Placeholder = "Enter current emote name",
  Value = "",
  Callback = function(value)
  EmoteSwapper.CurrentEmotes[i] = value
  end
 })
end

Tabs.Visuals:Section({ Title = "Selected Emotes", TextSize = 16 })

for i = 1, 12 do
 EmoteSwapper.InputFields["SelectedEmote" .. i] = Tabs.Visuals:Input({
  Title = "Select Emote " .. i,
  Placeholder = "Enter replacement emote name",
  Value = "",
  Callback = function(value)
  EmoteSwapper.SelectedEmotes[i] = value
  end
 })
end

function SwapEmoteNames(currentName, selectedName)
 Items = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not Items then return false end
 
 EmotesFolder = Items:FindFirstChild("Emotes")
 if not EmotesFolder then return false end
 
 currentEmoteObj = EmotesFolder:FindFirstChild(currentName)
 selectedEmoteObj = EmotesFolder:FindFirstChild(selectedName)
 
 if currentEmoteObj and selectedEmoteObj then
  tempName = selectedName .. "_EmoteSwapTemp"
  
  while EmotesFolder:FindFirstChild(tempName) do
  tempName = tempName .. "_"
  end
  
  currentEmoteObj.Name = tempName
  selectedEmoteObj.Name = currentName
  currentEmoteObj.Name = selectedName
  
  return true
 end
 return false
end

function ResetEmoteNames()
 Items = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
 if not Items then return false end
 
 EmotesFolder = Items:FindFirstChild("Emotes")
 if not EmotesFolder then return false end
 
 for currentEmote, selectedEmote in pairs(EmoteSwapper.SwappedPairs) do
  currentEmoteObj = EmotesFolder:FindFirstChild(selectedEmote)
  selectedEmoteObj = EmotesFolder:FindFirstChild(currentEmote)
  
  if currentEmoteObj and selectedEmoteObj then
  tempName = currentEmote .. "_EmoteSwapTemp"
  
  while EmotesFolder:FindFirstChild(tempName) do
 tempName = tempName .. "_"
  end
  
  currentEmoteObj.Name = tempName
  selectedEmoteObj.Name = selectedEmote
  currentEmoteObj.Name = currentEmote
  end
 end
 
 return true
end

function ProcessPendingSwaps()
 if not EmoteSwapper.PendingSwaps or #EmoteSwapper.PendingSwaps == 0 then
  return
 end
 
 swappedCount = 0
 failedCount = 0
 
 for _, swapData in ipairs(EmoteSwapper.PendingSwaps) do
  currentEmote = swapData[1]
  selectedEmote = swapData[2]
  
  if SwapEmoteNames(currentEmote, selectedEmote) then
  EmoteSwapper.SwappedPairs[currentEmote] = selectedEmote
  swappedCount = swappedCount + 1
  else
  failedCount = failedCount + 1
  end
 end
 
 EmoteSwapper.PendingSwaps = {}
 EmoteSwapper.PendingApply = false
 
 return swappedCount, failedCount
end

function CheckIfPlayerDead()
 return not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0
end

function CheckIfPlayerDowned()
 return player.Character and player.Character:GetAttribute("Downed")
end

EmoteSwapApplyButton = Tabs.Visuals:Button({
 Title = "Apply Emote Swap",
 Desc = "Swap the current emotes with selected ones",
 Icon = "refresh-cw",
 Callback = function()
  if CheckIfPlayerDead() and not CheckIfPlayerDowned() then
  EmoteSwapper.PendingSwaps = {}
  
  for i = 1, 12 do
 currentEmote = EmoteSwapper.CurrentEmotes[i]
 selectedEmote = EmoteSwapper.SelectedEmotes[i]
 
 if currentEmote ~= "" and selectedEmote ~= "" then
  table.insert(EmoteSwapper.PendingSwaps, {currentEmote, selectedEmote})
 end
  end
  
  if #EmoteSwapper.PendingSwaps > 0 then
 EmoteSwapper.PendingApply = true
 WindUI:Notify({
  Title = "Emote Swapper",
  Content = "Player is dead. Emote swap will be applied when you respawn.",
  Icon = "clock",
  Duration = 3
 })
  else
 WindUI:Notify({
  Title = "Emote Swapper",
  Content = "No emotes specified to swap",
  Icon = "x-circle",
  Duration = 3
 })
  end
  return
  end
  
  swappedCount = 0
  failedCount = 0
  
  for i = 1, 12 do
  currentEmote = EmoteSwapper.CurrentEmotes[i]
  selectedEmote = EmoteSwapper.SelectedEmotes[i]
  
  if currentEmote ~= "" and selectedEmote ~= "" then
 if SwapEmoteNames(currentEmote, selectedEmote) then
  EmoteSwapper.SwappedPairs[currentEmote] = selectedEmote
  swappedCount = swappedCount + 1
 else
  failedCount = failedCount + 1
 end
  end
  end
  
  message = ""
  if swappedCount > 0 then
  message = "Successfully swapped " .. tostring(swappedCount) .. " emote(s)"
  end
  if failedCount > 0 then
  if message ~= "" then message = message .. " | " end
  message = message .. "Failed to swap " .. tostring(failedCount) .. " emote(s)"
  end
  if message == "" then
  message = "No emotes specified to swap"
  end
  
  WindUI:Notify({
  Title = "Emote Swapper",
  Content = message,
  Icon = swappedCount > 0 and "check-circle" or "x-circle",
  Duration = 3
  })
 end
})

EmoteSwapResetButton = Tabs.Visuals:Button({
 Title = "Reset Emote Module",
 Desc = "Restore all emotes to their original names",
 Icon = "rotate-ccw",
 Callback = function()
  if ResetEmoteNames() then
  EmoteSwapper.SwappedPairs = {}
  EmoteSwapper.PendingSwaps = {}
  EmoteSwapper.PendingApply = false
  
  for i = 1, 12 do
 EmoteSwapper.CurrentEmotes[i] = ""
 EmoteSwapper.SelectedEmotes[i] = ""
 
 if EmoteSwapper.InputFields["CurrentEmote" .. i] then
  EmoteSwapper.InputFields["CurrentEmote" .. i]:Set("")
 end
 if EmoteSwapper.InputFields["SelectedEmote" .. i] then
  EmoteSwapper.InputFields["SelectedEmote" .. i]:Set("")
 end
  end
  
  WindUI:Notify({
 Title = "Emote Swapper",
 Content = "All emotes have been restored to original names!",
 Icon = "check-circle",
 Duration = 3
  })
  else
  WindUI:Notify({
 Title = "Emote Swapper",
 Content = "Failed to reset emotes!",
 Icon = "x-circle",
 Duration = 3
  })
  end
 end
})

player.CharacterRemoving:Connect(function()
 if next(EmoteSwapper.SwappedPairs) then
  ResetEmoteNames()
 end
end)

player.CharacterAdded:Connect(function(character)
 task.wait(1)
 
 if CheckIfPlayerDowned() then
  return
 end
 
 if next(EmoteSwapper.SwappedPairs) then
  for currentEmote, selectedEmote in pairs(EmoteSwapper.SwappedPairs) do
  SwapEmoteNames(currentEmote, selectedEmote)
  end
 end
 
 if EmoteSwapper.PendingApply and #EmoteSwapper.PendingSwaps > 0 then
  swappedCount, failedCount = ProcessPendingSwaps()
  
  message = ""
  if swappedCount > 0 then
  message = "Successfully swapped " .. tostring(swappedCount) .. " emote(s)"
  end
  if failedCount > 0 then
  if message ~= "" then message = message .. " | " end
  message = message .. "Failed to swap " .. tostring(failedCount) .. " emote(s)"
  end
  
  if message ~= "" then
  WindUI:Notify({
 Title = "Emote Swapper",
 Content = message,
 Icon = swappedCount > 0 and "check-circle" or "x-circle",
 Duration = 3
  })
  end
 end
end)

player.CharacterAdded:Connect(function(character)
 task.wait(1)
 
 if character:GetAttribute("Downed") then
  return
 end
 
 if next(EmoteSwapper.SwappedPairs) then
  for currentEmote, selectedEmote in pairs(EmoteSwapper.SwappedPairs) do
  SwapEmoteNames(currentEmote, selectedEmote)
  end
 end
end)
task.spawn(function()
 task.wait(1)
 currentStreak = game:GetService("Players").LocalPlayer:GetAttribute("Streak")
 if currentStreak then
  FakeStreaksInput:Set(tostring(currentStreak))
 end
end)
 -- ESP Tab
playerEspElements = {}
playerEspConnection = nil
EnemyEspElements = {}
EnemyEspConnection = nil
downedTracerConnection = nil
downedNameESPConnection = nil
downedTracerLines = {}
downedNameESPLabels = {}

EnemyNames = {}
if ReplicatedStorage:FindFirstChild("NPCStorage") then
 for _, npc in ipairs(ReplicatedStorage.NPCStorage:GetChildren()) do
  table.insert(EnemyNames, npc.Name)
 end
end

function isEnemyModel(model)
 if not model or not model.Name then return false end
 for _, name in ipairs(EnemyNames) do
  if model.Name == name then return true end
 end
 return false
end

function getDistanceFromPlayer(targetPosition)
 if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return 0 end
 return (targetPosition - player.Character.HumanoidRootPart.Position).Magnitude
end

function cleanupTracers(tracerTable)
 for _, drawing in ipairs(tracerTable) do
  if drawing and drawing.Remove then 
  pcall(function() drawing:Remove() end)
  elseif drawing then 
  drawing.Visible = false 
  end
 end
 tracerTable = {}
end

function cleanupNameESPLabels(labelTable)
 for _, label in ipairs(labelTable) do
  if label and label.Remove then 
  label:Remove()
  elseif label then 
  label.Visible = false 
  end
 end
 labelTable = {}
end

function createESPObject()
 return {
  box = Drawing.new("Square"),
  tracer = Drawing.new("Line"),
  name = Drawing.new("Text"),
  distance = Drawing.new("Text"),
  boxLines = {}
 }
end

function setupESPObject(esp)
 esp.box.Thickness = 2
 esp.box.Filled = false
 esp.tracer.Thickness = 1
 esp.name.Size = 14
 esp.name.Center = true
 esp.name.Outline = true
 esp.distance.Size = 14
 esp.distance.Center = true
 esp.distance.Outline = true
end

function cleanupDrawingTable(drawingTable)
 for _, drawing in pairs(drawingTable) do
  if type(drawing) == "table" then
  for _, line in ipairs(drawing) do
 pcall(line.Remove, line)
  end
  else
  pcall(drawing.Remove, drawing)
  end
 end
end

function draw3DBox(esp, hrp, camera, boxColor, boxSize)
 if not hrp or not camera then return end
 
 boxSize = boxSize or Vector3.new(4, 5, 3)
 local size = boxSize
 local offsets = {
  Vector3.new( size.X/2,  size.Y/2,  size.Z/2), Vector3.new( size.X/2,  size.Y/2, -size.Z/2),
  Vector3.new( size.X/2, -size.Y/2,  size.Z/2), Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
  Vector3.new(-size.X/2,  size.Y/2,  size.Z/2), Vector3.new(-size.X/2,  size.Y/2, -size.Z/2),
  Vector3.new(-size.X/2, -size.Y/2,  size.Z/2), Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
 }
 
 local screenPoints = {}
 local anyPointOnScreen = false

 for i, offset in ipairs(offsets) do
  local success, vec, onScreen = pcall(function()
  local worldPos = hrp.CFrame * CFrame.Angles(0, math.rad(90), 0) * offset
  return camera:WorldToViewportPoint(worldPos)
  end)
  if success then
  screenPoints[i] = {pos = Vector2.new(vec.X, vec.Y), depth = vec.Z, onScreen = onScreen}
  if onScreen and vec.Z > 0 then anyPointOnScreen = true end
  end
 end

 if not esp.boxLines or #esp.boxLines == 0 then
  esp.boxLines = {}
  for i = 1, 12 do
  local line = Drawing.new("Line")
  line.Thickness = 1
  line.ZIndex = 2
  table.insert(esp.boxLines, line)
  end
 end

 local edges = {
  {1, 2}, {1, 3}, {1, 5}, {2, 4}, {2, 6},
  {3, 4}, {3, 7}, {5, 6}, {5, 7}, {4, 8}, {6, 8}, {7, 8}
 }

 local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
  (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 10
 local thickness = math.clamp(3 / (distance / 50), 1, 3)

 for i, edge in ipairs(edges) do
  local line = esp.boxLines[i]
  if line then
  local p1, p2 = screenPoints[edge[1]], screenPoints[edge[2]]
  line.Color = boxColor or Color3.fromRGB(255, 255, 255)
  line.Thickness = thickness
  line.Transparency = 1
  if anyPointOnScreen and p1 and p2 and p1.depth > 0 and p2.depth > 0 then
 line.From = p1.pos
 line.To = p2.pos
 line.Visible = true
  else
 line.Visible = false
  end
  end
 end
end

function updatePlayerESP()
 local camera = workspace.CurrentCamera
 if not camera then return end
 
 local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
 local currentTargets = {}
 local gameFolder = workspace:FindFirstChild("Game")

 if gameFolder and gameFolder:FindFirstChild("Players") then
  for _, model in pairs(gameFolder.Players:GetChildren()) do
  if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
 local isPlayer = Players:GetPlayerFromCharacter(model) ~= nil
 local humanoid = model:FindFirstChild("Humanoid")
 
 if isPlayer and model.Name ~= player.Name and humanoid and humanoid.Health > 0 then
  currentTargets[model] = true
  
  if not playerEspElements[model] then
  playerEspElements[model] = createESPObject()
  setupESPObject(playerEspElements[model])
  end

  local esp = playerEspElements[model]
  local hrp = model.HumanoidRootPart
  local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

  if onScreen then
  local topY = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y
  local bottomY = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y
  local size = (bottomY - topY) / 2
  local toggles = featureStates.PlayerESP
  local boxSize = humanoid and Vector3.new(2, humanoid.HipHeight + 5, 2) or Vector3.new(4, 5, 3)

  if toggles.boxes then
 local boxColor = toggles.rainbowBoxes and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Color3.fromRGB(0, 255, 0)
 if toggles.boxType == "2D" then
  esp.box.Visible = true
  esp.box.Size = Vector2.new(size * 2, size * 3)
  esp.box.Position = Vector2.new(vector.X - size, vector.Y - size * 1.5)
  esp.box.Color = boxColor
  for _, line in ipairs(esp.boxLines) do line.Visible = false end
 else
  esp.box.Visible = false
  pcall(draw3DBox, esp, hrp, camera, boxColor, boxSize)
 end
  else
 esp.box.Visible = false
 for _, line in ipairs(esp.boxLines) do line.Visible = false end
  end

  esp.tracer.Visible = toggles.tracers
  if toggles.tracers then
 esp.tracer.From = screenBottomCenter
 esp.tracer.To = Vector2.new(vector.X, vector.Y)
 esp.tracer.Color = toggles.rainbowTracers and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Color3.fromRGB(0, 255, 0)
  end

  esp.name.Visible = toggles.names
  if toggles.names then
 esp.name.Text = model.Name
 esp.name.Position = Vector2.new(vector.X, vector.Y - size * 1.5 - 20)
 esp.name.Color = Color3.fromRGB(255, 255, 255)
  end

  esp.distance.Visible = toggles.distance
  if toggles.distance then
 local distance = getDistanceFromPlayer(hrp.Position)
 esp.distance.Text = string.format("%.1f", distance)
 esp.distance.Position = Vector2.new(vector.X, vector.Y + size * 1.5 + 5)
 esp.distance.Color = Color3.fromRGB(255, 255, 255)
  end
  else
  esp.box.Visible = false
  esp.tracer.Visible = false
  esp.name.Visible = false
  esp.distance.Visible = false
  for _, line in ipairs(esp.boxLines) do line.Visible = false end
  end
 end
  end
  end
 end

 for target, esp in pairs(playerEspElements) do
  if not currentTargets[target] then
  cleanupDrawingTable(esp)
  playerEspElements[target] = nil
  end
 end
end

function updateEnemyESP()
 local camera = workspace.CurrentCamera
 if not camera then return end
 
 local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
 local currentTargets = {}

 local gameFolder = workspace:FindFirstChild("Game")
 if gameFolder and gameFolder:FindFirstChild("Players") then
  for _, model in pairs(gameFolder.Players:GetChildren()) do
  if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isEnemyModel(model) then
 processEnemyModel(model, currentTargets, camera, screenBottomCenter)
  end
  end
 end

 if workspace:FindFirstChild("NPCStorage") then
  for _, model in pairs(workspace.NPCStorage:GetChildren()) do
  if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isEnemyModel(model) then
 processEnemyModel(model, currentTargets, camera, screenBottomCenter)
  end
  end
 end

 for target, esp in pairs(EnemyEspElements) do
  if not currentTargets[target] then
  cleanupDrawingTable(esp)
  EnemyEspElements[target] = nil
  end
 end
end

function processEnemyModel(model, currentTargets, camera, screenBottomCenter)
 currentTargets[model] = true
 
 if not EnemyEspElements[model] then
  EnemyEspElements[model] = createESPObject()
  setupESPObject(EnemyEspElements[model])
 end

 local esp = EnemyEspElements[model]
 local hrp = model.HumanoidRootPart
 local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

 if onScreen then
  local topY = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y
  local bottomY = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y
  local size = (bottomY - topY) / 2
  local toggles = featureStates.EnemyESP
  local humanoid = model:FindFirstChild("Humanoid")
  local boxSize = humanoid and Vector3.new(2, humanoid.HipHeight + 5, 2) or Vector3.new(4, 5, 3)

  if toggles.boxes then
  local boxColor = toggles.rainbowBoxes and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Color3.fromRGB(255, 0, 0)
  if toggles.boxType == "2D" then
 esp.box.Visible = true
 esp.box.Size = Vector2.new(size * 2, size * 3)
 esp.box.Position = Vector2.new(vector.X - size, vector.Y - size * 1.5)
 esp.box.Color = boxColor
 for _, line in ipairs(esp.boxLines) do line.Visible = false end
  else
 esp.box.Visible = false
 pcall(draw3DBox, esp, hrp, camera, boxColor, boxSize)
  end
  else
  esp.box.Visible = false
  for _, line in ipairs(esp.boxLines) do line.Visible = false end
  end

  esp.tracer.Visible = toggles.tracers
  if toggles.tracers then
  esp.tracer.From = screenBottomCenter
  esp.tracer.To = Vector2.new(vector.X, vector.Y)
  esp.tracer.Color = toggles.rainbowTracers and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Color3.fromRGB(255, 0, 0)
  end

  esp.name.Visible = toggles.names
  if toggles.names then
  esp.name.Text = model.Name
  esp.name.Position = Vector2.new(vector.X, vector.Y - size * 1.5 - 20)
  esp.name.Color = Color3.fromRGB(255, 0, 0)
  end

  esp.distance.Visible = toggles.distance
  if toggles.distance then
  local distance = getDistanceFromPlayer(hrp.Position)
  esp.distance.Text = string.format("%.1f", distance)
  esp.distance.Position = Vector2.new(vector.X, vector.Y + size * 1.5 + 5)
  esp.distance.Color = Color3.fromRGB(255, 0, 0)
  end
 else
  esp.box.Visible = false
  esp.tracer.Visible = false
  esp.name.Visible = false
  esp.distance.Visible = false
  for _, line in ipairs(esp.boxLines) do line.Visible = false end
 end
end

function startPlayerESP()
 if playerEspConnection then return end
 playerEspConnection = RunService.RenderStepped:Connect(updatePlayerESP)
end

function stopPlayerESP()
 if playerEspConnection then
  playerEspConnection:Disconnect()
  playerEspConnection = nil
 end
 for _, esp in pairs(playerEspElements) do
  cleanupDrawingTable(esp)
 end
 playerEspElements = {}
end

function startEnemyESP()
 if EnemyEspConnection then return end
 EnemyEspConnection = RunService.RenderStepped:Connect(updateEnemyESP)
end

function stopEnemyESP()
 if EnemyEspConnection then
  EnemyEspConnection:Disconnect()
  EnemyEspConnection = nil
 end
 for _, esp in pairs(EnemyEspElements) do
  cleanupDrawingTable(esp)
 end
 EnemyEspElements = {}
end

function setupEnemyDetection()
 local gameFolder = workspace:FindFirstChild("Game")
 if gameFolder and gameFolder:FindFirstChild("Players") then
  gameFolder.Players.ChildAdded:Connect(function(child)
  if child:IsA("Model") and isEnemyModel(child) then
 task.wait(0.5)
 updateEnemyESP()
  end
  end)
 end
 if workspace:FindFirstChild("NPCStorage") then
  workspace.NPCStorage.ChildAdded:Connect(function(child)
  if child:IsA("Model") and isEnemyModel(child) then
 task.wait(0.5)
 updateEnemyESP()
  end
  end)
 end
end

function startDownedTracer()
 downedTracerConnection = RunService.Heartbeat:Connect(function()
  cleanupTracers(downedTracerLines)
  downedTracerLines = {}
  local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
  if folder then
  for _, char in ipairs(folder:GetChildren()) do
 if char:IsA("Model") then
  local team = char:GetAttribute("Team")
  local downed = char:GetAttribute("Downed")
  if team ~= "Enemy" and char.Name ~= player.Name and downed == true then
  local hrp = char:FindFirstChild("HumanoidRootPart")
  if hrp and workspace.CurrentCamera then
 local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
 if onScreen then
  if featureStates.DownedTracer then
  local tracer = Drawing.new("Line")
  tracer.Color = Color3.fromRGB(255, 165, 0)
  tracer.Thickness = 2
  tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
  tracer.To = Vector2.new(pos.X, pos.Y)
  tracer.ZIndex = 1
  tracer.Visible = true
  table.insert(downedTracerLines, tracer)
  end
 end
  end
  end
 end
  end
  end
 end)
end

function stopDownedTracer()
 if downedTracerConnection then
  downedTracerConnection:Disconnect()
  downedTracerConnection = nil
 end
 cleanupTracers(downedTracerLines)
 downedTracerLines = {}
end

function startDownedNameESP()
 downedNameESPConnection = RunService.Heartbeat:Connect(function()
  cleanupNameESPLabels(downedNameESPLabels)
  downedNameESPLabels = {}
  local folder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
  if folder then
  for _, char in ipairs(folder:GetChildren()) do
 if char:IsA("Model") then
  local team = char:GetAttribute("Team")
  local downed = char:GetAttribute("Downed")
  if team ~= "Enemy" and char.Name ~= player.Name and downed == true then
  local hrp = char:FindFirstChild("HumanoidRootPart")
  if hrp and workspace.CurrentCamera then
 local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
 if onScreen then
  local distance = getDistanceFromPlayer(hrp.Position)
  local displayText = char.Name
  if featureStates.DownedDistanceESP then
  displayText = displayText .. "\n" .. math.floor(distance) .. " studs"
  end
  local label = Drawing.new("Text")
  label.Text = displayText
  label.Size = 16
  label.Center = true
  label.Outline = true
  label.OutlineColor = Color3.new(0, 0, 0)
  label.Color = Color3.fromRGB(255, 165, 0)
  label.Position = Vector2.new(pos.X, pos.Y - 50)
  label.Visible = true
  table.insert(downedNameESPLabels, label)
 end
  end
  end
 end
  end
  end
 end)
end

function stopDownedNameESP()
 if downedNameESPConnection then
  downedNameESPConnection:Disconnect()
  downedNameESPConnection = nil
 end
 cleanupNameESPLabels(downedNameESPLabels)
 downedNameESPLabels = {}
end

Tabs.ESP:Section({ Title = "ESP", TextSize = 40 })
Tabs.ESP:Section({ Title = "Note: Enabling this higher amount Enemy or Player may coust your game to lag", TextSize = 10 })
Tabs.ESP:Divider()

Tabs.ESP:Section({ Title = "Player ESP" })

PlayerNameESPToggle = Tabs.ESP:Toggle({
 Title = "Player Name ESP",
 Flag = "PlayerNameESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.names = state
  if state or featureStates.PlayerESP.boxes or featureStates.PlayerESP.tracers or featureStates.PlayerESP.distance then
  startPlayerESP()
  else
  stopPlayerESP()
  end
 end
})

PlayerBoxESPToggle = Tabs.ESP:Toggle({
 Title = "Player Box ESP",
 Flag = "PlayerBoxESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.boxes = state
  if state or featureStates.PlayerESP.tracers or featureStates.PlayerESP.names or featureStates.PlayerESP.distance then
  startPlayerESP()
  else
  stopPlayerESP()
  end
 end
})

PlayerBoxTypeDropdown = Tabs.ESP:Dropdown({
 Title = "Player Box Type",
 Flag = "PlayerBoxTypeDropdown",
 Values = {"2D", "3D"},
 Value = "2D",
 Callback = function(value)
  featureStates.PlayerESP.boxType = value
 end
})

PlayerRainbowBoxesToggle = Tabs.ESP:Toggle({
 Title = "Player Rainbow Boxes",
 Flag = "PlayerRainbowBoxesToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.rainbowBoxes = state
  if featureStates.PlayerESP.boxes then
  stopPlayerESP()
  startPlayerESP()
  end
 end
})

PlayerTracerToggle = Tabs.ESP:Toggle({
 Title = "Player Tracer",
 Flag = "PlayerTracerToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.tracers = state
  if state or featureStates.PlayerESP.boxes or featureStates.PlayerESP.names or featureStates.PlayerESP.distance then
  startPlayerESP()
  else
  stopPlayerESP()
  end
 end
})

PlayerRainbowTracersToggle = Tabs.ESP:Toggle({
 Title = "Player Rainbow Tracers",
 Flag = "PlayerRainbowTracersToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.rainbowTracers = state
  if featureStates.PlayerESP.tracers then
  stopPlayerESP()
  startPlayerESP()
  end
 end
})

PlayerDistanceESPToggle = Tabs.ESP:Toggle({
 Title = "Player Distance ESP",
 Flag = "PlayerDistanceESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.PlayerESP.distance = state
  if state or featureStates.PlayerESP.boxes or featureStates.PlayerESP.tracers or featureStates.PlayerESP.names then
  startPlayerESP()
  else
  stopPlayerESP()
  end
 end
})

PlayerHighlightsToggle = Tabs.ESP:Toggle({
 Title = "Player Highlights ESP",
 Flag = "PlayerHighlightsToggle",
 Value = false,
 Callback = function(state)
  PlayerHighlightsToggle = state
  if state then
  startPlayerHighlights()
  else
  stopPlayerHighlights()
  end
 end
})

Tabs.ESP:Section({ Title = "Enemy Name ESP" })

EnemyESPToggle = Tabs.ESP:Toggle({
 Title = "Enemy Name ESP",
 Flag = "EnemyESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.names = state
  if state then
  startEnemyESP()
  setupEnemyDetection()
  else
  stopEnemyESP()
  end
 end
})

EnemyBoxESPToggle = Tabs.ESP:Toggle({
 Title = "Enemy Box ESP",
 Flag = "EnemyBoxESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.boxes = state
  if state or featureStates.EnemyESP.names or featureStates.EnemyESP.tracers or featureStates.EnemyESP.distance then
  startEnemyESP()
  else
  stopEnemyESP()
  end
 end
})

EnemyBoxTypeDropdown = Tabs.ESP:Dropdown({
 Title = "Enemy Box Type",
 Flag = "EnemyBoxTypeDropdown",
 Values = {"2D", "3D"},
 Value = "2D",
 Callback = function(value)
  featureStates.EnemyESP.boxType = value
 end
})

EnemyRainbowBoxesToggle = Tabs.ESP:Toggle({
 Title = "Enemy Rainbow Boxes",
 Flag = "EnemyRainbowBoxesToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.rainbowBoxes = state
  if featureStates.EnemyESP.boxes then
  stopEnemyESP()
  startEnemyESP()
  end
 end
})

EnemyTracerToggle = Tabs.ESP:Toggle({
 Title = "Enemy Tracer",
 Flag = "EnemyTracerToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.tracers = state
  if state or featureStates.EnemyESP.names or featureStates.EnemyESP.boxes or featureStates.EnemyESP.distance then
  startEnemyESP()
  else
  stopEnemyESP()
  end
 end
})

EnemyRainbowTracersToggle = Tabs.ESP:Toggle({
 Title = "Enemy Rainbow Tracers",
 Flag = "EnemyRainbowTracersToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.rainbowTracers = state
  if featureStates.EnemyESP.tracers then
  stopEnemyESP()
  startEnemyESP()
  end
 end
})

EnemyDistanceESPToggle = Tabs.ESP:Toggle({
 Title = "Enemy Distance ESP",
 Flag = "EnemyDistanceESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.EnemyESP.distance = state
  if state or featureStates.EnemyESP.names or featureStates.EnemyESP.boxes or featureStates.EnemyESP.tracers then
  startEnemyESP()
  else
  stopEnemyESP()
  end
 end
})

Tabs.ESP:Section({ Title = "Downed Player ESP" })

DownedNameESPToggle = Tabs.ESP:Toggle({
 Title = "Downed Player Name ESP",
 Flag = "DownedNameESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.DownedNameESP = state
  if state then
  startDownedNameESP()
  else
  stopDownedNameESP()
  end
 end
})

DownedBoxESPToggle = Tabs.ESP:Toggle({
 Title = "Downed Player Box ESP",
 Flag = "DownedBoxESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.DownedBoxESP = state
  if state or featureStates.DownedTracer then
  if downedTracerConnection then stopDownedTracer() end
  startDownedTracer()
  else
  stopDownedTracer()
  end
 end
})

DownedBoxTypeDropdown = Tabs.ESP:Dropdown({
 Title = "Downed Box Type",
 Flag = "DownedBoxTypeDropdown",
 Values = {"2D", "3D"},
 Value = "2D",
 Callback = function(value)
  featureStates.DownedBoxType = value
 end
})

DownedTracerToggle = Tabs.ESP:Toggle({
 Title = "Downed Player Tracer",
 Flag = "DownedTracerToggle",
 Value = false,
 Callback = function(state)
  featureStates.DownedTracer = state
  if state or featureStates.DownedBoxESP then
  if downedTracerConnection then stopDownedTracer() end
  startDownedTracer()
  else
  stopDownedTracer()
  end
 end
})

DownedDistanceESPToggle = Tabs.ESP:Toggle({
 Title = "Downed Player Distance ESP",
 Flag = "DownedDistanceESPToggle",
 Value = false,
 Callback = function(state)
  featureStates.DownedDistanceESP = state
  if featureStates.DownedNameESP then
  stopDownedNameESP()
  startDownedNameESP()
  end
 end
})
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")

player = Players.LocalPlayer

PlayerHighlightsEnabled = false
DownedHighlightsEnabled = false

HighlightsConnection = nil
cachedPlayers = {}
lastPlayerCacheUpdate = 0
isRendering = true
windowFocused = true

function IsAlive(plr)
 character = plr.Character
 if not character then return false end
 
 humanoid = character:FindFirstChildOfClass("Humanoid")
 if not humanoid then return false end
 
 return humanoid.Health > 0
end

function IsDowned(character)
 return character:GetAttribute("Downed") == true
end

function getCachedPlayers()
 if tick() - lastPlayerCacheUpdate < 1 then
  return cachedPlayers
 end
 
 lastPlayerCacheUpdate = tick()
 cachedPlayers = Players:GetPlayers()
 return cachedPlayers
end

function clearAllHighlights()
 for _, plr in pairs(getCachedPlayers()) do
  if plr.Character then
  highlight = plr.Character:FindFirstChild("PlayerHighlight")
  if highlight then
 highlight:Destroy()
  end
  end
 end
end

function updateRoleHighlights()
 if not isRendering or not windowFocused then
  return
 end
 
 players = getCachedPlayers()

 for _, plr in ipairs(players) do
  if plr ~= player and plr.Character then
  model = plr.Character
  highlight = model:FindFirstChild("PlayerHighlight")
  isAlive = IsAlive(plr)
  isDowned = IsDowned(model)
  
  shouldShowHighlight = false
  if PlayerHighlightsEnabled and isAlive and not isDowned then
 shouldShowHighlight = true
  elseif DownedHighlightsEnabled and isDowned then
 shouldShowHighlight = true
  end
  
  if shouldShowHighlight then
 if isDowned then
  fillColor = Color3.fromRGB(255, 165, 0)
  outlineColor = Color3.fromRGB(200, 120, 0)
 else
  fillColor = Color3.fromRGB(0, 225, 0)
  outlineColor = Color3.fromRGB(0, 150, 0)
 end
 
 if not highlight then
  highlight = Instance.new("Highlight")
  highlight.Name = "PlayerHighlight"
  highlight.Adornee = model
  highlight.FillTransparency = 0.5
  highlight.OutlineTransparency = 0
  highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  highlight.Parent = model
 end
 highlight.FillColor = fillColor
 highlight.OutlineColor = outlineColor
 highlight.Enabled = true
  else
 if highlight then
  highlight:Destroy()
 end
  end
  end
 end
end

function startPlayerHighlights()
 PlayerHighlightsEnabled = true
 manageHighlightsConnection()
end

function stopPlayerHighlights()
 PlayerHighlightsEnabled = false
 manageHighlightsConnection()
end

function startDownedHighlights()
 DownedHighlightsEnabled = true
 manageHighlightsConnection()
end

function stopDownedHighlights()
 DownedHighlightsEnabled = false
 manageHighlightsConnection()
end

function manageHighlightsConnection()
 shouldRun = PlayerHighlightsEnabled or DownedHighlightsEnabled
 
 if shouldRun then
  if not HighlightsConnection then
  HighlightsConnection = RunService.Heartbeat:Connect(updateRoleHighlights)
  end
 else
  if HighlightsConnection then
  HighlightsConnection:Disconnect()
  HighlightsConnection = nil
  clearAllHighlights()
  end
 end
end

RunService.RenderStepped:Connect(function()
 isRendering = true
end)

lastRenderTime = tick()
renderCheckConnection = RunService.Heartbeat:Connect(function()
 currentTime = tick()
 
 if currentTime - lastRenderTime > 1 then
  isRendering = false
  clearAllHighlights()
 end
end)

RunService.RenderStepped:Connect(function()
 lastRenderTime = tick()
 isRendering = true
end)

UserInputService.WindowFocusReleased:Connect(function()
 windowFocused = false
 isRendering = false
 clearAllHighlights()
end)

UserInputService.WindowFocused:Connect(function()
 windowFocused = true
 isRendering = true
end)

game:GetService("GuiService"):GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
 if game:GetService("GuiService").MenuIsOpen then
  isRendering = false
  clearAllHighlights()
 else
  isRendering = true
 end
end)

Players.PlayerRemoving:Connect(function(plr)
 if plr.Character then
  highlight = plr.Character:FindFirstChild("PlayerHighlight")
  if highlight then
  highlight:Destroy()
  end
 end
end)

function cleanup()
 if HighlightsConnection then
  HighlightsConnection:Disconnect()
  HighlightsConnection = nil
 end
 if renderCheckConnection then
  renderCheckConnection:Disconnect()
 end
 clearAllHighlights()
end

game:GetService("ScriptContext").DescendantRemoving:Connect(function(descendant)
 if descendant == script then
  cleanup()
 end
end)
DownedHighlightsToggle = Tabs.ESP:Toggle({
 Title = "Downed Highlights ESP",
 Flag = "DownedHighlightsToggle",
 Value = false,
 Callback = function(state)
  DownedHighlightsToggle = state
  if state then
  startDownedHighlights()
  else
  stopDownedHighlights()
  end
 end
})
-- Utility Tab
FREECAM_SPEED = 50
SENSITIVITY = 0.002
JUMP_FORCE = 50

isFreecamEnabled = false
isFreecamMovementEnabled = true
cameraPosition = Vector3.new(0, 10, 0)
cameraRotation = Vector2.new(0, 0)
isMobile = not UserInputService.KeyboardEnabled
lastTouchPosition = nil
lastYPosition = nil
isJumping = false
isAltHeld = false

toggleFreeCam = Tabs.Utility:Toggle({
 Title = "Free Cam",
 Desc = "Toggle free camera movement",
 Value = false,
 Callback = function(value)
  if value then
  activateFreecam()
  else
  deactivateFreecam()
  end
 end
})

function updateCamera(dt)
 if not isFreecamEnabled or isAltHeld then return end
 
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local moveVector = Vector3.new(0, 0, 0)
 
 if isFreecamMovementEnabled and humanoid and humanoid.MoveDirection.Magnitude > 0 then
  local forward = camera.CFrame.LookVector
  local right = camera.CFrame.RightVector
  local forwardComponent = humanoid.MoveDirection:Dot(forward) * forward
  local rightComponent = humanoid.MoveDirection:Dot(right) * right
  moveVector = forwardComponent + rightComponent
 end
 
 if isFreecamMovementEnabled then
  if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
  moveVector = moveVector + Vector3.new(0, 1, 0)
  end
  if UserInputService:IsKeyDown(Enum.KeyCode.Q) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
  moveVector = moveVector - Vector3.new(0, 1, 0)
  end
 end
 
 if moveVector.Magnitude > 0 then
  moveVector = moveVector.Unit * FREECAM_SPEED * dt
  cameraPosition = cameraPosition + moveVector
 end
 
 camera.CameraType = Enum.CameraType.Scriptable
 local rotationCFrame = CFrame.Angles(0, cameraRotation.Y, 0) * CFrame.Angles(cameraRotation.X, 0, 0)
 camera.CFrame = CFrame.new(cameraPosition) * rotationCFrame
end

function onMouseMove(input)
 if not isFreecamEnabled or isMobile then return end
 cameraRotation = cameraRotation + Vector2.new(-input.Delta.Y * SENSITIVITY, -input.Delta.X * SENSITIVITY)
 cameraRotation = Vector2.new(math.clamp(cameraRotation.X, -math.pi/2, math.pi/2), cameraRotation.Y)
end

function onTouchMoved(input, gameProcessed)
 if not isFreecamEnabled or gameProcessed then return end
 
 if lastTouchPosition then
  local delta = input.Position - lastTouchPosition
  cameraRotation = cameraRotation + Vector2.new(-delta.Y * SENSITIVITY / 0.1, -delta.X * SENSITIVITY / 0.1)
  cameraRotation = Vector2.new(math.clamp(cameraRotation.X, -math.pi/2, math.pi/2), cameraRotation.Y)
 end
 lastTouchPosition = input.Position
end

function onTouchEnded(input)
 lastTouchPosition = nil
end

function freezePlayer(character)
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local rootPart = character and character:FindFirstChild("HumanoidRootPart")
 if not humanoid or not rootPart then return end
 
 lastYPosition = rootPart.Position.Y
 
 local diedConnection
 diedConnection = humanoid.Died:Connect(function()
  deactivateFreecam()
  diedConnection:Disconnect()
 end)
 
 if heartbeatConnection then heartbeatConnection:Disconnect() end
 heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
  if not isFreecamEnabled or not character.Parent then
  if rootPart then rootPart.Anchored = false end
  return
  end
  
  if isFreecamMovementEnabled then
  local currentY = rootPart.Position.Y
  if humanoid.FloorMaterial == Enum.Material.Air and not isJumping then
 local gravity = -196.2 * dt
 currentY = currentY + gravity * dt
  end
  rootPart.Position = Vector3.new(rootPart.Position.X, currentY, rootPart.Position.Z)
  lastYPosition = currentY
  end
 end)
end

UserInputService.JumpRequest:Connect(function()
 if not isFreecamEnabled or not isFreecamMovementEnabled then return end
 local character = player.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 local rootPart = character and character:FindFirstChild("HumanoidRootPart")
 if humanoid and rootPart and humanoid.FloorMaterial ~= Enum.Material.Air then
  isJumping = true
  local currentY = rootPart.Position.Y
  rootPart.Position = Vector3.new(rootPart.Position.X, currentY + JUMP_FORCE * 0.1, rootPart.Position.Z)
  task.delay(0.5, function() isJumping = false end)
 end
end)

function reloadFreecam()
 isFreecamEnabled = false
 isFreecamMovementEnabled = true
 camera.CameraType = Enum.CameraType.Custom
 UserInputService.MouseBehavior = Enum.MouseBehavior.Default
 cameraPosition = Vector3.new(0, 10, 0)
 cameraRotation = Vector2.new(0, 0)
 
 if heartbeatConnection then heartbeatConnection:Disconnect() end
 if touchConnection then touchConnection:Disconnect() end
 if inputChangedConnection then inputChangedConnection:Disconnect() end
 
 if toggleFreeCam then
  toggleFreeCam:Set(false)
 end
end

function activateFreecam()
 if isFreecamEnabled then return end
 isFreecamEnabled = true
 isFreecamMovementEnabled = true
 camera.CameraType = Enum.CameraType.Scriptable
 
 cameraPosition = camera.CFrame.Position
 local lookVector = camera.CFrame.LookVector
 cameraRotation = Vector2.new(math.asin(-lookVector.Y), math.atan2(-lookVector.X, lookVector.Z))
 
 UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
 
 if player.Character then
  freezePlayer(player.Character)
 end
 
 if characterAddedConnection then characterAddedConnection:Disconnect() end
 characterAddedConnection = player.CharacterAdded:Connect(function()
  reloadFreecam()
 end)
 
 if isMobile then
  if touchConnection then touchConnection:Disconnect() end
  touchConnection = UserInputService.TouchMoved:Connect(onTouchMoved)
  UserInputService.TouchEnded:Connect(onTouchEnded)
 end
 
 if inputChangedConnection then inputChangedConnection:Disconnect() end
 inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseMovement then
  onMouseMove(input)
  end
 end)
end

function deactivateFreecam()
 if not isFreecamEnabled then return end
 isFreecamEnabled = false
 isFreecamMovementEnabled = true
 isAltHeld = false
 camera.CameraType = Enum.CameraType.Custom
 UserInputService.MouseBehavior = Enum.MouseBehavior.Default
 
 if player.Character then
  local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
  if rootPart then rootPart.Anchored = false end
 end
 
 if heartbeatConnection then heartbeatConnection:Disconnect() end
 if touchConnection then touchConnection:Disconnect() end
 
 if toggleFreeCam then
  toggleFreeCam:Set(false)
 end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
 if gameProcessed then return end
 if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
  if isFreecamEnabled then
  isAltHeld = true
  if player.Character then
 local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
 if rootPart then
  rootPart.Anchored = false
 end
  end
  end
 elseif input.KeyCode == Enum.KeyCode.P and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
  if isFreecamEnabled then
  deactivateFreecam()
  else
  activateFreecam()
  end
 end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
 if gameProcessed then return end
 if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
  if isFreecamEnabled then
  isAltHeld = false
  if player.Character then
 local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
 if rootPart then
  rootPart.Anchored = false
 end
  end
  end
 end
end)

RunService.Heartbeat:Connect(updateCamera)
if characterAddedConnection then characterAddedConnection:Disconnect() end
characterAddedConnection = player.CharacterAdded:Connect(function()
 reloadFreecam()
end)

if not isMobile then
 WindUI:Notify({
  Title = "Free Cam",
  Content = "Use Ctrl+P to toggle Free Cam.",
  Duration = 3
 })
end

FreeCamSpeedSlider = Tabs.Utility:Slider({
 Title = "Free Cam Speed",
 Desc = "Adjust movement speed in Free Cam",
 Value = { Min = 1, Max = 500, Default = 50, Step = 1 },
 Callback = function(value)
  FREECAM_SPEED = value
 end
})

function setupDownedListener(character)
 if character then
  local downedConnection = character:GetAttributeChangedSignal("Downed"):Connect(function()
  if character:GetAttribute("Downed") == true then
 deactivateFreecam()
  end
  end)
  
  if character:GetAttribute("Downed") == true then
  deactivateFreecam()
  end
 end
end

if player.Character then
 setupDownedListener(player.Character)
end

player.CharacterAdded:Connect(setupDownedListener)

 Tabs.Utility:Space()
 
Tabs.Utility:Button({
 Title = "Clear Invis Walls",
 Callback = function()
  local invisPartsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("InvisParts")
  if invisPartsFolder then
  for _, obj in ipairs(invisPartsFolder:GetDescendants()) do
 if obj:IsA("BasePart") then
  obj.CanCollide = false
 end
  end
  end
 end
})
 Tabs.Utility:Space()
 
TimeChangerInput = Tabs.Utility:Input({
 Title = "Set Time (HH:MM)",
 Flag = "TimeChangerInput",
 Placeholder = "12:00",
 Callback = function(value)
  value = value:gsub("^%s*(.-)%s*$", "%1")
  
  local h_str, m_str = value:match("(%d+):(%d+)")
  if h_str and m_str then
  local h = tonumber(h_str)
  local m = tonumber(m_str)
  
  if h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59 and #h_str <= 2 and #m_str <= 2 then
 local totalHours = h + (m / 60)
 game:GetService("Lighting").ClockTime = totalHours
 end
  end
 end
})
getgenv().lagSwitchEnabled = false
getgenv().lagDuration = 0.5
local isLagActive = false
local lagSystemLoaded = false

function loadLagSystem()
    if lagSystemLoaded then return end
    lagSystemLoaded = true
end

function unloadLagSystem()
    if not lagSystemLoaded then return end
    lagSystemLoaded = false
    isLagActive = false
end

function checkLagState()
    local shouldLoad = getgenv().lagSwitchEnabled
    
    if shouldLoad and not lagSystemLoaded then
        loadLagSystem()
    elseif not shouldLoad and lagSystemLoaded then
        unloadLagSystem()
    end
end

Tabs.Utility:Space()
ButtonLib.Create:Button({
    Text = "Lag Switch",
    Flag = "LagSwitch",
    Visible = false,
    Callback = function() isLagActive = task.spawn(function()local d=getgenv().lagDuration or 0.5;local s=tick();while tick()-s<d do local a=math.random(1,1e6)*math.random(1,1e6);a=a/math.random(1,1e4)end;return false end)() end
}).Position = UDim2.new(0.5, -125, 0.2, 0)


LagSwitchToggle = Tabs.Utility:Toggle({
    Title = "Lag Switch",
    Flag = "LagSwitchToggle",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        getgenv().lagSwitchEnabled = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.LagSwitch then
            _G.DarahubLibBtn.LagSwitch.Visible = state
        end
        
        checkLagState()
    end
})

LagDurationInput = Tabs.Utility:Input({
    Title = "Lag Duration (seconds)",
    Flag = "LagDurationInput",
    Placeholder = "0.5",
    Value = tostring(getgenv().lagDuration),
    NumbersOnly = true,
    Callback = function(text)
        local n = tonumber(text)
        if n and n > 0 then
            getgenv().lagDuration = n
        end
    end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        unloadLagSystem()
    end
end)

checkLagState()

Tabs.Utility:Space()

GravityToggle = Tabs.Utility:Toggle({
    Title = "Custom Gravity",
    Flag = "GravityToggle",
    Value = false,
    Callback = function(state)
        featureStates.CustomGravity = state
        if state then
            workspace.Gravity = featureStates.GravityValue
        else
            workspace.Gravity = originalGameGravity
        end
    end
})


ButtonLib.Create:Toggle({
    Text = "Gravity",
    Flag = "GravityToggle",
    Default = false,
    Visible = false,
    Callback = function(s) 
        if GravityToggle then
            GravityToggle:Set(s)
        end
    end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

ShowGravityButtonToggle = Tabs.Utility:Toggle({
    Title = "Show Gravity Button",
    Flag = "ShowGravityButton",
    Value = false,
    Callback = function(state)
        featureStates.ShowGravityButton = state
        
        if _G.DarahubLibBtn and _G.DarahubLibBtn.GravityToggle then
            _G.DarahubLibBtn.GravityToggle.Visible = state
        end
    end
})
GravityInput = Tabs.Utility:Input({
    Title = "Gravity Value",
    Flag = "GravityInput",
    Placeholder = tostring(originalGameGravity),
    Value = tostring(featureStates.GravityValue),
    Callback = function(text)
        local num = tonumber(text)
        if num then
            featureStates.GravityValue = num
            if featureStates.CustomGravity then
                workspace.Gravity = num
            end
        end
    end
})

if featureStates.CustomGravity then
    workspace.Gravity = featureStates.GravityValue
else
    workspace.Gravity = originalGameGravity
end

if not featureStates then
    featureStates = {
        CustomGravity = false,
        GravityValue = workspace.Gravity
    }
end
local originalGameGravity = workspace.Gravity
player.CharacterAdded:Connect(function()
 hasRevived = false
 --[[ Disabled I don't like the stupid red error thing
   if featureStates.AutoSelfRevive then
  startAutoSelfRevive()
  ]]
end)
 Tabs.Utility:Space()
 
RemoveTexturesButton = Tabs.Utility:Button({
 Title = "Remove Textures",
 Callback = function()
  for _, part in ipairs(workspace:GetDescendants()) do
  if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") or part:IsA("WedgePart") or part:IsA("CornerWedgePart") then
 if part:IsA("Part") then
  part.Material = Enum.Material.SmoothPlastic
 end
 if part:FindFirstChildWhichIsA("Texture") then
  local texture = part:FindFirstChildWhichIsA("Texture")
  texture.Texture = "rbxassetid://0"
 end
 if part:FindFirstChildWhichIsA("Decal") then
  local decal = part:FindFirstChildWhichIsA("Decal")
  decal.Texture = "rbxassetid://0"
 end
  end
  end
 end
})
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
 if leavingPlayer == player then
  game:GetService("RunService"):Set3dRenderingEnabled(true)
 end
end) Tabs.Utility:Space()

LowQualityButton = Tabs.Utility:Button({
 Title = "Low Quality",
 Desc = "Disable textures, effects, and optimize graphics",
 Callback = function()
  local ToDisable = {
  Textures = true,
  VisualEffects = true,
  Parts = true,
  Particles = true,
  Sky = true
  }

  local ToEnable = {
  FullBright = false
  }

  local Stuff = {}

  for _, v in next, game:GetDescendants() do
  if ToDisable.Parts then
 if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("BasePart") then
  v.Material = Enum.Material.SmoothPlastic
  table.insert(Stuff, 1, v)
 end
  end
  
  if ToDisable.Particles then
 if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
  v.Enabled = false
  table.insert(Stuff, 1, v)
 end
  end
  
  if ToDisable.VisualEffects then
 if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
  v.Enabled = false
  table.insert(Stuff, 1, v)
 end
  end
  
  if ToDisable.Textures then
 if v:IsA("Decal") or v:IsA("Texture") then
  v.Texture = ""
  table.insert(Stuff, 1, v)
 end
  end
  
  if ToDisable.Sky then
 if v:IsA("Sky") then
  v.Parent = nil
  table.insert(Stuff, 1, v)
 end
  end
  end

  if ToEnable.FullBright then
  
  Lighting.FogColor = Color3.fromRGB(255, 255, 255)
  Lighting.FogEnd = math.huge
  Lighting.FogStart = math.huge
  Lighting.Ambient = Color3.fromRGB(255, 255, 255)
  Lighting.Brightness = 5
  Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
  Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
  Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
  Lighting.Outlines = true
  end
 end
})
Tabs.Utility:Space()
Tabs.Utility:Button({
 Title = "VIP CMD Macro",
 Icon = "rbxassetid://107814281854748",
 Callback = function() 
  local coreGui = game:GetService("CoreGui")
  if coreGui:FindFirstChild("MacroManagerGUI") then
  coreGui.MacroManagerGUI.Enabled = not coreGui.MacroManagerGUI.Enabled
  end
 end
})
Tabs.Utility:Space()
-- teleports tab
Tabs.Teleport:Section({ Title = "Teleports", TextSize = 20 })
Tabs.Teleport:Divider()

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Spawn",
 Desc = "Teleport to a random spawn location",
 Icon = "home",
 Callback = function()
  local spawnsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Parts") and workspace.Game.Map.Parts:FindFirstChild("Spawns")
  
  if spawnsFolder then
  local spawnLocations = spawnsFolder:GetChildren()
  if #spawnLocations > 0 then
 local randomSpawn = spawnLocations[math.random(1, #spawnLocations)]
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
 
 if humanoidRootPart then
  humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
 end
  end
  end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Random Player",
 Desc = "Teleport to a random online player",
 Icon = "users",
 Callback = function()
  local players = Players:GetPlayers()
  local validPlayers = {}
  
  for _, plr in ipairs(players) do
  if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
 table.insert(validPlayers, plr)
  end
  end
  
  if #validPlayers > 0 then
  local randomPlayer = validPlayers[math.random(1, #validPlayers)]
  local character = player.Character
  local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
  
  if humanoidRootPart then
 humanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
  end
  end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Downed Player",
 Desc = "Teleport to a random downed player",
 Icon = "heart",
 Callback = function()
  local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
  local downedPlayers = {}
  
  if playersFolder then
  for _, model in ipairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and model:GetAttribute("Downed") == true and model.Name ~= player.Name then
  local hrp = model:FindFirstChild("HumanoidRootPart")
  if hrp then
  table.insert(downedPlayers, model)
  end
 end
  end
  end
  
  if #downedPlayers > 0 then
  local randomDowned = downedPlayers[math.random(1, #downedPlayers)]
  local character = player.Character
  local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
  
  if humanoidRootPart then
 humanoidRootPart.CFrame = randomDowned.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
  end
  end
 end
})

local playerList = {}
Tabs.Teleport:Space()
PlayerDropdown = Tabs.Teleport:Dropdown({
 Title = "Select Player",
 Flag = "PlayerDropdown",
 Values = {"No players found"},
 Value = "No players found",
 Callback = function(selectedPlayer)
 end
})

function updatePlayerList()
 playerList = {}
 local players = Players:GetPlayers()
 local playerNames = {}
 
 for _, plr in ipairs(players) do
  if plr ~= player then
  table.insert(playerList, plr)
  table.insert(playerNames, plr.Name)
  end
 end
 
 if #playerNames == 0 then
  playerNames = {"No players found"}
 end
 
 PlayerDropdown:Refresh(playerNames, true)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

Tabs.Teleport:Button({
 Title = "Teleport to Selected Player",
 Desc = "Teleport to the player selected in dropdown",
 Icon = "user",
 Callback = function()
  local selectedPlayerName = PlayerDropdown.Value
  if selectedPlayerName ~= "No players found" then
  for _, plr in ipairs(playerList) do
 if plr.Name == selectedPlayerName and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
  local character = player.Character
  local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
  
  if humanoidRootPart then
  humanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
  end
  break
 end
  end
  end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Enemy",
 Desc = "Teleport to a random Enemy",
 Icon = "ghost",
 Callback = function()
  local Enemys = {}
  
  local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
  if playersFolder then
  for _, model in ipairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and isEnemyModel(model) then
  local hrp = model:FindFirstChild("HumanoidRootPart")
  if hrp then
  table.insert(Enemys, model)
  end
 end
  end
  end
  
  local NPCStorageFolder = workspace:FindFirstChild("NPCStorage")
  if NPCStorageFolder then
  for _, model in ipairs(NPCStorageFolder:GetChildren()) do
 if model:IsA("Model") and isEnemyModel(model) then
  local hrp = model:FindFirstChild("HumanoidRootPart")
  if hrp then
  table.insert(Enemys, model)
  end
 end
  end
  end
  
  if #Enemys > 0 then
  local randomEnemy = Enemys[math.random(1, #Enemys)]
  local character = player.Character
  local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
  
  if humanoidRootPart then
 humanoidRootPart.CFrame = randomEnemy.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
  end
  end
 end
})

Tabs.Teleport:Space()
 
local objectives = {}
local objectiveDropdown
local teleportButton
local refreshButton

function findObjectives()
 objectives = {}
 
 local gameFolder = workspace:FindFirstChild("Game")
 if not gameFolder then return false end
 
 local mapFolder = gameFolder:FindFirstChild("Map")
 if not mapFolder then return false end
 
 local partsFolder = mapFolder:FindFirstChild("Parts")
 if not partsFolder then return false end
 
 local objectivesFolder = partsFolder:FindFirstChild("Objectives")
 if not objectivesFolder then return false end
 
 for _, obj in pairs(objectivesFolder:GetChildren()) do
  if obj:IsA("Model") then
  local primaryPart = obj.PrimaryPart
  if not primaryPart then
 for _, part in pairs(obj:GetChildren()) do
  if part:IsA("BasePart") then
  primaryPart = part
  break
  end
 end
  end
  
  if primaryPart then
 table.insert(objectives, {
  Name = obj.Name,
  Part = primaryPart,
  Position = primaryPart.Position,
  Size = primaryPart.Size
 })
  end
  end
 end
 
 return #objectives > 0
end

function updateObjectiveDropdown()
 local hasObjectives = findObjectives()
 
 if not objectiveDropdown then
  warn("Objective dropdown not found in updateObjectiveDropdown")
  return
 end
 
 if hasObjectives and objectives then
  local objectiveNames = {}
  for _, obj in ipairs(objectives) do
  if obj and obj.Name then
 table.insert(objectiveNames, obj.Name)
  end
  end
  
  if #objectiveNames > 0 then
  objectiveDropdown:Refresh(objectiveNames, objectiveNames[1])
  else
  objectiveDropdown:Refresh({"No valid objectives"}, "No valid objectives")
  end
 else
  objectiveDropdown:Refresh({"No objectives found"}, "No objectives found")
 end
end
Tabs.Teleport:Space()
objectiveDropdown = Tabs.Teleport:Dropdown({
 Title = "Select Objective",
 Flag = "objectiveDropdown",
 Values = {"Loading..."},
 Value = "Loading...",
 Enabled = false,
 Callback = function(value)
 end
})

teleportButton = Tabs.Teleport:Button({
 Title = "Teleport to Objective",
 Icon = "navigation",
 Enabled = false,
 Callback = function()
  local selectedName = objectiveDropdown.Value
  if selectedName == "No objectives found" or selectedName == "Loading..." then
  return
  end
  
  local selectedObjective
  for _, obj in ipairs(objectives) do
  if obj.Name == selectedName then
 selectedObjective = obj
 break
  end
  end
  
  if not selectedObjective then
  return
  end
  
  local character = player.Character
  if not character then return end
  
  local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
  if not humanoidRootPart then return end
  
  local teleportPosition = selectedObjective.Position + Vector3.new(0, 5, 0)
  
  local raycastParams = RaycastParams.new()
  raycastParams.FilterDescendantsInstances = {character}
  raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
  
  local ray = workspace:Raycast(teleportPosition, Vector3.new(0, -10, 0), raycastParams)
  if ray then
  teleportPosition = ray.Position + Vector3.new(0, 3, 0)
  end
  
  humanoidRootPart.CFrame = CFrame.new(teleportPosition)
 end
})

refreshButton = Tabs.Teleport:Button({
 Title = "Refresh Objectives",
 Icon = "refresh-cw",
 Callback = function()
  updateObjectiveDropdown()
 end
})
task.spawn(function()
 task.wait(3)
 updateObjectiveDropdown()
 
 if workspace:FindFirstChild("Game") then
  local gameFolder = workspace.Game
  
  if gameFolder:FindFirstChild("Stats") then
  gameFolder.Stats:GetAttributeChangedSignal("RoundStarted"):Connect(function()
 task.wait(2)
 updateObjectiveDropdown()
  end)
  end
 end
end)
 -- Settings Tab
 Tabs.Settings:Section({ Title = "Settings", TextSize = 40 })
Tabs.Settings:Section({ Title = "Config Manager", TextSize = 20 })
Tabs.Settings:Divider()

-- Services
local ConfigManager = Window.ConfigManager

local CurrentConfigName = "default"
local AutoLoadConfig = "default"
local AutoLoadEnabled = false
local AutoSaveEnabled = false
local ConfigListDropdown = nil
local AutoSaveConnection = nil

function FileExists(path)
 if isfile then
  return pcall(readfile, path)
 end
 return false
end

function WriteFile(path, content)
 if writefile then
  return pcall(writefile, path, content)
 end
 return false
end

function ReadFile(path)
 if readfile then
  local success, content = pcall(readfile, path)
  if success then
  return content
  end
 end
 return ""
end

function loadAutoLoadSettings()
 local autoLoadFile = "Darahub/AutoLoad/Game/Evade-Legacy/AutoLoad.json"
 
 if FileExists(autoLoadFile) then
  local content = ReadFile(autoLoadFile)
  
  if content ~= "" then
  local success, data = pcall(function()
 return HttpService:JSONDecode(content)
  end)
  
  if success and data then
 AutoLoadConfig = data.configName or "default"
 AutoLoadEnabled = data.enabled or false
 return true
  end
  end
 end
 
 AutoLoadConfig = "default"
 AutoLoadEnabled = false
 return false
end

function saveAutoLoadSettings()
 local autoLoadFile = "Darahub/AutoLoad/Game/Evade-Legacy/AutoLoad.json"
 
 local success = WriteFile(autoLoadFile, "")
 if not success then
  if makefolder then
  pcall(function() makefolder("Darahub") end)
  pcall(function() makefolder("Darahub/AutoLoad") end)
  pcall(function() makefolder("Darahub/AutoLoad/Game") end)
  pcall(function() makefolder("Darahub/AutoLoad/Game/Evade-Legacy") end)
  end
 end
 
 local data = {
  enabled = AutoLoadEnabled,
  configName = AutoLoadConfig
 }
 
 local success, json = pcall(function()
  return HttpService:JSONEncode(data)
 end)
 
 if success then
  WriteFile(autoLoadFile, json)
 end
end

loadAutoLoadSettings()

local ConfigNameInput = Tabs.Settings:Input({
 Title = "Config Name",
 Flag = "ConfigNameInput",
 Desc = "Name for your config file",
 Icon = "file-cog",
 Placeholder = "default",
 Value = CurrentConfigName,
 Callback = function(value)
  if value ~= "" then
  CurrentConfigName = value
  end
 end
})

Tabs.Settings:Space()

local AutoLoadToggle = Tabs.Settings:Toggle({
 Title = "Auto Load",
 Flag = "AutoLoadToggle",
 Desc = "Automatically load this config when script starts",
 Value = AutoLoadEnabled,
 Callback = function(state)
  AutoLoadEnabled = state
  if state then
  AutoLoadConfig = CurrentConfigName
  WindUI:Notify({
 Title = "Auto-Load",
 Content = "Config '" .. CurrentConfigName .. "' will load automatically on startup",
 Duration = 3
  })
  end
  saveAutoLoadSettings()
 end
})

local AutoSaveToggle = Tabs.Settings:Toggle({
 Title = "Auto Save",
 Flag = "AutoSaveToggle",
 Desc = "Automatically save changes to config every second",
 Value = AutoSaveEnabled,
 Callback = function(state)
  AutoSaveEnabled = state
  
  -- Stop existing auto-save loop if it exists
  if AutoSaveConnection then
  AutoSaveConnection:Disconnect()
  AutoSaveConnection = nil
  end
  
  if state then
  WindUI:Notify({
 Title = "Auto-Save",
 Content = "Config will save automatically every second",
 Duration = 2
  })
  
  -- Start auto-save loop
  AutoSaveConnection = game:GetService("RunService").Heartbeat:Connect(function()
 if AutoSaveEnabled and CurrentConfigName ~= "" then
  task.spawn(function()
  Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
  Window.CurrentConfig:Save()
  end)
 end
 task.wait(1) -- Save every second
  end)
  else
  WindUI:Notify({
 Title = "Auto-Save",
 Content = "Auto-save disabled",
 Duration = 2
  })
  end
 end
})

Tabs.Settings:Space()

function refreshConfigList()
 local allConfigs = ConfigManager:AllConfigs() or {}
 
 -- Ensure "default" config exists
 if not table.find(allConfigs, "default") then
  -- Create default config if it doesn't exist
  local defaultConfig = ConfigManager:Config("default")
  if defaultConfig and defaultConfig.Save then
  defaultConfig:Save()
  end
  table.insert(allConfigs, 1, "default")
 end
 
 table.sort(allConfigs, function(a, b)
  return a:lower() < b:lower()
 end)
 
 local defaultValue = table.find(allConfigs, CurrentConfigName) and CurrentConfigName or "default"
 
 if ConfigListDropdown and ConfigListDropdown.Refresh then
  ConfigListDropdown:Refresh(allConfigs, defaultValue)
 end
end

ConfigListDropdown = Tabs.Settings:Dropdown({
 Title = "Existing Configs",
 Flag = "ConfigListDropdown",
 Desc = "Select from saved configs",
 Values = {"default"},
 Value = "default",
 Callback = function(value)
  CurrentConfigName = value
  ConfigNameInput:Set(value)
  
  if AutoLoadEnabled then
  AutoLoadConfig = value
  saveAutoLoadSettings()
  end
  
  local config = ConfigManager:GetConfig(value)
  if config then
  WindUI:Notify({
 Title = "Config Selected",
 Content = "Config '" .. value .. "' selected",
 Duration = 2
  })
  end
 end
})

Tabs.Settings:Space()

local SaveConfigButton = Tabs.Settings:Button({
 Title = "Save Config",
 Desc = "Save current settings to config",
 Icon = "save",
 Callback = function()
  if CurrentConfigName == "" then
  WindUI:Notify({
 Title = "Error",
 Content = "Please enter a config name",
 Duration = 3
  })
  return
  end
  
  Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
  
  local success = Window.CurrentConfig:Save()
  if success then
  WindUI:Notify({
 Title = "Config Saved",
 Content = "Config '" .. CurrentConfigName .. "' saved successfully",
 Duration = 3
  })
  
  if AutoLoadEnabled then
 AutoLoadConfig = CurrentConfigName
 saveAutoLoadSettings()
  end
  
  task.wait(0.5)
  refreshConfigList()
  else
  WindUI:Notify({
 Title = "Error",
 Content = "Failed to save config",
 Duration = 3
  })
  end
 end
})

Tabs.Settings:Space()

local LoadConfigButton = Tabs.Settings:Button({
 Title = "Load Config",
 Desc = "Load settings from selected config",
 Icon = "folder-open",
 Callback = function()
  if CurrentConfigName == "" then
  WindUI:Notify({
 Title = "Error",
 Content = "Please enter a config name",
 Duration = 3
  })
  return
  end
  
  Window.CurrentConfig = ConfigManager:CreateConfig(CurrentConfigName)
  
  local success = Window.CurrentConfig:Load()
  if success then
  WindUI:Notify({
 Title = "Config Loaded",
 Content = "Config '" .. CurrentConfigName .. "' loaded successfully",
 Duration = 3
  })
  
  if AutoLoadEnabled then
 AutoLoadConfig = CurrentConfigName
 saveAutoLoadSettings()
  end
  else
  WindUI:Notify({
 Title = "Error",
 Content = "Config '" .. CurrentConfigName .. "' not found or empty",
 Duration = 3
  })
  end
 end
})

Tabs.Settings:Space()

local DeleteConfigButton = Tabs.Settings:Button({
 Title = "Delete Config",
 Desc = "Delete selected config",
 Icon = "trash-2",
 Color = Color3.fromHex("#ff4830"),
 Callback = function()
  if CurrentConfigName == "default" then
  WindUI:Notify({
 Title = "Error",
 Content = "Cannot delete default config",
 Duration = 3
  })
  return
  end
  
  local success = ConfigManager:DeleteConfig(CurrentConfigName)
  if success then
  WindUI:Notify({
 Title = "Config Deleted",
 Content = "Config '" .. CurrentConfigName .. "' deleted",
 Duration = 3
  })
  
  CurrentConfigName = "default"
  ConfigNameInput:Set("default")
  
  if AutoLoadEnabled then
 AutoLoadConfig = "default"
 saveAutoLoadSettings()
  end
  
  task.wait(0.5)
  refreshConfigList()
  else
  WindUI:Notify({
 Title = "Error",
 Content = "Failed to delete config or config doesn't exist",
 Duration = 3
  })
  end
 end
})

Tabs.Settings:Space()

local RefreshConfigButton = Tabs.Settings:Button({
 Title = "Refresh Config List",
 Desc = "Update the list of available configs",
 Icon = "refresh-cw",
 Callback = function()
  refreshConfigList()
  WindUI:Notify({
  Title = "Config List Refreshed",
  Content = "Config list updated",
  Duration = 2
  })
 end
})

task.spawn(function()
 task.wait(0.5) 
 refreshConfigList()
 
 ConfigNameInput:Set("default")
 
 if AutoLoadEnabled then
  CurrentConfigName = AutoLoadConfig
  ConfigNameInput:Set(CurrentConfigName)
  
  task.wait(1)
  Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
  
  if Window.CurrentConfig:Load() then
  WindUI:Notify({
 Title = "Auto-Loaded",
 Content = "Config '" .. CurrentConfigName .. "' loaded automatically",
 Duration = 3
  })
  end
 end
end)

if AutoSaveEnabled then
 task.spawn(function()
  task.wait(1)
  
  if AutoSaveEnabled then
  AutoSaveConnection = game:GetService("RunService").Heartbeat:Connect(function()
 if AutoSaveEnabled and CurrentConfigName ~= "" then
  task.spawn(function()
  Window.CurrentConfig = ConfigManager:Config(CurrentConfigName)
  Window.CurrentConfig:Save()
  end)
 end
 task.wait(1)
  end)
  end
 end)
end
 Tabs.Settings:Section({ Title = "Personalize", TextSize = 20 })
 Tabs.Settings:Divider()

 local themes = {}
 for themeName, _ in pairs(WindUI:GetThemes()) do
  table.insert(themes, themeName)
 end
 table.sort(themes)

 local canChangeTheme = true
 local canChangeDropdown = true

 ThemeDropdown = Tabs.Settings:Dropdown({
  Title = "Select Theme",
  Flag = "ThemeDropdown",
  Values = themes,
  SearchBarEnabled = true,
  MenuWidth = 280,
  Value = "Dark",
  Callback = function(theme)
  if canChangeDropdown then
 canChangeTheme = false
 WindUI:SetTheme(theme)
 canChangeTheme = true
  end
  end
 })

 local TransparencySlider = Tabs.Settings:Slider({
  Title = "Window Transparency",
  Flag = "TransparencySlider",
  Value = { Min = 0, Max = 1, Default = 0.2, Step = 0.1 },
  Callback = function(value)
  WindUI.TransparencyValue = tonumber(value)
  Window:ToggleTransparency(tonumber(value) > 0)
  end
 })

 ThemeToggle = Tabs.Settings:Toggle({
  Title = "Enable Dark Mode",
  Flag = "ThemeToggle",
  Desc = "Use dark color scheme",
  Value = true,
  Callback = function(state)
  if canChangeTheme then
 local newTheme = state and "Dark" or "Light"
 WindUI:SetTheme(newTheme)
 if canChangeDropdown then
  ThemeDropdown:Select(newTheme)
 end
  end
  end
 })

 WindUI:OnThemeChange(function(theme)
  canChangeTheme = false
  ThemeToggle:Set(theme == "Dark")
  canChangeTheme = true
 end)

 Tabs.Settings:Section({ Title = "Keybinds" })
  Tabs.Settings:Keybind({
  Flag = "WinKeybind",
  Title = "Windows Keybind",
  Desc = "Keybind to open ui",
  Value = "RightControl",
  Callback = function(RightControl)
  Window:SetToggleKey(Enum.KeyCode[RightControl])
  end
 })
Tabs.Settings:Section({ Title = "Main Tabs Keybinds" })
 
Tabs.Settings:Keybind({ Flag = "StartRecord", Title = "Start Recording", Value = "", Callback = StartRecord })
Tabs.Settings:Keybind({ Flag = "StopRecord",  Title = "Stop Recording",  Value = "", Callback = StopRecord })
Tabs.Settings:Keybind({ Flag = "PlayTAS", Title = "Play TAS",  Value = "", Callback = PlayTAS })
Tabs.Settings:Section({ Title = "Note: This is a permanent Changes, it's can be used to pass limit value", TextSize = 15 })
Tabs.Settings:Space()

EmoteCrouchKeybind = Tabs.Settings:Keybind({
    Title = "Trigger Random Emote",
    Desc = "Keybind to trigger random emote with crouch",
    Value = "J",
    Flag = "EmoteCrouchKeybind",
    Callback = function(v)
        if featureStates.EmoteCrouchEnabled then
            triggerRandomEmote()
        end
    end
})

SuperBounceKeybind = Tabs.Settings:Keybind({
    Title = "Trigger Super Bounce",
    Desc = "Keybind to trigger super bounce",
    Value = "N",
    Flag = "SuperBounceKeybind",
    Callback = function(v)
        if featureStates.SuperBounceEnabled then
            triggerSuperBounce()
        end
    end
})

Tabs.Settings:Section({ Title = "Player Tabs Keybinds" })
Tabs.Settings:Space()

EasyTrimpKeybind = Tabs.Settings:Keybind({
    Title = "Easy Trimp Toggle",
    Desc = "Keybind to toggle Easy Trimp",
    Value = "U",
    Flag = "EasyTrimpKeybind",
    Callback = function(v)
        EasyTrimpToggle:Set(not EasyTrimpToggle.Value)
    end
})

Tabs.Settings:Section({ Title = "Auto Tabs Keybinds" })

BhopKeybind = Tabs.Settings:Keybind({
    Title = "Bhop Toggle Key",
    Desc = "Keybind to toggle Bhop",
    Value = "B",
    Flag = "BhopKeybind",
    Callback = function(v)
        BhopToggle:Set(not BhopToggle.Value)
    end
})

BhopHoldKeybind = Tabs.Settings:Keybind({
    Title = "Bhop Hold JUMP",
    Desc = "Keybind to toggle Bhop Hold",
    Value = "",
    Flag = "BhopHoldKeybind",
    Callback = function(v)
        BhopHoldToggle:Set(not BhopHoldToggle.Value)
    end
})

Tabs.Settings:Space()

AutoCrouchKeybind = Tabs.Settings:Keybind({
    Title = "Auto Crouch Toggle",
    Desc = "Keybind to toggle Auto Crouch",
    Value = "C",
    Flag = "AutoCrouchKeybind",
    Callback = function(v)
        AutoCrouchToggle:Set(not AutoCrouchToggle.Value)
    end
})

Tabs.Settings:Space()

AutoCarryKeybind = Tabs.Settings:Keybind({
    Title = "Auto Carry Toggle",
    Desc = "Keybind to toggle Auto Carry",
    Value = "X",
    Flag = "AutoCarryKeybind",
    Callback = function(v)
        AutoCarryToggle:Set(not AutoCarryToggle.Value)
    end
})

Tabs.Settings:Section({ Title = "Utility Tabs Keybinds" })

LagSwitchKeybind = Tabs.Settings:Keybind({
    Title = "Trigger Lag Switch",
    Desc = "Keybind to trigger lag switch",
    Value = "L",
    Flag = "LagSwitchKeybind",
    Callback = function(v)
        if getgenv().lagSwitchEnabled and not isLagActive then
            isLagActive = true
            task.spawn(function()
                local duration = getgenv().lagDuration or 0.5
                local start = tick()
                while tick() - start < duration do
                    local a = math.random(1, 1000000) * math.random(1, 1000000)
                    a = a / math.random(1, 10000)
                end
                isLagActive = false
            end)
        end
    end
})

Tabs.Settings:Space()

GravityKeybind = Tabs.Settings:Keybind({
    Title = "Toggle Gravity",
    Desc = "Keybind to toggle custom gravity",
    Value = "J",
    Flag = "GravityKeybind",
    Callback = function(v)
        GravityToggle:Set(not GravityToggle.Value)
    end
})


Tabs.Settings:Section({ Title = "Game Settings", TextSize = 20 })
Tabs.Settings:Divider()

Player = game:GetService("Players").LocalPlayer
PlayerSettings = Player.Settings

if not PlayerSettings then
    repeat task.wait() until Player.Settings
    PlayerSettings = Player.Settings
end

SettingControls = {}

CreateSettingControl = function(settingName, settingValue, valueType)
    if valueType == "IntValue" then
        control = Tabs.Settings:Input({
            Title = settingName,
            Flag = settingName .. "Input",
            Placeholder = tostring(settingValue),
            NumbersOnly = true,
            Value = tostring(settingValue),
            Callback = function(value)
                numValue = tonumber(value)
                if numValue then
                    PlayerSettings:SetAttribute(settingName, numValue)
                    Event = game:GetService("ReplicatedStorage").Events.UpdateSetting
                    Event:FireServer(settingName, numValue)
                end
            end
        })
        SettingControls[settingName] = control
        return control
        
    elseif valueType == "BoolValue" then
        control = Tabs.Settings:Toggle({
            Title = settingName,
            Flag = settingName .. "Toggle",
            Value = settingValue,
            Callback = function(state)
                PlayerSettings:SetAttribute(settingName, state)
                Event = game:GetService("ReplicatedStorage").Events.UpdateSetting
                    Event:FireServer(settingName, state)
            end
        })
        SettingControls[settingName] = control
        return control
    end
end

SettingsUpdated = function(settingName, newValue, valueType)
    control = SettingControls[settingName]
    if control and control.Set then
        if valueType == "IntValue" then
            control:Set(tostring(newValue))
        elseif valueType == "BoolValue" then
            control:Set(newValue)
        end
    end
end

for _, child in pairs(PlayerSettings:GetChildren()) do
    if child:IsA("IntValue") then
        settingName = child.Name
        settingValue = child.Value
        CreateSettingControl(settingName, settingValue, "IntValue")
        
        child.Changed:Connect(function(newValue)
            SettingsUpdated(settingName, newValue, "IntValue")
        end)
        
    elseif child:IsA("BoolValue") then
        settingName = child.Name
        settingValue = child.Value
        CreateSettingControl(settingName, settingValue, "BoolValue")
        
        child.Changed:Connect(function(newValue)
            SettingsUpdated(settingName, newValue, "BoolValue")
        end)
    end
end

for _, attributeName in pairs(PlayerSettings:GetAttributes()) do
    settingValue = PlayerSettings:GetAttribute(attributeName)
    if settingValue ~= nil then
        valueType = type(settingValue)
        if valueType == "number" then
            CreateSettingControl(attributeName, settingValue, "IntValue")
            
            PlayerSettings:GetAttributeChangedSignal(attributeName):Connect(function()
                newValue = PlayerSettings:GetAttribute(attributeName)
                if newValue ~= nil then
                    SettingsUpdated(attributeName, newValue, "IntValue")
                end
            end)
            
        elseif valueType == "boolean" then
            CreateSettingControl(attributeName, settingValue, "BoolValue")
            
            PlayerSettings:GetAttributeChangedSignal(attributeName):Connect(function()
                newValue = PlayerSettings:GetAttribute(attributeName)
                if newValue ~= nil then
                    SettingsUpdated(attributeName, newValue, "BoolValue")
                end
            end)
        end
    end
end

do
    local CoreGui = game:GetService("CoreGui")
    local DarahubFolder = CoreGui:FindFirstChild("Darahub")

    if DarahubFolder and Tabs and Tabs.Settings then
        Tabs.Settings:Section({
            Title = "GUI Size"
        })
        local defaultScales = {}

        for _, Element in pairs(DarahubFolder:GetChildren()) do
            if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                defaultScales[Element.Name] = Element.UIScale.Scale
            end
        end

        Tabs.Settings:Button({
            Title = "Reset All Scales",
            Description = "Reverts all buttons to their startup scale values",
            Callback = function()
                for _, Element in pairs(DarahubFolder:GetChildren()) do
                    if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                        local original = defaultScales[Element.Name] or 1
                        Element.UIScale.Scale = original
                    end
                end
            end
        })

        for _, Element in pairs(DarahubFolder:GetChildren()) do
            if Element:IsA("Frame") and Element:FindFirstChild("UIScale") then
                local currentScale = tonumber(Element.UIScale.Scale) or 1
                
                Tabs.Settings:Slider({
                    Title = Element.Name .. " Scale",
                    Desc = "Adjust GUI scale",
                    Flag = "Scale_Slider_" .. Element.Name,
                    Step = 0.01,
                    Value = {
                        Min = 0.01,
                        Max = 4,
                        Default = currentScale
                    },
                    Callback = function(val)
                        if Element and Element:FindFirstChild("UIScale") then
                            Element.UIScale.Scale = tonumber(val)
                        end
                    end
                })
            end
        end
    end
end
Tabs.Settings:Section({ Title = "UI Visibility", TextSize = 20 })
Tabs.Settings:Divider()

player = game:GetService("Players").LocalPlayer

TopGuiButtonDropdown = Tabs.Settings:Dropdown({
 Title = "Top UI Visibility",
 Flag = "TopGuiButtonDropdown",
 Desc = "Show/hide buttons in CustomTopGui",
 Values = {"VIPMenuButton", "LeaderboardButton", "SecondaryButton", "ReloadButton"},
 Multi = true,
 AllowNone = true,
 Value = {"VIPMenuButton", "LeaderboardButton", "SecondaryButton", "ReloadButton"},
 Callback = function(values)
  playerGui = player.PlayerGui
  customTopGui = playerGui:FindFirstChild("CustomTopGui")
  if not customTopGui then return end
  frame = customTopGui:FindFirstChild("Frame")
  if not frame then return end
  rightFrame = frame:FindFirstChild("Right")
  if not rightFrame then return end
  
  buttonNames = {"SecondaryButton", "VIPMenuButton", "LeaderboardButton", "ReloadButton"}
  
  for _, buttonName in ipairs(buttonNames) do
  frame = rightFrame:FindFirstChild(buttonName)
  if frame then
 frameVisible = false
 for _, selectedName in ipairs(values) do
  if selectedName == buttonName then
  frameVisible = true
  break
  end
 end
 frame.Visible = frameVisible
  end
  end
 end
})

FPSCounterToggle = Tabs.Settings:Toggle({
 Title = "Show FPS Counter",
 Flag = "FPSCounterToggle",
 Value = true,
 Callback = function(state)
  FPSCounter = game:GetService("CoreGui"):FindFirstChild("FPSCounter")
  if FPSCounter and FPSCounter:IsA("ScreenGui") then
  FPSCounter.Enabled = state
  end
 end
})
Tabs.Settings:Section({ Title = "UI Topbar Management", TextSize = 20 })

TopbarAnimationToggle = Tabs.Settings:Toggle({
 Title = "Topbar Animation",
 Flag = "TopbarAnimationToggle",
 Value = TopbarSettings.TopbarAnimation,
 Callback = function(state)
  TopbarSettings.TopbarAnimation = state
  for key, buttonData in pairs(createdButtons) do
   if buttonData and buttonData.updateVisualState then
   pcall(buttonData.updateVisualState)
   end
  end
 end
})

TopbarLockValueToggle = Tabs.Settings:Toggle({
 Title = "Topbar Lock Value",
 Flag = "TopbarLockValueToggle",
 Value = TopbarSettings.TopbarLockValue,
 Callback = function(state)
  TopbarSettings.TopbarLockValue = state
  UpdateAllButtons()
 end
})

task.wait(0.5)
FPSCounter = game:GetService("CoreGui"):FindFirstChild("FPSCounter")
if FPSCounter and FPSCounter:IsA("ScreenGui") then
 FPSCounterToggle:Set(FPSCounter.Enabled)
end

Tabs.Settings:Section({ Title = "Sensitivity Controls", TextSize = 20 })
Tabs.Settings:Divider()

MouseSensitivityEnabled = false
MouseSensitivityValue = 1.0
TouchSensitivityEnabled = false
TouchSensitivityValue = 1.0
MIN_SENSITIVITY = 0.1
MAX_SENSITIVITY = 20.0
DEFAULT_SENSITIVITY = 1.0
cameraInputModule = nil
mouseHookActive = false
touchHookActive = false

function setupSensitivityHook()
    if cameraInputModule then return true end
    
    local player = game:GetService("Players").LocalPlayer
    local success = false
    
    pcall(function()
        local playerScripts = player:FindFirstChild("PlayerScripts")
        if not playerScripts then return end
        
        local playerModule = playerScripts:FindFirstChild("PlayerModule")
        if not playerModule then return end
        
        local cameraModule = playerModule:FindFirstChild("CameraModule")
        if cameraModule then
            local cameraInput = cameraModule:FindFirstChild("CameraInput")
            if cameraInput then
                cameraInputModule = require(cameraInput)
                if cameraInputModule and cameraInputModule.getRotation then
                    local originalGetRotation = cameraInputModule.getRotation
                    cameraInputModule.getRotation = function(disableRotation)
                        local rotation = originalGetRotation(disableRotation)
                        local uis = game:GetService("UserInputService")
                        
                        if MouseSensitivityEnabled and uis.MouseEnabled then
                            return rotation * MouseSensitivityValue
                        elseif TouchSensitivityEnabled and uis.TouchEnabled then
                            return rotation * TouchSensitivityValue
                        end
                        return rotation
                    end
                    success = true
                end
            end
        end
    end)
    
    return success
end

MouseSensitivityToggle = Tabs.Settings:Toggle({
    Title = "Mouse Sensitivity",
    Flag = "MouseSensitivityToggle",
    Desc = "Adjust mouse sensitivity",
    Value = false,
    Callback = function(state)
        MouseSensitivityEnabled = state
        
        if state then
            if not setupSensitivityHook() then
                WindUI:Notify({
                    Title = "Mouse Sensitivity",
                    Content = "Failed to hook system. Try rejoining.",
                    Duration = 3
                })
                MouseSensitivityToggle:Set(false)
                MouseSensitivityEnabled = false
            end
        end
    end
})

MouseSensitivitySlider = Tabs.Settings:Slider({
    Title = "Mouse Sensitivity Value",
    Flag = "MouseSensitivitySlider",
    Desc = "Lower = slower, Higher = faster (Max: 20)",
    Value = { Min = 0.1, Max = 20, Default = 1.0 },
    Step = 0.1,
    Callback = function(value)
        MouseSensitivityValue = value
    end
})

Tabs.Settings:Space()

TouchSensitivityToggle = Tabs.Settings:Toggle({
    Title = "Touch Sensitivity",
    Flag = "TouchSensitivityToggle",
    Desc = "Adjust touch/mobile sensitivity",
    Value = false,
    Callback = function(state)
        TouchSensitivityEnabled = state
        
        if state then
            if not setupSensitivityHook() then
                WindUI:Notify({
                    Title = "Touch Sensitivity",
                    Content = "Failed to hook system. Try rejoining.",
                    Duration = 3
                })
                TouchSensitivityToggle:Set(false)
                TouchSensitivityEnabled = false
            end
        end
    end
})

TouchSensitivitySlider = Tabs.Settings:Slider({
    Title = "Touch Sensitivity Value",
    Flag = "TouchSensitivitySlider",
    Desc = "Lower = slower, Higher = faster (Max: 20)",
    Value = { Min = 0.1, Max = 20, Default = 1.0 },
    Step = 0.1,
    Callback = function(value)
        TouchSensitivityValue = value
    end
})

Tabs.Settings:Space()

Tabs.Settings:Section({ Title = "Reset Controls", TextSize = 20 })
Tabs.Settings:Divider()

Tabs.Settings:Button({
    Title = "Reset Sensitivity Settings",
    Desc = "Reset both mouse and touch sensitivity to defaults",
    Icon = "refresh-cw",
    Color = Color3.fromHex("#FF3030"),
    Callback = function()
        MouseSensitivityEnabled = false
        MouseSensitivityValue = DEFAULT_SENSITIVITY
        
        TouchSensitivityEnabled = false
        TouchSensitivityValue = DEFAULT_SENSITIVITY
        
        cameraInputModule = nil
        mouseHookActive = false
        touchHookActive = false
        
        if MouseSensitivityToggle then 
            MouseSensitivityToggle:Set(false) 
        end
        if MouseSensitivitySlider then 
            MouseSensitivitySlider:Set(1.0) 
        end
        if TouchSensitivityToggle then 
            TouchSensitivityToggle:Set(false) 
        end
        if TouchSensitivitySlider then 
            TouchSensitivitySlider:Set(1.0) 
        end
        
        WindUI:Notify({
            Title = "Sensitivity Reset",
            Content = "All sensitivity settings reset to default",
            Duration = 3
        })
    end
})
