EnemyRebalanceMod = RegisterMod("Enemy Rebalances", 1)

function EnemyRebalanceMod:onChargerUpdate(entity)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if entity.Variant == 1 then --drowned chargers
			local healthToSet = 20 --force their health to the same as a normal charger's
			
			if entity.SpawnerType > 0 then --lower their health to half a charger's if something spawned them (like a drowned hive)
				healthToSet = 10
			end
			
			--set the health
			entity.MaxHitPoints = healthToSet
			entity.HitPoints = healthToSet
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)

function EnemyRebalanceMod:onTearProjectileUpdate(projectile)
	local frameCount = projectile.FrameCount
	if frameCount == 2 then
		local projectileSprite = projectile:GetSprite()
		if projectileSprite:GetFilename() == "gfx/002.000_Tear.anm2" then
			local frame = projectileSprite:GetFrame()
			local offset = projectileSprite.Offset
			local scale = projectileSprite.Scale
			local rotation = projectileSprite.Rotation
			local color = projectileSprite.Color
			local flipX = projectileSprite.FlipX
			local flipY = projectileSprite.FlipY
			local speed = projectileSprite.PlaybackSpeed
			local animationToPlay = "RegularTear6"
			if projectileSprite:IsPlaying("RegularTear1") then
				animationToPlay = "RegularTear1"
			elseif projectileSprite:IsPlaying("RegularTear2") then
				animationToPlay = "RegularTear2"
			elseif projectileSprite:IsPlaying("RegularTear3") then
				animationToPlay = "RegularTear3"
			elseif projectileSprite:IsPlaying("RegularTear4") then
				animationToPlay = "RegularTear4"
			elseif projectileSprite:IsPlaying("RegularTear5") then
				animationToPlay = "RegularTear5"
			elseif projectileSprite:IsPlaying("RegularTear6") then
				animationToPlay = "RegularTear6"
			elseif projectileSprite:IsPlaying("RegularTear7") then
				animationToPlay = "RegularTear7"
			elseif projectileSprite:IsPlaying("RegularTear8") then
				animationToPlay = "RegularTear8"
			elseif projectileSprite:IsPlaying("RegularTear9") then
				animationToPlay = "RegularTear9"
			elseif projectileSprite:IsPlaying("RegularTear10") then
				animationToPlay = "RegularTear10"
			elseif projectileSprite:IsPlaying("RegularTear11") then
				animationToPlay = "RegularTear11"
			elseif projectileSprite:IsPlaying("RegularTear12") then
				animationToPlay = "RegularTear12"
			elseif projectileSprite:IsPlaying("RegularTear13") then
				animationToPlay = "RegularTear13"
			end
			projectileSprite:Load("gfx/009.004_tear projectile.anm2", true)
			projectileSprite.Offset = offset
			projectileSprite.Scale = scale
			projectileSprite.Rotation = rotation
			projectileSprite.Color = color
			projectileSprite.FlipX = flipX
			projectileSprite.FlipY = flipY
			projectileSprite.PlaybackSpeed = speed
			projectileSprite:SetFrame(animationToPlay, frame)
			projectileSprite:Play(animationToPlay, true)
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, EnemyRebalanceMod.onTearProjectileUpdate, ProjectileVariant.PROJECTILE_TEAR)

function EnemyRebalanceMod:onCoinProjectileUpdate(projectile)
	local frameCount = projectile.FrameCount
	if frameCount == 2 then
		local projectileSprite = projectile:GetSprite()
		if projectileSprite:GetFilename() == "gfx/002.020_Coin Tear.anm2" then
			local frame = projectileSprite:GetFrame()
			local offset = projectileSprite.Offset
			local scale = projectileSprite.Scale
			local rotation = projectileSprite.Rotation
			local color = projectileSprite.Color
			local flipX = projectileSprite.FlipX
			local flipY = projectileSprite.FlipY
			local speed = projectileSprite.PlaybackSpeed
			local animationToPlay = "MoveHori"
			if projectileSprite:IsPlaying("MoveVert") then
				animationToPlay = "MoveVert"
			elseif projectileSprite:IsPlaying("MoveHori") then
				animationToPlay = "MoveHori"
			end
			projectileSprite:Load("gfx/009.007_coin projectile.anm2", true)
			projectileSprite.Offset = offset
			projectileSprite.Scale = scale
			projectileSprite.Rotation = rotation
			projectileSprite.Color = color
			projectileSprite.FlipX = flipX
			projectileSprite.FlipY = flipY
			projectileSprite.PlaybackSpeed = speed
			projectileSprite:SetFrame(animationToPlay, frame)
			projectileSprite:Play(animationToPlay, true)
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, EnemyRebalanceMod.onCoinProjectileUpdate, ProjectileVariant.PROJECTILE_COIN)