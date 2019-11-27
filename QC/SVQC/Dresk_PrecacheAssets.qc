// DRESK
// Precache Assets

// NOTE : This is necessary with random monsters and player models.
// Models must be precached in the same order everytime to avoid issues with indexes.

// Prototypes
void Precache_Monsters();

void PerformGlobalPrecaches()
{
	Precache_Monsters();
	PrecacheSharedPlayerModelAssets();
	if( cvar(CVAR_PLAYERMODEL_PRECACHEALL_QUAKE2) )
		PrecacheAllQuake2PlayerModels();
}

void Precache_Monsters()
{
	// Base Quake Precaches
	// NOTE : Any Expansion Pack additional precaches are handled with
	// conditional logic under these precaches.
	monster_boss_Precache();
	monster_demon1_Precache();
	monster_dog_preache();
	monster_enforcer_Precache();
	monster_fish_Precache();
	monster_hell_knight_Precache();
	monster_knight_Precache();
	monster_ogre_Precache();
	monster_oldone_Precache();
	monster_shalrath_Precache();
	monster_shambler_Precache();
	monster_army_Precache();
	monster_tarbaby_Precache();
	monster_wizard_Precache();
	monster_zombie_Precache();
	
	// Kleshik
	if(g_bKleshikMonstersEnabled)
	{
		monster_kleshik_babydragon_Precache();
		monster_kleshik_firefiend_Precache();
		monster_kleshik_flisker_Precache();
	}
	
	// Hipnotic Precaches
	if(g_bHipnoticEnabled)
	{
		monster_armagon_Precache();
		monster_gremlin_Precache();
		monster_scourge_Precache();
		trap_spike_mine_Precache();
	}
	// Rogue Precaches
	if(g_bRogueEnabled)
	{
		monster_dragon_Precache();
		monster_eel_Precache();
		monster_sword_Precache();
		monster_lava_man_Precache();
		monster_morph_Precache();
		monster_mummy_Precache();
		monster_super_wrath_Precache();
		monster_wrath_Precache();
	}
}