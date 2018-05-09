UniqueAfterbirthFloorEnemiesMod = RegisterMod("Unique AB Floor Sprites", 1)

--load piber20helper
local _, err = pcall(require, "piber20helper")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(err)
end

function UniqueAfterbirthFloorEnemiesMod:getData(entity)
	local data = entity:GetData()
	if data.UniqueABFloorSprites == nil then
		data.UniqueABFloorSprites = {}
	end
	return data.UniqueABFloorSprites
end

function UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, variant, subtype, layer, flamingSpritesheet, floodedSpritesheet, dankSpritesheet, scarredSpritesheet)
	local frameCount = entity.FrameCount
	
	local thisType = entity.Type
	local thisVariant = entity.Variant
	local thisSubType = entity.SubType
	
	local data = UniqueAfterbirthFloorEnemiesMod:getData(entity)
	if data.LastType == nil then
		data.LastType = thisType
	end
	if data.LastVariant == nil then
		data.LastVariant = thisVariant
	end
	if data.LastSubType == nil then
		data.LastSubType = thisSubType
	end
	if data.entityTypesChanged == nil then
		data.entityTypesChanged = frameCount
	end
	
	if data.LastType ~= thisType then
		data.entityTypesChanged = frameCount
	end
	if data.LastVariant ~= thisVariant then
		data.entityTypesChanged = frameCount
	end
	if data.LastSubType ~= thisSubType then
		data.entityTypesChanged = frameCount
	end
	
	data.LastType = thisType
	data.LastVariant = thisVariant
	data.LastSubType = thisSubType
	
	if frameCount <= 1 or frameCount == data.entityTypesChanged or frameCount == (data.entityTypesChanged + 1) then
		if variant == nil then
			variant = -1
		end
		if thisVariant == variant or variant == -1 then
			if subtype == nil then
				subtype = -1
			end
			if thisSubType == subtype or subtype == -1 then
				local backdrop = piber20HelperMod:getCurrentBackdrop()
				local spritesheet = nil
				if backdrop == piber20HelperBackdrop.BURNING_BASEMENT then
					spritesheet = flamingSpritesheet
				elseif backdrop == piber20HelperBackdrop.FLOODED_CAVES then
					spritesheet = floodedSpritesheet
				elseif backdrop == piber20HelperBackdrop.DANK_DEPTHS then
					spritesheet = dankSpritesheet
				elseif backdrop == piber20HelperBackdrop.SCARRED_WOMB then
					spritesheet = scarredSpritesheet
				end
				if spritesheet ~= nil then
					local sprite = entity:GetSprite()
					if layer == nil then
						layer = 0
					end
					if layer >= 0 then
						sprite:ReplaceSpritesheet(layer, spritesheet) 
						sprite:LoadGraphics()
					else
						sprite:Load(spritesheet, true)
						sprite:Play(sprite:GetDefaultAnimation(), false)
					end
				end
			end
		end
	end
end

function UniqueAfterbirthFloorEnemiesMod:onBloodProjectileUpdate(entity)
	local spawnerType = entity.SpawnerType
	local spawnerVariant = entity.SpawnerVariant
	if spawnerType ~= 0 then
		if spawnerType ~= EntityType.ENTITY_FIREPLACE and spawnerType ~= EntityType.ENTITY_STONEHEAD and spawnerType ~= EntityType.ENTITY_POOTER and spawnerType ~= EntityType.ENTITY_SUCKER and spawnerType ~= EntityType.ENTITY_BOIL and spawnerType ~= EntityType.ENTITY_WALKINGBOIL and spawnerType ~= EntityType.ENTITY_HOST and spawnerType ~= EntityType.ENTITY_MOBILE_HOST and spawnerType ~= EntityType.ENTITY_FLESH_MOBILE_HOST and spawnerType ~= EntityType.ENTITY_CONSTANT_STONE_SHOOTER then
			if spawnerType ~= EntityType.ENTITY_BOOMFLY or spawnerType == EntityType.ENTITY_BOOMFLY and spawnerVariant ~= 1 then
				local backdrop = piber20HelperMod:getCurrentBackdrop()
				if backdrop == piber20HelperBackdrop.FLOODED_CAVES then
					UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, ProjectileVariant.PROJECTILE_NORMAL, -1, 0, nil, "gfx/enemybullets_flooded.png", nil, nil)
					local data = UniqueAfterbirthFloorEnemiesMod:getData(entity)
					data.isFloodedProjectile = true
				end
			end
		end
	end
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, UniqueAfterbirthFloorEnemiesMod.onBloodProjectileUpdate, ProjectileVariant.PROJECTILE_NORMAL)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, UniqueAfterbirthFloorEnemiesMod.onBloodProjectileUpdate, ProjectileVariant.PROJECTILE_NORMAL)

function UniqueAfterbirthFloorEnemiesMod:onProjectileRemove(entity)
	if entity.Variant == ProjectileVariant.PROJECTILE_NORMAL then
		local data = UniqueAfterbirthFloorEnemiesMod:getData(entity)
		if data.isFloodedProjectile then
			for _, poof in pairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BULLET_POOF, -1, false, false)) do
				if (poof.Position - entity.Position):Length() < 5 then
					UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(poof, EffectVariant.BULLET_POOF, -1, 0, nil, "gfx/effects/effect_003_bloodtear_flooded.png", nil, nil)
				end
			end
		end
	end
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, UniqueAfterbirthFloorEnemiesMod.onProjectileRemove, EntityType.ENTITY_PROJECTILE)

function UniqueAfterbirthFloorEnemiesMod:onGaperUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, "gfx/monsters/flaming/singed_frowning_gaper.png", nil, nil, nil) --frowning
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 1, "gfx/monsters/afterbirth/010.002_flaminggaper.png", nil, nil, nil) --regular
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onGaperUpdate, EntityType.ENTITY_GAPER)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onGaperUpdate, EntityType.ENTITY_GAPER)

function UniqueAfterbirthFloorEnemiesMod:onHorfUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, "gfx/monsters/flaming/singed_horf.png", nil, nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onHorfUpdate, EntityType.ENTITY_HORF)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onHorfUpdate, EntityType.ENTITY_HORF)

function UniqueAfterbirthFloorEnemiesMod:onCyclopiaUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, "gfx/monsters/flaming/singed_cyclopia.png", nil, nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onCyclopiaUpdate, EntityType.ENTITY_CYCLOPIA)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onCyclopiaUpdate, EntityType.ENTITY_CYCLOPIA)

function UniqueAfterbirthFloorEnemiesMod:onFattyUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, "gfx/monsters/afterbirth/207.002_flamingfatty.png", "gfx/monsters/flooded/drowned_monster_207_fatty.png", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, "gfx/monsters/afterbirth/207.002_flamingfatty.png", "gfx/monsters/flooded/drowned_monster_207_fatty.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onFattyUpdate, EntityType.ENTITY_FATTY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onFattyUpdate, EntityType.ENTITY_FATTY)

function UniqueAfterbirthFloorEnemiesMod:onCrazyLongLegsUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_long_legs.png", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 0, nil, "gfx/monsters/flooded/drowned_long_legs_small.png", nil, nil) --small
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onCrazyLongLegsUpdate, EntityType.ENTITY_CRAZY_LONG_LEGS)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onCrazyLongLegsUpdate, EntityType.ENTITY_CRAZY_LONG_LEGS)

function UniqueAfterbirthFloorEnemiesMod:onRedGhostUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, -1, nil, nil, nil, "gfx/scarred_ghost.anm2")
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onRedGhostUpdate, EntityType.ENTITY_RED_GHOST)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onRedGhostUpdate, EntityType.ENTITY_RED_GHOST)

function UniqueAfterbirthFloorEnemiesMod:onFleshDeathsHeadUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, nil, nil, "gfx/monsters/scarred/scarred_deaths_head.png")
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onFleshDeathsHeadUpdate, EntityType.ENTITY_FLESH_DEATHS_HEAD)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onFleshDeathsHeadUpdate, EntityType.ENTITY_FLESH_DEATHS_HEAD)

function UniqueAfterbirthFloorEnemiesMod:onMulliganUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 0, nil, "gfx/monsters/afterbirth/monster_000_bodies01_drowned.png", nil, nil) --mulligoon
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 1, nil, "gfx/monsters/flooded/drowned_monster_059_muligoon.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onMulliganUpdate, EntityType.ENTITY_MULLIGAN)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onMulliganUpdate, EntityType.ENTITY_MULLIGAN)

function UniqueAfterbirthFloorEnemiesMod:onClottyUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_065_clotty.png", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 2, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_075_lblob.png", nil, nil) --i. blob
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onClottyUpdate, EntityType.ENTITY_CLOTTY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onClottyUpdate, EntityType.ENTITY_CLOTTY)

function UniqueAfterbirthFloorEnemiesMod:onMaggotUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_105_maggot.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onMaggotUpdate, EntityType.ENTITY_MAGGOT)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onMaggotUpdate, EntityType.ENTITY_MAGGOT)

function UniqueAfterbirthFloorEnemiesMod:onChargerUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_113_charger.png", nil, nil) --regular
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onChargerUpdate, EntityType.ENTITY_CHARGER)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onChargerUpdate, EntityType.ENTITY_CHARGER)

function UniqueAfterbirthFloorEnemiesMod:onSpittyUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_115_spitty.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onSpittyUpdate, EntityType.ENTITY_SPITY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onSpittyUpdate, EntityType.ENTITY_SPITY)

function UniqueAfterbirthFloorEnemiesMod:onGlobinUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, -1, nil, "gfx/drowned_globin.anm2", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, -1, nil, "gfx/drowned_gazing globin.anm2", nil, nil) --gazing
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onGlobinUpdate, EntityType.ENTITY_GLOBIN)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onGlobinUpdate, EntityType.ENTITY_GLOBIN)

function UniqueAfterbirthFloorEnemiesMod:onNestUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/afterbirth/monster_000_bodies01_drowned.png", nil, nil)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, nil, "gfx/monsters/flooded/drowned_monster_205_nest.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onNestUpdate, EntityType.ENTITY_NEST)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onNestUpdate, EntityType.ENTITY_NEST)

function UniqueAfterbirthFloorEnemiesMod:onTumorUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_229_tumor.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onTumorUpdate, EntityType.ENTITY_TUMOR)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onTumorUpdate, EntityType.ENTITY_TUMOR)

function UniqueAfterbirthFloorEnemiesMod:onWallCreepUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_240_wallcreep.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onWallCreepUpdate, EntityType.ENTITY_WALL_CREEP)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onWallCreepUpdate, EntityType.ENTITY_WALL_CREEP)

function UniqueAfterbirthFloorEnemiesMod:onBlindCreepUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_242_blindcreep.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onBlindCreepUpdate, EntityType.ENTITY_BLIND_CREEP)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onBlindCreepUpdate, EntityType.ENTITY_BLIND_CREEP)

function UniqueAfterbirthFloorEnemiesMod:onConjoinedSpittyUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_243_conjoined spitty.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onConjoinedSpittyUpdate, EntityType.ENTITY_CONJOINED_SPITTY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onConjoinedSpittyUpdate, EntityType.ENTITY_CONJOINED_SPITTY)

function UniqueAfterbirthFloorEnemiesMod:onConjoinedFattyUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_257.000_conjoinedfatty.png", nil, nil)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, nil, "gfx/monsters/flooded/drowned_257.000_conjoinedfatty.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onConjoinedFattyUpdate, EntityType.ENTITY_CONJOINED_FATTY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onConjoinedFattyUpdate, EntityType.ENTITY_CONJOINED_FATTY)

function UniqueAfterbirthFloorEnemiesMod:onHopperUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_044_hopperleaper.png", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_082_trite.png", nil, nil) --trite
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onHopperUpdate, EntityType.ENTITY_HOPPER)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onHopperUpdate, EntityType.ENTITY_HOPPER)

function UniqueAfterbirthFloorEnemiesMod:onLeaperUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_044_hopperleaper.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onLeaperUpdate, EntityType.ENTITY_LEAPER)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onLeaperUpdate, EntityType.ENTITY_LEAPER)

function UniqueAfterbirthFloorEnemiesMod:onMawUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_141_maw.png", nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 1, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_142_redmaw.png", nil, nil) --red maw
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onMawUpdate, EntityType.ENTITY_MAW)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onMawUpdate, EntityType.ENTITY_MAW)

function UniqueAfterbirthFloorEnemiesMod:onMushroomUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_300_mushroomman.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onMushroomUpdate, EntityType.ENTITY_MUSHROOM)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onMushroomUpdate, EntityType.ENTITY_MUSHROOM)

function UniqueAfterbirthFloorEnemiesMod:onMinistroUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, nil, "gfx/monsters/flooded/drowned_monster_305_ministro.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onMinistroUpdate, EntityType.ENTITY_MINISTRO)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onMinistroUpdate, EntityType.ENTITY_MINISTRO)