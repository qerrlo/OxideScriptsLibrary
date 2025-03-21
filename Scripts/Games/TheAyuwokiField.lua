-- Author: @hinorium

-- Game: The Ayuwoki Field
-- Version: 1.0

if (game.PlaceId ~= 4010883325) then
	return warn("this place don't expected")
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(_character)
	Character = _character
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "The Ayuwoki Field",
	Icon = "github",
	LoadingTitle = "Oxide Hub Loading...",
	LoadingSubtitle = "by qerrlo",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "OxideHubConfig",
		FileName = "Settings"
	},
	Discord = {
		Enabled = false,
		Invite = "YourDiscordInvite",
		RememberJoins = true
	},
	KeySystem = false,
	KeySettings = {
		Title = "Oxide Hub Authentication",
		Subtitle = "Premium Access",
		Note = "Join our Discord for the key (discord.gg/YourServer)",
		FileName = "OxideKey",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"OXIDE-PREMIUM-2024", "BETA-ACCESS-KEY"}
	}
})

local EspTab = Window:CreateTab("ESP", "user-round-search")

local MainSection = EspTab:CreateSection("Main")

local ayuwoki = nil
ayuwoki = workspace:FindFirstChild("Ayuwoki")

local esp, espGui, eg_ui_list, eg_name, eg_studs

local ESP_AyuwokiToggle = EspTab:CreateToggle({
	Name = "ESP Ayuwoki",
	CurrentValue = false,
	Flag = "ESP_Ayuwoki", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		if (ayuwoki:FindFirstChild("esp")) and (ayuwoki:FindFirstChild("espGui")) then ayuwoki.esp:Destroy() ayuwoki.espGui:Destroy() end

		esp = Instance.new("Highlight")
		esp.Name = "esp"
		esp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		esp.FillColor = Color3.fromRGB(255, 0, 0)
		esp.FillTransparency = 0.5
		esp.OutlineColor = Color3.fromRGB(155, 55, 55)
		esp.OutlineTransparency = 0
		esp.Parent = ayuwoki

		espGui = Instance.new("BillboardGui")
		espGui.Name = "espGui"
		espGui.Adornee = ayuwoki.Head
		espGui.AlwaysOnTop = true
		espGui.Size = UDim2.new(10, 0, 5, 0)
		espGui.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
		espGui.Enabled = true
		espGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		espGui.Parent = ayuwoki

		eg_ui_list = Instance.new("UIListLayout")
		eg_ui_list.Name = "$list"
		eg_ui_list.FillDirection = Enum.FillDirection.Vertical
		eg_ui_list.SortOrder = Enum.SortOrder.LayoutOrder
		eg_ui_list.Wraps = true
		eg_ui_list.HorizontalAlignment = Enum.HorizontalAlignment.Center
		eg_ui_list.HorizontalFlex = "None"
		eg_ui_list.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
		eg_ui_list.VerticalAlignment = Enum.VerticalAlignment.Bottom
		eg_ui_list.VerticalFlex = "None"

		eg_name = Instance.new("TextLabel")
		eg_name.Name = "name"
		eg_name.AnchorPoint = Vector2.new(0.5, 0)
		eg_name.BackgroundTransparency = 1
		eg_name.Size = UDim2.new(1, 0, 0.2, 0)
		eg_name.Font = Enum.Font.RobotoMono
		eg_name.Text = (ayuwoki and `name: {ayuwoki.Name}`) or `name: n/a`
		eg_name.TextColor3 = Color3.fromRGB(255, 255, 255)
		eg_name.TextScaled = true
		eg_name.TextSize = 24
		eg_name.TextTransparency = 0.2
		eg_name.TextWrapped = true
		eg_name.Visible = true		

		eg_studs = Instance.new("TextLabel")
		eg_studs.Name = "studs"
		eg_studs.AnchorPoint = Vector2.new(0.5, 0)
		eg_studs.BackgroundTransparency = 1
		eg_studs.Size = UDim2.new(1, 0, 0.2, 0)
		eg_studs.Font = Enum.Font.RobotoMono
		eg_studs.Text = (ayuwoki and `studs: {(ayuwoki.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude}`) or `studs: n/a`
		eg_studs.TextColor3 = Color3.fromRGB(255, 255, 255)
		eg_studs.TextScaled = true
		eg_studs.TextSize = 24
		eg_studs.TextTransparency = 0.2
		eg_studs.TextWrapped = true
		eg_studs.Visible = true
	end,
})

render_connection = RunService.RenderStepped:Connect(function()
	eg_name.Text = (ayuwoki and `name: {ayuwoki.Name}`) or `name: n/a`
	eg_studs.Text = (ayuwoki and `studs: {(ayuwoki.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude}`) or `studs: n/a`
end)

workspace.ChildAdded:Connect(function(child)
	if (child.Name == "Ayuwoki") then
		ayuwoki = child
	end
end)

workspace.ChildRemoved:Connect(function(child)
	if (child.Name == "Ayuwoki") then
		ayuwoki = nil
	end
end)
