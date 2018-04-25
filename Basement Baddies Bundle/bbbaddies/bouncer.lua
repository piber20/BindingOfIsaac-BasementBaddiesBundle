function BBBaddiesMod:Bouncer(npc)
	local sprite = npc:GetSprite()
	if (npc.State == NpcState.STATE_MOVE) then
		if (npc.GridCollisionClass == 5) then
			npc:MultiplyFriction(1.5)
		end
		if (sprite:IsEventTriggered("Land")) then
			local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep:Update()
			creep:SetTimeout(120)
		end
	elseif (npc.State == NpcState.STATE_STOMP) then			
		if (sprite:WasEventTriggered("LandHeavy")) then
			npc.EntityCollisionClass = 4
			--npc.GridCollisionClass = 5
		end
		if (sprite:IsEventTriggered("LandHeavy")) then				
			local schut = ProjectileParams()
			schut.Variant = 3
			
			
			local projectileVelocity = Vector(0,1)
			projectileVelocity = projectileVelocity:Rotated(45)
			for i=0,3,1 do
				npc:FireProjectiles(npc.Position, projectileVelocity:Rotated(i*90) * 8, 0, schut)
			end
			
			local creepOffset = Vector(0,1)
			creepOffset = creepOffset:Rotated(math.random(0,60))
			for i=0,5,1 do
				local creep = Isaac.Spawn(1000, 26, 0, npc.Position + (creepOffset:Rotated(i*60) * 20), Vector(0,0), npc):ToEffect()
				creep:Update()
				creep:SetTimeout(120)
			end
			local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep:Update()
			creep:SetTimeout(120)
			
			npc:PlaySound(69, 1.0, 0, false, 1.0)
			npc:PlaySound(178, 1.0, 0, false, 1.0)
			
		elseif (sprite:IsEventTriggered("Land")) then
			local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep:Update()
			creep:SetTimeout(120)
			npc:PlaySound(69, 1.0, 0, false, 1.0)
			
		elseif (sprite:IsEventTriggered("Bounce")) then
			npc.Target = npc:GetPlayerTarget()
			local targetOffset = npc.Target.Position - npc.Position
			npc.TargetPosition = npc.Position + targetOffset:Normalized() * math.min(160,targetOffset:Length())
			npc.State = NpcState.STATE_SPECIAL
			npc.StateFrame = 0
		end
		
		npc.StateFrame = 0
			
	elseif (npc.State == NpcState.STATE_SPECIAL) then
		npc.Velocity = Vector(0,0)
		npc.Position = BBBaddiesMod:Lerp(npc.Position, npc.TargetPosition, 0.066)
		
		if (sprite:IsEventTriggered("Land")) then
			if (npc.StateFrame < 20) then
				local creepOffset = Vector(0,1)
				creepOffset = creepOffset:Rotated(math.random(0,90))
				for i=0,3,1 do
					local creep = Isaac.Spawn(1000, 26, 0, npc.Position + (creepOffset:Rotated(i*90) * 8), Vector(0,0), npc):ToEffect()
					creep:Update()
					creep:SetTimeout(120)
				end
			else
				local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
				creep:Update()
				creep:SetTimeout(120)
			end
			npc:PlaySound(69, 1.0, 0, false, 1.0)
			
		elseif (sprite:IsEventTriggered("Bounce")) then				
			npc.Target = npc:GetPlayerTarget()
			local targetOffset = npc.Target.Position - npc.Position
			npc.TargetPosition = npc.Position + targetOffset:Normalized() * math.min(96,targetOffset:Length())
		end
		
		if (sprite:IsFinished("BigJumpDown")) then
			npc.State = 4
			npc.StateFrame = 40
		end
		
	end
end