function BBBaddiesMod:Spiny(npc)
	if (npc.State > 5) then
		if (npc:GetSprite():IsEventTriggered("ShootBone")) then	
			local player = npc:GetPlayerTarget()
			local playerOffset = (player.Position + Vector(math.random(-24,24),math.random(-24,24))) - npc.Position
			local playerDirection = playerOffset:Normalized()
			
			local schut = ProjectileParams()
			
			schut.Variant = 1
			
			npc:FireProjectiles(npc.Position, playerDirection * 10, 0, schut)
			npc:PlaySound(249, 1.0, 0, false, 1.0)				
		end
	end
end