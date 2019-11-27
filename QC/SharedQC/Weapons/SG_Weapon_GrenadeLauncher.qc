// Shared Weapon Entity
entity	g_enWeaponEntity_GrenadeLauncher;

#ifdef QC_SERVERSIDE
float g_bRogueEnabled;
void W_FireGrenade();
void W_FireMultiGrenade();
#endif

string SG_GrenadeLauncherFiringSound()
{ // Return Grenade Launcher Firing Sound
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		return SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE1;
	else
	if(nRandom < 0.66)
		return SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE2;
	else
		return SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE3;
}

void SG_PrepareWeaponEntity_GrenadeLauncher()
{ // Prepare Weapon Entity
	g_enWeaponEntity_GrenadeLauncher = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_GrenadeLauncher;
	
	enEntity.strWeaponEntity_WeaponName					= "Grenade Launcer";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_rlaunch";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_GRENADE_LAUNCHER;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_rock.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_rock.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireGrenade;
	if(g_bRogueEnabled)
		enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireMultiGrenade;
	else
		enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	enEntity.fpWeaponEntity_PrimaryFiringSoundFunction		= SG_GrenadeLauncherFiringSound;
	enEntity.fpWeaponEntity_SecondaryFiringSoundFunction	= SG_GrenadeLauncherFiringSound;
	//enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/grenade.wav";
	//enEntity.strWeaponEntity_SecondaryFiringSound		= "weapons/grenade.wav";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.55;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 1.1;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 2;
	enEntity.fWeaponEntity_SecondaryRecoil				= 2;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 6;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_ROCKETS;
	
	// Extra Precaches
	#ifdef QC_CLIENTSIDE
	precache_sound(SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE1);
	precache_sound(SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE2);
	precache_sound(SOUND_KLESHIK_WEAPONS_GRENADLAUNCHER_FIRE3);
	#endif
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}