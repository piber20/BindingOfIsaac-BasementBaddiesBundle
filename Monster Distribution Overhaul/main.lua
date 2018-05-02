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
local isShopRoom = false
local isTreasureRoom = false
local isFlaming = false
local isFlooded = false
local isDank = false
local isScarred = false
local isVoid = false
local foundHush = false
local foundUltraGreed = false
local foundRagBoss = false
local foundBrownieBoss = false

function MonsterDistributionOverhaulMod:preEntitySpawn(type, variant, subType, position, velocity, spawner, seed)
	if type == EntityType.ENTITY_STONEY then
		if Game():GetRoom():GetFrameCount() > 0 or not MonsterDistributionOverhaulMod.RevertAfterbirthPlusReplacements then
			--replace stoneys
			local replaceStonies = true
			if Game():GetLevel():GetStage() == 12 then
				if MonsterDistributionOverhaulMod.AllowStoneysInTheVoid then
					replaceStonies = false
				end
			elseif MonsterDistributionOverhaulMod.AllowStoneys then
				replaceStonies = false
			end
			if replaceStonies then
				local currentStage = piber20HelperMod:getCurrentStage()
				
				--defaults (basement)
				local typeToReplace = EntityType.ENTITY_ATTACKFLY
				local variantToReplace = 0
				
				if currentStage == piber20HelperStage.CELLAR then
					typeToReplace = EntityType.ENTITY_SPIDER
				elseif currentStage == piber20HelperStage.BURNING_BASEMENT then
					typeToReplace = EntityType.ENTITY_GAPER --flaming gaper
					variantToReplace = 2
				elseif currentStage == piber20HelperStage.FLOODED_CAVES then
					typeToReplace = EntityType.ENTITY_CHARGER --drowned charger
					variantToReplace = 1
				elseif currentStage == piber20HelperStage.DEPTHS or currentStage == piber20HelperStage.NECROPOLIS or currentStage == piber20HelperStage.DANK_DEPTHS then
					typeToReplace = EntityType.ENTITY_FATTY --pale fatty
					variantToReplace = 1
				elseif currentStage == piber20HelperStage.WOMB or currentStage == piber20HelperStage.UTERO or currentStage == piber20HelperStage.SCARRED_WOMB then
					typeToReplace = EntityType.ENTITY_LUMP
				elseif currentStage == piber20HelperStage.BLUE_WOMB then
					typeToReplace = EntityType.ENTITY_HUSH_FLY
				elseif currentStage == piber20HelperStage.SHEOL then
					typeToReplace = EntityType.ENTITY_NULLS
				elseif currentStage == piber20HelperStage.CATHEDRAL then
					typeToReplace = EntityType.ENTITY_BABY
				elseif currentStage == piber20HelperStage.DARK_ROOM then
					typeToReplace = EntityType.ENTITY_NULLS
				elseif currentStage == piber20HelperStage.CHEST then
					typeToReplace = EntityType.ENTITY_FATTY --pale fatty
					variantToReplace = 1
				end
				
				local newData = {
					typeToReplace,
					variantToReplace,
					0,
					seed
				}
				return newData
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
			local typeToReplace = EntityType.ENTITY_SWARM
			local variantToReplace = 0
			
			if currentStage == piber20HelperStage.CELLAR then
				typeToReplace = EntityType.ENTITY_BOIL --sack
				variantToReplace = 2
			elseif currentStage == piber20HelperStage.BURNING_BASEMENT then
				typeToReplace = EntityType.ENTITY_FATTY --flaming fatty
				variantToReplace = 2
			elseif currentStage == piber20HelperStage.CAVES or currentStage == piber20HelperStage.CATACOMBS then
				typeToReplace = EntityType.ENTITY_HIVE
			elseif currentStage == piber20HelperStage.FLOODED_CAVES then
				typeToReplace = EntityType.ENTITY_HIVE --drowned hive
				variantToReplace = 1
			elseif currentStage == piber20HelperStage.DEPTHS or currentStage == piber20HelperStage.NECROPOLIS or currentStage == piber20HelperStage.DANK_DEPTHS then
				typeToReplace = EntityType.ENTITY_FAT_SACK
			elseif currentStage == piber20HelperStage.WOMB or currentStage == piber20HelperStage.UTERO or currentStage == piber20HelperStage.SCARRED_WOMB then
				typeToReplace = EntityType.ENTITY_HOST --flesh host
				variantToReplace = 1
			elseif currentStage == piber20HelperStage.BLUE_WOMB then
				typeToReplace = EntityType.ENTITY_HUSH_GAPER
			elseif currentStage == piber20HelperStage.SHEOL then
				typeToReplace = EntityType.ENTITY_IMP
			elseif currentStage == piber20HelperStage.CATHEDRAL then
				typeToReplace = EntityType.ENTITY_BABY --angelic baby
				variantToReplace = 1
			elseif currentStage == piber20HelperStage.DARK_ROOM then
				typeToReplace = EntityType.ENTITY_IMP
			elseif currentStage == piber20HelperStage.CHEST then
				typeToReplace = EntityType.ENTITY_DINGA
			end
			
			local newData = {
				typeToReplace,
				variantToReplace,
				0,
				seed
			}
			return newData
		end
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, MonsterDistributionOverhaulMod.preEntitySpawn)

function MonsterDistributionOverhaulMod:preRoomEntitySpawn(type, variant, subType, gridIndex, seed)
	--disable ab+ replacements
	if MonsterDistributionOverhaulMod.RevertAfterbirthPlusReplacements then
		local currentStage = piber20HelperMod:getCurrentStage()
		local returnOurselves = false
		
		--anti blister
		if type == EntityType.ENTITY_KEEPER or type == EntityType.ENTITY_TICKING_SPIDER then
			returnOurselves = true
		--anti mushroom
		elseif type == EntityType.ENTITY_HOST then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				if currentStage == piber20HelperStage.CAVES or currentStage == piber20HelperStage.CATACOMBS or currentStage == piber20HelperStage.FLOODED_CAVES then
					if piber20HelperMod:getRandomNumber(1, 40) == 1 then
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
				if piber20HelperMod:getRandomNumber(1, 40) == 1 then
					returnOurselves = false
				end
			end
		--anti poison mind
		elseif type == EntityType.ENTITY_BRAIN then
			returnOurselves = true
			if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
				if piber20HelperMod:getRandomNumber(1, 40) == 1 then
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
		
		if returnOurselves then
			local newData = {
				type,
				variant,
				subType
			}
			return newData
		end
	end
end
MonsterDistributionOverhaulMod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, MonsterDistributionOverhaulMod.preRoomEntitySpawn)

--replace enemies with stuff we want
function MonsterDistributionOverhaulMod:replaceEnemies(fromNewRoom)
	if fromNewRoom == nil then
		fromNewRoom = false
	end

	--replace stuff when we're not in greed mode or we're in a treasure room
	if not isGreedMode then
		if not foundUltraGreed then
			for _, greedGaper in pairs(Isaac.FindByType(EntityType.ENTITY_GREED_GAPER, 0, -1, false, true)) do --replace greed gaper with attack fly
				piber20HelperMod:replaceEntity(greedGaper, EntityType.ENTITY_ATTACKFLY, 0, 0, true)
			end
		end
	end
	
	--replace stuff when we're not in a boss room
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

	--replace stuff when we're in a shop room
	if isShopRoom then
		for _, keeper in pairs(Isaac.FindByType(EntityType.ENTITY_KEEPER, 0, -1, false, true)) do --replace keeper with spider
			piber20HelperMod:replaceEntity(keeper, EntityType.ENTITY_SPIDER, 0, 0, true)
		end
	end
	
	--replace flaming enemies with normal ones if we're not in the burning basement
	if not isFlaming then
		for _, flamingGaper in pairs(Isaac.FindByType(EntityType.ENTITY_GAPER, 2, -1, false, true)) do --replace flaming gapers with normal gapers
			piber20HelperMod:replaceEntity(flamingGaper, EntityType.ENTITY_GAPER, 1, 0, true)
		end
		for _, flamingFatty in pairs(Isaac.FindByType(EntityType.ENTITY_FATTY, 2, -1, false, true)) do --replace flaming fatties with normal fatties
			piber20HelperMod:replaceEntity(flamingFatty, EntityType.ENTITY_FATTY, 0, 0, true)
		end
		for _, crispy in pairs(Isaac.FindByType(EntityType.ENTITY_SKINNY, 2, -1, false, true)) do --replace crispys with skinnys
			piber20HelperMod:replaceEntity(crispy, EntityType.ENTITY_SKINNY, 0, 0, true)
		end
	end
	
	--replace drowned enemies with normal ones if we're not in the flooded caves
	if not isFlooded then
		for _, drownedBoomFly in pairs(Isaac.FindByType(EntityType.ENTITY_BOOMFLY, 2, -1, false, true)) do --replace drowned boom flies with normal boom flies
			piber20HelperMod:replaceEntity(drownedBoomFly, EntityType.ENTITY_BOOMFLY, 0, 0, true)
		end
		for _, drownedHive in pairs(Isaac.FindByType(EntityType.ENTITY_HIVE, 1, -1, false, true)) do --replace drowned hives with normal hives
			piber20HelperMod:replaceEntity(drownedHive, EntityType.ENTITY_HIVE, 0, 0, true)
		end
		for _, drownedCharger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 1, -1, false, true)) do --replace drowned chargers with normal chargers
			piber20HelperMod:replaceEntity(drownedCharger, EntityType.ENTITY_CHARGER, 0, 0, true)
		end
	else --replace flaming enemies with normal ones if we're in the flooded caves
		for _, flamingHopper in pairs(Isaac.FindByType(EntityType.ENTITY_FLAMINGHOPPER, 0, -1, false, true)) do --replace flaming hoppers with normal hoppers if we're in flooded caves (the floor is covered with water...)
			piber20HelperMod:replaceEntity(flamingHopper, EntityType.ENTITY_HOPPER, 0, 0, true)
		end
	end
	
	--replace dank enemies with normal ones if we're not in the dank depths
	if not isDank then
		for _, dankGlobin in pairs(Isaac.FindByType(EntityType.ENTITY_GLOBIN, 2, -1, false, true)) do --replace dank globin with normal globin
			piber20HelperMod:replaceEntity(dankGlobin, EntityType.ENTITY_GLOBIN, 0, 0, true)
		end
		for _, dankDeathsHead in pairs(Isaac.FindByType(EntityType.ENTITY_DEATHS_HEAD, 1, -1, false, true)) do --replace dank death's head with normal death's head
			piber20HelperMod:replaceEntity(dankDeathsHead, EntityType.ENTITY_DEATHS_HEAD, 0, 0, true)
		end
		for _, tarBoy in pairs(Isaac.FindByType(EntityType.ENTITY_TARBOY, 0, -1, false, true)) do --replace tar boy with nightcrawler
			piber20HelperMod:replaceEntity(tarBoy, EntityType.ENTITY_NIGHT_CRAWLER, 0, 0, true)
		end
		for _, gush in pairs(Isaac.FindByType(EntityType.ENTITY_GUSH, 0, -1, false, true)) do --replace gush with sack
			piber20HelperMod:replaceEntity(gush, EntityType.ENTITY_BOIL, 2, 0, true)
		end
		for _, dankSquirt in pairs(Isaac.FindByType(EntityType.ENTITY_SQUIRT, 1, -1, false, true)) do --replace dank squirt with normal squirt
			piber20HelperMod:replaceEntity(dankSquirt, EntityType.ENTITY_SQUIRT, 0, 0, true)
		end
		for _, dankCharger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 2, -1, false, true)) do --replace dank chargers with normal chargers
			piber20HelperMod:replaceEntity(dankCharger, EntityType.ENTITY_CHARGER, 0, 0, true)
		end
	end
	
	--replace scarred enemies with normal ones if we're not in the scarred womb
	if not isScarred then
		for _, scarredGuts in pairs(Isaac.FindByType(EntityType.ENTITY_GUTS, 1, -1, false, true)) do --replace scarred guts with normal guts
			piber20HelperMod:replaceEntity(scarredGuts, EntityType.ENTITY_GUTS, 0, 0, true)
		end
		for _, scarredDoubleVis in pairs(Isaac.FindByType(EntityType.ENTITY_VIS, 3, -1, false, true)) do --replace scarred double vis with normal double vis
			piber20HelperMod:replaceEntity(scarredDoubleVis, EntityType.ENTITY_VIS, 1, 0, true)
		end
	end
	
	--replace some womb enemies with normal ones if we're not in any womb chapters
	if currentStage ~= 7 and currentStage ~= 8 then
		for _, fleshDeathsHead in pairs(Isaac.FindByType(EntityType.ENTITY_FLESH_DEATHS_HEAD, 0, -1, false, true)) do --replace flesh death's head with normal death's head
			piber20HelperMod:replaceEntity(fleshDeathsHead, EntityType.ENTITY_DEATHS_HEAD, 0, 0, true)
		end
		for _, redGhost in pairs(Isaac.FindByType(EntityType.ENTITY_RED_GHOST, 0, -1, false, true)) do --replace red ghost with normal wizoob
			piber20HelperMod:replaceEntity(redGhost, EntityType.ENTITY_WIZOOB, 0, 0, true)
		end
	end

	--replace stuff when we're not in the hush floor
	if currentStage ~= 9 then
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
	
	--do ab+ replacements in a better way
	if MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements then
		--Ministro
		for _, clotty in pairs(Isaac.FindByType(EntityType.ENTITY_CLOTTY, -1, -1, false, true)) do
			if clotty.Variant ~= 1 then --no clots
				local chance = 300
				if variant == 2 then --i blob
					chance = 50
				end
				if piber20HelperMod:getRandomNumber(1, chance) == 1 then
					piber20HelperMod:replaceEntity(clotty, EntityType.ENTITY_MINISTRO, 0, 0, true)
				end
			end
		end
		--Blister
		if currentStage > 2 then
			for _, trite in pairs(Isaac.FindByType(EntityType.ENTITY_HOPPER, 1, -1, false, true)) do
				local chance = 200
				if currentStage > 4 then
					chance = 35
				end
				if piber20HelperMod:getRandomNumber(1, chance) == 1 then
					piber20HelperMod:replaceEntity(trite, EntityType.ENTITY_BLISTER, 0, 0, true)
				end
			end
		end
	end
	
	--force some normal enemies to be the alt floor versions if the player is in the alt floor
	if MonsterDistributionOverhaulMod.ForceAfterbirthFloorAlts then
		if isFlooded then
			for _, boomFly in pairs(Isaac.FindByType(EntityType.ENTITY_BOOMFLY, 0, -1, false, true)) do
				piber20HelperMod:replaceEntity(boomFly, EntityType.ENTITY_BOOMFLY, 2, 0, true)
			end
			for _, redBoomFly in pairs(Isaac.FindByType(EntityType.ENTITY_BOOMFLY, 1, -1, false, true)) do
				piber20HelperMod:replaceEntity(redBoomFly, EntityType.ENTITY_BOOMFLY, 2, 0, true)
			end
			for _, hive in pairs(Isaac.FindByType(EntityType.ENTITY_HIVE, 0, -1, false, true)) do
				piber20HelperMod:replaceEntity(hive, EntityType.ENTITY_HIVE, 1, 0, true)
			end
			for _, charger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 0, -1, false, true)) do
				piber20HelperMod:replaceEntity(charger, EntityType.ENTITY_CHARGER, 1, 0, true)
			end
			for _, dankCharger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 2, -1, false, true)) do
				piber20HelperMod:replaceEntity(charger, EntityType.ENTITY_CHARGER, 1, 0, true)
			end
		end
		if isDank then
			for _, globin in pairs(Isaac.FindByType(EntityType.ENTITY_GLOBIN, 0, -1, false, true)) do
				piber20HelperMod:replaceEntity(globin, EntityType.ENTITY_GLOBIN, 2, 0, true)
			end
			for _, charger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 0, -1, false, true)) do
				piber20HelperMod:replaceEntity(charger, EntityType.ENTITY_CHARGER, 2, 0, true)
			end
			for _, drownedCharger in pairs(Isaac.FindByType(EntityType.ENTITY_CHARGER, 1, -1, false, true)) do
				piber20HelperMod:replaceEntity(charger, EntityType.ENTITY_CHARGER, 2, 0, true)
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
	isShopRoom = false
	isTreasureRoom = false
	isFlaming = false
	isFlooded = false
	isDank = false
	isScarred = false
	isVoid = false
	foundHush = false
	foundUltraGreed = false
	foundRagBoss = false
	foundBrownieBoss = false
	
	if roomType == RoomType.ROOM_BOSS then
		isBossRoom = true
	elseif roomType == RoomType.ROOM_SHOP then
		isShopRoom = true
	elseif roomType == RoomType.ROOM_TREASURE then
		isTreasureRoom = true
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
		if currentStageType == 2 then
			if currentStage == 1 or currentStage == 2 then
				isFlaming = true
			elseif currentStage == 3 or currentStage == 4 then
				isFlooded = true
			elseif currentStage == 5 or currentStage == 6 then
				isDank = true
			elseif currentStage == 7 or currentStage == 8 then
				isScarred = true
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