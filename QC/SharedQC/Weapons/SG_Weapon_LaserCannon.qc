// Shared Weapon Entity
entity	g_enWeaponEntity_LaserCannon;

#ifdef QC_SERVERSIDE
void HIP_FireLaser();
#endif

void SG_PrepareWeaponEntity_LaserCannon()
{ // Prepare Weapon Entity
	g_enWeaponEntity_LaserCannon = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_LaserCannon;
	
	enEntity.strWeaponEntity_WeaponName					= "Laser Cannon";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_laser";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_LASER_CANNON;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_laserg.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_laserg.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= HIP_FireLaser;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "hipweap/laserg.wav";
	enEntity.nWeaponEntity_PrimaryFiringSoundChannel	= CHAN_WEAPON;
	enEntity.strWeaponEntity_SecondaryFiringSound		= "";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.1;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 1;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_CELLS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}