// Shared Game Weapon Information

// Definitions
#define WEAPON_FIRINGMODE_PRIMARY							0
#define WEAPON_FIRINGMODE_SECONDARY							1

#define WEAPON_EXTENDEDDATA_NONE							0

#define WEAPON_SHOTGUN_NUMBULLETS							6
#define WEAPON_SHOTGUN_SPREAD								'0.02 0.02 0'
#define WEAPON_SUPER_SHOTGUN_NUMBULLETS						18
#define WEAPON_SUPER_SHOTGUN_SPREAD							'0.14 0.08 0'

#define WEAPON_CHAIN_GUN_SPREAD								'0.05 0.05 0'

#define WEAPON_FIREBULLETS_STANDARD_DAMAGE					4

#define WEAPON_CLIENTCOMMAND_SERVERWEAPONSAVAILABLE			"ServerWeaponsAvailable"

// Specify if CSQC Firing Events are Enabled
#define WEAPON_USECSQCFIRINGEVENTS

// Fields for Weapon Entities
.string																	strWeaponEntity_WeaponName;
.string																	strWeaponEntity_HUDIcon;
.float																	nWeaponEntity_WeaponID;

.string																	strWeaponEntity_ViewWeaponModel;
.vector																	vWeaponEntity_ViewWeaponOriginOffset;
.string																	strWeaponEntity_ExternalWeaponModel;

.void()																	fpWeaponEntity_PrimaryFireFunction;
.void()																	fpWeaponEntity_SecondaryFireFunction;
.string																	strWeaponEntity_PrimaryFiringSound;
.float																	nWeaponEntity_PrimaryFiringSoundChannel;
.string()																fpWeaponEntity_PrimaryFiringSoundFunction;
.string																	strWeaponEntity_SecondaryFiringSound;
.float																	nWeaponEntity_SecondaryFiringSoundChannel;
.string()																fpWeaponEntity_SecondaryFiringSoundFunction;
.void(vector vOrigin, vector vDirection, float nExtendedData)			fpWeaponEntity_PrimaryBrassFunction;
.void(vector vOrigin, vector vDirection, float nExtendedData)			fpWeaponEntity_SecondaryBrassFunction;
.float																	tWeaponEntity_PrimaryRefireTime;
.float()																fpWeaponEntity_PrimaryRefireTimeFunction;
.float																	tWeaponEntity_SecondaryRefireTime;
.float()																fpWeaponEntity_SecondaryRefireTimeFunction;
.float																	bWeaponEntity_PrimaryWakesMonsters;
.float																	bWeaponEntity_SecondaryWakesMonsters;
.float																	fWeaponEntity_PrimaryRecoil;
.float																	fWeaponEntity_SecondaryRecoil;

.float																	nWeaponEntity_AmmoTypeUsed;
.float																	nWeaponEntity_PrimaryAmmoUsed;
.float																	nWeaponEntity_SecondaryAmmoUsed;

.entity																	enCurrentWeaponEntity;

// Prototype Weapon Entities
void SG_PrepareWeaponEntity_Axe();
void SG_PrepareWeaponEntity_Shotgun();
void SG_PrepareWeaponEntity_SuperShotgun();
void SG_PrepareWeaponEntity_Nailgun();
void SG_PrepareWeaponEntity_SuperNailgun();
void SG_PrepareWeaponEntity_GrenadeLauncher();
void SG_PrepareWeaponEntity_RocketLauncher();
void SG_PrepareWeaponEntity_Thunderbolt();
// Hipnotic Weapons
void SG_PrepareWeaponEntity_ProximityGun();
void SG_PrepareWeaponEntity_LaserCannon();
void SG_PrepareWeaponEntity_Mjolnir();

// Custom Weapons
void SG_PrepareWeaponEntity_LaserGun();
void SG_PrepareWeaponEntity_FlechetteCannon();
void SG_PrepareWeaponEntity_ChainGun();


entity g_enWeaponEntity_Axe;
entity g_enWeaponEntity_Shotgun;
entity g_enWeaponEntity_SuperShotgun;
entity g_enWeaponEntity_Nailgun;
entity g_enWeaponEntity_SuperNailgun;
entity g_enWeaponEntity_GrenadeLauncher;
entity g_enWeaponEntity_RocketLauncher;
entity g_enWeaponEntity_Thunderbolt;
entity g_enWeaponEntity_Mjolnir;
entity g_enWeaponEntity_ProximityGun;
entity g_enWeaponEntity_LaserCannon;
entity g_enWeaponEntity_LaserGun;
entity g_enWeaponEntity_FlechetteCannon;
entity g_enWeaponEntity_ChainGun;

void SG_WeaponEntity_PrecacheStandardInformation(entity enWeaponEntity)
{ // Weapon Entity - Precache Standard Information
	// Precache Models
	#ifdef QC_SERVERSIDE
	if(enWeaponEntity.strWeaponEntity_ViewWeaponModel != "")
		precache_model(enWeaponEntity.strWeaponEntity_ViewWeaponModel);
	if(enWeaponEntity.strWeaponEntity_ExternalWeaponModel != "")
		precache_model(enWeaponEntity.strWeaponEntity_ExternalWeaponModel);
	#else
	// Precache Sounds
	if(enWeaponEntity.strWeaponEntity_PrimaryFiringSound != "")
		precache_sound(enWeaponEntity.strWeaponEntity_PrimaryFiringSound);
	if(enWeaponEntity.strWeaponEntity_SecondaryFiringSound != "")
		precache_sound(enWeaponEntity.strWeaponEntity_SecondaryFiringSound);
	#endif
}
entity SG_WeaponEntity_SpawnWeaponEntity()
{ // Weapon Entity - Spawn Weapon Entity
	local entity enSpawn;
	enSpawn = spawn();
	
	enSpawn.classname = "WeaponEntity";
	
	enSpawn.strWeaponEntity_WeaponName = "UNKNOWN WEAPON";
	enSpawn.strWeaponEntity_HUDIcon = "";
	enSpawn.nWeaponEntity_WeaponID = 0;
	
	enSpawn.strWeaponEntity_ViewWeaponModel = "";
	enSpawn.vWeaponEntity_ViewWeaponOriginOffset = '0 0 0';
	enSpawn.strWeaponEntity_ExternalWeaponModel = "";
	
	enSpawn.fpWeaponEntity_PrimaryFireFunction = __NULL__;
	enSpawn.fpWeaponEntity_SecondaryFireFunction = __NULL__;
	
	enSpawn.fpWeaponEntity_PrimaryBrassFunction = __NULL__;
	enSpawn.fpWeaponEntity_SecondaryBrassFunction = __NULL__;
	
	enSpawn.strWeaponEntity_PrimaryFiringSound = "";
	enSpawn.nWeaponEntity_PrimaryFiringSoundChannel = CHAN_AUTO;
	enSpawn.fpWeaponEntity_PrimaryFiringSoundFunction = __NULL__;
	enSpawn.strWeaponEntity_SecondaryFiringSound = "";
	enSpawn.nWeaponEntity_SecondaryFiringSoundChannel = CHAN_AUTO;
	enSpawn.fpWeaponEntity_SecondaryFiringSoundFunction = __NULL__;
	
	enSpawn.tWeaponEntity_PrimaryRefireTime = 0;
	enSpawn.fpWeaponEntity_PrimaryRefireTimeFunction = __NULL__;
	enSpawn.tWeaponEntity_SecondaryRefireTime = 0;
	enSpawn.fpWeaponEntity_SecondaryRefireTimeFunction = __NULL__;
	
	enSpawn.bWeaponEntity_PrimaryWakesMonsters = FALSE;
	enSpawn.bWeaponEntity_SecondaryWakesMonsters = FALSE;
	
	enSpawn.fWeaponEntity_PrimaryRecoil = 0;
	enSpawn.fWeaponEntity_SecondaryRecoil = 0;
	
	enSpawn.nWeaponEntity_PrimaryAmmoUsed = 0;
	enSpawn.nWeaponEntity_SecondaryAmmoUsed = 0;
	enSpawn.nWeaponEntity_AmmoTypeUsed = AMMOTYPE_NONE;
	
	return enSpawn;
}
void SG_WeaponEntity_PrepareGlobalWeaponEntities()
{ // Weapon Entity - Prepare Global Weapon Entities
	SG_PrepareWeaponEntity_Axe();
	SG_PrepareWeaponEntity_Shotgun();
	SG_PrepareWeaponEntity_SuperShotgun();
	SG_PrepareWeaponEntity_Nailgun();
	SG_PrepareWeaponEntity_SuperNailgun();
	SG_PrepareWeaponEntity_GrenadeLauncher();
	SG_PrepareWeaponEntity_RocketLauncher();
	SG_PrepareWeaponEntity_Thunderbolt();
	// Hipnotic Weapons
	SG_PrepareWeaponEntity_ProximityGun();
	SG_PrepareWeaponEntity_LaserCannon();
	SG_PrepareWeaponEntity_Mjolnir();
	
	// Custom Weapons
	SG_PrepareWeaponEntity_LaserGun();
	SG_PrepareWeaponEntity_FlechetteCannon();
	SG_PrepareWeaponEntity_ChainGun();
	
	#ifdef QC_CLIENTSIDE
	// Precache Weapon Brass
	PrecacheWeaponBrass();
	#endif
}
entity SG_WeaponEntity_GetWeaponEntityFromWeaponID(float nWeaponID)
{ // Return Weapon Entity from Weapon ID
	local entity enReturn;
	switch(nWeaponID)
	{
		case WEAPON_AXE:
			enReturn = g_enWeaponEntity_Axe;
			break;
		case WEAPON_SHOTGUN:
			enReturn = g_enWeaponEntity_Shotgun;
			break;
		case WEAPON_SUPER_SHOTGUN:
			enReturn = g_enWeaponEntity_SuperShotgun;
			break;
		case WEAPON_NAILGUN:
			enReturn = g_enWeaponEntity_Nailgun;
			break;
		case WEAPON_SUPER_NAILGUN:
			enReturn = g_enWeaponEntity_SuperNailgun;
			break;
		case WEAPON_GRENADE_LAUNCHER:
			enReturn = g_enWeaponEntity_GrenadeLauncher;
			break;
		case WEAPON_ROCKET_LAUNCHER:
			enReturn = g_enWeaponEntity_RocketLauncher;
			break;
		case WEAPON_LIGHTNING:
			enReturn = g_enWeaponEntity_Thunderbolt;
			break;
		case WEAPON_MJOLNIR:
			enReturn = g_enWeaponEntity_Mjolnir;
			break;
		case WEAPON_PROXIMITY_GUN:
			enReturn = g_enWeaponEntity_ProximityGun;
			break;
		case WEAPON_LASER_CANNON:
			enReturn = g_enWeaponEntity_LaserCannon;
			break;
		case WEAPON_LASER_GUN:
			enReturn = g_enWeaponEntity_LaserGun;
			break;
		case WEAPON_FLECHETTE_CANNON:
			enReturn = g_enWeaponEntity_FlechetteCannon;
			break;
		case WEAPON_CHAIN_GUN:
			enReturn = g_enWeaponEntity_ChainGun;
			break;
	}
	
	return enReturn;
}
float GetByteEncodedWeaponID(float nWeaponID)
{ // Return Byte Encoded Weapon ID
	local float nReturn;
	while(nWeaponID >= 1)
	{
		nReturn = nReturn + 1;
		nWeaponID = nWeaponID / 2;
	}
	return nReturn;
}
float GetWeaponIDFromByteEncoded(float nByte)
{ // Get Weapon ID from Byte Encoded
	return( pow(2, nByte - 1) );
}
string SG_GetWeaponNameFromID(float nWeapon)
{ // Return Weapon Name from Item
	local entity enWeapon;
		enWeapon = SG_WeaponEntity_GetWeaponEntityFromWeaponID(nWeapon);
	if(enWeapon)
		return enWeapon.strWeaponEntity_WeaponName;
	else
		return "UNKNOWN WEAPON";
}
string SG_GetAmmoNameFromID(float nAmmo)
{ // Return Ammo Name from ID
	local string strReturn;
	switch(nAmmo)
	{
		case AMMOTYPE_SHELLS:
			strReturn = "Shells";
			break;
		case AMMOTYPE_NAILS:
			strReturn = "Nails";
			break;
		case AMMOTYPE_ROCKETS:
			strReturn = "Rockets";
			break;
		case AMMOTYPE_CELLS:
			strReturn = "Cells";
			break;
		default:
			strReturn = "UNKNOWN AMMO";
			break;
	}
	
	return strReturn;
}
string SG_GetWeaponFiringSound(entity enWeapon, float nFiringMode)
{ // Return Weapon Firing Sound
	local string strSound;
	
	if(nFiringMode == WEAPON_FIRINGMODE_PRIMARY)
	{
		if(enWeapon.fpWeaponEntity_PrimaryFiringSoundFunction != __NULL__)
			strSound = enWeapon.fpWeaponEntity_PrimaryFiringSoundFunction();
		else
			strSound = enWeapon.strWeaponEntity_PrimaryFiringSound;
	}
	else
	if(nFiringMode == WEAPON_FIRINGMODE_SECONDARY)
	{
		if(enWeapon.fpWeaponEntity_SecondaryFiringSoundFunction != __NULL__)
			strSound = enWeapon.fpWeaponEntity_SecondaryFiringSoundFunction();
		else
			strSound = enWeapon.strWeaponEntity_SecondaryFiringSound;
	}
		
	return strSound;
}
float SG_GetWeaponRefireTime(entity enWeapon, float nFiringMode)
{ // Return Weapon Refire Time
	local float tRefireTime;
	if(nFiringMode == WEAPON_FIRINGMODE_PRIMARY)
	{
		if(enWeapon.fpWeaponEntity_PrimaryRefireTimeFunction != __NULL__)
			tRefireTime = enWeapon.fpWeaponEntity_PrimaryRefireTimeFunction();
		else
			tRefireTime = enWeapon.tWeaponEntity_PrimaryRefireTime;
	}
	else
	if(nFiringMode == WEAPON_FIRINGMODE_SECONDARY)
	{
		if(enWeapon.fpWeaponEntity_SecondaryRefireTimeFunction != __NULL__)
			tRefireTime = enWeapon.fpWeaponEntity_SecondaryRefireTimeFunction();
		else
			tRefireTime = enWeapon.tWeaponEntity_SecondaryRefireTime;
	}
	
	return tRefireTime;
}