FixedDirtSpritesMod = RegisterMod("Fixed Dirt Sprites", 1)

--load piber20helper
local _, err = pcall(require, "piber20helper")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(err)
end

--load config
local _, err = pcall(require, "config")
if not string.match(tostring(err), "attempt to call a nil value %(method 'ForceError'%)") then
	Isaac.DebugString(err)
end

FixedDirtSpritesMod.enabled = true

--get local vars set up, these change when the room changes
local level = Game():GetLevel()
local room = level:GetCurrentRoom()
local currentChapter = 1

--use______Sprites vars, these control what sprites we should use
FixedDirtSpritesMod.useDirtSprites = true
FixedDirtSpritesMod.useWombSprites = false
FixedDirtSpritesMod.useScarredSprites = false
FixedDirtSpritesMod.useFloodedSprites = false
FixedDirtSpritesMod.useBlueSprites = false
FixedDirtSpritesMod.useDarkSprites = false
FixedDirtSpritesMod.useGraySprites = false
FixedDirtSpritesMod.useBlackSprites = false
FixedDirtSpritesMod.useRandomSprites = false

--function that sets a random use_____Sprites variable to true
function FixedDirtSpritesMod:setRandomSpriteVariable()
	--reset the vars
	FixedDirtSpritesMod.useDirtSprites = false
	FixedDirtSpritesMod.useWombSprites = false
	FixedDirtSpritesMod.useScarredSprites = false
	FixedDirtSpritesMod.useFloodedSprites = false
	FixedDirtSpritesMod.useBlueSprites = false
	FixedDirtSpritesMod.useDarkSprites = false
	FixedDirtSpritesMod.useGraySprites = false
	FixedDirtSpritesMod.useBlackSprites = false
	
	local randomSprite = piber20HelperMod:getRandomNumber(1, 8)
	if randomSprite == 1 then
		FixedDirtSpritesMod.useDirtSprites = true
	elseif randomSprite == 2 then
		FixedDirtSpritesMod.useWombSprites = true
	elseif randomSprite == 3 then
		FixedDirtSpritesMod.useScarredSprites = true
	elseif randomSprite == 4 then
		FixedDirtSpritesMod.useFloodedSprites = true
	elseif randomSprite == 5 then
		FixedDirtSpritesMod.useBlueSprites = true
	elseif randomSprite == 6 then
		FixedDirtSpritesMod.useDarkSprites = true
	elseif randomSprite == 7 then
		FixedDirtSpritesMod.useGraySprites = true
	elseif randomSprite == 8 then
		FixedDirtSpritesMod.useBlackSprites = true
	end
end

function FixedDirtSpritesMod:setDirtSprite(entity, layer, string, suffixDirt, suffixWomb, suffixScarred, suffixFlooded, suffixBlue, suffixDark, suffixGray, suffixBlack)
	if entity:Exists() then
		if string ~= nil or string ~= "" then
			if layer == nil then
				layer = 0
			end
			if suffixDirt == nil then
				suffixDirt = ""
			end
			if suffixWomb == nil then
				suffixWomb = suffixDirt
			end
			if suffixScarred == nil then
				suffixScarred = suffixWomb
			end
			if suffixFlooded == nil then
				suffixFlooded = suffixDirt
			end
			if suffixBlue == nil then
				suffixBlue = suffixFlooded
			end
			if suffixDark == nil then
				suffixDark = suffixDirt
			end
			if suffixGray == nil then
				suffixGray = suffixDark
			end
			if suffixBlack == nil then
				suffixBlack = suffixGray
			end
			
			local fullPath = "gfx/" .. string
			if FixedDirtSpritesMod.useDirtSprites then
				fullPath = fullPath .. suffixDirt
			elseif FixedDirtSpritesMod.useWombSprites then
				fullPath = fullPath .. suffixWomb
			elseif FixedDirtSpritesMod.useScarredSprites then
				fullPath = fullPath .. suffixScarred
			elseif FixedDirtSpritesMod.useFloodedSprites then
				fullPath = fullPath .. suffixFlooded
			elseif FixedDirtSpritesMod.useBlueSprites then
				fullPath = fullPath .. suffixBlue
			elseif FixedDirtSpritesMod.useDarkSprites then
				fullPath = fullPath .. suffixDark
			elseif FixedDirtSpritesMod.useGraySprites then
				fullPath = fullPath .. suffixGray
			elseif FixedDirtSpritesMod.useBlackSprites then
				fullPath = fullPath .. suffixBlack
			end
			fullPath = fullPath .. ".png"
			
			--no way to check if a file exists... at least none that i know of
			
			local sprite = entity:GetSprite()
			sprite:ReplaceSpritesheet(layer, fullPath)
			sprite:LoadGraphics()
		else
			Isaac.DebugString("[Fixed Dirt Sprites] ERROR: setDirtSprite was called with an empty string")
		end
	else
		Isaac.DebugString("[Fixed Dirt Sprites] ERROR: setDirtSprite was called with an entity that doesn't exist")
	end
end

function FixedDirtSpritesMod:setDirtSpriteLayers(entity, layers, string, suffixDirt, suffixWomb, suffixScarred, suffixFlooded, suffixBlue, suffixDark, suffixGray, suffixBlack)
	if entity:Exists() then
		if string ~= nil or string ~= "" then
			--randomize the sprite
			if FixedDirtSpritesMod.useRandomSprites then
				FixedDirtSpritesMod:setRandomSpriteVariable()
			end
			
			--call the single layer functions
			for layer = 0, layers do
				FixedDirtSpritesMod:setDirtSprite(entity, layer, string, suffixDirt, suffixWomb, suffixScarred, suffixFlooded, suffixBlue, suffixDark, suffixGray, suffixBlack)
			end
		else
			Isaac.DebugString("[Fixed Dirt Sprites] ERROR: setDirtSpriteLayers was called with an empty string")
		end
	else
		Isaac.DebugString("[Fixed Dirt Sprites] ERROR: setDirtSpriteLayers was called with an entity that doesn't exist")
	end
end

--replace dirt sprites with our variants
function FixedDirtSpritesMod:ReplaceDirtSprites(entity)
	if FixedDirtSpritesMod.enabled then
		local type = entity.Type
		local variant = entity.Variant
		local subType = entity.SubType --checking for subtype is a little tricky since some enemies (bosses in particular) use subtypes if it's a champion
		
		--enemies
		if type == EntityType.ENTITY_FRED then --fred
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/classic/monster_197_fred", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_EYE then --eye
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/classic/monster_194_eye", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_LUMP then --lump
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/classic/monster_198_lump", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_NIGHT_CRAWLER then --nightcrawler
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/rebirth/monster_255_nightcrawler", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_PARA_BITE then --parabite
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/classic/monster_199_parabite", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			elseif variant == 1 then --scarred parabite (the womb and scarred versions have different spelling... what the fuck)
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/afterbirth/058.001_scar", "redparabite_dirt", "redparabite", "edparabite_scarred", "redparabite_flooded", "redparabite_blue", "redparabite_dark", "redparabite_gray", "redparabite_black")
			end
		end
		if type == EntityType.ENTITY_ROUND_WORM then --round worm
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/rebirth/monster_244_roundworm", "", "womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			elseif variant == 1 then --tube worm
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/afterbirthplus/tubeworm", "_dirt", "_womb", "_scarred", "", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_ROUNDY then --roundy
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/afterbirth/276.000_roundy", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_ULCER then --ulcer
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "monsters/afterbirth/289.000_ulcer", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--bosses
		if type == EntityType.ENTITY_PIN then --pin
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "bosses/classic/boss_019_pin", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			elseif variant == 1 then --scolex
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "bosses/classic/boss_062_scolex", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			elseif variant == 2 and subType ~= 1 then --the frail
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 4, "bosses/afterbirth/boss_thefrail", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			elseif variant == 2 and subType == 1 then --the frail 2
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 4, "bosses/afterbirth/boss_thefrail2", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_POLYCEPHALUS then --polycephalus
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 1, "bosses/rebirth/polycephalus", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_MR_FRED then --mr. fred
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 1, "bosses/rebirth/megafred", "_dirt", "", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if type == EntityType.ENTITY_STAIN  then --the stain
			if variant == 0 then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 3, "bosses/afterbirth/thestain", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--alphabirth pack 2
		if Isaac.GetEntityTypeByName("3 Eyed Night Crawler") ~= -1 and type == Isaac.GetEntityTypeByName("3 Eyed Night Crawler") then
			if variant == Isaac.GetEntityVariantByName("3 Eyed Night Crawler") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_3eyednightcrawler", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Dip Ulcer") ~= -1 and type == Isaac.GetEntityTypeByName("Dip Ulcer") then
			if variant == Isaac.GetEntityVariantByName("Dip Ulcer") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_dipulcer", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Injured Round Worm") ~= -1 and type == Isaac.GetEntityTypeByName("Injured Round Worm") then
			if variant == Isaac.GetEntityVariantByName("Injured Round Worm") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_injuredroundworm", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Round Worm Trio") ~= -1 and type == Isaac.GetEntityTypeByName("Round Worm Trio") then
			if variant == Isaac.GetEntityVariantByName("Round Worm Trio") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_roundwormtrio", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--alphabirth pack 3
		if Isaac.GetEntityTypeByName("Lil Miner") ~= -1 and type == Isaac.GetEntityTypeByName("Lil Miner") then
			if variant == Isaac.GetEntityVariantByName("Lil Miner") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/familiars/sheet_familiar_lilminer", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--revelations
		if Isaac.GetEntityTypeByName("Smolycephalus") ~= -1 and type == Isaac.GetEntityTypeByName("Smolycephalus") then
			if variant == Isaac.GetEntityVariantByName("Smolycephalus") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 1, "monsters/enemySmolycephalus", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, FixedDirtSpritesMod.ReplaceDirtSprites)
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, FixedDirtSpritesMod.ReplaceDirtSprites)

--post update function
local everyOtherUpdateTicker = false
function FixedDirtSpritesMod:onUpdate()
	if FixedDirtSpritesMod.enabled then
		if Isaac.CountEntities(nil, EntityType.ENTITY_DELIRIUM, -1, -1) > 0 then
			FixedDirtSpritesMod.enabled = true --disable self if delirium is in this room
		end
		
		--forcefully replace tube worm's sprite in the womb, since it doesn't always work from post npc init
		if currentChapter == 4 then
			for _, tubeWorm in pairs(Isaac.FindByType(EntityType.ENTITY_ROUND_WORM, 1, 0, false, false)) do
				local tubeWormSprite = tubeWorm:GetSprite()
				if tubeWormSprite:IsPlaying("Appear") then
					FixedDirtSpritesMod:setDirtSpriteLayers(tubeWorm, 0, "monsters/afterbirthplus/tubeworm", "_dirt", "_womb", "_scarred", "", "_blue", "_dark", "_gray", "_black")
				end
			end
		end
		
		--enemies in the void spawn before room:GetRoomConfigStage() is set
		if currentChapter == 8 then
			local roomFrameCount = Game():GetLevel():GetCurrentRoom():GetFrameCount()
			if roomFrameCount <= 2 then
				for _, entity in pairs(Isaac.GetRoomEntities()) do
					FixedDirtSpritesMod:ReplaceDirtSprites(entity)
				end
			end
		end
		
		--if we're using random sprites, replace the sprites every few frames (which will give an error room effect to the sprites since it's randomized every time)
		if FixedDirtSpritesMod.useRandomSprites then
			if not everyOtherUpdateTicker then
				everyOtherUpdateTicker = true
			else
				everyOtherUpdateTicker = false
				for _, entity in pairs(Isaac.GetRoomEntities()) do
					FixedDirtSpritesMod:ReplaceDirtSprites(entity)
				end
			end
		end
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_UPDATE, FixedDirtSpritesMod.onUpdate)

--update our local vars when the room changes
function FixedDirtSpritesMod:updateVars()
	level = Game():GetLevel()
	room = level:GetCurrentRoom()
	
	local isGreedMode = Game():IsGreedMode()
	local currentStage = level:GetStage()
	local currentStageType = level:GetStageType()
	if isGreedMode then
		currentChapter = currentStage
	else
		if currentStage == 1 or currentStage == 2 then
			currentChapter = 1
		elseif currentStage == 3 or currentStage == 4 then
			currentChapter = 2
		elseif currentStage == 5 or currentStage == 6 then
			currentChapter = 3
		elseif currentStage == 7 or currentStage == 8 then
			currentChapter = 4
		else
			currentChapter = currentStage - 4
		end
	end
	
	FixedDirtSpritesMod.enabled = true
	FixedDirtSpritesMod.useDirtSprites = false
	FixedDirtSpritesMod.useWombSprites = false
	FixedDirtSpritesMod.useScarredSprites = false
	FixedDirtSpritesMod.useFloodedSprites = false
	FixedDirtSpritesMod.useBlueSprites = false
	FixedDirtSpritesMod.useDarkSprites = false
	FixedDirtSpritesMod.useGraySprites = false
	FixedDirtSpritesMod.useBlackSprites = false
	FixedDirtSpritesMod.useRandomSprites = false
	
	--custom stages workaround
	if StageSystem then
		if StageSystem.GetCurrentStage() ~= 0 then
			FixedDirtSpritesMod.enabled = false --so we don't overwrite any custom stage sprites
		end
	end
	
	--use dirt sprites based on the backdrop
	local keepFloodedSprites = false
	local keepWombSprites = false
	local backdrop = piber20HelperMod:getCurrentBackdrop()
	if backdrop == piber20HelperBackdrop.BASEMENT or backdrop == piber20HelperBackdrop.CELLAR or backdrop == piber20HelperBackdrop.BURNING_BASEMENT or backdrop == piber20HelperBackdrop.CAVES or backdrop == piber20HelperBackdrop.CATACOMBS or backdrop == piber20HelperBackdrop.CHEST or backdrop == piber20HelperBackdrop.MEGA_SATAN or backdrop == piber20HelperBackdrop.LIBRARY or backdrop == piber20HelperBackdrop.SHOP or backdrop == piber20HelperBackdrop.ISAACS_ROOM or backdrop == piber20HelperBackdrop.ARCADE or backdrop == piber20HelperBackdrop.ULTRA_GREED then
		FixedDirtSpritesMod.useDirtSprites = true
	elseif backdrop == piber20HelperBackdrop.FLOODED_CAVES then
		FixedDirtSpritesMod.useFloodedSprites = true
		keepFloodedSprites = true
	elseif backdrop == piber20HelperBackdrop.DEPTHS or backdrop == piber20HelperBackdrop.DANK_DEPTHS then
		FixedDirtSpritesMod.useGraySprites = true
	elseif backdrop == piber20HelperBackdrop.NECROPOLIS or backdrop == piber20HelperBackdrop.SECRET_ROOM or backdrop == piber20HelperBackdrop.BARREN_ROOM then
		FixedDirtSpritesMod.useDarkSprites = true
	elseif backdrop == piber20HelperBackdrop.WOMB or backdrop == piber20HelperBackdrop.UTERO then
		FixedDirtSpritesMod.useWombSprites = true
		keepWombSprites = true
	elseif backdrop == piber20HelperBackdrop.SCARRED_WOMB then
		FixedDirtSpritesMod.useScarredSprites = true
	elseif backdrop == piber20HelperBackdrop.BLUE_WOMB then
		FixedDirtSpritesMod.useBlueSprites = true
	elseif backdrop == piber20HelperBackdrop.SHEOL or backdrop == piber20HelperBackdrop.DARK_ROOM then
		FixedDirtSpritesMod.useBlackSprites = true
	elseif backdrop == piber20HelperBackdrop.CATHEDRAL or backdrop == piber20HelperBackdrop.BLUE_SECRET then
		FixedDirtSpritesMod.useFloodedSprites = true
	elseif backdrop == piber20HelperBackdrop.DICE_ROOM then
		FixedDirtSpritesMod.useWombSprites = true
	elseif backdrop == piber20HelperBackdrop.ERROR_ROOM then
		FixedDirtSpritesMod.useRandomSprites = true
	end
	
	if FixedDirtSpritesMod.BasicMode then
		if FixedDirtSpritesMod.useFloodedSprites then
			if not keepFloodedSprites then
				FixedDirtSpritesMod.useFloodedSprites = false
				FixedDirtSpritesMod.useDirtSprites = true
			end
		elseif FixedDirtSpritesMod.useWombSprites then
			if not keepWombSprites then
				FixedDirtSpritesMod.useWombSprites = false
				FixedDirtSpritesMod.useDirtSprites = true
			end
		elseif FixedDirtSpritesMod.useBlueSprites then
			FixedDirtSpritesMod.useBlueSprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		elseif FixedDirtSpritesMod.useDarkSprites then
			FixedDirtSpritesMod.useDarkSprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		elseif FixedDirtSpritesMod.useGraySprites then
			FixedDirtSpritesMod.useGraySprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		elseif FixedDirtSpritesMod.useBlackSprites then
			FixedDirtSpritesMod.useBlackSprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		elseif FixedDirtSpritesMod.useRandomSprites then
			FixedDirtSpritesMod.useRandomSprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		end
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FixedDirtSpritesMod.updateVars)