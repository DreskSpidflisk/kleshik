// Shared Weapon Entity
entity	g_enWeaponEntity_ProximityGun;

string SG_GrenadeLauncherFiringSound();

#ifdef QC_SERVERSIDE
float g_bProximityGunAllowAltFireDetonation;
void W_FireProximityGrenade();
void W_DetonateProximityBombs();
#endif

void SG_PrepareWeaponEntity_ProximityGun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_ProximityGun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_ProximityGun;
	
	enEntity.strWeaponEntity_WeaponName					= "Proximity Gun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_prox";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_PROXIMITY_GUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_prox.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_prox.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireProximityGrenade;
	if(g_bProximityGunAllowAltFireDetonation)
		enEntity.fpWeaponEntity_SecondaryFireFunction	= W_DetonateProximityBombs;
	else
		enEntity.fpWeaponEntity_SecondaryFireFunction	= __NULL__;
	#endif
	
	enEntity.fpWeaponEntity_PrimaryFiringSoundFunction		= SG_GrenadeLauncherFiringSound;
	enEntity.strWeaponEntity_SecondaryFiringSound		= "";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.65;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 2;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_ROCKETS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}