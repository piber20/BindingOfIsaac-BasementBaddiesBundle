function BBBaddiesMod:FatGlobin(npc)
	if npc.State == 0 then
		npc.State = 4
		npc.StateFrame = 20
	elseif npc.State == 4 then		
		local room = Game():GetRoom()
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetDirection = (npc.TargetPosition - npc.Position):Normalized()
				
		if (room:CheckLine(npc.Position + (targetDirection * -4), npc.TargetPosition - (targetDirection * 8), 0, 64, false, false)) then
			npc.Velocity = npc.Velocity + (targetDirection * 0.6)
			if (npc.Velocity:Length() > 3.6) then npc.Velocity = npc.Velocity:Normalized() * 3.6 end
		else
			npc.Pathfinder:FindGridPath(npc.TargetPosition, 0.6, 0, true)		
		end
		
		npc:MultiplyFriction(0.75)
		
		npc:AnimWalkFrame ("WalkHori", "WalkVert", 1.0)		
	end
	if (npc.Variant == BBBaddiesEntityVariant.FAT_GLOBIN_BLUBBER) then
		local sprite = npc:GetSprite()
		npc.StateFrame = npc.StateFrame + 1
		local currentFrame = sprite:GetFrame() + 1
		if (currentFrame > 36) then currentFrame = 0 end
		
		local regenStart = 150
		
		if (npc.StateFrame >= regenStart + 30) then
			newEnt = Isaac.Spawn(BBBaddiesEntityType.ENTITY_FAT_GLOBIN, variantFatGlobinComplete, 0, npc.Position, npc.Velocity, npc)
			newEnt.HitPoints = newEnt.MaxHitPoints / 2
			newEnt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			newSprite = newEnt:GetSprite()
			if (sprite:IsPlaying("WalkVert")) then
				newSprite:Play("WalkVert")
				newSprite:SetFrame("WalkVert",currentFrame)
			else
				newSprite:Play("WalkHori")
				newSprite:SetFrame("WalkHori",currentFrame)
			end
			npc:Remove()
		elseif (npc.StateFrame >= regenStart + 27) then
			sprite:SetOverlayFrame("WalkRegen10", currentFrame)
		elseif (npc.StateFrame >= regenStart + 24) then
			sprite:SetOverlayFrame("WalkRegen9", currentFrame)
		elseif (npc.StateFrame >= regenStart + 21) then
			sprite:SetOverlayFrame("WalkRegen8", currentFrame)
		elseif (npc.StateFrame >= regenStart + 18) then
			sprite:SetOverlayFrame("WalkRegen7", currentFrame)
		elseif (npc.StateFrame >= regenStart + 15) then
			sprite:SetOverlayFrame("WalkRegen6", currentFrame)
		elseif (npc.StateFrame >= regenStart + 12) then
			sprite:SetOverlayFrame("WalkRegen5", currentFrame)
		elseif (npc.StateFrame >= regenStart + 9) then
			sprite:SetOverlayFrame("WalkRegen4", currentFrame)
		elseif (npc.StateFrame >= regenStart + 6) then
			sprite:SetOverlayFrame("WalkRegen3", currentFrame)
		elseif (npc.StateFrame >= regenStart + 3) then
			sprite:SetOverlayFrame("WalkRegen2", currentFrame)
		elseif (npc.StateFrame >= regenStart) then
			sprite:SetOverlayFrame("WalkRegen1", currentFrame)
		end
	elseif (npc.Variant == BBBaddiesEntityVariant.FAT_GLOBIN_STACK) then
		local sprite = npc:GetSprite()
		npc.StateFrame = npc.StateFrame + 1
		local currentFrame = sprite:GetFrame() + 1
		if (currentFrame > 36) then currentFrame = 0 end
		local currentAnim = "WalkHori"
		if (sprite:IsPlaying("WalkVert")) then
			currentAnim = "WalkVert"
		end
		
		local regenStart = 150
		
		if (npc.StateFrame >= regenStart + 24) then
			newEnt = Isaac.Spawn(BBBaddiesEntityType.ENTITY_FAT_GLOBIN, BBBaddiesEntityVariant.FAT_GLOBIN_BLUBBER, 0, npc.Position, npc.Velocity, npc)
			newEnt.HitPoints = newEnt.MaxHitPoints / 2
			newEnt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			newSprite = newEnt:GetSprite()
			if (sprite:IsPlaying("WalkVert")) then
				newSprite:Play("WalkVert")
				newSprite:SetFrame("WalkVert",currentFrame)
			else
				newSprite:Play("WalkHori")
				newSprite:SetFrame("WalkHori",currentFrame)
			end
			npc:Remove()
		elseif (npc.StateFrame >= regenStart + 21) then
			sprite:SetOverlayFrame(currentAnim .. "Regen8", currentFrame)
		elseif (npc.StateFrame >= regenStart + 18) then
			sprite:SetOverlayFrame(currentAnim .. "Regen7", currentFrame)
		elseif (npc.StateFrame >= regenStart + 15) then
			sprite:SetOverlayFrame(currentAnim .. "Regen6", currentFrame)
		elseif (npc.StateFrame >= regenStart + 12) then
			sprite:SetOverlayFrame(currentAnim .. "Regen5", currentFrame)
		elseif (npc.StateFrame >= regenStart + 9) then
			sprite:SetOverlayFrame(currentAnim .. "Regen4", currentFrame)
		elseif (npc.StateFrame >= regenStart + 6) then
			sprite:SetOverlayFrame(currentAnim .. "Regen3", currentFrame)
		elseif (npc.StateFrame >= regenStart + 3) then
			sprite:SetOverlayFrame(currentAnim .. "Regen2", currentFrame)
		elseif (npc.StateFrame >= regenStart) then
			sprite:SetOverlayFrame(currentAnim .. "Regen1", currentFrame)
		end
	end
end
function BBBaddiesMod:FatGlobinTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == variantFatGlobinComplete) then
		if (npc.HitPoints < dmg) then
			--for i=0, 1 do
				local dmgDirection = (dmgSrc.Position - npc.Position):Normalized()
				local globinDirection = (dmgDirection + Vector(math.random(0,10) / 20,math.random(0,10) / 20)):Normalized()
				local globin = Isaac.Spawn(24, 0, 0, npc.Position, globinDirection * -10, npc)
				globin:ToNPC().State = 3
				globin:GetSprite():Play("ReGen", false)
				globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				globin.HitPoints = 10
				globin.MaxHitPoints = 10
			--end
			
			local newEnt = Isaac.Spawn(BBBaddiesEntityType.ENTITY_FAT_GLOBIN, BBBaddiesEntityVariant.FAT_GLOBIN_BLUBBER, 0, npc.Position, npc.Velocity, npc)
			newEnt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			newSprite = newEnt:GetSprite()
			sprite = npc:GetSprite()
			local currentFrame = sprite:GetFrame() + 1
			if (currentFrame > 36) then currentFrame = 0 end
			if (sprite:IsPlaying("WalkVert")) then
				newSprite:Play("WalkVert")
				newSprite:SetFrame("WalkVert",currentFrame)
			else
				newSprite:Play("WalkHori")
				newSprite:SetFrame("WalkHori",currentFrame)
			end
			
			npc:SetColor(Color(0,0,0,0,0,0,0), 10, 0, false, false)
			npc:Kill()
		end
	elseif (npc.Variant == BBBaddiesEntityVariant.FAT_GLOBIN_BLUBBER) then			
		if (npc.HitPoints < dmg) then					
			for i=0, 1 do
				local dmgDirection = (dmgSrc.Position - npc.Position):Normalized()
				local globinDirection = (dmgDirection + Vector(math.random(0,10) / 20,math.random(0,10) / 20)):Normalized()
				local globin = Isaac.Spawn(24, 0, 0, npc.Position, globinDirection * -10, npc)
				globin:ToNPC().State = 3
				globin:GetSprite():Play("ReGen", false)
				globin:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				globin.HitPoints = 10
				globin.MaxHitPoints = 10
			end
			
			local newEnt = Isaac.Spawn(BBBaddiesEntityType.ENTITY_FAT_GLOBIN, BBBaddiesEntityVariant.FAT_GLOBIN_STACK, 0, npc.Position, npc.Velocity, npc)
			newEnt:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			newSprite = newEnt:GetSprite()
			sprite = npc:GetSprite()
			local currentFrame = sprite:GetFrame() + 1
			if (currentFrame > 36) then currentFrame = 0 end
			if (sprite:IsPlaying("WalkVert")) then
				newSprite:Play("WalkVert")
				newSprite:SetFrame("WalkVert",currentFrame)
			else
				newSprite:Play("WalkHori")
				newSprite:SetFrame("WalkHori",currentFrame)
			end
			
			npc:SetColor(Color(0,0,0,0,0,0,0), 10, 0, false, false)
			npc:Kill()
		end
	end
end


BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.FatGlobin, BBBaddiesEntityType.ENTITY_FAT_GLOBIN)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.FatGlobinTakeDamage, EntityType.ENTITY_GURGLE)