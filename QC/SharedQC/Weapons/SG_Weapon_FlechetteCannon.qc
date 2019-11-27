// Shared Weapon Entity
entity	g_enWeaponEntity_FlechetteCannon;

#ifdef QC_SERVERSIDE
void W_FireFlechetteCannon();
void W_FireAltFlechetteCannon();
#endif

string SG_FlechetteCannonFiringSound()
{
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.50)
		return SOUND_KLESHIK_WEAPONS_FLECHETTECANNON_FIRE1;
	else
		return SOUND_KLESHIK_WEAPONS_FLECHETTECANNON_FIRE2;
}

void SG_PrepareWeaponEntity_FlechetteCannon()
{ // Prepare Weapon Entity
	g_enWeaponEntity_FlechetteCannon = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_FlechetteCannon;
	
	enEntity.strWeaponEntity_WeaponName					= "Flechette Cannon";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/bigbox";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_FLECHETTE_CANNON;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "Models/Weapons/FlechetteCannon/ViewWeapon.mdl";
	enEntity.vWeaponEntity_ViewWeaponOriginOffset		= '4.5 0 0';
	enEntity.strWeaponEntity_ExternalWeaponModel		= "Models/Weapons/FlechetteCannon/ExternalWeapon.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireFlechetteCannon;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireAltFlechetteCannon;
	#endif
	
	enEntity.fpWeaponEntity_PrimaryFiringSoundFunction	= SG_FlechetteCannonFiringSound;
	enEntity.fpWeaponEntity_SecondaryFiringSoundFunction	= SG_FlechetteCannonFiringSound;
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 1.0;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 1.0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 5;
	enEntity.fWeaponEntity_SecondaryRecoil				= 5;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 12;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 12;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_NAILS;
	
	// Extra Precaches
	#ifdef QC_CLIENTSIDE
	precache_sound(SOUND_KLESHIK_WEAPONS_FLECHETTECANNON_FIRE1);
	precache_sound(SOUND_KLESHIK_WEAPONS_FLECHETTECANNON_FIRE2);
	#endif
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}