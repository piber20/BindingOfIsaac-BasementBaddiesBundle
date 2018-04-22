EnemyRebalanceMod = RegisterMod("Enemy Rebalances", 1)

function EnemyRebalanceMod:onChargerUpdate(entity)
	local frameCount = entity.FrameCount
	if frameCount <= 1 then
		if entity.Variant == 1 then
			entity.MaxHitPoints = 18
			entity.HitPoints = 18
		end
	end
end
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_NPC_UPDATE, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)
EnemyRebalanceMod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, EnemyRebalanceMod.onChargerUpdate, EntityType.ENTITY_CHARGER)