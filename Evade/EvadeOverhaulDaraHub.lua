if getgenv().DaraHubExecuted then
game:GetService("Players").LocalPlayer.PlayerGui.Global.Messages.Use:Fire("Script Is Already Loaded, rejoin of you want to re-execute", "Error")
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
-- load shit button
local ButtonLib = loadstring(game:HttpGet("https://darahub.vercel.app/Module/Button-lib.lua"))()
-- shit leaderboard exit
coroutine.wrap(function() task.wait(3) while true do local success, err = pcall(function() local leaderboard = game:GetService("Players").LocalPlayer.PlayerGui.Global.Leaderboard if leaderboard then local exitButton = leaderboard.Center.XboxExit if exitButton then exitButton.Visible = true exitButton.Exit.MouseButton1Click:Connect(function() leaderboard.Visible = false end) end end end) if not success then warn("Leaderboard exit button setup failed:", err) end task.wait(5) end end)()
--macro command gui
Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
HttpService = game:GetService("HttpService")
Player = Players.LocalPlayer
PlayerGui = Player:WaitForChild("PlayerGui")
CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
task.wait(5) -- add little delay prevent vip command not loading
if not (player:GetAttribute("VIPCommandsAccess") == true) then
else
function getDpiScale()
 local Players = game:GetService("Players")
 local player = Players.LocalPlayer
 local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
 local frame = Instance.new("Frame", gui)
 frame.Size = UDim2.new(0, 100, 0, 100)
  task.wait()
  local scale = frame.AbsoluteSize.X / 100
  gui:Destroy()
  return math.clamp(math.round(scale * 10) / 10, 1, 3)
end
local DPI = getDpiScale()
local FILLED = "●"
local OPEN = "○"

function safeReadFile(path)
	if not readfile then return nil end
	local success, content = pcall(readfile, path)
	return success and content or nil
end

function safeWriteFile(path, data)
	if not writefile then return false end
	local success, _ = pcall(writefile, path, data)
	return success
end

local CONFIG_DIR = "DaraHub"
local CONFIG_FILE = CONFIG_DIR .. "/EvadeMacroVipCMD.json"
if isfolder and not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end

local Presets = {}

function serializeMacro(macro)
	local ser = table.clone(macro)
	ser.keybind = macro.keybind.Name
	if macro.startCondition then
		ser.startCondition = macro.startCondition
		ser.startRoundType = macro.startRoundType
		ser.startTimeType = macro.startTimeType
		ser.startTimeValue = macro.startTimeValue
		ser.startTimeUnit = macro.startTimeUnit
		ser.startRoundsCompleted = macro.startRoundsCompleted
	end
	return ser
end

function deserializeMacro(ser)
	local macro = table.clone(ser)
	macro.keybind = ser.keybind and Enum.KeyCode[ser.keybind] or Enum.KeyCode.F
	if ser.startCondition then
		macro.startCondition = ser.startCondition
		macro.startRoundType = ser.startRoundType
		macro.startTimeType = ser.startTimeType
		macro.startTimeValue = ser.startTimeValue
		macro.startTimeUnit = ser.startTimeUnit
		macro.startRoundsCompleted = ser.startRoundsCompleted
	end
	return macro
end

function loadPresets()
	local data = safeReadFile(CONFIG_FILE)
	if data then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, data)
		if success and typeof(decoded) == "table" then
			Presets = {}
			for name, arr in pairs(decoded) do
				Presets[name] = {}
				for i, ser in ipairs(arr) do
					Presets[name][i] = deserializeMacro(ser)
				end
			end
		end
	end
end

function savePresets()
	local toSave = {}
	for name, macros in pairs(Presets) do
		toSave[name] = {}
		for i, macro in ipairs(macros) do
			toSave[name][i] = serializeMacro(macro)
		end
	end
	local json = HttpService:JSONEncode(toSave)
	safeWriteFile(CONFIG_FILE, json)
end

loadPresets()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MacroManagerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui
ScreenGui.ScreenInsets = Enum.ScreenInsets.None
ScreenGui.DisplayOrder = 6
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0,420*DPI,0,520*DPI)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(25,25,35)
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = ScreenGui
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1,0,0,36*DPI)
TitleBar.BackgroundColor3 = Color3.fromRGB(30,30,45)
TitleBar.Parent = Main
TitleBar.Active = true
local Title = Instance.new("TextLabel")
Title.Name = "TitleLabel"
Title.Size = UDim2.new(1,-84,1,0)
Title.Position = UDim2.new(0,8,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Macro Manager"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16*DPI
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local ConfigBtn = Instance.new("TextButton")
ConfigBtn.Name = "ConfigButton"
ConfigBtn.Size = UDim2.new(0,28,0,28)
ConfigBtn.Position = UDim2.new(1,-68,0,4)
ConfigBtn.BackgroundColor3 = Color3.fromRGB(100,150,255)
ConfigBtn.Text = "🗂️"
ConfigBtn.TextColor3 = Color3.new(1,1,1)
ConfigBtn.Font = Enum.Font.GothamBold
ConfigBtn.TextSize = 16*DPI
ConfigBtn.Parent = TitleBar
Instance.new("UICorner",ConfigBtn).CornerRadius = UDim.new(0,6)

local Close = Instance.new("TextButton")
Close.Name = "CloseButton"
Close.Size = UDim2.new(0,28,0,28)
Close.Position = UDim2.new(1,-32,0,4)
Close.BackgroundColor3 = Color3.fromRGB(255,50,50)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14*DPI
Close.Parent = TitleBar
Instance.new("UICorner",Close).CornerRadius = UDim.new(0,6)

Close.MouseButton1Click:Connect(function()
	ScreenGui.Enabled = false
end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "MacroScroll"
Scroll.Size = UDim2.new(1,-16,1,-128)
Scroll.Position = UDim2.new(0,8,0,44)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 5
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout",Scroll)
Layout.Name = "MacroListLayout"
Layout.Padding = UDim.new(0,6)

local NoMacrosLabel = Instance.new("TextLabel")
NoMacrosLabel.Name = "NoMacrosLabel"
NoMacrosLabel.Size = UDim2.new(1,-32,1,-100)
NoMacrosLabel.Position = UDim2.new(0,16,0,50)
NoMacrosLabel.BackgroundTransparency = 1
NoMacrosLabel.Text = "No VIP Command macros available"
NoMacrosLabel.TextColor3 = Color3.fromRGB(150,150,150)
NoMacrosLabel.Font = Enum.Font.Gotham
NoMacrosLabel.TextSize = 16*DPI
NoMacrosLabel.TextWrapped = true
NoMacrosLabel.Visible = true
NoMacrosLabel.Parent = Main

local CreateBtn = Instance.new("TextButton")
CreateBtn.Name = "CreateButton"
CreateBtn.Size = UDim2.new(1,-16,0,36)
CreateBtn.Position = UDim2.new(0,8,1,-44)
CreateBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
CreateBtn.Text = "+ New Macro"
CreateBtn.TextColor3 = Color3.new(1,1,1)
CreateBtn.Font = Enum.Font.GothamBold
CreateBtn.TextSize = 15*DPI
CreateBtn.Parent = Main
Instance.new("UICorner",CreateBtn).CornerRadius = UDim.new(0,8)

local DelayUnits = {"Ms","Sec","Minute","Hour","Day","Week","Year"}

function toMs(v,u)
	local m = {Ms=1,Sec=1000,Minute=60000,Hour=3600000,Day=86400000,Week=604800000,Year=31536000000}
	return (v or 0) * (m[u] or 1)
end

local TimeUnits = {"Ms","Second","Minute","Hour","Day","Week","Month","Year"}

function toSeconds(v,u)
	local m = {Ms=0.001,Second=1,Minute=60,Hour=3600,Day=86400,Week=604800,Month=2629800,Year=31557600}
	return (v or 0) * (m[u] or 1)
end

function formatTimeRemaining(seconds)
	if seconds <= 0 then return "Done" end
	local years = math.floor(seconds/31557600); seconds %= 31557600
	local months = math.floor(seconds/2629800); seconds %= 2629800
	local weeks = math.floor(seconds/604800); seconds %= 604800
	local days = math.floor(seconds/86400); seconds %= 86400
	local hours = math.floor(seconds/3600); seconds %= 3600
	local mins = math.floor(seconds/60); seconds %= 60
	local parts = {}
	if years>0 then table.insert(parts,years.."y") end
	if months>0 then table.insert(parts,months.."mo") end
	if weeks>0 then table.insert(parts,weeks.."w") end
	if days>0 then table.insert(parts,days.."d") end
	if hours>0 then table.insert(parts,hours.."h") end
	if mins>0 then table.insert(parts,mins.."m") end
	if seconds > 0 and (#parts > 0 and seconds >= 1 or #parts == 0) then
		local sec_str = seconds < 1 and string.format("%.1fs", seconds) or math.floor(seconds) .. "s"
		table.insert(parts, sec_str)
	end
	return table.concat(parts," ")
end

local RoundTypes = {"Any","Round Start","Intermission"}
local TimeConditions = {"Any Time","Below","Above","At Certain Time"}
local RoundsCompletedOptions = {"1", "2", "3"}
local Macros = {}

function getRoundState()
	local gameFolder = workspace:FindFirstChild("Game")
	if gameFolder then
		local stats = gameFolder:FindFirstChild("Stats")
		if stats then
			local roundStarted = stats:GetAttribute("RoundStarted")
			if roundStarted ~= nil then
				return roundStarted and "Round Start" or "Intermission"
			end
		end
	end
	return nil
end

function getRoundsCompleted()
	local gameFolder = workspace:FindFirstChild("Game")
	if gameFolder then
		local stats = gameFolder:FindFirstChild("Stats")
		if stats then
			local rounds = stats:GetAttribute("RoundsCompleted")
			return typeof(rounds) == "number" and rounds or 0
		end
	end
	return 0
end

function updateNoMacrosLabel()
	NoMacrosLabel.Visible = #Macros == 0
end

function updateCanvas()
	task.defer(function()
		Scroll.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10)
	end)
end

local ConfirmPopup = nil

function showDeleteConfirm(data,idx,entryFrame)
	if ConfirmPopup then ConfirmPopup:Destroy() end
	ConfirmPopup = Instance.new("Frame")
	ConfirmPopup.Name = "DeleteConfirmPopup"
	ConfirmPopup.Size = UDim2.new(0,260*DPI,0,130*DPI)
	ConfirmPopup.Position = UDim2.new(0.5,0,0.5,0)
	ConfirmPopup.AnchorPoint = Vector2.new(0.5,0.5)
	ConfirmPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	ConfirmPopup.ZIndex = 20
	ConfirmPopup.Parent = ScreenGui
	Instance.new("UICorner",ConfirmPopup).CornerRadius = UDim.new(0,12)
	local msg = Instance.new("TextLabel")
	msg.Text = "Delete this macro?"
	msg.Size = UDim2.new(1,-20,0,50)
	msg.Position = UDim2.new(0,10,0,10)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1,1,1)
	msg.Font = Enum.Font.GothamBold
	msg.TextSize = 15*DPI
	msg.ZIndex = 21
	msg.Parent = ConfirmPopup
	local yes = Instance.new("TextButton")
	yes.Size = UDim2.new(0.45,0,0,32)
	yes.Position = UDim2.new(0.05,0,1,-40)
	yes.BackgroundColor3 = Color3.fromRGB(255,50,50)
	yes.Text = "Yes"
	yes.TextColor3 = Color3.new(1,1,1)
	yes.Font = Enum.Font.GothamBold
	yes.TextSize = 13*DPI
	yes.ZIndex = 21
	yes.Parent = ConfirmPopup
	Instance.new("UICorner",yes).CornerRadius = UDim.new(0,8)
	local no = Instance.new("TextButton")
	no.Size = UDim2.new(0.45,0,0,32)
	no.Position = UDim2.new(0.5,0,1,-40)
	no.BackgroundColor3 = Color3.fromRGB(100,100,100)
	no.Text = "No"
	no.TextColor3 = Color3.new(1,1,1)
	no.Font = Enum.Font.GothamBold
	no.TextSize = 13*DPI
	no.ZIndex = 21
	no.Parent = ConfirmPopup
	Instance.new("UICorner",no).CornerRadius = UDim.new(0,8)
	no.MouseButton1Click:Connect(function()
		ConfirmPopup:Destroy(); ConfirmPopup=nil
	end)
	yes.MouseButton1Click:Connect(function()
		if data.running and data.stopMacro then 
			data.stopMacro() 
		end
		entryFrame:Destroy()
		table.remove(Macros,idx)
		updateNoMacrosLabel()
		updateCanvas()
		ConfirmPopup:Destroy(); ConfirmPopup=nil
	end)
end

local MacroManager = {}
MacroManager.__index = MacroManager

function MacroManager.new(data)
	local self = setmetatable({}, MacroManager)
	
	self.data = data
	self.running = false
	self.pausedByCondition = false
	self.connections = {}
	self.startTime = nil
	self.cycleCount = nil
	self.maxCycles = nil
	self.nextRun = nil
	
	return self
end

function MacroManager:cleanupConnections()
	for i, conn in ipairs(self.connections) do
		if conn and conn.Connected then
			pcall(function() conn:Disconnect() end)
		end
		self.connections[i] = nil
	end
	self.connections = {}
end

function MacroManager:checkTimeCondition()
	if not self.data.startTimeType or self.data.startTimeType == "Any Time" then
		return true
	end
	local gameFolder = workspace:FindFirstChild("Game")
	if not gameFolder then return false end
	local stats = gameFolder:FindFirstChild("Stats")
	if not stats then return false end
	local timerValue = stats:GetAttribute("Timer")
	if not timerValue then return false end
	local targetTime = toSeconds(self.data.startTimeValue or 0, self.data.startTimeUnit or "Second")
	if self.data.startTimeType == "Below" then
		return timerValue < targetTime
	elseif self.data.startTimeType == "Above" then
		return timerValue > targetTime
	elseif self.data.startTimeType == "At Certain Time" then
		return math.abs(timerValue - targetTime) < 0.5
	end
	return false
end

function MacroManager:checkRoundCondition()
	if not self.data.startRoundType or self.data.startRoundType == "Any" then
		return true
	end
	local currentRoundState = getRoundState()
	return currentRoundState == self.data.startRoundType
end

function MacroManager:checkRoundsCompletedCondition()
	if not self.data.startRoundsCompleted or self.data.startRoundsCompleted == "Any" then
		return true
	end
	local required = tonumber(self.data.startRoundsCompleted)
	local actual = getRoundsCompleted()
	return actual >= required
end

function MacroManager:resumeFromPause()
	if self.pausedByCondition and self:checkRoundCondition() and self:checkTimeCondition() and self:checkRoundsCompletedCondition() then
		self.pausedByCondition = false
		if self.status then
			self.status.Text = "ON"
			self.status.TextColor3 = Color3.fromRGB(0,255,0)
		end
		if self.updateCountdown then self:updateCountdown() end
	end
end

function MacroManager:pauseDueToCondition()
	if self.running and not self.pausedByCondition then
		self.pausedByCondition = true
		if self.status then
			self.status.Text = "PAUSED"
			self.status.TextColor3 = Color3.fromRGB(255,150,50)
		end
		if self.updateCountdown then self:updateCountdown() end
	end
end

function MacroManager:monitorConditions()
	if not self.running then return end
	if self:checkRoundCondition() and self:checkTimeCondition() and self:checkRoundsCompletedCondition() then
		self:resumeFromPause()
	else
		self:pauseDueToCondition()
	end
end

function MacroManager:startCountdownUpdate()
	if self.countdownConn and self.countdownConn.Connected then 
		self.countdownConn:Disconnect() 
	end
	
	self.countdownConn = RunService.Heartbeat:Connect(function()
		if not self.running or not self.countdown then return end
		
		if not self.running then
			self.countdown.Text = "Ready"
			self.countdown.TextColor3 = Color3.fromRGB(255,200,100)
			if self.countdownConn and self.countdownConn.Connected then 
				self.countdownConn:Disconnect() 
			end
			return
		end
		
		local elapsed = tick() - self.startTime
		local delayMs = toMs(self.data.delayValue, self.data.delayUnit)
		local delaySec = delayMs / 1000
		local nextInSec = delaySec - ((tick() - self.startTime) % delaySec)
		
		if self.data.stopMode == "time" then
			local remaining = math.max(0, self.data.stopTime - elapsed)
			self.countdown.Text = self.pausedByCondition and "PAUSED (cond)" or formatTimeRemaining(remaining)
			self.countdown.TextColor3 = remaining<=0 and Color3.fromRGB(255,100,100) or (self.pausedByCondition and Color3.fromRGB(255,150,50) or Color3.fromRGB(100,255,100))
		elseif self.data.stopMode == "cycles" then
			local left = math.max(0, (self.maxCycles or 0) - self.cycleCount)
			self.countdown.Text = self.pausedByCondition and "PAUSED (cond)" or left.." cycle"..(left==1 and "" or "s").." left | "..formatTimeRemaining(nextInSec)
			self.countdown.TextColor3 = self.pausedByCondition and Color3.fromRGB(255,150,50) or Color3.fromRGB(100,255,100)
		else
			self.countdown.Text = self.pausedByCondition and "PAUSED (cond)" or formatTimeRemaining(nextInSec)
			self.countdown.TextColor3 = self.pausedByCondition and Color3.fromRGB(255,150,50) or Color3.fromRGB(100,255,100)
		end
	end)
	
	table.insert(self.connections, self.countdownConn)
end

function MacroManager:updateCountdown()
	if not self.countdown then return end
	
	if not self.running then
		self.countdown.Text = "Ready"
		self.countdown.TextColor3 = Color3.fromRGB(255,200,100)
		return
	end
	
	self:startCountdownUpdate()
end

function MacroManager:startMacro()
	if self.running then return end
	
	self.running = true
	self.pausedByCondition = false
	self.startTime = tick()
	self.cycleCount = 0
	self.maxCycles = (self.data.stopMode=="cycles") and self.data.stopCycles or nil
	self.nextRun = tick()
	
	local delayMs = toMs(self.data.delayValue, self.data.delayUnit)
	
	self:cleanupConnections()
	
	local mainConn = RunService.Heartbeat:Connect(function()
		if not self.running or self.pausedByCondition then return end
		
		local now = tick()
		if now >= self.nextRun then
			pcall(function()
				ReplicatedStorage.Events.Admin.VIPCommand:InvokeServer(self.data.command)
			end)
			self.cycleCount += 1
			self.nextRun = now + delayMs / 1000
		end
		
		if self.data.stopMode=="time" and (now - self.startTime >= self.data.stopTime) then 
			self:stopMacro()
			return 
		end
		if self.data.stopMode=="cycles" and self.cycleCount >= self.maxCycles then 
			self:stopMacro()
			return 
		end
	end)
	
	table.insert(self.connections, mainConn)
	
	if self.data.startCondition then
		local monitorConn = RunService.Heartbeat:Connect(function()
			self:monitorConditions()
		end)
		table.insert(self.connections, monitorConn)
	end
	
	local keyConn = UserInputService.InputBegan:Connect(function(inp, gp)
		if gp or inp.KeyCode ~= self.data.keybind then return end
		if self.running then
			self:stopMacro()
		else
			self:startMacro()
		end
	end)
	
	table.insert(self.connections, keyConn)
	
	if self.startBtn then
		self.startBtn.Text = "STOP"
		self.startBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
	end
	if self.status then
		self.status.Text = "ON"
		self.status.TextColor3 = Color3.fromRGB(0,255,0)
	end
	
	self:updateCountdown()
end

function MacroManager:stopMacro()
	self.running = false
	self.pausedByCondition = false
	
	self:cleanupConnections()
	
	if self.startBtn then
		self.startBtn.Text = "START"
		self.startBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
	end
	if self.status then
		self.status.Text = "OFF"
		self.status.TextColor3 = Color3.fromRGB(255,100,100)
	end
	if self.countdown then
		self.countdown.Text = "Ready"
		self.countdown.TextColor3 = Color3.fromRGB(255,200,100)
	end
end

function makeEntry(data, idx)
	local f = Instance.new("Frame")
	f.Name = "MacroEntry_" .. idx
	f.Size = UDim2.new(1, 0, 0, 180)
	f.BackgroundColor3 = Color3.fromRGB(35,35,50)
	f.ZIndex = 2
	f.Parent = Scroll
	Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)

	local name = Instance.new("TextLabel")
	name.Name = "MacroNameLabel"
	name.Size = UDim2.new(0.6,0,0,22)
	name.Position = UDim2.new(0,8,0,4)
	name.BackgroundTransparency = 1
	name.Text = data.name~="" and data.name or ("Macro "..idx)
	name.TextColor3 = Color3.new(1,1,1)
	name.Font = Enum.Font.GothamBold
	name.TextSize = 13*DPI
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.ZIndex = 3
	name.Parent = f

	local cmd = Instance.new("TextLabel")
	cmd.Name = "CommandLabel"
	cmd.Size = UDim2.new(1,-16,0,18)
	cmd.Position = UDim2.new(0,8,0,26)
	cmd.BackgroundTransparency = 1
	cmd.Text = data.command
	cmd.TextColor3 = Color3.fromRGB(180,180,180)
	cmd.Font = Enum.Font.Gotham
	cmd.TextSize = 11*DPI
	cmd.TextXAlignment = Enum.TextXAlignment.Left
	cmd.ZIndex = 3
	cmd.Parent = f

	local info = Instance.new("TextLabel")
	info.Name = "InfoLabel"
	info.Size = UDim2.new(1,-16,0,20)
	info.Position = UDim2.new(0,8,0,44)
	info.BackgroundTransparency = 1
	info.Text = string.format("Delay: %d %s | Key: %s", data.delayValue, data.delayUnit, (data.keybind and data.keybind.Name) or "F")
	info.TextColor3 = Color3.fromRGB(120,200,255)
	info.Font = Enum.Font.Gotham
	info.TextSize = 10*DPI
	info.TextXAlignment = Enum.TextXAlignment.Left
	info.ZIndex = 3
	info.Parent = f

	local startInfo = Instance.new("TextLabel")
	startInfo.Name = "StartInfoLabel"
	startInfo.Size = UDim2.new(1,-16,0,18)
	startInfo.Position = UDim2.new(0,8,0,66)
	startInfo.BackgroundTransparency = 1
	if data.startCondition then
		local startText = "Start: "
		if data.startRoundType and data.startRoundType ~= "Any" then
			startText = startText .. data.startRoundType
		end
		if data.startTimeType and data.startTimeType ~= "Any Time" then
			if startText ~= "Start: " then startText = startText .. ", " end
			startText = startText .. data.startTimeType .. " " .. (data.startTimeValue or "") .. " " .. (data.startTimeUnit or "")
		end
		if data.startRoundsCompleted and data.startRoundsCompleted ~= "Any" then
			if startText ~= "Start: " then startText = startText .. ", " end
			startText = startText .. "Rounds: " .. data.startRoundsCompleted
		end
		startInfo.Text = startText
	else
		startInfo.Text = "Start: Manual"
	end
	startInfo.TextColor3 = Color3.fromRGB(255,150,100)
	startInfo.Font = Enum.Font.Gotham
	startInfo.TextSize = 10*DPI
	startInfo.TextXAlignment = Enum.TextXAlignment.Left
	startInfo.ZIndex = 3
	startInfo.Parent = f

	local repeatLabel = Instance.new("TextLabel")
	repeatLabel.Name = "RepeatLabel"
	repeatLabel.Size = UDim2.new(1,-16,0,18)
	repeatLabel.Position = UDim2.new(0,8,0,86)
	repeatLabel.BackgroundTransparency = 1
	repeatLabel.Text = data.stopMode=="indefinitely" and "Run indefinitely"
		or data.stopMode=="time" and "Amount of time"
		or "Number of cycles"
	repeatLabel.TextColor3 = Color3.fromRGB(255,200,100)
	repeatLabel.Font = Enum.Font.Gotham
	repeatLabel.TextSize = 11*DPI
	repeatLabel.TextXAlignment = Enum.TextXAlignment.Left
	repeatLabel.ZIndex = 3
	repeatLabel.Parent = f

	local countdown = Instance.new("TextLabel")
	countdown.Name = "CountdownLabel"
	countdown.Size = UDim2.new(1,-16,0,18)
	countdown.Position = UDim2.new(0,8,0,104)
	countdown.BackgroundTransparency = 1
	countdown.Text = "Ready"
	countdown.TextColor3 = Color3.fromRGB(255,200,100)
	countdown.Font = Enum.Font.GothamBold
	countdown.TextSize = 12*DPI
	countdown.TextXAlignment = Enum.TextXAlignment.Left
	countdown.ZIndex = 3
	countdown.Parent = f

	local status = Instance.new("TextLabel")
	status.Name = "StatusLabel"
	status.Size = UDim2.new(0,70,0,18)
	status.Position = UDim2.new(1,-78,0,4)
	status.BackgroundTransparency = 1
	status.Text = "OFF"
	status.TextColor3 = Color3.fromRGB(255,100,100)
	status.Font = Enum.Font.GothamBold
	status.TextSize = 11*DPI
	status.ZIndex = 3
	status.Parent = f

	function btn(txt, col, x, name)
		local b = Instance.new("TextButton")
		b.Name = name.."Button"
		b.Size = UDim2.new(0,52,0,22)
		b.Position = UDim2.new(0,x,1,-31)
		b.BackgroundColor3 = col
		b.Text = txt
		b.TextColor3 = Color3.new(1,1,1)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 11*DPI
		b.ZIndex = 4
		b.Parent = f
		Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
		return b
	end

	local startBtn = btn("START", Color3.fromRGB(0,200,0), 8, "Start")
	local editBtn = btn("Edit", Color3.fromRGB(255,170,0), 68, "Edit")
	local dupBtn = btn("Dup", Color3.fromRGB(0,170,255), 128, "Duplicate")
	local delBtn = btn("Del", Color3.fromRGB(255,50,50), 188, "Delete")
	
	local manager = MacroManager.new(data)
	manager.startBtn = startBtn
	manager.status = status
	manager.countdown = countdown
	data.manager = manager
	
	startBtn.MouseButton1Click:Connect(function()
		if manager.running then
			manager:stopMacro()
		else
			manager:startMacro()
		end
	end)
	
	dupBtn.MouseButton1Click:Connect(function()
		local copy = table.clone(data)
		copy.name = (copy.name~="" and copy.name or "Macro").." (Copy)"
		table.insert(Macros, copy)
		makeEntry(copy, #Macros)
		updateNoMacrosLabel()
		updateCanvas()
	end)
	
	delBtn.MouseButton1Click:Connect(function() 
		showDeleteConfirm(data, idx, f) 
	end)
	
	editBtn.MouseButton1Click:Connect(function() 
		CmdEditMacro(data, idx, f) 
	end)
	
	data.entryFrame = f
	updateNoMacrosLabel()
	updateCanvas()
	
	return f
end

local Popup, activeDropdown, overlay = nil, nil, nil

function closeAllDropdowns()
	if activeDropdown then activeDropdown.Visible = false; activeDropdown = nil end
	if overlay then overlay:Destroy(); overlay = nil end
end

function createOverlay()
	if overlay then overlay:Destroy() end
	overlay = Instance.new("TextButton")
	overlay.Size = UDim2.new(1,0,1,0)
	overlay.BackgroundTransparency = 0.9
	overlay.BackgroundColor3 = Color3.new(0,0,0)
	overlay.Text = ""
	overlay.ZIndex = 14
	overlay.Parent = Popup
	overlay.MouseButton1Click:Connect(closeAllDropdowns)
end

function makeDropdown(btn, list, options, default, cb)
	btn.Text = default
	list.Visible = false
	list.ZIndex = 15
	for i, opt in ipairs(options) do
		local o = Instance.new("TextButton")
		o.Size = UDim2.new(1,0,0,28)
		o.Position = UDim2.new(0,0,0,(i-1)*28)
		o.BackgroundColor3 = Color3.fromRGB(50,50,70)
		o.Text = opt
		o.TextColor3 = Color3.new(1,1,1)
		o.Font = Enum.Font.Gotham
		o.TextSize = 13*DPI
		o.ZIndex = 16
		o.Parent = list
		Instance.new("UICorner", o).CornerRadius = UDim.new(0,6)
		o.MouseButton1Click:Connect(function()
			btn.Text = opt
			cb(opt)
			closeAllDropdowns()
		end)
	end
	btn.ZIndex = 11
	btn.MouseButton1Click:Connect(function()
		if activeDropdown == list then
			closeAllDropdowns()
		else
			closeAllDropdowns()
			list.Visible = true
			activeDropdown = list
			createOverlay()
		end
	end)
end

function CmdEditMacro(editData, oldIdx, oldFrame)
	if Popup then Popup:Destroy() end
	local isEdit = editData ~= nil
	local data = isEdit and table.clone(editData) or {
		name="", command="", delayValue=1, delayUnit="Ms",
		keybind=Enum.KeyCode.F, stopMode="indefinitely",
		stopTime=5, stopTimeUnit="Second", stopCycles=10,
		startCondition=false, startRoundType="Any", startTimeType="Any Time",
		startTimeValue=10, startTimeUnit="Second", startRoundsCompleted="Any"
	}

	Popup = Instance.new("Frame")
	Popup.Active = true
	Popup.Name = "EditMacroPopup"
	Popup.Size = UDim2.new(0,420*DPI,0,520*DPI)
	Popup.Position = UDim2.new(0.5,0,0.5,0)
	Popup.AnchorPoint = Vector2.new(0.5,0.5)
	Popup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	Popup.ZIndex = 10
	Popup.Parent = ScreenGui
	Instance.new("UICorner", Popup).CornerRadius = UDim.new(0,12)

	local pTitle = Instance.new("TextLabel")
	pTitle.Size = UDim2.new(1,0,0,36)
	pTitle.BackgroundColor3 = Color3.fromRGB(35,35,55)
	pTitle.Text = isEdit and "Edit Macro" or "New Macro"
	pTitle.TextColor3 = Color3.new(1,1,1)
	pTitle.Font = Enum.Font.GothamBold
	pTitle.TextSize = 16*DPI
	pTitle.ZIndex = 11
	pTitle.Parent = Popup
	Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0,12)

	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(1,-16,0,32)
	nameBox.Position = UDim2.new(0,8,0,44)
	nameBox.PlaceholderText = "Enter Name"
	nameBox.Text = data.name
	nameBox.BackgroundColor3 = Color3.fromRGB(40,40,55)
	nameBox.TextColor3 = Color3.new(1,1,1)
	nameBox.Font = Enum.Font.Gotham
	nameBox.TextSize = 13*DPI
	nameBox.ClearTextOnFocus = false
	nameBox.ZIndex = 11
	nameBox.Parent = Popup
	Instance.new("UICorner", nameBox)

	local cmdBox = Instance.new("TextBox")
	cmdBox.Size = UDim2.new(1,-16,0,32)
	cmdBox.Position = UDim2.new(0,8,0,82)
	cmdBox.PlaceholderText = "Enter command here, use ''!'' To execute a command"
	cmdBox.Text = data.command
	cmdBox.BackgroundColor3 = Color3.fromRGB(40,40,55)
	cmdBox.TextColor3 = Color3.new(1,1,1)
	cmdBox.Font = Enum.Font.Gotham
	cmdBox.TextSize = 13*DPI
	cmdBox.ClearTextOnFocus = false
	cmdBox.ZIndex = 11
	cmdBox.Parent = Popup
	Instance.new("UICorner", cmdBox)

	local delayVal = Instance.new("TextBox")
	delayVal.Size = UDim2.new(0,90,0,32)
	delayVal.Position = UDim2.new(0,8,0,120)
	delayVal.PlaceholderText = "Delay"
	delayVal.Text = tostring(data.delayValue or 1)
	delayVal.BackgroundColor3 = Color3.fromRGB(40,40,55)
	delayVal.TextColor3 = Color3.new(1,1,1)
	delayVal.Font = Enum.Font.Gotham
	delayVal.TextSize = 13*DPI
	delayVal.ClearTextOnFocus = false
	delayVal.ZIndex = 11
	delayVal.Parent = Popup
	Instance.new("UICorner", delayVal)

	local delayDrop = Instance.new("TextButton")
	delayDrop.Size = UDim2.new(0,90,0,32)
	delayDrop.Position = UDim2.new(0,106,0,120)
	delayDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	delayDrop.TextColor3 = Color3.new(1,1,1)
	delayDrop.Font = Enum.Font.GothamBold
	delayDrop.TextSize = 13*DPI
	delayDrop.Text = data.delayUnit or "Ms"
	delayDrop.ZIndex = 11
	delayDrop.Parent = Popup
	Instance.new("UICorner", delayDrop)

	local dropList = Instance.new("Frame")
	dropList.Size = UDim2.new(0,90,0,196)
	dropList.Position = UDim2.new(0,106,0,120)
	dropList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	dropList.Visible = false
	dropList.ZIndex = 15
	dropList.Parent = Popup
	Instance.new("UICorner", dropList)

	makeDropdown(delayDrop, dropList, DelayUnits, data.delayUnit or "Ms", function(u) data.delayUnit = u end)

	local keyBtn = Instance.new("TextButton")
	keyBtn.Size = UDim2.new(1,-16,0,32)
	keyBtn.Position = UDim2.new(0,8,0,162)
	keyBtn.Text = "Key: " .. (data.keybind and data.keybind.Name or "F")
	keyBtn.BackgroundColor3 = Color3.fromRGB(40,40,55)
	keyBtn.TextColor3 = Color3.new(1,1,1)
	keyBtn.Font = Enum.Font.Gotham
	keyBtn.TextSize = 13*DPI
	keyBtn.ZIndex = 11
	keyBtn.Parent = Popup
	Instance.new("UICorner", keyBtn)

	local waiting = false
	keyBtn.MouseButton1Click:Connect(function()
		if waiting then return end
		waiting = true
		keyBtn.Text = "Press any key..."
		local c = nil
		c = UserInputService.InputBegan:Connect(function(inp)
			if inp.KeyCode ~= Enum.KeyCode.Unknown then
				data.keybind = inp.KeyCode
				keyBtn.Text = "Key: " .. inp.KeyCode.Name
				waiting = false
				c:Disconnect()
			end
		end)
	end)

	local startWhenLabel = Instance.new("TextLabel")
	startWhenLabel.Size = UDim2.new(1,-16,0,24)
	startWhenLabel.Position = UDim2.new(0,8,0,200)
	startWhenLabel.BackgroundTransparency = 1
	startWhenLabel.Text = "Start when"
	startWhenLabel.TextColor3 = Color3.fromRGB(200,200,200)
	startWhenLabel.Font = Enum.Font.GothamBold
	startWhenLabel.TextSize = 14*DPI
	startWhenLabel.TextXAlignment = Enum.TextXAlignment.Left
	startWhenLabel.ZIndex = 11
	startWhenLabel.Parent = Popup

	local roundTypeLabel = Instance.new("TextLabel")
	roundTypeLabel.Size = UDim2.new(0.5,-4,0,20)
	roundTypeLabel.Position = UDim2.new(0,8,0,230)
	roundTypeLabel.BackgroundTransparency = 1
	roundTypeLabel.Text = "Round type"
	roundTypeLabel.TextColor3 = Color3.fromRGB(180,180,180)
	roundTypeLabel.Font = Enum.Font.Gotham
	roundTypeLabel.TextSize = 12*DPI
	roundTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
	roundTypeLabel.ZIndex = 11
	roundTypeLabel.Parent = Popup

	local roundTypeDrop = Instance.new("TextButton")
	roundTypeDrop.Size = UDim2.new(0.5,-12,0,28)
	roundTypeDrop.Position = UDim2.new(0,8,0,250)
	roundTypeDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	roundTypeDrop.TextColor3 = Color3.new(1,1,1)
	roundTypeDrop.Font = Enum.Font.GothamBold
	roundTypeDrop.TextSize = 12*DPI
	roundTypeDrop.Text = data.startRoundType or "Any"
	roundTypeDrop.ZIndex = 11
	roundTypeDrop.Parent = Popup
	Instance.new("UICorner", roundTypeDrop)

	local roundTypeList = Instance.new("Frame")
	roundTypeList.Size = UDim2.new(0.5,-12,0,84)
	roundTypeList.Position = UDim2.new(0,8,0,250)
	roundTypeList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	roundTypeList.Visible = false
	roundTypeList.ZIndex = 15
	roundTypeList.Parent = Popup
	Instance.new("UICorner", roundTypeList)

	makeDropdown(roundTypeDrop, roundTypeList, RoundTypes, data.startRoundType or "Any", function(u) data.startRoundType = u end)

	local timeTypeLabel = Instance.new("TextLabel")
	timeTypeLabel.Size = UDim2.new(0.5,-4,0,20)
	timeTypeLabel.Position = UDim2.new(0.5,4,0,230)
	timeTypeLabel.BackgroundTransparency = 1
	timeTypeLabel.Text = "Certain time"
	timeTypeLabel.TextColor3 = Color3.fromRGB(180,180,180)
	timeTypeLabel.Font = Enum.Font.Gotham
	timeTypeLabel.TextSize = 12*DPI
	timeTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
	timeTypeLabel.ZIndex = 11
	timeTypeLabel.Parent = Popup

	local timeTypeDrop = Instance.new("TextButton")
	timeTypeDrop.Size = UDim2.new(0.5,-12,0,28)
	timeTypeDrop.Position = UDim2.new(0.5,4,0,250)
	timeTypeDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	timeTypeDrop.TextColor3 = Color3.new(1,1,1)
	timeTypeDrop.Font = Enum.Font.GothamBold
	timeTypeDrop.TextSize = 12*DPI
	timeTypeDrop.Text = data.startTimeType or "Any Time"
	timeTypeDrop.ZIndex = 11
	timeTypeDrop.Parent = Popup
	Instance.new("UICorner", timeTypeDrop)

	local timeTypeList = Instance.new("Frame")
	timeTypeList.Size = UDim2.new(0.5,-12,0,112)
	timeTypeList.Position = UDim2.new(0.5,4,0,250)
	timeTypeList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	timeTypeList.Visible = false
	timeTypeList.ZIndex = 15
	timeTypeList.Parent = Popup
	Instance.new("UICorner", timeTypeList)

	makeDropdown(timeTypeDrop, timeTypeList, TimeConditions, data.startTimeType or "Any Time", function(u) data.startTimeType = u end)

	local timeValueLabel = Instance.new("TextLabel")
	timeValueLabel.Size = UDim2.new(0.3,-4,0,20)
	timeValueLabel.Position = UDim2.new(0.5,4,0,310)
	timeValueLabel.BackgroundTransparency = 1
	timeValueLabel.Text = "Enter time"
	timeValueLabel.TextColor3 = Color3.fromRGB(180,180,180)
	timeValueLabel.Font = Enum.Font.Gotham
	timeValueLabel.TextSize = 12*DPI
	timeValueLabel.TextXAlignment = Enum.TextXAlignment.Left
	timeValueLabel.Visible = false
	timeValueLabel.ZIndex = 11
	timeValueLabel.Parent = Popup

	local timeValueBox = Instance.new("TextBox")
	timeValueBox.Size = UDim2.new(0.3,-12,0,28)
	timeValueBox.Position = UDim2.new(0.5,4,0,330)
	timeValueBox.PlaceholderText = "Value"
	timeValueBox.Text = tostring(data.startTimeValue or 10)
	timeValueBox.BackgroundColor3 = Color3.fromRGB(40,40,55)
	timeValueBox.TextColor3 = Color3.new(1,1,1)
	timeValueBox.Font = Enum.Font.Gotham
	timeValueBox.TextSize = 13*DPI
	timeValueBox.ClearTextOnFocus = false
	timeValueBox.Visible = false
	timeValueBox.ZIndex = 11
	timeValueBox.Parent = Popup
	Instance.new("UICorner", timeValueBox)

	local timeUnitDrop = Instance.new("TextButton")
	timeUnitDrop.Size = UDim2.new(0.2,-8,0,28)
	timeUnitDrop.Position = UDim2.new(0.78,4,0,330)
	timeUnitDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	timeUnitDrop.TextColor3 = Color3.new(1,1,1)
	timeUnitDrop.Font = Enum.Font.GothamBold
	timeUnitDrop.TextSize = 12*DPI
	timeUnitDrop.Text = data.startTimeUnit or "Second"
	timeUnitDrop.Visible = false
	timeUnitDrop.ZIndex = 11
	timeUnitDrop.Parent = Popup
	Instance.new("UICorner", timeUnitDrop)

	local timeUnitList = Instance.new("Frame")
	timeUnitList.Size = UDim2.new(0.2,-8,0,196)
	timeUnitList.Position = UDim2.new(0.78,4,0,130)
	timeUnitList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	timeUnitList.Visible = false
	timeUnitList.ZIndex = 15
	timeUnitList.Parent = Popup
	Instance.new("UICorner", timeUnitList)

	makeDropdown(timeUnitDrop, timeUnitList, TimeUnits, data.startTimeUnit or "Second", function(u) data.startTimeUnit = u end)

	local roundsCompletedLabel = Instance.new("TextLabel")
	roundsCompletedLabel.Size = UDim2.new(0.5,-4,0,20)
	roundsCompletedLabel.Position = UDim2.new(0,8,0,280)
	roundsCompletedLabel.BackgroundTransparency = 1
	roundsCompletedLabel.Text = "Rounds Completed"
	roundsCompletedLabel.TextColor3 = Color3.fromRGB(180,180,180)
	roundsCompletedLabel.Font = Enum.Font.Gotham
	roundsCompletedLabel.TextSize = 12*DPI
	roundsCompletedLabel.TextXAlignment = Enum.TextXAlignment.Left
	roundsCompletedLabel.ZIndex = 11
	roundsCompletedLabel.Parent = Popup

	local roundsCompletedDrop = Instance.new("TextButton")
	roundsCompletedDrop.Size = UDim2.new(0.5,-12,0,28)
	roundsCompletedDrop.Position = UDim2.new(0,8,0,300)
	roundsCompletedDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	roundsCompletedDrop.TextColor3 = Color3.new(1,1,1)
	roundsCompletedDrop.Font = Enum.Font.GothamBold
	roundsCompletedDrop.TextSize = 12*DPI
	roundsCompletedDrop.Text = data.startRoundsCompleted or "Any"
	roundsCompletedDrop.ZIndex = 11
	roundsCompletedDrop.Parent = Popup
	Instance.new("UICorner", roundsCompletedDrop)

	local roundsCompletedList = Instance.new("Frame")
	roundsCompletedList.Size = UDim2.new(0.5,-12,0,112)
	roundsCompletedList.Position = UDim2.new(0,8,0,299)
	roundsCompletedList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	roundsCompletedList.Visible = false
	roundsCompletedList.ZIndex = 15
	roundsCompletedList.Parent = Popup
	Instance.new("UICorner", roundsCompletedList)

	makeDropdown(roundsCompletedDrop, roundsCompletedList, {"Any","1","2","3"}, data.startRoundsCompleted or "Any", function(u) data.startRoundsCompleted = u end)

	function updateTimeFields()
		local showTimeFields = data.startTimeType and data.startTimeType ~= "Any Time"
		timeValueLabel.Visible = showTimeFields
		timeValueBox.Visible = showTimeFields
		timeUnitDrop.Visible = showTimeFields
	end

	timeTypeDrop:GetPropertyChangedSignal("Text"):Connect(function()
		data.startTimeType = timeTypeDrop.Text
		updateTimeFields()
	end)

	updateTimeFields()

	local stopAfterLabel = Instance.new("TextLabel")
	stopAfterLabel.Size = UDim2.new(1,-16,0,24)
	stopAfterLabel.Position = UDim2.new(0,8,0,330)
	stopAfterLabel.BackgroundTransparency = 1
	stopAfterLabel.Text = "Stop after"
	stopAfterLabel.TextColor3 = Color3.fromRGB(200,200,200)
	stopAfterLabel.Font = Enum.Font.GothamBold
	stopAfterLabel.TextSize = 14*DPI
	stopAfterLabel.TextXAlignment = Enum.TextXAlignment.Left
	stopAfterLabel.ZIndex = 11
	stopAfterLabel.Parent = Popup

	local radioRows = {}

	function updateRadios()
		for _, row in ipairs(radioRows) do
			local radio = row:FindFirstChild("RadioBtn")
			local bg = row:FindFirstChild("CircleBg")
			local mode = row:FindFirstChild("Mode")
			if radio and bg and mode then
				local sel = mode.Value == data.stopMode
				radio.Text = sel and FILLED or OPEN
				bg.BackgroundColor3 = sel and Color3.fromRGB(0,200,0) or Color3.fromRGB(70,70,70)
			end
		end
	end

	function makeRadio(y, txt, mode)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1,-16,0,32)
		row.Position = UDim2.new(0,8,0,y)
		row.BackgroundTransparency = 1
		row.ZIndex = 11
		row.Parent = Popup
		local bg = Instance.new("Frame")
		bg.Name = "CircleBg"
		bg.Size = UDim2.new(0,28,0,28)
		bg.Position = UDim2.new(0,0,0,2)
		bg.BackgroundColor3 = data.stopMode==mode and Color3.fromRGB(0,200,0) or Color3.fromRGB(70,70,70)
		bg.ZIndex = 11
		bg.Parent = row
		Instance.new("UICorner", bg).CornerRadius = UDim.new(0,14)
		local radio = Instance.new("TextButton")
		radio.Name = "RadioBtn"
		radio.Size = UDim2.new(0,28,0,28)
		radio.Position = UDim2.new(0,0,0,2)
		radio.BackgroundTransparency = 1
		radio.Text = data.stopMode==mode and FILLED or OPEN
		radio.TextColor3 = Color3.new(1,1,1)
		radio.Font = Enum.Font.Code
		radio.TextSize = 22*DPI
		radio.ZIndex = 12
		radio.Parent = row
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,-36,1,0)
		lbl.Position = UDim2.new(0,36,0,0)
		lbl.BackgroundTransparency = 1
		lbl.Text = txt
		lbl.TextColor3 = Color3.new(1,1,1)
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 13*DPI
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.ZIndex = 11
		lbl.Parent = row
		radio.MouseButton1Click:Connect(function()
			data.stopMode = mode
			updateRadios()
		end)
		local modeVal = Instance.new("StringValue")
		modeVal.Name = "Mode"
		modeVal.Value = mode
		modeVal.Parent = row
		table.insert(radioRows, row)
		return row
	end

	local timeRow = makeRadio(360, "Amount of time", "time")
	local cycleRow = makeRadio(400, "Number of cycles", "cycles")
	makeRadio(440, "Run indefinitely", "indefinitely")

	local timeInput = Instance.new("TextBox")
	timeInput.Size = UDim2.new(0,70,0,28)
	timeInput.Position = UDim2.new(0,130,0,2)
	timeInput.BackgroundColor3 = Color3.fromRGB(40,40,55)
	timeInput.TextColor3 = Color3.new(1,1,1)
	timeInput.Font = Enum.Font.Gotham
	timeInput.TextSize = 13*DPI
	if data.stopMode=="time" and data.stopTime then
		local unit = data.stopTimeUnit or "Second"
		local val = data.stopTime / toSeconds(1,unit)
		timeInput.Text = tostring(math.floor(val+0.5))
	else
		timeInput.Text = "5"
		timeInput.PlaceholderText = "Time value"
	end
	timeInput.ClearTextOnFocus = false
	timeInput.ZIndex = 11
	timeInput.Parent = timeRow
	Instance.new("UICorner", timeInput)

	local timeDrop = Instance.new("TextButton")
	timeDrop.Size = UDim2.new(0,70,0,28)
	timeDrop.Position = UDim2.new(0,208,0,2)
	timeDrop.BackgroundColor3 = Color3.fromRGB(50,50,70)
	timeDrop.TextColor3 = Color3.new(1,1,1)
	timeDrop.Font = Enum.Font.GothamBold
	timeDrop.TextSize = 13*DPI
	timeDrop.Text = data.stopTimeUnit or "Second"
	timeDrop.ZIndex = 11
	timeDrop.Parent = timeRow
	Instance.new("UICorner", timeDrop)

	local tList = Instance.new("Frame")
	tList.Size = UDim2.new(0,70,0,224)
	tList.Position = UDim2.new(0,208,0,-190)
	tList.BackgroundColor3 = Color3.fromRGB(40,40,55)
	tList.Visible = false
	tList.ZIndex = 15
	tList.Parent = timeRow
	Instance.new("UICorner", tList)

	makeDropdown(timeDrop, tList, TimeUnits, data.stopTimeUnit or "Second", function(u) data.stopTimeUnit = u end)

	local cycleInput = Instance.new("TextBox")
	cycleInput.Size = UDim2.new(0,100,0,28)
	cycleInput.Position = UDim2.new(0,150,0,2)
	cycleInput.BackgroundColor3 = Color3.fromRGB(40,40,55)
	cycleInput.TextColor3 = Color3.new(1,1,1)
	cycleInput.Font = Enum.Font.Gotham
	cycleInput.TextSize = 13*DPI
	cycleInput.Text = tostring(data.stopCycles or 10)
	cycleInput.ClearTextOnFocus = false
	cycleInput.ZIndex = 11
	cycleInput.Parent = cycleRow
	Instance.new("UICorner", cycleInput)

	local save = Instance.new("TextButton")
	save.Size = UDim2.new(0.5,-12,0,36)
	save.Position = UDim2.new(0,8,1,-44)
	save.BackgroundColor3 = Color3.fromRGB(0,200,0)
	save.Text = isEdit and "Update" or "Create"
	save.TextColor3 = Color3.new(1,1,1)
	save.Font = Enum.Font.GothamBold
	save.TextSize = 15*DPI
	save.ZIndex = 11
	save.Parent = Popup
	Instance.new("UICorner", save)

	local cancel = Instance.new("TextButton")
	cancel.Size = UDim2.new(0.5,-12,0,36)
	cancel.Position = UDim2.new(0.5,4,1,-44)
	cancel.BackgroundColor3 = Color3.fromRGB(150,150,150)
	cancel.Text = "Cancel"
	cancel.TextColor3 = Color3.new(1,1,1)
	cancel.Font = Enum.Font.GothamBold
	cancel.TextSize = 15*DPI
	cancel.ZIndex = 11
	cancel.Parent = Popup
	Instance.new("UICorner", cancel)

	cancel.MouseButton1Click:Connect(function()
		closeAllDropdowns()
		Popup:Destroy(); Popup=nil
	end)

	function updateSaveBtn()
		local hasCmd = cmdBox.Text:match("^%s*(.-)%s*$") ~= ""
		save.BackgroundColor3 = hasCmd and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
		save.TextColor3 = hasCmd and Color3.new(1,1,1) or Color3.fromRGB(180,180,180)
	end

	cmdBox:GetPropertyChangedSignal("Text"):Connect(updateSaveBtn)
	updateSaveBtn()

	save.MouseButton1Click:Connect(function()
		local cmd = cmdBox.Text:match("^%s*(.-)%s*$")
		if cmd == "" then return end
		local name = nameBox.Text ~= "" and nameBox.Text or "Macro"
		local dVal = tonumber(delayVal.Text) or 1
		local newData = {
			name = name,
			command = cmd,
			delayValue = dVal,
			delayUnit = delayDrop.Text,
			keybind = data.keybind,
			stopMode = data.stopMode,
			stopTime = nil,
			stopTimeUnit = nil,
			stopCycles = nil,
			startCondition = (roundTypeDrop.Text ~= "Any" or timeTypeDrop.Text ~= "Any Time" or roundsCompletedDrop.Text ~= "Any"),
			startRoundType = roundTypeDrop.Text,
			startTimeType = timeTypeDrop.Text,
			startTimeValue = tonumber(timeValueBox.Text) or 10,
			startTimeUnit = timeUnitDrop.Text,
			startRoundsCompleted = roundsCompletedDrop.Text
		}
		if data.stopMode == "time" then
			local val = tonumber(timeInput.Text) or 5
			local unit = timeDrop.Text
			newData.stopTime = toSeconds(val, unit)
			newData.stopTimeUnit = unit
		elseif data.stopMode == "cycles" then
			newData.stopCycles = tonumber(cycleInput.Text) or 10
		end
		if isEdit then
			if editData.manager and editData.manager.running then 
				editData.manager:stopMacro() 
			end
			oldFrame:Destroy()
			table.remove(Macros, oldIdx)
		end
		table.insert(Macros, newData)
		makeEntry(newData, #Macros)
		updateNoMacrosLabel()
		updateCanvas()
		closeAllDropdowns()
		Popup:Destroy(); Popup=nil
	end)

	updateRadios()

	local cam = workspace.CurrentCamera
	local scale = math.min(1, cam.ViewportSize.X*0.78/(420*DPI), cam.ViewportSize.Y*0.78/(520*DPI))
	Instance.new("UIScale", Popup).Scale = scale
end

ConfigPopup = nil
ConfigScroll = nil
PresetConfirmPopup = nil
SaveAsPopup = nil
selectedPresetRow = nil

function highlightPresetRow(row, selected)
	if selected then
		row.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	else
		row.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	end
end

function showPresetDeleteConfirm(presetName, row)
	if PresetConfirmPopup then PresetConfirmPopup:Destroy() end
	PresetConfirmPopup = Instance.new("Frame")
	PresetConfirmPopup.Name = "PresetDeleteConfirm"
	PresetConfirmPopup.Size = UDim2.new(0,260*DPI,0,130*DPI)
	PresetConfirmPopup.Position = UDim2.new(0.5,0,0.5,0)
	PresetConfirmPopup.AnchorPoint = Vector2.new(0.5,0.5)
	PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	PresetConfirmPopup.ZIndex = 40
	PresetConfirmPopup.Parent = ScreenGui
	Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0,12)
	local msg = Instance.new("TextLabel")
	msg.Text = "Delete preset '" .. presetName .. "'?"
	msg.Size = UDim2.new(1,-20,0,50)
	msg.Position = UDim2.new(0,10,0,10)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1,1,1)
	msg.Font = Enum.Font.GothamBold
	msg.TextSize = 15*DPI
	msg.TextWrapped = true
	msg.ZIndex = 41
	msg.Parent = PresetConfirmPopup
	local yes = Instance.new("TextButton")
	yes.Size = UDim2.new(0.45,0,0,32)
	yes.Position = UDim2.new(0.05,0,1,-40)
	yes.BackgroundColor3 = Color3.fromRGB(255,50,50)
	yes.Text = "Yes"
	yes.TextColor3 = Color3.new(1,1,1)
	yes.Font = Enum.Font.GothamBold
	yes.TextSize = 13*DPI
	yes.ZIndex = 41
	yes.Parent = PresetConfirmPopup
	Instance.new("UICorner", yes).CornerRadius = UDim.new(0,8)
	local no = Instance.new("TextButton")
	no.Size = UDim2.new(0.45,0,0,32)
	no.Position = UDim2.new(0.5,0,1,-40)
	no.BackgroundColor3 = Color3.fromRGB(100,100,100)
	no.Text = "No"
	no.TextColor3 = Color3.new(1,1,1)
	no.Font = Enum.Font.GothamBold
	no.TextSize = 13*DPI
	no.ZIndex = 41
	no.Parent = PresetConfirmPopup
	Instance.new("UICorner", no).CornerRadius = UDim.new(0,8)
	no.MouseButton1Click:Connect(function()
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
	end)
	yes.MouseButton1Click:Connect(function()
		Presets[presetName] = nil
		savePresets()
		row:Destroy()
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
	end)
end

function showPresetLoadConfirm(presetName, presetData)
	if PresetConfirmPopup then PresetConfirmPopup:Destroy() end
	PresetConfirmPopup = Instance.new("Frame")
	PresetConfirmPopup.Name = "PresetLoadConfirm"
	PresetConfirmPopup.Size = UDim2.new(0,260*DPI,0,130*DPI)
	PresetConfirmPopup.Position = UDim2.new(0.5,0,0.5,0)
	PresetConfirmPopup.AnchorPoint = Vector2.new(0.5,0.5)
	PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	PresetConfirmPopup.ZIndex = 40
	PresetConfirmPopup.Parent = ScreenGui
	Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0,12)
	local msg = Instance.new("TextLabel")
	msg.Text = "Loading '" .. presetName .. "' will replace current macros. Continue?"
	msg.Size = UDim2.new(1,-20,0,50)
	msg.Position = UDim2.new(0,10,0,10)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1,1,1)
	msg.Font = Enum.Font.GothamBold
	msg.TextSize = 15*DPI
	msg.TextWrapped = true
	msg.ZIndex = 41
	msg.Parent = PresetConfirmPopup
	local yes = Instance.new("TextButton")
	yes.Size = UDim2.new(0.45,0,0,32)
	yes.Position = UDim2.new(0.05,0,1,-40)
	yes.BackgroundColor3 = Color3.fromRGB(0,170,255)
	yes.Text = "Yes"
	yes.TextColor3 = Color3.new(1,1,1)
	yes.Font = Enum.Font.GothamBold
	yes.TextSize = 13*DPI
	yes.ZIndex = 41
	yes.Parent = PresetConfirmPopup
	Instance.new("UICorner", yes).CornerRadius = UDim.new(0,8)
	local no = Instance.new("TextButton")
	no.Size = UDim2.new(0.45,0,0,32)
	no.Position = UDim2.new(0.5,0,1,-40)
	no.BackgroundColor3 = Color3.fromRGB(100,100,100)
	no.Text = "No"
	no.TextColor3 = Color3.new(1,1,1)
	no.Font = Enum.Font.GothamBold
	no.TextSize = 13*DPI
	no.ZIndex = 41
	no.Parent = PresetConfirmPopup
	Instance.new("UICorner", no).CornerRadius = UDim.new(0,8)
	no.MouseButton1Click:Connect(function()
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
	end)
	yes.MouseButton1Click:Connect(function()
		for _, macro in ipairs(Macros) do
			if macro.manager and macro.manager.running then
				macro.manager:stopMacro()
			end
		end
		
		Macros = {}
		for i, m in ipairs(presetData) do
			Macros[i] = table.clone(m)
		end
		
		for _, c in ipairs(Scroll:GetChildren()) do
			if c:IsA("Frame") and c.Name:match("^MacroEntry_") then c:Destroy() end
		end
		
		for i, m in ipairs(Macros) do 
			makeEntry(m, i) 
		end
		
		updateNoMacrosLabel()
		updateCanvas()
		if ConfigPopup then ConfigPopup:Destroy(); ConfigPopup = nil end
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
	end)
end

function showPresetSaveConflict(presetName, input, saveBtn, defaultName)
	if PresetConfirmPopup then PresetConfirmPopup:Destroy() end
	PresetConfirmPopup = Instance.new("Frame")
	PresetConfirmPopup.Name = "PresetSaveConflict"
	PresetConfirmPopup.Active = true
	PresetConfirmPopup.Size = UDim2.new(0,280*DPI,0,150*DPI)
	PresetConfirmPopup.Position = UDim2.new(0.5,0,0.5,0)
	PresetConfirmPopup.AnchorPoint = Vector2.new(0.5,0.5)
	PresetConfirmPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	PresetConfirmPopup.ZIndex = 50
	PresetConfirmPopup.Parent = ScreenGui
	Instance.new("UICorner", PresetConfirmPopup).CornerRadius = UDim.new(0,12)
	local msg = Instance.new("TextLabel")
	msg.Text = "Preset '" .. presetName .. "' already exists."
	msg.Size = UDim2.new(1,-20,0,40)
	msg.Position = UDim2.new(0,10,0,10)
	msg.BackgroundTransparency = 1
	msg.TextColor3 = Color3.new(1,1,1)
	msg.Font = Enum.Font.GothamBold
	msg.TextSize = 15*DPI
	msg.TextWrapped = true
	msg.ZIndex = 51
	msg.Parent = PresetConfirmPopup
	local replace = Instance.new("TextButton")
	replace.Size = UDim2.new(0.3,0,0,32)
	replace.Position = UDim2.new(0.05,0,1,-40)
	replace.BackgroundColor3 = Color3.fromRGB(255,170,0)
	replace.Text = "Replace"
	replace.TextColor3 = Color3.new(1,1,1)
	replace.Font = Enum.Font.GothamBold
	replace.TextSize = 13*DPI
	replace.ZIndex = 51
	replace.Parent = PresetConfirmPopup
	Instance.new("UICorner", replace).CornerRadius = UDim.new(0,8)
	local rename = Instance.new("TextButton")
	rename.Size = UDim2.new(0.35,0,0,32)
	rename.Position = UDim2.new(0.36,0,1,-40)
	rename.BackgroundColor3 = Color3.fromRGB(0,170,255)
	rename.Text = "Rename"
	rename.TextColor3 = Color3.new(1,1,1)
	rename.Font = Enum.Font.GothamBold
	rename.TextSize = 13*DPI
	rename.ZIndex = 51
	rename.Parent = PresetConfirmPopup
	Instance.new("UICorner", rename).CornerRadius = UDim.new(0,8)
	local cancel = Instance.new("TextButton")
	cancel.Size = UDim2.new(0.3,0,0,32)
	cancel.Position = UDim2.new(0.719,0,1,-40)
	cancel.BackgroundColor3 = Color3.fromRGB(100,100,100)
	cancel.Text = "Cancel"
	cancel.TextColor3 = Color3.new(1,1,1)
	cancel.Font = Enum.Font.GothamBold
	cancel.TextSize = 13*DPI
	cancel.ZIndex = 51
	cancel.Parent = PresetConfirmPopup
	Instance.new("UICorner", cancel).CornerRadius = UDim.new(0,8)
	cancel.MouseButton1Click:Connect(function()
		input:Destroy()
		saveBtn:Destroy()
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
	end)
	function performSave(finalName)
		Presets[finalName] = {}
		for i, macro in ipairs(Macros) do
			Presets[finalName][i] = table.clone(macro)
			Presets[finalName][i].manager = nil
		end
		savePresets()
		input:Destroy()
		saveBtn:Destroy()
		PresetConfirmPopup:Destroy(); PresetConfirmPopup=nil
		openConfigPopup()
	end
	replace.MouseButton1Click:Connect(function()
		performSave(presetName)
	end)
	rename.MouseButton1Click:Connect(function()
		local newName = presetName
		local i = 1
		while Presets[newName] do
			newName = presetName .. " (" .. i .. ")"
			i += 1
		end
		performSave(newName)
	end)
end

function showSaveAsPopup()
	if SaveAsPopup then SaveAsPopup:Destroy() end
	if ConfigPopup then ConfigPopup:Destroy() end
	selectedPresetRow = nil
	local defaultName = "Preset " .. os.date("%H-%M-%S")
	SaveAsPopup = Instance.new("Frame")
	SaveAsPopup.Name = "SaveAsPopup"
	SaveAsPopup.Active = true
	SaveAsPopup.Size = UDim2.new(0,320*DPI,0,400*DPI)
	SaveAsPopup.Position = UDim2.new(0.5,0,0.5,0)
	SaveAsPopup.AnchorPoint = Vector2.new(0.5,0.5)
	SaveAsPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	SaveAsPopup.ZIndex = 30
	SaveAsPopup.Parent = ScreenGui
	Instance.new("UICorner", SaveAsPopup).CornerRadius = UDim.new(0,12)
	local pTitle = Instance.new("TextLabel")
	pTitle.Size = UDim2.new(1,0,0,36)
	pTitle.BackgroundColor3 = Color3.fromRGB(35,35,55)
	pTitle.Text = "Save As"
	pTitle.TextColor3 = Color3.new(1,1,1)
	pTitle.Font = Enum.Font.GothamBold
	pTitle.TextSize = 16*DPI
	pTitle.ZIndex = 31
	pTitle.Parent = SaveAsPopup
	Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0,12)
	local existingScroll = Instance.new("ScrollingFrame")
	existingScroll.Name = "ExistingPresetsScroll"
	existingScroll.Size = UDim2.new(1,-16,0,200)
	existingScroll.Position = UDim2.new(0,8,0,44)
	existingScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	existingScroll.BackgroundTransparency = 1
	existingScroll.ScrollBarThickness = 5
	existingScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	existingScroll.ZIndex = 31
	existingScroll.Parent = SaveAsPopup
	local existingLayout = Instance.new("UIListLayout", existingScroll)
	existingLayout.Padding = UDim.new(0,6)
	local input = nil
	for presetName, _ in pairs(Presets) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1,0,0,30)
		row.BackgroundColor3 = Color3.fromRGB(40,40,55)
		row.ZIndex = 32
		row.Parent = existingScroll
		Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
		local label = Instance.new("TextButton")
		label.Text = presetName
		label.Size = UDim2.new(1,-16,1,0)
		label.Position = UDim2.new(0,8,0,0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 13*DPI
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 33
		label.Parent = row
		label.MouseButton1Click:Connect(function()
			if selectedPresetRow then
				highlightPresetRow(selectedPresetRow, false)
			end
			selectedPresetRow = row
			highlightPresetRow(row, true)
			if input then
				input.Text = presetName
			end
		end)
	end
	local inputLabel = Instance.new("TextLabel")
	inputLabel.Text = "Enter preset name"
	inputLabel.Size = UDim2.new(1,-16,0,24)
	inputLabel.Position = UDim2.new(0,8,0,260)
	inputLabel.BackgroundTransparency = 1
	inputLabel.TextColor3 = Color3.fromRGB(200,200,200)
	inputLabel.Font = Enum.Font.Gotham
	inputLabel.TextSize = 14*DPI
	inputLabel.ZIndex = 31
	inputLabel.Parent = SaveAsPopup
	input = Instance.new("TextBox")
	input.Text = ""
	input.ClearTextOnFocus = false
	input.PlaceholderText = defaultName
	input.Size = UDim2.new(1,-16,0,32)
	input.Position = UDim2.new(0,8,0,284)
	input.BackgroundColor3 = Color3.fromRGB(50,50,70)
	input.TextColor3 = Color3.new(1,1,1)
	input.Font = Enum.Font.Gotham
	input.TextSize = 13*DPI
	input.ZIndex = 31
	input.Parent = SaveAsPopup
	Instance.new("UICorner", input).CornerRadius = UDim.new(0,8)
	local saveBtn = Instance.new("TextButton")
	saveBtn.Size = UDim2.new(0.5,-12,0,36)
	saveBtn.Position = UDim2.new(0,8,1,-44)
	saveBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
	saveBtn.Text = "Save"
	saveBtn.TextColor3 = Color3.new(1,1,1)
	saveBtn.Font = Enum.Font.GothamBold
	saveBtn.TextSize = 15*DPI
	saveBtn.ZIndex = 31
	saveBtn.Parent = SaveAsPopup
	Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,8)
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Size = UDim2.new(0.5,-12,0,36)
	cancelBtn.Position = UDim2.new(0.5,4,1,-44)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
	cancelBtn.Text = "Cancel"
	cancelBtn.TextColor3 = Color3.new(1,1,1)
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.TextSize = 15*DPI
	cancelBtn.ZIndex = 31
	cancelBtn.Parent = SaveAsPopup
	Instance.new("UICorner", cancelBtn).CornerRadius = UDim.new(0,8)
	cancelBtn.MouseButton1Click:Connect(function()
		SaveAsPopup:Destroy(); SaveAsPopup = nil
		openConfigPopup()
	end)
	saveBtn.MouseButton1Click:Connect(function()
		local presetName = input.Text:match("^%s*(.-)%s*$")
		if presetName == "" then presetName = defaultName end
		if Presets[presetName] then
			showPresetSaveConflict(presetName, input, saveBtn, defaultName)
		else
			Presets[presetName] = {}
			for i, macro in ipairs(Macros) do
				Presets[presetName][i] = table.clone(macro)
				Presets[presetName][i].manager = nil
			end
			savePresets()
			SaveAsPopup:Destroy(); SaveAsPopup = nil
			openConfigPopup()
		end
	end)
	local cam = workspace.CurrentCamera
	local scale = math.min(1, cam.ViewportSize.X*0.78/(360*DPI), cam.ViewportSize.Y*0.78/(400*DPI))
	Instance.new("UIScale", SaveAsPopup).Scale = scale
end

function openConfigPopup()
	if ConfigPopup then ConfigPopup:Destroy() end
	ConfigPopup = Instance.new("Frame")
	ConfigPopup.Active = true
	ConfigPopup.Size = UDim2.new(0,320*DPI,0,400*DPI)
	ConfigPopup.Position = UDim2.new(0.5,0,0.5,0)
	ConfigPopup.AnchorPoint = Vector2.new(0.5,0.5)
	ConfigPopup.BackgroundColor3 = Color3.fromRGB(30,30,40)
	ConfigPopup.ZIndex = 30
	ConfigPopup.Parent = ScreenGui
	Instance.new("UICorner", ConfigPopup).CornerRadius = UDim.new(0,12)
	local pTitle = Instance.new("TextLabel")
	pTitle.Size = UDim2.new(1,0,0,36)
	pTitle.BackgroundColor3 = Color3.fromRGB(35,35,55)
	pTitle.Text = "Macro Presets"
	pTitle.TextColor3 = Color3.new(1,1,1)
	pTitle.Font = Enum.Font.GothamBold
	pTitle.TextSize = 16*DPI
	pTitle.ZIndex = 31
	pTitle.Parent = ConfigPopup
	Instance.new("UICorner", pTitle).CornerRadius = UDim.new(0,12)
	ConfigScroll = Instance.new("ScrollingFrame")
	ConfigScroll.Size = UDim2.new(1,-16,1,-88)
	ConfigScroll.Position = UDim2.new(0,8,0,44)
	ConfigScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	ConfigScroll.BackgroundTransparency = 1
	ConfigScroll.ScrollBarThickness = 5
	ConfigScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ConfigScroll.ZIndex = 31
	ConfigScroll.Parent = ConfigPopup
	local cfgLayout = Instance.new("UIListLayout", ConfigScroll)
	cfgLayout.Padding = UDim.new(0,6)
	local saveAsBtn = Instance.new("TextButton")
	saveAsBtn.Size = UDim2.new(0.5,-12,0,36)
	saveAsBtn.Position = UDim2.new(0,8,1,-44)
	saveAsBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	saveAsBtn.Text = "Save As"
	saveAsBtn.TextColor3 = Color3.new(1,1,1)
	saveAsBtn.Font = Enum.Font.GothamBold
	saveAsBtn.TextSize = 15*DPI
	saveAsBtn.ZIndex = 31
	saveAsBtn.Parent = ConfigPopup
	Instance.new("UICorner", saveAsBtn).CornerRadius = UDim.new(0,8)
	local closeCfgBtn = Instance.new("TextButton")
	closeCfgBtn.Size = UDim2.new(0.5,-12,0,36)
	closeCfgBtn.Position = UDim2.new(0.5,4,1,-44)
	closeCfgBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
	closeCfgBtn.Text = "Close"
	closeCfgBtn.TextColor3 = Color3.new(1,1,1)
	closeCfgBtn.Font = Enum.Font.GothamBold
	closeCfgBtn.TextSize = 15*DPI
	closeCfgBtn.ZIndex = 31
	closeCfgBtn.Parent = ConfigPopup
	Instance.new("UICorner", closeCfgBtn).CornerRadius = UDim.new(0,8)
	closeCfgBtn.MouseButton1Click:Connect(function()
		ConfigPopup:Destroy(); ConfigPopup = nil
	end)
	saveAsBtn.MouseButton1Click:Connect(function()
		showSaveAsPopup()
	end)
	for presetName, presetData in pairs(Presets) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1,0,0,40)
		row.BackgroundColor3 = Color3.fromRGB(40,40,55)
		row.ZIndex = 32
		row.Parent = ConfigScroll
		Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
		local label = Instance.new("TextLabel")
		label.Text = presetName
		label.Size = UDim2.new(0.6,0,1,0)
		label.Position = UDim2.new(0,8,0,0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.new(1,1,1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 13*DPI
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 33
		label.Parent = row
		local loadBtn = Instance.new("TextButton")
		loadBtn.Size = UDim2.new(0,60,0,28)
		loadBtn.Position = UDim2.new(1,-130,0,6)
		loadBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
		loadBtn.Text = "Load"
		loadBtn.TextColor3 = Color3.new(1,1,1)
		loadBtn.Font = Enum.Font.GothamBold
		loadBtn.TextSize = 12*DPI
		loadBtn.ZIndex = 33
		loadBtn.Parent = row
		Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,6)
		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0,60,0,28)
		delBtn.Position = UDim2.new(1,-65,0,6)
		delBtn.BackgroundColor3 = Color3.fromRGB(255,50,50)
		delBtn.Text = "Delete"
		delBtn.TextColor3 = Color3.new(1,1,1)
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextSize = 12*DPI
		delBtn.ZIndex = 33
		delBtn.Parent = row
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,6)
		loadBtn.MouseButton1Click:Connect(function()
			showPresetLoadConfirm(presetName, presetData)
		end)
		delBtn.MouseButton1Click:Connect(function()
			showPresetDeleteConfirm(presetName, row)
		end)
	end
	local cam = workspace.CurrentCamera
	local scale = math.min(1, cam.ViewportSize.X*0.78/(360*DPI), cam.ViewportSize.Y*0.78/(400*DPI))
	Instance.new("UIScale", ConfigPopup).Scale = scale
end

ConfigBtn.MouseButton1Click:Connect(openConfigPopup)
CreateBtn.MouseButton1Click:Connect(function() CmdEditMacro() end)

updateNoMacrosLabel()
updateCanvas()

local cam = workspace.CurrentCamera
local scale = math.min(1, cam.ViewportSize.X*0.78/(420*DPI), cam.ViewportSize.Y*0.78/(520*DPI))
local uiScale = Instance.new("UIScale", Main)
uiScale.Scale = scale
end
-- Top bar buttons
local TopbarSettings = {
 TopbarAnimation = false, 
 TopbarLockValue = false,
}

local isButtonLocked = {}
local currentMouseHold = {}
local activeKeybinds = {}
local createdButtons = {} 

function UpdateAllButtons()
 if not TopbarSettings.TopbarLockValue then 
 for key, _ in pairs(isButtonLocked) do
 if isButtonLocked[key] then
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = key, Down = false })
 end
 isButtonLocked[key] = nil
 activeKeybinds[key] = nil
 end
 else 
 for key, _ in pairs(currentMouseHold) do
 if currentMouseHold[key] then
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = key, Down = false })
 end
 currentMouseHold[key] = nil
 end
 end

 for key, buttonData in pairs(createdButtons) do
 if buttonData and buttonData.updateVisualState then
 pcall(buttonData.updateVisualState)
 end
 end
end

local player = game.Players.LocalPlayer
local starterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("CustomTopGui") then
 playerGui:FindFirstChild("CustomTopGui"):Destroy()
end

starterGui:SetCore("TopbarEnabled", false)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomTopGui"
screenGui.IgnoreGuiInset = false
screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
screenGui.DisplayOrder = 100
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0, 0, 0, 0)
frame.Size = UDim2.new(1, 0, 1, -2)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "Right"
scrollingFrame.Parent = frame
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.Position = UDim2.new(0, 12, 0, 0)
scrollingFrame.Size = UDim2.new(1, -24, 1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
scrollingFrame.ScrollingEnabled = false

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.Padding = UDim.new(0, 12)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom

local keybindButtonsConfig = {
 {
 name = "SecondaryButton",
 layoutOrder = 999,
 icon = "rbxassetid://126943351764139",
 label = "Zoom",
 width = 100,
 labelWidth = 45,
 key = "Secondary",
 enablesLockValue = true
 },
 {
 name = "ReloadButton",
 layoutOrder = 997,
 icon = "rbxassetid://78648212535999",
 label = "Front View/Reload",
 width = 173,
 labelWidth = 118,
 key = "Reload",
 enablesLockValue = true
 },
 {
 name = "LeaderboardButton",
 layoutOrder = 998,
 icon = "rbxassetid://5107166345",
 label = "Leaderboard",
 width = 143,
 labelWidth = 88,
 key = "Leaderboard",
 enablesLockValue = true
 }
}

function createKeybindButton(config)
 local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

 local Button = Instance.new("Frame")
 Button.Name = config.name
 Button.Parent = scrollingFrame
 Button.BackgroundTransparency = 1
 Button.ClipsDescendants = true
 Button.LayoutOrder = config.layoutOrder
 Button.Size = UDim2.new(0, 44, 0, 44)
 Button.ZIndex = 20

 local IconButton = Instance.new("Frame"); IconButton.Name = "IconButton"; IconButton.Parent = Button; IconButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0); IconButton.BackgroundTransparency = 0.3; IconButton.BorderSizePixel = 0; IconButton.ClipsDescendants = true; IconButton.Size = UDim2.new(1, 0, 1, 0); IconButton.ZIndex = 2
 local UICorner = Instance.new("UICorner"); UICorner.CornerRadius = UDim.new(1, 0); UICorner.Parent = IconButton
 local Menu = Instance.new("ScrollingFrame"); Menu.Name = "Menu"; Menu.Parent = IconButton; Menu.BackgroundTransparency = 1; Menu.BorderSizePixel = 0; Menu.Position = UDim2.new(0, 4, 0, 0); Menu.Selectable = false; Menu.Size = UDim2.new(1, 0, 1, 0); Menu.ZIndex = 20; Menu.BottomImage = ""; Menu.CanvasSize = UDim2.new(0, 0, 1, -1); Menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always; Menu.ScrollBarThickness = 0; Menu.TopImage = ""
 local MenuUIListLayout = Instance.new("UIListLayout"); MenuUIListLayout.Name = "MenuUIListLayout"; MenuUIListLayout.Parent = Menu; MenuUIListLayout.FillDirection = Enum.FillDirection.Horizontal; MenuUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; MenuUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
 local IconSpot = Instance.new("Frame"); IconSpot.Name = "IconSpot"; IconSpot.Parent = Menu; IconSpot.AnchorPoint = Vector2.new(0, 0.5); IconSpot.BackgroundColor3 = Color3.fromRGB(255, 255, 255); IconSpot.BackgroundTransparency = 1; IconSpot.Position = UDim2.new(0, 4, 0.5, 0); IconSpot.Size = UDim2.new(0, 36, 1, -8); IconSpot.ZIndex = 5
 local UICorner_2 = Instance.new("UICorner"); UICorner_2.CornerRadius = UDim.new(1, 0); UICorner_2.Parent = IconSpot
 local IconOverlay = Instance.new("Frame"); IconOverlay.Name = "IconOverlay"; IconOverlay.Parent = IconSpot; IconOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255); IconOverlay.BackgroundTransparency = 0.925; IconOverlay.Size = UDim2.new(1, 0, 1, 0); IconOverlay.Visible = false; IconOverlay.ZIndex = 6
 local UICorner_3 = Instance.new("UICorner"); UICorner_3.CornerRadius = UDim.new(1, 0); UICorner_3.Parent = IconOverlay
 local ClickRegion = Instance.new("TextButton"); ClickRegion.Name = "ClickRegion"; ClickRegion.Parent = IconSpot; ClickRegion.BackgroundTransparency = 1; ClickRegion.Size = UDim2.new(1, 0, 1, 0); ClickRegion.ZIndex = 20; ClickRegion.Text = ""
 local UICorner_4 = Instance.new("UICorner"); UICorner_4.CornerRadius = UDim.new(1, 0); UICorner_4.Parent = ClickRegion
 local Contents = Instance.new("Frame"); Contents.Name = "Contents"; Contents.Parent = IconSpot; Contents.BackgroundTransparency = 1; Contents.Size = UDim2.new(1, 0, 1, 0)
 local ContentsList = Instance.new("UIListLayout"); ContentsList.Name = "ContentsList"; ContentsList.Parent = Contents; ContentsList.FillDirection = Enum.FillDirection.Horizontal; ContentsList.HorizontalAlignment = Enum.HorizontalAlignment.Center; ContentsList.SortOrder = Enum.SortOrder.LayoutOrder; ContentsList.VerticalAlignment = Enum.VerticalAlignment.Center; ContentsList.Padding = UDim.new(0, 3)
 local IconLabelContainer = Instance.new("Frame"); IconLabelContainer.Name = "IconLabelContainer"; IconLabelContainer.Parent = Contents; IconLabelContainer.AnchorPoint = Vector2.new(0, 0.5); IconLabelContainer.BackgroundTransparency = 1; IconLabelContainer.LayoutOrder = 4; IconLabelContainer.Position = UDim2.new(0.5, 0, 0.5, 0); IconLabelContainer.Size = UDim2.new(0, 0, 1, 0); IconLabelContainer.Visible = false; IconLabelContainer.ZIndex = 3
 local IconLabel = Instance.new("TextLabel"); IconLabel.Name = "IconLabel"; IconLabel.Parent = IconLabelContainer; IconLabel.BackgroundTransparency = 1; IconLabel.LayoutOrder = 4; IconLabel.Size = UDim2.new(0, 1306, 1, 0); IconLabel.ZIndex = 15; IconLabel.Font = Enum.Font.GothamMedium; IconLabel.Text = config.label; IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255); IconLabel.TextSize = 16; IconLabel.TextWrapped = false; IconLabel.TextXAlignment = Enum.TextXAlignment.Left; IconLabel.Visible = false
 local IconImage = Instance.new("ImageLabel"); IconImage.Name = "IconImage"; IconImage.Parent = Contents; IconImage.AnchorPoint = Vector2.new(0, 0.5); IconImage.BackgroundTransparency = 1; IconImage.LayoutOrder = 2; IconImage.Position = UDim2.new(0, 11, 0.5, 0); IconImage.Size = UDim2.new(0.7, 0, 0.7, 0); IconImage.ZIndex = 15; IconImage.Image = config.icon
 local IconImageRatio = Instance.new("UIAspectRatioConstraint"); IconImageRatio.Name = "IconImageRatio"; IconImageRatio.Parent = IconImage; IconImageRatio.DominantAxis = Enum.DominantAxis.Height
 local IconSpotGradient = Instance.new("UIGradient"); IconSpotGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(96, 98, 100)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(77, 78, 80))}; IconSpotGradient.Rotation = 45; IconSpotGradient.Name = "IconSpotGradient"; IconSpotGradient.Parent = IconSpot

 local isHovering = false
 local smallButtonSize = UDim2.new(0, 44, 0, 44)
 local largeButtonSize = UDim2.new(0, config.width, 0, 44)
 local smallIconSpotSize = UDim2.new(0, 36, 1, -8)
 local largeIconSpotSize = UDim2.new(0, config.width - 8, 1, -8)
 local smallLabelSize = UDim2.new(0, 0, 1, 0)
 local largeLabelSize = UDim2.new(0, config.labelWidth, 1, 0)

 function getIsActive()
 if TopbarSettings.TopbarLockValue then
 return isButtonLocked[config.key] or false
 else
 return currentMouseHold[config.key] or false
 end
 end

 function updateVisualState()
 IconOverlay.Visible = getIsActive() or isHovering
 end

 function hideTextWithDelay()
 task.spawn(function()
 task.wait(0.2)
 if not isHovering and not getIsActive() then
  if not TopbarSettings.TopbarAnimation then
IconLabel.Visible = false
IconLabelContainer.Visible = false
  else
IconLabel.Visible = false
IconLabelContainer.Visible = false
  end
 end
 end)
 end

 function expand()
 isHovering = true
 updateVisualState() if TopbarSettings.TopbarAnimation then
  IconLabel.Visible = true
  IconLabelContainer.Visible = true
  
  TweenService:Create(Button, tweenInfo, {Size = largeButtonSize}):Play()
  TweenService:Create(IconSpot, tweenInfo, {Size = largeIconSpotSize}):Play()
  TweenService:Create(IconLabelContainer, tweenInfo, {Size = largeLabelSize}):Play()
 else
  IconLabel.Visible = false
  IconLabelContainer.Visible = false
 end
 end

 function contract()
 isHovering = false
 updateVisualState() if TopbarSettings.TopbarAnimation then 
  local t = TweenService:Create(Button, tweenInfo, {Size = smallButtonSize})
  t:Play()
  TweenService:Create(IconSpot, tweenInfo, {Size = smallIconSpotSize}):Play()
  TweenService:Create(IconLabelContainer, tweenInfo, {Size = smallLabelSize}):Play()
  hideTextWithDelay()
 else
  IconLabel.Visible = false
  IconLabelContainer.Visible = false
 end
 end

 ClickRegion.MouseEnter:Connect(expand)
 ClickRegion.MouseLeave:Connect(function()
 contract()
 if not TopbarSettings.TopbarLockValue and currentMouseHold[config.key] then
 currentMouseHold[config.key] = false
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = config.key, Down = false })
 end
 end)

 if config.enablesLockValue then
 ClickRegion.MouseButton1Click:Connect(function()
 if TopbarSettings.TopbarLockValue then 
 isButtonLocked[config.key] = not isButtonLocked[config.key]
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = config.key, Down = isButtonLocked[config.key] })
 activeKeybinds[config.key] = isButtonLocked[config.key] or nil
 updateVisualState()
 end
 end)

 ClickRegion.MouseButton1Down:Connect(function()
 if not TopbarSettings.TopbarLockValue then 
 currentMouseHold[config.key] = true
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = config.key, Down = true })
 updateVisualState()
 end
 end)

 ClickRegion.MouseButton1Up:Connect(function()
 if not TopbarSettings.TopbarLockValue and currentMouseHold[config.key] then 
 currentMouseHold[config.key] = false
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind:Fire({ Key = config.key, Down = false })
 updateVisualState()
 end
 end)
 end

 createdButtons[config.key] = {
 Button = Button,
 updateVisualState = updateVisualState
 }
end

for _, config in ipairs(keybindButtonsConfig) do
 createKeybindButton(config)
end
 WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- Localization setup
-- Set WindUI properties
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

-- Create WindUI window
 Window = WindUI:CreateWindow({
 NewElements = true,
 Title = "Dara Hub | Evade",
 Icon = "rbxassetid://137330250139083",
 Author = "Made by: Pnsdg And Yomka",
 Folder = "DaraHub/Games/Evade",
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

pcall(updateWindowOpenState)
featureStates = featureStates or {}
if featureStates.DisableCameraShake == nil then
 featureStates.DisableCameraShake = false
end
Window:SetIconSize(48)
Window:Tag({
 Title = "V1.4.6",
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
Combat = Window:Tab({ Title = "Combat", Icon = "sword" }),
Auto = Window:Tab({ Title = "Auto", Icon = "repeat-2" }),
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
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local UniverseServerTools = loadstring(game:HttpGet("https://darahub.vercel.app/Module/UniverseServerTools.lua"))()

UniverseServerTools(Tabs)

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local featureStates = {
  ResetWhenTakeDamage = false,
 ResetDamageType = "Any Damage",
 AutoWhistle = false,
 CustomGravity = false,
 GravityValue = originalGameGravity,
 InfiniteJump = false,
 TPWALK = false,
 JumpBoost = false,
 AntiAFK = false,
 AutoCarry = false,
 NoFog = false,
 AutoVote = false,
 AutoSelfRevive = false,
 AutoRevive = false,
 FastRevive = false,
 DisableCameraShake = false,
 PlayerESP = {
 boxes = false,
 tracers = false,
 names = false,
 distance = false,
 rainbowBoxes = false,
 rainbowTracers = false,
 boxType = "2D",
 },
 NextbotESP = {
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
 TpwalkValue = 1,
 JumpPower = 5,
 JumpMethod = "Hold",
 SelectedMap = 1,
 ZoomValue = 1,
 TimerDisplay = false
}
-- Variables
local character, humanoid, rootPart
local isJumpHeld = false
local hasRevived = false
local bodyVelocity, bodyGyro
local ToggleTpwalk = false
local TpwalkConnection
if not featureStates.AntiNextbotDistance then
 featureStates.AntiNextbotDistance = 50
end

local farmsSuppressedByAntiNextbot = false
local antiNextbotConnection = nil
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
function isPlayerGrounded()
 if not character or not humanoid or not rootPart then
 return false
 end
 local rayOrigin = rootPart.Position
 local rayDirection = Vector3.new(0, -3, 0)
 local raycastParams = RaycastParams.new()
 raycastParams.FilterDescendantsInstances = {character}
 raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
 local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
 return raycastResult ~= nil
end

function bouncePlayer()
 if character and humanoid and rootPart and humanoid.Health > 0 then
 if not isPlayerGrounded() then
 humanoid.Jump = true
 local jumpVelocity = math.sqrt(1.5 * humanoid.JumpHeight * workspace.Gravity) * 1.5
 rootPart.Velocity = Vector3.new(rootPart.Velocity.X, jumpVelocity * humanoid.JumpPower / 50, rootPart.Velocity.Z)
 end
 end
end

function getDistanceFromPlayer(targetPosition)
 if not character or not rootPart then return 0 end
 return (targetPosition - rootPart.Position).Magnitude
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


if not workspace:FindFirstChild("SecurityPart") then
 local SecurityPart = Instance.new("Part")
 SecurityPart.Name = "SecurityPart"
 SecurityPart.Size = Vector3.new(10, 1, 10)
 SecurityPart.Position = Vector3.new(5000, 5000, 5000)
 SecurityPart.Anchored = true
 SecurityPart.CanCollide = true
 SecurityPart.Parent = workspace
end



function onCharacterAdded(newCharacter, plr)
 if plr == player then
 character = newCharacter
 humanoid = character:WaitForChild("Humanoid", 5)
 rootPart = character:WaitForChild("HumanoidRootPart", 5)
 if not humanoid or not rootPart then
 warn("Failed to find Humanoid or HumanoidRootPart")
 return
 end
 if type(setupJumpBoost) == "function" then
 setupJumpBoost()
 else
 end
 if type(reapplyFeatures) == "function" then
 reapplyFeatures()
 else
 end
 end
end
function reapplyFeatures()
end
function onPlayerAdded(plr)
 plr.CharacterAdded:Connect(function(newCharacter)
 onCharacterAdded(newCharacter, plr)
 end)
 if plr.Character then
 onCharacterAdded(plr.Character, plr)
 end
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, plr in ipairs(Players:GetPlayers()) do
 onPlayerAdded(plr)
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
 if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Space then
 if featureStates.InfiniteJump then
 if featureStates.JumpMethod == "Hold" then
 isJumpHeld = true
 bouncePlayer()
 task.spawn(function()
 while isJumpHeld and featureStates.InfiniteJump and featureStates.JumpMethod == "Hold" do
 bouncePlayer()
 task.wait(0.1)
 end
 end)
 elseif featureStates.JumpMethod == "Spam" then
 if not isJumpHeld then
 isJumpHeld = true
 bouncePlayer()
 end
 end
 end
 end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
 if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Space then
 isJumpHeld = false
 end
end)

function setupMobileJumpButton()
 local success, result = pcall(function()
 local touchGui = player.PlayerGui:WaitForChild("TouchGui", 5)
 local touchControlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
 local jumpButton = touchControlFrame:WaitForChild("JumpButton", 5) jumpButton.Activated:Connect(function()
 if featureStates.InfiniteJump then
 if featureStates.JumpMethod == "Spam" then
 bouncePlayer()
 elseif featureStates.JumpMethod == "Hold" then
 bouncePlayer()
 end
 end
 end)

 jumpButton.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.Touch then
 isJumpHeld = true
 if featureStates.InfiniteJump and featureStates.JumpMethod == "Hold" then
 while isJumpHeld and featureStates.InfiniteJump and featureStates.JumpMethod == "Hold" do
 bouncePlayer()
 task.wait(0.1)
 end
 end
 end
 end)

 jumpButton.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.Touch then
 isJumpHeld = false
 end
 end)
 end)
 if not success then
 end
end

if player.Character then
 onCharacterAdded(player.Character, player)
else
 player.CharacterAdded:Connect(function(newCharacter)
 onCharacterAdded(newCharacter, player)
 end)
end
setupMobileJumpButton()
Tabs.Main:Section({ Title = "Misc", TextSize = 20 })
Tabs.Main:Divider()
do
    coroutine.resume(coroutine.create(function()
        ResetWhenTakeDamageToggle = Tabs.Main:Toggle({
            Title = "Reset when take damage",
            Flag = "ResetWhenTakeDamageToggle",
            Value = featureStates.ResetWhenTakeDamage,
            Callback = function(value)
                featureStates.ResetWhenTakeDamage = value
            end
        })

        ResetDamageTypeDropdown = Tabs.Main:Dropdown({
            Title = "Reset damage types",
            Flag = "ResetDamageTypeDropdown",
            Values = {"Any Damage", "Low Health"},
            Value = featureStates.ResetDamageType,
            Callback = function(value)
                featureStates.ResetDamageType = value
            end
        })
        
        Tabs.Main:Space()
        
        function monitorAnyDamage()
            function setupCharacter(character)
                local humanoid = character:WaitForChild("Humanoid")
                local lastHealth = humanoid.Health
                local isAlive = true
                
                function checkAliveStatus()
                    if character:GetAttribute("Downed") then
                        return false
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        return true
                    end
                    return false
                end

                humanoid.HealthChanged:Connect(function(currentHealth)
                    local wasAlive = isAlive
                    isAlive = checkAliveStatus()
                    if featureStates.ResetWhenTakeDamage and isAlive and currentHealth < lastHealth then
                        if featureStates.ResetDamageType == "Any Damage" then
                            game:GetService("ReplicatedStorage").Events.Character.ToolAction:FireServer(-2)
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://8164951181"
                            sound.Volume = 3
                            sound.Parent = game:GetService("SoundService")
                            sound:Play()
                            sound.Ended:Connect(function()
                                sound:Destroy()
                            end)
                        elseif featureStates.ResetDamageType == "Low Health" and currentHealth <= 25 then
                            game:GetService("ReplicatedStorage").Events.Character.ToolAction:FireServer(-2)
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://8164951181"
                            sound.Volume = 3
                            sound.Parent = game:GetService("SoundService")
                            sound:Play()
                            sound.Ended:Connect(function()
                                sound:Destroy()
                            end)
                        end
                    end
                    lastHealth = currentHealth
                end)

                character:GetAttributeChangedSignal("Downed"):Connect(function()
                    isAlive = not character:GetAttribute("Downed")
                end)
                isAlive = checkAliveStatus()
            end

            if player.Character then
                setupCharacter(player.Character)
            end
            player.CharacterAdded:Connect(setupCharacter)
        end

        monitorAnyDamage()
    end))
end
  Tabs.Main:Button({
 Title = "Show/Hide Reload button",
 Desc = "This button allow you to use front view mode without keyboard or any tool in vip server",
 Icon = "switch-camera",
 Callback = function()
 if reloadVisible then
 if reloadButton then
 reloadButton.Visible = false
 reloadButton.Active = false
 end
 reloadVisible = false
 else
 reloadButton = game:GetService("Players").LocalPlayer.PlayerGui.Shared.HUD.Mobile.Right.Mobile.ReloadButton
 local originalParent = reloadButton.Parent
 reloadButton.Parent = nil
 wait()
 reloadButton.Parent = originalParent
 reloadButton.Visible = true
 reloadButton.Active = true
 reloadVisible = true
 end
 end
})
Tabs.Main:Space()

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
 Tabs.Main:Space()
Tabs.Main:Button({
 Title = "Redeem All code",
 Desx = "Redeem All code That are listed in Wikipedia",
 Callback = function()
 if getgenv().EvadeCode then
game:GetService("Players").LocalPlayer.PlayerGui.Global.Messages.Use:Fire("You already used this", "Error")
 return
end
getgenv().EvadeCode = true
local ReplicatedStorage = game:GetService("ReplicatedStorage") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local RemoteEvent = ReplicatedStorage.Events.Data.UseCode local MessageEvent = LocalPlayer.PlayerGui.Global.Messages.Use local URL = "https://wiki-wacker.vercel.app/api/raw?url=https%3A%2F%2Fevade-nextbot.fandom.com%2Fwiki%2FCodes" function getContent(url) local success, content = pcall(function() return game:HttpGet(url, true) end) if success then return content else return nil end end function extractTRData(htmlContent) if not htmlContent then return {} end local tableRows = {} local trPattern = "<tr>(.-)</tr>" for trContent in htmlContent:gmatch(trPattern) do local rowData = {} local codePattern = "<td[^>]*>%s*<code[^>]*>(.-)</code>" local code = trContent:match(codePattern) if code then code = code:gsub("&lt;", "<") code = code:gsub("&gt;", ">") code = code:gsub("&amp;", "&") code = code:gsub("&quot;", '"') code = code:match("^%s*(.-)%s*$") or code rowData.code = code end local tdPattern = "<td[^>]*>(.-)</td>" local tdCount = 0 local tds = {} for tdContent in trContent:gmatch(tdPattern) do tdCount = tdCount + 1 local cleanContent = tdContent :gsub("<[^>]+>", "") :gsub("&lt;", "<") :gsub("&gt;", ">") :gsub("&amp;", "&") :gsub("&quot;", '"') :gsub("%s+", " ") :match("^%s*(.-)%s*$") or tdContent table.insert(tds, cleanContent) end if tdCount >= 2 and not rowData.code then rowData.code = tds[1] rowData.description = tdCount >= 2 and tds[2] or "" rowData.status = tdCount >= 3 and tds[3] or "" rowData.date = tdCount >= 4 and tds[4] or "" elseif rowData.code then rowData.description = tdCount >= 2 and tds[1] or "" rowData.status = tdCount >= 3 and tds[2] or "" rowData.date = tdCount >= 4 and tds[3] or "" end local statusPattern = "<b[^>]*>%s*<span[^>]*>([^<]+)</span>%s*</b>" local statusValue = trContent:match(statusPattern) if statusValue then statusValue = statusValue:lower():gsub("%s+", "") if statusValue == "true" or statusValue == "false" then rowData.spanStatus = statusValue end end if not rowData.spanStatus then local truePos = trContent:lower():find("true") local falsePos = trContent:lower():find("false") if truePos then rowData.spanStatus = "true" elseif falsePos then rowData.spanStatus = "false" end end if rowData.code and #rowData.code > 0 then table.insert(tableRows, rowData) end end return tableRows end function useCodeWithFeedback(code) local success, response = pcall(function() return RemoteEvent:InvokeServer(code) end) if not success then MessageEvent:Fire("Failed to fetch our Wikipedia content, please try again later", "Error") return end if response == nil then MessageEvent:Fire("Redeemed!", "Success") elseif type(response) == "boolean" then if response then MessageEvent:Fire("Accepted!", "Success") else MessageEvent:Fire("Invalid", "Error") end elseif type(response) == "string" then local lower = response:lower() if lower:find("success") or lower:find("accepted") or lower:find("redeemed") or lower:find("reward") then MessageEvent:Fire(response, "Success") elseif lower:find("invalid") or lower:find("error") or lower:find("failed") or lower:find("already") then MessageEvent:Fire(response, "Error") else MessageEvent:Fire(response, "Success") end elseif type(response) == "table" then if response.success == true then MessageEvent:Fire(response.message or "Success", "Success") elseif response.success == false then MessageEvent:Fire(response.message or "Failed", "Error") elseif response.error then MessageEvent:Fire(response.error, "Error") elseif response.message then MessageEvent:Fire(response.message, "Info") else MessageEvent:Fire("Processed", "Info") end else MessageEvent:Fire("Response: " .. tostring(response), "Info") end end function main() MessageEvent:Fire("Starting code extraction...", "Info") local htmlContent = getContent(URL) if not htmlContent then MessageEvent:Fire("Failed to fetch our Wikipedia content", "Error") return end local tableRows = extractTRData(htmlContent) if #tableRows == 0 then MessageEvent:Fire("No table rows found", "Error") return end MessageEvent:Fire("Found " .. #tableRows .. " table rows", "Info") local trueCodes = {} local falseCodes = {} local unknownCodes = {} for i, row in ipairs(tableRows) do local status = row.spanStatus or "unknown" if status == "true" then table.insert(trueCodes, row.code) elseif status == "false" then table.insert(falseCodes, row.code) else table.insert(unknownCodes, row.code) end end MessageEvent:Fire("True codes: " .. #trueCodes, "Success") MessageEvent:Fire("False codes: " .. #falseCodes, "Error") MessageEvent:Fire("Unknown codes: " .. #unknownCodes, "ing") MessageEvent:Fire("Code Will be redeem in 5 Second", "Message") wait(5) local validCodes = {} for _, code in ipairs(trueCodes) do table.insert(validCodes, code) end for _, code in ipairs(unknownCodes) do table.insert(validCodes, code) end if #validCodes == 0 then MessageEvent:Fire("No valid codes to try", "Error") return end for i, code in ipairs(validCodes) do MessageEvent:Fire("Processing [" .. i .. "/" .. #validCodes .. "]: " .. code, "Info") useCodeWithFeedback(code) end end main()
 end
})
 Tabs.Main:Space()

 local PathfindingService = game:GetService("PathfindingService")

featureStates.AntiNextbot = false
featureStates.AntiNextbotTeleportType = "Distance"
featureStates.AntiNextbotDistance = 50
featureStates.DistanceTeleport = 20

function handleAntiNextbot()
 if not featureStates.AntiNextbot then return end

 local character = Players.LocalPlayer.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return end

 local nextbots = {}
 local npcsFolder = workspace:FindFirstChild("NPCs")
 if npcsFolder then
 for _, model in ipairs(npcsFolder:GetChildren()) do
 if model:IsA("Model") and isNextbotModel(model) then
 local hrp = model:FindFirstChild("HumanoidRootPart")
 if hrp then
 table.insert(nextbots, model)
 end
 end
 end
 end

 local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
 if playersFolder then
 for _, model in ipairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and isNextbotModel(model) then
 local hrp = model:FindFirstChild("HumanoidRootPart")
 if hrp then
 table.insert(nextbots, model)
 end
 end
 end
 end

 for _, nextbot in ipairs(nextbots) do
 local nextbotHrp = nextbot:FindFirstChild("HumanoidRootPart")
 if nextbotHrp then
 local distance = (humanoidRootPart.Position - nextbotHrp.Position).Magnitude
 if distance <= featureStates.AntiNextbotDistance then
 if featureStates.AntiNextbotTeleportType == "Players" then
 local validPlayers = {}
 for _, plr in ipairs(Players:GetPlayers()) do
 if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
 table.insert(validPlayers, plr)
 end
 end
 if #validPlayers > 0 then
 local randomPlayer = validPlayers[math.random(1, #validPlayers)]
 humanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
 end
 elseif featureStates.AntiNextbotTeleportType == "Spawn" then
 local spawnsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Parts") and workspace.Game.Map.Parts:FindFirstChild("Spawns")
 if spawnsFolder then
 local spawnLocations = spawnsFolder:GetChildren()
 if #spawnLocations > 0 then
 local randomSpawn = spawnLocations[math.random(1, #spawnLocations)]
 humanoidRootPart.CFrame = randomSpawn.CFrame + Vector3.new(0, 3, 0)
 end
 end
 elseif featureStates.AntiNextbotTeleportType == "Distance" then
 local direction = (humanoidRootPart.Position - nextbotHrp.Position).Unit
 local targetPos = humanoidRootPart.Position + direction * featureStates.DistanceTeleport

 local path = PathfindingService:CreatePath({
 AgentRadius = 2,
 AgentHeight = 5,
 AgentCanJump = true
 })

 local success, errorMessage = pcall(function()
 path:ComputeAsync(humanoidRootPart.Position, targetPos)
 end)

 if success and path.Status == Enum.PathStatus.Success then
 local waypoints = path:GetWaypoints()
 if #waypoints > 1 then
 local lastValidPos = waypoints[#waypoints].Position
 local distanceToTarget = (lastValidPos - humanoidRootPart.Position).Magnitude
 if distanceToTarget <= featureStates.DistanceTeleport then
 humanoidRootPart.CFrame = CFrame.new(lastValidPos + Vector3.new(0, 3, 0))
 else
 for i = #waypoints, 1, -1 do
 local waypointPos = waypoints[i].Position
 if (waypointPos - humanoidRootPart.Position).Magnitude <= featureStates.DistanceTeleport then
 humanoidRootPart.CFrame = CFrame.new(waypointPos + Vector3.new(0, 3, 0))
 break
 end
 end
 end
 end
 else
 local fallbackPos = humanoidRootPart.Position + direction * featureStates.DistanceTeleport
 local ray = Ray.new(humanoidRootPart.Position, direction * featureStates.DistanceTeleport)
 local hit, hitPos = workspace:FindPartOnRayWithIgnoreList(ray, {character, nextbot})
 if not hit then
 humanoidRootPart.CFrame = CFrame.new(fallbackPos + Vector3.new(0, 3, 0))
 else
 humanoidRootPart.CFrame = CFrame.new(hitPos + Vector3.new(0, 3, 0))
 end
 end
 end
 break
 end
 end
 end
end

task.spawn(function()
 while true do
 if featureStates.AntiNextbot then
 pcall(handleAntiNextbot)
 end
 task.wait(0.1)
 end
end)


 AntiNextbotToggle = Tabs.Main:Toggle({
 Title = "Anti-Nextbot",
 Flag = "AntiNextbotToggle",
 Desc = "Automatically teleport away from nearby Nextbots (farms pause if too close)",
 Icon = "shield",
 Value = featureStates.AntiNextbot,
 Callback = function(state)
 featureStates.AntiNextbot = state if state then
 antiNextbotConnection = game:GetService("RunService").Heartbeat:Connect(function()
 if not featureStates.AntiNextbot then return end
 
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return end
 local nearestDistance = math.huge
 local nearestNextbot = nil
 local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
 local npcsFolder = workspace:FindFirstChild("NPCs")
 
 if playersFolder then
 for _, model in pairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isNextbotModel(model) then
 local dist = (model.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
 if dist < nearestDistance then
 nearestDistance = dist
 nearestNextbot = model
 end
 end
 end
 end
 
 if npcsFolder then
 for _, model in pairs(npcsFolder:GetChildren()) do
 if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isNextbotModel(model) then
 local dist = (model.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
 if dist < nearestDistance then
 nearestDistance = dist
 nearestNextbot = model
 end
 end
 end
 end
 
 local threshold = featureStates.AntiNextbotDistance
 local isTooClose = (nearestDistance < threshold)
 
 if isTooClose and not farmsSuppressedByAntiNextbot then
 previousMoneyFarm = getgenv().moneyfarm
 previousTicketFarm = getgenv().ticketfarm
 previousAutoWin = getgenv().autowin getgenv().moneyfarm = false
 getgenv().ticketfarm = false
 getgenv().autowin = false stopAutoMoneyFarm()
 stopAutoWin() if AutoMoneyFarmToggle and AutoMoneyFarmToggle.Set then AutoMoneyFarmToggle:Set(false) end
 if AutoTicketFarmToggle and AutoTicketFarmToggle.Set then AutoTicketFarmToggle:Set(false) end
 if AutoWinToggle and AutoWinToggle.Set then AutoWinToggle:Set(false) end farmsSuppressedByAntiNextbot = true
 elseif not isTooClose and farmsSuppressedByAntiNextbot then
 getgenv().moneyfarm = previousMoneyFarm
 getgenv().ticketfarm = previousTicketFarm
 getgenv().autowin = previousAutoWin if previousMoneyFarm then
 startAutoMoneyFarm()
 if AutoMoneyFarmToggle and AutoMoneyFarmToggle.Set then AutoMoneyFarmToggle:Set(true) end
 end
 if previousTicketFarm then
 if AutoTicketFarmToggle and AutoTicketFarmToggle.Set then AutoTicketFarmToggle:Set(true) end
 end
 if previousAutoWin then
 startAutoWin()
 if AutoWinToggle and AutoWinToggle.Set then AutoWinToggle:Set(true) end
 end farmsSuppressedByAntiNextbot = false
 end
 
 if isTooClose then
 local safePart = workspace:FindFirstChild("SecurityPart")
 if safePart then
 humanoidRootPart.CFrame = safePart.CFrame + Vector3.new(math.random(-5, 5), 3, math.random(-5, 5))
 end
 end
 end)
 else
 if antiNextbotConnection then
 antiNextbotConnection:Disconnect()
 antiNextbotConnection = nil
 end
 if farmsSuppressedByAntiNextbot then
 getgenv().moneyfarm = previousMoneyFarm
 getgenv().ticketfarm = previousTicketFarm
 getgenv().autowin = previousAutoWin
 
 if previousMoneyFarm then
 startAutoMoneyFarm()
 if AutoMoneyFarmToggle and AutoMoneyFarmToggle.Set then AutoMoneyFarmToggle:Set(true) end
 end
 if previousTicketFarm then
 if AutoTicketFarmToggle and AutoTicketFarmToggle.Set then AutoTicketFarmToggle:Set(true) end
 end
 if previousAutoWin then
 startAutoWin()
 if AutoWinToggle and AutoWinToggle.Set then AutoWinToggle:Set(true) end
 end
 
 farmsSuppressedByAntiNextbot = false
 end
 end
 end
})

 AntiNextbotTeleportTypeDropdown = Tabs.Main:Dropdown({
 Title = "Anti-Nextbot Teleport Type",
 Flag = "AntiNextbotTeleportTypeDropdown",
 Desc = "Choose how to teleport when avoiding Nextbots",
 Values = {"Players", "Spawn", "Distance"},
 Value = featureStates.AntiNextbotTeleportType,
 Callback = function(value)
 featureStates.AntiNextbotTeleportType = value
 end
})

 AntiNextbotDistanceInput = Tabs.Main:Input({
 Title = "Anti-Nextbot Distance",
 Flag = "AntiNextbotDistanceInput",
 Desc = "Distance threshold for Nextbot detection",
 Placeholder = tostring(featureStates.AntiNextbotDistance),
 NumbersOnly = true,
 Value = tostring(featureStates.AntiNextbotDistance),
 Callback = function(value)
 local num = tonumber(value)
 if num and num > 0 then
 featureStates.AntiNextbotDistance = num
 end
 end
})
 DistanceTeleportInput = Tabs.Main:Input({
 Title = "Distance Teleport",
 Flag = "DistanceTeleportInput",
 Desc = "How far to teleport when using Distance mode",
 Placeholder = tostring(featureStates.DistanceTeleport),
 NumbersOnly = true,
 Callback = function(value)
 local num = tonumber(value)
 if num and num > 0 then
 featureStates.DistanceTeleport = num
 end
 end
})

featureStates.AntiNextbotSpawn = false
featureStates.AntiNextbotSpawnType = "Spawn"
featureStates.AntiNextbotSpawnDistance = 40
featureStates.AntiNextbotTeleportDistance = 20

local cachedAttachment = nil
local lastAttachmentCheck = 0
local attachmentCheckCooldown = 5
local isSearchingForAttachment = false

function getAttachment()
 if tick() - lastAttachmentCheck > attachmentCheckCooldown then
 cachedAttachment = workspace.Terrain:FindFirstChild("NextbotSpawnAttachment")
 lastAttachmentCheck = tick()
 end
 return cachedAttachment
end

function startAttachmentSearch()
 if isSearchingForAttachment then return end
 isSearchingForAttachment = true
 
 task.spawn(function()
 while featureStates.AntiNextbotSpawn and not getAttachment() do
 task.wait(3) local statsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Stats")
 if statsFolder then
 local timerValue = statsFolder:GetAttribute("Timer")
 if timerValue == 0 then
 cachedAttachment = workspace.Terrain:FindFirstChild("NextbotSpawnAttachment")
 lastAttachmentCheck = tick()
 if cachedAttachment then
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "Attachment found! System now active.",
 Duration = 3
 })
 break
 end
 end
 end
 end
 isSearchingForAttachment = false
 end)
end

function fastDistanceSquared(pos1, pos2)
 local dx = pos1.X - pos2.X
 local dy = pos1.Y - pos2.Y
 local dz = pos1.Z - pos2.Z
 return dx*dx + dy*dy + dz*dz
end

function findSafeTeleportPositionReverse(startPos, targetPos)
 local raycastParams = RaycastParams.new()
 raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
 raycastParams.FilterDescendantsInstances = {player.Character}
 
 local direction = (targetPos - startPos).Unit
 local maxDistance = (targetPos - startPos).Magnitude
 
 for distance = maxDistance, 0, -5 do
 local testPos = startPos + (direction * distance) local downRay = workspace:Raycast(testPos + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0), raycastParams)
 if downRay then
 local groundPos = downRay.Position + Vector3.new(0, 3, 0) local upRay = workspace:Raycast(groundPos, Vector3.new(0, 6, 0), raycastParams)
 if not upRay then
 local sideRays = {
 Vector3.new(3, 0, 0),
 Vector3.new(-3, 0, 0),
 Vector3.new(0, 0, 3),
 Vector3.new(0, 0, -3)
 }
 
 local isSafe = true
 for _, sideDir in ipairs(sideRays) do
 local sideRay = workspace:Raycast(groundPos, sideDir, raycastParams)
 if sideRay and sideRay.Instance.CanCollide then
 isSafe = false
 break
 end
 end
 
 if isSafe then
 return groundPos
 end
 end
 end
 end
 
 return nil
end

function teleportToSpawn()
 local spawnsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Parts") and workspace.Game.Map.Parts:FindFirstChild("Spawns")
 
 if spawnsFolder then
 local spawnLocations = spawnsFolder:GetChildren()
 if #spawnLocations > 0 then
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
 for i = 1, math.min(3, #spawnLocations) do
 local randomSpawn = spawnLocations[math.random(1, #spawnLocations)]
 local targetPosition = randomSpawn.CFrame.Position + Vector3.new(0, 3, 0) local safePosition = findSafeTeleportPositionReverse(humanoidRootPart.Position, targetPosition)
 if safePosition then
 humanoidRootPart.CFrame = CFrame.new(safePosition)
 return true
 end
 end
 end
 end
 end
 return false
end

function teleportToPlayer()
 local players = Players:GetPlayers()
 local validPlayers = {}
 
 for _, plr in ipairs(players) do
 if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
 table.insert(validPlayers, plr)
 end
 end
 
 if #validPlayers > 0 then
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
 for i = 1, math.min(3, #validPlayers) do
 local randomPlayer = validPlayers[math.random(1, #validPlayers)]
 local targetPosition = randomPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0)
 
 local safePosition = findSafeTeleportPositionReverse(humanoidRootPart.Position, targetPosition)
 if safePosition then
 humanoidRootPart.CFrame = CFrame.new(safePosition)
 return true
 end
 end
 end
 end
 return false
end

function teleportToDistance()
 local attachment = getAttachment()
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return false end
 
 if attachment then
 local direction = (humanoidRootPart.Position - attachment.WorldPosition).Unit
 local targetPos = humanoidRootPart.Position + direction * featureStates.AntiNextbotTeleportDistance local safePosition = findSafeTeleportPositionReverse(humanoidRootPart.Position, targetPos)
 if safePosition then
 humanoidRootPart.CFrame = CFrame.new(safePosition)
 return true
 else
 return teleportToSpawn()
 end
 else
 return teleportToSpawn()
 end
end

function isPlayerNearSpawn()
 local attachment = getAttachment()
 if not attachment or not player.Character then return false end
 
 local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return false end
 
 local distanceSquared = fastDistanceSquared(humanoidRootPart.Position, attachment.WorldPosition)
 local triggerDistanceSquared = featureStates.AntiNextbotSpawnDistance * featureStates.AntiNextbotSpawnDistance
 
 return distanceSquared <= triggerDistanceSquared
end

function performAvoidance()
 if not player.Character then return end
 
 local success = false
 
 if featureStates.AntiNextbotSpawnType == "Spawn" then
 success = teleportToSpawn()
 elseif featureStates.AntiNextbotSpawnType == "Player" then
 success = teleportToPlayer()
 else
 success = teleportToDistance()
 end
 
 if not success then
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "No safe teleport location found!",
 Duration = 2
 })
 end
end

local nextbotSpawnConnection = nil
local lastAvoidanceTime = 0
local avoidanceCooldown = 2

function startAntiNextbot()
 if nextbotSpawnConnection then
 nextbotSpawnConnection:Disconnect()
 end
 
 nextbotSpawnConnection = RunService.Heartbeat:Connect(function()
 if not featureStates.AntiNextbotSpawn or not player.Character then return end if tick() - lastAvoidanceTime < avoidanceCooldown then return end local attachment = getAttachment()
 if not attachment then
 return
 end if isPlayerNearSpawn() then
 performAvoidance()
 lastAvoidanceTime = tick()
 end
 end)
end

function restartSystemOnEvents()
 player.CharacterAdded:Connect(function()
 if featureStates.AntiNextbotSpawn then
 task.wait(1)
 if not nextbotSpawnConnection then
 startAntiNextbot()
 end
 end
 end)
 
 local statsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Stats")
 if statsFolder then
 statsFolder:GetAttributeChangedSignal("Timer"):Connect(function()
 if featureStates.AntiNextbotSpawn then
 local timerValue = statsFolder:GetAttribute("Timer")
 if timerValue == 0 then
 cachedAttachment = workspace.Terrain:FindFirstChild("NextbotSpawnAttachment")
 lastAttachmentCheck = tick() if not nextbotSpawnConnection then
 task.wait(1)
 startAntiNextbot()
 end
 end
 end
 end)
 end
end
Tabs.Main:Space()

AntiNextbotSpawnToggle = Tabs.Main:Toggle({
 Title = "Anti Nextbot Spawn",
 Flag = "AntiNextbotSpawnToggle",
 Desc = "Automatically avoid Nextbot spawn areas",
 Value = false,
 Callback = function(state)
 featureStates.AntiNextbotSpawn = state if state then
 startAntiNextbot()
 startAttachmentSearch() if not getAttachment() then
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "System enabled - Searching for attachment...",
 Duration = 3
 })
 else
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "System enabled - Attachment found!",
 Duration = 3
 })
 end
 else
 if nextbotSpawnConnection then
 nextbotSpawnConnection:Disconnect()
 nextbotSpawnConnection = nil
 end
 isSearchingForAttachment = false
 end
 end
})

AntiNextbotSpawnTypeDropdown = Tabs.Main:Dropdown({
 Title = "Avoidance Mode",
 Flag = "AntiNextbotSpawnTypeDropdown",
 Desc = "Choose how to avoid Nextbot spawn",
 Values = {"Spawn", "Player", "Distance"},
 Value = "Spawn",
 Callback = function(value)
 featureStates.AntiNextbotSpawnType = value
 end
})

AntiNextbotSpawnDistanceInput = Tabs.Main:Input({
 Title = "Avoidance Distance",
 Flag = "AntiNextbotSpawnDistanceInput",
 Desc = "Distance to trigger avoidance (studs)",
 Placeholder = "40",
 NumbersOnly = true,
 Callback = function(value)
 local distance = tonumber(value)
 if distance and distance > 0 then
 featureStates.AntiNextbotSpawnDistance = distance
 end
 end
})

AntiNextbotTeleportDistanceInput = Tabs.Main:Input({
 Title = "Teleport Distance",
 Flag = "AntiNextbotTeleportDistanceInput",
 Desc = "How far to teleport in Distance mode (studs)",
 Placeholder = "20",
 NumbersOnly = true,
 Callback = function(value)
 local distance = tonumber(value)
 if distance and distance > 0 then
 featureStates.AntiNextbotTeleportDistance = distance
 end
 end
})

task.spawn(function()
 while true do
 task.wait(attachmentCheckCooldown) if featureStates.AntiNextbotSpawn then
 local currentAttachment = workspace.Terrain:FindFirstChild("NextbotSpawnAttachment") if currentAttachment and not cachedAttachment then
 cachedAttachment = currentAttachment
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "Attachment found! System now active.",
 Duration = 3
 })
 elseif not currentAttachment and cachedAttachment then
 cachedAttachment = nil
 WindUI:Notify({
 Title = "Anti Nextbot Spawn",
 Content = "Attachment lost - System will reactivate when found.",
 Duration = 3
 })
 else
 cachedAttachment = currentAttachment
 end
 end
 end
end)

restartSystemOnEvents()

Tabs.Main:Section({ Title = "Emote Crouch", TextSize = 20 })
Tabs.Main:Divider()

math.randomseed(tick())

local emoteInputs = {}
for i = 1, 12 do
emoteInputs[i] = Tabs.Main:Input({
Title = "Emote " .. i,
Placeholder = "Emote Name Here",
Callback = function(value)
featureStates["Emote" .. i] = value
end
})
end

function triggerRandomEmote()
local validEmotes = {}
for i = 1, 12 do
local emoteName = featureStates["Emote" .. i]
if emoteName and emoteName ~= "" then
table.insert(validEmotes, emoteName)
end
end

if #validEmotes > 0 then
math.randomseed(tick() + #validEmotes)

local ohTable1 = { ["Key"] = "Crouch", ["Down"] = true }
pcall(function()
player.PlayerScripts.Events.temporary_events.UseKeybind:Fire(ohTable1)
end)
local randomIndex = math.random(1, #validEmotes)
local randomEmote = validEmotes[randomIndex]
pcall(function()
ReplicatedStorage.Events.Character.Emote:FireServer(randomEmote)
end)
end
end
ButtonLib.Create:Button({
Text = "Emote Crouch",
Flag = "EmoteCrouch",
Visible = false,
Callback = function() triggerRandomEmote() end
}).Position = UDim2.new(0.5, -125, 0.2, 0)



EmoteCrouchToggle = Tabs.Main:Toggle({
Title = "Emote Crouch",
Flag = "EmoteCrouchToggle",
Desc = "Only type emote name without space and inside your emote slot will work",
Value = false,
Callback = function(state)
featureStates.EmoteCrouchEnabled = state

if _G.DarahubLibBtn and _G.DarahubLibBtn.EmoteCrouch then
_G.DarahubLibBtn.EmoteCrouch.Visible = state
end

end
})


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
Tabs.Main:Button({ Title = "Stop recording", Color = Color3.fromHex("#ff4830"), Callback = StopRecord })
Tabs.Main:Button({ Title = "Play", Color = Color3.fromHex("#30FF6A"), Callback = PlayTAS })
  -- Player Tabs
  Tabs.Player:Section({ Title = "Player", TextSize = 40 })
 Tabs.Player:Divider()
BounceSystem = {
Config = {
VelocityMultiplier = 80, -- 80 = 1 stud boost
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
-- Convert multiplier to velocity: multiplier/80 = studs/second to add
local boostAmount = self.Config.VelocityMultiplier / 1 -- 80 = 1 stud, 160 = 2 studs, etc.

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

Tabs.Player:Space()
 InfiniteJumpToggle = Tabs.Player:Toggle({
 Title = "Infinite Jump",
 Flag = "InfiniteJumpToggle",
 Value = false,
 Callback = function(state)
 featureStates.InfiniteJump = state
 end
 })

 JumpMethodDropdown = Tabs.Player:Dropdown({
 Title = "Infinite Jump Method",
 Flag = "JumpMethodDropdown",
 Values = {"Hold", "Spam"},
 Value = "Hold",
 Callback = function(value)
 featureStates.JumpMethod = value
 end
 })
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character
local humanoid
local rootPart

local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    else
        humanoid = nil
        rootPart = nil
    end
end

updateCharacter()
player.CharacterAdded:Connect(updateCharacter)
player.CharacterRemoving:Connect(function()
    character = nil
    humanoid = nil
    rootPart = nil
end)

local flying = false
local bodyVelocity
local bodyGyro
local flySpeed = 50
local ToggleTpwalk = false
local flyConnection

Tabs.Player:Space()

FlyToggle = Tabs.Player:Toggle({
    Title = "Fly",
    Flag = "FlyToggle",
    Value = false,
    Callback = function(state)
        flying = state
        if state then
            startFlying()
        else
            stopFlying()
        end
    end
})

function startFlying()
    updateCharacter()
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
    flyConnection = RunService.Heartbeat:Connect(updateFly)
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
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

function updateFly()
    if not flying or not bodyVelocity or not bodyGyro or not humanoid or not rootPart then return end
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
    
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    bodyVelocity.Velocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.new(0, 0, 0)
    bodyGyro.CFrame = cameraCFrame
end

function Tpwalking()
    if ToggleTpwalk and character and humanoid and rootPart then
        local moveDirection = humanoid.MoveDirection
        local moveDistance = 5
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

FlySpeedSlider = Tabs.Player:Slider({
    Title = "Fly Speed",
    Flag = "FlySpeedSlider",
    Value = { Min = 1, Max = 9999, Default = 70 },
    Desc = "Adjust fly speed",
    Callback = function(value)
        Waxed_Lightly_Weathered_Copper_Stairs_Elytra_Enchanted_Trident_With_RainSpeed = value
    end
})
local CachedTables = {}
local PlrModel = nil
local SlideFrictionValue = -8
local HeartbeatConnection = nil
local Enabled = false
local CharacterAddedConnection = nil

function RefreshCachedTables()
    local newCachedTables = {}
    
    for _, obj in ipairs(getgc(true)) do
        if type(obj) == "table" and rawget(obj, "Friction") and rawget(obj, "Speed") then
            table.insert(newCachedTables, obj)
        end
    end
    
    CachedTables = newCachedTables
end

function UpdatePlayerModel()
    local GameFolder = workspace:FindFirstChild("Game")
    local PlayersFolder = GameFolder and GameFolder:FindFirstChild("Players")
    
    if PlayersFolder then
        PlrModel = PlayersFolder:FindFirstChild(game.Players.LocalPlayer.Name)
    else
        PlrModel = nil
    end
end

function SetFriction(value)
    if #CachedTables == 0 then
        RefreshCachedTables()
    end
    
    for _, t in ipairs(CachedTables) do
        t.Friction = value
    end
end

function OnHeartbeat()
    if not PlrModel then
        SetFriction(5)
        return
    end
    
    local currentState = PlrModel:GetAttribute("State")
    
    if currentState == "Slide" then
        PlrModel:SetAttribute("State", "EmotingSlide")
    elseif currentState == "EmotingSlide" then
        SetFriction(SlideFrictionValue)
    else
        SetFriction(5)
    end
end

function StartInfiniteSlide()
    Enabled = true
    RefreshCachedTables()
    UpdatePlayerModel()
    
    if HeartbeatConnection then
        HeartbeatConnection:Disconnect()
    end
    
    HeartbeatConnection = game:GetService("RunService").Heartbeat:Connect(OnHeartbeat)
    
    if CharacterAddedConnection then
        CharacterAddedConnection:Disconnect()
    end
    
    CharacterAddedConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        RefreshCachedTables()
        UpdatePlayerModel()
    end)
end

function StopInfiniteSlide()
    Enabled = false
    SetFriction(5)
    
    if HeartbeatConnection then
        HeartbeatConnection:Disconnect()
        HeartbeatConnection = nil
    end
    
    if CharacterAddedConnection then
        CharacterAddedConnection:Disconnect()
        CharacterAddedConnection = nil
    end
    
    PlrModel = nil
    CachedTables = {}
end

Tabs.Player:Space()

InfiniteSlideToggle = Tabs.Player:Toggle({
    Title = "Infinite Slide",
    Flag = "InfiniteSlideToggle",
    Value = false,
    Callback = function(state)
        if state then
            SlideFrictionValue = tonumber(SlideFrictionInput.Value) or -8
            StartInfiniteSlide()
        else
            StopInfiniteSlide()
        end
    end
})

SlideFrictionInput = Tabs.Player:Input({
    Title = "Slide Friction",
    Flag = "SlideFrictionInput",
    Desc = "Negative Only And faster slide",
    Placeholder = "-8",
    NumbersOnly = true,
    Value = "-8",
    Callback = function(value)
        local num = tonumber(value)
        if num and num < 0 then
            SlideFrictionValue = num
            if Enabled and PlrModel then
                local currentState = PlrModel:GetAttribute("State")
                if currentState == "EmotingSlide" then
                    SetFriction(SlideFrictionValue)
                end
            end
        end
    end
})
Tabs.Player:Space()
noclipCFrame = Tabs.Player:Toggle({
 Title = "Noclip CFrame",
 Desc = "Walk Passthrough walls with cframespeed",
 Flag = "noclipCFrame",
 Value = false,
 Callback = function(state)
 if state then
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService") local LocalPlayer = Players.LocalPlayer
 local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
 local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") local noclipCFrame = 1
 local noclipCFrameEnabled = false
 local movementConnection noclipCFrameEnabled = true movementConnection = RunService.RenderStepped:Connect(function()
 if Character and HumanoidRootPart then
 for _, part in pairs(Character:GetDescendants()) do
 if part:IsA("BasePart") then
 part.CanCollide = false
 end
 end local MoveDirection = Character.Humanoid.MoveDirection
 if MoveDirection.Magnitude > 0 then
 HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + MoveDirection * (noclipCFrame / 10)
 end
 end
 end) LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
 Character = NewCharacter
 HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
 end) getgenv().noclipCFrameConnection = movementConnection
 else
 if getgenv().noclipCFrameConnection then
 getgenv().noclipCFrameConnection:Disconnect()
 getgenv().noclipCFrameConnection = nil
 end local Players = game:GetService("Players")
 local LocalPlayer = Players.LocalPlayer
 local Character = LocalPlayer.Character if Character then
 for _, part in pairs(Character:GetDescendants()) do
 if part:IsA("BasePart") then
 part.CanCollide = true
 end
 end
 end
 end
 end
})
NoclipLinearVelocity = Tabs.Player:Toggle({
    Title = "Noclip LinearVelocity",
    Desc = "Require Set Humanoid walkspeed to use this. Enable This may contain bad physic",
    Flag = "NoclipLinearVelocity",
    Value = false,
    Callback = function(state)
        if state then
            Players = game:GetService("Players")
            RunService = game:GetService("RunService")
            LocalPlayer = Players.LocalPlayer
            
            connections = {}
            
            function setupNoclip(character)
                if not character then return end
                
                humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
                if not humanoidRootPart then return end
                
                -- Use GetChildren()[17] to find LinearVelocity
                linearVelocity = nil
                if #humanoidRootPart:GetChildren() >= 17 then
                    linearVelocity = humanoidRootPart:GetChildren()[17]
                    if linearVelocity and linearVelocity:IsA("LinearVelocity") then
                        linearVelocity.Enabled = false
                        linearVelocity.MaxForce = 0
                    end
                end
                
                function disableCollision()
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                
                disableCollision()
                
                connection = RunService.RenderStepped:Connect(disableCollision)
                table.insert(connections, connection)
                
                charRemovingConnection = character.Destroying:Connect(function()
                    if connection and connection.Connected then
                        connection:Disconnect()
                    end
                    if charRemovingConnection and charRemovingConnection.Connected then
                        charRemovingConnection:Disconnect()
                    end
                end)
                table.insert(connections, charRemovingConnection)
            end
            
            character = LocalPlayer.Character
            if character then
                setupNoclip(character)
            end
            
            charAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
                setupNoclip(newChar)
            end)
            table.insert(connections, charAddedConnection)
            
            getgenv().NoclipLinearVelocityConnections = connections
            
        else
            if getgenv().NoclipLinearVelocityConnections then
                for _, connection in pairs(getgenv().NoclipLinearVelocityConnections) do
                    if connection and connection.Connected then
                        connection:Disconnect()
                    end
                end
                getgenv().NoclipLinearVelocityConnections = nil
            end
            
            Players = game:GetService("Players")
            LocalPlayer = Players.LocalPlayer
            character = LocalPlayer.Character
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
                
                humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    -- Use GetChildren()[17] to find LinearVelocity when disabling
                    if #humanoidRootPart:GetChildren() >= 17 then
                        linearVelocity = humanoidRootPart:GetChildren()[17]
                        if linearVelocity and linearVelocity:IsA("LinearVelocity") then
                            linearVelocity.Enabled = true
                            linearVelocity.MaxForce = 400000
                        end
                    end
                end
            end
        end
    end
}) 
player = game:GetService("Players").LocalPlayer
humanoidSpeed = 0
humanoidConnection = nil

function updateHumanoidSpeed()
    if humanoidConnection then
        humanoidConnection:Disconnect()
        humanoidConnection = nil
    end
    
    character = player.Character
    if not character then return end
    
    humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    if humanoidSpeed ~= 0 then
        originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = originalWalkSpeed + humanoidSpeed
        
        humanoidConnection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed == originalWalkSpeed then
                humanoid.WalkSpeed = originalWalkSpeed + humanoidSpeed
            end
        end)
    end
end

function onCharacterAdded(character)
    task.wait(0.5)
    updateHumanoidSpeed()
end

if player.Character then
    updateHumanoidSpeed()
end

player.CharacterAdded:Connect(onCharacterAdded)

Tabs.Player:Space()
 
Tabs.Player:Input({
    Title = "Humanoid.WalkSpeed",
    Value = "0",
    Callback = function(value)
        newSpeed = tonumber(value) or 0
        humanoidSpeed = newSpeed
        updateHumanoidSpeed()
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
local currentSettings = {
 Speed = "1500",
 JumpCap = "1",
 AirStrafeAcceleration = "187"
}
local appliedOnce = false
local playerModelPresent = false
local gameStatsPath = workspace:WaitForChild("Game"):WaitForChild("Stats")
getgenv().ApplyMode = "Not Optimized"
local requiredFields = {
 Friction = true,
 AirStrafeAcceleration = true,
 JumpHeight = true,
 RunDeaccel = true,
 JumpSpeedMultiplier = true,
 JumpCap = true,
 SprintCap = true,
 WalkSpeedMultiplier = true,
 BhopEnabled = true,
 Speed = true,
 AirAcceleration = true,
 RunAccel = true,
 SprintAcceleration = true
}

function hasAllFields(tbl)
 if type(tbl) ~= "table" then return false end
 for field, _ in pairs(requiredFields) do
 if rawget(tbl, field) == nil then return false end
 end
 return true
end

function getConfigTables()
 local tables = {}
 for _, obj in ipairs(getgc(true)) do
 local success, result = pcall(function()
 if hasAllFields(obj) then return obj end
 end)
 if success and result then
 table.insert(tables, result)
 end
 end
 return tables
end

function applyToTables(callback)
 local targets = getConfigTables()
 if #targets == 0 then return end
 
 if getgenv().ApplyMode == "Optimized" then
 task.spawn(function()
 for i, tableObj in ipairs(targets) do
 if tableObj and typeof(tableObj) == "table" then
 pcall(callback, tableObj)
 end
 
 if i % 3 == 0 then
 task.wait()
 end
 end
 end)
 else
 for i, tableObj in ipairs(targets) do
 if tableObj and typeof(tableObj) == "table" then
 pcall(callback, tableObj)
 end
 end
 end
end

function applyStoredSettings()
 local settings = {
 {field = "Speed", value = tonumber(currentSettings.Speed)},
 {field = "JumpCap", value = tonumber(currentSettings.JumpCap)},
 {field = "AirStrafeAcceleration", value = tonumber(currentSettings.AirStrafeAcceleration)}
 }
 
 for _, setting in ipairs(settings) do
 if setting.value and tostring(setting.value) ~= "1500" and tostring(setting.value) ~= "1" and tostring(setting.value) ~= "187" then
 applyToTables(function(obj)
 obj[setting.field] = setting.value
 end)
 end
 end
end

function applySettingsWithDelay()
 if not playerModelPresent or appliedOnce then
 return
 end
 
 appliedOnce = true
 
 local settings = {
 {field = "Speed", value = tonumber(currentSettings.Speed), delay = math.random(1, 14)},
 {field = "JumpCap", value = tonumber(currentSettings.JumpCap), delay = math.random(1, 14)},
 {field = "AirStrafeAcceleration", value = tonumber(currentSettings.AirStrafeAcceleration), delay = math.random(1, 14)}
 }
 
 for _, setting in ipairs(settings) do
 if setting.value and tostring(setting.value) ~= "1500" and tostring(setting.value) ~= "1" and tostring(setting.value) ~= "187" then
 task.spawn(function()
 task.wait(setting.delay)
 applyToTables(function(obj)
 obj[setting.field] = setting.value
 end)
 end)
 end
 end
end

function isPlayerModelPresent()
 local GameFolder = workspace:FindFirstChild("Game")
 local PlayersFolder = GameFolder and GameFolder:FindFirstChild("Players")
 return PlayersFolder and PlayersFolder:FindFirstChild(player.Name) ~= nil
end
Tabs.Player:Section({ Title = "Modifications" })

function createValidatedInput(config)
 return function(input)
 local val = tonumber(input)
 if not val then return end if config.min and val < config.min then return end
 if config.max and val > config.max then return end currentSettings[config.field] = tostring(val)
 applyToTables(function(obj)
 obj[config.field] = val
 end)
 end
end

SpeedInput = Tabs.Player:Input({
 Title = "Set Speed",
 Flag = "SpeedInput",
 Icon = "speedometer",
 Placeholder = "Default 1500",
 Value = currentSettings.Speed,
 Callback = createValidatedInput({
 field = "Speed",
 min = 0,
 max = 100008888
 })
})
Tabs.Player:Space()

JumpCapInput = Tabs.Player:Input({
 Title = "Set Jump Cap",
 Flag = "JumpCapInput",
 Icon = "chevrons-up",
 Placeholder = "Default 1",
 Value = currentSettings.JumpCap,
 Callback = createValidatedInput({
 field = "JumpCap",
 min = 0.1,
 max = 5088888
 })
})
Tabs.Player:Space()

StrafeInput = Tabs.Player:Input({
 Title = "Strafe Acceleration",
 Flag = "StrafeInput",
 Icon = "wind",
 Placeholder = "Default 187",
 Value = currentSettings.AirStrafeAcceleration,
 Callback = createValidatedInput({
 field = "AirStrafeAcceleration",
 min = 1,
 max = 1000888888
 })
})

ApplyMethodDropdown = Tabs.Player:Dropdown({
 Title = "Select Apply Method",
 Flag = "ApplyMethodDropdown",
 Values = { "Not Optimized", "Optimized" },
 Multi = false,
 Default = getgenv().ApplyMode,
 Callback = function(value)
 getgenv().ApplyMode = value
 end
})
Tabs.Player:Section({ Title = "Emote Speed" })

originalEmoteSpeeds = {}
itemsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Items")
if itemsFolder then
emotesFolder = itemsFolder:FindFirstChild("Emotes")
if emotesFolder then
for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
if emoteModule:IsA("ModuleScript") then
success, emoteData = pcall(require, emoteModule)
if success and emoteData and emoteData.EmoteInfo then
originalEmoteSpeeds[emoteModule.Name] = emoteData.EmoteInfo.SpeedMult
end
end
end
end
end

function applyEmoteSpeed(speedValue)
if not itemsFolder then return end
emotesFolder = itemsFolder:FindFirstChild("Emotes")
if not emotesFolder then return end

for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
if emoteModule:IsA("ModuleScript") then
success, emoteData = pcall(require, emoteModule)
if success and emoteData and emoteData.EmoteInfo and emoteData.EmoteInfo.SpeedMult ~= 0 then
emoteData.EmoteInfo.SpeedMult = speedValue
end
end
end
end

function restoreOriginalEmoteSpeeds()
if not itemsFolder then return end
emotesFolder = itemsFolder:FindFirstChild("Emotes")
if not emotesFolder then return end

for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
if emoteModule:IsA("ModuleScript") then
originalSpeed = originalEmoteSpeeds[emoteModule.Name]
if originalSpeed then
success, emoteData = pcall(require, emoteModule)
if success and emoteData and emoteData.EmoteInfo then
emoteData.EmoteInfo.SpeedMult = originalSpeed
end
end
end
end
end

local movementTables = nil

function getMatchingTables()
local matched = {}
for _, obj in pairs(getgc(true)) do
if typeof(obj) == "table" then
local ok = true
for field in pairs(requiredFields) do
if rawget(obj, field) == nil then
ok = false
break
end
end
if ok then
table.insert(matched, obj)
end
end
end
return matched
end

function findMovementTables()
if movementTables and #movementTables > 0 then
return movementTables
end
movementTables = getMatchingTables()
return movementTables
end

function applySpeedMultiplier(speedMultiplier)
local targets = findMovementTables()
if #targets == 0 then
return
end
for _, tableObj in ipairs(targets) do
if tableObj and typeof(tableObj) == "table" then
pcall(function()
tableObj.WalkSpeedMultiplier = speedMultiplier
end)
end
end
end

function getPlayerObj()
local gamePlayers = workspace.Game and workspace.Game.Players
if not gamePlayers then return nil end
return gamePlayers:FindFirstChild(player.Name)
end

playerObj = nil
connection = nil

function isEmotingState(state)
return state == "Emoting" 
or state == "EmotingAir" 
or state == "EmotingSlide" 
or state == "EmoteSwimming" 
or state == "EmotingSlideAir"
end

function setupConnection(obj)
if connection then 
connection:Disconnect() 
connection = nil
end
playerObj = obj
if not obj then 
movementTables = nil
return 
end

movementTables = nil

function onStateChanged()
local state = obj:GetAttribute("State")
local targetSpeed = isEmotingState(state) and emotingSpeed or 1
applySpeedMultiplier(targetSpeed)
end

onStateChanged()
connection = obj:GetAttributeChangedSignal("State"):Connect(onStateChanged)
end

emotingSpeed = 1

function resetMultiplierSpeed()
emotingSpeed = 1
applySpeedMultiplier(1)
movementTables = nil
end

EmoteSpeedModeDropdown = Tabs.Player:Dropdown({
Title = "Emote speed mode",
Flag = "EmoteSpeedModeDropdown",
Values = {"Nah", "Legit", "Multiplier speed"},
Value = "Nah",
Callback = function(value)
if value == "Nah" then
resetMultiplierSpeed()
restoreOriginalEmoteSpeeds()
if connection then 
connection:Disconnect() 
connection = nil
end
playerObj = nil
movementTables = nil
elseif value == "Multiplier speed" then
restoreOriginalEmoteSpeeds()
movementTables = nil
setupConnection(getPlayerObj())
task.spawn(function()
while EmoteSpeedModeDropdown.Value == "Multiplier speed" do
task.wait(2)
local current = getPlayerObj()
if current ~= playerObj then
setupConnection(current)
end
end
end)
elseif value == "Legit" then
resetMultiplierSpeed()
if connection then 
connection:Disconnect() 
connection = nil
end
playerObj = nil
movementTables = nil
local speedValue = featureStates.EmoteSpeedValue or 2
applyEmoteSpeed(speedValue)
end
end
})

EmoteSpeedInput = Tabs.Player:Input({
Title = "Emote Speed Value",
Flag = "EmoteSpeedInput",
Placeholder = "1500",
NumbersOnly = true,
Callback = function(value)
local num = tonumber(value)
if num and num > 0 then
featureStates.EmoteSpeedValue = num
if EmoteSpeedModeDropdown.Value == "Legit" then
local appliedValue = num / 1000
applyEmoteSpeed(appliedValue)
elseif EmoteSpeedModeDropdown.Value == "Multiplier speed" then
local appliedValue = num / 1000
emotingSpeed = appliedValue
if playerObj then
local state = playerObj:GetAttribute("State")
local targetSpeed = isEmotingState(state) and emotingSpeed or 1
applySpeedMultiplier(targetSpeed)
end
end
end
end
})

ApplyUnwalkableButton = Tabs.Player:Button({
Title = "Apply Speed unwalkable Emote",
Callback = function()
if not itemsFolder then return end

emotesFolder = itemsFolder:FindFirstChild("Emotes")
if not emotesFolder then return end

local speedValue = featureStates.EmoteSpeedValue or 2

for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
if emoteModule:IsA("ModuleScript") then
success, emoteData = pcall(require, emoteModule)
if success and emoteData and emoteData.EmoteInfo and emoteData.EmoteInfo.SpeedMult == 0 then
emoteData.EmoteInfo.SpeedMult = speedValue
end
end
end
end
})
 
ResetEmoteSpeedButton = Tabs.Player:Button({
Title = "Reset Emote Speed",
Desc= "Having Trouble? reset the speed or rejoin",
Callback = function()
restoreOriginalEmoteSpeeds()
resetMultiplierSpeed()
if connection then
connection:Disconnect()
connection = nil
end
playerObj = nil
movementTables = nil
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

if model:GetAttribute("IsEnemy") then return true end
if model:GetAttribute("IsNPC") then return true end
if humanoid:GetAttribute("Team") == "Nextbot" then return true end
if model:FindFirstChild("NPC") or model:FindFirstChild("Nextbot") then return true end

local NPCs = workspace:FindFirstChild("NPCs")
if NPCs and model:IsDescendantOf(NPCs) then return true end

return false
end

function getAllTargets()
local targets = {}

for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
table.insert(targets, {type = "Player", object = player})
end
end

local NPCs = workspace:FindFirstChild("NPCs")
if NPCs then
for _, model in ipairs(NPCs:GetChildren()) do
if isEnemyNPC(model) then
table.insert(targets, {type = "NPC", object = model})
end
end
end

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
else
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
Tabs.Combat:Space()

Tabs.Combat:Button({
 Title = "Visual Infinite ammo🤑",
 Desc = "អត់ចេះអស់គ្រាប់🗿✌️",
 Callback = function()
 local ReplicatedStorage = game:GetService("ReplicatedStorage")

 function makeInfiniteAmmo()
 local toolInfoModule = ReplicatedStorage.Modules.Character.CharacterTable.CharacterController.Local.HUD.FrameModules.ToolInfo
 local originalModule = require(toolInfoModule) local originalUpdateAmounts = originalModule.UpdateAmounts
 originalModule.UpdateAmounts = function(self, amounts)
 if amounts then
 for _, amountInfo in pairs(amounts) do
 if amountInfo.Current then
 amountInfo.Current = math.huge
 end
 if amountInfo.Reserve then
 amountInfo.Reserve = math.huge
 end
 if amountInfo.MaxReserve then
 amountInfo.MaxReserve = math.huge
 end
 end
 end
 return originalUpdateAmounts(self, amounts)
 end local originalUpdateBullets = originalModule.UpdateBullets
 originalModule.UpdateBullets = function(self, frame, oldAmount, newAmount)
 return originalUpdateBullets(self, frame, 0, 6)
 end
 end

 function modifyWeaponData()
 local rpgModule = ReplicatedStorage.Tools.RPG
 if rpgModule then
 local rpgData = require(rpgModule)
 
 for _, taskData in ipairs(rpgData.Tasks) do
 if taskData.ResourceInfo and taskData.ResourceInfo.Type == "Clip" then
 taskData.ResourceInfo.Cap = 676967
 taskData.ResourceInfo.Reserve = math.huge 
 end
 end
 end
 end

 function hookAllWeapons()
 for _, tool in pairs(ReplicatedStorage.Tools:GetChildren()) do
 local success, toolData = pcall(require, tool)
 if success and toolData.Tasks then
 for _, taskData in ipairs(toolData.Tasks) do
 if taskData.ResourceInfo then
 if taskData.ResourceInfo.Type == "Clip" then
 taskData.ResourceInfo.Cap = 676967
 taskData.ResourceInfo.Reserve = 676967
 elseif taskData.ResourceInfo.Max then
 taskData.ResourceInfo.Max = 676967
 end
 end
 end
 end
 end
 end

 makeInfiniteAmmo()
 modifyWeaponData()
 hookAllWeapons()
 end
})

Tabs.Combat:Space()

Tabs.Combat:Button({
 Title = "Visual No Shoot Delay",
 Desc = "បាញ់លើន🗿✌️",
 Callback = function()
 for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do 
 if v:IsA("ModuleScript") then 
 pcall(function() 
 local d = require(v) 
 if type(d) == "table" then 
 function f(t) 
 if typeof(t) == "table" then 
 if t.Cooldown and type(t.Cooldown) == "number" and t.Cooldown > 0 then 
 t.Cooldown = 0
 end 
 for _, x in pairs(t) do 
 if typeof(x) == "table" then 
 f(x) 
 end 
 end 
 end 
 end 
 f(d) 
 end 
 end) 
 end 
 end
 end
})

Tabs.Combat:Space()

Tabs.Combat:Button({
 Title = "Visual No Reload Delay",
 Callback = function()
 local ReplicatedStorage = game:GetService("ReplicatedStorage")

 local modifiedWeapons = {}

 function modifyWeaponStats(weaponName, moduleData)
 if modifiedWeapons[weaponName] then
 return
 end local changesMade = false function setFastCooldown(info)
 if info and info.Cooldown and info.Cooldown > 0.1 then
 info.Cooldown = 0.1
 changesMade = true
 end
 end if moduleData.Info and moduleData.Info.Cooldown then
 setFastCooldown(moduleData.Info)
 end -- Tasks
 if moduleData.Tasks then
 for _, task in ipairs(moduleData.Tasks) do
 if task.Info and task.Info.Cooldown then
 setFastCooldown(task.Info)
 end -- Reload functions
 if task.Functions then
 for _, func in ipairs(task.Functions) do
 if func.Name == "Reload" or (func.Keybinds and table.find(func.Keybinds, "Reload")) then
 if func.Activations then
 for _, activation in ipairs(func.Activations) do
 if activation.Methods then
 for _, method in ipairs(activation.Methods) do
 if method.Info then
 setFastCooldown(method.Info)
 end
 end
 end
 end
 end
 end
 end
 end if task.AutomaticFunctions then
 for _, autoFunc in ipairs(task.AutomaticFunctions) do
 if autoFunc.Methods then
 for _, method in ipairs(autoFunc.Methods) do
 if method.Info then
 setFastCooldown(method.Info)
 end
 end
 end
 end
 end
 end
 end if changesMade then
 modifiedWeapons[weaponName] = true
 end
 end

 local searchLocations = {
 ReplicatedStorage,
 workspace,
 game:GetService("ServerStorage")
 }

 for _, location in ipairs(searchLocations) do
 for _, obj in ipairs(location:GetDescendants()) do
 if obj:IsA("ModuleScript") then
 local path = obj:GetFullName()
 if not string.find(path, "Character") and
 not string.find(path, "UI") and
 not string.find(path, "HUD") and
 not string.find(path, "Camera") and
 not string.find(path, "Controller") then local success, moduleData = pcall(require, obj)
 if success and type(moduleData) == "table" then
 local weaponName = moduleData.HUD and moduleData.HUD.Name or obj.Name
 
 local isWeapon = false
 if moduleData.HUD and moduleData.HUD.Name then
 isWeapon = true
 elseif moduleData.Tasks then
 for _, task in ipairs(moduleData.Tasks) do
 if task.ResourceInfo and task.ResourceInfo.Type == "Clip" then
 isWeapon = true
 break
 end
 end
 end
 
 if isWeapon then
 modifyWeaponStats(weaponName, moduleData)
 end
 end
 end
 end
 end
 end

 for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
 if obj:IsA("ModuleScript") and obj.Name:match("%u") then
 local success, moduleData = pcall(require, obj)
 if success and type(moduleData) == "table" then
 local weaponName = obj.Name
 modifyWeaponStats(weaponName, moduleData)
 end
 end
 end
 end
})

Tabs.Combat:Space()
 -- Auto Tab
 Tabs.Auto:Section({ Title = "Auto", TextSize = 40 })
 local player = game:GetService("Players").LocalPlayer
local Event = game:GetService("ReplicatedStorage").Events.Player.ChangePlayerMode
local monitoring = false
local humanoidConnections = {}
local lastJoinTime = 0
local joinCooldown = 3 
function cleanupHumanoidConnections()
    for _, connection in pairs(humanoidConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    humanoidConnections = {}
end
function attemptAutoJoin()
    local currentTime = tick()
    if currentTime - lastJoinTime < joinCooldown then
        return
    end
    lastJoinTime = currentTime
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            return
        end
    end
    Event:FireServer(true)
end
function onHumanoidHealthChanged(health)
    if health <= 0 then
        task.wait(0.5)
        local character = player.Character
        if not character then
            attemptAutoJoin()
            return
        end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            attemptAutoJoin()
        end
    end
end
function monitorCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        cleanupHumanoidConnections()
        local healthConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            onHumanoidHealthChanged(humanoid.Health)
        end)
        table.insert(humanoidConnections, healthConnection)
        onHumanoidHealthChanged(humanoid.Health)
        local diedConnection = humanoid.Died:Connect(function()
            attemptAutoJoin()
        end)
        table.insert(humanoidConnections, diedConnection)
    end
end
function monitorPlayer()
    while monitoring do
        task.wait(0.5)
        if not player.Character then
            attemptAutoJoin()
        else
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                attemptAutoJoin()
            end
        end
    end
end
function checkRoundStart()
    local gameFolder = workspace:FindFirstChild("Game")
    if not gameFolder then return end
    local statsFolder = gameFolder:FindFirstChild("Stats")
    if not statsFolder then return end
    local roundStart = statsFolder:FindFirstChild("RoundStart")
    if roundStart and roundStart.Value == true then
        attemptAutoJoin()
    end
end
function AutojoinStartMonitoring()
    if monitoring then return end
    monitoring = true
    local gameFolder = workspace:FindFirstChild("Game")
    if gameFolder then
        local statsFolder = gameFolder:FindFirstChild("Stats")
        if statsFolder then
            local roundStart = statsFolder:FindFirstChild("RoundStart")
            if roundStart then
                roundStart:GetPropertyChangedSignal("Value"):Connect(checkRoundStart)
            end
        end
    end
    if player.Character then
        monitorCharacter(player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5) 
        monitorCharacter(character)
    end)
    spawn(monitorPlayer)
end
function AutojoinstopMonitoring()
    monitoring = false
    cleanupHumanoidConnections()
end
 toggleAutoJoin = Tabs.Auto:Toggle({
    Title = "Auto Join",
    Value = false,
    Callback = function(state)
        if state then
            AutojoinStartMonitoring()
        else
            AutojoinstopMonitoring()
        end
    end
})
 game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.JumpReact:Fire()
game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.EndJump:Fire()

getgenv().autoJumpType = "Bounce"
getgenv().bhopMode = "Acceleration"
getgenv().bhopAccelValue = -0.5
getgenv().bhopHoldActive = false
getgenv().autoJumpEnabled = false
getgenv().jumpCooldown = 0.7
featureStates = featureStates or {}
featureStates.Bhop = false
featureStates.BhopHold = false
featureStates.AutoCrouch = false
featureStates.AutoCrouchMode = "Air"
featureStates.AutoCarry = false

player = game:GetService("Players").LocalPlayer
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
Players = game:GetService("Players")
Tabs = Tabs or {Auto = {}}

isMobile = isMobile or UserInputService.TouchEnabled

bhopConnection = nil
bhopLoaded = false
characterConnection = nil
frictionTables = {}

Character = nil
Humanoid = nil
HumanoidRootPart = nil
LastJump = 0

GROUND_CHECK_DISTANCE = 3.5
MAX_SLOPE_ANGLE = 45
AIR_RANGE = 0.1

findFrictionTables = function()
frictionTables = {}
for _, t in pairs(getgc(true)) do
if type(t) == "table" and rawget(t, "Friction") then
table.insert(frictionTables, {obj = t, original = t.Friction})
end
end
end

setFriction = function(value)
for _, e in ipairs(frictionTables) do
if e.obj and type(e.obj) == "table" and rawget(e.obj, "Friction") then
e.obj.Friction = value
end
end
end

resetBhopFriction = function()
for _, e in ipairs(frictionTables) do
if e.obj and type(e.obj) == "table" and rawget(e.obj, "Friction") then
e.obj.Friction = e.original
end
end
frictionTables = {}
end

applyBhopFriction = function()
if getgenv().bhopMode == "Acceleration" then
findFrictionTables()
if #frictionTables > 0 then
setFriction(getgenv().bhopAccelValue or -0.5)
end
else
resetBhopFriction()
end
end

IsOnGround = function()
if not Character or not HumanoidRootPart or not Humanoid then return false end

state = Humanoid:GetState()
if state == Enum.HumanoidStateType.Jumping or 
state == Enum.HumanoidStateType.Freefall or
state == Enum.HumanoidStateType.Swimming then
return false
end

raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
raycastParams.FilterDescendantsInstances = {Character}
raycastParams.IgnoreWater = true

rayOrigin = HumanoidRootPart.Position
rayDirection = Vector3.new(0, -GROUND_CHECK_DISTANCE, 0)
raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

if not raycastResult then return false end

surfaceNormal = raycastResult.Normal
angle = math.deg(math.acos(surfaceNormal:Dot(Vector3.new(0, 1, 0))))

return angle <= MAX_SLOPE_ANGLE
end

updateBhop = function()
if not bhopLoaded then return end

character = player.Character
humanoid = character and character:FindFirstChild("Humanoid")
if not character or not humanoid then
return
end

isBhopActive = getgenv().autoJumpEnabled or getgenv().bhopHoldActive

if isBhopActive then
now = tick()
if IsOnGround() and (now - LastJump) > getgenv().jumpCooldown then
if getgenv().autoJumpType == "Realistic" then
game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.JumpReact:Fire()
task.wait(0.1)
game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.EndJump:Fire()
else
humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
LastJump = now
end
end
end

loadBhop = function()
if bhopLoaded then return end

bhopLoaded = true

if bhopConnection then
bhopConnection:Disconnect()
end
bhopConnection = RunService.Heartbeat:Connect(updateBhop)
applyBhopFriction()
end

unloadBhop = function()
if not bhopLoaded then return end

bhopLoaded = false

if bhopConnection then
bhopConnection:Disconnect()
bhopConnection = nil
end

getgenv().bhopHoldActive = false
resetBhopFriction()
end

checkBhopState = function()
shouldLoad = getgenv().autoJumpEnabled or getgenv().bhopHoldActive

if shouldLoad then
loadBhop()
else
unloadBhop()
end
end

reapplyBhopOnRespawn = function()
if getgenv().autoJumpEnabled or getgenv().bhopHoldActive then
wait(0.5)
applyBhopFriction()
checkBhopState()
end
end

setupJumpButton = function()
success, err = pcall(function()
touchGui = player:WaitForChild("PlayerGui", 5):WaitForChild("TouchGui", 5)
if not touchGui then return end
touchControlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
if not touchControlFrame then return end
jumpButton = touchControlFrame:WaitForChild("JumpButton", 5)
if not jumpButton then return end

jumpButton.MouseButton1Down:Connect(function()
if featureStates.BhopHold then
getgenv().bhopHoldActive = true
checkBhopState()
end
end)

jumpButton.MouseButton1Up:Connect(function()
getgenv().bhopHoldActive = false
checkBhopState()
end)
end)
end

setupJumpButton()

RunService.Heartbeat:Connect(function()
if not Character or not Character:IsDescendantOf(workspace) then
Character = player.Character or player.CharacterAdded:Wait()
if Character then
Humanoid = Character:FindFirstChildOfClass("Humanoid")
HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
else
Humanoid = nil
HumanoidRootPart = nil
end
end
end)

if characterConnection then
characterConnection:Disconnect()
end
characterConnection = player.CharacterAdded:Connect(function(character)
Character = character
Humanoid = character:WaitForChild("Humanoid")
HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
setupJumpButton()
reapplyBhopOnRespawn()
end)

Tabs.Auto:Space()
AutoJumpTypeDropdown = Tabs.Auto:Dropdown({
Title = "Auto Jump type",
Flag = "AutoJumpTypeDropdown",
Values = {"Bounce", "Realistic"},
Value = "Bounce",
Callback = function(value)
getgenv().autoJumpType = value
end
})

BhopToggle = Tabs.Auto:Toggle({
Title = "Bhop",
Flag = "BhopToggle",
Value = false,
Callback = function(state)
featureStates.Bhop = state
getgenv().autoJumpEnabled = state

checkBhopState()
end
})

ButtonLib.Create:Toggle({
Text = "Bunny Hop",
Flag = "BunnyHopToggle",
Default = false,
Visible = false,
Callback = function(s) 
if BhopToggle then
BhopToggle:Set(s)
end
end
}).Position = UDim2.new(0.5, -125, 0.4, 0)

ShowBunnyHopButtonToggle = Tabs.Auto:Toggle({
Title = "Show Bunny Hop Button",
Flag = "ShowBunnyHopButton",
Value = false,
Callback = function(state)
featureStates.ShowBunnyHopButton = state

if _G.DarahubLibBtn and _G.DarahubLibBtn.BunnyHopToggle then
_G.DarahubLibBtn.BunnyHopToggle.Visible = state
end
end
})
BhopHoldToggle = Tabs.Auto:Toggle({
Title = "Bhop (Hold Space/Jump)",
Flag = "BhopHoldToggle",
Value = false,
Callback = function(state)
featureStates.BhopHold = state
if not state then
getgenv().bhopHoldActive = false
checkBhopState()
end
end
})

BhopModeDropdown = Tabs.Auto:Dropdown({
Title = "Bhop Mode",
Flag = "BhopModeDropdown",
Values = {"Acceleration", "No Acceleration"},
Value = "Acceleration",
Callback = function(value)
getgenv().bhopMode = value
checkBhopState()
end
})

BhopAccelInput = Tabs.Auto:Input({
Title = "Bhop Acceleration (Negative Only)",
Flag = "BhopAccelInput",
Placeholder = "-0.5",
Numeric = true,
Callback = function(value)
if tostring(value):sub(1, 1) == "-" then
n = tonumber(value)
if n then
getgenv().bhopAccelValue = n
if getgenv().autoJumpEnabled or getgenv().bhopHoldActive then
applyBhopFriction()
end
end
end
end
})

JumpCooldownInput = Tabs.Auto:Input({
Title = "Jump Cooldown (Seconds)",
Flag = "JumpCooldownInput",
Placeholder = "0.7",
Numeric = true,
Callback = function(value)
n = tonumber(value)
if n and n > 0 then
getgenv().jumpCooldown = n
end
end
})

Players.PlayerRemoving:Connect(function(leavingPlayer)
if leavingPlayer == player then
unloadBhop()
if characterConnection then
characterConnection:Disconnect()
end
end
end)

checkBhopState()

local previousCrouchState = false
local spamDown = true
local previousAutoCrouch = false
local crouchConnection = nil

function fireKeybind(down, key)
local ohTable = {
["Down"] = down,
["Key"] = key
}
local event = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Events"):WaitForChild("temporary_events"):WaitForChild("UseKeybind")
event:Fire(ohTable)
end

function setupAutoCrouchListeners()
if crouchConnection then crouchConnection:Disconnect() end
crouchConnection = RunService.Heartbeat:Connect(function()
local autoOn = featureStates.AutoCrouch
local mode = featureStates.AutoCrouchMode

if previousAutoCrouch and not autoOn then
local character = Players.LocalPlayer.Character
if character and character:FindFirstChild("Humanoid") then
if mode == "Normal" then
fireKeybind(false, "Crouch")
end
end
end

previousAutoCrouch = autoOn

if not autoOn then return end

local character = Players.LocalPlayer.Character
if not character or not character:FindFirstChild("Humanoid") then return end

local humanoid = character.Humanoid

if mode == "Spam" then
fireKeybind(spamDown, "Crouch")
spamDown = not spamDown
elseif mode == "Normal" then
fireKeybind(true, "Crouch")
else
local isAir = (humanoid.FloorMaterial == Enum.Material.Air) and (humanoid:GetState() ~= Enum.HumanoidStateType.Seated)
local shouldCrouch = (mode == "Air" and isAir) or (mode == "Ground" and not isAir)
if shouldCrouch ~= previousCrouchState then
fireKeybind(shouldCrouch, "Crouch")
previousCrouchState = shouldCrouch
end
end
end)

Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
previousCrouchState = false
spamDown = true
end)
end

setupAutoCrouchListeners()

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

AutoCarryConnection = nil

function startAutoCarry()
AutoCarryConnection = RunService.Heartbeat:Connect(function()
if not featureStates.AutoCarry then return end
local char = player.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp then
for _, other in ipairs(Players:GetPlayers()) do
if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
local dist = (hrp.Position - other.Character.HumanoidRootPart.Position).Magnitude
if dist <= 20 then
local args = { "Carry", [3] = other.Name }
pcall(function()
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact"):FireServer(unpack(args))
end)
task.wait(0.01)
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
local reviveRange = 10
local loopDelay = 0.15
local reviveLoopHandle = nil
local interactEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact")
local featureStates = featureStates or {}
featureStates.FastReviveMethod = "Interact"
featureStates.reviveHook = nil
featureStates.interactHookActive = false
function startAutoRevive()
 if featureStates.FastReviveMethod == "Auto" then
 if reviveLoopHandle then return end reviveLoopHandle = task.spawn(function()
 while featureStates.FastRevive do
 local LocalPlayer = Players.LocalPlayer
 if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
 local myHRP = LocalPlayer.Character.HumanoidRootPart
 for _, pl in ipairs(Players:GetPlayers()) do
 if pl ~= LocalPlayer then
 local char = pl.Character
 if char and char:FindFirstChild("HumanoidRootPart") then
 if isPlayerDowned(pl) then
 local hrp = char.HumanoidRootPart
 local success, dist = pcall(function()
 return (myHRP.Position - hrp.Position).Magnitude
 end)
 if success and dist and dist <= reviveRange then
 pcall(function()
 interactEvent:FireServer("Revive", true, pl.Name)
 end)
 end
 end
 end
 end
 end
 end
 task.wait(loopDelay)
 end
 reviveLoopHandle = nil
 end)
 elseif featureStates.FastReviveMethod == "Interact" then
 if not featureStates.interactHookActive then
 local localPlayer = Players.LocalPlayer
 local eventsFolder = localPlayer.PlayerScripts:WaitForChild("Events")
 local tempEventsFolder = eventsFolder:WaitForChild("temporary_events")
 local useKeybind = tempEventsFolder:WaitForChild("UseKeybind") local connection = useKeybind.Event:Connect(function(...)
 local args = {...}
 
 if args[1] and type(args[1]) == "table" then
 local keyData = args[1] if keyData.Key == "Interact" and keyData.Down == true and featureStates.FastRevive then
 function reviveAllPlayers()
 local ohString1 = "Revive"
 local ohBoolean2 = true
 
 for _, player in pairs(Players:GetPlayers()) do
 if player ~= localPlayer then
 local ohString3 = player.Name
 pcall(function()
 interactEvent:FireServer(ohString1, ohBoolean2, ohString3)
 end)
 -- task.wait(0.1)
 end
 end
 end task.spawn(reviveAllPlayers)
 end
 end
 end) featureStates.interactConnection = connection
 featureStates.interactHookActive = true
 end
 end
end

function stopAutoRevive()
 if reviveLoopHandle then
 task.cancel(reviveLoopHandle)
 reviveLoopHandle = nil
 end
 
 if featureStates.interactHookActive then
 if featureStates.interactConnection then
 featureStates.interactConnection:Disconnect()
 featureStates.interactConnection = nil
 end
 featureStates.interactHookActive = false
 end
end

FastReviveToggle = Tabs.Auto:Toggle({
 Title = "Fast Revive",
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

FastReviveMethodDropdown = Tabs.Auto:Dropdown({
 Title = "Fast Revive Method",
 Flag = "FastReviveMethodDropdown",
 Values = {"Auto", "Interact"},
 Value = "Interact",
 Callback = function(value)
 featureStates.FastReviveMethod = value stopAutoRevive()
 if featureStates.FastReviveMethod == "Interact" then
 featureStates.interactHookActive = false
 end if featureStates.FastRevive then
 startAutoRevive()
 end
 end
})

 Tabs.Auto:Space()
 function fireVoteServer(mapNumber)
 local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
 if eventsFolder then
 local playerFolder = eventsFolder:WaitForChild("Player", 10)
 if playerFolder then
 local voteEvent = playerFolder:WaitForChild("Vote", 10)
 if voteEvent and typeof(voteEvent) == "Instance" and voteEvent:IsA("RemoteEvent") then
 local args = {[1] = mapNumber}
 voteEvent:FireServer(unpack(args))
 end
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


 Tabs.Auto:Space()
AutoVoteModeDropdown = Tabs.Auto:Dropdown({
 Title = "Vote Mode",
 Flag = "AutoVoteModeDropdown",
 Values = {"Mode 1", "Mode 2", "Mode 3", "Mode 4"},
 Value = "Mode 1",
 Callback = function(value)
 if value == "Mode 1" then
 featureStates.SelectedVoteMode = 1
 elseif value == "Mode 2" then
 featureStates.SelectedVoteMode = 2
 elseif value == "Mode 3" then
 featureStates.SelectedVoteMode = 3
 elseif value == "Mode 4" then
 featureStates.SelectedVoteMode = 4
 end
 end
})
AutoVoteModeToggle = Tabs.Auto:Toggle({
 Title = "Auto Vote Game Mode",
 Flag = "AutoVoteModeToggle",
 Value = false,
 Callback = function(state)
 if state then
 local voteConnection
 voteConnection = RunService.Heartbeat:Connect(function()
 local voteEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("Vote")
 if voteEvent then
 if featureStates.SelectedVoteMode == 1 then
 voteEvent:FireServer(1, true)
 elseif featureStates.SelectedVoteMode == 2 then
 voteEvent:FireServer(2, true)
 elseif featureStates.SelectedVoteMode == 3 then
 voteEvent:FireServer(3, true)
 elseif featureStates.SelectedVoteMode == 4 then
 voteEvent:FireServer(4, true)
 end
 end
 end) getgenv().AutoVoteModeConnection = voteConnection
 else
 if getgenv().AutoVoteModeConnection then
 getgenv().AutoVoteModeConnection:Disconnect()
 getgenv().AutoVoteModeConnection = nil
 end
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
 end local character = player.Character
 if character then
 local humanoid = character:WaitForChild("Humanoid")
 local hrp = character:WaitForChild("HumanoidRootPart")
 
 AutoSelfReviveConnection = character:GetAttributeChangedSignal("Downed"):Connect(function()
 local isDowned = character:GetAttribute("Downed")
 if isDowned and not isReviving then
 isReviving = true if featureStates.SelfReviveMethod == "Spawnpoint" then
 if not hasRevived then
 hasRevived = true
 pcall(function()
 ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
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
 ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
 end) local newCharacter
 repeat
 newCharacter = player.Character
 task.wait()
 until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= character if newCharacter then
 local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
 if lastSavedPosition and newHRP then
 newHRP.CFrame = CFrame.new(lastSavedPosition)
 lastSavedPosition = nil
 end
 end isReviving = false
 end)
 end
 end
 end)
 end respawnConnection = player.CharacterAdded:Connect(function(newChar)
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
 ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
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
 end task.spawn(function()
 pcall(function()
 ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
 end) local freshCharacter
 repeat
 freshCharacter = player.Character
 task.wait()
 until freshCharacter and freshCharacter:FindFirstChild("HumanoidRootPart") and freshCharacter ~= newChar if freshCharacter then
 local freshHRP = freshCharacter:FindFirstChild("HumanoidRootPart")
 if lastSavedPosition and freshHRP then
 freshHRP.CFrame = CFrame.new(lastSavedPosition)
 end
 end isReviving = false
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
 ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
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
 ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
 end) local newCharacter
 repeat
 newCharacter = player.Character
 task.wait()
 until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= character if newCharacter then
 local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
 if lastSavedPosition and newHRP then
 newHRP.CFrame = CFrame.new(lastSavedPosition)
 lastSavedPosition = nil
 end
 end
 end)
 end
end
player.CharacterAdded:Connect(function()
 hasRevived = false
end)
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
 game:GetService("ReplicatedStorage").Events.Character.Whistle:FireServer()
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

local ingShown = false
local carriedPlayers = {}
local ignoreCarried = false

local function isPlayerCarried(playerModel)
return carriedPlayers[playerModel] == true
end

local CharacterController = require(game:GetService("ReplicatedStorage").Modules.Character.CharacterTable.CharacterController.Global.Rig.Carry)
local originalCarried = CharacterController.Carried
local originalCancel = CharacterController.Cancel

CharacterController.Carried = function(self, carrierTag)
local player = game:GetService("Players"):GetPlayerFromCharacter(self.Character)
if player then
carriedPlayers[self.Character] = true
end
return originalCarried(self, carrierTag)
end

CharacterController.Cancel = function(self)
carriedPlayers[self.Character] = nil
return originalCancel(self)
end

AfkFarmToggle = Tabs.Auto:Toggle({
Title = "Afk Farm",
Flag = "AfkFarmToggle",
Desc = "Automated farming with multiple options",
Value = false,
Callback = function(state)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local hrp = rootPart
local interactEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Character"):WaitForChild("Interact")
local featureStates = featureStates or {}
local AntiAFKToggle = AntiAFKToggle or { Set = function() end }
local AutoSelfReviveToggle = AutoSelfReviveToggle or { Set = function() end }
local function updateCharacterReferences()
    character = player.Character
    if character then
        rootPart = character:WaitForChild("HumanoidRootPart")
        hrp = rootPart
    end
end
player.CharacterAdded:Connect(updateCharacterReferences)
local player = game:GetService("Players").LocalPlayer
local isVIP = player:GetAttribute("VIPCommandsAccess") == true

if state then
if isVIP or warningShown then
featureStates.AfkFarm = state

if character and rootPart then
securityPart = workspace:FindFirstChild("SecurityPart")
if securityPart then
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
else
rootPart.CFrame = CFrame.new(0, 100, 0)
end
end

AntiAFKToggle:Set(true)
AntiAFKConnection = player.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

AutoSelfReviveToggle:Set(true)
if not AutoSelfReviveConnection then
local lastSavedPosition = nil
local hasRevived = false
local isReviving = false

AutoSelfReviveConnection = player.Character:GetAttributeChangedSignal("Downed"):Connect(function()
local isDowned = player.Character:GetAttribute("Downed")
if isDowned and not isReviving then
isReviving = true

if hrp then
lastSavedPosition = hrp.Position
end

task.spawn(function()
pcall(function()
ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
end)

local newCharacter
repeat
newCharacter = player.Character
task.wait()
until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= player.Character

if newCharacter then
local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
if lastSavedPosition and newHRP then
newHRP.CFrame = CFrame.new(lastSavedPosition)
end

securityPart = workspace:FindFirstChild("SecurityPart")
if securityPart then
newHRP.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
end
end

isReviving = false
end)
end
end)
end

if AfkFarmConnection then
AfkFarmConnection:Disconnect()
end

AfkFarmConnection = RunService.Heartbeat:Connect(function()
if not character or not rootPart then return end

securityPart = workspace:FindFirstChild("SecurityPart")
if not securityPart then
rootPart.CFrame = CFrame.new(0, 100, 0)
return
end

if not character:GetAttribute("Downed") then
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
end

local selectedModes = featureStates.AfkFarmModes or {}
for _, mode in ipairs(selectedModes) do
if mode == "Auto Money" then
playersInGame = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersInGame then
for _, v in pairs(playersInGame:GetChildren()) do
if v:IsA("Model") and v:GetAttribute("Downed") then
if v:FindFirstChild("RagdollConstraints") then
continue
end

if isPlayerCarried(v) then
continue
end

rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
task.wait(0.5)
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
break
end
end
end

elseif mode == "Auto Ticket" then
tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
if tickets then
activeTickets = tickets:GetChildren()
if #activeTickets > 0 then
if not currentTicket or not currentTicket.Parent then
currentTicket = activeTickets[1]
ticketProcessedTime = tick()
end

if currentTicket and currentTicket.Parent then
ticketPart = currentTicket:FindFirstChild("HumanoidRootPart")
if ticketPart then
targetPosition = ticketPart.Position + Vector3.new(0, 999, 0)
rootPart.CFrame = CFrame.new(targetPosition)

if tick() - ticketProcessedTime > 0.1 then
rootPart.CFrame = ticketPart.CFrame
end
else
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end

elseif mode == "Auto Turkey" then
npcsFolder = workspace:FindFirstChild("NPCs")
if npcsFolder then
for _, npc in ipairs(npcsFolder:GetChildren()) do
if npc:IsA("Model") and npc.Name == "Turkey" then
turkeyHrp = npc:FindFirstChild("HumanoidRootPart")
if turkeyHrp then
rootPart.CFrame = turkeyHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end

playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersFolder then
for _, model in ipairs(playersFolder:GetChildren()) do
if model:IsA("Model") and model.Name == "Turkey" then
modelHrp = model:FindFirstChild("HumanoidRootPart")
if modelHrp then
rootPart.CFrame = modelHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end
end
end
end)
else
WindUI:Popup({
Title = "<b><font color='#FF5555'>WARNING! BAN WAVE!</font></b>",
Icon = "shield-x",
Content = [[<b><font color='#FFAA00'>⚠️DO NOT USE AUTO FARM ON PUBLIC SERVER OR UNTRUSTED PRIVATE SERVER! IF YOU DON'T WANNA GET BAN!</font></b>
<font color='#4fe000'> • Be Sure Use It On Your Own Private Server To Avoid BAN!</font>
<b><font color='#FF5555'> • IF YOU KEEP CONTINUE DOING THIS YOU WILL GET BAN ANYTIME SOON!</font></b>
<b><font color='#FF5555'> 🚫 WHEN YOU GET BANNED, THERE'S NO UNBAN APPEAL!</font></b>
<font color='#FF5555'> Remember: Staff will not giving you second chance!</font>]],
Buttons = {
{
Title = "Cancel",
Callback = function() 
AfkFarmToggle:Set(false)
featureStates.AfkFarm = false
end,
Variant = "Destructive",
},
{
Title = "Continue Anyway",
Icon = "shield-check",
Callback = function() 
warningShown = true
featureStates.AfkFarm = state

if character and rootPart then
securityPart = workspace:FindFirstChild("SecurityPart")
if securityPart then
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
else
rootPart.CFrame = CFrame.new(0, 100, 0)
end
end

AntiAFKToggle:Set(true)
AntiAFKConnection = player.Idled:Connect(function()
VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
task.wait(1)
VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

AutoSelfReviveToggle:Set(true)
if not AutoSelfReviveConnection then
local lastSavedPosition = nil
local hasRevived = false
local isReviving = false

AutoSelfReviveConnection = player.Character:GetAttributeChangedSignal("Downed"):Connect(function()
local isDowned = player.Character:GetAttribute("Downed")
if isDowned and not isReviving then
isReviving = true

if hrp then
lastSavedPosition = hrp.Position
end

task.spawn(function()
pcall(function()
ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
end)

local newCharacter
repeat
newCharacter = player.Character
task.wait()
until newCharacter and newCharacter:FindFirstChild("HumanoidRootPart") and newCharacter ~= player.Character

if newCharacter then
local newHRP = newCharacter:FindFirstChild("HumanoidRootPart")
if lastSavedPosition and newHRP then
newHRP.CFrame = CFrame.new(lastSavedPosition)
end

securityPart = workspace:FindFirstChild("SecurityPart")
if securityPart then
newHRP.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
end
end

isReviving = false
end)
end
end)
end

if AfkFarmConnection then
AfkFarmConnection:Disconnect()
end

AfkFarmConnection = RunService.Heartbeat:Connect(function()
if not character or not rootPart then return end

securityPart = workspace:FindFirstChild("SecurityPart")
if not securityPart then
rootPart.CFrame = CFrame.new(0, 100, 0)
return
end

if not character:GetAttribute("Downed") then
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
end

local selectedModes = featureStates.AfkFarmModes or {}
for _, mode in ipairs(selectedModes) do
if mode == "Auto Money" then
playersInGame = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersInGame then
for _, v in pairs(playersInGame:GetChildren()) do
if v:IsA("Model") and v:GetAttribute("Downed") then
if v:FindFirstChild("RagdollConstraints") then
continue
end

if isPlayerCarried(v) then
continue
end

rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
task.wait(0.5)
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
break
end
end
end

elseif mode == "Auto Ticket" then
tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
if tickets then
activeTickets = tickets:GetChildren()
if #activeTickets > 0 then
if not currentTicket or not currentTicket.Parent then
currentTicket = activeTickets[1]
ticketProcessedTime = tick()
end

if currentTicket and currentTicket.Parent then
ticketPart = currentTicket:FindFirstChild("HumanoidRootPart")
if ticketPart then
targetPosition = ticketPart.Position + Vector3.new(0, 999, 0)
rootPart.CFrame = CFrame.new(targetPosition)

if tick() - ticketProcessedTime > 0.1 then
rootPart.CFrame = ticketPart.CFrame
end
else
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end

elseif mode == "Auto Turkey" then
npcsFolder = workspace:FindFirstChild("NPCs")
if npcsFolder then
for _, npc in ipairs(npcsFolder:GetChildren()) do
if npc:IsA("Model") and npc.Name == "Turkey" then
turkeyHrp = npc:FindFirstChild("HumanoidRootPart")
if turkeyHrp then
rootPart.CFrame = turkeyHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end

playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersFolder then
for _, model in ipairs(playersFolder:GetChildren()) do
if model:IsA("Model") and model.Name == "Turkey" then
modelHrp = model:FindFirstChild("HumanoidRootPart")
if modelHrp then
rootPart.CFrame = modelHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end
end
end
end)
end,
Variant = "Primary",
}
}
})
end
else
featureStates.AfkFarm = state

if AfkFarmConnection then
AfkFarmConnection:Disconnect()
AfkFarmConnection = nil
end
if AutoReviveConnection then
AutoReviveConnection:Disconnect()
AutoReviveConnection = nil
end
if AutoTicketFarmConnection then
AutoTicketFarmConnection:Disconnect()
AutoTicketFarmConnection = nil
end
if AutoTurkeyFarmConnection then
AutoTurkeyFarmConnection:Disconnect()
AutoTurkeyFarmConnection = nil
end
if AutoSelfReviveConnection then
AutoSelfReviveConnection:Disconnect()
AutoSelfReviveConnection = nil
end
end
end
})

AfkFarmDropdown = Tabs.Auto:Dropdown({
Title = "Afk Farm Mode",
Flag = "AfkFarmDropdown",
Desc = "Select farming methods (can choose multiple)",
Values = {"Auto Money", "Auto Ticket", "Auto Turkey"},
Multi = true,
AllowNone = true,
Value = {},
Callback = function(selected)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local hrp = rootPart
local function updateCharacterReferences()
    character = player.Character
    if character then
        rootPart = character:WaitForChild("HumanoidRootPart")
        hrp = rootPart
    end
end
player.CharacterAdded:Connect(updateCharacterReferences)
featureStates.AfkFarmModes = selected

if featureStates.AfkFarm then
if AfkFarmConnection then
AfkFarmConnection:Disconnect()
AfkFarmConnection = nil
end

AfkFarmConnection = RunService.Heartbeat:Connect(function()
if not character or not rootPart then return end

securityPart = workspace:FindFirstChild("SecurityPart")
if not securityPart then
rootPart.CFrame = CFrame.new(0, 100, 0)
return
end

if not character:GetAttribute("Downed") then
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
end

for _, mode in ipairs(selected) do
if mode == "Auto Money" then
playersInGame = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersInGame then
for _, v in pairs(playersInGame:GetChildren()) do
if v:IsA("Model") and v:GetAttribute("Downed") then
if v:FindFirstChild("RagdollConstraints") then
continue
end

if isPlayerCarried(v) then
continue
end

rootPart.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
ReplicatedStorage.Events.Character.Interact:FireServer("Revive", true, v)
task.wait(0.5)
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
break
end
end
end

elseif mode == "Auto Ticket" then
tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
if tickets then
activeTickets = tickets:GetChildren()
if #activeTickets > 0 then
if not currentTicket or not currentTicket.Parent then
currentTicket = activeTickets[1]
ticketProcessedTime = tick()
end

if currentTicket and currentTicket.Parent then
ticketPart = currentTicket:FindFirstChild("HumanoidRootPart")
if ticketPart then
targetPosition = ticketPart.Position + Vector3.new(0, 999, 0)
rootPart.CFrame = CFrame.new(targetPosition)

if tick() - ticketProcessedTime > 0.1 then
rootPart.CFrame = ticketPart.CFrame
end
else
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end
else
rootPart.CFrame = securityPart.CFrame + Vector3.new(0, 3, 0)
currentTicket = nil
end

elseif mode == "Auto Turkey" then
npcsFolder = workspace:FindFirstChild("NPCs")
if npcsFolder then
for _, npc in ipairs(npcsFolder:GetChildren()) do
if npc:IsA("Model") and npc.Name == "Turkey" then
turkeyHrp = npc:FindFirstChild("HumanoidRootPart")
if turkeyHrp then
rootPart.CFrame = turkeyHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end

playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
if playersFolder then
for _, model in ipairs(playersFolder:GetChildren()) do
if model:IsA("Model") and model.Name == "Turkey" then
modelHrp = model:FindFirstChild("HumanoidRootPart")
if modelHrp then
rootPart.CFrame = modelHrp.CFrame + Vector3.new(0, 3, 0)
break
end
end
end
end
end
end
end)
end

if AutoReviveConnection then
AutoReviveConnection:Disconnect()
AutoReviveConnection = nil
end

if table.find(selected, "Auto Money") then
AutoReviveConnection = RunService.Heartbeat:Connect(function()
if not character or not rootPart then return end

LocalPlayer = Players.LocalPlayer
if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
myHRP = LocalPlayer.Character.HumanoidRootPart
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= LocalPlayer then
char = pl.Character
if char and char:FindFirstChild("HumanoidRootPart") then
isDowned = char:GetAttribute("Downed")
if isDowned and not char:FindFirstChild("RagdollConstraints") then
if isPlayerCarried(char) then
continue
end

hrp = char.HumanoidRootPart
success, dist = pcall(function()
return (myHRP.Position - hrp.Position).Magnitude
end)
if success and dist and dist <= 10 then
pcall(function()
interactEvent:FireServer("Revive", true, pl.Name)
end)
end
end
end
end
end
end
end)
end
end
})

AfkFarmConnection = nil
AutoReviveConnection = nil
AutoTicketFarmConnection = nil
AutoTurkeyFarmConnection = nil
currentTicket = nil
ticketProcessedTime = 0
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


local module_upvr = {}
module_upvr.__index = module_upvr

local currentModuleInstance = nil

function module_upvr.new()
 if currentModuleInstance then
 currentModuleInstance = nil
 end

 local player = game.Players.LocalPlayer
 local playerGui = player:WaitForChild("PlayerGui", 5)
 local self = setmetatable({
 Player = player,
 Enabled = false,
 Visible = false,
 }, module_upvr)

 local nextbotNoise
 local success, err = pcall(function()
 local shared = playerGui:FindFirstChild("Shared")
 if shared then
 local hud = shared:FindFirstChild("HUD")
 if hud then
 nextbotNoise = hud:FindFirstChild("NextbotNoise")
 end
 end
 if not nextbotNoise then
 local hud = playerGui:FindFirstChild("HUD")
 if hud then
 nextbotNoise = hud:FindFirstChild("NextbotNoise")
 end
 end
 if not nextbotNoise then
 nextbotNoise = playerGui:FindFirstChild("NextbotNoise")
 end
 end)

 if not success or not nextbotNoise then
 warn("Failed to find NextbotNoise in PlayerGui: " .. (err or "Unknown error"))
 return self
 end

 self.originalSize = nextbotNoise.Size
 self.originalPosition = nextbotNoise.Position
 self.originalImageTransparency = nextbotNoise.ImageTransparency
 self.originalNoiseTransparency = nextbotNoise:FindFirstChild("Noise") and nextbotNoise.Noise.ImageTransparency or 0
 self.originalNoise2Transparency = nextbotNoise:FindFirstChild("Noise2") and nextbotNoise.Noise2.ImageTransparency or 0

 local transparencySuccess, transparencyErr = pcall(function()
 local inset = game:GetService("GuiService"):GetGuiInset()
 nextbotNoise.Position = UDim2.new(0.5, 0, 0, -inset.Y)
 nextbotNoise.Size = UDim2.new(0, 0, 0, 0)
 nextbotNoise.ImageTransparency = 1
 if nextbotNoise:FindFirstChild("Noise") then
 nextbotNoise.Noise.ImageTransparency = 1
 else
 warn("Noise not found in NextbotNoise")
 end
 if nextbotNoise:FindFirstChild("Noise2") then
 nextbotNoise.Noise2.ImageTransparency = 1
 else
 warn("Noise2 not found in NextbotNoise")
 end
 end)

 if not transparencySuccess then
 warn("Failed to set vignette properties: " .. transparencyErr)
 end

 self.Noise = nextbotNoise
 currentModuleInstance = self
 return self
end

function module_upvr.stop(self)
 if self.Noise then
 local success, err = pcall(function()
 self.Noise.Size = self.originalSize
 self.Noise.Position = self.originalPosition
 self.Noise.ImageTransparency = self.originalImageTransparency
 if self.Noise:FindFirstChild("Noise") then
 self.Noise.Noise.ImageTransparency = self.originalNoiseTransparency
 end
 if self.Noise:FindFirstChild("Noise2") then
 self.Noise.Noise2.ImageTransparency = self.originalNoise2Transparency
 end
 end)
 if not success then
 warn("Failed to restore vignette properties: " .. err)
 end
 end
 currentModuleInstance = nil
end

function module_upvr.Update(arg1, arg2)
 if arg1 and arg1.Noise then
 local success, err = pcall(function()
 if arg1.Noise:IsA("ImageLabel") or arg1.Noise:IsA("Frame") then
 arg1.Noise.ImageTransparency = 1
 if arg1.Noise:FindFirstChild("Noise") then
 arg1.Noise.Noise.ImageTransparency = 1
 end
 if arg1.Noise:FindFirstChild("Noise2") then
 arg1.Noise.Noise2.ImageTransparency = 1
 end
 end
 end)
 if not success then
 warn("Update failed to set transparencies: " .. err)
 end
 end
end



local stableCameraInstance = nil

local StableCamera = {}
StableCamera.__index = StableCamera

function StableCamera.new(maxDistance)
 local self = setmetatable({}, StableCamera)
 self.Player = Players.LocalPlayer
 self.MaxDistance = maxDistance or 50
 self._conn = RunService.RenderStepped:Connect(function(dt) self:Update(dt) end)
 return self
end

function tryResetShake(player)
 if not player then return end
 local ok, playerScripts = pcall(function() return player:FindFirstChild("PlayerScripts") end)
 if not ok or not playerScripts then return end
 local cameraSet = playerScripts:FindFirstChild("Camera") and playerScripts.Camera:FindFirstChild("Set")
 if cameraSet and type(cameraSet.Invoke) == "function" then
 pcall(function()
 cameraSet:Invoke("CFrameOffset", "Shake", CFrame.new())
 end)
 end
end

function StableCamera:Update(dt)
 if Players and Players.LocalPlayer then
 tryResetShake(Players.LocalPlayer)
 end
end

function StableCamera:Destroy()
 if self._conn then
 self._conn:Disconnect()
 self._conn = nil
 end
end
Tabs.Visuals:Space()

DisableCameraShakeToggle = Tabs.Visuals:Toggle({
 Title = "Disable Camera Shake",
 Flag = "DisableCameraShakeToggle",
 Value = false,
 Callback = function(state)
 featureStates.DisableCameraShake = state
 if state then
 if stableCameraInstance then
 stableCameraInstance:Destroy()
 stableCameraInstance = nil
 end
 stableCameraInstance = StableCamera.new(50)
 pcall(function()
 WindUI:Notify({ Title = "Camera", Content = "Camera shake disabled", Duration = 0 })
 end)
 else
 if stableCameraInstance then
 stableCameraInstance:Destroy()
 stableCameraInstance = nil
 end
 pcall(function()
 WindUI:Notify({ Title = "Camera", Content = "Camera shake enabled", Duration = 0 })
 end)
 end
 end
})

local vignetteEnabled = false
Tabs.Visuals:Space()
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

function getMapController()
for _, obj in pairs(game:GetDescendants()) do
if obj:IsA("ModuleScript") and obj.Name == "MapController" then
local success, module = pcall(require, obj)
if success and module.UpdateHeartbeat then
return module
end
end
end
return nil
end

local controller = getMapController()
local originalUpdate = controller and controller.UpdateHeartbeat
local safeZoneDisabled = false
local heartbeatConnection = nil

function enableSafeZoneBypass()
if not controller then return end

controller.UpdateHeartbeat = function(self, dt)
if self.mapVisuals and self.mapVisuals.SafezoneHandler then
self.mapVisuals.SafezoneHandler.CheckIfInSafezone = function()
return false
end
end
return originalUpdate(self, dt)
end

heartbeatConnection = RunService.Heartbeat:Connect(function()
if controller and controller.mapVisuals and controller.mapVisuals.SafezoneHandler then
controller.mapVisuals.SafezoneHandler.CheckIfInSafezone = function()
return false
end
end
end)

safeZoneDisabled = true
end

function disableSafeZoneBypass()
if heartbeatConnection then
heartbeatConnection:Disconnect()
heartbeatConnection = nil
end

if controller and originalUpdate then
controller.UpdateHeartbeat = originalUpdate
end

safeZoneDisabled = false
end

DisableSafeZoneReduction = Tabs.Visuals:Toggle({
Title = "Remove Camping Spot",
Desc = "This is actually disable ui lol",
Flag = "DisableSafeZoneReduction",
Default = false,
Callback = function(value)
if value then
enableSafeZoneBypass()
else
disableSafeZoneBypass()
end
end
})
Tabs.Visuals:Space()
Disablevignette = Tabs.Visuals:Toggle({
 Title = "Disable Vignette",
 Flag = "Disablevignette",
 Default = false,
 Callback = function(value)
 vignetteEnabled = value
 if value then
 local vignetteInstance = module_upvr.new()
 if vignetteInstance then
 vignetteConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
 module_upvr.Update(vignetteInstance, dt)
 end)
 end
 else
 if vignetteConnection then
 vignetteConnection:Disconnect()
 vignetteConnection = nil
 end
 if currentModuleInstance then
 module_upvr.stop(currentModuleInstance)
 end
 end
 end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function()
 wait(1)
 
 if vignetteEnabled then
 local vignetteInstance = module_upvr.new()
 if vignetteInstance then
 if vignetteConnection then
 vignetteConnection:Disconnect()
 end
 vignetteConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
 module_upvr.Update(vignetteInstance, dt)
 end)
 end
 end
end)
Tabs.Visuals:Space()

	 FullBrightToggle = Tabs.Visuals:Toggle({
 Title = "Full Bright",
 Flag = "FullBrightToggle",
 Desc = "Ya Like drinking Night Vision while mining in da cave and sceard of creeper blow you up dawg?",
 Value = false,
 Callback = function(state)
 featureStates.FullBright = state
 if state then featureStates.originalBrightness = Lighting.Brightness
 featureStates.originalAmbient = Lighting.Ambient
 featureStates.originalOutdoorAmbient = Lighting.OutdoorAmbient
 featureStates.originalColorShiftBottom = Lighting.ColorShift_Bottom
 featureStates.originalColorShiftTop = Lighting.ColorShift_Top function applyFullBright()
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
 end applyFullBright() if featureStates.fullBrightConnection then
 featureStates.fullBrightConnection:Disconnect()
 end featureStates.fullBrightConnection = RunService.Heartbeat:Connect(function()
 if featureStates.FullBright then
 applyFullBright()
 end
 end) featureStates.fullBrightCharConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function()
 task.wait(1)
 if featureStates.FullBright then
 applyFullBright()
 end
 end) else
 if featureStates.fullBrightConnection then
 featureStates.fullBrightConnection:Disconnect()
 featureStates.fullBrightConnection = nil
 end if featureStates.fullBrightCharConnection then
 featureStates.fullBrightCharConnection:Disconnect()
 featureStates.fullBrightCharConnection = nil
 end if featureStates.originalBrightness then
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
Tabs.Visuals:Space()
]]
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TimerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Timer = Instance.new("Frame")
Timer.Name = "Timer"
Timer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Timer.BackgroundTransparency = 1
Timer.BorderColor3 = Color3.fromRGB(27, 42, 53)
Timer.Size = UDim2.new(1, 0, 1, 0)
Timer.Parent = ScreenGui

local Top = Instance.new("Frame")
Top.Name = "Top"
Top.AnchorPoint = Vector2.new(0.5, 0)
Top.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Top.BackgroundTransparency = 1
Top.BorderColor3 = Color3.fromRGB(27, 42, 53)
Top.Position = UDim2.new(0.5, 0, 0, 0)
Top.Size = UDim2.new(1, 0, 1, 0)
Top.Parent = Timer

local AspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
AspectRatioConstraint.Parent = Top

local SizeConstraint = Instance.new("UISizeConstraint")
SizeConstraint.MaxSize = Vector2.new(900, 900)
SizeConstraint.Parent = Top

local MainTimer = Instance.new("Frame")
MainTimer.Name = "MainTimer"
MainTimer.AnchorPoint = Vector2.new(0.5, 0)
MainTimer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainTimer.BackgroundTransparency = 0.6
MainTimer.BorderColor3 = Color3.fromRGB(27, 42, 53)
MainTimer.BorderSizePixel = 0
MainTimer.Position = UDim2.new(0.5, 0, 0.04, 0)
MainTimer.Size = UDim2.new(0.25, 0, 0.1, 0)
MainTimer.Parent = Top
MainTimer.Visible = false

local MainTimerCorner = Instance.new("UICorner")
MainTimerCorner.CornerRadius = UDim.new(0, 4)
MainTimerCorner.Parent = MainTimer

local MainTimerStroke = Instance.new("UIStroke")
MainTimerStroke.Transparency = 0.8
MainTimerStroke.Parent = MainTimer

local TimerEmptyFrame = Instance.new("Frame")
TimerEmptyFrame.AnchorPoint = Vector2.new(0, 0.5)
TimerEmptyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimerEmptyFrame.BackgroundTransparency = 1
TimerEmptyFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
TimerEmptyFrame.Position = UDim2.new(0.775, 0, 0.6, 0)
TimerEmptyFrame.Size = UDim2.new(0.225, 0, 0.45, 0)
TimerEmptyFrame.Parent = MainTimer

local TimerListLayout = Instance.new("UIListLayout")
TimerListLayout.FillDirection = Enum.FillDirection.Horizontal
TimerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TimerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TimerListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
TimerListLayout.Parent = TimerEmptyFrame

local TimerBackground = Instance.new("ImageLabel")
TimerBackground.Name = "Background"
TimerBackground.Image = "rbxassetid://196969716"
TimerBackground.ImageColor3 = Color3.fromRGB(21, 21, 21)
TimerBackground.ImageTransparency = 0.7
TimerBackground.AnchorPoint = Vector2.new(0.5, 0.5)
TimerBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimerBackground.BackgroundTransparency = 1
TimerBackground.BorderColor3 = Color3.fromRGB(27, 42, 53)
TimerBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
TimerBackground.Size = UDim2.new(1, 0, 1, 0)
TimerBackground.ZIndex = 0
TimerBackground.Parent = MainTimer

local TimerBackgroundCorner = Instance.new("UICorner")
TimerBackgroundCorner.CornerRadius = UDim.new(0, 4)
TimerBackgroundCorner.Parent = TimerBackground

local TimerImage = Instance.new("ImageLabel")
TimerImage.Image = "rbxassetid://6761866149"
TimerImage.ImageColor3 = Color3.fromRGB(165, 194, 255)
TimerImage.ImageTransparency = 0.9
TimerImage.ScaleType = Enum.ScaleType.Crop
TimerImage.AnchorPoint = Vector2.new(0.5, 0.5)
TimerImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimerImage.BackgroundTransparency = 1
TimerImage.BorderColor3 = Color3.fromRGB(27, 42, 53)
TimerImage.Position = UDim2.new(0.5, 0, 0.5, 0)
TimerImage.Size = UDim2.new(0.8, 0, 1, 0)
TimerImage.ZIndex = 2
TimerImage.Parent = MainTimer

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StatusLabel.Text = "ROUND ACTIVE"
StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
StatusLabel.TextScaled = true
StatusLabel.TextSize = 14
StatusLabel.TextStrokeTransparency = 0.95
StatusLabel.TextWrapped = true
StatusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
StatusLabel.Position = UDim2.new(0.5, 0, 0.25, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0.25, 0)
StatusLabel.ZIndex = 3
StatusLabel.Parent = MainTimer

local StatusStroke = Instance.new("UIStroke")
StatusStroke.Thickness = 2
StatusStroke.Transparency = 0.7
StatusStroke.Parent = StatusLabel

local StatusGradient = Instance.new("UIGradient")
StatusGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(194, 194, 194))
})
StatusGradient.Rotation = 90
StatusGradient.Parent = StatusLabel

local TimeDisplay = Instance.new("TextLabel")
TimeDisplay.Name = "TimeDisplay"
TimeDisplay.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TimeDisplay.Text = "0:00"
TimeDisplay.TextColor3 = Color3.fromRGB(165, 194, 255)
TimeDisplay.TextScaled = true
TimeDisplay.TextSize = 14
TimeDisplay.TextStrokeTransparency = 0.95
TimeDisplay.TextWrapped = true
TimeDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
TimeDisplay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimeDisplay.BackgroundTransparency = 1
TimeDisplay.BorderColor3 = Color3.fromRGB(27, 42, 53)
TimeDisplay.Position = UDim2.new(0.5, 0, 0.65, 0)
TimeDisplay.Size = UDim2.new(0.5, 0, 0.5, 0)
TimeDisplay.ZIndex = 3
TimeDisplay.Parent = MainTimer

local TimeStroke = Instance.new("UIStroke")
TimeStroke.Thickness = 3
TimeStroke.Transparency = 0.7
TimeStroke.Parent = TimeDisplay

local TimeGradient = Instance.new("UIGradient")
TimeGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(194, 194, 194))
})
TimeGradient.Rotation = 90
TimeGradient.Parent = TimeDisplay

local SpecialRound = Instance.new("Frame")
SpecialRound.Name = "SpecialRound"
SpecialRound.AnchorPoint = Vector2.new(0.5, 0)
SpecialRound.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpecialRound.BackgroundTransparency = 0.6
SpecialRound.BorderColor3 = Color3.fromRGB(27, 42, 53)
SpecialRound.BorderSizePixel = 0
SpecialRound.Position = UDim2.new(0.5, 0, 0.15, 0)
SpecialRound.Size = UDim2.new(0.23, 0, 0.05, 0)
SpecialRound.Parent = Top
SpecialRound.Visible = false
local SpecialRoundLabel = Instance.new("TextLabel")
SpecialRoundLabel.Name = "Label"
SpecialRoundLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
SpecialRoundLabel.Text = "No Jumping"
SpecialRoundLabel.TextColor3 = Color3.fromRGB(255, 208, 115)
SpecialRoundLabel.TextScaled = true
SpecialRoundLabel.TextSize = 14
SpecialRoundLabel.TextStrokeTransparency = 0.95
SpecialRoundLabel.TextWrapped = true
SpecialRoundLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SpecialRoundLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpecialRoundLabel.BackgroundTransparency = 1
SpecialRoundLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
SpecialRoundLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
SpecialRoundLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
SpecialRoundLabel.ZIndex = 3
SpecialRoundLabel.Parent = SpecialRound

local SpecialRoundStroke = Instance.new("UIStroke")
SpecialRoundStroke.Thickness = 2
SpecialRoundStroke.Transparency = 0.7
SpecialRoundStroke.Parent = SpecialRoundLabel

local SpecialRoundEmptyFrame = Instance.new("Frame")
SpecialRoundEmptyFrame.AnchorPoint = Vector2.new(0, 0.5)
SpecialRoundEmptyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpecialRoundEmptyFrame.BackgroundTransparency = 1
SpecialRoundEmptyFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
SpecialRoundEmptyFrame.Position = UDim2.new(0.775, 0, 0.6, 0)
SpecialRoundEmptyFrame.Size = UDim2.new(0.225, 0, 0.45, 0)
SpecialRoundEmptyFrame.Parent = SpecialRound

local SpecialRoundListLayout = Instance.new("UIListLayout")
SpecialRoundListLayout.FillDirection = Enum.FillDirection.Horizontal
SpecialRoundListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SpecialRoundListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpecialRoundListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SpecialRoundListLayout.Parent = SpecialRoundEmptyFrame

local SpecialRoundCorner = Instance.new("UICorner")
SpecialRoundCorner.CornerRadius = UDim.new(0, 4)
SpecialRoundCorner.Parent = SpecialRound

local SpecialRoundBackground = Instance.new("ImageLabel")
SpecialRoundBackground.Name = "Background"
SpecialRoundBackground.Image = "rbxassetid://196969716"
SpecialRoundBackground.ImageColor3 = Color3.fromRGB(21, 21, 21)
SpecialRoundBackground.ImageTransparency = 0.7
SpecialRoundBackground.AnchorPoint = Vector2.new(0.5, 0.5)
SpecialRoundBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpecialRoundBackground.BackgroundTransparency = 1
SpecialRoundBackground.BorderColor3 = Color3.fromRGB(27, 42, 53)
SpecialRoundBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
SpecialRoundBackground.Size = UDim2.new(1, 0, 1, 0)
SpecialRoundBackground.ZIndex = 0
SpecialRoundBackground.Parent = SpecialRound

local SpecialRoundBackgroundCorner = Instance.new("UICorner")
SpecialRoundBackgroundCorner.CornerRadius = UDim.new(0, 4)
SpecialRoundBackgroundCorner.Parent = SpecialRoundBackground

local SpecialRoundUIStroke = Instance.new("UIStroke")
SpecialRoundUIStroke.Transparency = 0.8
SpecialRoundUIStroke.Parent = SpecialRound

local TimerGUI = {
ScreenGui = ScreenGui,
TimeDisplay = TimeDisplay,
SpecialRoundLabel = SpecialRoundLabel,
StatusLabel = StatusLabel,
MainTimer = MainTimer,
SpecialRound = SpecialRound,
TimerEnabled = false,
SpecialRoundEnabled = false,
CurrentSpecialRoundName = "",
OriginalTimerVisible = false
}

function TimerGUI:GetRoundTitle(roundName)
if not roundName or roundName == "" then
return ""
end

local specialRoundsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Info")
if not specialRoundsFolder then return roundName end

specialRoundsFolder = specialRoundsFolder:FindFirstChild("SpecialRounds")
if not specialRoundsFolder then return roundName end

local roundModule = specialRoundsFolder:FindFirstChild(roundName)
if not roundModule then return roundName end

local success, moduleData = pcall(function()
return require(roundModule)
end)

if success and moduleData and moduleData.Title then
return moduleData.Title
end

return roundName
end

function TimerGUI:SetTime(seconds)
if type(seconds) == "number" then
local minutes = math.floor(seconds / 60)
local remainingSeconds = math.floor(seconds % 60)
self.TimeDisplay.Text = string.format("%d:%02d", minutes, remainingSeconds)

if seconds <= 5 then
self.TimeDisplay.TextColor3 = Color3.fromRGB(215, 100, 100)
self.StatusLabel.TextColor3 = Color3.fromRGB(215, 100, 100)
else
self.TimeDisplay.TextColor3 = Color3.fromRGB(165, 194, 255)
self.StatusLabel.TextColor3 = Color3.fromRGB(165, 194, 255)
end
else
self.TimeDisplay.Text = tostring(seconds)
end
end

function TimerGUI:SetSpecialRound(roundName)
if roundName and roundName ~= "" then
self.CurrentSpecialRoundName = roundName
local roundTitle = self:GetRoundTitle(roundName)
self.SpecialRoundLabel.Text = roundTitle
self.SpecialRound.Visible = self.SpecialRoundEnabled
else
self.CurrentSpecialRoundName = ""
self.SpecialRound.Visible = false
end
end

function TimerGUI:SetStatus(text)
self.StatusLabel.Text = text:upper()
end

function TimerGUI:SetTimerVisible(visible)
self.TimerEnabled = visible
self.OriginalTimerVisible = visible

if self.CheckingGameTimer then
self:CheckGameTimerVisibility()
else
self.MainTimer.Visible = visible
end
end

function TimerGUI:SetSpecialRoundVisible(visible)
self.SpecialRoundEnabled = visible

if visible and self.CurrentSpecialRoundName ~= "" then
self.SpecialRound.Visible = true
else
self.SpecialRound.Visible = false
end
end

function TimerGUI:CheckGameTimerVisibility()
if not self.TimerEnabled then
self.MainTimer.Visible = false
return
end

local hud = localPlayer.PlayerGui:FindFirstChild("Shared")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

hud = hud:FindFirstChild("HUD")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

hud = hud:FindFirstChild("Overlay")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

hud = hud:FindFirstChild("Default")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

hud = hud:FindFirstChild("RoundOverlay")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

hud = hud:FindFirstChild("Round")
if not hud then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

local roundTimer = hud:FindFirstChild("RoundTimer")
if not roundTimer then
self.MainTimer.Visible = self.OriginalTimerVisible
return
end

if roundTimer.Visible then
self.MainTimer.Visible = false
else
self.MainTimer.Visible = self.OriginalTimerVisible
end
end

function TimerGUI:StartGameTimerCheck()
if self.CheckingGameTimer then return end

self.CheckingGameTimer = true

spawn(function()
while self.CheckingGameTimer do
self:CheckGameTimerVisibility()
wait(0.1)
end
end)
end

function TimerGUI:StopGameTimerCheck()
self.CheckingGameTimer = false
self.MainTimer.Visible = self.OriginalTimerVisible
end

function TimerGUI:UpdateFromAttributes()
local statsFolder = workspace:FindFirstChild("Game")
if not statsFolder then return end

statsFolder = statsFolder:FindFirstChild("Stats")
if not statsFolder then return end

local timerValue = statsFolder:GetAttribute("Timer")
local specialRoundValue = statsFolder:GetAttribute("SpecialRound")
local roundStarted = statsFolder:GetAttribute("RoundStarted")

if timerValue then
self:SetTime(timerValue)
end

if roundStarted ~= nil then
if roundStarted == true then
self:SetStatus("Round Active")
else
self:SetStatus("Intermission")
end
end

if specialRoundValue then
self:SetSpecialRound(tostring(specialRoundValue))
else
self:SetSpecialRound("")
end
end

function TimerGUI:StartAttributeMonitor()
if self._attributeConnection then
self._attributeConnection:Disconnect()
end

local statsFolder = workspace:FindFirstChild("Game")
if not statsFolder then return end

statsFolder = statsFolder:FindFirstChild("Stats")
if not statsFolder then return end

self._attributeConnection = statsFolder:GetAttributeChangedSignal("Timer"):Connect(function()
self:UpdateFromAttributes()
end)

self._attributeConnection2 = statsFolder:GetAttributeChangedSignal("RoundStarted"):Connect(function()
self:UpdateFromAttributes()
end)

self._attributeConnection3 = statsFolder:GetAttributeChangedSignal("SpecialRound"):Connect(function()
self:UpdateFromAttributes()
end)

self:UpdateFromAttributes()
end

function TimerGUI:StopAttributeMonitor()
if self._attributeConnection then
self._attributeConnection:Disconnect()
self._attributeConnection = nil
end
if self._attributeConnection2 then
self._attributeConnection2:Disconnect()
self._attributeConnection2 = nil
end
if self._attributeConnection3 then
self._attributeConnection3:Disconnect()
self._attributeConnection3 = nil
end
end

TimerGUI:SetTimerVisible(false)
TimerGUI:SetSpecialRoundVisible(false)

TimerGUI:StartAttributeMonitor()

function createStandaloneToggles()
local timerToggle = Instance.new("BoolValue")
timerToggle.Name = "TimerDisplayToggle"
timerToggle.Value = false
timerToggle.Changed:Connect(function(state)
if state then
TimerGUI.ScreenGui.Enabled = true
TimerGUI:SetTimerVisible(true)
TimerGUI:StartAttributeMonitor()
TimerGUI:StartGameTimerCheck()
else
TimerGUI:SetTimerVisible(false)
TimerGUI:StopGameTimerCheck()
end
end)

local specialRoundToggle = Instance.new("BoolValue")
specialRoundToggle.Name = "SpecialRoundDisplayToggle"
specialRoundToggle.Value = false
specialRoundToggle.Changed:Connect(function(state)
TimerGUI:SetSpecialRoundVisible(state)
end)

TimerGUI.TimerToggle = timerToggle
TimerGUI.SpecialRoundToggle = specialRoundToggle

return timerToggle, specialRoundToggle
end

function TimerGUI:SetTimerToggle(state)
if self.TimerToggle then
self.TimerToggle.Value = state
end
end

function TimerGUI:SetSpecialRoundToggle(state)
if self.SpecialRoundToggle then
self.SpecialRoundToggle.Value = state
end
end

createStandaloneToggles()

Tabs.Visuals:Space()

TimerDisplayToggle = Tabs.Visuals:Toggle({
Title = "Timer Display",
Flag = "TimerDisplayToggle",
Value = false,
Callback = function(state)
TimerGUI:SetTimerToggle(state)
end
})

Tabs.Visuals:Space()

SpecialRoundToggle = Tabs.Visuals:Toggle({
Title = "Special Round Display",
Flag = "SpecialRoundToggle",
Value = false,
Callback = function(state)
TimerGUI:SetSpecialRoundToggle(state)
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
 for j = 0, n do d[0][j] = j end  for i = 1, m do 
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
 tempRoot.Name = "__temp_reset_" .. tostring(tick()):gsub("%.", "_")  local tempA = Instance.new("Folder", tempRoot) 
 local tempB = Instance.new("Folder", tempRoot)  for _, c in ipairs(a:GetChildren()) do c.Parent = tempA end 
 for _, c in ipairs(b:GetChildren()) do c.Parent = tempB end  for _, c in ipairs(tempA:GetChildren()) do c.Parent = b end 
 for _, c in ipairs(tempB:GetChildren()) do c.Parent = a end  tempRoot:Destroy() isSwapped = false WindUI:Notify({
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
player = game:GetService("Players").LocalPlayer
ReplicatedStorage = game:GetService("ReplicatedStorage")

emoteModelScript = nil
originalEmoteData = {}
replacementEnabled = false
emoteDataSaved = false
emoteFrame = nil
currentTag = nil

currentEmotes = {}
selectEmotes = {}
currentEmoteInputs = {}
selectEmoteInputs = {}

for i = 1, 12 do
    currentEmotes[i] = ""
    selectEmotes[i] = ""
end

Events = ReplicatedStorage:WaitForChild("Events", 10)
CharacterFolder = Events and Events:WaitForChild("Character", 10)
EmoteRemote = CharacterFolder and CharacterFolder:WaitForChild("Emote", 10)
PassCharacterInfo = CharacterFolder and CharacterFolder:WaitForChild("PassCharacterInfo", 10)
remoteSignal = PassCharacterInfo and PassCharacterInfo.OnClientEvent

emoteNameCache = {}
normalizedCache = {}

function fireSelect(emoteName)
    if not currentTag then return end
    local tagNumber = tonumber(currentTag)
    if not tagNumber or tagNumber < 0 or tagNumber > 255 then return end
    if not emoteName or emoteName == "" then return end
    
    local bufferData = buffer.create(2)
    buffer.writeu8(bufferData, 0, tagNumber)
    buffer.writeu8(bufferData, 1, 17)
    
    if remoteSignal then
        firesignal(remoteSignal, bufferData, {emoteName})
    end
end

function setupAnimationListener()
    function setupHumanoidListeners(char)
        local isR15 = char:GetAttribute("R15") == true
        local humanoid
        if isR15 then
            local r15Visual = char:WaitForChild("R15Visual", 5)
            if r15Visual then
                humanoid = r15Visual:WaitForChild("Visual_Humanoid", 5)
            end
        else
            humanoid = char:WaitForChild("Humanoid", 5)
        end
        
        if humanoid then
            humanoid.AnimationPlayed:Connect(function(track)
                local animation = track.Animation
                if animation and animation:IsDescendantOf(ReplicatedStorage.Items.Emotes) then
                    local emoteModule = animation:FindFirstAncestorWhichIsA("ModuleScript")
                    if emoteModule then
                        local currentEmoteName = emoteModule.Name
                        
                        for i = 1, 12 do
                            if currentEmotes[i] ~= "" and selectEmotes[i] ~= "" then
                                local normalizedCurrent = normalizeText(currentEmotes[i])
                                local normalizedPlaying = normalizeText(currentEmoteName)
                                
                                if normalizedCurrent == normalizedPlaying then
                                    fireSelect(selectEmotes[i])
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    
    if player.Character then
        setupHumanoidListeners(player.Character)
    end
    
    player.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        setupHumanoidListeners(newChar)
    end)
end

setupAnimationListener()

function findEmoteModelScript()
    if emoteModelScript then return emoteModelScript end
    
    for _, script in pairs(player.PlayerScripts:GetDescendants()) do
        if script.Name == "EmoteModel" then
            emoteModelScript = script
            return script
        end
    end
    
    for _, script in pairs(ReplicatedStorage:GetDescendants()) do
        if script.Name == "EmoteModel" then
            emoteModelScript = script
            return script
        end
    end
    return nil
end

function normalizeText(text)
    if not text then return "" end
    if not normalizedCache[text] then
        normalizedCache[text] = string.lower(text:gsub("%s+", ""))
    end
    return normalizedCache[text]
end

function findEmoteModuleByDisplayName(displayName)
    if displayName == "NONE" or not displayName then return nil end
    
    if emoteNameCache[displayName] ~= nil then
        return emoteNameCache[displayName]
    end
    
    emotesFolder = ReplicatedStorage:FindFirstChild("Items")
    if not emotesFolder then 
        emoteNameCache[displayName] = nil
        return nil 
    end
    emotesFolder = emotesFolder:FindFirstChild("Emotes")
    if not emotesFolder then 
        emoteNameCache[displayName] = nil
        return nil 
    end
    
    normalizedDisplayName = normalizeText(displayName)
    
    for _, emoteModule in pairs(emotesFolder:GetChildren()) do
        success, emoteData = pcall(require, emoteModule)
        if success and emoteData then
            emoteDisplayName = emoteData.AppearanceInfo.NameShorted or emoteData.AppearanceInfo.Name
            if normalizeText(emoteDisplayName) == normalizedDisplayName then
                emoteNameCache[displayName] = emoteModule.Name
                return emoteModule.Name
            end
        end
    end
    
    emoteNameCache[displayName] = nil
    return nil
end

function getEmoteFrame()
    playerGui = player.PlayerGui
    shared = playerGui and playerGui:FindFirstChild("Shared")
    hud = shared and shared:FindFirstChild("HUD")
    interactors = hud and hud:FindFirstChild("Interactors")
    popups = interactors and interactors:FindFirstChild("Popups")
    return popups and popups:FindFirstChild("Emote")
end

function cleanUpLastEmoteFrame()
    if emoteFrame then
        emoteFrame = nil
    end
end

function restoreOriginalEmotes()
    if not emoteModelScript then
        findEmoteModelScript()
    end
    if not emoteModelScript or not emoteFrame then return end
    
    emoteModelFunction = require(emoteModelScript)
    emoteWheel = emoteFrame:FindFirstChild("Wheel")
    emoteWheel2 = emoteFrame:FindFirstChild("Wheel2")
    
    if not emoteWheel then return end
    
    function processSlot(emoteSlot, key)
        if not emoteSlot then return end
        textLabel = emoteSlot:FindFirstChild("TextLabel")
        viewportFrame = emoteSlot:FindFirstChild("ViewportFrame")
        
        if textLabel and viewportFrame then
            original = originalEmoteData[key]
            if original then
                if viewportFrame:FindFirstChild("WorldModel") then
                    viewportFrame.WorldModel:Destroy()
                end
                
                if original.displayText ~= "NONE" and original.emoteName then
                    emoteModule = ReplicatedStorage.Items.Emotes:FindFirstChild(original.emoteName)
                    if emoteModule then
                        emoteModelFunction(viewportFrame, original.emoteName)
                    end
                    textLabel.Text = original.displayText
                else
                    textLabel.Text = "NONE"
                end
            end
        end
    end
    
    for i = 1, 6 do
        processSlot(emoteWheel:FindFirstChild("Emote"..i), "Wheel_Emote"..i)
    end
    
    if emoteWheel2 then
        for i = 1, 6 do
            processSlot(emoteWheel2:FindFirstChild("Emote"..i), "Wheel2_Emote"..i)
        end
    end
end

function replaceEmotesFrame()
    if not replacementEnabled or not emoteDataSaved or not emoteFrame then return false end
    if not emoteModelScript then findEmoteModelScript() end
    if not emoteModelScript then return false end
    
    emoteModelFunction = require(emoteModelScript)
    emoteWheel = emoteFrame:FindFirstChild("Wheel")
    emoteWheel2 = emoteFrame:FindFirstChild("Wheel2")
    
    if not emoteWheel then return false end
    
    anyPairsConfigured = false
    
    function processEmoteSlot(emoteSlot, wheelName, i)
        if not emoteSlot then return end
        textLabel = emoteSlot:FindFirstChild("TextLabel")
        if not textLabel then return end
        
        currentText = textLabel.Text
        normalizedCurrent = normalizeText(currentText)
        
        for j = 1, 12 do
            searchEmote = currentEmotes[j]
            replaceEmote = selectEmotes[j]
            
            if searchEmote ~= "" and replaceEmote ~= "" then
                anyPairsConfigured = true
                if normalizedCurrent == normalizeText(searchEmote) then
                    viewportFrame = emoteSlot.ViewportFrame
                    if viewportFrame then
                        replacementModule = ReplicatedStorage.Items.Emotes:FindFirstChild(replaceEmote)
                        if replacementModule then
                            key = wheelName.."_Emote"..i
                            if not originalEmoteData[key] then
                                originalEmoteData[key] = {
                                    displayText = currentText,
                                    emoteName = findEmoteModuleByDisplayName(currentText) or currentText
                                }
                            end
                            
                            if viewportFrame:FindFirstChild("WorldModel") then
                                viewportFrame.WorldModel:Destroy()
                            end
                            
                            targetEmoteModule = require(replacementModule)
                            targetDisplayName = targetEmoteModule.AppearanceInfo.NameShorted or targetEmoteModule.AppearanceInfo.Name
                            
                            emoteModelFunction(viewportFrame, replaceEmote)
                            textLabel.Text = targetDisplayName
                        end
                    end
                    break
                end
            end
        end
    end
    
    for i = 1, 6 do
        processEmoteSlot(emoteWheel:FindFirstChild("Emote"..i), "Wheel", i)
    end
    
    if emoteWheel2 then
        for i = 1, 6 do
            processEmoteSlot(emoteWheel2:FindFirstChild("Emote"..i), "Wheel2", i)
        end
    end
    
    return anyPairsConfigured
end

function saveOriginalEmoteData(frame)
    if not frame then return end
    originalEmoteData = {}
    emoteWheel = frame:FindFirstChild("Wheel")
    emoteWheel2 = frame:FindFirstChild("Wheel2")
    
    if not emoteWheel then return end
    
    function saveSlot(emoteSlot, key)
        if not emoteSlot then return end
        textLabel = emoteSlot:FindFirstChild("TextLabel")
        if textLabel then
            originalEmoteData[key] = {
                displayText = textLabel.Text,
                emoteName = findEmoteModuleByDisplayName(textLabel.Text) or textLabel.Text
            }
        end
    end
    
    for i = 1, 6 do
        saveSlot(emoteWheel:FindFirstChild("Emote"..i), "Wheel_Emote"..i)
    end
    
    if emoteWheel2 then
        for i = 1, 6 do
            saveSlot(emoteWheel2:FindFirstChild("Emote"..i), "Wheel2_Emote"..i)
        end
    end
    
    emoteDataSaved = true
end

function readTagFromFolder(folder)
    if not folder then return nil end
    attributeValue = folder:GetAttribute("Tag")
    if attributeValue ~= nil then return attributeValue end
    tagValue = folder:FindFirstChild("Tag")
    if tagValue and tagValue:IsA("ValueBase") then return tagValue.Value end
    return nil
end

local respawnInProgress = false
local lastRespawnTime = 0
local reapplyThread = nil

function cleanupOnRespawn()
    currentTag = nil
    emoteFrame = nil
    
    if reapplyThread then
        task.cancel(reapplyThread)
        reapplyThread = nil
    end
end

function handleSingleRespawn()
    local now = tick()
    
    if respawnInProgress and (now - lastRespawnTime) < 2 then
        return
    end
    
    respawnInProgress = true
    lastRespawnTime = now
    
    cleanupOnRespawn()
    
    task.spawn(function()
        local startTime = tick()
        while tick() - startTime < 10 do
            if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players") then
                local playerFolder = workspace.Game.Players:FindFirstChild(player.Name)
                if playerFolder then
                    currentTag = readTagFromFolder(playerFolder)
                    if currentTag then
                        local tagNumber = tonumber(currentTag)
                        if tagNumber and tagNumber >= 0 and tagNumber <= 255 then
                            break
                        end
                    end
                end
            end
            task.wait(0.1)
        end
        
        respawnInProgress = false
    end)
    
    if replacementEnabled and emoteDataSaved then
        if reapplyThread then
            task.cancel(reapplyThread)
            reapplyThread = nil
        end
        
        reapplyThread = task.delay(1.5, function()
            if not replacementEnabled or not emoteDataSaved then return end
            
            for attempts = 1, 30 do
                emoteFrame = getEmoteFrame()
                if emoteFrame then
                    saveOriginalEmoteData(emoteFrame)
                    restoreOriginalEmotes()
                    replaceEmotesFrame()
                    break
                end
                task.wait(0.1)
            end
        end)
    end
end

Tabs.Visuals:Section({ Title = "Emote Changer", TextSize = 20 })

for i = 1, 12 do
    currentEmoteInputs[i] = Tabs.Visuals:Input({
        Title = "Current Emote " .. i,
        Flag = "EmoteChangerSection",
        Placeholder = "Enter current emote name",
        Value = currentEmotes[i],
        Callback = function(v) currentEmotes[i] = v:gsub("%s+", "") end
    })
end

Tabs.Visuals:Divider()

for i = 1, 12 do
    selectEmoteInputs[i] = Tabs.Visuals:Input({
        Title = "Select Emote " .. i,
        Placeholder = "Enter select emote name",
        Value = selectEmotes[i],
        Callback = function(v) selectEmotes[i] = v:gsub("%s+", "") end
    })
end

VisualsEmoteOption = Tabs.Visuals:Input({
    Title = "Emote Possible option",
    Flag = "VisualsEmoteOption",
    Desc = "Higher Value may Broke emote animation recommend Use 1-3 (0 or 'Random' for random)",
    Placeholder = "0",
    Value ="0",
    Callback = function(v)
        currentNum = v:lower() == "random" or tonumber(v) == 0 and "Random" or tonumber(v) or 0
        
        function setupCharacter(char)
            if char == player.Character then
                char:SetAttribute("EmoteNum", currentNum == "Random" and math.random(1, 3) or currentNum)
            end
        end
        
        function monitorCharacter()
            while true do
                task.wait(1)
                char = player.Character
                if char and char:GetAttribute("EmoteNum") ~= currentNum then
                    char:SetAttribute("EmoteNum", currentNum == "Random" and math.random(1, 3) or currentNum)
                end
            end
        end
        
        if player.Character then setupCharacter(player.Character) end
        player.CharacterAdded:Connect(function(char) task.wait(1); setupCharacter(char) end)
        spawn(monitorCharacter)
    end
})

ApplyButton = Tabs.Visuals:Toggle({
    Title = "Enable replace emote wheel",
    Type = "Checkbox",
    Value = replacementEnabled,
    Callback = function(state)
        replacementEnabled = state
        ApplyButton.Color = replacementEnabled and Color3.fromHex("#305dff") or Color3.fromHex("#555555")
        
        if emoteFrame and emoteDataSaved then
            restoreOriginalEmotes()
        end
        
        if replacementEnabled and emoteFrame and emoteDataSaved then
            replaceEmotesFrame()
        end
    end
})

ApplyButton.Color = replacementEnabled and Color3.fromHex("#305dff") or Color3.fromHex("#555555")

VisualsEmoteApply = Tabs.Visuals:Button({
    Title = "Apply Emote Mappings",
    Icon = "refresh-cw",
    Callback = function()
        hasAnyEmote = false
        for i = 1, 12 do
            if currentEmotes[i] ~= "" or selectEmotes[i] ~= "" then
                hasAnyEmote = true
                break
            end
        end
        
        if not hasAnyEmote then
            WindUI:Notify({
                Title = "Emote Changer",
                Content = "Please enter your emote",
                Duration = 3
            })
            return
        end
        
        function normalizeEmoteName(name)
            return name:gsub("%s+", ""):lower()
        end
        
        function isValidEmote(emoteName)
            if emoteName == "" then return false, "" end
            normalizedInput = normalizeEmoteName(emoteName)
            emotesFolder = ReplicatedStorage:FindFirstChild("Items")
            
            if emotesFolder then
                emotesFolder = emotesFolder:FindFirstChild("Emotes")
                if emotesFolder then
                    for _, emoteModule in ipairs(emotesFolder:GetChildren()) do
                        if emoteModule:IsA("ModuleScript") then
                            if normalizeEmoteName(emoteModule.Name) == normalizedInput then
                                return true, emoteModule.Name
                            end
                        end
                    end
                end
            end
            return false, ""
        end
        
        sameEmoteSlots = {}
        missingEmoteSlots = {}
        invalidEmoteSlots = {}
        successfulSlots = {}
        
        for i = 1, 12 do
            if currentEmotes[i] ~= "" and selectEmotes[i] ~= "" then
                currentValid, currentActual = isValidEmote(currentEmotes[i])
                selectValid, selectActual = isValidEmote(selectEmotes[i])
                
                if not currentValid and not selectValid then
                    table.insert(invalidEmoteSlots, {
                        slot = i,
                        currentInvalid = true,
                        currentName = currentEmotes[i],
                        selectInvalid = true,
                        selectName = selectEmotes[i]
                    })
                elseif not currentValid then
                    table.insert(invalidEmoteSlots, {
                        slot = i,
                        currentInvalid = true,
                        currentName = currentEmotes[i],
                        selectInvalid = false,
                        selectName = selectEmotes[i]
                    })
                elseif not selectValid then
                    table.insert(invalidEmoteSlots, {
                        slot = i,
                        currentInvalid = false,
                        currentName = currentEmotes[i],
                        selectInvalid = true,
                        selectName = selectEmotes[i]
                    })
                elseif currentActual:lower() == selectActual:lower() then
                    table.insert(sameEmoteSlots, i)
                else
                    table.insert(successfulSlots, {
                        slot = i,
                        current = currentActual,
                        select = selectActual
                    })
                end
            elseif currentEmotes[i] ~= "" or selectEmotes[i] ~= "" then
                table.insert(missingEmoteSlots, i)
            end
        end
        
        message = ""
        
        if #successfulSlots > 0 then
            message = message .. "<font color='#00FF00'><stroke color='#000000' width='0.0001'>✓ Successfully applied emote on:</stroke></font>\n"
            for _, data in ipairs(successfulSlots) do
                message = message .. "<font color='#00FF00'><stroke color='#000000' width='0.0001'>Slot " .. data.slot .. " Emote: " .. data.current .. " → " .. data.select .. "</stroke></font>\n"
            end
            message = message .. "\n"
        end
        
        if #sameEmoteSlots > 0 then
            message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>🆇 Failed to apply emote on:</stroke></font>\n"
            for _, slot in ipairs(sameEmoteSlots) do
                message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>Slot " .. slot .. " - Cannot change emote with the same name</stroke></font>\n"
            end
            message = message .. "\n"
        end
        
        if #invalidEmoteSlots > 0 then
            message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>🆇 Failed to apply emote on:</stroke></font>\n"
            for _, data in ipairs(invalidEmoteSlots) do
                message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>Slot " .. data.slot .. " - "
                if data.currentInvalid and data.selectInvalid then
                    message = message .. "Invalid current emote: \"" .. data.currentName .. "\", Invalid select emote: \"" .. data.selectName .. "\"</stroke></font>\n"
                elseif data.currentInvalid then
                    message = message .. "Invalid current emote: \"" .. data.currentName .. "\", Select emote: \"" .. data.selectName .. "\"</stroke></font>\n"
                else
                    message = message .. "Current emote: \"" .. data.currentName .. "\", Invalid select emote: \"" .. data.selectName .. "\"</stroke></font>\n"
                end
            end
            message = message .. "\n"
        end
        
        if #missingEmoteSlots > 0 then
            message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>🆇 Failed to apply emote on:</stroke></font>\n"
            for _, slot in ipairs(missingEmoteSlots) do
                if currentEmotes[slot] == "" then
                    message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>Slot " .. slot .. " - Current emote slot is missing text</stroke></font>\n"
                else
                    message = message .. "<font color='#ff0000'><stroke color='#FFFFFF' width='0.0001'>Slot " .. slot .. " - Select emote slot is missing text</stroke></font>\n"
                end
            end
        end
        
        emoteNameCache = {}
        normalizedCache = {}
        WindUI:Notify({
            Title = "Emote Changer",
            Content = message,
            Duration = 8
        })
        
        cleanUpLastEmoteFrame()
        emoteFrame = getEmoteFrame()
        if not emoteFrame then
            WindUI:Notify({
                Title = "Emote Changer",
                Content = "Emote wheel not found.",
                Duration = 5
            })
            return
        end
        
        saveOriginalEmoteData(emoteFrame)
        
        restoreOriginalEmotes()
        
        if replacementEnabled then
            replaceEmotesFrame()
        end
    end
})

VisualsEmoteReset = Tabs.Visuals:Button({
    Title = "Reset All Emotes",
    Icon = "trash-2",
    Callback = function()
        if emoteFrame then
            restoreOriginalEmotes()
        end
        
        for i = 1, 12 do
            currentEmotes[i] = ""
            selectEmotes[i] = ""
            
            if currentEmoteInputs[i] and currentEmoteInputs[i].Set then
                currentEmoteInputs[i]:Set("")
            end
            
            if selectEmoteInputs[i] and selectEmoteInputs[i].Set then
                selectEmoteInputs[i]:Set("")
            end
        end
        
        if VisualsEmoteOption and VisualsEmoteOption.Set then
            VisualsEmoteOption:Set("")
        end
        
        emoteNameCache = {}
        normalizedCache = {}
        cleanUpLastEmoteFrame()
        
        WindUI:Notify({
            Title = "Emote Changer", 
            Content = "All emotes have been reset!"
        })
    end
})

if player.Character then
    task.spawn(handleSingleRespawn)
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    handleSingleRespawn()
end)

if workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players") then
    workspace.Game.Players.ChildAdded:Connect(function(child)
        if child.Name == player.Name then
            task.wait(0.5)
            handleSingleRespawn()
        end
    end)
    
    workspace.Game.Players.ChildRemoved:Connect(function(child)
        if child.Name == player.Name then
            currentTag = nil
            cleanUpLastEmoteFrame()
        end
    end)
end
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
 selectedFolder = carryAnimations:FindFirstChild(lastSelectedActual) if currentFolder and selectedFolder then
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
 selectedFolder = carryAnimations:FindFirstChild(selectedActualName) if not currentFolder or not selectedFolder then
 WindUI:Notify({
 Title = "CarryAnimation Replacer",
 Content = "One or both animations not found in folder",
 Duration = 3
 })
 return
 end tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_carry_swap_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = carryAnimations tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot for _, child in ipairs(currentFolder:GetChildren()) do
 child.Parent = tempCurrent
 end for _, child in ipairs(selectedFolder:GetChildren()) do
 child.Parent = tempSelected
 end for _, child in ipairs(tempCurrent:GetChildren()) do
 child.Parent = selectedFolder
 end for _, child in ipairs(tempSelected:GetChildren()) do
 child.Parent = currentFolder
 end tempRoot:Destroy() lastCurrentCarryAnim = current
 lastSelectedCarryAnim = selected
 isSwapped = true WindUI:Notify({
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
 selectedFolder = perks:FindFirstChild(lastSelectedActual) if currentFolder and selectedFolder then
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
 selectedFolder = perks:FindFirstChild(selectedActualName) if not currentFolder or not selectedFolder then
 WindUI:Notify({
 Title = "Perk Replacer",
 Content = "One or both perks not found in folder",
 Duration = 3
 })
 return
 end tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_perk_swap_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = perks tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot for _, child in ipairs(currentFolder:GetChildren()) do
 child.Parent = tempCurrent
 end for _, child in ipairs(selectedFolder:GetChildren()) do
 child.Parent = tempSelected
 end for _, child in ipairs(tempCurrent:GetChildren()) do
 child.Parent = selectedFolder
 end for _, child in ipairs(tempSelected:GetChildren()) do
 child.Parent = currentFolder
 end tempRoot:Destroy() lastCurrentPerk = current
 lastSelectedPerk = selected
 isPerkSwapped = true WindUI:Notify({
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
 selectedFolder = perks:FindFirstChild(lastSelectedActual) if currentFolder and selectedFolder then
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
 selectedFolder = perks:FindFirstChild(selectedActualName) if not currentFolder or not selectedFolder then
 WindUI:Notify({
 Title = "Perk Replacer 2",
 Content = "One or both perks not found in folder",
 Duration = 3
 })
 return
 end tempRoot = Instance.new("Folder")
 tempRoot.Name = "__temp_perk_swap2_" .. tostring(tick()):gsub("%.", "_")
 tempRoot.Parent = perks tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot for _, child in ipairs(currentFolder:GetChildren()) do
 child.Parent = tempCurrent
 end for _, child in ipairs(selectedFolder:GetChildren()) do
 child.Parent = tempSelected
 end for _, child in ipairs(tempCurrent:GetChildren()) do
 child.Parent = selectedFolder
 end for _, child in ipairs(tempSelected:GetChildren()) do
 child.Parent = currentFolder
 end tempRoot:Destroy() lastCurrentPerk2 = current
 lastSelectedPerk2 = selected
 isPerkSwapped2 = true WindUI:Notify({
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
 selectedValid, selectedTool, selectedVariants, selectedSkin = isValidSkin(lastCurrentTool, lastSelectedSkin) if currentValid and selectedValid then
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
 tempRoot.Parent = currentVariants tempCurrent = Instance.new("Folder")
 tempCurrent.Name = "tempCurrent"
 tempCurrent.Parent = tempRoot tempSelected = Instance.new("Folder")
 tempSelected.Name = "tempSelected"
 tempSelected.Parent = tempRoot for _, child in ipairs(currentSkin:GetChildren()) do
 child.Parent = tempCurrent
 end for _, child in ipairs(selectedSkin:GetChildren()) do
 child.Parent = tempSelected
 end for _, child in ipairs(tempCurrent:GetChildren()) do
 child.Parent = selectedSkin
 end for _, child in ipairs(tempSelected:GetChildren()) do
 child.Parent = currentSkin
 end tempRoot:Destroy() lastCurrentTool = toolName
 lastCurrentSkin = currentSkinName
 lastSelectedSkin = selectedSkinName
 isSkinSwapped = true WindUI:Notify({
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
 Tabs.Visuals:Section({ Title = "NameTag Changers", TextSize = 15 })
VisualNametagDropdown = Tabs.Visuals:Dropdown({
 Title = "Visual Nametag",
 Flag = "VisualNametagDropdown",
 Desc = "Select nametag appearance",
 SearchBarEnabled = true, Values = {"Ignore", "None"},
 Value = "Ignore",
 Callback = function(value)
 playerFolder = workspace.Game.Players:FindFirstChild(game.Players.LocalPlayer.Name)
 if playerFolder then
 if value == "None" then
 playerFolder:SetAttribute("Nametag", nil)
 elseif value ~= "Ignore" then
 cleanValue = value:gsub("%s+", "")
 playerFolder:SetAttribute("Nametag", cleanValue)
 end
 end
 end
})

function updateNametagList()
 nametagValues = {"Ignore", "None"}
 nametagsFolder = game:GetService("ReplicatedStorage").Items.Nametags
 
 if nametagsFolder then
 for _, nametagModule in ipairs(nametagsFolder:GetChildren()) do
 if nametagModule:IsA("ModuleScript") then
 success, nametagData = pcall(require, nametagModule)
 if success and nametagData and nametagData.AppearanceInfo then
 table.insert(nametagValues, nametagData.AppearanceInfo.Name)
 end
 end
 end
 end
 
 VisualNametagDropdown:Refresh(nametagValues, "Ignore")
end

updateNametagList()

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
 wait(1)
 playerFolder = workspace.Game.Players:FindFirstChild(game.Players.LocalPlayer.Name)
 if playerFolder and VisualNametagDropdown.Value ~= "Ignore" then
 if VisualNametagDropdown.Value == "None" then
 playerFolder:SetAttribute("Nametag", nil)
 else
 cleanValue = VisualNametagDropdown.Value:gsub("%s+", "")
 playerFolder:SetAttribute("Nametag", cleanValue)
 end
 end
end)

game:GetService("RunService").Heartbeat:Connect(function()
 playerFolder = workspace.Game.Players:FindFirstChild(game.Players.LocalPlayer.Name)
 if playerFolder and VisualNametagDropdown.Value ~= "Ignore" then
 if VisualNametagDropdown.Value == "None" then
 playerFolder:SetAttribute("Nametag", nil)
 else
 cleanValue = VisualNametagDropdown.Value:gsub("%s+", "")
 currentTag = playerFolder:GetAttribute("Nametag")
 if currentTag ~= cleanValue then
 playerFolder:SetAttribute("Nametag", cleanValue)
 end
 end
 end
end)
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
Tabs.Visuals:Section({ Title = "Emote Swapper (Buggy)", TextSize = 20 })
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
 tempName = selectedName .. "_EmoteSwapTemp" while EmotesFolder:FindFirstChild(tempName) do
 tempName = tempName .. "_"
 end currentEmoteObj.Name = tempName
 selectedEmoteObj.Name = currentName
 currentEmoteObj.Name = selectedName return true
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
 selectedEmoteObj = EmotesFolder:FindFirstChild(currentEmote) if currentEmoteObj and selectedEmoteObj then
 tempName = currentEmote .. "_EmoteSwapTemp" while EmotesFolder:FindFirstChild(tempName) do
 tempName = tempName .. "_"
 end currentEmoteObj.Name = tempName
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
 selectedEmote = swapData[2] if SwapEmoteNames(currentEmote, selectedEmote) then
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
 EmoteSwapper.PendingSwaps = {} for i = 1, 12 do
 currentEmote = EmoteSwapper.CurrentEmotes[i]
 selectedEmote = EmoteSwapper.SelectedEmotes[i]
 
 if currentEmote ~= "" and selectedEmote ~= "" then
 table.insert(EmoteSwapper.PendingSwaps, {currentEmote, selectedEmote})
 end
 end if #EmoteSwapper.PendingSwaps > 0 then
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
 end swappedCount = 0
 failedCount = 0 for i = 1, 12 do
 currentEmote = EmoteSwapper.CurrentEmotes[i]
 selectedEmote = EmoteSwapper.SelectedEmotes[i] if currentEmote ~= "" and selectedEmote ~= "" then
 if SwapEmoteNames(currentEmote, selectedEmote) then
 EmoteSwapper.SwappedPairs[currentEmote] = selectedEmote
 swappedCount = swappedCount + 1
 else
 failedCount = failedCount + 1
 end
 end
 end message = ""
 if swappedCount > 0 then
 message = "Successfully swapped " .. tostring(swappedCount) .. " emote(s)"
 end
 if failedCount > 0 then
 if message ~= "" then message = message .. " | " end
 message = message .. "Failed to swap " .. tostring(failedCount) .. " emote(s)"
 end
 if message == "" then
 message = "No emotes specified to swap"
 end WindUI:Notify({
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
 EmoteSwapper.PendingApply = false for i = 1, 12 do
 EmoteSwapper.CurrentEmotes[i] = ""
 EmoteSwapper.SelectedEmotes[i] = ""
 
 if EmoteSwapper.InputFields["CurrentEmote" .. i] then
 EmoteSwapper.InputFields["CurrentEmote" .. i]:Set("")
 end
 if EmoteSwapper.InputFields["SelectedEmote" .. i] then
 EmoteSwapper.InputFields["SelectedEmote" .. i]:Set("")
 end
 end WindUI:Notify({
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
 swappedCount, failedCount = ProcessPendingSwaps() message = ""
 if swappedCount > 0 then
 message = "Successfully swapped " .. tostring(swappedCount) .. " emote(s)"
 end
 if failedCount > 0 then
 if message ~= "" then message = message .. " | " end
 message = message .. "Failed to swap " .. tostring(failedCount) .. " emote(s)"
 end if message ~= "" then
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
nextbotEspElements = {}
nextbotEspConnection = nil
downedTracerConnection = nil
downedNameESPConnection = nil
downedTracerLines = {}
downedNameESPLabels = {}

nextBotNames = {}
if ReplicatedStorage:FindFirstChild("NPCs") then
 for _, npc in ipairs(ReplicatedStorage.NPCs:GetChildren()) do
 table.insert(nextBotNames, npc.Name)
 end
end

function isNextbotModel(model)
 if not model or not model.Name then return false end
 for _, name in ipairs(nextBotNames) do
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
 Vector3.new( size.X/2, size.Y/2, size.Z/2), Vector3.new( size.X/2, size.Y/2, -size.Z/2),
 Vector3.new( size.X/2, -size.Y/2, size.Z/2), Vector3.new( size.X/2, -size.Y/2, -size.Z/2),
 Vector3.new(-size.X/2, size.Y/2, size.Z/2), Vector3.new(-size.X/2, size.Y/2, -size.Z/2),
 Vector3.new(-size.X/2, -size.Y/2, size.Z/2), Vector3.new(-size.X/2, -size.Y/2, -size.Z/2),
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
 currentTargets[model] = true if not playerEspElements[model] then
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

function updateNextbotESP()
 local camera = workspace.CurrentCamera
 if not camera then return end
 
 local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
 local currentTargets = {}

 local gameFolder = workspace:FindFirstChild("Game")
 if gameFolder and gameFolder:FindFirstChild("Players") then
 for _, model in pairs(gameFolder.Players:GetChildren()) do
 if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isNextbotModel(model) then
 processNextbotModel(model, currentTargets, camera, screenBottomCenter)
 end
 end
 end

 if workspace:FindFirstChild("NPCs") then
 for _, model in pairs(workspace.NPCs:GetChildren()) do
 if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") and isNextbotModel(model) then
 processNextbotModel(model, currentTargets, camera, screenBottomCenter)
 end
 end
 end

 for target, esp in pairs(nextbotEspElements) do
 if not currentTargets[target] then
 cleanupDrawingTable(esp)
 nextbotEspElements[target] = nil
 end
 end
end

function processNextbotModel(model, currentTargets, camera, screenBottomCenter)
 currentTargets[model] = true
 
 if not nextbotEspElements[model] then
 nextbotEspElements[model] = createESPObject()
 setupESPObject(nextbotEspElements[model])
 end

 local esp = nextbotEspElements[model]
 local hrp = model.HumanoidRootPart
 local vector, onScreen = camera:WorldToViewportPoint(hrp.Position)

 if onScreen then
 local topY = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y
 local bottomY = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y
 local size = (bottomY - topY) / 2
 local toggles = featureStates.NextbotESP
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

function startNextbotESP()
 if nextbotEspConnection then return end
 nextbotEspConnection = RunService.RenderStepped:Connect(updateNextbotESP)
end

function stopNextbotESP()
 if nextbotEspConnection then
 nextbotEspConnection:Disconnect()
 nextbotEspConnection = nil
 end
 for _, esp in pairs(nextbotEspElements) do
 cleanupDrawingTable(esp)
 end
 nextbotEspElements = {}
end

function setupNextbotDetection()
 local gameFolder = workspace:FindFirstChild("Game")
 if gameFolder and gameFolder:FindFirstChild("Players") then
 gameFolder.Players.ChildAdded:Connect(function(child)
 if child:IsA("Model") and isNextbotModel(child) then
 task.wait(0.5)
 updateNextbotESP()
 end
 end)
 end
 if workspace:FindFirstChild("NPCs") then
 workspace.NPCs.ChildAdded:Connect(function(child)
 if child:IsA("Model") and isNextbotModel(child) then
 task.wait(0.5)
 updateNextbotESP()
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
 if team ~= "Nextbot" and char.Name ~= player.Name and downed == true then
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
 if team ~= "Nextbot" and char.Name ~= player.Name and downed == true then
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
Tabs.ESP:Section({ Title = "Note: Enabling this higher amount Nextbot Player and ticket may coust your game to lag", TextSize = 10 })
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

Tabs.ESP:Section({ Title = "Nextbot Name ESP" })

NextbotESPToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Name ESP",
 Flag = "NextbotESPToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.names = state
 if state then
 startNextbotESP()
 setupNextbotDetection()
 else
 stopNextbotESP()
 end
 end
})

NextbotBoxESPToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Box ESP",
 Flag = "NextbotBoxESPToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.boxes = state
 if state or featureStates.NextbotESP.names or featureStates.NextbotESP.tracers or featureStates.NextbotESP.distance then
 startNextbotESP()
 else
 stopNextbotESP()
 end
 end
})

NextbotBoxTypeDropdown = Tabs.ESP:Dropdown({
 Title = "Nextbot Box Type",
 Flag = "NextbotBoxTypeDropdown",
 Values = {"2D", "3D"},
 Value = "2D",
 Callback = function(value)
 featureStates.NextbotESP.boxType = value
 end
})

NextbotRainbowBoxesToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Rainbow Boxes",
 Flag = "NextbotRainbowBoxesToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.rainbowBoxes = state
 if featureStates.NextbotESP.boxes then
 stopNextbotESP()
 startNextbotESP()
 end
 end
})

NextbotTracerToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Tracer",
 Flag = "NextbotTracerToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.tracers = state
 if state or featureStates.NextbotESP.names or featureStates.NextbotESP.boxes or featureStates.NextbotESP.distance then
 startNextbotESP()
 else
 stopNextbotESP()
 end
 end
})

NextbotRainbowTracersToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Rainbow Tracers",
 Flag = "NextbotRainbowTracersToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.rainbowTracers = state
 if featureStates.NextbotESP.tracers then
 stopNextbotESP()
 startNextbotESP()
 end
 end
})

NextbotDistanceESPToggle = Tabs.ESP:Toggle({
 Title = "Nextbot Distance ESP",
 Flag = "NextbotDistanceESPToggle",
 Value = false,
 Callback = function(state)
 featureStates.NextbotESP.distance = state
 if state or featureStates.NextbotESP.names or featureStates.NextbotESP.boxes or featureStates.NextbotESP.tracers then
 startNextbotESP()
 else
 stopNextbotESP()
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
 isDowned = IsDowned(model) shouldShowHighlight = false
 if PlayerHighlightsEnabled and isAlive and not isDowned then
 shouldShowHighlight = true
 elseif DownedHighlightsEnabled and isDowned then
 shouldShowHighlight = true
 end if shouldShowHighlight then
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
Tabs.ESP:Section({ Title = "Ticket ESP" })
function cleanupDrawings(drawingTable)
 for ticket, drawings in pairs(drawingTable or {}) do
 pcall(function()
 if drawings and type(drawings) == "table" then
 for _, drawing in ipairs(drawings) do
 if drawing and drawing.Remove then
 drawing:Remove()
 end
 end
 elseif drawings and drawings.Remove then
 drawings:Remove()
 end
 end)
 drawingTable[ticket] = nil
 end
 return {}
end

function cleanupHighlights(highlightTable)
 for _, highlight in pairs(highlightTable or {}) do
 pcall(function()
 if highlight and highlight.Destroy then
 highlight:Destroy()
 end
 end)
 end
 return {}
end

TicketEspToggle = Tabs.ESP:Toggle({
 Title = "Ticket ESP",
 Flag = "TicketEspToggle",
 Value = false,
 Callback = function(state)
 if not state then
 if getgenv().ticketEspConnections then
 for _, connection in ipairs(getgenv().ticketEspConnections) do
 connection:Disconnect()
 end
 getgenv().ticketEspConnections = nil
 task.wait(0.5)
 if getgenv().ticketEspLabels then
 getgenv().ticketEspLabels = cleanupDrawings(getgenv().ticketEspLabels)
 end
 end
 return
 end

 getgenv().ticketEspConnections = getgenv().ticketEspConnections or {}
 getgenv().ticketEspLabels = getgenv().ticketEspLabels or {} for _, connection in ipairs(getgenv().ticketEspConnections) do
 connection:Disconnect()
 end
 getgenv().ticketEspConnections = {}
 getgenv().ticketEspLabels = cleanupDrawings(getgenv().ticketEspLabels)

 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
 if not tickets then return end

 function updateEsp()
 if not tickets then return end for ticket, label in pairs(getgenv().ticketEspLabels) do
 if not ticket.Parent or not ticket:FindFirstChild("HumanoidRootPart") then
 label:Remove()
 getgenv().ticketEspLabels[ticket] = nil
 end
 end for _, ticket in ipairs(tickets:GetChildren()) do
 if ticket:FindFirstChild("HumanoidRootPart") and not getgenv().ticketEspLabels[ticket] then
 local label = Drawing.new("Text")
 label.Visible = false
 label.Text = "Ticket"
 label.Color = Color3.fromRGB(0, 0, 255)
 label.Size = 20
 label.Center = true
 label.Outline = true
 getgenv().ticketEspLabels[ticket] = label
 end
 end local camera = workspace.CurrentCamera
 if not camera then return end
 for ticket, label in pairs(getgenv().ticketEspLabels) do
 local ticketPart = ticket:FindFirstChild("HumanoidRootPart")
 if ticketPart then
 local screenPos, onScreen = camera:WorldToViewportPoint(ticketPart.Position)
 label.Visible = onScreen
 if onScreen then
 label.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
 end
 end
 end
 end task.spawn(updateEsp) table.insert(getgenv().ticketEspConnections, RunService.RenderStepped:Connect(function()
 task.spawn(updateEsp)
 end))
 table.insert(getgenv().ticketEspConnections, tickets.ChildAdded:Connect(updateEsp))
 table.insert(getgenv().ticketEspConnections, tickets.ChildRemoved:Connect(updateEsp))
 end
})

TicketTracerEspToggle = Tabs.ESP:Toggle({
 Title = "Ticket Tracer ESP",
 Flag = "TicketTracerEspToggle",
 Value = false,
 Callback = function(state)
 if not state then
 if getgenv().ticketTracerConnections then
 for _, connection in ipairs(getgenv().ticketTracerConnections) do
 connection:Disconnect()
 end
 getgenv().ticketTracerConnections = nil
 task.wait(0.5)
 if getgenv().ticketTracerDrawings then
 getgenv().ticketTracerDrawings = cleanupDrawings(getgenv().ticketTracerDrawings)
 end
 end
 return
 end

 getgenv().ticketTracerConnections = getgenv().ticketTracerConnections or {}
 getgenv().ticketTracerDrawings = getgenv().ticketTracerDrawings or {} for _, connection in ipairs(getgenv().ticketTracerConnections) do
 connection:Disconnect()
 end
 getgenv().ticketTracerConnections = {}
 getgenv().ticketTracerDrawings = cleanupDrawings(getgenv().ticketTracerDrawings)

 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
 if not tickets then return end

 function updateTracerEsp()
 if not tickets then return end for ticket, drawings in pairs(getgenv().ticketTracerDrawings) do
 if not ticket.Parent or not ticket:FindFirstChild("HumanoidRootPart") then
 cleanupDrawings({[ticket] = drawings})
 getgenv().ticketTracerDrawings[ticket] = nil
 end
 end for _, ticket in ipairs(tickets:GetChildren()) do
 if ticket:FindFirstChild("HumanoidRootPart") and not getgenv().ticketTracerDrawings[ticket] then
 local tracer = Drawing.new("Line")
 tracer.Visible = false
 tracer.Color = Color3.fromRGB(0, 0, 255)
 tracer.Thickness = 2
 tracer.Transparency = 1
 getgenv().ticketTracerDrawings[ticket] = {tracer}
 end
 end local camera = workspace.CurrentCamera
 if not camera then return end
 local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
 for ticket, drawings in pairs(getgenv().ticketTracerDrawings) do
 local ticketPart = ticket:FindFirstChild("HumanoidRootPart")
 if ticketPart then
 local screenPos, onScreen = camera:WorldToViewportPoint(ticketPart.Position)
 drawings[1].Visible = onScreen
 if onScreen then
 drawings[1].From = screenBottomCenter
 drawings[1].To = Vector2.new(screenPos.X, screenPos.Y)
 end
 end
 end
 end task.spawn(updateTracerEsp) table.insert(getgenv().ticketTracerConnections, RunService.RenderStepped:Connect(function()
 task.spawn(updateTracerEsp)
 end))
 table.insert(getgenv().ticketTracerConnections, tickets.ChildAdded:Connect(updateTracerEsp))
 table.insert(getgenv().ticketTracerConnections, tickets.ChildRemoved:Connect(updateTracerEsp))
 end
})

TicketDistanceEspToggle = Tabs.ESP:Toggle({
 Title = "Ticket Distance ESP",
 Flag = "TicketDistanceEspToggle",
 Value = false,
 Callback = function(state)
 if not state then
 if getgenv().ticketDistanceConnections then
 for _, connection in ipairs(getgenv().ticketDistanceConnections) do
 connection:Disconnect()
 end
 getgenv().ticketDistanceConnections = nil
 task.wait(0.5)
 if getgenv().ticketDistanceLabels then
 getgenv().ticketDistanceLabels = cleanupDrawings(getgenv().ticketDistanceLabels)
 end
 end
 return
 end

 getgenv().ticketDistanceConnections = getgenv().ticketDistanceConnections or {}
 getgenv().ticketDistanceLabels = getgenv().ticketDistanceLabels or {} for _, connection in ipairs(getgenv().ticketDistanceConnections) do
 connection:Disconnect()
 end
 getgenv().ticketDistanceConnections = {}
 getgenv().ticketDistanceLabels = cleanupDrawings(getgenv().ticketDistanceLabels)

 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
 if not tickets then return end

 function updateDistanceEsp()
 if not tickets then return end for ticket, label in pairs(getgenv().ticketDistanceLabels) do
 if not ticket.Parent or not ticket:FindFirstChild("HumanoidRootPart") then
 label:Remove()
 getgenv().ticketDistanceLabels[ticket] = nil
 end
 end for _, ticket in ipairs(tickets:GetChildren()) do
 if ticket:FindFirstChild("HumanoidRootPart") and not getgenv().ticketDistanceLabels[ticket] then
 local distanceLabel = Drawing.new("Text")
 distanceLabel.Visible = false
 distanceLabel.Text = "0m"
 distanceLabel.Color = Color3.fromRGB(0, 0, 255)
 distanceLabel.Size = 16
 distanceLabel.Center = true
 distanceLabel.Outline = true
 getgenv().ticketDistanceLabels[ticket] = distanceLabel
 end
 end local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
 local camera = workspace.CurrentCamera
 if not camera or not humanoidRootPart then return end
 for ticket, label in pairs(getgenv().ticketDistanceLabels) do
 local ticketPart = ticket:FindFirstChild("HumanoidRootPart")
 if ticketPart then
 local screenPos, onScreen = camera:WorldToViewportPoint(ticketPart.Position)
 label.Visible = onScreen
 if onScreen then
 local distance = (ticketPart.Position - humanoidRootPart.Position).Magnitude
 label.Text = string.format("%.1fm", distance)
 label.Position = Vector2.new(screenPos.X, screenPos.Y + 20)
 end
 end
 end
 end task.spawn(updateDistanceEsp) table.insert(getgenv().ticketDistanceConnections, RunService.RenderStepped:Connect(function()
 task.spawn(updateDistanceEsp)
 end))
 table.insert(getgenv().ticketDistanceConnections, tickets.ChildAdded:Connect(updateDistanceEsp))
 table.insert(getgenv().ticketDistanceConnections, tickets.ChildRemoved:Connect(updateDistanceEsp))
 end
})

HighlightsTicketEspToggle = Tabs.ESP:Toggle({
 Title = "Highlights Ticket ESP",
 Flag = "HighlightsTicketEspToggle",
 Value = false,
 Callback = function(state)
 if not state then
 if getgenv().ticketHighlightConnections then
 for _, connection in ipairs(getgenv().ticketHighlightConnections) do
 connection:Disconnect()
 end
 getgenv().ticketHighlightConnections = nil
 task.wait(0.5)
 if getgenv().ticketHighlights then
 getgenv().ticketHighlights = cleanupHighlights(getgenv().ticketHighlights)
 end
 end
 return
 end

 getgenv().ticketHighlightConnections = getgenv().ticketHighlightConnections or {}
 getgenv().ticketHighlights = getgenv().ticketHighlights or {} for _, connection in ipairs(getgenv().ticketHighlightConnections) do
 connection:Disconnect()
 end
 getgenv().ticketHighlightConnections = {}
 getgenv().ticketHighlights = cleanupHighlights(getgenv().ticketHighlights)

 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
 if not tickets then return end

 function updateHighlights()
 if not tickets then return end for ticket, highlight in pairs(getgenv().ticketHighlights) do
 if not ticket.Parent or not ticket:FindFirstChild("HumanoidRootPart") then
 highlight:Destroy()
 getgenv().ticketHighlights[ticket] = nil
 end
 end for _, ticket in ipairs(tickets:GetChildren()) do
 if ticket:FindFirstChild("HumanoidRootPart") and not getgenv().ticketHighlights[ticket] then
 local highlight = Instance.new("Highlight")
 highlight.Adornee = ticket
 highlight.FillColor = Color3.fromRGB(0, 0, 255)
 highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
 highlight.FillTransparency = 0.5
 highlight.OutlineTransparency = 0
 highlight.Parent = ticket
 getgenv().ticketHighlights[ticket] = highlight
 end
 end
 end task.spawn(updateHighlights) table.insert(getgenv().ticketHighlightConnections, RunService.RenderStepped:Connect(function()
 task.spawn(updateHighlights)
 end))
 table.insert(getgenv().ticketHighlightConnections, tickets.ChildAdded:Connect(updateHighlights))
 table.insert(getgenv().ticketHighlightConnections, tickets.ChildRemoved:Connect(updateHighlights))
 end
})

TicketBoxEspToggle = Tabs.ESP:Toggle({
 Title = "Ticket Box ESP",
 Flag = "TicketBoxEspToggle",
 Value = false,
 Callback = function(state)
 if not state then
 if getgenv().ticketBoxConnections then
 for _, connection in ipairs(getgenv().ticketBoxConnections) do
 connection:Disconnect()
 end
 getgenv().ticketBoxConnections = nil
 task.wait(0.5)
 if getgenv().ticketBoxDrawings then
 getgenv().ticketBoxDrawings = cleanupDrawings(getgenv().ticketBoxDrawings)
 end
 end
 return
 end

 getgenv().ticketBoxConnections = getgenv().ticketBoxConnections or {}
 getgenv().ticketBoxDrawings = getgenv().ticketBoxDrawings or {} for _, connection in ipairs(getgenv().ticketBoxConnections) do
 connection:Disconnect()
 end
 getgenv().ticketBoxConnections = {}
 getgenv().ticketBoxDrawings = cleanupDrawings(getgenv().ticketBoxDrawings)

 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets")
 if not tickets then return end

 function updateBoxEsp()
 if not tickets then return end for ticket, drawings in pairs(getgenv().ticketBoxDrawings) do
 local is2D = type(drawings[1]) ~= "table"
 local expected2D = getgenv().ticketBoxType == "2D"
 if not ticket.Parent or not ticket:FindFirstChild("HumanoidRootPart") or is2D ~= expected2D then
 cleanupDrawings({[ticket] = drawings})
 getgenv().ticketBoxDrawings[ticket] = nil
 end
 end for _, ticket in ipairs(tickets:GetChildren()) do
 if ticket:FindFirstChild("HumanoidRootPart") and not getgenv().ticketBoxDrawings[ticket] then
 local drawings = {}
 if getgenv().ticketBoxType == "2D" then
 local box = Drawing.new("Square")
 box.Visible = false
 box.Color = Color3.fromRGB(0, 0, 255)
 box.Thickness = 2
 box.Filled = false
 drawings = {box}
 else
 drawings = {}
 for i = 1, 12 do
 local line = Drawing.new("Line")
 line.Visible = false
 line.Color = Color3.fromRGB(0, 0, 255)
 line.Thickness = 2
 line.Transparency = 1
 table.insert(drawings, line)
 end
 end
 getgenv().ticketBoxDrawings[ticket] = drawings
 end
 end local camera = workspace.CurrentCamera
 if not camera then return end
 for ticket, drawings in pairs(getgenv().ticketBoxDrawings) do
 local ticketPart = ticket:FindFirstChild("HumanoidRootPart")
 if ticketPart then
 local screenPos, onScreen = camera:WorldToViewportPoint(ticketPart.Position)
 if onScreen then
 if getgenv().ticketBoxType == "2D" then
 local topY = camera:WorldToViewportPoint(ticketPart.Position + Vector3.new(0, 2, 0)).Y
 local bottomY = camera:WorldToViewportPoint(ticketPart.Position - Vector3.new(0, 2, 0)).Y
 local size = (bottomY - topY) / 2
 drawings[1].Size = Vector2.new(size * 2, size * 2)
 drawings[1].Position = Vector2.new(screenPos.X - size, screenPos.Y - size)
 drawings[1].Visible = true
 else
 local boxSize = Vector3.new(4, 4, 4)
 local offsets = {
 Vector3.new( boxSize.X/2, boxSize.Y/2, boxSize.Z/2),
 Vector3.new( boxSize.X/2, boxSize.Y/2, -boxSize.Z/2),
 Vector3.new( boxSize.X/2, -boxSize.Y/2, boxSize.Z/2),
 Vector3.new( boxSize.X/2, -boxSize.Y/2, -boxSize.Z/2),
 Vector3.new(-boxSize.X/2, boxSize.Y/2, boxSize.Z/2),
 Vector3.new(-boxSize.X/2, boxSize.Y/2, -boxSize.Z/2),
 Vector3.new(-boxSize.X/2, -boxSize.Y/2, boxSize.Z/2),
 Vector3.new(-boxSize.X/2, -boxSize.Y/2, -boxSize.Z/2),
 }
 local screenPoints = {}
 local anyPointOnScreen = false
 for i, offset in ipairs(offsets) do
 local worldPos = ticketPart.CFrame * offset
 local vec, onScreenPoint = camera:WorldToViewportPoint(worldPos)
 screenPoints[i] = {pos = Vector2.new(vec.X, vec.Y), depth = vec.Z}
 if onScreenPoint and vec.Z > 0 then
 anyPointOnScreen = true
 end
 end
 local edges = {
 {1, 2}, {1, 3}, {1, 5},
 {2, 4}, {2, 6},
 {3, 4}, {3, 7},
 {5, 6}, {5, 7},
 {4, 8}, {6, 8}, {7, 8}
 }
 for i, edge in ipairs(edges) do
 local line = drawings[i]
 if line then
 local p1 = screenPoints[edge[1]]
 local p2 = screenPoints[edge[2]]
 if anyPointOnScreen and p1.depth > 0 and p2.depth > 0 then
 line.From = p1.pos
 line.To = p2.pos
 line.Visible = true
 else
 line.Visible = false
 end
 end
 end
 end
 else
 for _, drawing in ipairs(drawings) do
 drawing.Visible = false
 end
 end
 end
 end
 end task.spawn(updateBoxEsp) table.insert(getgenv().ticketBoxConnections, RunService.RenderStepped:Connect(function()
 task.spawn(updateBoxEsp)
 end))
 table.insert(getgenv().ticketBoxConnections, tickets.ChildAdded:Connect(updateBoxEsp))
 table.insert(getgenv().ticketBoxConnections, tickets.ChildRemoved:Connect(updateBoxEsp))
 end
})

BoxticketTypeDropdown = Tabs.ESP:Dropdown({
 Title = "Box Type",
 Flag = "BoxticketTypeDropdown",
 Values = {"2D", "3D"},
 Value = "2D",
 Callback = function(value)
 getgenv().ticketBoxType = value
 if getgenv().ticketBoxDrawings then
 getgenv().ticketBoxDrawings = cleanupDrawings(getgenv().ticketBoxDrawings)
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
 end if isFreecamMovementEnabled then
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
 end) if character:GetAttribute("Downed") == true then
 deactivateFreecam()
 end
 end
end

if player.Character then
 setupDownedListener(player.Character)
end

player.CharacterAdded:Connect(setupDownedListener)

 Tabs.Utility:Space()
Tabs.Utility:Toggle({
 Title = "Exchange Menu",
 Default = false,
 Callback = function(value)
 game.Players.LocalPlayer.PlayerGui.Menu.Views.Battlepass.Exchange.Visible = value
 end
}) 
Tabs.Utility:Space()
 
Tabs.Utility:Toggle({
 Title = "Bypass Battle Pass Waiting",
 Desc = [[Skip all battle pass requirements and unlock everything instantly.
Note: If the script dosent work it's may took days to able buy somethings, so be patient]],
 Default = false,
 Callback = function(value)

 if unlockLoop then
 unlockLoop:Disconnect()
 unlockLoop = nil
 end

 if value then

 unlockLoop = game:GetService("RunService").Heartbeat:Connect(function()
 local player = Players.LocalPlayer

 if not player:FindFirstChild("PlayerGui") then
 return
 end

 function setBattlepassVisible()
 local success, result = pcall(function()

 local gui = player.PlayerGui:FindFirstChild("Menu")
 if gui then
 gui = gui:FindFirstChild("Views")
 if gui then
 gui = gui:FindFirstChild("Battlepass")
 if gui then
 gui = gui:FindFirstChild("ViewPass")
 if gui then
 gui = gui:FindFirstChild("Center")
 if gui then
 gui = gui:FindFirstChild("ViewPass")
 if gui then
 gui = gui:FindFirstChild("Unlocked")
 if gui then
 gui.Visible = false
 return true
 end
 end
 end
 end
 end
 end
 end
 return false
 end)

 if not success then

 end
 end

 setBattlepassVisible()
 end)
 else

 local player = Players.LocalPlayer

 if player and player:FindFirstChild("PlayerGui") then
 local success = pcall(function()
 local gui = player.PlayerGui:FindFirstChild("Menu")
 if gui then
 gui = gui:FindFirstChild("Views")
 if gui then
 gui = gui:FindFirstChild("Battlepass")
 if gui then
 gui = gui:FindFirstChild("ViewPass")
 if gui then
 gui = gui:FindFirstChild("Center")
 if gui then
 gui = gui:FindFirstChild("ViewPass")
 if gui then
 gui = gui:FindFirstChild("Unlocked")
 if gui then
 gui.Visible = true
 end
 end
 end
 end
 end
 end
 end
 end)
 end
 end
 end
})

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
 value = value:gsub("^%s*(.-)%s*$", "%1") local h_str, m_str = value:match("(%d+):(%d+)")
 if h_str and m_str then
 local h = tonumber(h_str)
 local m = tonumber(m_str) if h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59 and #h_str <= 2 and #m_str <= 2 then
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
featureStates.NoRender = false
featureStates.NoRenderColor = Color3.fromRGB(0, 0, 0)
 Tabs.Utility:Space()
 
NoRenderToggle = Tabs.Utility:Toggle({
 Title = "No Render",
 Flag = "NoRenderToggle",
 Desc = "Disable 3D rendering for performance",
 Value = false,
 Callback = function(state)
 featureStates.NoRender = state
 game:GetService("RunService"):Set3dRenderingEnabled(not state) if state then
 local gui = Instance.new("ScreenGui")
 gui.Name = "NoRenderBackground"
 gui.IgnoreGuiInset = true
 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 gui.ResetOnSpawn = false local frame = Instance.new("Frame")
 frame.Size = UDim2.new(1, 0, 1, 0)
 frame.BackgroundColor3 = featureStates.NoRenderColor
 frame.BorderSizePixel = 0
 frame.Parent = gui gui.Parent = player.PlayerGui
 else
 local gui = player.PlayerGui:FindFirstChild("NoRenderBackground")
 if gui then
 gui:Destroy()
 end
 end
 end
})

NoRenderColorPicker = Tabs.Utility:Colorpicker({
 Title = "No Render Color",
 Flag = "NoRenderColorPicker",
 Desc = "Choose background color when No Render is enabled",
 Default = Color3.fromRGB(0, 0, 0),
 Transparency = 0,
 Callback = function(color)
 featureStates.NoRenderColor = color if featureStates.NoRender then
 local gui = player.PlayerGui:FindFirstChild("NoRenderBackground")
 if gui then
 local frame = gui:FindFirstChildOfClass("Frame")
 if frame then
 frame.BackgroundColor3 = color
 end
 end
 end
 end
})
featureStates.RemoveTextures = false
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
 end if ToDisable.Particles then
 if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
 v.Enabled = false
 table.insert(Stuff, 1, v)
 end
 end if ToDisable.VisualEffects then
 if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
 v.Enabled = false
 table.insert(Stuff, 1, v)
 end
 end if ToDisable.Textures then
 if v:IsA("Decal") or v:IsA("Texture") then
 v.Texture = ""
 table.insert(Stuff, 1, v)
 end
 end if ToDisable.Sky then
 if v:IsA("Sky") then
 v.Parent = nil
 table.insert(Stuff, 1, v)
 end
 end
 end

 if ToEnable.FullBright then Lighting.FogColor = Color3.fromRGB(255, 255, 255)
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
local player = Players.LocalPlayer
if not (player:GetAttribute("VIPCommandsAccess") == true) then
else
Tabs.Utility:Section({ Title = "VIP COMMAND", TextSize = 20 })
Tabs.Utility:Divider()

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

function isValidMap(mapName)
 local mapsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Info")
 if mapsFolder then
 mapsFolder = mapsFolder:FindFirstChild("Maps")
 if mapsFolder then
 for _, map in ipairs(mapsFolder:GetChildren()) do
 if map.Name == mapName then
 return true
 end
 end
 end
 end
 return false
end

function isValidGameMode(gameMode)
 local gamemodesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Info")
 if gamemodesFolder then
 gamemodesFolder = gamemodesFolder:FindFirstChild("Gamemodes")
 if gamemodesFolder then
 for _, mode in ipairs(gamemodesFolder:GetChildren()) do
 if mode.Name == gameMode then
 return true
 end
 end
 end
 end
 return false
end
 Tabs.Utility:Space()
 
mapSettingsInput = Tabs.Utility:Input({
 Title = "Set Map Settings",
 Flag = "MapSettingsInput",
 Placeholder = "Enter map name (e.g., Abstract)",
 Value = "Abstract",
 Callback = function(value)
 featureStates.SelectedMapSetting = value
 end
})

Tabs.Utility:Button({
 Title = "Add Map",
 Desc = "Add the specified map to rotation",
 Icon = "plus",
 Callback = function()
 local mapName = featureStates.SelectedMapSetting or "Abstract"
 if mapName and mapName ~= "" then
 if isValidMap(mapName) then
 pcall(function()
 game:GetService("ReplicatedStorage").Events.CustomServers.Admin:FireServer("AddMap", mapName)
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Added map: " .. mapName,
 Duration = 3
 })
 end)
 else
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Invalid map name: " .. mapName,
 Duration = 3
 })
 end
 end
 end
})

Tabs.Utility:Button({
 Title = "Remove Map",
 Desc = "Remove the specified map from rotation",
 Icon = "minus",
 Callback = function()
 local mapName = featureStates.SelectedMapSetting or "Abstract"
 if mapName and mapName ~= "" then
 if isValidMap(mapName) then
 pcall(function()
 game:GetService("ReplicatedStorage").Events.CustomServers.Admin:FireServer("RemoveMap", mapName)
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Removed map: " .. mapName,
 Duration = 3
 })
 end)
 else
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Invalid map name: " .. mapName,
 Duration = 3
 })
 end
 end
 end
})
 Tabs.Utility:Space()
 
gameModeInput = Tabs.Utility:Input({
 Title = "Select Game Mode",
 Flag = "GameModeInput",
 Placeholder = "Enter game mode (e.g., Pro)",
 Value = "Pro",
 Callback = function(value)
 featureStates.SelectedGameMode = value
 end
})

Tabs.Utility:Button({
 Title = "Set Game Mode",
 Desc = "Change the server game mode",
 Icon = "settings",
 Callback = function()
 local gameMode = featureStates.SelectedGameMode or "Pro"
 if gameMode and gameMode ~= "" then
 if isValidGameMode(gameMode) then
 pcall(function()
 game:GetService("ReplicatedStorage").Events.CustomServers.Admin:FireServer("Gamemode", gameMode)
local Event = game:GetService("Players").LocalPlayer.PlayerGui.Global.Messages.Use
Event:Fire(
    "Gamemode will be automatically applied whenever possible",
    "Success"
)
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Set game mode to: " .. gameMode,
 Duration = 3
 })
 end)
 else
 WindUI:Notify({
 Title = "Custom Server",
 Content = "Invalid game mode: " .. gameMode,
 Duration = 3
 })
 end
 end
 end
})
 Tabs.Utility:Space()
 
Tabs.Utility:Button({
 Title = "Unlock VIP Commands",
 Desc = "Restore access to VIP commands if accidentally locked",
 Icon = "unlock",
 Callback = function()
 pcall(function()
 local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
 local globalGui = playerGui:WaitForChild("Global")
 local vipMenu = globalGui:WaitForChild("VIPMenu")
 local createFrame = vipMenu:WaitForChild("Create"):WaitForChild("Frame") local lockedFrame = createFrame:FindFirstChild("Locked")
 if lockedFrame then
 lockedFrame.Visible = false
 end local commandsFrame = createFrame:FindFirstChild("Commands")
 if commandsFrame then
 commandsFrame.Visible = true
 end 
 end)
 end
})

 Tabs.Utility:Section ({
 Title = "IDK What to put here",
 })
 
end
 local invisPartsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("InvisParts")

local movingSecurityParts = false
local partSpeed = 10
local partRadius = 100
local storedSecurityParts = {}
local movementConnection = nil
function disableInvisPartsCollision()
 if invisPartsFolder then
 WindUI:Notify({
 Title = "Notification",
 Content = "Invisible Border is removed",
 Duration = 3
 })
 for _, obj in ipairs(invisPartsFolder:GetDescendants()) do
 if obj:IsA("BasePart") then
 obj.CanCollide = false
 end
 end
 end
end

function restoreInvisPartsCollision()
 if invisPartsFolder then
 WindUI:Notify({
 Title = "Notification",
 Content = "Invisible Border is Restored",
 Duration = 3
 })
 for _, obj in ipairs(invisPartsFolder:GetDescendants()) do
 if obj:IsA("BasePart") then
 obj.CanCollide = true
 end
 end
 end
end
 securityPartToggle = Tabs.Utility:Toggle({
 Title = "Moving Security Part",
 Flag = "securityPartToggle",
 Value = false,
 Callback = function(state)
 movingSecurityParts = state if state then
 disableInvisPartsCollision() local partNames = {"SecurityPart"}
 storedSecurityParts = {} for _, partName in ipairs(partNames) do
 local part = workspace:FindFirstChild(partName)
 if part then
 table.insert(storedSecurityParts, part)
 end
 end for _, obj in ipairs(workspace:GetDescendants()) do
 if obj:IsA("Part") and string.find(obj.Name:lower(), "securitypart") and not table.find(storedSecurityParts, obj) then
 table.insert(storedSecurityParts, obj)
 end
 end if #storedSecurityParts == 0 then
 WindUI:Notify({
 Title = "Security Parts",
 Content = "No security parts found",
 Duration = 3
 })
 movingSecurityParts = false
 restoreInvisPartsCollision()
 return
 end for _, part in ipairs(storedSecurityParts) do
 for _, child in ipairs(part:GetChildren()) do
 if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyForce") then
 child:Destroy()
 end
 end
 
 part.CanCollide = true
 part.Anchored = false
 part.Massless = false
 
 local bodyVelocity = Instance.new("BodyVelocity")
 bodyVelocity.Velocity = Vector3.new(0, 0, 0)
 bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
 bodyVelocity.Parent = part
 
 local bodyGyro = Instance.new("BodyGyro")
 bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
 bodyGyro.P = 1000
 bodyGyro.D = 100
 bodyGyro.Parent = part
 end movementConnection = game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
 if not movingSecurityParts or #storedSecurityParts == 0 then
 if movementConnection then
 movementConnection:Disconnect()
 movementConnection = nil
 end
 return
 end
 
 local mainPart = storedSecurityParts[1]
 if mainPart and mainPart.Parent then
 local time = tick()
 local x = math.cos(time * partSpeed * 0.1) * partRadius
 local z = math.sin(time * partSpeed * 0.1) * partRadius
 local y = math.sin(time * partSpeed * 0.05) * 10 + 500 mainPart.Position = Vector3.new(x - 29, y, z + 30) for i = 2, #storedSecurityParts do
 local followerPart = storedSecurityParts[i]
 if followerPart and followerPart.Parent then
 local offsetX = (i - 1) * 5
 local offsetZ = (i - 1) * 5
 followerPart.Position = mainPart.Position + Vector3.new(offsetX, 0, offsetZ)
 end
 end
 else
 movingSecurityParts = false
 end
 end)
 else
 restoreInvisPartsCollision() if movementConnection then
 movementConnection:Disconnect()
 movementConnection = nil
 end for _, part in ipairs(storedSecurityParts) do
 if part and part.Parent then
 part.Anchored = true
 part.Position = Vector3.new(0, 500, 0) for _, child in ipairs(part:GetChildren()) do
 if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyForce") then
 child:Destroy()
 end
 end
 end
 end
 storedSecurityParts = {}
 end
 end
})

 partSpeedInput = Tabs.Utility:Input({
 Title = "Part Speed",
 Flag = "partSpeedInput",
 Placeholder = "10",
 Value = tostring(partSpeed),
 NumbersOnly = true,
 Callback = function(value)
 local speed = tonumber(value)
 if speed and speed > 0 then
 partSpeed = speed
 end
 end
})

 partRadiusInput = Tabs.Utility:Input({
 Title = "Part Radius",
 Flag = "partRadiusInput",
 Placeholder = "100",
 Value = tostring(partRadius),
 NumbersOnly = true,
 Callback = function(value)
 local radius = tonumber(value)
 if radius and radius > 0 then
 partRadius = radius
 end
 end
})

local speedPadConnection = nil
local speedPadCharAddedConn = nil
local speedPadObjects = {}

if not featureStates.SpeedPadValue then
 featureStates.SpeedPadValue = 1.3
end
if not featureStates.SpeedPadDuration then
 featureStates.SpeedPadDuration = 2
end

function cleanupSpeedPadObjects()
 for _, obj in pairs(speedPadObjects) do
 if obj.connection and obj.connection.Connected then
 obj.connection:Disconnect()
 end
 end
 speedPadObjects = {}
end

function setupSpeedPadBooster()
 cleanupSpeedPadObjects()
 
 function findSpeedPads()
 local pads = {}
 local deployables = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Deployables")
 if not deployables then return pads end for _, pad in ipairs(deployables:GetChildren()) do
 if string.find(pad.Name:lower(), "speed") then
 table.insert(pads, pad)
 end
 end
 return pads
 end

 function createSpeedPadMonitor(pad)
 local padId = tostring(pad:GetDebugId()) if speedPadObjects[padId] and speedPadObjects[padId].connection then
 speedPadObjects[padId].connection:Disconnect()
 end

 local connection = RunService.Heartbeat:Connect(function()
 if not pad or not pad.Parent then
 if connection.Connected then
 connection:Disconnect()
 end
 speedPadObjects[padId] = nil
 return
 end

 local character = player.Character
 if not character then return end local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return end

 local padPosition = pad.PrimaryPart and pad.PrimaryPart.Position or pad:GetPivot().Position
 local distance = (humanoidRootPart.Position - padPosition).Magnitude if distance >= 1 and distance <= 9 then
 if not speedPadObjects[padId].lastBoost or (tick() - speedPadObjects[padId].lastBoost) > 1 then
 pcall(function()
 firesignal(ReplicatedStorage.Events.Character.SpeedBoost.OnClientEvent, "SpeedPad", featureStates.SpeedPadValue, featureStates.SpeedPadDuration, Color3.new(0.490196, 0.607843, 1.000000))
 end)
 speedPadObjects[padId].lastBoost = tick()
 end
 end
 end)

 speedPadObjects[padId] = {
 connection = connection,
 lastBoost = 0,
 pad = pad
 }
 end

 local deployables = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Deployables")
 if deployables then
 for _, pad in ipairs(findSpeedPads()) do
 createSpeedPadMonitor(pad)
 end if speedPadObjects.childAddedConn and speedPadObjects.childAddedConn.Connected then
 speedPadObjects.childAddedConn:Disconnect()
 end
 speedPadObjects.childAddedConn = deployables.ChildAdded:Connect(function(child)
 task.wait(0.5)
 if string.find(child.Name:lower(), "speed") then
 createSpeedPadMonitor(child)
 end
 end) if speedPadObjects.childRemovedConn and speedPadObjects.childRemovedConn.Connected then
 speedPadObjects.childRemovedConn:Disconnect()
 end
 speedPadObjects.childRemovedConn = deployables.ChildRemoved:Connect(function(child)
 local padId = tostring(child:GetDebugId())
 if speedPadObjects[padId] and speedPadObjects[padId].connection then
 speedPadObjects[padId].connection:Disconnect()
 speedPadObjects[padId] = nil
 end
 end)
 end
end
 Tabs.Utility:Space()
 
SpeedPadToggle = Tabs.Utility:Toggle({
 Title = "SpeedPad Booster",
 Flag = "SpeedPadToggle",
 Value = false,
 Callback = function(state)
 featureStates.SpeedPad = state
 if state then
 if not player.Character then
 player.CharacterAdded:Wait()
 end
 task.wait(1)
 setupSpeedPadBooster() if speedPadCharAddedConn then
 speedPadCharAddedConn:Disconnect()
 end
 speedPadCharAddedConn = player.CharacterAdded:Connect(function()
 task.wait(2)
 if featureStates.SpeedPad then
 setupSpeedPadBooster()
 end
 end)
 else
 cleanupSpeedPadObjects()
 if speedPadCharAddedConn then
 speedPadCharAddedConn:Disconnect()
 speedPadCharAddedConn = nil
 end
 end
 end
})

SpeedPadValueInput = Tabs.Utility:Input({
 Title = "Speed Value",
 Flag = "SpeedPadValueInput",
 Placeholder = "1.3",
 Value = tostring(featureStates.SpeedPadValue),
 NumbersOnly = true,
 Callback = function(text)
 local num = tonumber(text)
 if num then
 featureStates.SpeedPadValue = num
 end
 end
})

SpeedPadDurationInput = Tabs.Utility:Input({
 Title = "Duration",
 Flag = "SpeedPadDurationInput",
 Placeholder = "2",
 Value = tostring(featureStates.SpeedPadDuration),
 NumbersOnly = true,
 Callback = function(text)
 local num = tonumber(text)
 if num then
 featureStates.SpeedPadDuration = num
 end
 end
})

local jumpPadConnection = nil
local jumpPadCharAddedConn = nil
local jumpPadObjects = {}

if not featureStates.JumpPadBooster then
 featureStates.JumpPadBooster = false
end
if not featureStates.JumpPadValue then
 featureStates.JumpPadValue = 0
end

function cleanupJumpPadObjects()
 for _, obj in pairs(jumpPadObjects) do
 if obj.connection and obj.connection.Connected then
 obj.connection:Disconnect()
 end
 end
 jumpPadObjects = {}
 
 for _, obj in ipairs(workspace:GetChildren()) do
 if obj.Name == "TempBouncePart" then
 obj:Destroy()
 end
 end
end

function setupJumpPadBooster()
 cleanupJumpPadObjects()
 
 local character = player.Character
 if not character then return end
 
 local humanoid = character:FindFirstChild("Humanoid")
 local rootPart = character:FindFirstChild("HumanoidRootPart")
 if not humanoid or not rootPart then return end
 
 function findJumpPads()
 local pads = {}
 local deployables = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Deployables")
 if not deployables then return pads end for _, pad in ipairs(deployables:GetChildren()) do
 if string.find(pad.Name:lower(), "jump") then
 table.insert(pads, pad)
 end
 end
 return pads
 end

 function createJumpPadMonitor(pad)
 local padId = tostring(pad:GetDebugId()) if jumpPadObjects[padId] and jumpPadObjects[padId].connection then
 jumpPadObjects[padId].connection:Disconnect()
 end

 local connection = ReplicatedStorage.Events.Other.DeployableUsed.OnClientEvent:Connect(function(deployable, usedOnPlayerModel)
 if deployable ~= pad then return end
 if not usedOnPlayerModel or not usedOnPlayerModel.Parent then return end
 if usedOnPlayerModel.Name ~= player.Name then return end
 if usedOnPlayerModel.Parent ~= workspace.Game.Players then return end

 local currentCharacter = player.Character
 if not currentCharacter then return end local currentHumanoid = currentCharacter:FindFirstChild("Humanoid")
 local currentRootPart = currentCharacter:FindFirstChild("HumanoidRootPart")
 if not currentHumanoid or not currentRootPart then return end

 currentRootPart.Velocity = Vector3.new(0, featureStates.JumpPadValue, 0)
 currentHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
 end)

 jumpPadObjects[padId] = {
 connection = connection,
 pad = pad
 }
 end

 local deployables = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Deployables")
 if deployables then
 for _, pad in ipairs(findJumpPads()) do
 createJumpPadMonitor(pad)
 end if jumpPadObjects.childAddedConn and jumpPadObjects.childAddedConn.Connected then
 jumpPadObjects.childAddedConn:Disconnect()
 end
 jumpPadObjects.childAddedConn = deployables.ChildAdded:Connect(function(child)
 task.wait(0.5)
 if string.find(child.Name:lower(), "jump") then
 createJumpPadMonitor(child)
 end
 end) if jumpPadObjects.childRemovedConn and jumpPadObjects.childRemovedConn.Connected then
 jumpPadObjects.childRemovedConn:Disconnect()
 end
 jumpPadObjects.childRemovedConn = deployables.ChildRemoved:Connect(function(child)
 local padId = tostring(child:GetDebugId())
 if jumpPadObjects[padId] and jumpPadObjects[padId].connection then
 jumpPadObjects[padId].connection:Disconnect()
 jumpPadObjects[padId] = nil
 end
 end)
 end
end
 Tabs.Utility:Space()
 
JumpPadToggle = Tabs.Utility:Toggle({
 Title = "Jump Pad Booster",
 Flag = "JumpPadToggle",
 Value = false,
 Callback = function(state)
 featureStates.JumpPadBooster = state
 if state then
 if not player.Character then
 player.CharacterAdded:Wait()
 end
 task.wait(1)
 setupJumpPadBooster()

 if jumpPadCharAddedConn then
 jumpPadCharAddedConn:Disconnect()
 end
 jumpPadCharAddedConn = player.CharacterAdded:Connect(function()
 task.wait(2)
 if featureStates.JumpPadBooster then
 setupJumpPadBooster()
 end
 end)

 local character = player.Character
 if character then
 local humanoid = character:FindFirstChild("Humanoid")
 local rootPart = character:FindFirstChild("HumanoidRootPart")
 if humanoid and rootPart and humanoid.FloorMaterial == Enum.Material.Air then
 local tempPart = Instance.new("Part")
 tempPart.Name = "TempBouncePart"
 tempPart.Size = Vector3.new(10, 1, 10)
 tempPart.Position = rootPart.Position - Vector3.new(0, 3, 0)
 tempPart.Anchored = true
 tempPart.CanCollide = true
 tempPart.Transparency = 1
 tempPart.Parent = workspace

 rootPart.Velocity = Vector3.new(0, featureStates.JumpPadValue, 0)
 humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

 game:GetService("Debris"):AddItem(tempPart, 1)
 end
 end
 else
 cleanupJumpPadObjects()
 if jumpPadCharAddedConn then
 jumpPadCharAddedConn:Disconnect()
 jumpPadCharAddedConn = nil
 end
 end
 end
})

JumpPadValueInput = Tabs.Utility:Input({
 Title = "Jump Value",
 Flag = "JumpPadValueInput",
 Placeholder = "0",
 Value = tostring(featureStates.JumpPadValue),
 NumbersOnly = true,
 Callback = function(text)
 local num = tonumber(text)
 if num then
 featureStates.JumpPadValue = num
 end
 end
})
 Tabs.Utility:Space()
Tabs.Utility:Button({
 Title = "Fix Drink Cola Animation",
 Desc = "If you clicked on this, The infinite cola script will no longer work",
 Callback = function()
 local Event = game:GetService("Players").LocalPlayer.PlayerScripts.Events.temporary_events.UseKeybind local mt = getrawmetatable(Event)
 local oldNamecall = mt.__namecall setreadonly(mt, false)
 mt.__namecall = newcclosure(function(self, ...)
 local method = getnamecallmethod()
 local args = {...} if method == "Fire" and self == Event then
 if args[1] and args[1].Key and args[1].Key == "Cola" then
 game:GetService("ReplicatedStorage").Events.Character.ToolAction:FireServer(0,19)
 return wait()
 end
 end return oldNamecall(self, ...)
 end)
 setreadonly(mt, true)
 end
})
UnlimitedColaToggle = Tabs.Utility:Toggle({
 Title = "Unlimited Cola",
 Flag = "UnlimitedColaToggle",
 Desc = "Block The ''ToolAction:FireServer'' remote when the value is ''(0, 19)'' This feature is a visual So no one can see you drink, Have fun of trick your viewer",
 Value = false,
 Callback = function(state)
 featureStates.UnlimitedCola = state if state then
 local RemoteEvent = ReplicatedStorage.Events.Character.ToolAction
 local SpeedBoostEvent = ReplicatedStorage.Events.Character.SpeedBoost

 -- Hook into the ToolAction remote event
 local mt = getrawmetatable(RemoteEvent)
 local oldNamecall = mt.__namecall

 local recentBlockTime = 0
 local blockCooldown = 0.1

 setreadonly(mt, false)

 mt.__namecall = newcclosure(function(self, ...)
 local method = getnamecallmethod()
 local args = {...}
 
 if method == "FireServer" and self == RemoteEvent then
 if args[2] == 19 then -- Cola action
 local currentTime = tick() if currentTime - recentBlockTime >= blockCooldown then
 recentBlockTime = currentTime
 
 -- Fire the speed boost signal after blocking the cola drink
 task.delay(2.15, function()
 if featureStates.UnlimitedCola then
 firesignal(SpeedBoostEvent.OnClientEvent, "Cola", 1.4, 3.5, Color3.fromRGB(199, 141, 93))
 end
 end)
 
 return nil -- Block the original cola drink
 end
 end
 end
 
 return oldNamecall(self, ...)
 end)

 setreadonly(mt, true)

 featureStates.ColaMetatableHook = {
 mt = mt,
 oldNamecall = oldNamecall
 }

 else
 if featureStates.ColaMetatableHook then
 local mt = featureStates.ColaMetatableHook.mt
 local oldNamecall = featureStates.ColaMetatableHook.oldNamecall
 
 setreadonly(mt, false)
 mt.__namecall = oldNamecall
 setreadonly(mt, true)
 
 featureStates.ColaMetatableHook = nil
 end
 end
 end
})

ColaSpeedBoosterToggle = Tabs.Utility:Toggle({
 Title = "Cola Speed Booster",
 Flag = "ColaSpeedBoosterToggle",
 Value = false,
 Callback = function(state)
 featureStates.ColaSpeedBooster = state if state then
 local RemoteEvent = ReplicatedStorage.Events.Character.ToolAction
 local SpeedBoostEvent = ReplicatedStorage.Events.Character.SpeedBoost

 -- Hook into the ToolAction remote event
 local mt = getrawmetatable(RemoteEvent)
 local oldNamecall = mt.__namecall

 setreadonly(mt, false)

 mt.__namecall = newcclosure(function(self, ...)
 local method = getnamecallmethod()
 local args = {...}
 
 if method == "FireServer" and self == RemoteEvent and featureStates.ColaSpeedBooster then
 if args[2] == 19 then -- Cola action
 -- Fire the boosted speed signal after a delay
 task.delay(2.14, function()
 if featureStates.ColaSpeedBooster then
 local speed = featureStates.ColaSpeedValue or 1.4
 local duration = featureStates.ColaDurationValue or 3.5
 firesignal(SpeedBoostEvent.OnClientEvent, "Cola", speed, duration, Color3.fromRGB(199, 141, 93))
 end
 end)
 end
 end
 
 return oldNamecall(self, ...)
 end)

 setreadonly(mt, true)

 featureStates.ColaSpeedMetatableHook = {
 mt = mt,
 oldNamecall = oldNamecall
 }

 else
 if featureStates.ColaSpeedMetatableHook then
 local mt = featureStates.ColaSpeedMetatableHook.mt
 local oldNamecall = featureStates.ColaSpeedMetatableHook.oldNamecall
 
 setreadonly(mt, false)
 mt.__namecall = oldNamecall
 setreadonly(mt, true)
 
 featureStates.ColaSpeedMetatableHook = nil
 end
 end
 end
})

ColaSpeedInput = Tabs.Utility:Input({
 Title = "Speed Value",
 Flag = "ColaSpeedInput",
 Placeholder = "1.4",
 NumbersOnly = true,
 Callback = function(value)
 local num = tonumber(value)
 if num and num > 0 then
 featureStates.ColaSpeedValue = num
 end
 end
})

ColaDurationInput = Tabs.Utility:Input({
 Title = "Duration",
 Flag = "ColaDurationInput",
 Placeholder = "3.5",
 NumbersOnly = true,
 Callback = function(value)
 local num = tonumber(value)
 if num and num > 0 then
 featureStates.ColaDurationValue = num
 end
 end
})

function handleRespawn()
 task.wait(2)
 
 if featureStates.SpeedPad then
 setupSpeedPadBooster()
 end
 
 if featureStates.JumpPadBooster then
 setupJumpPadBooster()
 end
end

player.CharacterAdded:Connect(handleRespawn)

task.spawn(function()
 task.wait(3)
 if featureStates.SpeedPad then
 setupSpeedPadBooster()
 end
 if featureStates.JumpPadBooster then
 setupJumpPadBooster()
 end
end)
-- teleports tab
Tabs.Teleport:Section({ Title = "Teleports", TextSize = 20 })
Tabs.Teleport:Divider()

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Spawn",
 Desc = "Teleport to a random spawn location",
 Icon = "home",
 Callback = function()
 local spawnsFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Map") and workspace.Game.Map:FindFirstChild("Parts") and workspace.Game.Map.Parts:FindFirstChild("Spawns") if spawnsFolder then
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
 local validPlayers = {} for _, plr in ipairs(players) do
 if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
 table.insert(validPlayers, plr)
 end
 end if #validPlayers > 0 then
 local randomPlayer = validPlayers[math.random(1, #validPlayers)]
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
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
 local downedPlayers = {} if playersFolder then
 for _, model in ipairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and model:GetAttribute("Downed") == true and model.Name ~= player.Name then
 local hrp = model:FindFirstChild("HumanoidRootPart")
 if hrp then
 table.insert(downedPlayers, model)
 end
 end
 end
 end if #downedPlayers > 0 then
 local randomDowned = downedPlayers[math.random(1, #downedPlayers)]
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
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
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
 humanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
 end
 break
 end
 end
 end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Ticket",
 Desc = "Teleport to a random ticket",
 Icon = "ticket",
 Callback = function()
 local tickets = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Effects") and workspace.Game.Effects:FindFirstChild("Tickets") if tickets then
 local ticketList = tickets:GetChildren()
 if #ticketList > 0 then
 local randomTicket = ticketList[math.random(1, #ticketList)]
 local ticketPart = randomTicket:FindFirstChild("HumanoidRootPart")
 
 if ticketPart then
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
 humanoidRootPart.CFrame = ticketPart.CFrame + Vector3.new(0, 3, 0)
 end
 end
 end
 end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to Nextbot",
 Desc = "Teleport to a random nextbot",
 Icon = "ghost",
 Callback = function()
 local nextbots = {} local playersFolder = workspace:FindFirstChild("Game") and workspace.Game:FindFirstChild("Players")
 if playersFolder then
 for _, model in ipairs(playersFolder:GetChildren()) do
 if model:IsA("Model") and isNextbotModel(model) then
 local hrp = model:FindFirstChild("HumanoidRootPart")
 if hrp then
 table.insert(nextbots, model)
 end
 end
 end
 end local npcsFolder = workspace:FindFirstChild("NPCs")
 if npcsFolder then
 for _, model in ipairs(npcsFolder:GetChildren()) do
 if model:IsA("Model") and isNextbotModel(model) then
 local hrp = model:FindFirstChild("HumanoidRootPart")
 if hrp then
 table.insert(nextbots, model)
 end
 end
 end
 end if #nextbots > 0 then
 local randomNextbot = nextbots[math.random(1, #nextbots)]
 local character = player.Character
 local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart") if humanoidRootPart then
 humanoidRootPart.CFrame = randomNextbot.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
 end
 end
 end
})

Tabs.Teleport:Space()
 
Tabs.Teleport:Button({
 Title = "Teleport to SecurityPart",
 Icon = "shield",
 Callback = function()
 local existingPart = workspace:FindFirstChild("SecurityPart") if existingPart then
 local character = game.Players.LocalPlayer.Character if character then
 local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
 
 if humanoidRootPart then
 humanoidRootPart.CFrame = existingPart.CFrame + Vector3.new(0, 3, 0)
 end
 end
 else
 print("SecurityPart not found")
 end
 end
})
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
 end if primaryPart then
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
 end if #objectiveNames > 0 then
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
 end local selectedObjective
 for _, obj in ipairs(objectives) do
 if obj.Name == selectedName then
 selectedObjective = obj
 break
 end
 end if not selectedObjective then
 return
 end local character = player.Character
 if not character then return end local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
 if not humanoidRootPart then return end local teleportPosition = selectedObjective.Position + Vector3.new(0, 5, 0) local raycastParams = RaycastParams.new()
 raycastParams.FilterDescendantsInstances = {character}
 raycastParams.FilterType = Enum.RaycastFilterType.Blacklist local ray = workspace:Raycast(teleportPosition, Vector3.new(0, -10, 0), raycastParams)
 if ray then
 teleportPosition = ray.Position + Vector3.new(0, 3, 0)
 end humanoidRootPart.CFrame = CFrame.new(teleportPosition)
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
 local gameFolder = workspace.Game if gameFolder:FindFirstChild("Stats") then
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
 local autoLoadFile = "Darahub/AutoLoad/Game/Evade/AutoLoad.json"
 
 if FileExists(autoLoadFile) then
 local content = ReadFile(autoLoadFile) if content ~= "" then
 local success, data = pcall(function()
 return HttpService:JSONDecode(content)
 end) if success and data then
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
 local autoLoadFile = "Darahub/AutoLoad/Game/Evade/AutoLoad.json"
 
 local success = WriteFile(autoLoadFile, "")
 if not success then
 if makefolder then
 pcall(function() makefolder("Darahub") end)
 pcall(function() makefolder("Darahub/AutoLoad") end)
 pcall(function() makefolder("Darahub/AutoLoad/Game") end)
 pcall(function() makefolder("Darahub/AutoLoad/Game/Evade") end)
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

ConfigNameInput = Tabs.Settings:Input({
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

AutoLoadToggle = Tabs.Settings:Toggle({
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

AutoSaveToggle = Tabs.Settings:Toggle({
 Title = "Auto Save",
 Flag = "AutoSaveToggle",
 Desc = "Automatically save changes to config every second",
 Value = AutoSaveEnabled,
 Callback = function(state)
 AutoSaveEnabled = state -- Stop existing auto-save loop if it exists
 if AutoSaveConnection then
 AutoSaveConnection:Disconnect()
 AutoSaveConnection = nil
 end if state then
 WindUI:Notify({
 Title = "Auto-Save",
 Content = "Config will save automatically every second",
 Duration = 2
 }) -- Start auto-save loop
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
 ConfigNameInput:Set(value) if AutoLoadEnabled then
 AutoLoadConfig = value
 saveAutoLoadSettings()
 end local config = ConfigManager:GetConfig(value)
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

SaveConfigButton = Tabs.Settings:Button({
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
 end Window.CurrentConfig = ConfigManager:Config(CurrentConfigName) local success = Window.CurrentConfig:Save()
 if success then
 WindUI:Notify({
 Title = "Config Saved",
 Content = "Config '" .. CurrentConfigName .. "' saved successfully",
 Duration = 3
 }) if AutoLoadEnabled then
 AutoLoadConfig = CurrentConfigName
 saveAutoLoadSettings()
 end task.wait(0.5)
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

LoadConfigButton = Tabs.Settings:Button({
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
 end Window.CurrentConfig = ConfigManager:CreateConfig(CurrentConfigName) local success = Window.CurrentConfig:Load()
 if success then
 WindUI:Notify({
 Title = "Config Loaded",
 Content = "Config '" .. CurrentConfigName .. "' loaded successfully",
 Duration = 3
 }) if AutoLoadEnabled then
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

DeleteConfigButton = Tabs.Settings:Button({
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
 end local success = ConfigManager:DeleteConfig(CurrentConfigName)
 if success then
 WindUI:Notify({
 Title = "Config Deleted",
 Content = "Config '" .. CurrentConfigName .. "' deleted",
 Duration = 3
 }) CurrentConfigName = "default"
 ConfigNameInput:Set("default") if AutoLoadEnabled then
 AutoLoadConfig = "default"
 saveAutoLoadSettings()
 end task.wait(0.5)
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

RefreshConfigButton = Tabs.Settings:Button({
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
 ConfigNameInput:Set(CurrentConfigName) task.wait(1)
 Window.CurrentConfig = ConfigManager:Config(CurrentConfigName) if Window.CurrentConfig:Load() then
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
 task.wait(1) if AutoSaveEnabled then
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

themes = {}

success, availableThemes = pcall(function()
return WindUI:GetThemes()
end)

if success and type(availableThemes) == "table" then
for themeName, _ in pairs(availableThemes) do
table.insert(themes, themeName)
end
table.sort(themes)
else
warn("Failed to load themes, using defaults")
themes = {"Dark", "Light"}
end

canChangeTheme = true
canChangeDropdown = true

ThemeDropdown = Tabs.Settings:Dropdown({
Title = "Select Theme",
Flag = "ThemeDropdown",
Values = themes,
SearchBarEnabled = true,
MenuWidth = 280,
Value = themes[1] or "Dark",
Callback = function(theme)
if canChangeDropdown then
canChangeTheme = false
pcall(function()
WindUI:SetTheme(theme)
end)
canChangeTheme = true

-- Sync toggle with new theme
if ThemeToggle then
ThemeToggle:Set(theme == "Dark")
end
end
end
})

TransparencySlider = Tabs.Settings:Slider({
Title = "Window Transparency",
Step = 0.1,
Flag = "TransparencySlider",
Value = { Min = 0, Max = 1, Default = 1 },
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
newTheme = state and "Dark" or "Light"
canChangeDropdown = false
pcall(function()
WindUI:SetTheme(newTheme)
end)

if ThemeDropdown then
ThemeDropdown:Select(newTheme)
end
canChangeDropdown = true
end
end
})

success = pcall(function()
WindUI:OnThemeChange(function(theme)
canChangeTheme = false
if ThemeToggle then
ThemeToggle:Set(theme == "Dark")
end
canChangeTheme = true
end)
end)

if not success then
warn("WindUI:OnThemeChange is not available")
end

if WindUI and WindUI.GetTheme then
success, currentTheme = pcall(function()
return WindUI:GetTheme()
end)

if success and currentTheme then
canChangeDropdown = false
if ThemeDropdown then
ThemeDropdown:Select(currentTheme)
end
if ThemeToggle then
ThemeToggle:Set(currentTheme == "Dark")
end
canChangeDropdown = true
end
end
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
Tabs.Settings:Keybind({ Flag = "StopRecord", Title = "Stop Recording", Value = "", Callback = StopRecord })
Tabs.Settings:Keybind({ Flag = "PlayTAS", Title = "Play TAS", Value = "", Callback = PlayTAS })
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
-- Game Settings Section
Tabs.Settings:Section({ Title = "Game Settings" })
Tabs.Settings:Divider()
settingsElements = {}
defaultSettings = {}
currentSettings = {}
pendingUpdates = {}
updateCooldown = 1
lastUpdateTime = tick()
settingsUpdatedEvent = game.ReplicatedStorage.Modules.Client.Settings.Updated
changeSettingRemote = game.ReplicatedStorage.Events.Data.ChangeSetting

success, settingsModule = pcall(function()
return require(game.ReplicatedStorage.Modules.TablesAndMethods.DefaultSettings)
end)

if success and settingsModule then
for _, setting in pairs(settingsModule) do
if setting.Name then
defaultSettings[setting.Name] = {
Tag = setting.Tag,
Type = type(setting.Value or setting.DefaultValue),
Default = setting.Value or setting.DefaultValue
}
end
end
end

function fetchCurrentSettings()
local clientSettingsModule = game.ReplicatedStorage.Modules.Client.Settings
if clientSettingsModule and clientSettingsModule.GetSetting then
for settingName, data in pairs(defaultSettings) do
local currentValue = clientSettingsModule.GetSetting:Invoke(settingName)
if currentValue ~= nil then
currentSettings[settingName] = currentValue
else
currentSettings[settingName] = data.Default
end
end
end
end

fetchCurrentSettings()

for settingName, settingData in pairs(defaultSettings) do
if settingData.Type == "boolean" then
settingsElements[settingName] = Tabs.Settings:Toggle({
Title = settingName,
Value = currentSettings[settingName] or false,
Callback = function(state)
if currentSettings[settingName] == state then return end

changeSettingRemote:InvokeServer(settingData.Tag, state)
settingsUpdatedEvent:Fire(settingData.Tag, state)
currentSettings[settingName] = state
pendingUpdates[settingName] = true
lastUpdateTime = tick()
end
})
elseif settingData.Type == "number" then
settingsElements[settingName] = Tabs.Settings:Input({
Title = settingName,
Placeholder = tostring(currentSettings[settingName] or settingData.Default),
Value = tostring(currentSettings[settingName] or settingData.Default),
Callback = function(value)
local numValue = tonumber(value)
if numValue and currentSettings[settingName] ~= numValue then
changeSettingRemote:InvokeServer(settingData.Tag, numValue)
settingsUpdatedEvent:Fire(settingData.Tag, numValue)
currentSettings[settingName] = numValue
pendingUpdates[settingName] = true
lastUpdateTime = tick()
end
end
})
end
end

settingsUpdatedEvent.Event:Connect(function(tag, value)
for settingName, data in pairs(defaultSettings) do
if data.Tag == tag then
if currentSettings[settingName] ~= value then
currentSettings[settingName] = value
if settingsElements[settingName] then
if data.Type == "boolean" then
settingsElements[settingName]:Set(value)
elseif data.Type == "number" then
settingsElements[settingName]:Set(tostring(value))
end
end
end
break
end
end
end)

RunService.Heartbeat:Connect(function()
local now = tick()
if now - lastUpdateTime >= updateCooldown and next(pendingUpdates) ~= nil then
fetchCurrentSettings()

for settingName, _ in pairs(pendingUpdates) do
local data = defaultSettings[settingName]
if data and currentSettings[settingName] then
if settingsElements[settingName] then
if data.Type == "boolean" then
if settingsElements[settingName].Value ~= currentSettings[settingName] then
settingsElements[settingName]:Set(currentSettings[settingName])
end
elseif data.Type == "number" then
local currentValue = settingsElements[settingName].Value or ""
if tostring(currentSettings[settingName]) ~= currentValue then
settingsElements[settingName]:Set(tostring(currentSettings[settingName]))
end
end
end
end
end

pendingUpdates = {}
end
end)

-- GUI Scale Section
CoreGui = game:GetService("CoreGui")
DarahubFolder = CoreGui:FindFirstChild("Darahub")

if DarahubFolder and Tabs and Tabs.Settings then
Tabs.Settings:Section({ Title = "GUI Size" })
defaultScales = {}

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

Tabs.Settings:Section({ Title = "UI Visiblety", TextSize = 20 })
Tabs.Settings:Divider()

TopGuiButtonDropdown = Tabs.Settings:Dropdown({
Title = "Top UI Visiblety",
Flag = "TopGuiButtonDropdown",
Desc = "Show/hide buttons in CustomTopGui",
Values = {"SecondaryButton", "ReloadButton", "LeaderboardButton"},
Multi = true,
AllowNone = true,
Value = {"SecondaryButton", "ReloadButton", "LeaderboardButton"},
Callback = function(values)
playerGui = player.PlayerGui
customTopGui = playerGui:FindFirstChild("CustomTopGui")
if not customTopGui then return end
frame = customTopGui:FindFirstChild("Frame")
if not frame then return end
rightFrame = frame:FindFirstChild("Right")
if not rightFrame then return end
buttonNames = {"SecondaryButton", "ReloadButton", "LeaderboardButton"}
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
MIN_SENSITIVITY = 0.1
MAX_SENSITIVITY = 20.0
DEFAULT_SENSITIVITY = 1.0
cameraInputModule = nil
mouseHookActive = false
touchHookActive = false

function setupSensitivityHook()
if cameraInputModule then return true end

player = game:GetService("Players").LocalPlayer
success = false

pcall(function()
playerScripts = player:FindFirstChild("PlayerScripts")
if not playerScripts then return end
playerModule = playerScripts:FindFirstChild("PlayerModule")
if not playerModule then return end
cameraModule = playerModule:FindFirstChild("CameraModule")
if cameraModule then
cameraInput = cameraModule:FindFirstChild("CameraInput")
if cameraInput then
cameraInputModule = require(cameraInput)
if cameraInputModule and cameraInputModule.getRotation then
originalGetRotation = cameraInputModule.getRotation
cameraInputModule.getRotation = function(disableRotation)
rotation = originalGetRotation(disableRotation)
uis = game:GetService("UserInputService")
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

Window:SelectTab(1)
task.spawn(function()
while true do
task.wait(0.5)
local currentlyPresent = isPlayerModelPresent()
if currentlyPresent and not playerModelPresent then
playerModelPresent = true
applyStoredSettings()
elseif not currentlyPresent and playerModelPresent then
playerModelPresent = false
end
end
end)
