// Shared Weapon Entity
entity	g_enWeaponEntity_Mjolnir;

#ifdef QC_SERVERSIDE
void W_FireMjolnir();
#endif

void SG_PrepareWeaponEntity_Mjolnir()
{ // Prepare Weapon Entity
	g_enWeaponEntity_Mjolnir = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_Mjolnir;
	
	enEntity.strWeaponEntity_WeaponName					= "Mjolnir";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_mjolnir";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_MJOLNIR;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_hammer.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_hammer.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireMjolnir;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireMjolnir;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "knight/sword1.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "knight/sword1.wav";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.5;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0.5;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 0;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= FALSE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 0;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_CELLS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}