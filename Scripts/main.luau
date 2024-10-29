local HttpService = game:GetService("HttpService")

local url = {
    AnimateReplacer = "https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/AnimateReplacer/AnimateReplacer.luau",
    InfiniteYield = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/source",
    UniversalSynSaveInstance = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/refs/heads/main/saveinstance.luau",
    DexExplorer = "https://github.com/Hosvile/DEX-Explorer/releases/latest/download/main.lua",
}
local constants = {
    AnimateReplacer = {
        version = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/AnimateReplacer/version")).Version,
    },
    InfiniteYield = {
        version = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/version")).Version,
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

local AnimateReplacerButton = ScriptsTab:CreateButton({
	Name = "Animation Replacer v" .. constants.AnimateReplacer.version,
	Callback = function()
		pcall(function()
			loadstring(game:HttpGet(url.AnimateReplacer))()
		end)
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

local UniversalSynSaveInstanceButton = ScriptsTab:CreateButton({
	Name = "UniversalSynSaveInstance",
	Callback = function()
		pcall(function()
			local synsaveinstance = loadstring(game:HttpGet(url.UniversalSynSaveInstance, true), "saveinstance")()
            local options = { SaveBytecode = true, NilInstances = true, RemovePlayerCharacters = false, IsolatePlayers = true, IsolateLocalPlayerCharacter = true, IsolateStarterPlayer = true, IsolateLocalPlayer = true }
            synsaveinstance(options)
		end)
	end,
})

local DexExplorerButton = ScriptsTab:CreateButton({
	Name = "Dex Explorer",
	Callback = function()
		pcall(function()
			local __function = loadstring(game:HttpGet(url.DexExplorer, true))

            		__function(__function)
		end)
	end,
})
