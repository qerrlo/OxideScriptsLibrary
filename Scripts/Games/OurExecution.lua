-- Author: @hinorium
-- Game: An Average Tycoon

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

local CurrentVersion = "1.0.1"

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
	if tool:FindFirstChild("Swing") then
		return tool, "melee"
	elseif tool:FindFirstChild("Firing") then
		return tool, "weapon"
	end
	return nil
end

re_fire_server = function(re, args)
	if not re then return end
	re:FireServer(unpack(args))
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
							re_fire_server(tool, swing_num)
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
