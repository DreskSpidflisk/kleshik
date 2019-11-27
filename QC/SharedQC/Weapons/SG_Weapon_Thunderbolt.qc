// Shared Weapon Entity
entity	g_enWeaponEntity_Thunderbolt;

#ifdef QC_SERVERSIDE
float g_bRogueEnabled;
void W_FireLightning();
void W_FirePlasma();
#endif

void SG_PrepareWeaponEntity_Thunderbolt()
{ // Prepare Weapon Entity
	g_enWeaponEntity_Thunderbolt = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_Thunderbolt;
	
	enEntity.strWeaponEntity_WeaponName					= "Thunderbolt";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_lightng";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_LIGHTNING;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_light.mdl";
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_light.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireLightning;
	if(g_bRogueEnabled)
		enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FirePlasma;
	else
		enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/lstart.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= "plasma/fire.wav";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.1;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 1.0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 1;
	enEntity.fWeaponEntity_SecondaryRecoil				= 2;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 16;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_CELLS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}