// Shared Weapon Entity
entity	g_enWeaponEntity_ChainGun;

.float	nChainGun_BulletsFired;

#define WEAPON_CHAINGUN_BULLETDAMAGE				13

#ifdef QC_SERVERSIDE
void W_FireChainGun();
#endif

string SG_ChainGunFiringSound()
{ // Return Chain Gun Firing Sound
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.50)
		return SOUND_KLESHIK_WEAPONS_CHAINGUN_FIRE1;
	else
		return SOUND_KLESHIK_WEAPONS_CHAINGUN_FIRE2;
}
float SG_ChainGunPrimaryRefireTime()
{ // Return ChainGun Refire Time
	local float tRefireTime;
	
	tRefireTime = max(0.046, 0.160 - (self.nChainGun_BulletsFired * 0.0045) );
	self.nChainGun_BulletsFired = min(125, self.nChainGun_BulletsFired + 1);
	
	return tRefireTime;
}

void SG_PrepareWeaponEntity_ChainGun()
{ // Prepare Weapon Entity
	g_enWeaponEntity_ChainGun = SG_WeaponEntity_SpawnWeaponEntity();
	local entity enEntity;
		enEntity = g_enWeaponEntity_ChainGun;
	
	enEntity.strWeaponEntity_WeaponName					= "Chain Gun";
	enEntity.strWeaponEntity_HUDIcon					= "gfx/bigbox";
	enEntity.nWeaponEntity_WeaponID						= WEAPON_CHAIN_GUN;
	
	enEntity.strWeaponEntity_ViewWeaponModel			= "progs/v_nail2.mdl";
	enEntity.vWeaponEntity_ViewWeaponOriginOffset		= '0 5 2';
	enEntity.strWeaponEntity_ExternalWeaponModel		= "progs/g_nail2.mdl";
	
	#ifdef QC_SERVERSIDE
	enEntity.effects									= EF_NODRAW;
	enEntity.fpWeaponEntity_PrimaryFireFunction			= W_FireChainGun;
	enEntity.fpWeaponEntity_SecondaryFireFunction		= __NULL__;
	#endif
	
	#ifdef QC_CLIENTSIDE
	enEntity.fpWeaponEntity_PrimaryBrassFunction		= Brass_ChainGun;
	#endif
	
	enEntity.fpWeaponEntity_PrimaryFiringSoundFunction	= SG_ChainGunFiringSound;
	enEntity.strWeaponEntity_SecondaryFiringSound		= "";
	
	enEntity.tWeaponEntity_PrimaryRefireTime			= 0.08;
	enEntity.fpWeaponEntity_PrimaryRefireTimeFunction	= SG_ChainGunPrimaryRefireTime;
	enEntity.tWeaponEntity_SecondaryRefireTime			= 0;
	
	enEntity.fWeaponEntity_PrimaryRecoil				= 0.3;
	enEntity.fWeaponEntity_SecondaryRecoil				= 0;
	
	enEntity.bWeaponEntity_PrimaryWakesMonsters			= TRUE;
	enEntity.bWeaponEntity_SecondaryWakesMonsters		= FALSE;
	
	enEntity.nWeaponEntity_PrimaryAmmoUsed				= 1;
	enEntity.nWeaponEntity_SecondaryAmmoUsed			= 0;
	enEntity.nWeaponEntity_AmmoTypeUsed					= AMMOTYPE_NAILS;
	
	// Extra Precaches
	#ifdef QC_CLIENTSIDE
	precache_sound(SOUND_KLESHIK_WEAPONS_CHAINGUN_FIRE1);
	precache_sound(SOUND_KLESHIK_WEAPONS_CHAINGUN_FIRE2);
	#endif
	
	SG_WeaponEntity_PrecacheStandardInformation(enEntity);
}