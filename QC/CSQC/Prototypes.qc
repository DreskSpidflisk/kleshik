// DRESK
// Prototypes

// Definitions

// View
string	g_strCustomFace;
float	g_nWeaponsAvailable;
vector	g_vIconSize_BottomGeneric;

// Temporary Effects
float	g_tLastBulletImpactTime;

void	HUD_PrepareMapDisplayStrings();
void	HUD_Prepare();

// Player Model Interface
float CheckPlayerModelInterfaceKeyEvent(float nKey);

// Weapon Brass
void PrecacheWeaponBrass();

void Brass_Shotgun(vector vOrigin, vector vDirection, float nExtendedData);
void Brass_SuperShotgun(vector vOrigin, vector vDirection, float nExtendedData);
void Brass_Nailgun(vector vOrigin, vector vDirection, float nExtendedData);
void Brass_ChainGun(vector vOrigin, vector vDirection, float nExtendedData);