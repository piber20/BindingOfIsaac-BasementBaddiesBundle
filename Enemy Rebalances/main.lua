EnemyRebalanceMod = RegisterMod("Enemy Rebalances", 1)

function EnemyRebalanceMod:onChargerUpdate(entity)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if entity.Variant == 1 then --drowned chargers
			local healthToSet = 20 --force their health to the same as a normal charger's
			
			if entity.SpawnerType > 0 then --lower their health to half a charger's if something spawned them (like a drowned hive)
				healthToSet = 10
			end
			
			--set the health
			entity.MaxHitPoints = healthToSet
			entity.HitPoints = healthToSet
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)

function EnemyRebalanceMod:onBlisterUpdate(entity)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if entity.Variant == 0 then --normal blisters
			local baseHealth = 16 --lower blister's health and give them stagehp
			local fakeStageHP = 4
			
			--do stagehp math
			local level = Game():GetLevel()
			local stage = level:GetStage()
			healthToSet = baseHealth + (fakeStageHP * stage)
			
			--set the health
			entity.MaxHitPoints = healthToSet
			entity.HitPoints = healthToSet
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, EnemyRebalanceMod.onBlisterUpdate, EntityType.ENTITY_BLISTER)
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyRebalanceMod.onBlisterUpdate, EntityType.ENTITY_BLISTER)