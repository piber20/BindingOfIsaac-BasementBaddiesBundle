function BBBaddiesMod:DankDinga(npc)
	if (npc.FrameCount % 16 == 0) then
		local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
		creep:Update()
		local anim = "0" .. math.random(1,6)
		creep:SetSize(32, Vector(1,1),0)
		creep:GetSprite():SetFrame("BigBlood" .. anim, 2)
		creep:SetTimeout(120)
	end
	if (npc.State == 8 and npc.StateFrame == 32) then
		local creep = Isaac.Spawn(1000, 26, 0, npc.Position, Vector(0,0), npc):ToEffect()
		creep:Update()
		local anim = "0" .. math.random(1,6)
		creep:SetSize(64, Vector(1,1),0)
		creep:GetSprite():SetFrame("BiggestBlood" .. anim, 2)
		creep:SetTimeout(240)
	end
end

function BBBaddiesMod:DankDipTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.HitPoints < dmg) then		
		npc = npc:ToNPC()
		local schut = ProjectileParams()
		schut.HeightModifier = 16
		schut.Scale = 0.8
		schut.Variant = 3
		schut.Color = Color(0.2,0.2,0.25,1,0,0,0)
		
		
		local projectileVelocity = Vector(0,1)
		projectileVelocity = projectileVelocity:Rotated(45)
		for i=0,3,1 do
			npc:FireProjectiles(npc.Position, projectileVelocity:Rotated(i*90) * 8, 0, schut)
		end
	end
end