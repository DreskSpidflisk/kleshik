// DRESK
// Weapons

// Definitions
#define WEAPON_GENERICWEAPONFIRE							te_GenericWeaponFire(vCurrentShotOrigin, v_forward)

// #define WEAPON_UPDATECURRENTAMMO

// Fields
// float	nWeaponEntityImpulses[10];
.float	nWeaponPickup_AmmoType;

float	g_nNumCurrentProximityBombs;

// Functions
void UpdateCurrentWeaponEntity(entity enEntity)
{ // Update Current Weapon Entity
	enEntity.enCurrentWeaponEntity = SG_WeaponEntity_GetWeaponEntityFromWeaponID(enEntity.weapon);
}
void RegisterWeaponEntityToImpulse(entity enWeaponEntity, float nImpulse)
{ // Register Weapon Entity to Impulse
	
}
void weapon_touch()
{
	local float leave;

	if (!(other.flags & FL_CLIENT))
		return;
	// DRESK
	// Prevent dead-player pickup (it happens!)
	if (other.health <= 0)
		return;
		
	// Backup Self
	local entity enOldSelf;
		enOldSelf = self;
		
	// DRESK
	// Support Clone Item Touch
	if(self.enCloneItem)
	{ // Clone Item Exists
		// Invoke Clone Item Touch Function
		self = self.enCloneItem;
		self.touch();
		// Restore Self
		self = enOldSelf;
	}
	// DRESK
	// Support Cooperative Shared Weapons
	local float bSkipLocalMessage;
	bSkipLocalMessage = CheckCooperativeSharedWeaponAddition(other, self.nCSQCStat_Weapons);

	// DRESK
	// Support Dropped Items
	if ( (deathmatch == 2 || coop) && !self.bIsDroppedItem)
		leave = 1;
	else
		leave = 0;
		
	// DRESK
	// Check Update Advanced Statistics
	// NOTE: Necessary to call here to apply statistic
	// even if player already has item.
	CheckUpdatedAdvancedStatistics();
	
	// DRESK
	// Process Targets Always
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
	
	// Check for Leaving Weapon
	if(leave && other.nCSQCStat_Weapons & self.nCSQCStat_Weapons)
		// Player has Weapon; Leave
		return;
	// Add Item to Player
	other.nCSQCStat_Weapons = other.nCSQCStat_Weapons | self.nCSQCStat_Weapons;
	
	// Add Ammo to Player
	if(g_bCoopSharedAmmo)
	{ // Cooperative Shared Ammo Enabled
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_SHELLS)
			UpdateSharedAmmo(AMMOTYPE_SHELLS, self.aflag);
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_NAILS)
			UpdateSharedAmmo(AMMOTYPE_NAILS, self.aflag);
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_ROCKETS)
			UpdateSharedAmmo(AMMOTYPE_ROCKETS, self.aflag);
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_CELLS)
			UpdateSharedAmmo(AMMOTYPE_CELLS, self.aflag);
	}
	else
	{ // Local Ammo
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_SHELLS)
			other.ammo_shells += self.aflag;
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_NAILS)
			other.ammo_nails += self.aflag;
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_ROCKETS)
			other.ammo_rockets += self.aflag;
		else
		if(self.nWeaponPickup_AmmoType == AMMOTYPE_CELLS)
			other.ammo_cells += self.aflag;
	}
	
	// Display Message
	if(!bSkipLocalMessage && !SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Weapon) )
	{ // Display Local Message
		local string strMessage;
		local string strAmmo;
			strAmmo = ftos(self.aflag);
			
		strMessage = strcat("You get the ^2", self.netname, "^7, ^2", strAmmo, "^7 ", SG_GetAmmoNameFromID(self.nWeaponPickup_AmmoType), "\n");
		sprint(other, strMessage);
	}
	
	// Play Touch Sound
	if(!self.bIsCloneItem)
		sound (other, CHAN_AUTO, "weapons/pkup.wav", 1, ATTN_NORM);
	
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif

	// Cap Ammo
	BoundAmmo(other);

	// Assign Current Ammo
	self = other;
	W_SetCurrentAmmo(FALSE);
	self = enOldSelf;

	if (leave)
		return;

	// remove it in single player, or setup for respawning in deathmatch
	// DRESK
	// Remove Dropped Item
	if(self.bIsDroppedItem)
		remove(self);
	else
	{
		// DRESK
		// Support Faded Items
		if( !CheckFadedItem() )
			self.model = string_null;
		self.solid = SOLID_NOT;
		if (deathmatch == 1)
			self.nextthink = time + 30;
		self.think = SUB_regen;
	}
}
/*QUAKED weapon_supershotgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_supershotgun()
{
	precache_model ("progs/g_shot.mdl");
	setmodel (self, "progs/g_shot.mdl");
	self.nCSQCStat_Weapons = WEAPON_SUPER_SHOTGUN;
	self.netname = "Super Shotgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 5;
	self.nWeaponPickup_AmmoType = AMMOTYPE_SHELLS;
	
	StartItem ();
}

/*QUAKED weapon_nailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_nailgun()
{
	precache_model ("progs/g_nail.mdl");
	setmodel (self, "progs/g_nail.mdl");
	self.nCSQCStat_Weapons = WEAPON_NAILGUN;
	self.netname = "Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_NAILS;
	
	StartItem ();
}

/*QUAKED weapon_supernailgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_supernailgun()
{
	precache_model ("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	self.nCSQCStat_Weapons = WEAPON_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_NAILS;
	
	StartItem ();
}

/*QUAKED weapon_grenadelauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_grenadelauncher()
{
	precache_model ("progs/g_rock.mdl");
	setmodel (self, "progs/g_rock.mdl");
	self.nCSQCStat_Weapons = WEAPON_GRENADE_LAUNCHER;
	
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 5;
	self.nWeaponPickup_AmmoType = AMMOTYPE_ROCKETS;
	
	StartItem ();
}

/*QUAKED weapon_rocketlauncher (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_rocketlauncher()
{
	precache_model ("progs/g_rock2.mdl");
	setmodel (self, "progs/g_rock2.mdl");
	self.nCSQCStat_Weapons = WEAPON_ROCKET_LAUNCHER;
	
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 5;
	self.nWeaponPickup_AmmoType = AMMOTYPE_ROCKETS;
	
	StartItem ();
}


/*QUAKED weapon_lightning (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_lightning()
{
	precache_model ("progs/g_light.mdl");
	setmodel (self, "progs/g_light.mdl");
	self.nCSQCStat_Weapons = WEAPON_LIGHTNING;
	
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 15;
	self.nWeaponPickup_AmmoType = AMMOTYPE_CELLS;
	
	StartItem ();
}
/*QUAKED weapon_mjolnir (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_mjolnir()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	precache_model ("progs/g_hammer.mdl");
	setmodel (self, "progs/g_hammer.mdl");
	
	// DRESK
	// Weapon Fix
	self.nCSQCStat_Weapons = WEAPON_MJOLNIR;
	
	self.netname = "Mjolnir";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_CELLS;
	
	StartItem ();
}

/*QUAKED weapon_laser_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void weapon_laser_gun()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	precache_model ("progs/g_laserg.mdl");
	setmodel (self, "progs/g_laserg.mdl");
	// DRESK
	// Weapon Fix
	self.nCSQCStat_Weapons = WEAPON_LASER_CANNON;
	
	self.netname = "Laser Cannon";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_CELLS;
	
	StartItem ();
}
void weapon_laser_gun_kleshik()
{
	self.nCSQCStat_Weapons = WEAPON_LASER_GUN;
	
	precache_model("Models/Weapons/LaserGun/ExternalWeapon.mdl");
	setmodel (self, "Models/Weapons/LaserGun/ExternalWeapon.mdl");
	
	self.netname = "Laser Gun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_CELLS;
	
	StartItem ();
}
void weapon_flechette_cannon()
{
	self.nCSQCStat_Weapons = WEAPON_FLECHETTE_CANNON;
	
	precache_model("Models/Weapons/FlechetteCannon/ExternalWeapon.mdl");
	setmodel (self, "Models/Weapons/FlechetteCannon/ExternalWeapon.mdl");
	
	self.netname = "Flechette Cannon";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_NAILS;
	
	StartItem ();
}
void weapon_chain_gun()
{
	self.nCSQCStat_Weapons = WEAPON_CHAIN_GUN;
	
	precache_model("progs/g_nail2.mdl");
	setmodel (self, "progs/g_nail2.mdl");
	
	self.netname = "Chain Gun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	self.aflag = 30;
	self.nWeaponPickup_AmmoType = AMMOTYPE_NAILS;
	
	StartItem ();
}

/*QUAKED weapon_proximity_gun (0 .5 .8) (-16 -16 0) (16 16 32)
*/
void weapon_proximity_gun()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	precache_model ("progs/g_prox.mdl");
	setmodel (self, "progs/g_prox.mdl");
	
	// DRESK
	// Weapon Fix
	self.nCSQCStat_Weapons = WEAPON_PROXIMITY_GUN;
	
	self.netname = "Proximity Gun";
	self.touch = weapon_touch;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Assign Ammo Amount Here
	self.aflag = 6;
	self.nWeaponPickup_AmmoType = AMMOTYPE_ROCKETS;
	
	StartItem ();
}
/*
=============
Deathmatch_Weapon

Deathmatch weapon change rules for picking up a weapon

.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;
=============
*/
void Deathmatch_Weapon(float nOld, float nNew)
{
	local float or2, nr;

// change self.weapon if desired
	or2 = RankForWeapon (self.weapon);
	nr = RankForWeapon (nNew);
	if ( nr < or2 )
	{
		self.weapon = nNew;
		UpdateCurrentWeaponEntity(self);
	}
}
float RankForWeapon(float w)
{
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{ // Hipnotic Mode
		if (w == WEAPON_LIGHTNING)
			return 1;
		if (w == WEAPON_ROCKET_LAUNCHER)
			return 2;
		if (w == WEAPON_LASER_CANNON)
			return 3;
		if (w == WEAPON_SUPER_NAILGUN)
			return 4;
		if (w == WEAPON_PROXIMITY_GUN)
			return 5;
		if (w == WEAPON_GRENADE_LAUNCHER)
			return 6;
		if (w == WEAPON_SUPER_SHOTGUN)
			return 7;
		if (w == WEAPON_NAILGUN)
			return 8;
		if (w == WEAPON_MJOLNIR)
			return 9;
		return 10;
	}
	else
	{ // Regular Mode
		if (w == WEAPON_LIGHTNING)
			return 1;
		if (w == WEAPON_ROCKET_LAUNCHER)
			return 2;
		if (w == WEAPON_SUPER_NAILGUN)
			return 3;
		if (w == WEAPON_GRENADE_LAUNCHER)
			return 4;
		if (w == WEAPON_SUPER_SHOTGUN)
			return 5;
		if (w == WEAPON_NAILGUN)
			return 6;
		return 7;
	}
}
void BoundAmmo(entity enEntity)
{
	// DRESK
	// Support Cooperative Shared Ammo Pool
	if(g_bCoopSharedAmmo)
		// Do NOT Bound Local Ammunition
		return;
		
	// DRESK
	// Support CVar-based Max Ammo
	local float fMaxShells;
		fMaxShells = cvar(CVAR_AMMO_MAXSHELLS);
	local float fMaxNails;
		fMaxNails = cvar(CVAR_AMMO_MAXNAILS);
	local float fMaxRockets;
		fMaxRockets = cvar(CVAR_AMMO_MAXROCKETS);
	local float fMaxCells;
		fMaxCells = cvar(CVAR_AMMO_MAXCELLS);
		
	if (enEntity.ammo_shells > fMaxShells)
		enEntity.ammo_shells = fMaxShells;
	if (enEntity.ammo_nails > fMaxNails)
		enEntity.ammo_nails = fMaxNails;
	if (enEntity.ammo_rockets > fMaxRockets)
		enEntity.ammo_rockets = fMaxRockets;
	if (enEntity.ammo_cells > fMaxCells)
		enEntity.ammo_cells = fMaxCells;
}
void DropNewWeapon(float nWeapon)
{ // Drop New Weapon
	// NOTE: Assumed scope is entity to drop weapon.
	local entity enDropper;
	local entity enPowerup;
	local float bBadItem;
	
	// Backup Entity
	enDropper = self;
	self = enPowerup;
	
	// Spawn Powerup
	self = spawn();
	// Assign Dropped Item
	self.bIsDroppedItem = TRUE;
	
	switch(nWeapon)
	{
		case WEAPON_SUPER_SHOTGUN:
			self.classname = "weapon_supershotgun";
			weapon_supershotgun();
		break;
		case WEAPON_NAILGUN:
			self.classname = "weapon_nailgun";
			weapon_nailgun();
		break;
		case WEAPON_SUPER_NAILGUN:
			self.classname = "weapon_supernailgun";
			weapon_supernailgun();
		break;
		case WEAPON_GRENADE_LAUNCHER:
			self.classname = "weapon_grenadelauncher";
			weapon_grenadelauncher();
		break;
		case WEAPON_ROCKET_LAUNCHER:
			self.classname = "weapon_rocketlauncher";
			weapon_rocketlauncher();
		break;
		case WEAPON_LIGHTNING:
			self.classname = "weapon_lightning";
			weapon_lightning();
		break;
		case WEAPON_PROXIMITY_GUN:
			self.classname = "weapon_proximity_gun";
			weapon_proximity_gun();
		break;
		case WEAPON_LASER_CANNON:
			self.classname = "weapon_laser_gun";
			weapon_laser_gun();
		break;
		case WEAPON_MJOLNIR:
			self.classname = "weapon_mjolnir";
			weapon_mjolnir();
		case WEAPON_LASER_GUN:
			self.classname = "weapon_laser_gun_kleshik";
			weapon_laser_gun_kleshik();
			break;
		break;
		default:
			bBadItem = TRUE;
		break;
	}
	
	if(bBadItem)
	{ // Bad Item
		remove(self);
	}
	else
	{ // Toss Item
		TossItem(enDropper, self);
		
		// Apply Gyro Physics Properties
		if(g_bGyroPhysicsEnabled)
		{
			// Assign Movetype to Bounce
			self.movetype = MOVETYPE_BOUNCE;
			Gyro_ObjectMacro_Grenade(self, 800);
		}
	}
	
	// Restore Entity
	self = enDropper;
}
void DropWeapons()
{ // Drop Weapons
	// NOTE: Assumed scope is entity to drop weapons.
	if(self.nCSQCStat_Weapons & WEAPON_SUPER_SHOTGUN)
		DropNewWeapon(WEAPON_SUPER_SHOTGUN);
	if(self.nCSQCStat_Weapons & WEAPON_NAILGUN)
		DropNewWeapon(WEAPON_NAILGUN);
	if(self.nCSQCStat_Weapons & WEAPON_SUPER_NAILGUN)
		DropNewWeapon(WEAPON_SUPER_NAILGUN);
	if(self.nCSQCStat_Weapons & WEAPON_GRENADE_LAUNCHER)
		DropNewWeapon(WEAPON_GRENADE_LAUNCHER);
	if(self.nCSQCStat_Weapons & WEAPON_ROCKET_LAUNCHER)
		DropNewWeapon(WEAPON_ROCKET_LAUNCHER);
	if(self.nCSQCStat_Weapons & WEAPON_LIGHTNING)
		DropNewWeapon(WEAPON_LIGHTNING);
	if(self.nCSQCStat_Weapons & WEAPON_PROXIMITY_GUN)
		DropNewWeapon(WEAPON_PROXIMITY_GUN);
	if(self.nCSQCStat_Weapons & WEAPON_LASER_CANNON)
		DropNewWeapon(WEAPON_LASER_CANNON);
	if(self.nCSQCStat_Weapons & WEAPON_MJOLNIR)
		DropNewWeapon(WEAPON_MJOLNIR);
	if(self.nCSQCStat_Weapons & WEAPON_LASER_GUN)
		DropNewWeapon(WEAPON_LASER_GUN);
}
float GetAmmoAmountFromAmmoType(entity enPlayer, float nAmmoType)
{ // Return Ammo Amount from Ammo Type
	if(nAmmoType == AMMOTYPE_SHELLS)
		return enPlayer.ammo_shells;
	else
	if(nAmmoType == AMMOTYPE_NAILS)
		return enPlayer.ammo_nails;
	else
	if(nAmmoType == AMMOTYPE_ROCKETS)
		return enPlayer.ammo_rockets;
	else
	if(nAmmoType == AMMOTYPE_CELLS)
		return enPlayer.ammo_cells;
	else
		return 0;
}
float GetActiveWeaponAmmoAmount(entity enPlayer)
{ // Return Active Weapon Ammo Amount
	return( GetAmmoAmountFromAmmoType(enPlayer, enPlayer.enCurrentWeaponEntity.nWeaponEntity_AmmoTypeUsed) );
}