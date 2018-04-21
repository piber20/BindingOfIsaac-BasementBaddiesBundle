FixedDirtSpritesMod = RegisterMod("Fixed Dirt Sprites", 1)
FixedDirtSpritesMod.enabled = true

--save data
local json = require("json")
FixedDirtSpritesMod.Data = {
	enabled = true, --controls if the mod will replace sprites. overwrites the FixedDirtSpritesMod.enabled value above if set to false
	basicMode = false, --if basic mode is active, only dirt, womb, scarred, and flooded sprites will be used, and flooded sprites will only be used in flooded caves. dirt sprites also will not be specific to room types.
	errorRandom = true, --if this is set to false, dirt sprites will not be randomized in the error room.
}

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

if not rnghelpermod then
	rnghelpermod = RegisterMod("piber20's RNG helper stuff", 1)
	rnghelpermod.newRNG = RNG()
	function rnghelpermod:updateNewRNGSeed()
		local seed = Game():GetSeeds():GetStartSeed()
		if seed ~= 0 then
			rnghelpermod.newRNG:SetSeed(seed, 1)
		end
	end
	rnghelpermod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, rnghelpermod.updateNewRNGSeed)
	function rnghelpermod:getRandomNumber(min, max)
		local num = nil
		if min ~= nil and max ~= nil then -- Min and max passed, integer [min,max]
			num = math.floor(rnghelpermod.newRNG:RandomFloat() * (max - min + 1) + min)
		elseif min ~= nil then -- Only min passed, integer [0,min]
			num = math.floor(rnghelpermod.newRNG:RandomFloat() * (min + 1))
		else -- float [0,1)
			num = rnghelpermod.newRNG:RandomFloat()
		end
		return num
	end
end
local function getRandomNumber(min, max)
	local num = rnghelpermod:getRandomNumber(min, max)
	return num
end

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
	
	local randomSprite = getRandomNumber(1, 8)
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
		if Isaac.GetEntityTypeByName("3 Eyed Night Crawler") ~= 0 and type == Isaac.GetEntityTypeByName("3 Eyed Night Crawler") then
			if variant == Isaac.GetEntityVariantByName("3 Eyed Night Crawler") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_3eyednightcrawler", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Dip Ulcer") ~= 0 and type == Isaac.GetEntityTypeByName("Dip Ulcer") then
			if variant == Isaac.GetEntityVariantByName("Dip Ulcer") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_dipulcer", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Injured Round Worm") ~= 0 and type == Isaac.GetEntityTypeByName("Injured Round Worm") then
			if variant == Isaac.GetEntityVariantByName("Injured Round Worm") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_injuredroundworm", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		if Isaac.GetEntityTypeByName("Round Worm Trio") ~= 0 and type == Isaac.GetEntityTypeByName("Round Worm Trio") then
			if variant == Isaac.GetEntityVariantByName("Round Worm Trio") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/enemies/sheet_enemy_roundwormtrio", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--alphabirth pack 3
		if Isaac.GetEntityTypeByName("Lil Miner") ~= 0 and type == Isaac.GetEntityTypeByName("Lil Miner") then
			if variant == Isaac.GetEntityVariantByName("Lil Miner") then
				FixedDirtSpritesMod:setDirtSpriteLayers(entity, 0, "animations/familiars/sheet_familiar_lilminer", "", "_womb", "_scarred", "_flooded", "_blue", "_dark", "_gray", "_black")
			end
		end
		--revelations
		if Isaac.GetEntityTypeByName("Smolycephalus") ~= 0 and type == Isaac.GetEntityTypeByName("Smolycephalus") then
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
	
	FixedDirtSpritesMod.enabled = FixedDirtSpritesMod.Data.enabled
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
	
	--default rooms/floors
	local keepFloodedSprites = false
	local roomType = room:GetType() --if basic mode is enabled, these rooms will use the floor's own dirt sprites instead of being room-specific. this matches default game behavior i believe
	if not FixedDirtSpritesMod.Data.basicMode and (roomType == RoomType.ROOM_SHOP or roomType == RoomType.ROOM_LIBRARY or roomType == RoomType.ROOM_DUNGEON or roomType == RoomType.ROOM_ISAACS or roomType == RoomType.ROOM_CHEST or roomType == RoomType.ROOM_SUPERSECRET) then
		FixedDirtSpritesMod.useDirtSprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and (roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_BARREN) then
		FixedDirtSpritesMod.useDarkSprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and (roomType == RoomType.ROOM_SACRIFICE or roomType == RoomType.ROOM_ARCADE) then
		FixedDirtSpritesMod.useGraySprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and (roomType == RoomType.ROOM_CURSE or roomType == RoomType.ROOM_CHALLENGE or roomType == RoomType.ROOM_DEVIL or roomType == RoomType.ROOM_BOSSRUSH or roomType == RoomType.ROOM_BLACK_MARKET) then
		FixedDirtSpritesMod.useBlackSprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and roomType == RoomType.ROOM_DICE then
		FixedDirtSpritesMod.useWombSprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and roomType == RoomType.ROOM_ANGEL then
		FixedDirtSpritesMod.useFloodedSprites = true
	elseif not FixedDirtSpritesMod.Data.basicMode and roomType == RoomType.ROOM_ERROR then
		FixedDirtSpritesMod.useRandomSprites = true
	elseif isGreedMode then
		if currentChapter == 1 then --basement
			FixedDirtSpritesMod.useDirtSprites = true
		elseif currentChapter == 2 then --caves
			FixedDirtSpritesMod.useDirtSprites = true
		elseif currentChapter == 3 then --depths
			FixedDirtSpritesMod.useGraySprites = true
		elseif currentChapter == 4 then --womb
			FixedDirtSpritesMod.useWombSprites = true
		elseif currentChapter == 5 then --sheol
			FixedDirtSpritesMod.useBlackSprites = true
		elseif currentChapter == 6 then --shop
			FixedDirtSpritesMod.useDirtSprites = true
		elseif currentChapter == 7 then --ultra greed
			FixedDirtSpritesMod.useDirtSprites = true
		end
	else
		if currentChapter == 1 then --basement/cellar/burning basement
			FixedDirtSpritesMod.useDirtSprites = true
		elseif currentChapter == 2 then
			if currentStageType == 2 then --flooded caves
				FixedDirtSpritesMod.useFloodedSprites = true
				keepFloodedSprites = true
			else --caves/catacombs
				FixedDirtSpritesMod.useDirtSprites = true
			end
		elseif currentChapter == 3 then
			if currentStageType == 1 then --necropolis
				FixedDirtSpritesMod.useDarkSprites = true
			else --depths/dank depths
				FixedDirtSpritesMod.useGraySprites = true
			end
		elseif currentChapter == 4 then
			if currentStageType == 2 then --scarred womb
				FixedDirtSpritesMod.useScarredSprites = true
			else --womb/utero
				FixedDirtSpritesMod.useWombSprites = true
			end
		elseif currentChapter == 5 then --blue womb
			FixedDirtSpritesMod.useBlueSprites = true
		elseif currentChapter == 6 then
			if currentStageType == 1 then --cathedral
				FixedDirtSpritesMod.useFloodedSprites = true
			else --sheol
				FixedDirtSpritesMod.useBlackSprites = true
			end
		elseif currentChapter == 7 then
			if currentStageType == 1 then --chest
				FixedDirtSpritesMod.useDirtSprites = true
			else --dark room
				FixedDirtSpritesMod.useBlackSprites = true
			end
		elseif currentChapter == 8 then --the void
			if roomType == RoomType.ROOM_DEFAULT then
				local roomStage = room:GetRoomConfigStage()
				if roomStage == 1 then --basement?
					FixedDirtSpritesMod.useDirtSprites = true
				elseif roomStage == 2 then --cellar?
					FixedDirtSpritesMod.useDirtSprites = true
				elseif roomStage == 3 then --burning basement?
					FixedDirtSpritesMod.useDirtSprites = true
				elseif roomStage == 4 then --caves?
					FixedDirtSpritesMod.useDirtSprites = true
				elseif roomStage == 5 then --catacombs?
					FixedDirtSpritesMod.useDirtSprites = true
				elseif roomStage == 6 then --flooded caves?
					FixedDirtSpritesMod.useFloodedSprites = true
					keepFloodedSprites = true
				elseif roomStage == 7 then --depths?
					FixedDirtSpritesMod.useGraySprites = true
				elseif roomStage == 8 then --necropolis?
					FixedDirtSpritesMod.useDarkSprites = true
				elseif roomStage == 9 then --dank depths?
					FixedDirtSpritesMod.useGraySprites = true
				elseif roomStage == 10 then --womb?
					FixedDirtSpritesMod.useWombSprites = true
				elseif roomStage == 11 then --utero?
					FixedDirtSpritesMod.useWombSprites = true
				elseif roomStage == 12 then --scarred womb?
					FixedDirtSpritesMod.useScarredSprites = true
				elseif roomStage == 13 then --blue womb?
					FixedDirtSpritesMod.useBlueSprites = true
				elseif roomStage == 14 then --sheol?
					FixedDirtSpritesMod.useBlackSprites = true
				elseif roomStage == 15 then --cathedral?
					FixedDirtSpritesMod.useFloodedSprites = true
				elseif roomStage == 16 then --dark room?
					FixedDirtSpritesMod.useBlackSprites = true
				elseif roomStage == 17 then --chest?
					FixedDirtSpritesMod.useDirtSprites = true
				else
					FixedDirtSpritesMod.enabled = false
				end
			else
				FixedDirtSpritesMod.enabled = false
			end
		else
			FixedDirtSpritesMod.enabled = false
		end
	end
	
	if FixedDirtSpritesMod.Data.basicMode then
		if FixedDirtSpritesMod.useFloodedSprites then
			if not keepFloodedSprites then
				FixedDirtSpritesMod.useFloodedSprites = false
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
		end
	end
	
	if not FixedDirtSpritesMod.Data.errorRandom then
		if FixedDirtSpritesMod.useRandomSprites then
			FixedDirtSpritesMod.useRandomSprites = false
			FixedDirtSpritesMod.useDirtSprites = true
		end
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, FixedDirtSpritesMod.updateVars)

--CONFIGURATION, use the ingame console and type "dirtsprites"
function FixedDirtSpritesMod:consoleConfig(command, arguments)
	--nicalis pls add an options menu for mods
	
	command = command:lower()
	if command == "dirtsprites" then
		arguments = arguments:lower()
		
		--valid setting check
		local enabled = arguments:find("enabled")
		if enabled == nil then
			enabled = 0
		end
		local basicMode = arguments:find("basicmode")
		if basicMode == nil then
			basicMode = 0
		end
		local errorRandom = arguments:find("errorrandom")
		if errorRandom == nil then
			errorRandom = 0
		end
		local resetToDefault = arguments:find("resettodefault")
		if resetToDefault == nil then
			resetToDefault = 0
		end
		local currentSettings = arguments:find("currentsettings")
		if currentSettings == nil then
			currentSettings = 0
		end
		local isValidArg = false
		if enabled == 1 or basicMode == 1 or errorRandom == 1 or resetToDefault == 1 or currentSettings == 1 then
			isValidArg = true
		end
		
		if isValidArg then
			if enabled == 1 then
				arguments = arguments:sub(9, 9)
				if arguments == "t" then
					arguments = "1"
				elseif arguments == "f" then
					arguments = "0"
				end
				
				arguments = tonumber(arguments)
				if arguments ~= nil then
					arguments = arguments - 0.5
					arguments = math.ceil(arguments)
					
					if arguments >= 1 then
						arguments = true
					else
						arguments = false
					end
					
					FixedDirtSpritesMod.Data.enabled = arguments
					FixedDirtSpritesMod:SaveData(json.encode(FixedDirtSpritesMod.Data))
					Isaac.ConsoleOutput("Set enabled setting to " .. tostring(arguments))
				else
					Isaac.ConsoleOutput("Invalid input. Type true or false.")
				end
			elseif basicMode == 1 then
				arguments = arguments:sub(11, 11)
				if arguments == "t" then
					arguments = "1"
				elseif arguments == "f" then
					arguments = "0"
				end
				
				arguments = tonumber(arguments)
				if arguments ~= nil then
					arguments = arguments - 0.5
					arguments = math.ceil(arguments)
					
					if arguments >= 1 then
						arguments = true
					else
						arguments = false
					end
					
					FixedDirtSpritesMod.Data.basicMode = arguments
					FixedDirtSpritesMod:SaveData(json.encode(FixedDirtSpritesMod.Data))
					Isaac.ConsoleOutput("Set basicMode setting to " .. tostring(arguments))
				else
					Isaac.ConsoleOutput("Invalid input. Type true or false.")
				end
			elseif errorRandom == 1 then
				arguments = arguments:sub(13, 13)
				if arguments == "t" then
					arguments = "1"
				elseif arguments == "f" then
					arguments = "0"
				end
				
				arguments = tonumber(arguments)
				if arguments ~= nil then
					arguments = arguments - 0.5
					arguments = math.ceil(arguments)
					
					if arguments >= 1 then
						arguments = true
					else
						arguments = false
					end
					
					FixedDirtSpritesMod.Data.errorRandom = arguments
					FixedDirtSpritesMod:SaveData(json.encode(FixedDirtSpritesMod.Data))
					Isaac.ConsoleOutput("Set errorRandom setting to " .. tostring(arguments))
				else
					Isaac.ConsoleOutput("Invalid input. Type true or false.")
				end
			elseif resetToDefault == 1 then
				FixedDirtSpritesMod.Data.enabled = true
				FixedDirtSpritesMod.Data.basicMode = false
				FixedDirtSpritesMod.Data.errorRandom = true
				FixedDirtSpritesMod:SaveData(json.encode(FixedDirtSpritesMod.Data))
				Isaac.ConsoleOutput("Reset all settings to default.")
			elseif currentSettings == 1 then
				Isaac.ConsoleOutput("Current settings:")
				Isaac.ConsoleOutput("enabled = " .. tostring(FixedDirtSpritesMod.Data.enabled))
				Isaac.ConsoleOutput("basicMode = " .. tostring(FixedDirtSpritesMod.Data.basicMode))
				Isaac.ConsoleOutput("errorRandom = " .. tostring(FixedDirtSpritesMod.Data.errorRandom))
			end
		else
			Isaac.ConsoleOutput("Fixed Dirt Sprites console commands:")
			Isaac.ConsoleOutput("dirtsprites enabled [true or false]")
			Isaac.ConsoleOutput("dirtsprites basicMode [true or false]")
			Isaac.ConsoleOutput("dirtsprites errorRandom [true or false]")
			Isaac.ConsoleOutput("dirtsprites resetToDefault")
			Isaac.ConsoleOutput("dirtsprites currentSettings")
		end
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, FixedDirtSpritesMod.consoleConfig)

function FixedDirtSpritesMod:onGameStart(isSaveGame)
	if FixedDirtSpritesMod:HasData() then
		local loadData = json.decode(FixedDirtSpritesMod:LoadData())
		
		if loadData.enabled ~= nil then
			FixedDirtSpritesMod.Data.enabled = loadData.enabled
		end
		if loadData.basicMode ~= nil then
			FixedDirtSpritesMod.Data.basicMode = loadData.basicMode
		end
		if loadData.errorRandom ~= nil then
			FixedDirtSpritesMod.Data.errorRandom = loadData.errorRandom
		end
		
		FixedDirtSpritesMod:SaveData(json.encode(FixedDirtSpritesMod.Data))
	end
end
FixedDirtSpritesMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FixedDirtSpritesMod.onGameStart)