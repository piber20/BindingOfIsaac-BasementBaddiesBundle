function BBBaddiesMod:HiveVariants(npc)
	if npc.State == 0 then
		npc.State = 4
		npc.StateFrame = 20
		
	elseif npc.State == 4 then
		local room = Game():GetRoom()
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = npc.TargetPosition - npc.Position
		local targetDirection = targetOffset:Normalized()
		
		local targetPlayer = false
		
		if (targetOffset:Length() < 360) then
			npc.Pathfinder:EvadeTarget(npc.TargetPosition)
			npc.Velocity = npc.Velocity * 2
			targetPlayer = true
		else
			npc.Pathfinder:MoveRandomly(false)
		end
		
		if (npc.Velocity:Length() > 5) then npc.Velocity = npc.Velocity:Normalized() * 5 end
				
		npc:AnimWalkFrame("WalkHori", "WalkVert", 1.0)
		local sprite = npc:GetSprite()
		if (sprite:IsOverlayPlaying("Walk") == false) then
			sprite:PlayOverlay("Walk", false)
		end
		
		if (npc.StateFrame < 40) then
			npc.StateFrame = npc.StateFrame + 1
		elseif (room:GetAliveEnemiesCount() < 15) then
			npc.StateFrame = 25
			if (targetOffset:Length() < 128 and math.random(0,16) == 0
				or math.random(0,128) == 0) then
				npc.State = NpcState.STATE_SUICIDE
				sprite:PlayOverlay("Explode", false)		
			else
				if (math.random(0,3) == 0) then
					if (targetPlayer) then npc.State = 8
					else npc.State = 9 end
					npc.StateFrame = -20
					sprite:PlayOverlay("Shoot", false)
				elseif math.random(0,2) == 0 then
					npc:PlaySound (143, 1.0, 0, false, 1)
					npc.StateFrame = 20
				end
			end
		elseif math.random(0,2) == 0 then
			npc:PlaySound (143, 1.0, 0, false, 1)
			npc.StateFrame = 20
		end	
	elseif npc.State == 8 then
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = npc.TargetPosition - npc.Position
		local targetDirection = targetOffset:Normalized()
		
		if (targetOffset:Length() < 360) then
			npc.Pathfinder:EvadeTarget(npc.TargetPosition)
			--npc.Velocity = npc.Velocity * 2
		else
			npc.Pathfinder:MoveRandomly(false)
		end
		
		if (npc.Velocity:Length() > 5) then npc.Velocity = npc.Velocity:Normalized() * 5 end
		
		npc:AnimWalkFrame("WalkHori", "WalkVert", 1.0)
		
		local sprite = npc:GetSprite()
		if (sprite:GetOverlayFrame() == 9) then -- Since you can't seem to get events from overlays, this will have to suffice.
			npc:PlaySound(178, 1.0, 0, false, 0.85)
			
			local player = npc:GetPlayerTarget()
			local playerOffset = (player.Position + Vector(math.random(-24,24),math.random(-24,24))) - npc.Position
			local playerDirection = playerOffset:Normalized()
			
			local projectileCount = math.random(6,8)
			local projectileVelocity = Vector(1,0)
			
			for i=0,projectileCount,1 do
				local schut = ProjectileParams()
				schut.Scale = math.random(3,6) * 0.2
				schut.HeightModifier = 16
				schut.FallingSpeedModifier = math.random(-18, -12)
				schut.FallingAccelModifier = 0.75--1--0.5
				local angle = math.random(-30,30)
				local direction = playerDirection:Rotated(angle)
				local speed = math.random(2,8) * (1 - (math.abs(angle) * 0.01))
				npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
			end		
		end
		if (sprite:IsOverlayFinished("Shoot")) then
			npc.State = 4
			npc.StateFrame = 0
		end
	elseif npc.State == 9 then
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = npc.TargetPosition - npc.Position
		local targetDirection = targetOffset:Normalized()
		
		if (targetOffset:Length() < 360) then
			npc.Pathfinder:EvadeTarget(npc.TargetPosition)
			--npc.Velocity = npc.Velocity * 2
		else
			npc.Pathfinder:MoveRandomly(false)
		end
		
		if (npc.Velocity:Length() > 5) then npc.Velocity = npc.Velocity:Normalized() * 5 end
		
		npc:AnimWalkFrame("WalkHori", "WalkVert", 1.0)
		
		local sprite = npc:GetSprite()
		if (sprite:GetOverlayFrame() == 9) then -- Since you can't seem to get events from overlays, this will have to suffice.
			npc:PlaySound(178, 1.0, 0, false, 0.85)
			
			local player = npc:GetPlayerTarget()
			local playerOffset = (player.Position + Vector(math.random(-24,24),math.random(-24,24))) - npc.Position
			local playerDirection = playerOffset:Normalized()
			
			local projectileCount = math.random(6,8)
			local projectileVelocity = Vector(1,0)
			
			for i=0,projectileCount,1 do
				local schut = ProjectileParams()
				schut.Scale = math.random(3,6) * 0.15
				schut.HeightModifier = 16
				schut.FallingSpeedModifier = math.random(-18, -12)
				schut.FallingAccelModifier = 0.75
				local direction = projectileVelocity:Rotated(math.random(0,360))
				local speed = math.random(3,5)
				npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
			end	
		end
		if (sprite:IsOverlayFinished("Shoot")) then
			npc.State = 4
			npc.StateFrame = 0
		end
	elseif npc.State == NpcState.STATE_SUICIDE then
		npc:MultiplyFriction(0.5)
		npc:AnimWalkFrame("WalkHori", "WalkVert", 1.0)
		local sprite = npc:GetSprite()
		if (sprite:IsOverlayFinished("Explode")) then
			Isaac.Explode(npc.Position, npc, 1.0)
			for i=1,3,1 do
				local projectileSpeed = math.random(5,15) * 0.2
				local projectileVelocity = Vector(projectileSpeed,0)
				projectileVelocity = projectileVelocity:Rotated(math.random(0,360))
				
				local boilBall = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, 2, 0, npc.Position + projectileVelocity, projectileVelocity,npc)
				boilBall:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				boilBall:ToNPC().I1 = math.random(0,2)--4
				boilBall:ToNPC().V1 = Vector(math.random(-8,-4),0.35)
				boilBall.Parent = npc
			end
			npc:Remove()
		end
	end
end
function BBBaddiesMod:HiveVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesEntityVariant.HIVE_BOILLIGAN) then
		if (npc.HitPoints < dmg) then
			for i=1,3,1 do
				local projectileSpeed = math.random(5,15) * 0.2
				local projectileVelocity = Vector(projectileSpeed,0)
				projectileVelocity = projectileVelocity:Rotated(math.random(0,360))
				
				local boilBall = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, 2, 0, npc.Position + projectileVelocity, projectileVelocity,npc)
				boilBall:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				boilBall:ToNPC().I1 = math.random(0,2)--4
				boilBall:ToNPC().V1 = Vector(math.random(-8,-4),0.35)
				boilBall.Parent = npc
			end
		end
	end
end

BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.HiveVariants, BBBaddiesEntityType.ENTITY_CUSTOM_HIVE)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.HiveVariantsTakeDamage, BBBaddiesEntityType.ENTITY_CUSTOM_HIVE)