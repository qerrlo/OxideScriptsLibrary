-- Author: @hinorium
-- Game: The Ayuwoki Field
-- Version: 1.10

if game.PlaceId ~= 4010883325 then
    return warn("Wrong place!")
end

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function updateCharacter(newCharacter)
    Character = newCharacter
end
LocalPlayer.CharacterAdded:Connect(updateCharacter)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "The Ayuwoki Field",
    LoadingTitle = "Oxide Hub",
    LoadingSubtitle = "by qerrlo",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "OxideHubConfig",
        FileName = "AyuwokiESP"
    },
    KeySystem = false
})

local EspTab = Window:CreateTab("ESP", "user-round-search")
local MainSection = EspTab:CreateSection("Main")

local ESPManager = {
    enabled = false,
    ayuwoki = nil,
    espObjects = {},
    connections = {}
}

function ESPManager:CreateESPObjects()
    if not self.ayuwoki then return end
    
    self:CleanupESPObjects()
    
    self.espObjects.highlight = Instance.new("Highlight")
    self.espObjects.highlight.Name = "esp"
    self.espObjects.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    self.espObjects.highlight.FillColor = Color3.fromRGB(255, 0, 0)
    self.espObjects.highlight.FillTransparency = 0.5
    self.espObjects.highlight.OutlineColor = Color3.fromRGB(155, 55, 55)
    self.espObjects.highlight.OutlineTransparency = 0
    self.espObjects.highlight.Parent = self.ayuwoki
    
    self.espObjects.gui = Instance.new("BillboardGui")
    self.espObjects.gui.Name = "espGui"
    self.espObjects.gui.Adornee = self.ayuwoki:FindFirstChild("Head")
    self.espObjects.gui.AlwaysOnTop = true
    self.espObjects.gui.Size = UDim2.new(10, 0, 5, 0)
    self.espObjects.gui.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
    self.espObjects.gui.Parent = self.ayuwoki
    
    local uilist = Instance.new("UIListLayout")
    uilist.FillDirection = Enum.FillDirection.Vertical
    uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uilist.Parent = self.espObjects.gui
    
    self.espObjects.nameLabel = Instance.new("TextLabel")
    self.espObjects.nameLabel.BackgroundTransparency = 1
    self.espObjects.nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
    self.espObjects.nameLabel.Font = Enum.Font.RobotoMono
    self.espObjects.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.espObjects.nameLabel.TextScaled = true
    self.espObjects.nameLabel.Parent = self.espObjects.gui
    
    self.espObjects.distanceLabel = Instance.new("TextLabel")
    self.espObjects.distanceLabel.BackgroundTransparency = 1
    self.espObjects.distanceLabel.Size = UDim2.new(1, 0, 0.2, 0)
    self.espObjects.distanceLabel.Font = Enum.Font.RobotoMono
    self.espObjects.distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.espObjects.distanceLabel.TextScaled = true
    self.espObjects.distanceLabel.Parent = self.espObjects.gui
    
    self:UpdateESPInfo()
end

function ESPManager:UpdateESPInfo()
    if not self.enabled or not self.ayuwoki or not Character then return end
    
    if self.espObjects.nameLabel then
        self.espObjects.nameLabel.Text = "name: " .. self.ayuwoki.Name
    end
    
    if self.espObjects.distanceLabel and self.ayuwoki:FindFirstChild("HumanoidRootPart") and Character:FindFirstChild("HumanoidRootPart") then
        local distance = (self.ayuwoki.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
        self.espObjects.distanceLabel.Text = string.format("studs: %d", math.floor(distance))
    end
end

function ESPManager:CleanupESPObjects()
    for _, object in pairs(self.espObjects) do
        if object and typeof(object) == "Instance" then
            object:Destroy()
        end
    end
    self.espObjects = {}
end

function ESPManager:SetEnabled(enabled)
    self.enabled = enabled
    if enabled then
        self:CreateESPObjects()
        
        self.connections.update = RunService.RenderStepped:Connect(function()
            self:UpdateESPInfo()
        end)
    else
        self:CleanupESPObjects()
        
        for _, connection in pairs(self.connections) do
            if connection then
                connection:Disconnect()
            end
        end
        self.connections = {}
    end
end

local ESP_AyuwokiToggle = EspTab:CreateToggle({
    Name = "ESP Ayuwoki",
    CurrentValue = false,
    Flag = "ESP_Ayuwoki",
    Callback = function(Value)
        ESPManager:SetEnabled(Value)
    end,
})

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Ayuwoki" then
        ESPManager.ayuwoki = child
        if ESPManager.enabled then
            ESPManager:CreateESPObjects()
        end
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Ayuwoki" then
        ESPManager.ayuwoki = nil
        ESPManager:CleanupESPObjects()
    end
end)

if workspace:FindFirstChild("Ayuwoki") then
    ESPManager.ayuwoki = workspace.Ayuwoki
    if ESPManager.enabled then
        ESPManager:CreateESPObjects()
    end
end
