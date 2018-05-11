function BBBaddiesMod:GusherVarients(npc)
	
	if (npc.Variant == BBBaddiesEntityVariant.GUSHER_GRIPE) then
		if npc.State == 4 then
			local sprite = npc:GetSprite()
			if not sprite:IsOverlayPlaying("Blood") then sprite:PlayOverlay("Blood") end
			
			
			if (npc.StateFrame < 30) then
				npc.StateFrame = npc.StateFrame + 1
			else
				local targetDirection = Vector(1,0)
				local targetOffset = targetDirection:Rotated(math.random(0,360)) * math.random(32,160)
				if (math.random(0,2) == 0) then
					npc.StateFrame = 0
					local schut = ProjectileParams()
					schut.HeightModifier = 10
					schut.FallingSpeedModifier = -20
					schut.FallingAccelModifier = 1
					npc:FireProjectiles(npc.Position, targetOffset * 0.04, 0, schut)
					
					npc:PlaySound(213, 1.0, 0, false, 1.0)
				else
					npc.StateFrame = 15					
				end
			end
		end
	end
	
end

BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.GusherVarients, EntityType.ENTITY_GUSHER)