version = "1.0"

local config = {
	animationPack = "Levitation";
	includeToStarterAnimate = false;
}

local starter_player = game:GetService("StarterPlayer")
local player = game.Players.LocalPlayer

function isR15(plr)
	if plr.Character and plr.Character:FindFirstChildOfClass('Humanoid') then
		return plr.Character:FindFirstChildOfClass('Humanoid').RigType == Enum.HumanoidRigType.R15
	end
	return false
end

local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
local animate = player.Character:FindFirstChild("Animate")

local animPacks = {
	["Levitation"] = {
		climb = {
			ClimbAnim = "http://www.roblox.com/asset/?id=10921132092";
		};
		fall = {
			FallAnim = "http://www.roblox.com/asset/?id=10921136539";
		};
		idle = {
			Animation1 = "http://www.roblox.com/asset/?id=10921132962";
			Animation2 = "http://www.roblox.com/asset/?id=10921133721";
		};
		jump = {
			JumpAnim = "http://www.roblox.com/asset/?id=10921137402";
		};
		run = {
			RunAnim = "http://www.roblox.com/asset/?id=10921135644";
		};
		swim = {
			Swim = "http://www.roblox.com/asset/?id=10921138209";
		};
		swimidle = {
			SwimIdle = "http://www.roblox.com/asset/?id=10921139478";
		};
		walk = {
			WalkAnim = "http://www.roblox.com/asset/?id=10921140719";
		};
	};
	["Stylized Female"] = {
		climb = {
			ClimbAnim = "http://www.roblox.com/asset/?id=4708184253";
		};
		fall = {
			FallAnim = "http://www.roblox.com/asset/?id=4708186162";
		};
		idle = {
			Animation1 = "http://www.roblox.com/asset/?id=4708191566";
			Animation2 = "http://www.roblox.com/asset/?id=4708192150";
		};
		jump = {
			JumpAnim = "http://www.roblox.com/asset/?id=4708188025";
		};
		run = {
			RunAnim = "http://www.roblox.com/asset/?id=4708192705";
		};
		swim = {
			Swim = "http://www.roblox.com/asset/?id=4708189360";
		};
		swimidle = {
			SwimIdle = "http://www.roblox.com/asset/?id=4708190607";
		};
		walk = {
			WalkAnim = "http://www.roblox.com/asset/?id=4708193840";
		};
	};
}

local function replaceAnimationId(packName: string?, includeToStarterAnimate: boolean?): ()
	local animPack = animPacks[packName]
	if animate and animPack then
		local success, errorMessage = pcall(function()
			task.spawn(function()
				animate.Disabled = true

				animate.climb.ClimbAnim.AnimationId = animPack.climb.ClimbAnim
				animate.fall.FallAnim.AnimationId = animPack.fall.FallAnim
				animate.idle.Animation1.AnimationId = animPack.idle.Animation1
				animate.idle.Animation2.AnimationId = animPack.idle.Animation2
				animate.jump.JumpAnim.AnimationId = animPack.jump.JumpAnim
				animate.run.RunAnim.AnimationId = animPack.run.RunAnim
				animate.swim.Swim.AnimationId = animPack.swim.Swim
				animate.swimidle.SwimIdle.AnimationId = animPack.swimidle.SwimIdle
				animate.walk.WalkAnim.AnimationId = animPack.walk.WalkAnim

				animate.Disabled = false

				if includeToStarterAnimate then
					local starter_animate = starter_player.StarterCharacterScripts:FindFirstChild("Animate")
					if starter_animate then
						starter_animate.climb.ClimbAnim.AnimationId = animPack.climb.ClimbAnim
						starter_animate.fall.FallAnim.AnimationId = animPack.fall.FallAnim
						starter_animate.idle.Animation1.AnimationId = animPack.idle.Animation1
						starter_animate.idle.Animation2.AnimationId = animPack.idle.Animation2
						starter_animate.jump.JumpAnim.AnimationId = animPack.jump.JumpAnim
						starter_animate.run.RunAnim.AnimationId = animPack.run.RunAnim
						starter_animate.swim.Swim.AnimationId = animPack.swim.Swim
						starter_animate.swimidle.SwimIdle.AnimationId = animPack.swimidle.SwimIdle
						starter_animate.walk.WalkAnim.AnimationId = animPack.walk.WalkAnim
					end
				end
			end)
		end)

		if success then
			print("Succefully - Replaced animations to " .. animPack)
		else
			print("Error - Replacing animations: " .. errorMessage)
		end
	end
end

replaceAnimationId(config.animationPack, config.includeToStarterAnimate)
