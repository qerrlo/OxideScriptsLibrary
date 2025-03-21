-- Версия и конфигурация
local VERSION = "1.13"
local DEFAULT_CONFIG = {
    animationPack = "Levitation",
    includeToStarterAnimate = false,
    autoRestore = true,
    notifyOnChange = true,
    showUI = false
}

-- Сервисы
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")

-- Локальные переменные
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animate = Character:WaitForChild("Animate")

-- Расширенный список анимаций
local AnimationPacks = {
    ["Levitation"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=10921132092" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=10921136539" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=10921132962",
            Animation2 = "http://www.roblox.com/asset/?id=10921133721"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=10921137402" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=10921135644" },
        swim = { Swim = "http://www.roblox.com/asset/?id=10921138209" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=10921139478" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=10921140719" }
    },
    ["Confident"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=1069946257" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=1069973677" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=1069977950",
            Animation2 = "http://www.roblox.com/asset/?id=1069987858"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=1069984524" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=1070001516" },
        swim = { Swim = "http://www.roblox.com/asset/?id=1070009914" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=1070012133" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=1070017263" }
    },
    ["Popstar"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=1213044953" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=1212900995" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=1212900985",
            Animation2 = "http://www.roblox.com/asset/?id=1212954651"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=1212954642" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=1212980348" },
        swim = { Swim = "http://www.roblox.com/asset/?id=1212852603" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=1212998578" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=1212980338" }
    },
    ["Patrol"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=1148811837" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=1148863382" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=1149612882",
            Animation2 = "http://www.roblox.com/asset/?id=1150842221"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=1150944216" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=1150967949" },
        swim = { Swim = "http://www.roblox.com/asset/?id=1151204998" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=1151221899" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=1151231493" }
    },
    ["Sneaky"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=1132461372" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=1132469004" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=1132473842",
            Animation2 = "http://www.roblox.com/asset/?id=1132477671"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=1132489853" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=1132494274" },
        swim = { Swim = "http://www.roblox.com/asset/?id=1132500520" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=1132506407" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=1132510133" }
    },
    ["Princess"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=940996062" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=941000007" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=941003647",
            Animation2 = "http://www.roblox.com/asset/?id=941013098"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=941008832" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=941015281" },
        swim = { Swim = "http://www.roblox.com/asset/?id=941018893" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=941025398" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=941028902" }
    },
    ["Cowboy"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=1014380606" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=1014384571" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=1014390418",
            Animation2 = "http://www.roblox.com/asset/?id=1014398616"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=1014394726" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=1014401683" },
        swim = { Swim = "http://www.roblox.com/asset/?id=1014406523" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=1014411816" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=1014421541" }
    },
    ["Stylized Female"] = {
        climb = { ClimbAnim = "http://www.roblox.com/asset/?id=4708184253" },
        fall = { FallAnim = "http://www.roblox.com/asset/?id=4708186162" },
        idle = {
            Animation1 = "http://www.roblox.com/asset/?id=4708191566",
            Animation2 = "http://www.roblox.com/asset/?id=4708192150"
        },
        jump = { JumpAnim = "http://www.roblox.com/asset/?id=4708188025" },
        run = { RunAnim = "http://www.roblox.com/asset/?id=4708192705" },
        swim = { Swim = "http://www.roblox.com/asset/?id=4708189360" },
        swimidle = { SwimIdle = "http://www.roblox.com/asset/?id=4708190607" },
        walk = { WalkAnim = "http://www.roblox.com/asset/?id=4708193840" }
    }
}

-- Утилиты
local Utility = {}

function Utility.IsR15(character)
    local humanoid = character:FindFirstChildOfClass('Humanoid')
    return humanoid and humanoid.RigType == Enum.HumanoidRigType.R15
end

function Utility.Notify(title, message, duration)
    if DEFAULT_CONFIG.notifyOnChange then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3
        })
    end
end

-- Основной класс AnimationReplacer
local AnimationReplacer = {}
AnimationReplacer.__index = AnimationReplacer

function AnimationReplacer.new(config)
    local self = setmetatable({}, AnimationReplacer)
    self.config = config or DEFAULT_CONFIG
    self.originalAnimations = {}
    self.currentPack = nil
    return self
end

function AnimationReplacer:SaveOriginalAnimations()
    if not Animate then return end
    
    local function saveAnimations(animate)
        local original = {}
        for _, category in pairs(animate:GetChildren()) do
            if category:IsA("Folder") then
                original[category.Name] = {}
                for _, anim in pairs(category:GetChildren()) do
                    if anim:IsA("Animation") then
                        original[category.Name][anim.Name] = anim.AnimationId
                    end
                end
            end
        end
        return original
    end
    
    self.originalAnimations = saveAnimations(Animate)
end

function AnimationReplacer:RestoreOriginalAnimations()
    if not Animate or not self.originalAnimations then return end
    
    for category, animations in pairs(self.originalAnimations) do
        local folder = Animate:FindFirstChild(category)
        if folder then
            for animName, animId in pairs(animations) do
                local anim = folder:FindFirstChild(animName)
                if anim and anim:IsA("Animation") then
                    anim.AnimationId = animId
                end
            end
        end
    end
    
    Utility.Notify("Animations Restored", "Original animations have been restored", 3)
end

function AnimationReplacer:ReplaceAnimations(packName)
    if not AnimationPacks[packName] then
        Utility.Notify("Error", "Animation pack not found: " .. packName, 3)
        return false
    end
    
    local success, error = pcall(function()
        local pack = AnimationPacks[packName]
        Animate.Disabled = true
        
        -- Замена анимаций
        for category, animations in pairs(pack) do
            local folder = Animate:FindFirstChild(category)
            if folder then
                for animName, animId in pairs(animations) do
                    local anim = folder:FindFirstChild(animName)
                    if anim and anim:IsA("Animation") then
                        anim.AnimationId = animId
                    end
                end
            end
        end
        
        -- Обработка StarterAnimate если включено
        if self.config.includeToStarterAnimate then
            local starterAnimate = StarterPlayer.StarterCharacterScripts:FindFirstChild("Animate")
            if starterAnimate then
                for category, animations in pairs(pack) do
                    local folder = starterAnimate:FindFirstChild(category)
                    if folder then
                        for animName, animId in pairs(animations) do
                            local anim = folder:FindFirstChild(animName)
                            if anim and anim:IsA("Animation") then
                                anim.AnimationId = animId
                            end
                        end
                    end
                end
            end
        end
        
        Animate.Disabled = false
        self.currentPack = packName
    end)
    
    if success then
        Utility.Notify("Success", "Animations replaced with " .. packName, 3)
        return true
    else
        Utility.Notify("Error", "Failed to replace animations: " .. error, 3)
        return false
    end
end

-- Инициализация и обработка событий
local function Initialize()
    local animator = AnimationReplacer.new(DEFAULT_CONFIG)
    animator:SaveOriginalAnimations()
    
    -- Обработка смены персонажа
    Player.CharacterAdded:Connect(function(newCharacter)
        Character = newCharacter
        Animate = Character:WaitForChild("Animate")
        
        if animator.currentPack then
            animator:ReplaceAnimations(animator.currentPack)
        end
    end)
    
    -- Применение начального набора анимаций
    animator:ReplaceAnimations(DEFAULT_CONFIG.animationPack)
    
    return animator
end

-- Создание UI для управления анимациями (опционально)
local function CreateAnimationUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local UICorner = Instance.new("UICorner")
    local UIPadding = Instance.new("UIPadding")

    -- Main Frame Setup
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    MainFrame.Name = "AnimationsMenu"
    MainFrame.Size = UDim2.new(0, 220, 0, 320)
    MainFrame.Position = UDim2.new(0.85, 0, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Title Setup
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Text = "Animation Packs"
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainFrame

    -- Scrolling Frame Setup
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -50)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 45)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.Parent = MainFrame

    -- UI Layout Setup
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.SortOrder = Enum.SortOrder.Name

    -- Add Corners
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    local TitleCorner = UICorner:Clone()
    TitleCorner.Parent = Title

    -- Add Padding
    UIPadding.Parent = ScrollingFrame
    UIPadding.PaddingTop = UDim.new(0, 5)

    -- Create Buttons
    for packName, _ in pairs(AnimationPacks) do
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = ScrollingFrame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = packName
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.Parent = ButtonFrame

        local ButtonCorner = UICorner:Clone()
        ButtonCorner.Parent = ButtonFrame

        -- Hover Effect
        Button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}
            ):Play()
        end)

        Button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(ButtonFrame, 
                TweenInfo.new(0.2), 
                {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}
            ):Play()
        end)

        -- Click Effect
        Button.MouseButton1Down:Connect(function()
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
        end)

        Button.MouseButton1Up:Connect(function()
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            animator:ReplaceAnimations(packName)
        end)
    end

    -- Update ScrollingFrame Canvas Size
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Make Frame Draggable
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Запуск
local animator = Initialize()
if DEFAULT_CONFIG.showUI then
    CreateAnimationUI()
end

return animator
