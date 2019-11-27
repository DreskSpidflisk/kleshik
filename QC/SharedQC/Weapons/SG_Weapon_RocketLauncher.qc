// Shared Weapon Entity
entity	g_enWeaponEntity_RocketLauncher;

#ifdef QC_SERVERSIDE
float g_bRogueEnabled;
void W_FireRocket();
void W_FireMultiRocket();
#endif

string SG_RocketLauncherFiringSound()
{
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		return SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE1;
	else
	if(nRandom < 0.66)
		return SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE2;
	else
		return SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE3;
}

void SG_PrepareWeaponEntity_RocketLauncher()
{ // Prepare Weapon Entity
	g_enWeaponEntity_RocketLauncher = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_RocketLauncher;
	
	enEntity.strWeaponEntity_WeaponName					= "Rocket Launcher";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_srlaunch";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_ROCKET_LAUNCHER;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_rock2.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_rock2.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireRocket;
	if(g_bRogueEnabled)
		enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireMultiRocket;
	else
		enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	enEntity.fpWeaponEntity_PrimaryFiringSoundFunction	= SG_RocketLauncherFiringSound;
	enEntity.fpWeaponEntity_SecondaryFiringSoundFunction = SG_RocketLauncherFiringSound;
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.8;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 1.35;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 2;
	enEntity.fWeaponEntity_SecondaryRecoil				= 2;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 4;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_ROCKETS;
	
	// Extra Precaches
	#ifdef QC_CLIENTSIDE
	precache_sound(SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE1);
	precache_sound(SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE2);
	precache_sound(SOUND_KLESHIK_WEAPONS_ROCKETLAUNCHER_FIRE3);
	#endif
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}