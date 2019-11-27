// Shared Weapon Entity
entity	g_enWeaponEntity_SuperNailgun;

#ifdef QC_SERVERSIDE
void W_FireSuperSpikes();
#endif

void SG_PrepareWeaponEntity_SuperNailgun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_SuperNailgun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_SuperNailgun;
	
	enEntity.strWeaponEntity_WeaponName					= "Super Nailgun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_snailgun";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_SUPER_NAILGUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_nail2.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_nail2.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireSuperSpikes;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	#ifdef QC_CLIENTSIDE
	enEntity.fpWeaponEntity_PrimaryBrassFunction		= Brass_Nailgun;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/spike2.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.1;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 1;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 2;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_NAILS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}