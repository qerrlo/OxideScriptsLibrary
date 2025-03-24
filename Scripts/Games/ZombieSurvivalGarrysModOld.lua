-- Author: @hinorium

-- Game: Zombie Survival Garry's Mod [Old]
-- Version: 1.02b

if (game.PlaceId ~= 10149471313) then
	return warn("this place don't expected")
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

PlaceId, JobId = game.PlaceId, game.JobId
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Zombie Survival Garry's Mod [Old]",
	Icon = "github",
	LoadingTitle = "UI Loading...",
	LoadingSubtitle = "by hinorium",
	ConfigurationSaving = {
		Enabled = false,
		FolderName = "OxideHubConfig",
		FileName = "Settings"
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

local function fire_remote(remoteName: string, args: {any})
	local success, remote = pcall(function()
		return ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild(remoteName, 10)
	end)

	if not success or not remote then
		warn("Remote event not found:", remoteName)
		return false
	end

	local success2, result = pcall(function()
		remote:FireServer(unpack(args))
	end)

	if not success2 then
		warn("Failed to fire remote:", remoteName, result)
		return false
	end

	return true
end

local MiscTab = Window:CreateTab("Misc", "folder-cog")

local MainSection = MiscTab:CreateSection("Toggles")

local Toggles = {
	Bypass_OutsideGameArea = MiscTab:CreateToggle({
		Name = "[AC] - Outside GameArea - Bypass",
		CurrentValue = false,
		Flag = "__BYPASS_OutsideGameArea",
		Callback = function(Value)
			_G.BypassEnabled = Value

			local function applyBypass()
				local partsToModify = {
					workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Triggers"),
					workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("AC"),
					workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("GameArea")
				}

				for i, container in ipairs(partsToModify) do
					if not container then
						return false
					end
				end

				local success, error = pcall(function()
					if _G.BypassEnabled then
						for _, container in ipairs(partsToModify) do
							for _, part in ipairs(container:GetChildren()) do
								if part:IsA("BasePart") then
									if not part:GetAttribute("OriginalProperties") then
										part:SetAttribute("OriginalProperties", HttpService:JSONEncode({
											CanCollide = part.CanCollide,
											CanTouch = part.CanTouch,
											CanQuery = part.CanQuery
										}))
									end
									part.CanCollide = false
									part.CanTouch = false
									part.CanQuery = false
								end
							end
						end
					else
						local settings = {
							[workspace.Map.Triggers] = {CanCollide = false, CanTouch = true, CanQuery = true},
							[workspace.Map.AC] = {CanCollide = true, CanTouch = true, CanQuery = true},
							[workspace.Map.GameArea] = {CanCollide = false, CanTouch = true, CanQuery = false}
						}

						for _, container in ipairs(partsToModify) do
							local containerSettings = settings[container]
							if containerSettings then
								for _, part in ipairs(container:GetChildren()) do
									if part:IsA("BasePart") then
										for property, value in pairs(containerSettings) do
											part[property] = value
										end
									end
								end
							end
						end
					end
				end)

				if not success then
					warn("AC Bypass error:", error)
					return false
				end
				return true
			end

			applyBypass()

			if Value then
				if not _G.MapWatcher then
					_G.MapWatcher = workspace.ChildAdded:Connect(function(child)
						if child.Name == "Map" then
							task.wait(0.5)
							applyBypass()
						end
					end)
				end
			else
				if _G.MapWatcher then
					_G.MapWatcher:Disconnect()
					_G.MapWatcher = nil
				end
			end
		end,
	}),
	Disable_Barricades_Collisions = MiscTab:CreateToggle({
		Name = "[AC] - Barricades - Bypass (Not Server Barricades)",
		CurrentValue = false,
		Flag = "__BYPASS_Barricades_notserver",
		Callback = function(Value)
			_G.BarricadesBypassEnabled = Value

			local function applyBarricadesBypass()
				local barricadesModel = workspace:FindFirstChild("Barricades") and workspace.Barricades:FindFirstChild("Model")

				if not barricadesModel then
					return false
				end

				local success, error = pcall(function()
					if _G.BarricadesBypassEnabled then
						for _, barricade in ipairs(barricadesModel:GetChildren()) do
							if barricade:IsA("MeshPart") and barricade.Name == "Barricade" then
								if not barricade:GetAttribute("OriginalProperties") then
									barricade:SetAttribute("OriginalProperties", HttpService:JSONEncode({
										CanCollide = barricade.CanCollide,
										CanTouch = barricade.CanTouch,
										CanQuery = barricade.CanQuery
									}))
								end
								barricade.CanCollide = false
								barricade.CanTouch = false
								barricade.CanQuery = false
							end
						end
					else
						for _, barricade in ipairs(barricadesModel:GetChildren()) do
							if barricade:IsA("MeshPart") and barricade.Name == "Barricade" then
								local originalProps = barricade:GetAttribute("OriginalProperties")
								if originalProps then
									local props = HttpService:JSONDecode(originalProps)
									barricade.CanCollide = true
									barricade.CanTouch = true
									barricade.CanQuery = true
								end
							end
						end
					end
				end)

				if not success then
					warn("Barricades Bypass error:", error)
					return false
				end
				return true
			end

			applyBarricadesBypass()

			if Value then
				if not _G.BarricadesChildWatcher and workspace:FindFirstChild("Barricades") and workspace.Barricades:FindFirstChild("Model") then
					_G.BarricadesChildWatcher = workspace.Barricades.Model.ChildAdded:Connect(function(child)
						if child:IsA("MeshPart") and child.Name == "Barricade" then
							task.wait(0.1)
							if _G.BarricadesBypassEnabled then
								child.CanCollide = false
								child.CanTouch = false
								child.CanQuery = false
							end
						end
					end)
				end
			else
				if _G.BarricadesChildWatcher then
					_G.BarricadesChildWatcher:Disconnect()
					_G.BarricadesChildWatcher = nil
				end
			end
		end,
	}),
}

local Section = MiscTab:CreateSection("Buttons")

local Buttons = {
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
