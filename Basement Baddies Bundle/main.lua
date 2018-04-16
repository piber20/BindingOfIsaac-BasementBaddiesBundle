local   BBB = RegisterMod( "basement baddies bundle", 1);


--Projectiles
local	typeCustomTears = Isaac.GetEntityTypeByName("Bubble Tear")
local	variantTearBubble = Isaac.GetEntityVariantByName("Bubble Tear")

--New Variants
local	variantLatchFly = Isaac.GetEntityVariantByName("Latch Fly")
local	variantMinistroII = Isaac.GetEntityVariantByName("Ministro II")
local	variantDrownedDip = Isaac.GetEntityVariantByName("Drowned Dip")
local	variantDrownedSquirt = Isaac.GetEntityVariantByName("Drowned Squirt")

--New Enemies
local	typeFlamingHorf = Isaac.GetEntityTypeByName("Flaming Horf")
local	typeModCreep = Isaac.GetEntityTypeByName("Drowned Creep")
local	variantDrownedCreep = Isaac.GetEntityVariantByName("Drowned Creep")
local	variantStickyCreep = Isaac.GetEntityVariantByName("Sticky Creep")
local	typeDankDukie = Isaac.GetEntityTypeByName("Dank Dukie")


--Old Enemies
local	variantRoundWorm = Isaac.GetEntityVariantByName("Round Worm")
local	typeHorf = Isaac.GetEntityTypeByName("Horf")
local	typeWallCreep = Isaac.GetEntityTypeByName("Wall Creep")
local	typeRageCreep = Isaac.GetEntityTypeByName("Rage Creep")
local	typeBlindCreep = Isaac.GetEntityTypeByName("Blind Creep")
local	typeTheThing = Isaac.GetEntityTypeByName("The Thing")
local	typeDukie = Isaac.GetEntityTypeByName("Dukie")


local	debugString = "Sorry Nothing"


local function bit(p)--function to get bits from integers
  return 2 ^ (p - 1)
end
local function hasbit(x, p)
  return x % (p + p) >= p       
end
local function setbit(x, p)--function to add bit p to integer x
  return hasbit(x, p) and x or x + p
end
local function clearbit(x, p)
  return hasbit(x, p) and x - p or x
end

local function Lerp(a, b, weight)
	return a * (1 - weight) + b * weight
end

local function DistanceFromLine(point, lineStart, lineEnd)
	local dif = lineEnd - lineStart
    if (dif.X == 0) and (dif.Y == 0) then
        dif = point - lineStart
        return math.sqrt(dif.X * dif.X + dif.Y * dif.Y)
	else
		local t = ((point.X - lineStart.X) * dif.X + (point.Y - lineStart.Y) * dif.Y) / (dif.X * dif.X + dif.Y * dif.Y);
	
		if (t < 0) then
			dif.X = point.X - lineStart.X
			dif.Y = point.Y - lineStart.Y
		elseif (t > 1) then
			dif.X = point.X - lineEnd.X
			dif.Y = point.Y - lineEnd.Y
		else
			local newPoint = Vector(lineStart.X + (t * dif.X), lineStart.Y + (t * dif.Y))
			dif.X = point.X - newPoint.X
			dif.Y = point.Y - newPoint.Y
		end

		return math.sqrt(dif.X * dif.X + dif.Y * dif.Y);
	end
end

function BBB:FlyVariants(npc)
	--for some reason the fly sfx doesn't want to work, so this is gonna' go ahead and be a fly variant to make it do so
	if (npc.Variant == variantLatchFly) then 
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
end
function BBB:DipVariants(npc)
	if (npc.Variant == variantDrownedDip) then		
		if npc:GetSprite():IsFinished("Appear") then
			npc.State = 3
		end
		if ((npc.Position - npc.V1):Length() > 10) then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position + (npc.Velocity * 0.5), Vector(0,0), npc):ToEffect()
			npc.V1 = npc.Position
			creep:Update()
			local anim = "0" .. math.random(1,6)
			creep:SetSize(12, Vector(1,1),0)
			creep:GetSprite():SetFrame("SmallBlood" .. anim, 2)
			creep:SetTimeout(30)
			
			npc.Scale = npc.Scale - 0.04
			if (npc.Scale < 0.5) then
				npc:Kill()
			end	
		end
	elseif (npc.SpawnerType == 220 and npc.SpawnerVariant == variantDrownedSquirt) then
		npc:Morph(217, variantDrownedDip, npc.SubType, npc:GetChampionColorIdx())
	elseif (npc.FrameCount <= 1 and npc.Variant == 0) then
		if (npc.SpawnerType == 223 and npc.SpawnerVariant == variantDankDinga) then
			npc:Morph(217, variantDankDip, npc.SubType, npc:GetChampionColorIdx())
		elseif (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 9) then
				npc:Morph(217, variantDankDip, npc.SubType, npc:GetChampionColorIdx())
			end
		end
	end
end
function BBB:SquirtVariants(npc)
	if (npc.Variant == variantDrownedSquirt) then		
		if (npc:GetData().creepPos == nil) then
			npc:GetData().creepPos = { {npc.Position, npc.FrameCount}, {npc.Position, npc.FrameCount} };
		end
		if ((npc.Position - npc.V1):Length() > 20 or (npc.Velocity:Length() < 1 and npc.FrameCount % 12 == 0)) then
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_SLIPPERY_BROWN, 0, npc.Position + (npc.Velocity * 0.5), Vector(0,0), npc):ToEffect()
			npc.V1 = npc.Position
			creep:Update()
			local anim = "0" .. math.random(1,6)
			creep:SetSize(32, Vector(1,1),0)
			creep:GetSprite():SetFrame("BigBlood" .. anim, 2)
			creep:SetTimeout(60)
			
			table.insert(npc:GetData().creepPos, { creep.Position, npc.FrameCount} )
		end
		
		--debugString = "#creepPos:" .. #npc:GetData().creepPos
		for i, dipCreep in ipairs(npc:GetData().creepPos) do
			local creepPosition = dipCreep[1]
			local creepTime = dipCreep[2]
			
			if (npc.FrameCount > creepTime + 45) then
				table.remove(npc:GetData().creepPos,i)
				
			elseif ((creepPosition - npc.Position):Length() > 32 and math.random(0,96) == 0) then
				local offset = Vector(1,0):Rotated(math.random(0,360)) * math.random(0,8)
				local dip = Isaac.Spawn(217, variantDrownedDip, 0, creepPosition + offset, Vector(0,0), npc)
				dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
				dip:Update()
				dip:ToNPC().State = 2
				dip:GetSprite():Play("Appear", true)
			end
		end
		
	elseif (npc.FrameCount <= 1 and npc.Variant == 0) then
		if (npc.SpawnerType == 223 and npc.SpawnerVariant == variantDankDinga) then
			npc:Morph(220, 1, npc.SubType, npc:GetChampionColorIdx())
		end
	end
end
function BBB:SquirtVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == variantDrownedSquirt) then
		if (npc.HitPoints < dmg) then
			for i=0,1,1 do
				local offset = Vector(1,0):Rotated(math.random(0,360)) * math.random(0,8)
				local dip = Isaac.Spawn(217, variantDrownedDip, 0, npc.Position + offset, Vector(0,0), npc)
				dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			end
		end
	end
end


function BBB:FlamingHorf(npc)
	if (npc.State == 0) then
		npc.GridCollisionClass = 3
		npc.State = 3
	elseif (npc.State == 3) then
		npc:GetSprite():Play("Shake", true)
		npc.State = 4
	elseif (npc.State == 4) then
		local room = Game():GetRoom()
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = npc.TargetPosition - npc.Position
		local targetDirection = targetOffset:Normalized()
			
		npc.Velocity = npc.Velocity + (targetDirection * 0.1)
		if (npc.Velocity:Length() > 1.5) then npc.Velocity = npc.Velocity:Normalized() * 1.5 end
		
		if (math.abs(targetOffset.X) < 12 or math.abs(targetOffset.Y) < 12) then
			npc.State = 8
			npc.StateFrame = 0
			npc:GetSprite():Play("Attack")
			npc:PlaySound(146, 1.0, 0, false, 1.0)
			if (math.abs(targetOffset.X) < math.abs(targetOffset.Y)) then
				if (targetOffset.Y < 0) then
					npc.TargetPosition = Vector(0,-1)
				else
					npc.TargetPosition = Vector(0,1)					
				end
			else
				if (targetOffset.X < 0) then
					npc.TargetPosition = Vector(-1,0)
				else
					npc.TargetPosition = Vector(1,0)					
				end
			end
		end
	elseif (npc.State == 8) then
		if (npc.StateFrame == 0) then
			if (npc:GetSprite():IsFinished("Attack")) then
				npc.StateFrame = 1
				npc.Velocity = Lerp(npc.Velocity,npc.TargetPosition * 12,0.5)
				npc.Mass = 20
				npc.GridCollisionClass = 6
				
				if (math.abs(npc.TargetPosition.X) > math.abs(npc.TargetPosition.Y)) then
					if (npc.TargetPosition.X > 0) then
						npc:GetSprite():Play("ChargeRight")
					else
						npc:GetSprite():Play("ChargeLeft")				
					end
				else
					if (npc.TargetPosition.Y > 0) then
						npc:GetSprite():Play("ChargeDown")
					else
						npc:GetSprite():Play("ChargeUp")				
					end
				end
			end
		elseif (npc.StateFrame == 1) then
			local collided = false
			
			if (math.abs(npc.TargetPosition.X) > math.abs(npc.TargetPosition.Y)) then
				if (npc.TargetPosition.X > 0) then
					if (npc.Velocity.X <= 0) then collided = true end
				else
					if (npc.Velocity.X >= 0) then collided = true end					
				end
			else
				if (npc.TargetPosition.Y > 0) then
					if (npc.Velocity.Y <= 0) then collided = true end
				else
					if (npc.Velocity.Y >= 0) then collided = true end					
				end
			end
		
			if (collided) then
				npc.StateFrame = 2
				npc.Mass = 7
				npc.GridCollisionClass = 3
				npc:GetSprite():Play("Bump")
				
				local schut = ProjectileParams()
				schut.BulletFlags = (2 ^ 28) --+ (2 ^ 4)
				schut.HeightModifier = 20
				schut.FallingSpeedModifier = 0.5
				schut.FallingAccelModifier = -0.15
				schut.Variant = 2
				schut.Color = Color(1,1,0.2,1,100,25,0)
				
				local projectileVelocity = Vector(10,0)
				
				for i=0,7,1 do
					npc:FireProjectiles(npc.Position, projectileVelocity:Rotated(i*45), 0, schut)
				end
			else
				npc.Velocity = Lerp(npc.Velocity,npc.TargetPosition * 12,0.5)
			end	
		else
			npc:MultiplyFriction(0.85)--npc.Velocity = npc.Velocity * (npc.Friction / 1.15)
			if (npc:GetSprite():IsFinished("Bump")) then
				npc:GetSprite():Play("Shake", true)
				npc.State = 4
			end
		end
	end
end
function BBB:Spiny(npc)
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
function BBB:CreepVariants(npc)
	local room = Game():GetRoom()
	local tlPos = room:GetTopLeftPos()
	local brPos = room:GetBottomRightPos()
	
	if npc.State == 0 then
		if npc.I1 == 0 then
			local upDistance = math.abs(npc.Position.Y - tlPos.Y)
			local downDistance = math.abs(npc.Position.Y - brPos.Y)
			local leftDistance = math.abs(npc.Position.X - tlPos.X)
			local rightDistance = math.abs(npc.Position.X - brPos.X)
			
			if downDistance < upDistance then
				if leftDistance < rightDistance then
					if downDistance < leftDistance then
						npc.I1 = 2
					else
						npc.I1 = 3
					end
				else
					if downDistance < rightDistance then
						npc.I1 = 2
					else
						npc.I1 = 4
					end
				end
			else
				if leftDistance < rightDistance then
					if upDistance < leftDistance then
						npc.I1 = 1
					else
						npc.I1 = 3
					end
				else
					if upDistance < rightDistance then
						npc.I1 = 1
					else
						npc.I1 = 4
					end
				end
			end
		end
		
		if npc.I1 == 1 then
			npc.Position = Vector(npc.Position.X,tlPos.Y)
		elseif npc.I1 == 2 then
			npc.Position = Vector(npc.Position.X,brPos.Y)
			npc.SpriteRotation = 180
		elseif npc.I1 == 3 then
			npc.Position = Vector(tlPos.X,npc.Position.Y)
			npc.SpriteRotation = 270
			npc.SpriteOffset = Vector(0,-12)
		elseif npc.I1 == 4 then
			npc.Position = Vector(brPos.X,npc.Position.Y)
			npc.SpriteRotation = 90
			npc.SpriteOffset = Vector(0,-12)
		end
		npc.State = 3
		npc.StateFrame = math.random(40,70)
		npc.GridCollisionClass = 0
	else
		local targetPlayer = true
		local moveSpeed = 2
		
		if (npc.Variant == variantStickyCreep) then moveSpeed = 4 end
		
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = (npc.TargetPosition - npc.Position)
		local sprite = npc:GetSprite()
		
		if npc.State == 3 then
			if targetPlayer then				
				if npc.I1 == 1 or npc.I1 == 2 then
					if targetOffset.X > 5 then
						if sprite:IsPlaying("Walk") == false then
							sprite:Play("Walk",true)
							sprite.PlaybackSpeed = 1
						end
						npc.Velocity = Vector(moveSpeed,0)
						npc.SpriteScale = Vector(-1,0)
						--npc.FlipX = true
					elseif targetOffset.X < -5 then
						if sprite:IsPlaying("Walk") == false then
							sprite:Play("Walk",true)
							sprite.PlaybackSpeed = 1
						end
						npc.Velocity = Vector(-moveSpeed,0)
						npc.SpriteScale = Vector(1,0)
						--npc.FlipX = false
					else				
						npc.Velocity = Vector(0,0)
						if sprite:IsPlaying("Walk") then
							sprite:Play("Attack",true)
							sprite.PlaybackSpeed = 0
						end
					end
				
				elseif  npc.I1 == 3 or npc.I1 == 4 then
					if targetOffset.Y > 5 then
						if sprite:IsPlaying("Walk") == false then
							sprite:Play("Walk",true)
							sprite.PlaybackSpeed = 1
						end
						npc.Velocity = Vector(0,moveSpeed)
						npc.SpriteScale = Vector(-1,0)
						--npc.FlipX = true
					elseif targetOffset.Y < -5 then
						if sprite:IsPlaying("Walk") == false then
							sprite:Play("Walk",true)
							sprite.PlaybackSpeed = 1
						end
						npc.Velocity = Vector(0,-moveSpeed)
						npc.SpriteScale = Vector(1,0)
						--npc.FlipX = false
					else				
						npc.Velocity = Vector(0,0)
						if sprite:IsPlaying("Walk") then
							sprite:Play("Attack",true)
							sprite.PlaybackSpeed = 0
						end
					end
				end
			end
			
			npc.StateFrame = npc.StateFrame - 1
			if npc.StateFrame <= 0 then
				npc.State = 8
				sprite:Play("Attack",true)
				sprite.PlaybackSpeed = 1
			end
		end
		
		if (npc.Variant == variantDrownedCreep) then		
			if npc.State == 8 then
				if sprite:IsEventTriggered("Fire") then
					local projectileVelocity
					
					if npc.I1 == 1 then
						projectileVelocity = Vector(0,math.abs(targetOffset.Y) * 0.1)
					elseif npc.I1 == 2 then
						projectileVelocity = Vector(0,-math.abs(targetOffset.Y) * 0.1)
					elseif npc.I1 == 3 then
						projectileVelocity = Vector(math.abs(targetOffset.X * 0.1),0)
					elseif npc.I1 == 4 then
						projectileVelocity = Vector(-math.abs(targetOffset.X * 0.1),0)
					end	
						
					local newNPC = Isaac.Spawn(typeCustomTears, variantTearBubble, 0, npc.Position + projectileVelocity, projectileVelocity, npc)
					newNPC:ToNPC().I1 = 3
					newNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					BBB:TearBubbleInit(newNPC:ToNPC())
					npc:PlaySound(317, 1.0, 0, false, 1.0)	
				end	
				if sprite:IsFinished("Attack") then				
					npc.State = 3
					npc.StateFrame = math.random(40,70)
				end	
				npc:MultiplyFriction(0.75)
			end
		end
		if (npc.Variant == variantStickyCreep) then
			if npc.State == 8 then
				if sprite:IsEventTriggered("Fire") then
					local projectileVelocity
					local projectileSpeed = 6
					if npc.I1 == 1 then
						projectileVelocity = Vector(0,projectileSpeed)
					elseif npc.I1 == 2 then
						projectileVelocity = Vector(0,-projectileSpeed)
					elseif npc.I1 == 3 then
						projectileVelocity = Vector(projectileSpeed,0)
					elseif npc.I1 == 4 then
						projectileVelocity = Vector(-projectileSpeed,0)
					end	
					
					local schut = ProjectileParams()
					schut.Scale = 2
					schut.Variant = 3
					schut.Color = Color(0.2,0.2,0.25,1,0,0,0)
					schut.FallingAccelModifier = -0.15
					
					npc:FireProjectiles(npc.Position + projectileVelocity, projectileVelocity, 0, schut)
					npc:PlaySound(317, 1.0, 0, false, 1.0)
				end	
				if sprite:IsFinished("Attack") then				
					npc.State = 3
					npc.StateFrame = math.random(40,70)
				end	
				npc:MultiplyFriction(0.75)
			end
		end
		
		
		if npc.I1 == 1 then
			npc.Position = Vector(npc.Position.X,tlPos.Y)
		elseif npc.I1 == 2 then
			npc.Position = Vector(npc.Position.X,brPos.Y)
		elseif npc.I1 == 3 then
			npc.Position = Vector(tlPos.X,npc.Position.Y)
		elseif npc.I1 == 4 then
			npc.Position = Vector(brPos.X,npc.Position.Y)
		end
	end
end
function BBB:DankDukie(npc)
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
				local newNPC = Isaac.Spawn(13, variantLatchFly, 0, npc.Position + Vector(0,13), Vector(0,3),npc)
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
function BBB:DankDukieTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
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
function BBB:MinistroII(npc)
	if (npc.Variant == variantMinistroII) then
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
end

function BBB:CustomTears(npc)
	if (npc.Variant == variantTearBubble) then
		local sprite = npc:GetSprite()
		npc:MultiplyFriction(0.9)
		if npc.State == 0 then
			BBB:TearBubbleInit(npc)
		else
			npc.StateFrame = npc.StateFrame + 1
			if npc.StateFrame > 30 then
				npc.StateFrame = 0
				local frame = sprite:GetFrame()
				
				if sprite:IsPlaying("RegularTear1") then				
					sprite:SetFrame("RegularTear2", frame)
					sprite:Play("RegularTear2", true)
					
				elseif sprite:IsPlaying("RegularTear2") then				
					sprite:SetFrame("RegularTear3", frame)
					sprite:Play("RegularTear3", true)
					
				elseif sprite:IsPlaying("RegularTear3") then				
					sprite:SetFrame("RegularTear4", frame)
					sprite:Play("RegularTear4", true)
					
				elseif sprite:IsPlaying("RegularTear4") then				
					sprite:SetFrame("RegularTear5", frame)
					sprite:Play("RegularTear5", true)
					
				elseif sprite:IsPlaying("RegularTear5") then				
					sprite:SetFrame("RegularTear6", frame)
					sprite:Play("RegularTear6", true)
					
				elseif sprite:IsPlaying("RegularTear6") then				
					sprite:SetFrame("RegularTear7", frame)
					sprite:Play("RegularTear7", true)
					
				elseif sprite:IsPlaying("RegularTear7") then				
					npc.I1 = 1
					sprite:SetFrame("RegularTear8", frame)
					sprite:Play("RegularTear8", true)
					
				elseif sprite:IsPlaying("RegularTear8") then				
					npc.I1 = 2
					sprite:SetFrame("RegularTear9", frame)
					sprite:Play("RegularTear9", true)
					
				elseif sprite:IsPlaying("RegularTear9") then				
					npc.I1 = 3
					sprite:SetFrame("RegularTear10", frame)
					sprite:Play("RegularTear10", true)
					
				elseif sprite:IsPlaying("RegularTear10") then				
					npc.I1 = 4
					sprite:SetFrame("RegularTear11", frame)
					sprite:Play("RegularTear11", true)
					
				elseif sprite:IsPlaying("RegularTear11") then				
					npc.I1 = 5
					sprite:SetFrame("RegularTear12", frame)
					sprite:Play("RegularTear12", true)
					
				elseif sprite:IsPlaying("RegularTear12") then				
					npc.I1 = 6
					sprite:SetFrame("RegularTear13", frame)
					sprite:Play("RegularTear13", true)
					
				elseif sprite:IsPlaying("RegularTear13") then
					local projectileCount = npc.I1
					local radius = 2 + (npc.I1)
					local scale = 0.2 + (npc.I1 * 0.1)
					local projectileVelocity = Vector(1,0)
					
					for i=0,projectileCount,1 do
						local schut = ProjectileParams()
						schut.Variant = 4
						schut.Scale = scale
						--schut.scale = math.random(10,20) / 10
						schut.FallingSpeedModifier = math.random(-6, 2)
						schut.FallingAccelModifier = 0.5
						local direction = projectileVelocity:Rotated(math.random(0,360))
						local speed = math.random(radius- 1,radius+1) * 0.5
						
						npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
					end	
					npc:PlaySound(178, 1.0, 0, false, 1.0)
					npc:Kill()
				end
				--npc:SetSize(10 + npc.I1, 1, 12)
				npc:SetSize(10 + npc.I1, Vector(1,1), 12)
			end
		end
	end
end
function BBB:TearBubbleInit(npc)
	local sprite = npc:GetSprite()

	npc.SpriteOffset = Vector(0,-16)
	npc.EntityCollisionClass = 2
	npc.State = 3
	npc.SplatColor = Color(0,0,0,0,0,0,0)
	
	if npc.I1 == 0 then
		sprite:Play("RegularTear6", true)
	elseif npc.I1 == 1 then
		sprite:Play("RegularTear7", true)
	elseif npc.I1 == 2 then
		sprite:Play("RegularTear8", true)
	elseif npc.I1 == 3 then
		sprite:Play("RegularTear9", true)
	elseif npc.I1 == 4 then
		sprite:Play("RegularTear10", true)
	elseif npc.I1 == 5 then
		sprite:Play("RegularTear11", true)
	elseif npc.I1 == 6 then
		sprite:Play("RegularTear12", true)
	else
		sprite:Play("RegularTear13", true)
	end
	
	npc:SetSize(10 + npc.I1, Vector(1,1), 12)
end
function BBB:CustomTearsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == variantTearBubble) then
		npc = npc:ToNPC()
		if (npc.HitPoints < dmg) then
			local projectileCount = npc.I1
			local radius = 2 + (npc.I1)
			local scale = 0.2 + (npc.I1 * 0.1)
			local projectileVelocity = Vector(1,0)
			
			for i=0,projectileCount,1 do
				local schut = ProjectileParams()
				schut.Variant = 4
				schut.Scale = scale
				--schut.scale = math.random(10,20) / 10
				schut.FallingSpeedModifier = math.random(-6, 2)
				schut.FallingAccelModifier = 0.5
				local direction = projectileVelocity:Rotated(math.random(0,360))
				local speed = math.random(radius- 1,radius+1) * 0.5
				
				npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
			end	
			npc:PlaySound(178, 1.0, 0, false, 1.0)
		end
	end
end
function BBB:CustomTearsPlayerCollision(npc, player)
	if (npc.Variant == variantTearBubble) then
		npc:Kill()
		local projectileCount = npc.I1
		local radius = 2 + (npc.I1)
		local scale = 0.2 + (npc.I1 * 0.1)
		local projectileVelocity = Vector(1,0)
		
		for i=0,projectileCount,1 do
			local schut = ProjectileParams()
			schut.Variant = 4
			schut.Scale = scale
			--schut.scale = math.random(10,20) / 10
			schut.FallingSpeedModifier = math.random(-6, 2)
			schut.FallingAccelModifier = 0.5
			local direction = projectileVelocity:Rotated(math.random(0,360))
			local speed = math.random(radius- 1,radius+1) * 0.5
			
			npc:FireProjectiles(npc.Position, direction * speed, 0, schut)
		end	
		npc:PlaySound(178, 1.0, 0, false, 1.0)
	else
		npc:Kill()
		npc:PlaySound(258, 1.0, 0, false, 1.0)
		Isaac.Spawn(1000, 12, 0, npc.Position + npc.SpriteOffset, Vector(0,0),npc)
	end
end
function BBB:PlayerCollision(player, npc, low)
	if (npc.Type == typeCustomTears) then
		BBB:CustomTearsPlayerCollision(npc:ToNPC(), player)
	end
end
function BBB:ProjectileUpdate(ent)
	if (ent.SpawnerType == typeModCreep and ent.SpawnerVariant == variantStickyCreep) then
		if (ent.FrameCount % 3 == 0) then				
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, ent.Position, Vector(0,0), ent):ToEffect()
			creep:Update()
			creep:SetTimeout(90)
		end
	end
end


function BBB:HorfAlts(npc)
	if (npc.Variant == 0) then
		if (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 3 and math.random(0,1) == 0) then
				npc:Morph(typeFlamingHorf, npc.Variant, npc.SubType, npc:GetChampionColorIdx())
			end
		end
	end
end
function BBB:DukieAlts(npc)
	if (npc.Variant == 0) then
		if (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 9 and math.random(0,1) == 0) then
				npc:Morph(typeDankDukie, npc.Variant, npc.SubType, npc:GetChampionColorIdx())
			end
		end
	end
end
function BBB:WallCreepAlts(npc)
	if (npc.Variant == 0) then
		if (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 6 and npc.HitPoints ~= 0 and math.random(0,1) == 0 ) then
				-- --Using the npc Hitpoints as a variable because, for some reason, despite being dependent on frame count this code will otherwise be called twice.
				npc.HitPoints = 0
				npc:Remove()
				
				local newNPC = Isaac.Spawn(typeDrownedCreep, npc.Variant, npc.SubType, npc.Position, npc.Velocity, npc)
				newNPC:ToNPC().I1 = npc.I1
			end
		end
	end
end


function FindNearbyEnemy(pointGet)
	local entities = Isaac.GetRoomEntities()
	local nearestEnt = nil
	local nearestDistance = 100000--Vector(1000,1000)
	for i = 1, #entities do
		if entities[ i ]:IsVulnerableEnemy( ) then
			if (pointGet:Distance(entities[i].Position) < nearestDistance) then
				nearestDistance = pointGet:Distance(entities[i].Position)
				nearestEnt = entities[i]
			end
		end
	end
	return nearestEnt
end

function BBB:debug_text()
	--Isaac.RenderScaledText(debugString, 100, 100, 0.5, 0.5, 255, 0, 0, 255)
	entinfo()
end
function entinfo()
	local debugMode = 0 --Isaac.GetPlayer(0):GetHearts()
	--debugMode 0 = Nothing
	--debugMode 1 = local ints
	--debugMode 2 = local vectors
	--debugMode 3 = types and variants
	--debugMode 4 = state and stateframes
	--debugMode 5 = children
	--debugMode 6 = parents
	--debugMode 7 = entity ref
	--debugMode 8 = target entity
	--debugMode 9 = target position
	--debugMode 10 = groupID
	--debugMode 11 = npc.GridCollisionClass
	--debugMode 12 = sprite color
	--debugMode 13 = sprite name
	--debugMode 14 = Position, Velocity
	--debugMode 15 = Friction
	--debugMode 16 = EntityCollisionClass
	--debugMode 17 = SpawnerEntity
	if (debugMode ~= 0) then
		local entities = Isaac.GetRoomEntities()
		for i = 1, #entities do
			if (debugMode == 1) then
				if (entities[i]:ToNPC() ~= nil) then--entities[ i ]:IsVulnerableEnemy( ) then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i]:ToNPC().I1 .. " " .. entities[i]:ToNPC().I2, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				end
			elseif (debugMode == 2) then
				if (entities[i]:ToNPC() ~= nil) then--entities[ i ]:IsVulnerableEnemy( ) then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText("[" .. math.floor(entities[i]:ToNPC().V1.X) .. "," .. math.floor(entities[i]:ToNPC().V1.Y) .. "] [" .. math.floor(entities[i]:ToNPC().V2.X) .. "," .. math.floor(entities[i]:ToNPC().V2.Y) .. "]", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				end
			elseif (debugMode == 3) then
				Isaac.RenderScaledText(entities[i].Type .. "." .. entities[i].Variant .. "." .. entities[i].SubType, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 0.5, 0.5, 155, 155, 155, 255)
			elseif (debugMode == 4) then
				if entities[ i ]:IsVulnerableEnemy( ) then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i]:ToNPC().State .. ":" .. entities[i]:ToNPC().StateFrame, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 0.5, 0.5, 155, 155, 155, 255)
				end
			elseif (debugMode == 5) then
				if entities[ i ]:IsVulnerableEnemy( ) and entities[i]:ToNPC().ChildNPC ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i]:ToNPC().ChildNPC.Type .. ":" .. entities[i]:ToNPC().ChildNPC.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				elseif entities[i].Child ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i].Child.Type .. ":" .. entities[i].Child.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				end
			elseif (debugMode == 6) then
				if entities[ i ]:IsVulnerableEnemy( ) and entities[i]:ToNPC().ParentNPC ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i]:ToNPC().ParentNPC.Type .. ":" .. entities[i]:ToNPC().ParentNPC.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				elseif entities[i].Parent ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderScaledText(entities[i].Parent.Type .. ":" .. entities[i].Parent.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				elseif entities[i].SpawnerEntity ~= nil then
					Isaac.RenderScaledText(entities[i].SpawnerEntity.Type .. ":" .. entities[i].SpawnerEntity.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				else
				--	Isaac.RenderScaledText("No parent ", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48,0.5,0.5, 155, 155, 155, 255)
				end
			elseif (debugMode == 7) then
				if entities[ i ]:IsVulnerableEnemy( ) and entities[i]:ToNPC().EntityRef ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderText(entities[i]:ToNPC().EntityRef.Type .. ":" .. entities[i]:ToNPC().EntityRef.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				else
					Isaac.RenderText("No entityref ", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				end
			elseif (debugMode == 8) then
				if entities[i].Target ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderText(entities[i].Target.Type .. ":" .. entities[i].Target.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				end
			elseif (debugMode == 9) then
				Isaac.RenderScaledText("[" .. math.floor(entities[i].TargetPosition.X) .. "," .. math.floor(entities[i].TargetPosition.Y) .. "]", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 0.5, 0.5, 155, 155, 155, 255)
			elseif (debugMode == 10) then
				if entities[ i ]:IsVulnerableEnemy( ) then
					Isaac.RenderText(entities[i]:ToNPC().GroupIdx, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				end
			elseif (debugMode == 11) then			
				Isaac.RenderText(entities[ i ].GridCollisionClass, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			elseif (debugMode == 12) then
				local sprite = entities[ i ]:GetSprite()
				local col = sprite.Color
				Isaac.RenderText( "[" .. (math.floor(col.R*100)/100) .. "," .. (math.floor(col.G*100)/100) .. "," .. (math.floor(col.B*100)/100) .. "," .. (math.floor(col.A*100)/100) .. "," .. (math.floor(col.RO*25500)/100) .. "," .. (math.floor(col.GO*25500)/100) .. "," .. (math.floor(col.BO*25500)/100) .. "]", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			elseif (debugMode == 13) then
				local sprite = entities[ i ]:GetSprite()
				Isaac.RenderText( sprite:GetFilename() , (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			
			elseif (debugMode == 14) then				
				Isaac.RenderText("[" .. (math.floor(entities[i].Position.X*100)/100) .. "," .. (math.floor(entities[i].Position.Y*100)/100) .. "] [" .. (math.floor(entities[i].Velocity.X*100)/100) .. "," .. (math.floor(entities[i].Velocity.Y*100)/100) .. "]", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			
			elseif (debugMode == 15) then
				Isaac.RenderText("" .. entities[i].Friction, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			
			elseif (debugMode == 16) then			
				Isaac.RenderText(entities[ i ].EntityCollisionClass, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
			
			elseif (debugMode == 17) then
				if entities[i].SpawnerEntity ~= nil then--if (entities[i].Target ~= nil) then
					Isaac.RenderText(entities[i].SpawnerEntity.Type .. ":" .. entities[i].SpawnerEntity.Variant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				else
					Isaac.RenderText(entities[i].SpawnerType .. ":" .. entities[i].SpawnerVariant, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				end
			end
		end
	end
end

BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.FlyVariants, 13);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.DipVariants, 217);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.SquirtVariants, 220);
BBB:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBB.SquirtVariantsTakeDamage, 220);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.Spiny, 276);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.MinistroII, 305);

BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.FlamingHorf, typeFlamingHorf);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.CreepVariants, typeModCreep);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.DankDukie, typeDankDukie);
BBB:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBB.DankDukieTakeDamage, typeDankDukie);


BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.HorfAlts, typeHorf);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.WallCreepAlts, typeWallCreep);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.WallCreepAlts, typeRageCreep);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.WallCreepAlts, typeBlindCreep);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.WallCreepAlts, typeTheThing);
BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.DukieAlts, typeDukie);



BBB:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBB.CustomTears, typeCustomTears);
BBB:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBB.CustomTearsTakeDamage, typeCustomTears);
BBB:AddCallback( ModCallbacks.MC_PRE_PLAYER_COLLISION, BBB.PlayerCollision);
BBB:AddCallback( ModCallbacks.MC_POST_PROJECTILE_UPDATE, BBB.ProjectileUpdate);

BBB:AddCallback( ModCallbacks.MC_POST_RENDER, BBB.debug_text);