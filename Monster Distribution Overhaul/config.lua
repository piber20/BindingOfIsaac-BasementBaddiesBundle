----------
--CONFIG--
----------


--STONEY AND PORTAL REMOVALS--
-- Change these to false if you wish to remove stoneys and portals from the game. Highly recommended.
-- They get replaced by enemies based on the floor you're in.
-- The "InTheVoid" settings allow you to control if you want these enemies to appear in the void but nowhere else. I recommend allowing only portals to spawn in the void, as it fits thematically.
-- These are set to true by default because people will complain if I outright remove these guys.
MonsterDistributionOverhaulMod.AllowStoneysInTheVoid = true
MonsterDistributionOverhaulMod.AllowPortalsInTheVoid = true
MonsterDistributionOverhaulMod.AllowStoneys = true
MonsterDistributionOverhaulMod.AllowPortals = true


--AFTERBIRTH+ REPLACEMENTS--
-- Set this to false if you don't want afterbirth+ replacements to be reverted. The rooms added by this mod will still show up.
MonsterDistributionOverhaulMod.RevertAfterbirthPlusReplacements = true

-- Set this to false if you don't want this mod to implement its own "better" version of afterbirth+ replacements.
-- If you leave this enabled:
-- The Thing, Poison Mind, and Nerve Ending's replacements are much rarer.
-- Mushroom's replacements also get reenabled, but are rarer and only occur in chapter 2. (caves, catacombs, flooded caves)
-- Clotties and I. Blobs have a very small chance to be replaced by Ministros.
-- Trites have a very small chance to be replaced by Blisters, but only beyond chapter 1. The replacement chance gets higher beyond chapter 2.
MonsterDistributionOverhaulMod.BetterAfterbirthPlusReplacements = true


--FLOOR ALTS--
-- Set this to true if you want to force regular versions of enemies to be replaced with their unique floor versions if they appear in their floor.
-- What enabling this does:
-- Boom flies turn into drowned boom flies in flooded caves
-- Chargers turn into drowned chargers in flooded caves
-- Hives turn into drowned hives in flooded caves
-- Globins turn into dank globins in dank depths
-- This is recommended if you have a mod that adds more unique afterbirth floor enemies and you have a mod that nerfs the drowned charger's health.
MonsterDistributionOverhaulMod.ForceAfterbirthFloorAlts = false


--BOSS ENEMIES--
-- Set this to true if you want to allow boss variants of enemies to appear outside of the boss fights.
-- If you leave this as false:
-- Greed Gapers are replaced with Attack Flies outside of the ultra greed battle
-- Hush Gapers are replaced with normal Gapers outside of the hush battle
-- Hush Flies are replaced with Ring Flies outside of the hush battle
-- Hush Boils are replaced with normal Boils outside of the hush battle
-- Rag Man's Rag Lings are replaced with normal Raglings outside of the rag boss battles
-- Brownie Corn Dips are replaced with normal Corn Dips outside of the afterbirth poop boss battles
MonsterDistributionOverhaulMod.AllowStandaloneBossEnemies = false

















--DO NOT EDIT THIS--
MonsterDistributionOverhaulMod:ForceError() --this function doesn't exist, we do this to cause an error intentionally