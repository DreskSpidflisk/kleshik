// Shared Weapon Entity
entity	g_enWeaponEntity_Shotgun;

#ifdef QC_SERVERSIDE
void W_FireShotgun();
void W_FireSniperRifle();
#endif

void SG_PrepareWeaponEntity_Shotgun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_Shotgun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_Shotgun;
	
	enEntity.strWeaponEntity_WeaponName					= "Shotgun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/inv_shotgun";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_SHOTGUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_shot.mdl";
	#ifdef WEAPONENTITIES_USEAXEANDSHOTGUNEXTERNALMODELS
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_shotgun.mdl";
	#else
	enEntity.strWeaponEntity_ExternalWeaponModel		= "";
	#endif
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireShotgun;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= W_FireSniperRifle;
	#endif
	
	#ifdef QC_CLIENTSIDE
	enEntity.fpWeaponEntity_PrimaryBrassFunction		= Brass_Shotgun;
	#endif
	
	enEntity.strWeaponEntity_PrimaryFiringSound			= "weapons/guncock.wav";
	enEntity.strWeaponEntity_SecondaryFiringSound		= SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_FIRE;
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.4;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 2.0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 2;
	enEntity.fWeaponEntity_SecondaryRecoil				= 8;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= TRUE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 18;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_SHELLS;
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}