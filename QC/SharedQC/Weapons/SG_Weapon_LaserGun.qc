// Shared Weapon Entity
entity	g_enWeaponEntity_LaserGun;

#ifdef QC_SERVERSIDE
void W_FireLaserGun();
void W_FireAltLaserGun();
#endif

void SG_PrepareWeaponEntity_LaserGun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_LaserGun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_LaserGun;
	
	enEntity.strWeaponEntity_WeaponName					= "Laser Gun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/bigbox";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_LASER_GUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "Models/Weapons/LaserGun/ViewWeapon.mdl";
	enEntity.vWeaponEntity_ViewWeaponOriginOffset		= '7 -3 0';
	enEntity.strWeaponEntity_ExternalWeaponModel		= "Models/Weapons/LaserGun/ExternalWeapon.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireLaserGun;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireAltLaserGun;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= SOUND_KLESHIK_WEAPONS_LASERGUN_FIRE;
	enEntity.strWeaponEntity_SecondaryFiringSound		= SOUND_KLESHIK_WEAPONS_LASERGUN_ALTFIRE;
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.28;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0.95;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 2;
	enEntity.fWeaponEntity_SecondaryRecoil				= 4;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 8;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_CELLS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}