-- Author: @hinorium
-- Game: Our Execution

function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)

local COREGUI = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local HttpService = cloneref(game:GetService("HttpService"))
local MarketplaceService = cloneref(game:GetService("MarketplaceService"))
local RunService = cloneref(game:GetService("RunService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local GuiService = cloneref(game:GetService("GuiService"))
local Lighting = cloneref(game:GetService("Lighting"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local GroupService = cloneref(game:GetService("GroupService"))
local PathService = cloneref(game:GetService("PathfindingService"))
local SoundService = cloneref(game:GetService("SoundService"))
local Teams = cloneref(game:GetService("Teams"))
local StarterPlayer = cloneref(game:GetService("StarterPlayer"))
local InsertService = cloneref(game:GetService("InsertService"))
local ChatService = cloneref(game:GetService("Chat"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))
local ContentProvider = cloneref(game:GetService("ContentProvider"))
local StatsService = cloneref(game:GetService("Stats"))
local MaterialService = cloneref(game:GetService("MaterialService"))
local AvatarEditorService = cloneref(game:GetService("AvatarEditorService"))
local TextService = cloneref(game:GetService("TextService"))
local TextChatService = cloneref(game:GetService("TextChatService"))
local CaptureService = cloneref(game:GetService("CaptureService"))
local VoiceChatService = cloneref(game:GetService("VoiceChatService"))

local PlaceId, JobId = game.PlaceId, game.JobId
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())

local CurrentVersion = "1.0.9"

local LocalPlayer = Players.LocalPlayer
local PlayerGui = cloneref(LocalPlayer:FindFirstChildWhichIsA("PlayerGui"))

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "Our Execution",
	LoadingTitle = "OE - v" .. CurrentVersion,
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

function fire(object)
	if object:IsA("ProximityPrompt") then
		if not object.Enabled then object.Enabled = true end
		fireproximityprompt(object)
	elseif object:IsA("ClickDetector") then
		fireclickdetector(object)
	else
		local clickPrompt = object:FindFirstChildWhichIsA("ProximityPrompt") or object:FindFirstChildWhichIsA("ClickDetector")
		if not clickPrompt then return end
		if clickPrompt:IsA("ProximityPrompt") then
			if not clickPrompt.Enabled then clickPrompt.Enabled = true end
			fireproximityprompt(clickPrompt)
		elseif clickPrompt:IsA("ClickDetector") then
			fireclickdetector(clickPrompt)
		end
	end
end

get_tool = function()
	local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
	if not tool then return end
	if tool:FindFirstChild("Swing") then
		return tool, "melee"
	elseif tool:FindFirstChild("Firing") then
		return tool, "weapon"
	end
	return nil
end

re_fire_server = function(re, args)
	if not re then return end
	if re:IsA("RemoteEvent") then
		re:FireServer(unpack(args))
	end
end

function get_toggle_state(toggle: boolean)
	if toggle then
		return "ON"
	else
		return "OFF"
	end
end

_G.main = {
	kill_aura = {
		toggle = false;
	};
	melee = {
		hitbox = {
			name = "none";
			object = nil;
		};
	};
};

_G.visuals = {
	esp = {
		zombies = {
			toggle = false;
		};
	};
};

_G.connections = {
	kill_aura = nil;
	auto_fire = nil;
	melee_hitbox_expander = nil;
}

local MainTab = Window:CreateTab("Main", "code-xml")

local MainButtonsSection = MainTab:CreateSection("Buttons")
local MainButtons = {
	kill_aura = MainTab:CreateToggle({
		Name = "[Melee] - Kill Aura",
		CurrentValue = false,
		Flag = "MAIN-KILL-AURA",
		Callback = function(Value)
			if Value then
				if _G.connections.kill_aura ~= nil then
					_G.connections.kill_aura:Disconnect()
					_G.connections.kill_aura = nil
				end
				_G.connections.kill_aura = RunService.Heartbeat:Connect(function(dt)
					local tool, tool_type = get_tool()
					if tool and tool_type == "melee" then
						local swing_event = tool:FindFirstChild("Swing")
						local swing_num = 1
						if swing_event then
							re_fire_server(swing_event, {
								swing_num
							})
							swing_num = swing_num + 1
							if swing_num > 2 then
								swing_num = 1
							end
						end
					end
				end)
				notify("[DEBUG]", "Kill Aura - Enabled")
			else
				if _G.connections.kill_aura then
					_G.connections.kill_aura:Disconnect()
					_G.connections.kill_aura = nil
				end
				notify("[DEBUG]", "Kill Aura - Disabled")
			end
		end,
	}),
	melee_hitbox_expander = MainTab:CreateToggle({
		Name = "[Melee] - Hitbox Expander",
		CurrentValue = false,
		Flag = "MAIN-HITBOX-EXPANDER",
		Callback = function(Value)
			if Value then
				if _G.connections.melee_hitbox_expander ~= nil then
					_G.connections.melee_hitbox_expander:Disconnect()
					_G.connections.melee_hitbox_expander = nil
				end
				_G.connections.melee_hitbox_expander = LocalPlayer.Character.ChildAdded:Connect(function(child)
					if child:IsA("Tool") then
						local tool, tool_type = get_tool()
						if tool and tool_type == "melee" then
							local hitbox = tool:FindFirstChild("Hitbox")
							if not hitbox then return end
							if _G.main.melee.hitbox.name == "none" then
								_G.main.melee.hitbox.name = "original_size"
							end
							if not hitbox:GetAttribute(_G.main.melee.hitbox.name) then 
								hitbox:SetAttribute(_G.main.melee.hitbox.name, hitbox.Size)
							end
							_G.main.melee.hitbox.object = hitbox
							hitbox.Size = hitbox.Size + Vector3.new(20, 20, 20)
							task.wait()
							hitbox.Size = hitbox.Size = hitbox.Size + Vector3.new(20, 20, 20)
						end
					end
				end)

				for _, child in LocalPlayer.Character:GetChildren() do
					if child:IsA("Tool") then
						local tool, tool_type = get_tool()
						if tool and tool_type == "melee" then
							local hitbox = tool:FindFirstChild("Hitbox")
							if not hitbox then return end
							if _G.main.melee.hitbox.name == "none" then
								_G.main.melee.hitbox.name = "original_size"
							end
							if not hitbox:GetAttribute(_G.main.melee.hitbox.name) then 
								hitbox:SetAttribute(_G.main.melee.hitbox.name, hitbox.Size)
							end
							_G.main.melee.hitbox.object = hitbox
							hitbox.Size = hitbox.Size + Vector3.new(20, 20, 20)
							task.wait()
							hitbox.Size = hitbox.Size = hitbox.Size + Vector3.new(20, 20, 20)
						end
					end
				end
				notify("[DEBUG]", "Melee Hitbox Expander - Enabled")
			else
				if _G.connections.melee_hitbox_expander then
					_G.connections.melee_hitbox_expander:Disconnect()
					_G.connections.melee_hitbox_expander = nil
					
					if _G.main.melee.hitbox.object then
						local originalSize = _G.main.melee.hitbox.object:GetAttribute(_G.main.melee.hitbox.name)
						_G.main.melee.hitbox.object.Size = originalSize or _G.main.melee.hitbox.object.Size - Vector3.new(20, 20, 20)
					end
					
					for _, child in LocalPlayer.Character:GetChildren() do
						if child:IsA("Tool") then
							local tool, tool_type = get_tool()
							if tool and tool_type == "melee" then
								local hitbox = tool:FindFirstChild("Hitbox")
								if not hitbox then return end
								local originalSize = hitbox:GetAttribute(_G.main.melee.hitbox.name)
								hitbox.Size = originalSize or hitbox.Size - Vector3.new(20, 20, 20)
							end
						end
					end
				end
				notify("[DEBUG]", "Melee Hitbox Expander - Disabled")
			end
		end,
	}),
	auto_fire = MainTab:CreateToggle({
		Name = "[Weapon] - Auto Fire",
		CurrentValue = false,
		Flag = "MAIN-AUTO-FIRE",
		Callback = function(Value)
			if Value then
				if _G.connections.auto_fire ~= nil then
					_G.connections.auto_fire:Disconnect()
					_G.connections.auto_fire = nil
				end
				_G.connections.auto_fire = RunService.Heartbeat:Connect(function(dt)
					local tool, tool_type = get_tool()
					if tool and tool_type == "weapon" then
						local firing_event = tool:FindFirstChild("Firing")
						local head = LocalPlayer.Character and LocalPlayer.Chararacter:FindFirstChild("Head")
						if firing_event then
							re_fire_server(firing_event, {
								"real", head.CFrame.LookVector
							})
						end
					end
				end)
				notify("[DEBUG]", "Auto Fire - Enabled")
			else
				if _G.connections.auto_fire then
					_G.connections.auto_fire:Disconnect()
					_G.connections.auto_fire = nil
				end
				notify("[DEBUG]", "Auto Fire - Disabled")
			end
		end,
	}),
}

local VisualsTab = Window:CreateTab("Visuals", "user-round-search")

local VisualsButtonsSection = VisualsTab:CreateSection("Buttons")
local VisualsButtons = {
	monsters_esp = VisualsTab:CreateToggle({
		Name = "[ON/OFF] - Toggle Zombies ESP",
		CurrentValue = false,
		Flag = "VISUALS-ZOMBIES-ESP",
		Callback = function(Value)
			_G.visuals.esp.zombies.toggle = Value
			if Value then
				workspace.AliveZombies.ChildAdded:Connect(function(child)
					if not child:FindFirstChildWhichIsA("Highlight") and child.Name == "zombie_esp" then
						local chams = Instance.new("Highlight")
						chams.Name = "zombie_esp"
						chams.Parent = child
					end
				end)

				for _, child in workspace.AliveZombies:GetChildren() do
					if not child:FindFirstChildWhichIsA("Highlight") and child.Name == "zombie_esp" then
						local chams = Instance.new("Highlight")
						chams.Name = "zombie_esp"
						chams.Parent = child
					end
				end
				notify("[DEBUG]", "Zombies ESP - Enabled")
			else
				for _, child in workspace.AliveZombies:GetChildren() do
					if child:FindFirstChildWhichIsA("Highlight") and child.Name == "zombie_esp" then
						child:Destroy()
					end
				end
				notify("[DEBUG]", "Zombies ESP - Disabled")
			end
		end,
	}),
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
