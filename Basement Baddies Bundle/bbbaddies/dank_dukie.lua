local function Lerp(a, b, weight)
	return a * (1 - weight) + b * weight
end

function BBBaddiesMod:FlyLatch(npc)
	if (npc.State == 0) then
		npc.State = 3
		--npc:PlaySound (4, 1.0, 0, true, 1.0)
		
	elseif (npc.State == 3) then
		if (math.random(0,1) == 0) then npc.I1 = 1 end		
		npc:GetSprite():Play("Fly", true)
		--npc:PlaySound(4, 0.5, 0, false, 1.0)
		npc.State = 4
		
	elseif (npc.State == 4) then
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetVelocity = (npc.TargetPosition - npc.Position):Normalized() * 5
		if npc.I1 == 1 then
			targetVelocity = targetVelocity:Rotated(-60)
		else
			targetVelocity = targetVelocity:Rotated(60)
		end
			
		npc.Velocity = Lerp(npc.Velocity,targetVelocity,0.5)
	end
	
	local accX = (math.random(0,100) - 50)*0.01
	local accY = (math.random(0,100) - 50)*0.01
	npc.Velocity = npc.Velocity + Vector(accX,accY)
	--npc:MultiplyFriction(0.8)
end

function BBBaddiesMod:DankDukie(npc)
	if (npc.State == 0) then
		npc.GridCollisionClass = 3
		npc.State = 3
		npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
		npc.V1 = Vector(1.1,0)
		
	else			
		local newVelocityX = 3--5
		local newVelocityY = 3--5
		if (npc.Velocity.X < 0) then newVelocityX = -3
		elseif (npc.Velocity.X == 0 and math.random(0,1) == 0) then newVelocityX = -3 end
		if (npc.Velocity.Y < 0) then newVelocityY = -3
		elseif (npc.Velocity.Y == 0 and math.random(0,1) == 0) then newVelocityY = -3 end
		
		npc.Velocity = Lerp(npc.Velocity, Vector(newVelocityX, newVelocityY), 0.05)
		if (npc.Velocity:Length() > 5) then npc.Velocity = npc.Velocity:Normalized() * 5 end

				
		if (npc.State == 3) then
			npc:GetSprite():Play("Idle", true)
			npc.State = 4
			
			npc.StateFrame = math.random(30,60)
			
		elseif(npc.State == 4) then
			
			npc.StateFrame = npc.StateFrame - 1
			if npc.StateFrame <= 0 then
				npc.State = NpcState.STATE_ATTACK
				npc:GetSprite():Play("Cough")
			end
		elseif(npc.State == NpcState.STATE_ATTACK ) then	
			local sprite = npc:GetSprite()
			if sprite:IsEventTriggered("Shoot") then			
				--local newNPC = Isaac.Spawn(281, 0, 0, npc.Position + Vector(0,13), Vector(0,3),npc)
				local newNPC = Isaac.Spawn(13, BBBaddiesEntityVariant.FLY_LATCH, 0, npc.Position + Vector(0,13), Vector(0,3),npc)
				newNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				newNPC.Parent = npc
				npc:PlaySound(318, 1.0, 0, false, 1.0)		
				
			elseif sprite:IsFinished("Cough") then
				npc:GetSprite():Play("Idle", true)
				npc.State = 4
				npc.StateFrame = math.random(40,60)
			end	
		elseif(npc.State == NpcState.STATE_ATTACK2 ) then			
			local sprite = npc:GetSprite()
			
			npc.StateFrame = npc.StateFrame - 1
			if npc.StateFrame <= 0 then
				npc:GetSprite():Play("Uncover")
			end
			
			if sprite:IsFinished("Cover") then
				npc:GetSprite():Play("Covered")
			elseif sprite:IsFinished("Uncover") then
				npc:GetSprite():Play("Idle", true)
				npc.State = 4
				npc.StateFrame = math.random(40,60)
			end
		end			
	end
end
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.DankDukie, BBBaddiesEntityType.ENTITY_DANK_DUKIE)

function BBBaddiesMod:DankDukieTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	local sprite = npc:GetSprite()
	local isCovered = false
	if sprite:IsPlaying("Covered") then	isCovered = true
	elseif sprite:IsPlaying("Cover") and sprite:WasEventTriggered("Cover") then isCovered = true
	elseif sprite:IsPlaying("Uncover") and sprite:WasEventTriggered("Uncover") == false then isCovered = true
	end	
	
	if isCovered then
		if sprite:IsPlaying("Cover") then
			local childEntCount = 0
			local entities = Isaac.GetRoomEntities()
			for i = 1, #entities do 
				if (entities[i]:IsVulnerableEnemy() and entities[i].Parent ~= nil and entities[i].Parent.Index == npc.Index) then
					childEntCount = childEntCount + 1				
				end
			end
			
			if (childEntCount > 2) then
				npc:ToNPC().StateFrame = math.random(80,160)
			end
		end
	
		return false
	else
		local childEntCount = 0
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do 
			if (entities[i]:IsVulnerableEnemy() and entities[i].Parent ~= nil and entities[i].Parent.Index == npc.Index) then
				childEntCount = childEntCount + 1				
			end
		end
		
		if (childEntCount > 3) then
			npc:ToNPC().State = NpcState.STATE_ATTACK2
			npc:GetSprite():Play("Cover")
			npc:ToNPC().StateFrame = math.random(80,160)
		elseif (math.random(0,2) < childEntCount) then
			npc:ToNPC().State = NpcState.STATE_ATTACK2
			npc:GetSprite():Play("Cover")
			npc:ToNPC().StateFrame = math.random(80,160)
		end			
	end
end
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.DankDukieTakeDamage, BBBaddiesEntityType.ENTITY_DANK_DUKIE)