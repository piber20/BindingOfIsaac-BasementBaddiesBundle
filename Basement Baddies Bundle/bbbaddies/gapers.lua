function BBBaddiesMod:GaperVarients(npc)
	local init = false
	local room = Game():GetRoom()
	if npc.State == 0 then
		init = true
		npc.State = 4
	end
	if (npc.Variant == BBBaddiesEntityVariant.GAPER_MURMUR) then
		if npc.State == 4 then
			BBBaddiesMod:MovementGaper(npc,3.6)
			if (npc.StateFrame < 21) then
				npc.StateFrame = npc.StateFrame + 1
			else
				npc.StateFrame = 0
				local player = npc:GetPlayerTarget()
				local playerOffset = player.Position - npc.Position
				if (playerOffset:Length() < 160 and math.random(0,3) == 0) then
					npc.State = 8
					npc.StateFrame = 0
					npc:GetSprite():Play("Attack", true)
				end
			end
			if (npc.FrameCount % 6 == 0 and math.random(0,4) == 0) then
				local splat = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_SPLAT, 0, npc.Position, Vector(0,0), npc):ToEffect()
				splat:GetSprite():SetFrame("Size" .. math.random(1,3) .. "BloodStains", math.random(0,15))
			end
		elseif npc.State == 8 then
			npc:MultiplyFriction(0.5)
			local sprite = npc:GetSprite()
			if (sprite:IsEventTriggered("Shoot")) then
				local player = npc:GetPlayerTarget()
				local playerOffset = player.Position - npc.Position
				if (playerOffset:Length() > 160) then playerOffset = playerOffset:Normalized() * 160 end
				
				local schut = ProjectileParams()
				schut.Scale = 1.5
				schut.FallingSpeedModifier = -20
				schut.FallingAccelModifier = 1
				npc:FireProjectiles(npc.Position, playerOffset * 0.04, 0, schut)
				
				npc:PlaySound(213, 1.0, 0, false, 1.0)
			end
			if (sprite:IsFinished("Attack")) then
				npc.State = 4
			end
		end
	end
	
end
function BBBaddiesMod:MovementGaper(npc, moveSpeed)
	local room = Game():GetRoom()
	npc.Target = npc:GetPlayerTarget()
	npc.TargetPosition = npc.Target.Position
	local targetDirection = (npc.TargetPosition - npc.Position):Normalized()
	
	if (room:CheckLine(npc.Position + (targetDirection * -4), npc.TargetPosition - (targetDirection * 8), 0, 64, false, false)) then 
		npc.Velocity = npc.Velocity + (targetDirection * (moveSpeed / 6))
		if (npc.Velocity:Length() > moveSpeed) then npc.Velocity = npc.Velocity:Normalized() * moveSpeed end
	else
		npc.Pathfinder:FindGridPath(npc.TargetPosition, (moveSpeed / 8), 0, true)		
	end
	
	npc:AnimWalkFrame("WalkHori", "WalkVert", 1.0)
end
function BBBaddiesMod:GaperVarientsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.HitPoints < dmg and math.random(0,4) == 0) then
		local gripe = Isaac.Spawn(EntityType.ENTITY_GUSHER, BBBaddiesEntityVariant.GUSHER_GRIPE, 0, npc.Position, Vector(0,0), npc)
		gripe:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
	end
end



BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.GaperVarients, BBBaddiesEntityType.ENTITY_CUSTOM_GAPER)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.GaperVarientsTakeDamage, EntityType.ENTITY_CUSTOM_GAPER)