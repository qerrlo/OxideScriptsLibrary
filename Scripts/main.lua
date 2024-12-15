local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- URLs и константы
local url = {
    AnimateReplacer = "https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/AnimateReplacer/AnimateReplacer.luau",
    InfiniteYield = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/source",
    UniversalSynSaveInstance = "https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/UniversalSynSaveInstance/saveinstance.luau",
    DexExplorer = "https://github.com/Hosvile/DEX-Explorer/releases/latest/download/main.lua",
    RemoteSpy = "https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua",
    DarkDex = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"
}

-- Получение версий скриптов
local function getVersions()
    local versions = {}
    local success, result = pcall(function()
        versions.AnimateReplacer = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/qerrlo/OxideScriptsLibrary/refs/heads/main/Scripts/AnimateReplacer/version")).Version
        versions.InfiniteYield = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/refs/heads/master/version")).Version
    end)
    return versions
end

local constants = getVersions()

-- Настройки UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Тема UI
local CustomTheme = {
    Main = Color3.fromRGB(25, 25, 25),
    Second = Color3.fromRGB(32, 32, 32),
    Stroke = Color3.fromRGB(60, 60, 60),
    Divider = Color3.fromRGB(60, 60, 60),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150)
}

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "Oxide Hub Premium",
    Icon = "candy-cane",
    LoadingTitle = "Oxide Hub Loading...",
    LoadingSubtitle = "by qerrlo",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OxideHubConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = true,
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

-- Создание вкладок
local ScriptsTab = Window:CreateTab("Scripts", "file-code-2")
local UtilityTab = Window:CreateTab("Utility", "wrench")

-- Основная секция скриптов
local MainSection = ScriptsTab:CreateSection("Main Scripts")

-- Функция для безопасного выполнения скриптов
local function safeLoadstring(url, name)
    return function()
        local success, result = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Success",
                Content = name .. " loaded successfully",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to load " .. name,
                Duration = 2
            })
        end
    end
end

local function safeSaveInstance()
    return function()
        local success, result = pcall(function()
            local synsaveinstance = loadstring(game:HttpGet(url.UniversalSynSaveInstance, true), "saveinstance")()
            local options = {
                SaveBytecode = true,
                NilInstances = true,
                RemovePlayerCharacters = false,
                IsolatePlayers = true,
                IsolateLocalPlayerCharacter = true,
                IsolateStarterPlayer = true,
                IsolateLocalPlayer = true
            }
            synsaveinstance(options)
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Success",
                Content = "Game instance saved successfully",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to save game instance",
                Duration = 2
            })
        end
    end
end

-- Кнопки скриптов
ScriptsTab:CreateButton({
    Name = "UniversalSynSaveInstance v" .. (constants.UniversalSynSaveInstance or "Latest"),
    Info = "Replace your character animations",
    Callback = safeLoadstring(url.UniversalSynSaveInstance, "UniversalSynSaveInstance")
})

ScriptsTab:CreateButton({
    Name = "Animation Replacer v" .. (constants.AnimateReplacer or "Latest"),
    Info = "Replace your character animations",
    Callback = safeLoadstring(url.AnimateReplacer, "Animation Replacer")
})

ScriptsTab:CreateButton({
    Name = "Infinite Yield v" .. (constants.InfiniteYield or "Latest"),
    Info = "Admin Commands",
    Callback = safeLoadstring(url.InfiniteYield, "Infinite Yield")
})

-- Секция утилит
local UtilitySection = UtilityTab:CreateSection("Developer Tools")

UtilityTab:CreateButton({
    Name = "Dex Explorer",
    Info = "Game Explorer",
    Callback = safeLoadstring(url.DexExplorer, "Dex Explorer")
})

UtilityTab:CreateButton({
    Name = "Remote Spy",
    Info = "Monitor Remote Events",
    Callback = safeLoadstring(url.RemoteSpy, "Remote Spy")
})

-- Анти-чит обход
local function setupAnticheatBypass()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and args[1].Name:match("AntiCheat") then
            return
        end
        return old(...)
    end)
    setreadonly(mt, true)
end

-- Инициализация
setupAnticheatBypass()
