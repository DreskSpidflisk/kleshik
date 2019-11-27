// DRESK - Defs
// Provides the base definitions for the modification.

#pragma flag off fastarrays // make dp behave with new fteqcc versions. remove when dp bug with fteqcc fastarrays is fixed

#define ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS								30
#define ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO						15
#define ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS								15
#define ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS								10
#define ADVANCEDSTATISTICS_ARRAYSIZE_OTHER									30

#define BRUSHCRUSH_INSTANTKILL_DAMAGE										1000

#define WEAPON_GRENADE_GHOSTOWNER_THINKTIME									0.2

#define CHEATIMPULSE_GIVEALL												253
#define CHEATIMPULSE_GIVEALLPOWERUPS										254
#define CHEATIMPULSE_QUADDAMAGE												255

#define ARMORTYPE_GREEN														1
#define ARMORTYPE_YELLOW													2
#define ARMORTYPE_RED														3

#define POWERUPTYPE_ENVIROSUIT												1
#define POWERUPTYPE_INVULNERABILITY											2
#define POWERUPTYPE_INVISIBILITY											3
#define POWERUPTYPE_QUADDAMAGE												4
#define POWERUPTYPE_EMPATHYSHIELDS											5

#define HITLOCATION_NONE													'0 0 0'
#define HITLOCATION_SELFORIGIN												self.origin

// Preprocessor Logic Definitions
#define SUPPRESSCLIENTBFCOMMANDS

// View Offsets
#define PLAYER_VIEWOFFSETS_NORMAL											'0 0 22'
#define PLAYER_VIEWOFFSETS_CROUCH											'0 0 12'

// Sizes
#define PLAYER_CROUCH_MINS													'-16 -16 -24'
#define PLAYER_CROUCH_MAXS													'16 16 22'

// Fields

// Support Array-Based Clients
// entity		enClients[32];
// float		nClientCnt;

// Support Punchangle Suppression Time
.float		tSuppressPunchAngleTime;

// Support Frags Set Transition Flag
.float		bFragsSetAtTransition;

// Support Base Properties
.float		nEntityHealthAtSpawn;
.float		nGibHealth;

.float		bIgnoreRadiusDamage;
.float		fRadiusDamageRatio;
.float		bRadiusDamageRatioOverride;

// Support Bleeds Sparks(walls, brushes, statues in Rogue, etc)
.float		bBleedsSparks;

// Support Bleed Entities
/*
.float nNumBleedEntitiesSpawned;
.entity enBleedEntity[3];
*/

// Support Wall Stuck Monster Debug
float		g_nNumWallStuckMonsters;
.float		tMonsterStartTimeDelay;
.float		nSolidityAtSpawn;
.float		nMovetypeAtSpawn;

// Support Spikeshooter Parameters
.float		bIsSilentSpikeshooter;

// Support Item Dropout Debug
float		nNumItemsDroppedOut;
float		nNumExplodingItemsDroppedOut;

// Support Legacy item_weapon Debug
float		nNumLegacyItemWeapons;

// Support Respawn Type
.float		fRespawnType;
.vector		vLastDeathOrigin;
.float		nLastEquippedWeapon;
.float		fRespawnAtDeathLocationReuseTime;

// Support Last Damage Velocity
// Used for directional gibs
.vector		vLastDamageVelocity;
// Support Force Damage Momentum
.float		bForceDamageMomentum;
.float		bIgnoreDamageMomentum;
// Support DamageForce Functions
.float		fPreDamageForce_Multiplier;
.void()		th_PreDamageForce;
.void()		th_PostDamageForce;
// Support Monster Killed Counter
.float		nNumTimesKilled;
// Support Gib Type
.float		nGibType;
// Support Monster Clone
.float		bMonsterIsClone;
.float		bIsClassReplacement;

// Support Is Corpse
.float		bIsCorpse;
//Support is Gibbed Corpse
.float		bIsGibbedCorpse;

// Support Number of Corpse Twitches
.float		nNumCorpseTwitches;

// Support Previous Skill
float		nPreviousSkill;

// Rogue Cutscene
float	g_RogueCutScene_Running;