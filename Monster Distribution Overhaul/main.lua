MonsterDistributionOverhaulMod = RegisterMod("Monster Distribution Overhaul", 1)

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

--get local vars set up, these change when the room changes
local currentStage = 1
local currentStageType = 0
local isGreedMode = Game():IsGreedMode()
local isBossRoom = false
local isVoid = false
local foundHush = false
local foundUltraGreed = false
local foundRagBoss = false
local foundBrownieBoss = false

function MonsterDistributionOverhaulMod:preEntitySpawn(type, variant, subType, position, velocity, spawner, seed)
	local returnOurselves = false
	local originalType = type
	local originalVariant = variant
	local originalSubType = subType
	
	if type == EntityType.ENTITY_STONEY then
		if MonsterDistributionOverhaulMod.RevertAfterbirthPlusReplacements then
			--replace stoneys
			local replaceStonies = true
			if isVoid then
				if MonsterDistributionOverhaulMod.AllowStoneysInTheVoid then
					replaceStonies = false
				end
			elseif MonsterDistributionOverhaulMod.AllowStoneys then
				replaceStonies = false
			end
			if replaceStonies then
				local currentStage = piber20HelperMod:getCurrentStage()
				
				--defaults (basement)
				returnOurselves = true
				type = EntityType.ENTITY_ATTACKFLY
				variant = 0
				subType = 0
				
				if currentStage == piber20HelperStage.CELLAR then
					type = EntityType.ENTITY_SPIDER
				elseif currentStage == piber20HelperStage.BURNING_BASEMENT then
					type = EntityType.ENTITY_GAPER --flaming gaper
					variant = 2
				elseif currentStage == piber20HelperStage.FLOODED_CAVES then
					type = EntityType.ENTITY_CHARGER --drowned charger
					variant = 1
				elseif currentStage == piber20HelperStage.DEPTHS or currentStage == piber20HelperStage.NECROPOLIS or currentStage == piber20HelperStage.DANK_DEPTHS then
					type = EntityType.ENTITY_FATTY --pale fatty
					variant = 1
				elseif currentStage == piber20HelperStage.WOMB or currentStage == piber20HelperStage.UTERO or currentStage == piber20HelperStage.SCARRED_WOMB then
					type = EntityType.ENTITY_LUMP
				elseif currentStage == piber20HelperStage.BLUE_WOMB then
					type = EntityType.ENTITY_HUSH_FLY
				elseif currentStage == piber20HelperStage.SHEOL then
					type = EntityType.ENTITY_NULLS
				elseif currentStage == piber20HelperStage.CATHEDRAL then
					type = EntityType.ENTITY_BABY
				elseif currentStage == piber20HelperStage.DARK_ROOM then
					type = EntityType.ENTITY_NULLS
				elseif currentStage == piber20HelperStage.CHEST then
					type = EntityType.ENTITY_FATTY --pale fatty
					variant = 1
				end
			end
		end
	elseif type == EntityType.ENTITY_PORTAL then
		--replace portals
		local replacePortals = true
		if isVoid then
			if MonsterDistributionOverhaulMod.AllowPortalsInTheVoid then
				replacePortals = false
			end
		elseif MonsterDistributionOverhaulMod.AllowPortals then
			replacePortals = false
		end
		if replacePortals then
			local currentStage = piber20HelperMod:getCurrentStage()
				
			--defaults (basement)
			returnOurselves = true
			type = EntityType.ENTITY_SWARM
			variant = 0
			subType = 0
			
			if currentStage == piber20HelperStage.CELLAR then
				type = EntityType.ENTITY_BOIL --sack
				variant = 2
			elseif currentStage == piber20HelperStage.BURNING_BASEMENT then
				type = EntityType.ENTITY_FATTY --flaming fatty
				variant = 2
			elseif currentStage == piber20HelperStage.CAVES or currentStage == piber20HelperStage.CATACOMBS then
				type = EntityType.ENTITY_HIVE
			elseif currentStage == piber20HelperStage.FLOODED_CAVES then
				type = EntityType.ENTITY_HIVE --drowned hive
				variant = 1
			elseif currentStage == piber20HelperStage.DEPTHS or currentStage == piber20HelperStage.NECROPOLIS or currentStage == piber20HelperStage.DANK_DEPTHS then
				type = EntityType.ENTITY_FAT_SACK
			elseif currentStage == piber20HelperStage.WOMB or currentStage == piber20HelperStage.UTERO or currentStage == piber20HelperStage.SCARRED_WOMB then
				type = EntityType.ENTITY_HOST --flesh host
				variant = 1
			elseif currentStage == piber20HelperStage.BLUE_WOMB then
				type = EntityType.ENTITY_HUSH_GAPER
			elseif currentStage == piber20HelperStage.SHEOL then
				type = EntityType.ENTITY_IMP
			elseif currentStage == piber20HelperStage.CATHEDRAL then
				type = EntityType.ENTITY_BABY --angelic baby
				variant = 1
			elseif currentStage == piber20HelperStage.DARK_ROOM then
				type = EntityType.ENTITY_IMP
			elseif currentStage == piber20HelperStage.CHEST then
				type = EntityType.ENTITY_DINGA
			end
		end
	end
	
	--return our new data
	if returnOurselves then
		local message = "Replacing " .. originalType .. "." .. originalVariant .. "." .. originalSubType .. " with " .. type .. "." .. variant .. "." .. subType .. " in entity spawn"
		if MonsterDistributionOverhaulMod.ReportReplacementsToLog then
			Isaac.DebugString(message)
		end
		if MonsterDistributionOverhaulMod.ReportReplacementsToConsole then
			Isaac.ConsoleOutput(message)
		end
		local newData = {
			type,
			variant,
			subType,
			seed
		}
		return newData
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, MonsterDistributionOverhaulMod.preEntitySpawn)

function MonsterDistributionOverhaulMod:preRoomEntitySpawn(type, variant, subType, gridIndex, seed)
	local currentBackdrop = piber20HelperMod:getCurrentBackdrop()
	
	local returnOurselves = false
	local originalType = type
	local originalVariant = variant
	local originalSubType = subType
	
	--disable ab+ replacements
	if MonsterDistributionOverhaulMod.RevertAfterbirthPlusReplacements then
		--anti blister
		if type == EntityType.ENTITY_KEEPER or type == EntityType.ENTITY_TICKING_SPIDER then
			returnOurselves = true
		--anti mushroom
		elseif type == EntityType.ENTITY_HOST then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				local currentStage = piber20HelperMod:getCurrentStage()
				if currentStage == piber20HelperStage.CAVES or currentStage == piber20HelperStage.CATACOMBS or currentStage == piber20HelperStage.FLOODED_CAVES then
					if piber20HelperMod:getRandomNumber(1, 40, seed) == 1 then
						returnOurselves = false
					end
				end
			end
		--anti ministro
		elseif type == EntityType.ENTITY_HOPPER then
			returnOurselves = true
		--anti nerve ending 2
		elseif type == EntityType.ENTITY_NERVE_ENDING and variant == 0 then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				if piber20HelperMod:getRandomNumber(1, 40, seed) == 1 then
					returnOurselves = false
				end
			end
		--anti poison mind
		elseif type == EntityType.ENTITY_BRAIN then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				if piber20HelperMod:getRandomNumber(1, 40, seed) == 1 then
					returnOurselves = false
				end
			end
		--anti stoney
		elseif type == EntityType.ENTITY_FATTY and variant == 1 then
			returnOurselves = true
		--anti the thing
		elseif type == EntityType.ENTITY_WALL_CREEP or type == EntityType.ENTITY_RAGE_CREEP or type == EntityType.ENTITY_BLIND_CREEP then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				if piber20HelperMod:getRandomNumber(1, 60, seed) == 1 then
					returnOurselves = false
				end
			end
		end
	end

	--replace stuff when we're in a shop room
	if currentBackdrop == piber20HelperBackdrop.SHOP and not isGreedMode then
		if type == EntityType.ENTITY_KEEPER and variant == 0 then --replace keeper with spider
			returnOurselves = true
			type = EntityType.ENTITY_SPIDER
			variant = 0
			subType = 0
		end
	end
	
	--replace flaming enemies with normal ones if we're not in the burning basement
	if currentBackdrop ~= piber20HelperBackdrop.BURNING_BASEMENT then
		if type == EntityType.ENTITY_GAPER and variant == 2 then --replace flaming gapers with normal gapers
			returnOurselves = true
			type = EntityType.ENTITY_GAPER
			variant = 1
			subType = 0
		end
		if type == EntityType.ENTITY_FATTY and variant == 2 then --replace flaming fatties with normal fatties
			returnOurselves = true
			type = EntityType.ENTITY_FATTY
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_SKINNY and variant == 2 then --replace crispys with skinnys
			returnOurselves = true
			type = EntityType.ENTITY_SKINNY
			variant = 0
			subType = 0
		end
	end
	
	--replace drowned enemies with normal ones if we're not in the flooded caves
	if currentBackdrop ~= piber20HelperBackdrop.FLOODED_CAVES then
		if type == EntityType.ENTITY_BOOMFLY and variant == 2 then --replace drowned boom flies with normal boom flies
			returnOurselves = true
			type = EntityType.ENTITY_BOOMFLY
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_HIVE and variant == 1 then --replace drowned hives with normal hives
			returnOurselves = true
			type = EntityType.ENTITY_HIVE
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_CHARGER and variant == 1 then --replace drowned chargers with normal chargers
			returnOurselves = true
			type = EntityType.ENTITY_CHARGER
			variant = 0
			subType = 0
		end
	end
	
	--replace dank enemies with normal ones if we're not in the dank depths
	if currentBackdrop ~= piber20HelperBackdrop.DANK_DEPTHS then
		if type == EntityType.ENTITY_GLOBIN and variant == 2 then --replace dank globin with normal globin
			returnOurselves = true
			type = EntityType.ENTITY_GLOBIN
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_TARBOY and variant == 0 then --replace tar boy with nightcrawler
			returnOurselves = true
			type = EntityType.ENTITY_NIGHT_CRAWLER
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_GUSH and variant == 0 then --replace gush with sack
			returnOurselves = true
			type = EntityType.ENTITY_BOIL
			variant = 2
			subType = 0
		end
		if type == EntityType.ENTITY_SQUIRT and variant == 1 then --replace dank squirt with normal squirt
			returnOurselves = true
			type = EntityType.ENTITY_SQUIRT
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_CHARGER and variant == 2 then --replace dank chargers with normal chargers
			returnOurselves = true
			type = EntityType.ENTITY_CHARGER
			variant = 0
			subType = 0
		end
	end
	
	--replace scarred enemies with normal ones if we're not in the scarred womb
	if currentBackdrop ~= piber20HelperBackdrop.SCARRED_WOMB then
		if type == EntityType.ENTITY_GUTS and variant == 1 then --replace scarred guts with normal guts
			returnOurselves = true
			type = EntityType.ENTITY_GUTS
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_VIS and variant == 3 then --replace scarred double vis with normal double vis
			returnOurselves = true
			type = EntityType.ENTITY_VIS
			variant = 1
			subType = 0
		end
	end
	
	--replace some womb enemies with normal ones if we're not in any womb chapters
	if currentBackdrop ~= piber20HelperBackdrop.UTERO and currentBackdrop ~= piber20HelperBackdrop.WOMB and currentBackdrop ~= piber20HelperBackdrop.SCARRED_WOMB then
		if type == EntityType.ENTITY_FLESH_DEATHS_HEAD and variant == 0 then --replace flesh death's head with normal death's head
			returnOurselves = true
			type = EntityType.ENTITY_DEATHS_HEAD
			variant = 0
			subType = 0
		end
		if type == EntityType.ENTITY_RED_GHOST and variant == 0 then --replace red ghost with normal wizoob
			returnOurselves = true
			type = EntityType.ENTITY_WIZOOB
			variant = 0
			subType = 0
		end
	end
	
	--do ab+ replacements in a better way
	if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
		--Ministro
		if type == EntityType.ENTITY_CLOTTY then
			if variant ~= 1 then --no clots
				local chance = 300
				if variant == 2 then --i blob
					chance = 50
				end
				if piber20HelperMod:getRandomNumber(1, chance, seed) == 1 then
					returnOurselves = true
					type = EntityType.ENTITY_MINISTRO
					variant = 0
					subType = 0
				end
			end
		end
		--Blister
		local currentStage = piber20HelperMod:getCurrentStage()
		if currentStage > 2 then
			if type == EntityType.ENTITY_HOPPER and variant == 1 then
				local chance = 200
				if currentStage > 4 then
					chance = 35
				end
				if piber20HelperMod:getRandomNumber(1, chance, seed) == 1 then
					returnOurselves = true
					type = EntityType.ENTITY_BLISTER
					variant = 0
					subType = 0
				end
			end
		end
	end
	
	--force some normal enemies to be the alt floor versions if the player is in the alt floor
	if MonsterDistributionOverhaulMod.ForceAfterbirthFloorAlts then
		if currentBackdrop == piber20HelperBackdrop.FLOODED_CAVES then
			if type == EntityType.ENTITY_BOOMFLY and (variant == 1 or variant == 2) then
				returnOurselves = true
				type = EntityType.ENTITY_BOOMFLY
				variant = 2
				subType = 0
			end
			if type == EntityType.ENTITY_HIVE and variant == 0 then
				returnOurselves = true
				type = EntityType.ENTITY_HIVE
				variant = 1
				subType = 0
			end
			if type == EntityType.ENTITY_CHARGER and (variant == 0 or variant == 2) then
				returnOurselves = true
				type = EntityType.ENTITY_CHARGER
				variant = 1
				subType = 0
			end
		end
		if currentBackdrop == piber20HelperBackdrop.DANK_DEPTHS then
			if type == EntityType.ENTITY_GLOBIN and variant == 0 then
				returnOurselves = true
				type = EntityType.ENTITY_GLOBIN
				variant = 2
				subType = 0
			end
			if type == EntityType.ENTITY_CHARGER and (variant == 0 or variant == 1) then
				returnOurselves = true
				type = EntityType.ENTITY_CHARGER
				variant = 2
				subType = 0
			end
		end
	end
	
	--return our new data
	if returnOurselves then
		local message = "Replacing " .. originalType .. "." .. originalVariant .. "." .. originalSubType .. " with " .. type .. "." .. variant .. "." .. subType .. " in room spawn"
		if MonsterDistributionOverhaulMod.ReportReplacementsToLog then
			Isaac.DebugString(message)
		end
		if MonsterDistributionOverhaulMod.ReportReplacementsToConsole then
			Isaac.ConsoleOutput(message)
		end
		local newData = {
			type,
			variant,
			subType
		}
		return newData
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, MonsterDistributionOverhaulMod.preRoomEntitySpawn)

--replace enemies with stuff we want
function MonsterDistributionOverhaulMod:replaceEnemies(fromNewRoom)
	if fromNewRoom == nil then
		fromNewRoom = false
	end

	--replace stuff when we're not in greed mode and ultra greed isnt here
	if not isGreedMode then
		if not foundUltraGreed then
			for _, greedGaper in pairs(Isaac.FindByType(EntityType.ENTITY_GREED_GAPER, 0, -1, false, true)) do --replace greed gaper with attack fly
				piber20HelperMod:replaceEntity(greedGaper, EntityType.ENTITY_ATTACKFLY, 0, 0, true)
			end
		end
	end
	
	--replace stuff when we're not in a boss room and certain bosses aren't here
	if not isBossRoom then
		if not foundRagBoss then
			for _, ragManRagLing in pairs(Isaac.FindByType(EntityType.ENTITY_RAGLING, 1, -1, false, true)) do --replace rag man's ragling with normal ragling
				piber20HelperMod:replaceEntity(ragManRagLing, EntityType.ENTITY_RAGLING, 0, 0, true)
			end
		end
		if not foundBrownieBoss then
			for _, brownieCornDip in pairs(Isaac.FindByType(EntityType.ENTITY_DIP, 2, -1, false, true)) do --replace brownie corn dip with normal corn dip
				piber20HelperMod:replaceEntity(brownieCornDip, EntityType.ENTITY_DIP, 1, 0, true)
			end
		end
	end

	--replace stuff when we're not in the hush floor
	if currentBackdrop ~= piber20HelperBackdrop.BLUE_WOMB then
		if not foundHush then
			for _, hushGaper in pairs(Isaac.FindByType(EntityType.ENTITY_HUSH_GAPER, 0, -1, false, true)) do --replace hush gaper with normal gaper
				piber20HelperMod:replaceEntity(hushGaper, EntityType.ENTITY_GAPER, 1, 0, true)
			end
			for _, hushFly in pairs(Isaac.FindByType(EntityType.ENTITY_HUSH_FLY, 0, -1, false, true)) do --replace hush fly with ring fly
				piber20HelperMod:replaceEntity(hushFly, EntityType.ENTITY_RING_OF_FLIES, 0, 0, true)
			end
			for _, hushBoil in pairs(Isaac.FindByType(EntityType.ENTITY_HUSH_BOIL, 0, -1, false, true)) do --replace hush boil with normal boil
				piber20HelperMod:replaceEntity(hushBoil, EntityType.ENTITY_BOIL, 0, 0, true)
			end
		end
	end
end

--sets boss found variables based amount of boss entities
function MonsterDistributionOverhaulMod:setFoundBossVariable()
	if Isaac.CountEntities(nil, EntityType.ENTITY_HUSH, -1, -1) > 0 then
		foundHush = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_ULTRA_GREED, -1, -1) > 0 then
		foundUltraGreed = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_RAG_MAN, -1, -1) > 0 then
		foundRagBoss = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_RAG_MEGA, -1, -1) > 0 then
		foundRagBoss = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_DINGLE, 1, -1) > 0 then --dangle
		foundBrownieBoss = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_BROWNIE, -1, -1) > 0 then
		foundBrownieBoss = true
	end
	if Isaac.CountEntities(nil, EntityType.ENTITY_GURGLING, 2, -1) > 0 then --turdling
		foundBrownieBoss = true
	end
end

--call our function
function MonsterDistributionOverhaulMod:onUpdate()
	local foundEnemies = false
	
	--look for some specific bosses before we replace some enemies
	if Isaac.CountBosses() > 0 then
		MonsterDistributionOverhaulMod:setFoundBossVariable()
		foundEnemies = true
	end
	
	--call our replace enemy function
	if Isaac.CountEnemies() > 0 then
		MonsterDistributionOverhaulMod:replaceEnemies()
		foundEnemies = true
	end
	
	--clear our table if we didn't find any enemies
	if not foundEnemies then
		if not MonsterDistributionOverhaulMod.AllowStandaloneBossEnemies then
			foundHush = false
			foundUltraGreed = false
			foundRagBoss = false
			foundBrownieBoss = false
		end
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_POST_UPDATE, MonsterDistributionOverhaulMod.onUpdate)

function MonsterDistributionOverhaulMod:onRoomChange()
	--update our vars
	local level = Game():GetLevel()
	local room = level:GetCurrentRoom()
	local roomType = room:GetType()
	currentStage = level:GetStage()
	currentStageType = level:GetStageType()
	isGreedMode = Game():IsGreedMode()
	isBossRoom = false
	isVoid = false
	foundHush = false
	foundUltraGreed = false
	foundRagBoss = false
	foundBrownieBoss = false
	
	if roomType == RoomType.ROOM_BOSS then
		isBossRoom = true
	end
	
	if MonsterDistributionOverhaulMod.AllowStandaloneBossEnemies then
		foundHush = true
		foundUltraGreed = true
		foundRagBoss = true
		foundBrownieBoss = true
	end
	
	if not isGreedMode then
		if currentStage == 12 then
			local roomStage = room:GetRoomConfigStage()
			isVoid = true
			if roomStage == 1 then
				currentStage = 1
				currentStageType = 0
			elseif roomStage == 2 then
				currentStage = 1
				currentStageType = 1
			elseif roomStage == 3 then
				currentStage = 1
				currentStageType = 2
			elseif roomStage == 4 then
				currentStage = 3
				currentStageType = 0
			elseif roomStage == 5 then
				currentStage = 3
				currentStageType = 1
			elseif roomStage == 6 then
				currentStage = 3
				currentStageType = 2
			elseif roomStage == 7 then
				currentStage = 5
				currentStageType = 0
			elseif roomStage == 8 then
				currentStage = 5
				currentStageType = 1
			elseif roomStage == 9 then
				currentStage = 5
				currentStageType = 2
			elseif roomStage == 10 then
				currentStage = 7
				currentStageType = 0
			elseif roomStage == 11 then
				currentStage = 7
				currentStageType = 1
			elseif roomStage == 12 then
				currentStage = 7
				currentStageType = 2
			elseif roomStage == 13 then
				currentStage = 9
				currentStageType = 0
			elseif roomStage == 14 then
				currentStage = 10
				currentStageType = 0
			elseif roomStage == 15 then
				currentStage = 10
				currentStageType = 1
			elseif roomStage == 16 then
				currentStage = 11
				currentStageType = 0
			elseif roomStage == 17 then
				currentStage = 11
				currentStageType = 1
			end
		end
	else
		currentStageType = 0
		if currentStage == 1 then
			currentStage = 1
		elseif currentStage == 2 then
			currentStage = 3
		elseif currentStage == 3 then
			currentStage = 5
		elseif currentStage == 4 then
			currentStage = 7
		elseif currentStage == 5 then
			currentStage = 10
		elseif currentStage == 6 or currentStage == 7  then
			currentStage = 11
			currentStageType = 1
		end
	end
	
	--look for some specific bosses before we replace some enemies
	if Isaac.CountBosses() > 0 then
		MonsterDistributionOverhaulMod:setFoundBossVariable()
	end
	
	--call our replace enemy function
	if Isaac.CountEnemies() <= 0 then
		MonsterDistributionOverhaulMod:replaceEnemies(true)
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, MonsterDistributionOverhaulMod.onRoomChange)