// Shared Weapon Entity
entity	g_enWeaponEntity_SuperShotgun;

#ifdef QC_SERVERSIDE
void W_FireSuperShotgun();
void W_FireScatterShot();
#endif

void SG_PrepareWeaponEntity_SuperShotgun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_SuperShotgun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_SuperShotgun;
	
	enEntity.strWeaponEntity_WeaponName					= "Super Shotgun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_sshotgun";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_SUPER_SHOTGUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_shot2.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_shot.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireSuperShotgun;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireScatterShot;
	#endif
	
	#ifdef QC_CLIENTSIDE
	enEntity.fpWeaponEntity_PrimaryBrassFunction		= Brass_SuperShotgun;
	enEntity.fpWeaponEntity_SecondaryBrassFunction		= Brass_SuperShotgun;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/shotgn2.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "Kleshik/Weapons/ScatterShot/Fire.wav";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.7;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 1.5;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 4;
	enEntity.fWeaponEntity_SecondaryRecoil				= 15;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 2;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 3;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_SHELLS;
	
	// Extra Precaches
	#ifdef QC_CLIENTSIDE
	precache_sound(SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP1);
	precache_sound(SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP2);
	precache_sound(SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP3);
	#endif
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}