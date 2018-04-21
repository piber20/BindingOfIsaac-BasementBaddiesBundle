UniqueAfterbirthFloorEnemiesMod = RegisterMod("Unique Afterbirth Floor Enemies", 1)

UniqueAfterbirthFloorSpritesets = {
	NONE = 0,
	FLAMING = 1,
	FLOODED = 2,
	DANK = 3,
	SCARRED = 4
}

function UniqueAfterbirthFloorEnemiesMod:getSpritesetsToUse()
	local level = Game():GetLevel()
	local currentStage = level:GetStage()
	local spritesetToUse = UniqueAfterbirthFloorSpritesets.NONE
	if not Game():IsGreedMode() then
		if currentStage == 12 then
			local room = level:GetCurrentRoom()
			local roomStage = room:GetRoomConfigStage()
			
			if roomStage == 3 then
				spritesetToUse = UniqueAfterbirthFloorSpritesets.FLAMING
			elseif roomStage == 6 then 
				spritesetToUse = UniqueAfterbirthFloorSpritesets.FLOODED
			elseif roomStage == 9 then
				spritesetToUse = UniqueAfterbirthFloorSpritesets.DANK
			elseif roomStage == 12 then
				spritesetToUse = UniqueAfterbirthFloorSpritesets.SCARRED
			end
		else
			local currentStageType = level:GetStageType()
			if currentStageType == 2 then
				if currentStage == 1 or currentStage == 2 then
					spritesetToUse = UniqueAfterbirthFloorSpritesets.FLAMING
				elseif currentStage == 3 or currentStage == 4 then
					spritesetToUse = UniqueAfterbirthFloorSpritesets.FLOODED
				elseif currentStage == 5 or currentStage == 6 then
					spritesetToUse = UniqueAfterbirthFloorSpritesets.DANK
				elseif currentStage == 7 or currentStage == 8 then
					spritesetToUse = UniqueAfterbirthFloorSpritesets.SCARRED
				end
			end
		end
	end
	
	return spritesetToUse
end

function UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, variant, subtype, layer, flamingSpritesheet, floodedSpritesheet, dankSpritesheet, scarredSpritesheet)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if variant == nil then
			variant = -1
		end
		if entity.Variant == variant or variant == -1 then
			if subtype == nil then
				subtype = -1
			end
			if entity.SubType == subtype or subtype == -1 then
				local spritesetToUse = UniqueAfterbirthFloorEnemiesMod:getSpritesetsToUse()
				if spritesetToUse ~= UniqueAfterbirthFloorSpritesets.NONE then
					local spritesheet = nil
					if spritesetToUse == UniqueAfterbirthFloorSpritesets.FLAMING then
						spritesheet = flamingSpritesheet
					elseif spritesetToUse == UniqueAfterbirthFloorSpritesets.FLOODED then
						spritesheet = floodedSpritesheet
					elseif spritesetToUse == UniqueAfterbirthFloorSpritesets.DANK then
						spritesheet = dankSpritesheet
					elseif spritesetToUse == UniqueAfterbirthFloorSpritesets.SCARRED then
						spritesheet = scarredSpritesheet
					end
					if spritesheet ~= nil then
						local sprite = entity:GetSprite()
						if layer >= 0 then
							sprite:ReplaceSpritesheet(layer, spritesheet) 
						else
							sprite:Load(spritesheet, true)
							sprite:Play(sprite:GetDefaultAnimation(), false)
						end
						sprite:LoadGraphics()
					end
				end
			end
		end
	end
end

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
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 0, "gfx/monsters/afterbirth/207.002_flamingfatty.png", nil, nil, nil) --regular
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, 0, -1, 1, "gfx/monsters/afterbirth/207.002_flamingfatty.png", nil, nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, UniqueAfterbirthFloorEnemiesMod.onFattyUpdate, EntityType.ENTITY_FATTY)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, UniqueAfterbirthFloorEnemiesMod.onFattyUpdate, EntityType.ENTITY_FATTY)

function UniqueAfterbirthFloorEnemiesMod:onBloodProjectileUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, ProjectileVariant.PROJECTILE_NORMAL, -1, 0, nil, "gfx/enemybullets_flooded.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, UniqueAfterbirthFloorEnemiesMod.onBloodProjectileUpdate, ProjectileVariant.PROJECTILE_NORMAL)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_INIT, UniqueAfterbirthFloorEnemiesMod.onBloodProjectileUpdate, ProjectileVariant.PROJECTILE_NORMAL)

function UniqueAfterbirthFloorEnemiesMod:onBloodProjectilePoofUpdate(entity)
	UniqueAfterbirthFloorEnemiesMod:onRespritableEntityUpdate(entity, EffectVariant.BULLET_POOF, -1, 0, nil, "gfx/effects/effect_003_bloodtear_flooded.png", nil, nil)
end
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, UniqueAfterbirthFloorEnemiesMod.onBloodProjectilePoofUpdate, EffectVariant.BULLET_POOF)
UniqueAfterbirthFloorEnemiesMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, UniqueAfterbirthFloorEnemiesMod.onBloodProjectilePoofUpdate, EffectVariant.BULLET_POOF)

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