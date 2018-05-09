FixedDirtSpritesMod = RegisterMod("More Dirt Sprites", 1)

--load piber20helper
local _, err = pcall(require, "piber20helper")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(err)
end

FixedDirtSpritesMod.enabled = true

function FixedDirtSpritesMod:getData(entity)
	local data = entity:GetData()
	if data.DirtSprites == nil then
		data.DirtSprites = {}
	end
	return data.DirtSprites
end

FixedDirtSpritesDirt = { --custom enum that tells us which dirt sprite to use
	NONE = -1,
	DIRT = 0,
	WOMB = 1,
	SCARRED = 2,
	FLOODED = 3,
	BLUE_WOMB = 4,
	DIRT_DARK = 5,
	GRAY = 6,
	BLACK = 7
}

function FixedDirtSpritesMod:getDirtToUse()
	local backdrop = piber20HelperMod:getCurrentBackdrop()
	local dirtToUse = FixedDirtSpritesDirt.DIRT
	if backdrop == piber20HelperBackdrop.FLOODED_CAVES or backdrop == piber20HelperBackdrop.CATHEDRAL then
		dirtToUse = FixedDirtSpritesDirt.FLOODED
	elseif backdrop == piber20HelperBackdrop.DEPTHS or backdrop == piber20HelperBackdrop.DANK_DEPTHS then
		dirtToUse = FixedDirtSpritesDirt.GRAY
	elseif backdrop == piber20HelperBackdrop.NECROPOLIS or backdrop == piber20HelperBackdrop.SECRET_ROOM or backdrop == piber20HelperBackdrop.BARREN_ROOM then
		dirtToUse = FixedDirtSpritesDirt.DIRT_DARK
	elseif backdrop == piber20HelperBackdrop.WOMB or backdrop == piber20HelperBackdrop.UTERO or backdrop == piber20HelperBackdrop.DICE_ROOM then
		dirtToUse = FixedDirtSpritesDirt.WOMB
	elseif backdrop == piber20HelperBackdrop.SCARRED_WOMB then
		dirtToUse = FixedDirtSpritesDirt.SCARRED
	elseif backdrop == piber20HelperBackdrop.BLUE_WOMB then
		dirtToUse = FixedDirtSpritesDirt.BLUE_WOMB
	elseif backdrop == piber20HelperBackdrop.SHEOL or backdrop == piber20HelperBackdrop.DARK_ROOM then
		dirtToUse = FixedDirtSpritesDirt.BLACK
	elseif backdrop == piber20HelperBackdrop.ERROR_ROOM then
		dirtToUse = FixedDirtSpritesDirt.NONE
	end
	
	if Isaac.CountEntities(nil, EntityType.ENTITY_DELIRIUM, -1, -1) > 0 then
		dirtToUse = FixedDirtSpritesDirt.NONE --disable self if delirium is in this room
	end
	
	if StageSystem then
		if StageSystem.GetCurrentStage() ~= 0 then
			dirtToUse = FixedDirtSpritesDirt.NONE --so we don't overwrite any custom stage sprites
		end
	end
	
	--return our dirtToUse value
	return dirtToUse
end

function FixedDirtSpritesMod:setDirtSprite(entity, variant, layer, dirt, womb, scarred, flooded, blueWomb, dirtDark, gray, black)
	local frameCount = entity.FrameCount
	
	local thisType = entity.Type
	local thisVariant = entity.Variant
	local thisSubType = entity.SubType
	local thisHealth = entity.HitPoints
	
	local data = FixedDirtSpritesMod:getData(entity)
	if data.LastType == nil then
		data.LastType = thisType
	end
	if data.LastVariant == nil then
		data.LastVariant = thisVariant
	end
	if data.LastSubType == nil then
		data.LastSubType = thisSubType
	end
	if data.LastHealth == nil then
		data.LastHealth = thisHealth
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
	if data.LastHealth <= (thisHealth - 50) then --this is the only way i can think of to detect the frail's second phase
		data.entityTypesChanged = frameCount
	end
	
	data.LastType = thisType
	data.LastVariant = thisVariant
	data.LastSubType = thisSubType
	data.LastHealth = thisHealth
	
	if frameCount <= 1 or (frameCount >= data.entityTypesChanged and frameCount <= (data.entityTypesChanged + 2)) then
		local dirtToUse = FixedDirtSpritesMod:getDirtToUse()
		if dirtToUse ~= FixedDirtSpritesDirt.NONE then
			if entity.Variant == variant then
				local spritesheet = nil
				
				if dirt and dirtToUse == FixedDirtSpritesDirt.DIRT then
					spritesheet = dirt
				elseif womb and dirtToUse == FixedDirtSpritesDirt.WOMB then
					spritesheet = womb
				elseif scarred and dirtToUse == FixedDirtSpritesDirt.SCARRED then
					spritesheet = scarred
				elseif flooded and dirtToUse == FixedDirtSpritesDirt.FLOODED then
					spritesheet = flooded
				elseif blueWomb and dirtToUse == FixedDirtSpritesDirt.BLUE_WOMB then
					spritesheet = blueWomb
				elseif dirtDark and dirtToUse == FixedDirtSpritesDirt.DIRT_DARK then
					spritesheet = dirtDark
				elseif gray and dirtToUse == FixedDirtSpritesDirt.GRAY then
					spritesheet = gray
				elseif black and dirtToUse == FixedDirtSpritesDirt.BLACK then
					spritesheet = black
				end
				
				if spritesheet ~= nil then
					--trying to make the frail's second phase work, ugh
					if data.entityTypesChanged > 60 then
						if spritesheet == "gfx/bosses/afterbirth/boss_thefrail.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_womb.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_womb.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_scarred.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_scarred.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_flooded.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_flooded.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_blue_womb.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_blue_womb.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_dirt_dark.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_dirt_dark.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_gray.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_gray.png"
						elseif spritesheet == "gfx/bosses/afterbirth/boss_thefrail_black.png" then
							spritesheet = "gfx/bosses/afterbirth/boss_thefrail2_black.png"
						end
					end
					
					local sprite = entity:GetSprite()
					sprite:ReplaceSpritesheet(layer, spritesheet)
					sprite:LoadGraphics()
				end
			end
		end
	end
end

-----------
--ENEMIES--
-----------
function FixedDirtSpritesMod:onFredUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/classic/monster_197_fred_dirt.png", "gfx/monsters/classic/monster_197_fred.png", "gfx/monsters/classic/monster_197_fred_scarred.png", "gfx/monsters/classic/monster_197_fred_flooded.png", "gfx/monsters/classic/monster_197_fred_blue_womb.png", "gfx/monsters/classic/monster_197_fred_dirt_dark.png", "gfx/monsters/classic/monster_197_fred_gray.png", "gfx/monsters/classic/monster_197_fred_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onFredUpdate, EntityType.ENTITY_FRED)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onFredUpdate, EntityType.ENTITY_FRED)

function FixedDirtSpritesMod:onEyeUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/classic/monster_194_eye_dirt.png", "gfx/monsters/classic/monster_194_eye.png", "gfx/monsters/classic/monster_194_eye_scarred.png", "gfx/monsters/classic/monster_194_eye_flooded.png", "gfx/monsters/classic/monster_194_eye_blue_womb.png", "gfx/monsters/classic/monster_194_eye_dirt_dark.png", "gfx/monsters/classic/monster_194_eye_gray.png", "gfx/monsters/classic/monster_194_eye_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onEyeUpdate, EntityType.ENTITY_EYE)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onEyeUpdate, EntityType.ENTITY_EYE)

function FixedDirtSpritesMod:onLumpUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/classic/monster_198_lump_dirt.png", "gfx/monsters/classic/monster_198_lump.png", "gfx/monsters/classic/monster_198_lump_scarred.png", "gfx/monsters/classic/monster_198_lump_flooded.png", "gfx/monsters/classic/monster_198_lump_blue_womb.png", "gfx/monsters/classic/monster_198_lump_dirt_dark.png", "gfx/monsters/classic/monster_198_lump_gray.png", "gfx/monsters/classic/monster_198_lump_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onLumpUpdate, EntityType.ENTITY_LUMP)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onLumpUpdate, EntityType.ENTITY_LUMP)

function FixedDirtSpritesMod:onNightCrawlerUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/rebirth/monster_255_nightcrawler.png", "gfx/monsters/rebirth/monster_255_nightcrawler_womb.png", "gfx/monsters/rebirth/monster_255_nightcrawler_scarred.png", "gfx/monsters/rebirth/monster_255_nightcrawler_flooded.png", "gfx/monsters/rebirth/monster_255_nightcrawler_blue_womb.png", "gfx/monsters/rebirth/monster_255_nightcrawler_dirt_dark.png", "gfx/monsters/rebirth/monster_255_nightcrawler_gray.png", "gfx/monsters/rebirth/monster_255_nightcrawler_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onNightCrawlerUpdate, EntityType.ENTITY_NIGHT_CRAWLER)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onNightCrawlerUpdate, EntityType.ENTITY_NIGHT_CRAWLER)

function FixedDirtSpritesMod:onParaBiteUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/classic/monster_199_parabite_dirt.png", "gfx/monsters/classic/monster_199_parabite.png", "gfx/monsters/classic/monster_199_parabite_scarred.png", "gfx/monsters/classic/monster_199_parabite_flooded.png", "gfx/monsters/classic/monster_199_parabite_blue_womb.png", "gfx/monsters/classic/monster_199_parabite_dirt_dark.png", "gfx/monsters/classic/monster_199_parabite_gray.png", "gfx/monsters/classic/monster_199_parabite_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 1, 0, "gfx/monsters/afterbirth/058.001_scarredparabite_dirt.png", "gfx/monsters/afterbirth/058.001_scarredparabite.png", "gfx/monsters/afterbirth/058.001_scarredparabite_scarred.png", "gfx/monsters/afterbirth/058.001_scarredparabite_flooded.png", "gfx/monsters/afterbirth/058.001_scarredparabite_blue_womb.png", "gfx/monsters/afterbirth/058.001_scarredparabite_dirt_dark.png", "gfx/monsters/afterbirth/058.001_scarredparabite_gray.png", "gfx/monsters/afterbirth/058.001_scarredparabite_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onParaBiteUpdate, EntityType.ENTITY_PARA_BITE)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onParaBiteUpdate, EntityType.ENTITY_PARA_BITE)

function FixedDirtSpritesMod:onRoundWormUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/rebirth/monster_244_roundworm.png", "gfx/monsters/rebirth/monster_244_roundworm_womb.png", "gfx/monsters/rebirth/monster_244_roundworm_scarred.png", "gfx/monsters/rebirth/monster_244_roundworm_flooded.png", "gfx/monsters/rebirth/monster_244_roundworm_blue_womb.png", "gfx/monsters/rebirth/monster_244_roundworm_dirt_dark.png", "gfx/monsters/rebirth/monster_244_roundworm_gray.png", "gfx/monsters/rebirth/monster_244_roundworm_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 1, 0, "gfx/monsters/afterbirthplus/tubeworm_dirt.png", "gfx/monsters/afterbirthplus/tubeworm_scarred.png", "gfx/monsters/afterbirthplus/tubeworm.png", "gfx/monsters/afterbirthplus/tubeworm_womb.png", "gfx/monsters/afterbirthplus/tubeworm_blue_womb.png", "gfx/monsters/afterbirthplus/tubeworm_dirt_dark.png", "gfx/monsters/afterbirthplus/tubeworm_gray.png", "gfx/monsters/afterbirthplus/tubeworm_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onRoundWormUpdate, EntityType.ENTITY_ROUND_WORM)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onRoundWormUpdate, EntityType.ENTITY_ROUND_WORM)

function FixedDirtSpritesMod:onRoundyUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/afterbirth/276.000_roundy.png", "gfx/monsters/afterbirth/276.000_roundy_womb.png", "gfx/monsters/afterbirth/276.000_roundy_scarred.png", "gfx/monsters/afterbirth/276.000_roundy_flooded.png", "gfx/monsters/afterbirth/276.000_roundy_blue_womb.png", "gfx/monsters/afterbirth/276.000_roundy_dirt_dark.png", "gfx/monsters/afterbirth/276.000_roundy_gray.png", "gfx/monsters/afterbirth/276.000_roundy_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onRoundyUpdate, EntityType.ENTITY_ROUNDY)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onRoundyUpdate, EntityType.ENTITY_ROUNDY)

function FixedDirtSpritesMod:onUlcerUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/monsters/afterbirth/289.000_ulcer.png", "gfx/monsters/afterbirth/289.000_ulcer_womb.png", "gfx/monsters/afterbirth/289.000_ulcer_scarred.png", "gfx/monsters/afterbirth/289.000_ulcer_flooded.png", "gfx/monsters/afterbirth/289.000_ulcer_blue_womb.png", "gfx/monsters/afterbirth/289.000_ulcer_dirt_dark.png", "gfx/monsters/afterbirth/289.000_ulcer_gray.png", "gfx/monsters/afterbirth/289.000_ulcer_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onUlcerUpdate, EntityType.ENTITY_ULCER)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onUlcerUpdate, EntityType.ENTITY_ULCER)

----------
--BOSSES--
----------
function FixedDirtSpritesMod:onPinUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/bosses/classic/boss_019_pin.png", "gfx/bosses/classic/boss_019_pin_womb.png", "gfx/bosses/classic/boss_019_pin_scarred.png", "gfx/bosses/classic/boss_019_pin_flooded.png", "gfx/bosses/classic/boss_019_pin_blue_womb.png", "gfx/bosses/classic/boss_019_pin_dirt_dark.png", "gfx/bosses/classic/boss_019_pin_gray.png", "gfx/bosses/classic/boss_019_pin_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 1, 0, "gfx/bosses/classic/boss_062_scolex_dirt.png", "gfx/bosses/classic/boss_062_scolex.png", "gfx/bosses/classic/boss_062_scolex_scarred.png", "gfx/bosses/classic/boss_062_scolex_flooded.png", "gfx/bosses/classic/boss_062_scolex_blue_womb.png", "gfx/bosses/classic/boss_062_scolex_dirt_dark.png", "gfx/bosses/classic/boss_062_scolex_gray.png", "gfx/bosses/classic/boss_062_scolex_black.png")
	if entity.SubType ~= 1 then
		FixedDirtSpritesMod:setDirtSprite(entity, 2, 0, "gfx/bosses/afterbirth/boss_thefrail.png", "gfx/bosses/afterbirth/boss_thefrail_womb.png", "gfx/bosses/afterbirth/boss_thefrail_scarred.png", "gfx/bosses/afterbirth/boss_thefrail_flooded.png", "gfx/bosses/afterbirth/boss_thefrail_blue_womb.png", "gfx/bosses/afterbirth/boss_thefrail_dirt_dark.png", "gfx/bosses/afterbirth/boss_thefrail_gray.png", "gfx/bosses/afterbirth/boss_thefrail_black.png")
	else
		FixedDirtSpritesMod:setDirtSprite(entity, 2, 0, "gfx/bosses/afterbirth/boss_thefrail2.png", "gfx/bosses/afterbirth/boss_thefrail2_womb.png", "gfx/bosses/afterbirth/boss_thefrail2_scarred.png", "gfx/bosses/afterbirth/boss_thefrail2_flooded.png", "gfx/bosses/afterbirth/boss_thefrail2_blue_womb.png", "gfx/bosses/afterbirth/boss_thefrail2_dirt_dark.png", "gfx/bosses/afterbirth/boss_thefrail2_gray.png", "gfx/bosses/afterbirth/boss_thefrail2_black.png")
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onPinUpdate, EntityType.ENTITY_PIN)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onPinUpdate, EntityType.ENTITY_PIN)

function FixedDirtSpritesMod:onPolycephalusUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/bosses/rebirth/polycephalus.png", "gfx/bosses/rebirth/polycephalus_womb.png", "gfx/bosses/rebirth/polycephalus_scarred.png", "gfx/bosses/rebirth/polycephalus_flooded.png", "gfx/bosses/rebirth/polycephalus_blue_womb.png", "gfx/bosses/rebirth/polycephalus_dirt_dark.png", "gfx/bosses/rebirth/polycephalus_gray.png", "gfx/bosses/rebirth/polycephalus_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 1, "gfx/bosses/rebirth/polycephalus.png", "gfx/bosses/rebirth/polycephalus_womb.png", "gfx/bosses/rebirth/polycephalus_scarred.png", "gfx/bosses/rebirth/polycephalus_flooded.png", "gfx/bosses/rebirth/polycephalus_blue_womb.png", "gfx/bosses/rebirth/polycephalus_dirt_dark.png", "gfx/bosses/rebirth/polycephalus_gray.png", "gfx/bosses/rebirth/polycephalus_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onPolycephalusUpdate, EntityType.ENTITY_POLYCEPHALUS)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onPolycephalusUpdate, EntityType.ENTITY_POLYCEPHALUS)

function FixedDirtSpritesMod:onMrFredUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/bosses/rebirth/megafred_dirt.png", "gfx/bosses/rebirth/megafred.png", "gfx/bosses/rebirth/megafred_scarred.png", "gfx/bosses/rebirth/megafred_flooded.png", "gfx/bosses/rebirth/megafred_blue_womb.png", "gfx/bosses/rebirth/megafred_dirt_dark.png", "gfx/bosses/rebirth/megafred_gray.png", "gfx/bosses/rebirth/megafred_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 1, "gfx/bosses/rebirth/megafred_dirt.png", "gfx/bosses/rebirth/megafred.png", "gfx/bosses/rebirth/megafred_scarred.png", "gfx/bosses/rebirth/megafred_flooded.png", "gfx/bosses/rebirth/megafred_blue_womb.png", "gfx/bosses/rebirth/megafred_dirt_dark.png", "gfx/bosses/rebirth/megafred_gray.png", "gfx/bosses/rebirth/megafred_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onMrFredUpdate, EntityType.ENTITY_MR_FRED)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onMrFredUpdate, EntityType.ENTITY_MR_FRED)

function FixedDirtSpritesMod:onStainUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 0, "gfx/bosses/afterbirth/thestain.png", "gfx/bosses/afterbirth/thestain_womb.png", "gfx/bosses/afterbirth/thestain_scarred.png", "gfx/bosses/afterbirth/thestain_flooded.png", "gfx/bosses/afterbirth/thestain_blue_womb.png", "gfx/bosses/afterbirth/thestain_dirt_dark.png", "gfx/bosses/afterbirth/thestain_gray.png", "gfx/bosses/afterbirth/thestain_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 1, "gfx/bosses/afterbirth/thestain.png", "gfx/bosses/afterbirth/thestain_womb.png", "gfx/bosses/afterbirth/thestain_scarred.png", "gfx/bosses/afterbirth/thestain_flooded.png", "gfx/bosses/afterbirth/thestain_blue_womb.png", "gfx/bosses/afterbirth/thestain_dirt_dark.png", "gfx/bosses/afterbirth/thestain_gray.png", "gfx/bosses/afterbirth/thestain_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 2, "gfx/bosses/afterbirth/thestain.png", "gfx/bosses/afterbirth/thestain_womb.png", "gfx/bosses/afterbirth/thestain_scarred.png", "gfx/bosses/afterbirth/thestain_flooded.png", "gfx/bosses/afterbirth/thestain_blue_womb.png", "gfx/bosses/afterbirth/thestain_dirt_dark.png", "gfx/bosses/afterbirth/thestain_gray.png", "gfx/bosses/afterbirth/thestain_black.png")
	FixedDirtSpritesMod:setDirtSprite(entity, 0, 3, "gfx/bosses/afterbirth/thestain.png", "gfx/bosses/afterbirth/thestain_womb.png", "gfx/bosses/afterbirth/thestain_scarred.png", "gfx/bosses/afterbirth/thestain_flooded.png", "gfx/bosses/afterbirth/thestain_blue_womb.png", "gfx/bosses/afterbirth/thestain_dirt_dark.png", "gfx/bosses/afterbirth/thestain_gray.png", "gfx/bosses/afterbirth/thestain_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onStainUpdate, EntityType.ENTITY_STAIN)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onStainUpdate, EntityType.ENTITY_STAIN)

-----------
--EFFECTS--
-----------

function FixedDirtSpritesMod:onShockwaveUpdate(entity)
	FixedDirtSpritesMod:setDirtSprite(entity, EffectVariant.ROCK_EXPLOSION, 0, "gfx/effects/effect_062_groundbreakcaves.png", "gfx/effects/effect_062_groundbreak_womb.png", "gfx/effects/effect_062_groundbreak_scarred.png", "gfx/effects/effect_062_groundbreak_flooded.png", "gfx/effects/effect_062_groundbreak_blue_womb.png", "gfx/effects/effect_062_groundbreak.png", "gfx/effects/effect_062_groundbreakdepths.png", "gfx/effects/effect_062_groundbreak_black.png")
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, FixedDirtSpritesMod.onShockwaveUpdate, EffectVariant.ROCK_EXPLOSION)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, FixedDirtSpritesMod.onShockwaveUpdate, EffectVariant.ROCK_EXPLOSION)

----------------------------
--ENTITIES FROM OTHER MODS--
----------------------------
FixedDirtSpritesOtherModEntityType = {
	ENTITY_3_EYED_NIGHT_CRAWLER = -1,
	ENTITY_DIP_ULCER = -1,
	ENTITY_INJURED_ROUND_WORM = -1,
	ENTITY_ROUND_WORM_TRIO = -1,
	ENTITY_LIL_MINER = -1,
	ENTITY_SMOLYCEPHALUS = -1
}
FixedDirtSpritesOtherModEntityVariant = {
	ENTITY_3_EYED_NIGHT_CRAWLER = -1,
	ENTITY_DIP_ULCER = -1,
	ENTITY_INJURED_ROUND_WORM = -1,
	ENTITY_ROUND_WORM_TRIO = -1,
	ENTITY_LIL_MINER = -1,
	ENTITY_SMOLYCEPHALUS = -1
}
local checkedForModContent = false
function FixedDirtSpritesMod:checkForModContent()
	if not checkedForModContent then
		---------------------
		--ALPHABIRTH PACK 2--
		---------------------
		FixedDirtSpritesOtherModEntityType.ENTITY_3_EYED_NIGHT_CRAWLER = Isaac.GetEntityTypeByName("3 Eyed Night Crawler")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_3_EYED_NIGHT_CRAWLER = Isaac.GetEntityVariantByName("3 Eyed Night Crawler")
		if FixedDirtSpritesOtherModEntityType.ENTITY_3_EYED_NIGHT_CRAWLER ~= -1 then
			function FixedDirtSpritesMod:onThreeEyedNightCrawlerUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_3_EYED_NIGHT_CRAWLER, 0, "gfx/animations/enemies/sheet_enemy_3eyednightcrawler.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_womb.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_scarred.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_flooded.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_blue_womb.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_dirt_dark.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_gray.png", "gfx/animations/enemies/sheet_enemy_3eyednightcrawler_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onThreeEyedNightCrawlerUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_3_EYED_NIGHT_CRAWLER)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onThreeEyedNightCrawlerUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_3_EYED_NIGHT_CRAWLER)
		end
		
		FixedDirtSpritesOtherModEntityType.ENTITY_DIP_ULCER = Isaac.GetEntityTypeByName("Dip Ulcer")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_DIP_ULCER = Isaac.GetEntityVariantByName("Dip Ulcer")
		if FixedDirtSpritesOtherModEntityType.ENTITY_DIP_ULCER ~= -1 then
			function FixedDirtSpritesMod:onDipUlcerUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_DIP_ULCER, 0, "gfx/animations/enemies/sheet_enemy_dipulcer.png", "gfx/animations/enemies/sheet_enemy_dipulcer_womb.png", "gfx/animations/enemies/sheet_enemy_dipulcer_scarred.png", "gfx/animations/enemies/sheet_enemy_dipulcer_flooded.png", "gfx/animations/enemies/sheet_enemy_dipulcer_blue_womb.png", "gfx/animations/enemies/sheet_enemy_dipulcer_dirt_dark.png", "gfx/animations/enemies/sheet_enemy_dipulcer_gray.png", "gfx/animations/enemies/sheet_enemy_dipulcer_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onDipUlcerUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_DIP_ULCER)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onDipUlcerUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_DIP_ULCER)
		end
		
		FixedDirtSpritesOtherModEntityType.ENTITY_INJURED_ROUND_WORM = Isaac.GetEntityTypeByName("Injured Round Worm")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_INJURED_ROUND_WORM = Isaac.GetEntityVariantByName("Injured Round Worm")
		if FixedDirtSpritesOtherModEntityType.ENTITY_INJURED_ROUND_WORM ~= -1 then
			function FixedDirtSpritesMod:onInjuredRoundWormUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_INJURED_ROUND_WORM, 0, "gfx/animations/enemies/sheet_enemy_injuredroundworm.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_womb.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_scarred.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_flooded.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_blue_womb.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_dirt_dark.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_gray.png", "gfx/animations/enemies/sheet_enemy_injuredroundworm_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onInjuredRoundWormUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_INJURED_ROUND_WORM)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onInjuredRoundWormUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_INJURED_ROUND_WORM)
		end
		
		FixedDirtSpritesOtherModEntityType.ENTITY_ROUND_WORM_TRIO = Isaac.GetEntityTypeByName("Round Worm Trio")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_ROUND_WORM_TRIO = Isaac.GetEntityVariantByName("Round Worm Trio")
		if FixedDirtSpritesOtherModEntityType.ENTITY_ROUND_WORM_TRIO ~= -1 then
			function FixedDirtSpritesMod:onRoundWormTrioUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_ROUND_WORM_TRIO, 0, "gfx/animations/enemies/sheet_enemy_roundwormtrio.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_womb.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_scarred.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_flooded.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_blue_womb.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_dirt_dark.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_gray.png", "gfx/animations/enemies/sheet_enemy_roundwormtrio_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onRoundWormTrioUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_ROUND_WORM_TRIO)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onRoundWormTrioUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_ROUND_WORM_TRIO)
		end
		
		---------------------
		--ALPHABIRTH PACK 3--
		---------------------
		FixedDirtSpritesOtherModEntityType.ENTITY_LIL_MINER = Isaac.GetEntityTypeByName("Lil Miner")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_LIL_MINER = Isaac.GetEntityVariantByName("Lil Miner")
		if FixedDirtSpritesOtherModEntityType.ENTITY_LIL_MINER ~= -1 then
			function FixedDirtSpritesMod:onLilMinerUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_LIL_MINER, 0, "gfx/animations/familiars/sheet_familiar_lilminer.png", "gfx/animations/familiars/sheet_familiar_lilminer_womb.png", "gfx/animations/familiars/sheet_familiar_lilminer_scarred.png", "gfx/animations/familiars/sheet_familiar_lilminer_flooded.png", "gfx/animations/familiars/sheet_familiar_lilminer_blue_womb.png", "gfx/animations/familiars/sheet_familiar_lilminer_dirt_dark.png", "gfx/animations/familiars/sheet_familiar_lilminer_gray.png", "gfx/animations/familiars/sheet_familiar_lilminer_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, FixedDirtSpritesMod.onLilMinerUpdate, FixedDirtSpritesOtherModEntityVariant.ENTITY_LIL_MINER)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, FixedDirtSpritesMod.onLilMinerUpdate, FixedDirtSpritesOtherModEntityVariant.ENTITY_LIL_MINER)
		end
		
		-------------------------
		--REVELATIONS CHAPTER 1--
		-------------------------
		FixedDirtSpritesOtherModEntityType.ENTITY_SMOLYCEPHALUS = Isaac.GetEntityTypeByName("Smolycephalus")
		FixedDirtSpritesOtherModEntityVariant.ENTITY_SMOLYCEPHALUS = Isaac.GetEntityVariantByName("Smolycephalus")
		if FixedDirtSpritesOtherModEntityType.ENTITY_SMOLYCEPHALUS ~= -1 then
			function FixedDirtSpritesMod:onRoundWormTrioUpdate(entity)
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_SMOLYCEPHALUS, 0, "gfx/monsters/enemySmolycephalus.png", "gfx/monsters/enemySmolycephalus_womb.png", "gfx/monsters/enemySmolycephalus_scarred.png", "gfx/monsters/enemySmolycephalus_flooded.png", "gfx/monsters/enemySmolycephalus_blue_womb.png", "gfx/monsters/enemySmolycephalus_dirt_dark.png", "gfx/monsters/enemySmolycephalus_gray.png", "gfx/monsters/enemySmolycephalus_black.png")
				FixedDirtSpritesMod:setDirtSprite(entity, FixedDirtSpritesOtherModEntityVariant.ENTITY_SMOLYCEPHALUS, 1, "gfx/monsters/enemySmolycephalus.png", "gfx/monsters/enemySmolycephalus_womb.png", "gfx/monsters/enemySmolycephalus_scarred.png", "gfx/monsters/enemySmolycephalus_flooded.png", "gfx/monsters/enemySmolycephalus_blue_womb.png", "gfx/monsters/enemySmolycephalus_dirt_dark.png", "gfx/monsters/enemySmolycephalus_gray.png", "gfx/monsters/enemySmolycephalus_black.png")
			end
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, FixedDirtSpritesMod.onRoundWormTrioUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_SMOLYCEPHALUS)
			FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.onRoundWormTrioUpdate, FixedDirtSpritesOtherModEntityType.ENTITY_SMOLYCEPHALUS)
		end
		
		checkedForModContent = true
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FixedDirtSpritesMod.checkForModContent)