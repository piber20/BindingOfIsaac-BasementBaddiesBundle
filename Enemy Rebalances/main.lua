EnemyRebalanceMod = RegisterMod("Enemy Rebalances", 1)

function EnemyRebalanceMod:onChargerUpdate(entity)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if entity.Variant == 1 then
			if entity.SpawnerType == EntityType.ENTITY_HIVE and entity.SpawnerVariant == 1 then
				entity.MaxHitPoints = 10
				entity.HitPoints = 10
			else
				entity.MaxHitPoints = 20
				entity.HitPoints = 20
			end
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)