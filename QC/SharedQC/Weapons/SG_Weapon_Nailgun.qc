// Shared Weapon Entity
entity	g_enWeaponEntity_Nailgun;

#ifdef QC_SERVERSIDE
void W_FireSpikes();
void W_FireScitheGun();
#endif

void SG_PrepareWeaponEntity_Nailgun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_Nailgun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_Nailgun;
	
	enEntity.strWeaponEntity_WeaponName					= "Nailgun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_nailgun";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_NAILGUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_nail.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_nail.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireSpikes;
	// enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireScitheGun;
	#endif
	
	#ifdef QC_CLIENTSIDE
	enEntity.fpWeaponEntity_PrimaryBrassFunction		= Brass_Nailgun;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/rocket1i.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "weapons/rocket1i.wav";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.1;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0.3;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 1;
	enEntity.fWeaponEntity_SecondaryRecoil				= 1;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 0.5;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 1;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_NAILS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}