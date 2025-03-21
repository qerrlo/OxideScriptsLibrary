-- Загрузка Rayfield UI из внешнего источника
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerData = LocalPlayer.PlayerData
local Workspace = game:GetService("Workspace")

-- Настройки ключевой системы
local KeySystemConfig = {
    Enabled = false,
    Keys = {"OXIDE-FAZBLOX-2024", "TEST-KEY-12345"},  -- Ваши ключи
    LinkvertiseURL = "https://link-hub.net/000000/key" -- Ваша ссылка
}

-- Создание основного окна UI
local Window = Rayfield:CreateWindow({
    Name = "Freddy Fazbloxs Pizza Roleplay [Hub]",
    Icon = "sparkles", -- Используйте 0 для отсутствия иконки
    LoadingTitle = "Loading Interface Suite",
    LoadingSubtitle = "by oxide",
    Theme = {
        TextColor = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(25, 25, 25),
        Topbar = Color3.fromRGB(34, 34, 34),
        Shadow = Color3.fromRGB(60, 60, 60),
        NotificationBackground = Color3.fromRGB(20, 20, 20),
        NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
        TabBackground = Color3.fromRGB(80, 80, 80),
        TabStroke = Color3.fromRGB(85, 85, 85),
        TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
        TabTextColor = Color3.fromRGB(240, 240, 240),
        SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
        ElementBackground = Color3.fromRGB(35, 35, 35),
        ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
        SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
        ElementStroke = Color3.fromRGB(50, 50, 50),
        SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
        SliderBackground = Color3.fromRGB(50, 138, 220),
        SliderProgress = Color3.fromRGB(50, 138, 220),
        SliderStroke = Color3.fromRGB(58, 163, 255),
        ToggleBackground = Color3.fromRGB(30, 30, 30),
        ToggleEnabled = Color3.fromRGB(0, 146, 214),
        ToggleDisabled = Color3.fromRGB(100, 100, 100),
        ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
        ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
        ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
        ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),
        DropdownSelected = Color3.fromRGB(40, 40, 40),
        DropdownUnselected = Color3.fromRGB(30, 30, 30),
        InputBackground = Color3.fromRGB(30, 30, 30),
        InputStroke = Color3.fromRGB(65, 65, 65),
        PlaceholderColor = Color3.fromRGB(178, 178, 178),
    },
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true, -- Отключение предупреждений о несовпадении версии
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FazbloxConfig", -- Создание пользовательской папки для вашего хаба/игры
        FileName = "Settings"
    },
    Discord = {
        Enabled = false, -- Отключение приглашения в Discord
        Invite = "noinvitelink", -- Код приглашения в Discord
        RememberJoins = true -- Запоминание присоединений к серверу
    },
    KeySystem = KeySystemConfig.Enabled,
    KeySettings = {
        Title = "Key System - Freddy Fazbloxs Hub",
        Subtitle = "Enter Key",
        Note = "Get your key from https://link-hub.net/000000/key", 
        FileName = "FazbloxHubKey",
        SaveKey = true,
        GrabKeyFromSite = false, -- Включаем получение ключа с сайта
        Key = KeySystemConfig.Keys, -- Укажите ваш линк
        KeyFormat = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX", -- Формат ключа
        Notify = {
            Title = "Freddy Fazbloxs Hub",
            Description = "Successfully authenticated!",
            Duration = 3.5
        }
    }
})

if KeySystemConfig.Enabled then
    setclipboard("https://link-hub.net/000000/key")
end

-- Создание вкладок и секций
local Tab = Window:CreateTab("Changers", "layers")
local TogglesTab = Window:CreateTab("Toggles", "list-collapse")
local OtherTab = Window:CreateTab("Other", "plus")
local PlayerDataSection = Tab:CreateSection("Player Data")

-- Создание кнопок для изменения данных игрока
local InfSkins = Tab:CreateButton({
    Name = "Infinite Skins",
    Callback = function()
        PlayerData.Skin.Value = math.huge
        PlayerData.Skin:GetPropertyChangedSignal("Value"):Connect(function()
            PlayerData.Skin.Value = math.huge      
        end)
    end,
})

local InfTickets = Tab:CreateButton({
    Name = "Infinite Tickets",
    Callback = function()
        PlayerData.Tickets.Value = math.huge
        PlayerData.Tickets:GetPropertyChangedSignal("Value"):Connect(function()
            PlayerData.Tickets.Value = math.huge
        end)
    end,
})

local InfTokens = Tab:CreateButton({
    Name = "Infinite Tokens",
    Callback = function()
        PlayerData.Tokens.Value = math.huge
        PlayerData.Tokens:GetPropertyChangedSignal("Value"):Connect(function()
            PlayerData.Tokens.Value = math.huge
        end)
    end,
})

-- Секция переключателей
local TogglesSection = TogglesTab:CreateSection("Toggles")

-- Создание переключателей
local FFEventCompletedToggle = TogglesTab:CreateToggle({
    Name = "Toggle [FFEventCompleted]",
    CurrentValue = PlayerData.FFEventCompleted.Value,
    Flag = "FFEventCompletedToggle",
    Callback = function(Value)
        PlayerData.FFEventCompleted.Value = Value
    end,
})

local BonnieToggle = TogglesTab:CreateToggle({
    Name = "Get [Bonnie]",
    CurrentValue = PlayerData.BonniePurchased.Value,
    Flag = "BonnieToggle",
    Callback = function(Value)
        PlayerData.BonniePurchased.Value = Value
    end,
})

local ChicaToggle = TogglesTab:CreateToggle({
    Name = "Get [Chica]",
    CurrentValue = PlayerData.ChicaPurchased.Value,
    Flag = "ChicaToggle",
    Callback = function(Value)
        PlayerData.ChicaPurchased.Value = Value
    end,
})

local FoxyToggle = TogglesTab:CreateToggle({
    Name = "Get [Foxy]",
    CurrentValue = PlayerData.FoxyPurchased,
    Flag = "FoxyToggle",
    Callback = function(Value)
        PlayerData.FoxyPurchased.Value = Value
    end,
})

local FreddyToggle = TogglesTab:CreateToggle({
    Name = "Get [Freddy]",
    CurrentValue = PlayerData.FreddyPurchased,
    Flag = "FreddyToggle",
    Callback = function(Value)
        PlayerData.FreddyPurchased.Value = Value
    end,
})

local GFreddyToggle = TogglesTab:CreateToggle({
    Name = "Get [Golden Freddy]",
    CurrentValue = PlayerData.GFreddyPurchased,
    Flag = "GFreddyToggle",
    Callback = function(Value)
        PlayerData.GFreddyPurchased.Value = Value
    end,
})

-- Разделитель и переключатель всех скинов
local Divider = TogglesTab:CreateDivider()

local AllSkinsToggle = TogglesTab:CreateToggle({
    Name = "Get [All Skins]",
    CurrentValue = false,
    Flag = "AllSkinsToggle",
    Callback = function(Value)
        for _, v in pairs(PlayerData:GetDescendants()) do
            if v:IsA("BoolValue") and string.match(v.Name, "Skin") then
                v.Value = Value
            end
        end
    end,
})

local FakeDeveloperRoleButton = OtherTab:CreateButton({
   Name = "Fake Developer Role",
   Callback = function()
        local args = {
            [1] = "Developer",
            [2] = math.huge
        }

        workspace:WaitForChild("RoleEvent"):FireServer(unpack(args))
   end,
})

local CustomRoleInput = OtherTab:CreateInput({
   Name = "Custom Role",
   CurrentValue = "",
   PlaceholderText = `example: "Roblox"`,
   RemoveTextAfterFocusLost = false,
   Flag = "CustomRoleInput",
   Callback = function(Text)
        local args = {
            [1] = Text,
            [2] = math.huge
        }

        workspace:WaitForChild("RoleEvent"):FireServer(unpack(args))
   end,
})

local CustomNameInput = OtherTab:CreateInput({
   Name = "Custom Name [NameTag]",
   CurrentValue = "",
   PlaceholderText = `example: "Roblox"`,
   RemoveTextAfterFocusLost = false,
   Flag = "CustomNameInput",
   Callback = function(Text)
        local args = {
            [1] = Text,
            [2] = false
        }

        LocalPlayer.Character.NameEvent:FireServer(unpack(args))
   end,
})

local CustomDescriptionInput = OtherTab:CreateInput({
   Name = "Custom Description [NameTag]",
   CurrentValue = "",
   PlaceholderText = `example: "oxide"`,
   RemoveTextAfterFocusLost = false,
   Flag = "CustomDescriptionInput",
   Callback = function(Text)
        local args = {
            [1] = false,
            [2] = Text
        }

        LocalPlayer.Character.NameEvent:FireServer(unpack(args))
   end,
})
