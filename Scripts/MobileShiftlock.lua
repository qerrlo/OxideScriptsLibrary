-- Improved Shiftlock Script by fedoratum, hinorium
-- Version 4.0

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Settings = UserSettings()
local GameSettings = Settings.GameSettings

-- Constants
local SMOOTH_ENABLED = false
local STATES = {
	OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
	ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
}
local XZ_VECTOR3 = Vector3.new(1, 0, 1)
local ENABLED_OFFSET = CFrame.new(1.75, 0, 0)
local DISABLED_OFFSET = CFrame.new(-1.75, 0, 0)
local FIRST_PERSON_THRESHOLD = 2

-- Variables
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ShiftLockEnabled = false
local ActiveConnection = nil
local RootPosition = Vector3.new(0, 0, 0)
local InitialCameraLook = nil
local LastCameraOffset = DISABLED_OFFSET
local IsInFirstPerson = false

-- GUI Creation
local ShiftlockGui = Instance.new("ScreenGui")
ShiftlockGui.Name = "ShiftlockGui"
ShiftlockGui.Parent = Player.PlayerGui
ShiftlockGui.ResetOnSpawn = false
ShiftlockGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ShiftlockButton = Instance.new("ImageButton")
ShiftlockButton.Name = "ShiftlockButton"
ShiftlockButton.Parent = ShiftlockGui
ShiftlockButton.Active = true
ShiftlockButton.Draggable = true
ShiftlockButton.BackgroundTransparency = 1
ShiftlockButton.Position = UDim2.new(0.92, 0, 0.55, 0)
ShiftlockButton.Size = UDim2.new(0.064, 0, 0.066, 0)
ShiftlockButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftlockButton.Image = STATES.OFF

-- Mobile Compatibility
ShiftlockButton.Visible = UserInputService.TouchEnabled

-- Utility Functions
local function GetCharacter()
	return Player.Character
end

local function GetHumanoidRootPart()
	local character = GetCharacter()
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
	local character = GetCharacter()
	return character and character:FindFirstChild("Humanoid")
end

local function CheckFirstPerson()
	local character = GetCharacter()
	if character and Camera then
		local head = character:FindFirstChild("Head")
		if head then
			return (Camera.CFrame.Position - head.Position).Magnitude < FIRST_PERSON_THRESHOLD
		end
	end
	return false
end

local function UpdateRootPosition()
	local rootPart = GetHumanoidRootPart()
	if rootPart then
		RootPosition = rootPart.Position
	end
end

local function UpdateCharacterRotation(autoRotate)
	local humanoid = GetHumanoid()
	if humanoid then
		humanoid.AutoRotate = autoRotate
	end
end

local function GetCameraLookCFrame()
	if Camera then
		return CFrame.new(RootPosition, RootPosition + (Camera.CFrame.LookVector * XZ_VECTOR3).Unit)
	end
	return CFrame.new()
end

-- Main Functions
local function ResetCamera()
	if Camera then
		local rootPart = GetHumanoidRootPart()
		if rootPart then
			Camera.CFrame = Camera.CFrame
		end
	end
end

local function EnableShiftlock()
	UpdateRootPosition()
	UpdateCharacterRotation(false)
	ShiftlockButton.Image = STATES.ON
	IsInFirstPerson = CheckFirstPerson()

	local rootPart = GetHumanoidRootPart()
	if rootPart then
		if SMOOTH_ENABLED then
			rootPart.CFrame = rootPart.CFrame:Lerp(GetCameraLookCFrame(), 0.25)
		else
			rootPart.CFrame = GetCameraLookCFrame()
		end
	end

	if Camera then
		if not IsInFirstPerson then
			Camera.CFrame = Camera.CFrame * ENABLED_OFFSET
		end
	end
end

local function DisableShiftlock()
	UpdateRootPosition()
	UpdateCharacterRotation(true)
	ShiftlockButton.Image = STATES.OFF
	IsInFirstPerson = CheckFirstPerson()

	if Camera and not IsInFirstPerson then
		Camera.CFrame = Camera.CFrame * DISABLED_OFFSET
	end

	if ActiveConnection then
		ActiveConnection:Disconnect()
		ActiveConnection = nil
	end
end

local function InitializeCamera()
	local rootPart = GetHumanoidRootPart()
	if rootPart then
		Camera.CameraType = Enum.CameraType.Custom
		Camera.CFrame = Camera.CFrame
	end
end

local function ToggleShiftlock()
	if not ActiveConnection then
		InitializeCamera()
		ShiftLockEnabled = true
		ActiveConnection = RunService.RenderStepped:Connect(EnableShiftlock)
	else
		ShiftLockEnabled = false
		DisableShiftlock()
		ResetCamera()
	end
end

-- Event Connections
ShiftlockButton.MouseButton1Click:Connect(ToggleShiftlock)

-- Keyboard Support
ContextActionService:BindAction("ToggleShiftlock", function(_, state)
	if state == Enum.UserInputState.Begin then
		ToggleShiftlock()
	end
end, false, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift)

-- Camera Mode Changes
Camera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
	if ActiveConnection then
		DisableShiftlock()
		ResetCamera()
		ShiftLockEnabled = false
	end
end)

-- Character Loading
Player.CharacterAdded:Connect(function(character)
	if ActiveConnection then
		ActiveConnection:Disconnect()
		ActiveConnection = nil
	end
	ShiftLockEnabled = false
	ShiftlockButton.Image = STATES.OFF
	IsInFirstPerson = false

	character:WaitForChild("HumanoidRootPart")
	task.wait(0.1)
	InitializeCamera()
end)

-- Handle Camera Type Changes
Camera:GetPropertyChangedSignal("CameraType"):Connect(function()
	if Camera.CameraType ~= Enum.CameraType.Custom then
		if ActiveConnection then
			DisableShiftlock()
			ResetCamera()
			ShiftLockEnabled = false
		end
	end
end)

-- Handle Zoom Changes
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel and ShiftLockEnabled then
		IsInFirstPerson = CheckFirstPerson()
	end
end)
