// Shared Weapon Entity
entity	g_enWeaponEntity_Axe;

#ifdef QC_SERVERSIDE
void W_FireAxe();
#endif

void SG_PrepareWeaponEntity_Axe()
{ // Prepare Weapon Entity
	g_enWeaponEntity_Axe = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_Axe;
	
	enEntity.strWeaponEntity_WeaponName					= "Axe";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/bigbox";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_AXE;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_axe.mdl";
	#ifdef WEAPONENTITIES_USEAXEANDSHOTGUNEXTERNALMODELS
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_axe.mdl";
	#else
	enEntity.strWeaponEntity_ExternalWeaponModel		= "";
	#endif
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireAxe;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/ax1.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.3;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 0;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= FALSE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 0;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_NONE;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}