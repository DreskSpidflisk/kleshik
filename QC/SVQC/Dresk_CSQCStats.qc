// DRESK
// CSQC Stats

// Function Extension (since it doesn't exist in dpextensions)
void(float index, float type, .float field) SV_AddStat = #232;

// Definitions
#define CSQCSTAT_TYPE_INT								2
#define CSQCSTAT_TYPE_FLOAT								8

// Fields
.float		nCSQCStat_Powerups;
.float		nCSQCStat_Keys;
.float		nCSQCStat_Weapons;
.float		nCSQCStat_FlareAvailable;
.float		nCSQCStat_ClientEdictNumOnServer;

.float		nCSQCStat_PlayerIsCrouching;

.float		nCSQCStat_Skill;

.float		nCSQCStat_AdditionalMonsters_Total;
.float		nCSQCStat_AdditionalMonsters_Killed;

.float		fCSQCStat_FlashLightLightLevel;
.float		fCSQCStat_FlashLightMinimumAmbientLevel;

.float		tCSQCStat_PowerupEndTime_Invisibility;
.float		tCSQCStat_PowerupEndTime_Invulnerability;
.float		tCSQCStat_PowerupEndTime_Biosuit;
.float		tCSQCStat_PowerupEndTime_QuadDamage;
.float		tCSQCStat_PowerupEndTime_EmpathyShields;

// Functions
void PrepareCSQCStats()
{ // Prepare CSQC Stats
	// Register Powerups
	SV_AddStat(STAT_KLESHIK_POWERUPS, CSQCSTAT_TYPE_INT, nCSQCStat_Powerups);
	// Register Keys
	SV_AddStat(STAT_KLESHIK_KEYS, CSQCSTAT_TYPE_INT, nCSQCStat_Keys);
	// Register Weapons
	SV_AddStat(STAT_KLESHIK_WEAPONS, CSQCSTAT_TYPE_INT, nCSQCStat_Weapons);
	// Register Flare Available
	SV_AddStat(STAT_KLESHIK_FLAREAVAILABLE, CSQCSTAT_TYPE_INT, nCSQCStat_FlareAvailable);
	// Register Client Edict Num on Server
	SV_AddStat(STAT_KLESHIK_CLIENTEDICTNUMONSERVER, CSQCSTAT_TYPE_INT, nCSQCStat_ClientEdictNumOnServer);
	
	// Register Flash Light
	SV_AddStat(STAT_KLESHIK_FLASHLIGHTLIGHTLEVEL, CSQCSTAT_TYPE_INT, fCSQCStat_FlashLightLightLevel);
	// Register Flash Light Minimum Ambient Light Level
	SV_AddStat(STAT_KLESHIK_FLASHLIGHTMINIMUMAMBIENTLEVEL, CSQCSTAT_TYPE_INT, fCSQCStat_FlashLightMinimumAmbientLevel);
	
	// Register Player is Crouching
	SV_AddStat(STAT_KLESHIK_PLAYERISCROUCHING, CSQCSTAT_TYPE_INT, nCSQCStat_PlayerIsCrouching);
	
	// Register Skill
	SV_AddStat(STAT_KLESHIK_SKILL, CSQCSTAT_TYPE_INT, nCSQCStat_Skill);
	
	// Register Additional Monsters
	SV_AddStat(STAT_KLESHIK_ADDITIONALMONSTERS_TOTAL, CSQCSTAT_TYPE_INT, nCSQCStat_AdditionalMonsters_Total);
	SV_AddStat(STAT_KLESHIK_ADDITIONALMONSTERS_KILLED, CSQCSTAT_TYPE_INT, nCSQCStat_AdditionalMonsters_Killed);
	
	// Register Powerup End Times
	SV_AddStat(STAT_KLESHIK_POWERUPENDTIME_INVISIBILITY, CSQCSTAT_TYPE_FLOAT, tCSQCStat_PowerupEndTime_Invisibility);
	SV_AddStat(STAT_KLESHIK_POWERUPENDTIME_INVULNERABILITY, CSQCSTAT_TYPE_FLOAT, tCSQCStat_PowerupEndTime_Invulnerability);
	SV_AddStat(STAT_KLESHIK_POWERUPENDTIME_BIOSUIT, CSQCSTAT_TYPE_FLOAT, tCSQCStat_PowerupEndTime_Biosuit);
	SV_AddStat(STAT_KLESHIK_POWERUPENDTIME_QUADDAMAGE, CSQCSTAT_TYPE_FLOAT, tCSQCStat_PowerupEndTime_QuadDamage);
	SV_AddStat(STAT_KLESHIK_POWERUPENDTIME_EMPATHYSHIELDS, CSQCSTAT_TYPE_FLOAT, tCSQCStat_PowerupEndTime_EmpathyShields);
}
void CSQCStat_SyncSkill()
{ // CSQCStat - Sync Skill
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.nCSQCStat_Skill = skill;
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void CSQCStat_SyncAdditionalMonstersTotal()
{ // CSQCStat - Sync Additional Monsters Total
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.nCSQCStat_AdditionalMonsters_Total = g_nNumSpawnedMonsters;
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void CSQCStat_SyncAdditionalMonstersKilled()
{ // CSQCStat - Sync Additional Monsters Killed
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.nCSQCStat_AdditionalMonsters_Killed = g_nNumKilledSpawnedMonsters;
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}