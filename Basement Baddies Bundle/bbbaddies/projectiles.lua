function BBBaddiesMod:CustomTears(npc)
	if (npc.SpawnerType == BBBaddiesEntityType.ENTITY_CUSTOM_CREEP and (npc.SpawnerVariant == BBBaddiesEntityVariant.CREEP_STICKY or 
		(npc.SpawnerVariant == BBBaddiesEntityVariant.CREEP_CHIMERA and npc.Variant == BBBaddiesProjectileVariant.PROJECTILE_TAR))) then
		if (npc.FrameCount % 3 == 0) then				
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, npc.Position, Vector(0,0), npc):ToEffect()
			creep:Update()
			creep:SetTimeout(90)
		end
	end
	
	if (npc.Variant == BBBaddiesProjectileVariant.PROJECTILE_TAR) then	
		--I1 = size
		--StateFrame = range
		--V1.X = targetSpeed
		--V1.Y = bounceLimit
		
		local sprite = npc:GetSprite()
		if npc.State == 0 or npc.State == 1 or npc.State == 2 then
			npc.SpriteOffset = Vector(0,-16)
			npc.EntityCollisionClass = 1
			npc.State = 3
			npc.SplatColor = Color(0,0,0,0,0,0,0)--Color(0.725,0.81,1,1,0,0,0)
			
			if npc.I1 == 0 then
				sprite:Play("RegularTear4", true)
			elseif npc.I1 == 1 then
				sprite:Play("RegularTear5", true)
			elseif npc.I1 == 2 then
				sprite:Play("RegularTear6", true)
			elseif npc.I1 == 3 then
				sprite:Play("RegularTear7", true)
			elseif npc.I1 == 4 then
				sprite:Play("RegularTear8", true)
			elseif npc.I1 == 5 then
				sprite:Play("RegularTear9", true)
			elseif npc.I1 == 6 then
				sprite:Play("RegularTear10", true)
			elseif npc.I1 == 7 then
				sprite:Play("RegularTear11", true)
			elseif npc.I1 == 8 then
				sprite:Play("RegularTear12", true)
			else
				sprite:Play("RegularTear13", true)
			end
			
			npc:SetSize(6 + npc.I1, Vector(1,1), 12)
			npc.V2 = npc.Velocity
		end
		
		local bounce = false
		
		if npc.V2.X < 0 and npc.Velocity.X > 0 then bounce = true			
		elseif npc.V2.X > 0 and npc.Velocity.X < 0 then bounce = true end
		if npc.V2.Y < 0 and npc.Velocity.Y > 0 then bounce = true
		elseif npc.V2.Y > 0 and npc.Velocity.Y < 0 then bounce = true end
		
		if (bounce) then
			if npc.V1.Y > 0 then
				npc.V1 = Vector(npc.V1.X, npc.V1.Y - 1)
				npc.Velocity = npc.Velocity:Rotated(math.random(-30,30))				
				npc.StateFrame = 24
				
				-- npc.Velocity = npc.Velocity:Rotated(math.random(-30,30))
				-- local spread = math.random(10,25)
				-- for i=-1,1,2 do
					-- tarBall = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, BBBaddiesProjectileVariant.PROJECTILE_TAR, 0, npc.Position, npc.Velocity:Rotated(i * spread),npc.Parent)
					-- tarBall:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					-- tarBall:ToNPC().I1 = 3
					-- tarBall:ToNPC().V1 = Vector(6,0)
					-- tarBall:ToNPC().StateFrame = 20
					-- tarBall.Parent = npc
				-- end
				-- npc:Remove()
			else
				npc:Kill()
				npc:PlaySound(258, 1.0, 0, false, 1.0)
				Isaac.Spawn(1000, 12, 0, npc.Position, Vector(0,0),npc)
			end		
		end
		if npc.Velocity:Length() < npc.V1.X then 
			npc.Velocity = npc.Velocity:Normalized() * npc.V1.X
		end
		npc.V2 = npc.Velocity
		
		
		if (npc.SpriteOffset.Y >= 0) then
			npc:Kill()
			npc:PlaySound(258, 1.0, 0, false, 1.0)
			Isaac.Spawn(1000, 12, 0, npc.Position, Vector(0,0),npc)
		else
			npc.SpriteOffset = Vector(0,npc.SpriteOffset.Y + (16 / npc.StateFrame))
		end
	end
	if (npc.Variant == BBBaddiesProjectileVariant.PROJECTILE_BUBBLE) then
		local sprite = npc:GetSprite()
		npc:MultiplyFriction(0.9)
		if npc.State == 0 then
			BBBaddiesMod:TearBubbleInit(npc)
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
						if npc.SubType == 0 then schut.Variant = 4 end
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
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.CustomTears, BBBaddiesEntityType.ENTITY_CUSTOM_TEAR)

function BBBaddiesMod:TearBubbleInit(npc)
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

function BBBaddiesMod:CustomTearsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesProjectileVariant.PROJECTILE_BUBBLE) then
		npc = npc:ToNPC()
		if (npc.HitPoints < dmg) then
			local projectileCount = npc.I1
			local radius = 2 + (npc.I1)
			local scale = 0.2 + (npc.I1 * 0.1)
			local projectileVelocity = Vector(1,0)
			
			for i=0,projectileCount,1 do
				local schut = ProjectileParams()
				if npc.SubType == 0 then schut.Variant = 4 end
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
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.CustomTearsTakeDamage, BBBaddiesEntityType.ENTITY_CUSTOM_TEAR)

function BBBaddiesMod:CustomTearsPlayerCollision(npc, player)
	if (npc.Variant == BBBaddiesProjectileVariant.PROJECTILE_BUBBLE) then
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

--TO BE REPLACED
function BBBaddiesMod:PlayerCollision(player, npc, low)
	if (npc.Type == BBBaddiesEntityType.ENTITY_CUSTOM_TEAR) then
		BBBaddiesMod:CustomTearsPlayerCollision(npc:ToNPC(), player)
	end
end
BBBaddiesMod:AddCallback( ModCallbacks.MC_PRE_PLAYER_COLLISION, BBBaddiesMod.PlayerCollision)
--TO BE REPLACED

function BBBaddiesMod:ProjectileUpdate(ent)
	if (ent.SpawnerType == BBBaddiesEntityType.ENTITY_CUSTOM_CREEP and ent.SpawnerVariant == BBBaddiesEntityVariant.CREEP_STICKY) then
		if (ent.FrameCount % 3 == 0) then				
			local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_BLACK, 0, ent.Position, Vector(0,0), ent):ToEffect()
			creep:Update()
			creep:SetTimeout(90)
		end
	end
	if ((ent.SpawnerType == EntityType.ENTITY_LEAPER and ent.SpawnerVariant == BBBaddiesEntityVariant.LEAPER_BOUNCER) or
		(ent.SpawnerType == EntityType.ENTITY_DIP and ent.SpawnerVariant == BBBaddiesEntityVariant.DIP_DANK)) then
		if (ent.FrameCount <= 1) then				
			local sprite = ent:GetSprite()
			sprite:ReplaceSpritesheet(0, "gfx/ink_bullets.png")
			sprite:LoadGraphics()
		end
	end
end
BBBaddiesMod:AddCallback( ModCallbacks.MC_POST_PROJECTILE_UPDATE, BBBaddiesMod.ProjectileUpdate)