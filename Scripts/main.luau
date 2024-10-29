local HttpService = game:GetService("HttpService")

local url = {
    AnimationReplacer = "https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/AnimateReplacer/AnimateReplacer.lua",
    InfiniteYield = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/source",
}
local constants = {
    InfiniteYield = {
        version = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/version")).Version
    },
}

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "🎃 Oxide Hub 🎃",
	LoadingTitle = "Loaded!",
	LoadingSubtitle = "by qerrlo",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "Oxide Hub"
	},
	Discord = {
		Enabled = false,
		Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})


local ScriptsTab = Window:CreateTab("📜 Scripts", nil) -- Title, Image
local Section = ScriptsTab:CreateSection("Main")

local AnimationReplacerButton = ScriptsTab:CreateButton({
	Name = "Animation Replacer v1.0",
	Callback = function()
		pcall(function()
			loadstring(game:HttpGet(url.AnimationReplacer))()
		end)
		Rayfield:Notify({
			Title = "Scripts | Notify",
			Content = "Your animate script replaced!",
			Duration = 6.5,
			-- Image = 4483362458,
			Actions = { -- Notification Buttons

				Ignore = { -- Duplicate this table (or remove it) to add and remove buttons to the notification.
					Name = "Continue!",
					-- Callback = function()
					-- 	print("The user tapped Okay!")
					-- end
				},

			},
		})
	end,
})

local InfiniteYieldButton = ScriptsTab:CreateButton({
	Name = "Infinite Yield v" .. constants.InfiniteYield.version,
	Callback = function()
		pcall(function()
			loadstring(game:HttpGet(url.InfiniteYield))()
		end)
	end,
})
