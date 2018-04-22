function BBBaddiesMod:DrownedDip(npc)
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
		
		
		local sprite = npc:GetSprite()
		if (npc.Scale < 0.5 and npc.State ~= NpcState.STATE_UNIQUE_DEATH) then
			-- if (math.random(0,1) == 0) then
				npc.State = NpcState.STATE_UNIQUE_DEATH
				sprite:Play("Disappear")
			-- else			
				-- npc:Remove()
				
				-- npc:PlaySound(237, 0.5, 0, false, 1.0)
				-- local plop = Isaac.Spawn(EntityType.ENTITY_EFFECT, BBBaddiesEffectVariant.DIARHEA_EXPLOSION, 0, npc.Position + (npc.Velocity * 0.5), Vector(0,0), npc):ToEffect()
			-- end
		end	
		
		if sprite:IsFinished("Disappear") then
			npc:Remove()
		end
	end
end

function BBBaddiesMod:DrownedSquirt(npc)
	if (npc:GetData().creepPos == nil) then
		npc:GetData().creepPos = { {npc.Position, npc.FrameCount}, {npc.Position, npc.FrameCount} }
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
	
	--BBBaddiesdebugString = "#creepPos:" .. #npc:GetData().creepPos
	for i, dipCreep in ipairs(npc:GetData().creepPos) do
		local creepPosition = dipCreep[1]
		local creepTime = dipCreep[2]
		
		if (npc.FrameCount > creepTime + 45) then
			table.remove(npc:GetData().creepPos,i)
			
		elseif ((creepPosition - npc.Position):Length() > 32 and math.random(0,96) == 0) then
			local offset = Vector(1,0):Rotated(math.random(0,360)) * math.random(0,8)
			local dip = Isaac.Spawn(217, BBBaddiesEntityVariant.DIP_DROWNED, 0, creepPosition + offset, Vector(0,0), npc)
			dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
			dip:Update()
			dip:ToNPC().State = 2
			dip:GetSprite():Play("Appear", true)
		end
	end
end
function BBBaddiesMod:DrownedSquirtTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.HitPoints < dmg) then
		for i=0,1,1 do
			local offset = Vector(1,0):Rotated(math.random(0,360)) * math.random(0,8)
			local dip = Isaac.Spawn(217, BBBaddiesEntityVariant.DIP_DROWNED, 0, npc.Position + offset, Vector(0,0), npc)
			dip:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		end
	end
end