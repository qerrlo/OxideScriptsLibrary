-- Author: @hinorium

-- Game: Zombie Survival Garry's Mod [Old]
-- Version: 1.05b

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

local PlaceId, JobId = game.PlaceId, game.JobId
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

local CurrentVersion = "1.0.5b"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Zombie Survival Garry's Mod [Old]",
	Icon = "github",
	LoadingTitle = "ZSGM [Old] - v" .. CurrentVersion,
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

function fire_remote(remoteName: string, args: {any})
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

local MainTab = Window:CreateTab("Main", "code-xml")

local MainTogglesSection = MainTab:CreateSection("Toggles")

local MainToggles = {
	ESP = MainTab:CreateToggle({
		Name = "ESP",
		CurrentValue = false,
		Flag = "__Toggle_ESP",
		Callback = function(Value)
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local LocalPlayer = Players.LocalPlayer

			local connections = {}
			local espObjects = {}

			local function cleanupESP()
				for _, connection in pairs(connections) do
					if connection then connection:Disconnect() end
				end
				connections = {}

				for _, objects in pairs(espObjects) do
					for _, object in pairs(objects) do
						if object then object:Destroy() end
					end
				end
				espObjects = {}
			end

			local function createESP(character)
				if not character then return end
				local humanoid = character:WaitForChild("Humanoid")
				local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
				if not humanoid or not humanoidRootPart then return end

				local player = Players:GetPlayerFromCharacter(character)
				if not player then return end

				espObjects[player.UserId] = espObjects[player.UserId] or {}
				local playerObjects = espObjects[player.UserId]

				local highlight = Instance.new("Highlight")
				highlight.FillTransparency = 0.5
				highlight.OutlineTransparency = 0
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.Adornee = character
				highlight.Parent = character
				playerObjects.highlight = highlight

				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Size = UDim2.new(0, 100, 0, 40)
				billboardGui.StudsOffset = Vector3.new(0, 3, 0)
				billboardGui.AlwaysOnTop = true
				billboardGui.Parent = humanoidRootPart
				playerObjects.billboardGui = billboardGui

				local healthFrame = Instance.new("Frame")
				healthFrame.Size = UDim2.new(1, 0, 0.3, 0)
				healthFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				healthFrame.BorderSizePixel = 0
				healthFrame.Parent = billboardGui
				playerObjects.healthFrame = healthFrame

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(1, 0, 0.7, 0)
				nameLabel.Position = UDim2.new(0, 0, 0.3, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				nameLabel.TextScaled = true
				nameLabel.Parent = billboardGui
				playerObjects.nameLabel = nameLabel

				local updateConnection = RunService.RenderStepped:Connect(function()
					if not character:IsDescendantOf(workspace) or not humanoid.Parent then
						if playerObjects.updateConnection then
							playerObjects.updateConnection:Disconnect()
						end
						return
					end

					if player.Team == Teams.Zombies then
						highlight.FillColor = Color3.fromRGB(0, 255, 0)
					else
						highlight.FillColor = Color3.fromRGB(255, 0, 0)
					end

					healthFrame.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 0.3, 0)
					nameLabel.Text = player.Name .. "\n" .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth

					local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and 
						(LocalPlayer.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude or 0
					local transparency = math.clamp(distance / 100, 0, 0.8)
					highlight.FillTransparency = transparency
					highlight.OutlineTransparency = transparency
					billboardGui.Enabled = distance < 100
				end)
				playerObjects.updateConnection = updateConnection
				table.insert(connections, updateConnection)

				local deathConnection = humanoid.Died:Connect(function()
					if playerObjects.updateConnection then
						playerObjects.updateConnection:Disconnect()
					end
					for _, object in pairs(playerObjects) do
						if typeof(object) == "Instance" then
							object:Destroy()
						end
					end
					espObjects[player.UserId] = nil
				end)
				table.insert(connections, deathConnection)
			end

			if Value then
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer then
						if player.Character then
							createESP(player.Character)
						end
						local connection = player.CharacterAdded:Connect(createESP)
						table.insert(connections, connection)
					end
				end

				local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
					if player ~= LocalPlayer then
						local connection = player.CharacterAdded:Connect(createESP)
						table.insert(connections, connection)
					end
				end)
				table.insert(connections, playerAddedConnection)
			else
				cleanupESP()
			end
		end,
	})
}

local MaubButtonsSection = MainTab:CreateSection("Buttons")

local MainButtons = {
	DestroySigils = MainTab:CreateButton({
		Name = "Destroy All Sigil's [Only Zombie]",
		Callback = function()
			local function getZombieCharacter()
				local character = Players.LocalPlayer.Character
				if not character then return nil end

				for _, zombieType in ipairs({"Zombie", "Nightmare", "Crow"}) do
					if character:FindFirstChild(zombieType) then
						return character[zombieType]
					end
				end
				return nil
			end
			
			local function destroySigil(sigil)
				local maxHP = sigil:GetAttribute("MaxHP") or 1000
				local currentHP = sigil:GetAttribute("HP") or 1000
				local damagePerHit = 55
				local hitsNeeded = math.ceil(currentHP / damagePerHit)
				
				local zombieChar = getZombieCharacter()
				if not zombieChar then
					notify('Error', 'You must be a zombie!')
					return
				end
				
				for i = 1, hitsNeeded do
					local args = {
						zombieChar,
						sigil,
						sigil.CFrame,
						55
					}

					fire_remote("MeleeKnockback", args)
					task.wait(0.1)

					local newHP = sigil:GetAttribute("HP")
					if newHP and newHP <= 0 then
						break
					end
				end
			end

			local sigils = workspace:FindFirstChild("Sigils")
			if not sigils then return end

			for _, sigil in ipairs(sigils:GetChildren()) do
				if sigil.Name == "Sigil" then
					task.spawn(function()
						destroySigil(sigil)
						task.wait(0.2)
					end)
				end
			end

			notify('Info', 'All sigils destroyed!')
		end,
	}),
	DestroyBarricades = MainTab:CreateButton({
		Name = "Destroy All Barricades [Only Zombie]",
		Callback = function()
			local function getZombieCharacter()
				local character = Players.LocalPlayer.Character
				if not character then return nil end

				for _, zombieType in ipairs({"Zombie", "Nightmare", "Crow"}) do
					if character:FindFirstChild(zombieType) then
						return character[zombieType]
					end
				end
				return nil
			end

			local function damageBarricade(barricade)
				local zombieChar = getZombieCharacter()
				if not zombieChar then
					notify('Error', 'You must be a zombie!')
					return
				end

				local args = {
					zombieChar,
					barricade,
					barricade.CFrame,
					55,
					0.1
				}
				fire_remote("DamagedBarricade", args)
			end

			local barricadesModel = workspace:FindFirstChild("Barricades") 
				and workspace.Barricades:FindFirstChild("Model")

			if not barricadesModel then return end

			local barricades = {}
			for _, barricade in ipairs(barricadesModel:GetChildren()) do
				if barricade:IsA("MeshPart") and barricade.Name == "Barricade" then
					table.insert(barricades, barricade)
				end
			end

			local attackCount = 0
			local maxAttacks = 30

			for i = 1, #barricadesModel:GetChildren() + #barricades do
				task.spawn(function()
					while attackCount < maxAttacks do
						for _, barricade in ipairs(barricades) do
							if barricade.Parent and barricade:GetAttribute("BarricadeHP") and barricade:GetAttribute("BarricadeHP") > 0 then
								task.spawn(function()
									damageBarricade(barricade)
								end)
							end
						end

						attackCount = attackCount + 1
						task.wait(0.05)
					end
				end)
				task.wait(0.03)
			end

			notify('Info', 'All barricades destroyed!')
		end,
	}),
}

local MiscTab = Window:CreateTab("Misc", "folder-cog")

local MiscTogglesSection = MiscTab:CreateSection("Toggles")

local MiscToggles = {
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
	Bypass_Noclip = MiscTab:CreateToggle({
		Name = "[AC] - Noclip Exploiting - Bypass (Testing)",
		CurrentValue = false,
		Flag = "__BYPASS_Noclip",
		Callback = function(Value)
			_G.NoclipBypassEnabled = Value
			
			local LocalPlayer = Players.LocalPlayer
			local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

			local function isZombie()
				return LocalPlayer and LocalPlayer.Team.Name == "Zombies" or LocalPlayer.TeamColor == BrickColor.new("Lime green")
			end

			local function isAlive()
				return Character and Character.Parent and Character:FindFirstChild("HumanoidRootPart") 
					and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0
			end

			local lastPosition = nil
			local failedAttempts = 0
			local lastCheckTime = tick()

			local function setupBypass()
				if not isAlive() then return end

				local humanoidRootPart = Character.HumanoidRootPart
				local humanoid = Character.Humanoid

				if _G.NoclipBypassEnabled then
					if not _G.NoclipConnection then
						_G.NoclipConnection = RunService.Heartbeat:Connect(function()
							if not isAlive() or not _G.NoclipBypassEnabled then
								if _G.NoclipConnection then
									_G.NoclipConnection:Disconnect()
									_G.NoclipConnection = nil
								end
								return
							end

							local currentTime = tick()
							if currentTime - lastCheckTime > 0.1 then
								local barricadesModel = workspace:FindFirstChild("Barricades") and workspace.Barricades:FindFirstChild("Model")
								local nearBarricade = false

								if barricadesModel then
									for _, barricade in ipairs(barricadesModel:GetChildren()) do
										if barricade:IsA("MeshPart") and barricade.Name == "Barricade" then
											local distance = (humanoidRootPart.Position - barricade.Position).Magnitude
											if distance < 4 then
												nearBarricade = true
												break
											end
										end
									end
								end

								if not nearBarricade then
									lastPosition = humanoidRootPart.CFrame
									failedAttempts = 0
								end
								lastCheckTime = currentTime
							end

							if isZombie() then
								local barricadesModel = workspace:FindFirstChild("Barricades") and workspace.Barricades:FindFirstChild("Model")
								if barricadesModel then
									for _, barricade in ipairs(barricadesModel:GetChildren()) do
										if barricade:IsA("MeshPart") and barricade.Name == "Barricade" then
											local distance = (humanoidRootPart.Position - barricade.Position).Magnitude
											if distance < 2.5 then
												failedAttempts = failedAttempts + 1

												if failedAttempts >= 2 then
													if lastPosition then
														humanoidRootPart.CFrame = lastPosition
														failedAttempts = 0
														task.wait(0.1)
													end
												end

												humanoidRootPart.Velocity = humanoidRootPart.Velocity * 0.7
												humanoidRootPart.AssemblyLinearVelocity = Vector3.new(
													math.clamp(humanoidRootPart.AssemblyLinearVelocity.X, -10, 10),
													math.clamp(humanoidRootPart.AssemblyLinearVelocity.Y, -10, 10),
													math.clamp(humanoidRootPart.AssemblyLinearVelocity.Z, -10, 10)
												)
											end
										end
									end
								end
							end
						end)
					end
				else
					if _G.NoclipConnection then
						_G.NoclipConnection:Disconnect()
						_G.NoclipConnection = nil
					end
					lastPosition = nil
					failedAttempts = 0
				end
			end

			setupBypass()

			if _G.NoclipBypassEnabled and not _G.CharacterAddedConnection then
				_G.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(newCharacter)
					Character = newCharacter
					task.wait(0.5)
					lastPosition = nil
					failedAttempts = 0
					setupBypass()
				end)
			elseif not _G.NoclipBypassEnabled and _G.CharacterAddedConnection then
				_G.CharacterAddedConnection:Disconnect()
				_G.CharacterAddedConnection = nil
			end
		end,
	}),
}

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
