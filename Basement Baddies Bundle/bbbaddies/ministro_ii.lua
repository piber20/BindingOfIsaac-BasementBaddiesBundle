local function Lerp(a, b, weight)
	return a * (1 - weight) + b * weight
end

function BBBaddiesMod:MinistroII(npc)
	local sprite = npc:GetSprite()
	if npc.State == 3 then
		if math.random(0,3) == 0 then
			sprite:Play("BigJumpUp",true)
			npc.Target = npc:GetPlayerTarget()
			npc.TargetPosition = npc.Target.Position
			npc.State = NpcState.STATE_ATTACK2
		end
	elseif npc.State == NpcState.STATE_ATTACK2 then
		if sprite:IsFinished("BigJumpUp") then
			sprite:Play("BigJumpDown",true)
			npc.EntityCollisionClass = 0
			npc.GridCollisionClass = 0
			npc.State = NpcState.STATE_ATTACK3
			
		elseif sprite:IsPlaying("BigJumpUp") == false then
			sprite:Play("BigJumpUp",true)
			npc.Target = npc:GetPlayerTarget()
			npc.TargetPosition = npc.Target.Position
		end
	elseif npc.State == NpcState.STATE_ATTACK3 then
		if sprite:IsEventTriggered("Land") then
			npc.EntityCollisionClass = 4
			npc.GridCollisionClass = 5
			local projectileCount = math.random(6,12)
			local projectileVelocity = Vector(1,0)
			
			for i=0,projectileCount,1 do
				local schut = ProjectileParams()
				schut.Scale = math.random(3,6) * 0.1
				schut.HeightModifier = 16
				schut.FallingSpeedModifier = math.random(-10, -6)
				schut.FallingAccelModifier = 0.5
				local direction = projectileVelocity:Rotated(math.random(0,360))
				local speed = math.random(3,5)
				npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
			end
			npc:PlaySound(48, 1.0, 0, false, 1.0)
			
		elseif (sprite:WasEventTriggered("Land") == false) then
			local prePos = npc.Position
			npc.Position = Lerp(npc.Position, npc.TargetPosition,0.1)
			npc.Velocity = (npc.Position - prePos)			
			
		elseif sprite:IsFinished("BigJumpDown") then
			sprite:Play("Idle",true)
			npc.State = 3
		end
	end
end