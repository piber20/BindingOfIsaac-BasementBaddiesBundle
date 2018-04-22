function BBBaddiesMod:CreepVariants(npc)
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
		
		if (npc.Variant == BBBaddiesEntityVariant.CREEP_STICKY) then moveSpeed = 4 end
		if (npc.Variant == BBBaddiesEntityVariant.CREEP_CHIMERA) then 
			if npc.SubType == 1 then moveSpeed = 5
			elseif npc.SubType == 3 then 
				moveSpeed = 1
				targetPlayer = false
			elseif npc.SubType == 5 then moveSpeed = 4 end
		end
		
		if targetPlayer then
			npc.Target = npc:GetPlayerTarget()
			npc.TargetPosition = npc.Target.Position
		else
			if npc.FrameCount % 32 == 0 and math.random(0,1) == 0 then
				local targetX = tlPos.X
				local targetY = tlPos.Y
				
				if math.random(0,1) == 0 then 
					targetX = brPos.X
					targetY = brPos.Y
				end
				npc.TargetPosition = Vector(targetX,targetY)
			end
		end
		
		local targetOffset = (npc.TargetPosition - npc.Position)
		local sprite = npc:GetSprite()
		
		if npc.State == 3 then
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
			
			npc.StateFrame = npc.StateFrame - 1
			if npc.StateFrame <= 0 then
				--Check that the Creep is on Screen
				local room = Game():GetRoom()
				local screenPos = room:WorldToScreenPosition(npc.Position)
				
				if screenPos.Y > 0 and screenPos.Y < 272 then				
					if (npc.Variant == BBBaddiesEntityVariant.CREEP_CHIMERA) then
						if (npc.SubType == 0 or npc.I2 <= 0) then
							npc.State = 9
							sprite:Play("Roll Down",true)
							sprite.PlaybackSpeed = 1
						else
							npc.State = 8
							npc.I2 = npc.I2 - 1
							sprite:Play("Attack",true)
							sprite.PlaybackSpeed = 1
						end
					else
						npc.State = 8
						sprite:Play("Attack",true)
						sprite.PlaybackSpeed = 1
					end
				end				
			end
		end
		
		if (npc.Variant == BBBaddiesEntityVariant.CREEP_DROWNED) then		
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
						
					local newNPC = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, BBBaddiesProjectileVariant.PROJECTILE_BUBBLE, 0, npc.Position + projectileVelocity, projectileVelocity, npc)
					newNPC:ToNPC().I1 = 3
					newNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					BBBaddiesMod:TearBubbleInit(newNPC:ToNPC())
					npc:PlaySound(317, 1.0, 0, false, 1.0)	
				end	
				if sprite:IsFinished("Attack") then				
					npc.State = 3
					npc.StateFrame = math.random(40,70)
				end	
				npc:MultiplyFriction(0.75)
			end
		end
		if (npc.Variant == BBBaddiesEntityVariant.CREEP_STICKY) then
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
					
					-- local schut = ProjectileParams()
					-- schut.Scale = 2
					-- schut.Variant = 3
					-- schut.Color = Color(0.2,0.2,0.25,1,0,0,0)
					-- schut.FallingAccelModifier = -0.15
					
					-- npc:FireProjectiles(npc.Position + projectileVelocity, projectileVelocity, 0, schut)		
					
					projectileVelocity = projectileVelocity:Rotated(math.random(-10,10))
					tarBall = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, BBBaddiesProjectileVariant.PROJECTILE_TAR, 0, npc.Position + projectileVelocity, projectileVelocity,npc)
					tarBall:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
					tarBall:ToNPC().I1 = 5
					tarBall:ToNPC().V1 = Vector(projectileSpeed,1)
					tarBall:ToNPC().StateFrame = 150
					tarBall.Parent = npc
					
					npc:PlaySound(317, 1.0, 0, false, 1.0)
				end	
				if sprite:IsFinished("Attack") then				
					npc.State = 3
					npc.StateFrame = math.random(40,70)
				end	
				npc:MultiplyFriction(0.75)
			end
		end
		if (npc.Variant == BBBaddiesEntityVariant.CREEP_CHIMERA) then
			--SubType:0 - Default
			--SubType:1 - Wall
			--SubType:2 - Rage
			--SubType:3 - Blind
			--SubType:4 - Drowned
			--SubType:5 - Sticky
			if npc.State == 8 then
				if sprite:IsEventTriggered("Fire") then
					if npc.SubType == 1 then --Wall
						local projectileVelocity
					
						local projectileSpeed = 8
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
						--schut.HeightModifier = 20
						--schut.FallingSpeedModifier = 0.5
						--schut.FallingAccelModifier = -0.15
						
						npc:FireProjectiles(npc.Position + (projectileVelocity * 0.2), projectileVelocity, 0, schut)
						if sprite:GetFrame() == 10 then
							npc:PlaySound(317, 1.0, 0, false, 1.0)
						end
					end
					if npc.SubType == 2 then --Rage					
						local laserDirection
						local laserOffset = Vector(0,0)
						
						if npc.I1 == 1 then
							laserDirection = Vector(0,1)
						elseif npc.I1 == 2 then
							laserDirection = Vector(0,-1)
						elseif npc.I1 == 3 then
							laserDirection = Vector(1,0)
							laserOffset = Vector(0,-16)
						elseif npc.I1 == 4 then
							laserDirection = Vector(-1,0)
							laserOffset = Vector(0,-16)
						end			
						
						local laser = EntityLaser.ShootAngle(1, npc.Position + laserDirection + laserOffset, laserDirection:GetAngleDegrees(), 46, Vector(0,0), npc)
						laser.DepthOffset = 24
					end
					if npc.SubType == 3 then --Blind
						local projectileVelocity
					
						if npc.I1 == 1 then
							projectileVelocity = Vector(0,1)
						elseif npc.I1 == 2 then
							projectileVelocity = Vector(0,-1)
						elseif npc.I1 == 3 then
							projectileVelocity = Vector(1,0)
						elseif npc.I1 == 4 then
							projectileVelocity = Vector(-1,0)
						end	
						
						local schut = ProjectileParams()
						--schut.HeightModifier = 20
						--schut.FallingSpeedModifier = 0.5
						schut.FallingAccelModifier = -0.065
						
						npc:FireProjectiles(npc.Position + projectileVelocity * 3, projectileVelocity * 9, 0, schut)
						npc:FireProjectiles(npc.Position + projectileVelocity * 3, projectileVelocity:Rotated(15) * 8, 0, schut)
						npc:FireProjectiles(npc.Position + projectileVelocity * 3, projectileVelocity:Rotated(-15) * 8, 0, schut)
						npc:PlaySound(317, 1.0, 0, false, 1.0)
					end
					if npc.SubType == 4 then --Drowned
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
							
						local newNPC = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, BBBaddiesProjectileVariant.PROJECTILE_BUBBLE, 1, npc.Position + projectileVelocity, projectileVelocity, npc)
						newNPC:ToNPC().I1 = 3
						newNPC:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						newNPC.Parent = npc
						BBBaddiesMod:TearBubbleInit(newNPC:ToNPC())
						npc:PlaySound(317, 1.0, 0, false, 1.0)
					end
					if npc.SubType == 5 then --Sticky
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
						
						projectileVelocity = projectileVelocity:Rotated(math.random(-10,10))
						tarBall = Isaac.Spawn(BBBaddiesEntityType.ENTITY_CUSTOM_TEAR, BBBaddiesProjectileVariant.PROJECTILE_TAR, 0, npc.Position + projectileVelocity, projectileVelocity,npc)
						tarBall:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
						tarBall:ToNPC().I1 = 5
						tarBall:ToNPC().V1 = Vector(projectileSpeed,1)
						tarBall:ToNPC().StateFrame = 150
						tarBall.Parent = npc
						
						npc:PlaySound(317, 1.0, 0, false, 1.0)
					end					
				end	
				if sprite:IsFinished("Attack") then				
					npc.State = 3
					npc.StateFrame = math.random(40,70)
				end
				npc:MultiplyFriction(0.75)
				if npc.SubType == 2 then
					npc:MultiplyFriction(0.25)
				end
			end
			if npc.State == 9 then				
				if sprite:IsFinished("Roll Down") then		
					local newSubtype = math.random(1,5)
					while newSubtype == npc.SubType do
						newSubtype = math.random(1,5)
					end					
					npc.SubType = newSubtype
					
					npc.I2 = math.random(2,3)
					
					
					
					local newAnim = ""
					if npc.SubType == 1 then
						newAnim = "gfx/chimera_creep_wall_form.anm2"
					elseif npc.SubType == 2 then
						newAnim = "gfx/chimera_creep_rage_form.anm2"
						npc.I2 = math.random(1,2)
					elseif npc.SubType == 3 then
						newAnim = "gfx/chimera_creep_blind_form.anm2"
						local targetX = tlPos.X
						local targetY = tlPos.Y
						
						if math.random(0,1) == 0 then 
							targetX = brPos.X
							targetY = brPos.Y
						end
						npc.TargetPosition = Vector(targetX,targetY)
					elseif npc.SubType == 4 then
						newAnim = "gfx/chimera_creep_drowned_form.anm2"
					elseif npc.SubType == 5 then
						newAnim = "gfx/chimera_creep_sticky_form.anm2"
					end
					
					sprite:Load(newAnim,true)
					sprite:Play("Roll Up", true)
				elseif sprite:IsFinished("Roll Up") then				
					npc.State = 3
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
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.CreepVariants, BBBaddiesEntityType.ENTITY_CUSTOM_CREEP)