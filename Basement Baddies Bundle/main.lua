BBBaddiesMod = RegisterMod("basement baddies bundle", 1)

BBBaddiesEntityType = {
	ENTITY_CUSTOM_TEAR = Isaac.GetEntityTypeByName("Bubble Tear"),
	ENTITY_METEOR_MAW = Isaac.GetEntityTypeByName("Meteor Maw"),
	ENTITY_CUSTOM_CREEP = Isaac.GetEntityTypeByName("Drowned Creep"),
	ENTITY_DANK_DUKIE = Isaac.GetEntityTypeByName("Dank Dukie"),
	ENTITY_CUSTOM_GAPER = Isaac.GetEntityTypeByName("Murmur"),
	ENTITY_FAT_GLOBIN = Isaac.GetEntityTypeByName("Fat Globin"),
	ENTITY_CUSTOM_HIVE = Isaac.GetEntityTypeByName("Boilligan"),
	ENTITY_CUSTOM_BABY = Isaac.GetEntityTypeByName("Greediest Hanger")
}

BBBaddiesProjectileVariant = {
	PROJECTILE_BUBBLE = Isaac.GetEntityVariantByName("Bubble Tear"),
	PROJECTILE_TAR = Isaac.GetEntityVariantByName("Tar Tear"),
	PROJECTILE_BOIL = Isaac.GetEntityVariantByName("Boil Tear")
}

BBBaddiesEntityVariant = {
	FLY_LATCH = Isaac.GetEntityVariantByName("Latch Fly"),
	MINSTRO_II = Isaac.GetEntityVariantByName("Ministro II"),
	DIP_DROWNED = Isaac.GetEntityVariantByName("Drowned Dip"),
	DIP_DANK = Isaac.GetEntityVariantByName("Dank Dip"),
	SQUIRT_DROWNED = Isaac.GetEntityVariantByName("Drowned Squirt"),
	DINGA_DANK = Isaac.GetEntityVariantByName("Dank Dinga"),
	CREEP_DROWNED = Isaac.GetEntityVariantByName("Drowned Creep"),
	CREEP_STICKY = Isaac.GetEntityVariantByName("Sticky Creep"),
	CREEP_CHIMERA = Isaac.GetEntityVariantByName("Chimera Creep"),
	ROUNDY_SPINY = Isaac.GetEntityVariantByName("Spiny"),
	LEAPER_BOUNCER = Isaac.GetEntityVariantByName("Bouncer"),
	GAPER_MURMUR = Isaac.GetEntityVariantByName("Murmur"),
	GUSHER_GRIPE = Isaac.GetEntityVariantByName("Gripe"),
	FAT_GLOBIN_BLUBBER = Isaac.GetEntityVariantByName("Fat Globin Blubber"),
	FAT_GLOBIN_STACK = Isaac.GetEntityVariantByName("Fat Globin Stack"),
	HIVE_BOILLIGAN = Isaac.GetEntityVariantByName("Boilligan"),
	KEEPER_GREEDIEST = Isaac.GetEntityVariantByName("Greediest Keeper")
}

BBBaddiesEffectVariant = {
	DIARHEA_EXPLOSION = Isaac.GetEntityVariantByName("Diarhea Explosion")
}

require("bbbaddies.dank_dukie")
require("bbbaddies.dank_dinga")
require("bbbaddies.drowned_squirt")
require("bbbaddies.spiny")
require("bbbaddies.ministro_ii")
require("bbbaddies.meteor_maw")
require("bbbaddies.projectiles")
require("bbbaddies.creeps")
require("bbbaddies.hives")
require("bbbaddies.bouncer")
require("bbbaddies.gapers")
require("bbbaddies.gushers")
require("bbbaddies.fat_globin")

BBBaddiesDebugString = "Sorry Nothing"

--BBBaddiesInkEnemies = { {EntityType.ENTITY_LEAPER, BBBaddiesEntityVariant.LEAPER_BOUNCER} , {208, 0}, {29,0} }


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

function BBBaddiesMod:Lerp(a, b, weight)
	return a * (1 - weight) + b * weight
end

local function DistanceFromLine(point, lineStart, lineEnd)
	local dif = lineEnd - lineStart
    if (dif.X == 0) and (dif.Y == 0) then
        dif = point - lineStart
        return math.sqrt(dif.X * dif.X + dif.Y * dif.Y)
	else
		local t = ((point.X - lineStart.X) * dif.X + (point.Y - lineStart.Y) * dif.Y) / (dif.X * dif.X + dif.Y * dif.Y)
	
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

		return math.sqrt(dif.X * dif.X + dif.Y * dif.Y)
	end
end

function BBBaddiesMod:FlyVariants(npc)
	--for some reason the fly sfx doesn't want to work, so this is gonna' go ahead and be a fly variant to make it do so
	if (npc.Variant == BBBaddiesEntityVariant.FLY_LATCH) then 
		BBBaddiesMod:FlyLatch(npc)
	end
end
function BBBaddiesMod:DipVariants(npc)
	if (npc.Variant == BBBaddiesEntityVariant.DIP_DROWNED) then
		BBBaddiesMod:DrownedDip(npc)
	elseif (npc.SpawnerType == 220 and npc.SpawnerVariant == BBBaddiesEntityVariant.SQUIRT_DROWNED) then
		npc:Morph(217, BBBaddiesEntityVariant.DIP_DROWNED, npc.SubType, npc:GetChampionColorIdx())
	elseif (npc.FrameCount <= 1 and npc.Variant == 0) then
		if (npc.SpawnerType == 223 and npc.SpawnerVariant == BBBaddiesEntityVariant.DINGA_DANK) then
			npc:Morph(217, BBBaddiesEntityVariant.DIP_DANK, npc.SubType, npc:GetChampionColorIdx())
		elseif (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 9) then
				npc:Morph(217, BBBaddiesEntityVariant.DIP_DANK, npc.SubType, npc:GetChampionColorIdx())
			end
		end
	end
end
function BBBaddiesMod:DipVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesEntityVariant.DIP_DANK) then
		BBBaddiesMod:DankDipTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	end
end
function BBBaddiesMod:SquirtVariants(npc)
	if (npc.Variant == BBBaddiesEntityVariant.SQUIRT_DROWNED) then		
		BBBaddiesMod:DrownedSquirt(npc)
	elseif (npc.FrameCount <= 1 and npc.Variant == 0) then
		if (npc.SpawnerType == 223 and npc.SpawnerVariant == BBBaddiesEntityVariant.DINGA_DANK) then
			npc:Morph(220, 1, npc.SubType, npc:GetChampionColorIdx())
		end
	end
end
function BBBaddiesMod:SquirtVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesEntityVariant.SQUIRT_DROWNED) then
		toReturn = BBBaddiesMod:DrownedSquirtTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
		if toReturn ~= nil then
			return toReturn
		end
	end
end
function BBBaddiesMod:DingaVariants(npc)
	if (npc.Variant == BBBaddiesEntityVariant.DINGA_DANK) then
		BBBaddiesMod:DankDinga(npc)		
	elseif (npc.FrameCount == 0) then
		local backdrop = Game():GetRoom():GetBackdropType()
		if (backdrop == 9) then
			npc:Morph(223, BBBaddiesEntityVariant.DINGA_DANK, npc.SubType, npc:GetChampionColorIdx())
		end
	end
end
function BBBaddiesMod:LeaperVariants(npc)
	if (npc.Variant == BBBaddiesEntityVariant.LEAPER_BOUNCER) then
		BBBaddiesMod:Bouncer(npc)
	elseif (npc.FrameCount == 0) then
		local backdrop = Game():GetRoom():GetBackdropType()
		if (backdrop == 9) then
			npc:Morph(EntityType.ENTITY_LEAPER, BBBaddiesEntityVariant.LEAPER_BOUNCER, npc.SubType, npc:GetChampionColorIdx())
		end
	end
end
function BBBaddiesMod:GurgleVariants(npc)	
	if (npc.Variant == BBBaddiesEntityVariant.GURGLE_MURMUR) then
		BBBaddiesMod:Murmur(npc)
	end
end
function BBBaddiesMod:GurgleVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesEntityVariant.GURGLE_MURMUR) then
		toReturn = BBBaddiesMod:MurmurTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
		if toReturn ~= nil then
			return toReturn
		end
	end
end
function BBBaddiesMod:SplasherVariants(npc)	
	if (npc.Variant == BBBaddiesEntityVariant.SPLASHER_GRIPE) then
		BBBaddiesMod:Splasher(npc)
	end
end

function BBBaddiesMod:GlobinVariants(npc)
	if (npc.SubType == 1100) then
		if (npc.State == NpcState.STATE_IDLE) then
			local sprite = npc:GetSprite() 
			local frame = sprite:GetFrame()
			
			if (frame % 2 == 0 and frame < 20) then
				local projectileVelocity = Vector(1,0)
				local projectileSpeed = math.random(0,15) * 0.1
				local schut = ProjectileParams()
				
				schut.HeightModifier = 10
				schut.Variant = 4
				schut.FallingSpeedModifier = -30
				schut.FallingAccelModifier = 1
				schut.HeightModifier = 24
				
				npc:FireProjectiles(npc.Position, projectileVelocity:Rotated(math.random(0,360)) * projectileSpeed, 0, schut)
				npc:PlaySound(178, 1.0, 0, false, 1.0)
			end
			
			if (npc.Variant == 1 and npc.FrameCount % 8 == 0) then				
				local creep = Isaac.Spawn(1000, 25, 0, npc.Position, Vector(0,0), npc):ToEffect()
				creep:SetTimeout(90)
			end
		end		
	end
end


function BBBaddiesMod:BabyVariants(npc)
	local sprite = npc:GetSprite()
	if (npc.State == 0) then
		if (npc.Variant == 0) then
			local fly = Isaac.Spawn(96, 0, 0, npc.Position, Vector(0,0), npc)
			fly.Parent = npc
			fly:ToNPC().StateFrame = 6
		end
		npc.GridCollisionClass = 3
		npc.State = 3
	elseif (npc.State == 3) then
		npc:GetSprite():Play("Move", true)
		npc.State = 4
	elseif (npc.State == NpcState.STATE_JUMP) then
		if (sprite:IsEventTriggered("Invisible")) then
			npc.Visible = false
		elseif sprite:IsFinished("Vanish") then
			npc.EntityCollisionClass = 0			
			local room = Game():GetRoom()
			local tlPos = room:GetTopLeftPos()
			local brPos = room:GetBottomRightPos()
			
			local newPos = Vector(math.random(tlPos.X,brPos.X),math.random(tlPos.Y,brPos.Y))
			
			local playerOffset = Game():GetPlayer(0).Position - npc.Position
			if (playerOffset:Length() > 64) then
				npc.Position = newPos
				npc.Velocity = Vector(0,0)
				npc.Visible = true
				sprite:Play("Vanish2",true)
				npc.State = NpcState.STATE_STOMP
			end
		end
	elseif (npc.State == NpcState.STATE_STOMP) then
		if sprite:IsFinished("Vanish2") then
			sprite:Play("Move",true)
			npc.EntityCollisionClass = 4
			npc.State = 4
		end
	end
	
	if (npc.Variant == 0) then
		local room = Game():GetRoom()
		npc.Target = npc:GetPlayerTarget()
		npc.TargetPosition = npc.Target.Position
		local targetOffset = npc.TargetPosition - npc.Position
		local targetDirection = targetOffset:Normalized()
		
		if (npc.State == NpcState.STATE_ATTACK ) then
			if (sprite:IsEventTriggered("Shoot")) then
				local projectileVelocity = targetOffset:Normalized()
				local schut = ProjectileParams()
				schut.BulletFlags = ProjectileFlags.GREED 
					
				for i=-1,1,1 do	
					local projectileSpeed = 7
					if (i == 0) then projectileSpeed = 8 end
					npc:FireProjectiles(npc.Position, projectileVelocity:Rotated(i * 15) * projectileSpeed, 0, schut)
				end
				npc:PlaySound(178, 1.0, 0, false, 1.0)
			elseif sprite:IsFinished("Attack") then
				sprite:Play("Move",true)
				npc.State = 4
			end
		else			
			npc.Velocity = npc.Velocity + (targetDirection * 0.1)
			
			if npc.StateFrame >= 20 then
				if math.random(0,6) == 0 then				
					sprite:Play("Attack",true)
					npc.State = NpcState.STATE_ATTACK
					npc.StateFrame = -10
				else
					npc.StateFrame = 15
				end
			else
				npc.StateFrame = npc.StateFrame + 1
			end
		end
		npc:MultiplyFriction(0.95)
	end	
	
	--if (npc.Velocity:Length() > 1) then npc.Velocity = npc.Velocity:Normalized() * 0.5 end
end
function BBBaddiesMod:BabyVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == 0) then
		toReturn = BBBaddiesMod:GreediestTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
		if toReturn ~= nil then
			return toReturn
		end
	end
end

BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.BabyVariants, BBBaddiesEntityType.ENTITY_CUSTOM_BABY)


function BBBaddiesMod:KeeperVariantsTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
	if (npc.Variant == BBBaddiesEntityVariant.KEEPER_GREEDIEST) then
		toReturn = BBBaddiesMod:GreediestTakeDamage(npc, dmg, dmgType, dmgSrc, dmgCountDown)
		if toReturn ~= nil then
			return toReturn
		end
	end
end
function BBBaddiesMod:GreediestTakeDamage(ent, dmg, dmgType, dmgSrc, dmgCountDown)	
	local npc = ent:ToNPC()			
	npc.I1 = npc.I1 + 1
	local coin = Isaac.Spawn(5, 20, 0, npc.Position, Vector(0,0), npc)
	
	if (npc.I1 > 5) then
		if (npc.I1 > 20 or math.random(0,10) == 0) then
			npc.I2 = 1
			npc:Kill()
			local coinCount = math.random(2,4)
			local coinVelocity = Vector(1,0)
			for i=0,coinCount,1 do
				Isaac.Spawn(5, 20, 0, npc.Position, coinVelocity:Rotated(math.random(0,360)), npc)
			end
			npc:PlaySound(141, 1.0, 0, false, 1.0)
		end
	end
end
function BBBaddiesMod:GreediestDie(npc)
	if (npc.I2 == 0) then
		local item = Isaac.Spawn(5, 100, CollectibleType.COLLECTIBLE_DOLLAR, npc.Position, Vector(0,0), npc)
		npc.I2 = 1
	end
end 



function BBBaddiesMod:RoundyVariants(npc)
	if npc.Variant == BBBaddiesEntityVariant.ROUNDY_SPINY then
		BBBaddiesMod:Spiny(npc)
	end
end
function BBBaddiesMod:MinistroVariants(npc)
	if (npc.Variant == BBBaddiesEntityVariant.MINSTRO_II) then
		BBBaddiesMod:MinistroII(npc)
	end
end


-- function BBBaddiesMod:HorfAlts(npc)
	-- if (npc.Variant == 0) then
		-- if (npc.FrameCount == 0) then
			-- local backdrop = Game():GetRoom():GetBackdropType()
			-- if (backdrop == 3 and math.random(0,1) == 0) then
				-- npc:Morph(BBBaddiesEntityType.ENTITY_METEOR_MAW, npc.Variant, npc.SubType, npc:GetChampionColorIdx())
			-- end
		-- end
	-- end
-- end
function BBBaddiesMod:DukieAlts(npc)
	if (npc.Variant == 0) then
		if (npc.FrameCount == 0) then
			local backdrop = Game():GetRoom():GetBackdropType()
			if (backdrop == 9 and math.random(0,1) == 0) then
				npc:Morph(BBBaddiesEntityType.ENTITY_DANK_DUKIE, npc.Variant, npc.SubType, npc:GetChampionColorIdx())
			end
		end
	end
end
function BBBaddiesMod:WallCreepAlts(npc)
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



function BBBaddiesMod:PostEntityRemove(ent)
	if (ent.Type == EntityType.ENTITY_PROJECTILE) then
		BBBaddiesMod:PostProjectileRemove(ent)
	elseif ((ent.Type == EntityType.ENTITY_KEEPER and ent.Variant == BBBaddiesEntityVariant.KEEPER_GREEDIEST) or
		(ent.Type == BBBaddiesEntityType.ENTITY_CUSTOM_BABY and ent.Variant == 0)) then
		BBBaddiesMod:GreediestDie(ent:ToNPC())
	end
end
-- function BBBaddiesMod:PostNpcDeath(npc)
	-- BBBaddiesDebugString = "PostNpcDeath"
	-- if ((npc.Type == EntityType.ENTITY_KEEPER and npc.Variant == BBBaddiesEntityVariant.KEEPER_GREEDIEST) or
		-- (npc.Type == EntityType.ENTITY_HANGER and npc.Variant == BBBaddiesEntityVariant.HANGER_GREEDIEST)) then
		-- BBBaddiesMod:GreediestDie(npc)
	-- end
-- end
BBBaddiesMod:AddCallback( ModCallbacks.MC_POST_ENTITY_REMOVE, BBBaddiesMod.PostEntityRemove)
BBBaddiesMod:AddCallback( ModCallbacks.MC_POST_NPC_DEATH, BBBaddiesMod.PostEntityRemove)



function BBBaddiesMod:debug_text()
	--Isaac.RenderScaledText(BBBaddiesDebugString, 100, 100, 0.5, 0.5, 255, 0, 0, 255)
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
	--debugMode 18 = GroupIdx
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
				if (entities[ i ]:ToNPC() ~= nil) then--if (entities[i].Target ~= nil) then
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
				
			elseif (debugMode == 18) then
				if entities[i]:ToNPC() ~= nil then
					Isaac.RenderText(entities[i]:ToNPC().GroupIdx, (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 155, 155, 155, 255)
				end
				
			elseif (debugMode == 19) then
				Isaac.RenderScaledText("[" .. entities[i].PositionOffset.X .. "," .. entities[i].PositionOffset.Y .. "]", (entities[i].Position.X * 0.65) + 24, (entities[i].Position.Y * 0.65) - 48, 0.5, 0.5, 155, 155, 155, 255)
				
			end
		end
	end
end

BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.FlyVariants, EntityType.ENTITY_FLY)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.DipVariants, EntityType.ENTITY_DIP)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.DipVariantsTakeDamage, EntityType.ENTITY_DIP)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.SquirtVariants, EntityType.ENTITY_SQUIRT)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.SquirtVariantsTakeDamage, EntityType.ENTITY_SQUIRT)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.RoundyVariants, EntityType.ENTITY_ROUNDY)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.MinistroVariants, EntityType.ENTITY_MINISTRO)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.DingaVariants, EntityType.ENTITY_DINGA)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.LeaperVariants, EntityType.ENTITY_LEAPER)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.GurgleVariants, EntityType.ENTITY_GURGLE)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.GurgleVariantsTakeDamage, EntityType.ENTITY_GURGLE)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.SplasherVariants, EntityType.ENTITY_SPLASHER)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.GlobinVariants, EntityType.ENTITY_GLOBIN)

BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.KeeperVariantsTakeDamage, EntityType.ENTITY_KEEPER)
BBBaddiesMod:AddCallback( ModCallbacks.MC_ENTITY_TAKE_DMG, BBBaddiesMod.BabyVariantsTakeDamage, BBBaddiesEntityType.ENTITY_CUSTOM_BABY)



BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.HorfAlts, EntityType.ENTITY_HORF)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.WallCreepAlts, EntityType.ENTITY_WALL_CREEP)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.WallCreepAlts, EntityType.ENTITY_RAGE_CREEP)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.WallCreepAlts, EntityType.ENTITY_BLIND_CREEP)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.WallCreepAlts, EntityType.ENTITY_THE_THING)
BBBaddiesMod:AddCallback( ModCallbacks.MC_NPC_UPDATE, BBBaddiesMod.DukieAlts, EntityType.ENTITY_DUKIE)


BBBaddiesMod:AddCallback( ModCallbacks.MC_POST_RENDER, BBBaddiesMod.debug_text)