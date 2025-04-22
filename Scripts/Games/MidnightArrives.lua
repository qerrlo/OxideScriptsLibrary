-- Author: @hinorium
-- Game: Midnight Arrives™
-- Version: 1.1

if game.PlaceId ~= 185115596 then
	return warn("Wrong place!")
end

local COREGUI = game:GetService("CoreGui")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GroupService = game:GetService("GroupService")
local PathService = game:GetService("PathfindingService")
local SoundService = game:GetService("SoundService")
local Teams = game:GetService("Teams")
local StarterPlayer = game:GetService("StarterPlayer")
local InsertService = game:GetService("InsertService")
local ChatService = game:GetService("Chat")
local ProximityPromptService = game:GetService("ProximityPromptService")
local StatsService = game:GetService("Stats")
local MaterialService = game:GetService("MaterialService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local TextChatService = game:GetService("TextChatService")
local CaptureService = game:GetService("CaptureService")
local VoiceChatService = game:GetService("VoiceChatService")

local PlaceId, JobId = game.PlaceId, game.JobId
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

local CurrentVersion = "1.1"

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function updateCharacter(newCharacter)
	Character = newCharacter
end
LocalPlayer.CharacterAdded:Connect(updateCharacter)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Midnight Arrives™",
	LoadingTitle = "MA™ - v" .. CurrentVersion,
	LoadingSubtitle = "by hinorium",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "OxideHubConfig",
		FileName = "Settings"
	},
	KeySystem = false
})

type rayfield_notify_container = {
	Content: string?,
	Title: string?,
	Duration: number?,
	Image: string?
}

function notify(title: string?, content: string?, duration: number?): rayfield_notify_container
	return Rayfield:Notify({
		Title = title or "N/A",
		Content = content or "N/A",
		Duration = duration or 6.5,
		Image = "circle-alert",
	})
end

function WaitForChildOfClass(parent, className)
	while true do
		local child = parent:FindFirstChildOfClass(className)
		if child then
			return child
		end
		parent.ChildAdded:Wait()
	end
end

local MainTab = Window:CreateTab("Main", "code-xml")
local MainButtonsSection = MainTab:CreateSection("Buttons")

local EspTab = Window:CreateTab("ESP", "user-round-search")
local EspButtonsSection = EspTab:CreateSection("Buttons")

local ESPManager = {
	enabled = {
		monster = false,
		collect = false
	},
	monsters = {},
	collectibles = {},
	espObjects = {
		monster = {},
		collect = {}
	},
	connections = {}
}

-- Существующие функции для монстров остаются без изменений

function ESPManager:GetCollectibles()
	local collectibles = {}
	local currentMap = workspace.CurrentMap:GetChildren()[1]
	if currentMap and currentMap:FindFirstChild("To_Collect") then
		for _, item in ipairs(currentMap.To_Collect:GetChildren()) do
			table.insert(collectibles, item)
		end
	end
	return collectibles
end

function ESPManager:CreateCollectibleESP(item)
	if not item then return end

	local espData = {
		highlight = Instance.new("Highlight"),
		gui = Instance.new("BillboardGui"),
		nameLabel = Instance.new("TextLabel"),
		distanceLabel = Instance.new("TextLabel")
	}

	-- Highlight setup
	espData.highlight.Name = "esp"
	espData.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	espData.highlight.FillColor = Color3.fromRGB(255, 255, 0) -- Желтый цвет для collectibles
	espData.highlight.FillTransparency = 0.5
	espData.highlight.OutlineColor = Color3.fromRGB(155, 155, 0)
	espData.highlight.OutlineTransparency = 0
	espData.highlight.Parent = item

	-- GUI setup
	espData.gui.Name = "espGui"
	espData.gui.Adornee = item
	espData.gui.AlwaysOnTop = true
	espData.gui.Size = UDim2.new(0, 50, 0, 50)
	espData.gui.StudsOffsetWorldSpace = Vector3.new(0, 2, 0)
	espData.gui.Parent = item

	local uilist = Instance.new("UIListLayout")
	uilist.FillDirection = Enum.FillDirection.Vertical
	uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uilist.Parent = espData.gui

	-- Labels setup
	espData.nameLabel.BackgroundTransparency = 1
	espData.nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
	espData.nameLabel.Font = Enum.Font.RobotoMono
	espData.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	espData.nameLabel.TextScaled = true
	espData.nameLabel.Parent = espData.gui

	espData.distanceLabel.BackgroundTransparency = 1
	espData.distanceLabel.Size = UDim2.new(1, 0, 0.2, 0)
	espData.distanceLabel.Font = Enum.Font.RobotoMono
	espData.distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	espData.distanceLabel.TextScaled = true
	espData.distanceLabel.Parent = espData.gui

	return espData
end

function ESPManager:UpdateCollectibleESP(item, espData)
	if not self.enabled.collect or not item or not Character then return end

	if espData.nameLabel then
		espData.nameLabel.Text = item.Name
	end

	if espData.distanceLabel then
		local characterRoot = Character:FindFirstChild("HumanoidRootPart")
		if characterRoot then
			local distance = (item.Position - characterRoot.Position).Magnitude
			espData.distanceLabel.Text = string.format("Distance: %d", math.floor(distance))
		end
	end
end

function ESPManager:SetEnabled(type, enabled)
	self.enabled[type] = enabled

	if type == "monster" then
		if enabled then
			for _, monster in ipairs(self:GetMonsters()) do
				self.espObjects.monster[monster] = self:CreateESPObject(monster)
			end
		else
			for monster, espData in pairs(self.espObjects.monster) do
				self:CleanupESPObject(espData)
			end
			self.espObjects.monster = {}
		end
	elseif type == "collect" then
		if enabled then
			for _, item in ipairs(self:GetCollectibles()) do
				self.espObjects.collect[item] = self:CreateCollectibleESP(item)
			end
		else
			for item, espData in pairs(self.espObjects.collect) do
				self:CleanupESPObject(espData)
			end
			self.espObjects.collect = {}
		end
	end

	-- Update connection
	if self.connections.update then
		self.connections.update:Disconnect()
	end

	if self.enabled.monster or self.enabled.collect then
		self.connections.update = RunService.RenderStepped:Connect(function()
			if self.enabled.monster then
				for monster, espData in pairs(self.espObjects.monster) do
					if monster.Parent then
						self:UpdateESPInfo(monster, espData)
					else
						self:CleanupESPObject(espData)
						self.espObjects.monster[monster] = nil
					end
				end
			end

			if self.enabled.collect then
				for item, espData in pairs(self.espObjects.collect) do
					if item.Parent then
						self:UpdateCollectibleESP(item, espData)
					else
						self:CleanupESPObject(espData)
						self.espObjects.collect[item] = nil
					end
				end
			end
		end)
	end
end

-- Обработчики событий для To_Collect
workspace.CurrentMap.ChildAdded:Connect(function(map)
	if ESPManager.enabled.collect then
		task.wait(1) -- Даем время на загрузку To_Collect
		if map:FindFirstChild("To_Collect") then
			for _, item in ipairs(map.To_Collect:GetChildren()) do
				ESPManager.espObjects.collect[item] = ESPManager:CreateCollectibleESP(item)
			end
		end
	end
end)

-- Обновляем колбэки для тогглов
local ESP_Toggles = {
	ESP_MonsterToggle = EspTab:CreateToggle({
		Name = "ESP Monster",
		CurrentValue = false,
		Flag = "ESP_Monster",
		Callback = function(Value)
			ESPManager:SetEnabled("monster", Value)
		end,
	}),
	ESP_ToCollectToggle = EspTab:CreateToggle({
		Name = "ESP ToCollect",
		CurrentValue = false,
		Flag = "ESP_ToCollect",
		Callback = function(Value)
			ESPManager:SetEnabled("collect", Value)
		end,
	})
}

local MiscTab = Window:CreateTab("Misc", "folder-cog")
local MiscButtonsSection = MiscTab:CreateSection("Buttons")
local MiscButtons = {
	Antiidle = MiscTab:CreateButton({
		Name = "Anti-Idle",
		Callback = function()
			local GC = getconnections or get_signal_cons
			if GC then
				for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
					if v["Disable"] then
						v["Disable"](v)
					elseif v["Disconnect"] then
						v["Disconnect"](v)
					end
				end
			else
				local VirtualUser = game:GetService("VirtualUser")
				Players.LocalPlayer.Idled:Connect(function()
					VirtualUser:CaptureController()
					VirtualUser:ClickButton2(Vector2.new())
				end)
			end
			notify('Anti Idle','Anti idle is enabled')
		end,
	}),
	ClientAntiKick = MiscTab:CreateButton({
		Name = "[Client] Anti-Kick",
		Callback = function()
			if not hookmetamethod then 
				return notify('Incompatible Exploit','Your exploit does not support this command (missing hookmetamethod)')
			end
			local LocalPlayer = Players.LocalPlayer
			local oldhmmi
			local oldhmmnc
			oldhmmi = hookmetamethod(game, "__index", function(self, method)
				if self == LocalPlayer and method:lower() == "kick" then
					return error("Expected ':' not '.' calling member function Kick", 2)
				end
				return oldhmmi(self, method)
			end)
			oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
				if self == LocalPlayer and getnamecallmethod():lower() == "kick" then
					return
				end
				return oldhmmnc(self, ...)
			end)

			notify('Client Antikick','Client anti kick is now active (only effective on localscript kick)')
		end,
	}),
	AutoRejoin = MiscTab:CreateButton({
		Name = "Auto-Rejoin",
		Callback = function()
			GuiService.ErrorMessageChanged:Connect(function()
				if #Players:GetPlayers() <= 1 then
					Players.LocalPlayer:Kick("\nRejoining...")
					wait()
					TeleportService:Teleport(PlaceId, Players.LocalPlayer)
				else
					TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
				end
			end)
			notify("Auto Rejoin", "Auto rejoin enabled")
		end,
	}),
	ClearError = MiscTab:CreateButton({
		Name = "Clear-Error",
		Callback = function()
			GuiService:ClearError()
		end,
	}),
}
