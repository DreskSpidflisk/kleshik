// Definitions
#define QUAKE2PLAYERMODEL_WEAPONID_DEFAULT							1
#define QUAKE2PLAYERMODEL_WEAPONID_BLASTER							2
#define QUAKE2PLAYERMODEL_WEAPONID_SHOTGUN							4
#define QUAKE2PLAYERMODEL_WEAPONID_SUPERSHOTGUN						8
#define QUAKE2PLAYERMODEL_WEAPONID_MACHINEGUN						16
#define QUAKE2PLAYERMODEL_WEAPONID_CHAINGUN							32
#define QUAKE2PLAYERMODEL_WEAPONID_GRENADELAUNCHER					64
#define QUAKE2PLAYERMODEL_WEAPONID_ROCKETLAUNCHER					128
#define QUAKE2PLAYERMODEL_WEAPONID_HYPERBLASTER						256
#define QUAKE2PLAYERMODEL_WEAPONID_RAILGUN							512
#define QUAKE2PLAYERMODEL_WEAPONID_BFG								1024
#define QUAKE2PLAYERMODEL_WEAPONID_MAX								1024

#define QUAKE2PLAYERMODEL_SOUNDID_BUMP1								1
#define QUAKE2PLAYERMODEL_SOUNDID_DEATH1							2
#define QUAKE2PLAYERMODEL_SOUNDID_DEATH2							4
#define QUAKE2PLAYERMODEL_SOUNDID_DEATH3							8
#define QUAKE2PLAYERMODEL_SOUNDID_DEATH4							16
#define QUAKE2PLAYERMODEL_SOUNDID_DROWN1							32
#define QUAKE2PLAYERMODEL_SOUNDID_FALL1								64
#define QUAKE2PLAYERMODEL_SOUNDID_FALL2								128
#define QUAKE2PLAYERMODEL_SOUNDID_GURP1								256
#define QUAKE2PLAYERMODEL_SOUNDID_GURP2								512
#define QUAKE2PLAYERMODEL_SOUNDID_JUMP1								1024
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN25_1							2048
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN25_2							4096
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN50_1							8192
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN50_2							16384
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN75_1							32768
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN75_2							65536
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN100_1							131072
#define QUAKE2PLAYERMODEL_SOUNDID_PAIN100_2							262144

#define QUAKE2PLAYERMODEL_SOUNDS_EXPECTEDNUMBER						19



string SG_GetQuake2WeaponStringFromWeaponID(float nWeaponID)
{ // Return Quake2 Weapon String from Weapon ID
	local string strReturn;
	switch(nWeaponID)
	{
		case QUAKE2PLAYERMODEL_WEAPONID_DEFAULT:
			strReturn = "Default";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_BLASTER:
			strReturn = "Blaster";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_SHOTGUN:
			strReturn = "Shotgun";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_SUPERSHOTGUN:
			strReturn = "Super Shotgun";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_MACHINEGUN:
			strReturn = "Machinegun";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_CHAINGUN:
			strReturn = "Chaingun";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_GRENADELAUNCHER:
			strReturn = "Grenade Launcher";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_ROCKETLAUNCHER:
			strReturn = "Rocket Launcher";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_HYPERBLASTER:
			strReturn = "Hyper Blaster";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_RAILGUN:
			strReturn = "Railgun";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_BFG:
			strReturn = "BFG";
			break;
		default:
			strReturn = "Unknown";
			break;
	}
	
	return strReturn;
}

string SG_GetQuake2WeaponModelNameFromID(float nWeaponID)
{ // Return Quake2 Weapon Model Name from ID
	local string strReturn;
	switch(nWeaponID)
	{
		case QUAKE2PLAYERMODEL_WEAPONID_DEFAULT:
			strReturn = "/weapon.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_BLASTER:
			strReturn = "/w_blaster.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_SHOTGUN:
			strReturn = "/w_shotgun.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_SUPERSHOTGUN:
			strReturn = "/w_sshotgun.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_MACHINEGUN:
			strReturn = "/w_machinegun.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_CHAINGUN:
			strReturn = "/w_chaingun.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_GRENADELAUNCHER:
			strReturn = "/w_glauncher.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_ROCKETLAUNCHER:
			strReturn = "/w_rlauncher.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_HYPERBLASTER:
			strReturn = "/w_hyperblaster.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_RAILGUN:
			strReturn = "/w_railgun.md2";
			break;
		case QUAKE2PLAYERMODEL_WEAPONID_BFG:
			strReturn = "/w_bfg.md2";
			break;
		default:
			strReturn = "/weapon.md2";
			break;
	}
	
	return strReturn;
}