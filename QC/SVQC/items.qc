/* ALL LIGHTS SHOULD BE 0 1 0 IN COLOR ALL OTHER ITEMS SHOULD
BE .8 .3 .4 IN COLOR */

void SUB_regen()
{
	// DRESK
	// Check for Faded Item
	CheckRespawnFadedItem();
	
	
	self.model = self.mdl;		// restore original model
	self.solid = SOLID_TRIGGER;	// allow it to be touched again
	// sound (self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);	// play respawn sound
	setorigin (self, self.origin);
	
	// DRESK
	// Utilize Temporary Entity for Feedback
	te_ItemRespawn(self.origin);
	
	// DRESK
	// Check for Exploding Item Box
	if( cvar(CVAR_EXPLODINGITEMBOX_INCLUDEITEMRESPAWNS) )
		CheckExplodingItemBox();
};



/*QUAKED noclass (0 0 0) (-8 -8 -8) (8 8 8)
prints a warning message when spawned
*/
void noclass()
{
	dprint ("noclass spawned at");
	dprint (vtos(self.origin));
	dprint ("\n");
	remove (self);
};



/*
============
PlaceItem

plants the object on the floor
============
*/
void PlaceItem()
{
	local float	oldz;

	self.mdl = self.model;		// so it can be restored on respawn
	self.flags = FL_ITEM;		// make extra wide
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	
	// DRESK
	// Check for Exploding Item Box
	// NOTE: Check BEFORE Dropping Original Item to Floor
	CheckExplodingItemBox();
	// Check for Legacy Item
	CheckLegacyItemSpawn();
	
	if (!droptofloor())
	{
		// DRESK
		// Increment Debug Counter
		nNumItemsDroppedOut = nNumItemsDroppedOut + 1;
		
		dprint ("Bonus item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
	}
	
	// Register Advanced Statistics
	if(self.touch == weapon_touch)
	{
		RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_WEAPON);
		// Angle Weapons
		self.angles_x = 20;
	}
	else
	if(self.touch == powerup_touch)
		RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_POWERUP);
	else
	if(self.touch == health_touch
		|| self.touch == ammo_touch
		|| self.touch == armor_touch)
	{
		RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_HEALTHARMORAMMO);
			// Slightly Angle all Items
		self.angles_y = random() * 15;
		if(random() < 0.5)
			self.angles_y *= -1;
	}
	else
		RegisterAdvancedGameStatistic(5);
};

/*
============
StartItem

Sets the clipping size and plants the object on the floor
============
*/
void StartItem()
{
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
	
	// DRESK
	// Check for Ambient Sound Spawn
	CheckAmbientSoundSpawn();
}

/*
=========================================================================

HEALTH BOX

=========================================================================
*/
//
// T_Heal: add health to an entity, limiting health to max_health
// "ignore" will ignore max_health limit
//
float T_Heal(entity e, float healamount, float ignore)
{
	if (e.health <= 0)
		return 0;
	if ((!ignore) && (e.health >= other.max_health))
		return 0;
	healamount = ceil(healamount);

	e.health = e.health + healamount;
	if ((!ignore) && (e.health >= other.max_health))
		e.health = other.max_health;
		
	if (e.health > 250)
		e.health = 250;
		
	// DRESK
	// Check for Bleeding
	CheckCreatureBleeding(e);
	
	return 1;
};

/*QUAKED item_health (.3 .3 1) (0 0 0) (32 32 32) rotten megahealth
Health box. Normally gives 25 points.
Rotten box heals 5-10 points,
megahealth will add 100 health, then 
rot you down to your maximum health limit, 
one point per second.
*/

float	H_ROTTEN = 1;
float	H_MEGA = 2;
.float	healamount, healtype;
void() health_touch;
void() item_megahealth_rot;

// DRESK
// C-STYLE FUNCTION SYNTAX
void item_health()
{	
	self.touch = health_touch;

	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");

		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else
	if (self.spawnflags & H_MEGA)
	{
		precache_model("maps/b_bh100.bsp");
		precache_sound("items/r_item2.wav");
		setmodel(self, "maps/b_bh100.bsp");
		self.noise = "items/r_item2.wav";
		self.healamount = 100;
		self.healtype = 2;
	}
	else
	{
		precache_model("maps/b_bh25.bsp");
		precache_sound("items/health1.wav");
		setmodel(self, "maps/b_bh25.bsp");
		self.noise = "items/health1.wav";
		self.healamount = 25;
		self.healtype = 1;
	}
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
};

// DRESK
// C-STYLE FUNCTION SYNTAX
void health_touch()
{
	// DRESK
	// Unused Variable(s)
	// local	float amount;
	// local	string	s;
	
	if (other.classname != "player")
		return;
	// DRESK
	// Prevent dead-player pickup (it happens!)
	if (other.health <= 0)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	// NOTE: Necessary to call here to apply statistic
	// even if player already has item.
	CheckUpdatedAdvancedStatistics();
	
	if (self.healtype == 2) // Megahealth?  Ignore max_health...
	{
		if (other.health >= 250)
			return;
		if (!T_Heal(other, self.healamount, 1))
			return;
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
			return;
	}
	
	// DRESK
	// Advanced Message
	local string strMessage;
	strMessage = strcat("You receive ^2", ftos(self.healamount), "^7 health\n");
	// Support Disabled Item Pickup Messages
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Health) )
		sprint(other, strMessage);
	/*
	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");
	*/
	
	// health touch sound
	sound(other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	
	// DRESK
	// Increment Number of Items Picked Up
	// NOTE: Including Only Ammo as of Now
	// UpdateClientStatsScore(other, CLIENTSCORE_NUMITEMSPICKEDUP, 1);

	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	// DRESK
	// Support Faded Items
	if( !CheckFadedItem() )
		// Non-Faded Item
		self.model = string_null;
	self.solid = SOLID_NOT;

	// DRESK
	// Dont' do this rot shit
	/*
	// Megahealth = rot down the player's super health
	if (self.healtype == 2)
	{
		// DRESK - HIPNOTIC SUPPORT
		// Superhealth Item Truly not Necessary; Suppressing
		// other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	*/
	if (deathmatch != 2)		// deathmatch 2 is the silly old rules
	{
		// DRESK
		// Support Coop Respawn Items
		if (deathmatch || CheckCooperativeItemRespawn( cvar(CVAR_ITEM_RESPAWNTIME_AMMOHEALTH) ) )
		{
			if(self.healtype == 2)
				self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_AMMOHEALTH) * 5;
			else
				self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_AMMOHEALTH);
		}
		self.think = SUB_regen;
	}
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void item_megahealth_rot()
{
	other = self.owner;
	
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}

	// it is possible for a player to die and respawn between rots, so don't
	// just blindly subtract the flag off
	// DRESK - HIPNOTIC SUPPORT
	// Superhealth Item Truly not Necessary; Suppressing
	// other.items = other.items - (other.items & IT_SUPERHEALTH);
	
	if (deathmatch == 1 || CheckCooperativeItemRespawn( cvar(CVAR_ITEM_RESPAWNTIME_MEGAHEALTH) ) )	// deathmatch 2 is silly old rules
	{
		self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_MEGAHEALTH);
		self.think = SUB_regen;
	}
};

/*
===============================================================================

ARMOR

===============================================================================
*/

void() armor_touch;

// DRESK
// C-STYLE FUNCTION SYNTAX
void armor_touch()
{
	local	float	type, value, bit;
	
	if (other.health <= 0)
		return;
	if (other.classname != "player")
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	// NOTE: Necessary to call here to apply statistic
	// even if player already has item.
	if(!self.bIsDroppedItem)
		CheckUpdatedAdvancedStatistics();

	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = ITEM_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = ITEM_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = ITEM_ARMOR3;
	}
	if (other.armortype*other.armorvalue >= type*value)
		return;
		
	other.armortype = type;
	other.armorvalue = value;
	// DRESK
	// Set Current Armor Max Armor Value
	other.nCurrentArmorMaxArmorValue = value;
	other.items = other.items - (other.items & (ITEM_ARMOR1 | ITEM_ARMOR2 | ITEM_ARMOR3)) + bit;

	// DRESK
	// Support Faded Items
	if( !CheckFadedItem() )
		// Non-Faded Item
		self.model = string_null;
	self.solid = SOLID_NOT;
	// DRESK
	// Support Coop Respawn Items
	if (deathmatch == 1 || CheckCooperativeItemRespawn( cvar(CVAR_ITEM_RESPAWNTIME_ARMOR) ) )
		self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_ARMOR);
	self.think = SUB_regen;

	// DRESK
	// Calculate Percentile Reduction
	local float fReduction;
		fReduction = rint(type * 100);
	// Support Advanced Armor Pickup
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Armor) )
	{
		local string strMessage;
		strMessage = strcat("You get ^2", ftos(value), "^7 armor for ^2");
			
		strMessage = strcat(strMessage, ftos(fReduction), "%^7 damage reduction\n");
		sprint(other, strMessage);
	}
	sound(other, CHAN_AUTO, "items/armor1.wav", 1, ATTN_NORM);
	
	// DRESK
	// Increment Number of Items Picked Up
	// NOTE: Including Only Ammo as of Now
	//UpdateClientStatsScore(other, CLIENTSCORE_NUMITEMSPICKEDUP, 1);
	
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	// DRESK
	// Remove Dropped Item
	if(self.bIsDroppedItem)
		remove(self);
	else
	{
		activator = other;
		SUB_UseTargets();				// fire all targets / killtargets
	}
};


/*QUAKED item_armor1 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void item_armor1()
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 0;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
};

/*QUAKED item_armor2 (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void item_armor2()
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 1;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
};

/*QUAKED item_armorInv (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void item_armorInv()
{
	self.touch = armor_touch;
	precache_model ("progs/armor.mdl");
	setmodel (self, "progs/armor.mdl");
	self.skin = 2;
	setsize (self, '-16 -16 0', '16 16 56');
	
	// DRESK
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
};

/*
===============================================================================

WEAPONS

===============================================================================
*/

/*
===============================================================================

AMMO

===============================================================================
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void ammo_touch()
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
	
	// DRESK
	// Support CVar-based Max Ammo
	local float fMaxShells;
		if(g_bCoopSharedAmmo)
			fMaxShells = COOPSHAREDAMMO_AMMOMAX_SHELLS;
		else
			fMaxShells = cvar(CVAR_AMMO_MAXSHELLS);
	local float fMaxNails;
		if(g_bCoopSharedAmmo)
			fMaxNails = COOPSHAREDAMMO_AMMOMAX_NAILS;
		else
			fMaxNails = cvar(CVAR_AMMO_MAXNAILS);
	local float fMaxRockets;
		if(g_bCoopSharedAmmo)
			fMaxRockets = COOPSHAREDAMMO_AMMOMAX_ROCKETS;
		else
			fMaxRockets = cvar(CVAR_AMMO_MAXROCKETS);
	local float fMaxCells;
		if(g_bCoopSharedAmmo)
			fMaxCells = COOPSHAREDAMMO_AMMOMAX_CELLS;
		else
			fMaxCells = cvar(CVAR_AMMO_MAXCELLS);
		
	// DRESK
	// Check Update Advanced Statistics
	// NOTE: Necessary to call here to apply statistic
	// even if player already has item.
	CheckUpdatedAdvancedStatistics();


	// shotgun
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= fMaxShells)
			return;
			
		// DRESK
		// Support Cooperative Shared Ammo Pool
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_SHELLS, self.aflag);
		else
			other.ammo_shells = other.ammo_shells + self.aflag;
	}

	// spikes
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= fMaxNails)
			return;
		// DRESK
		// Support Cooperative Shared Ammo Pool
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_NAILS, self.aflag);
		else
			other.ammo_nails = other.ammo_nails + self.aflag;
	}

	//	rockets
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= fMaxRockets)
			return;
		// DRESK
		// Support Cooperative Shared Ammo Pool
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_ROCKETS, self.aflag);
		else
			other.ammo_rockets = other.ammo_rockets + self.aflag;
	}

	//	cells
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= fMaxCells)
			return;
		// DRESK
		// Support Cooperative Shared Ammo Pool
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_CELLS, self.aflag);
		else
			other.ammo_cells = other.ammo_cells + self.aflag;
	}

	BoundAmmo(other);
	
	// DRESK
	// Support Advanced Pickup Message
	local string strMessage;
	// Support Cooperative Shared Ammunition Pool
	if(g_bCoopSharedAmmo)
		strMessage = strcat(other.netname, "^7 got");
	else
		strMessage = "You get";
		
	strMessage = strcat(strMessage, " ^2", ftos(self.aflag), "^7 ", self.netname, "\n");
	
	// Support Disabled Item Pickup Messages
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Ammo) )
	{
		if(g_bCoopSharedAmmo)
			bprint(strMessage);
		else
			sprint(other, strMessage);
	}
	
	// DRESK
	// Increment Number of Items Picked Up
	UpdateClientStatsScore(other, CLIENTSCORE_NUMAMMOPICKEDUP, self.aflag);
	
	// ammo touch sound
	// DRESK
	// Support Shared Cooperative Ammo
	if(g_bCoopSharedAmmo)
		sound (other, CHAN_AUTO, self.noise, 1, ATTN_NONE);
	else
		sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif

	// remove it in single player, or setup for respawning in deathmatch

	// DRESK
	// Support Faded Items
	if( !CheckFadedItem() )
		// Non-Faded Item
		self.model = string_null;
		
	self.solid = SOLID_NOT;
	// DRESK
	// Support Coop Respawn Items
	if (deathmatch == 1|| CheckCooperativeItemRespawn( cvar(CVAR_ITEM_RESPAWNTIME_AMMOHEALTH) ) )
		self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_AMMOHEALTH);
	self.think = SUB_regen;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
}




float WEAPON_BIG2 = 1;

/*QUAKED item_shells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void item_shells()
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_shell1.bsp");
		setmodel (self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model ("maps/b_shell0.bsp");
		setmodel (self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize (self, '0 0 0', '32 32 56');
	self.noise = SOUND_KLESHIK_ITEMS_PICKUPSHELLS;
	StartItem ();
}

/*QUAKED item_spikes (0 .5 .8) (0 0 0) (32 32 32) big
*/

void item_spikes()
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_nail1.bsp");
		setmodel (self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model ("maps/b_nail0.bsp");
		setmodel (self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize (self, '0 0 0', '32 32 56');
	self.noise = SOUND_KLESHIK_ITEMS_PICKUPNAILS;
	StartItem ();
}

/*QUAKED item_rockets (0 .5 .8) (0 0 0) (32 32 32) big
*/

void item_rockets()
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_rock1.bsp");
		setmodel (self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model ("maps/b_rock0.bsp");
		setmodel (self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize (self, '0 0 0', '32 32 56');
	self.noise = SOUND_KLESHIK_ITEMS_PICKUPROCKETS;
	StartItem ();
}


/*QUAKED item_cells (0 .5 .8) (0 0 0) (32 32 32) big
*/

void item_cells()
{
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model ("maps/b_batt1.bsp");
		setmodel (self, "maps/b_batt1.bsp");
		
		// DRESK
		// Additional Cells
		self.aflag = 30;
		// self.aflag = 12;
	}
	else
	{
		precache_model ("maps/b_batt0.bsp");
		setmodel (self, "maps/b_batt0.bsp");
		
		// DRESK
		// Additional Cells
		self.aflag = 15;
		
		// self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize (self, '0 0 0', '32 32 56');
	self.noise = SOUND_KLESHIK_ITEMS_PICKUPCELLS;
	StartItem ();
}


/*QUAKED item_weapon (0 .5 .8) (0 0 0) (32 32 32) shotgun rocket spikes big
DO NOT USE THIS!!!! IT WILL BE REMOVED!
*/

void item_weapon()
{
	local float SHOTGUN = 1;
	local float ROCKET = 2;
	local float SPIKES = 4;
	local float BIG = 8;
	// DRESK
	// Increment Number of Legacy Items
	nNumLegacyItemWeapons = nNumLegacyItemWeapons + 1;
	// Colormod for Recognition
	// self.colormod = '0.5 0.5 1';
	
	// Provide Dynamic Translation to Standard Item
	if(self.spawnflags & SHOTGUN)
	{ // Shells
		if(self.spawnflags & BIG)
			// Assign Standard Spawnflag
			self.spawnflags = WEAPON_BIG2;
		else
			self.spawnflags = 0;
			
		// Translate
		self.classname = "item_shells";
		item_shells();
	}
	else
	if(self.spawnflags & SPIKES)
	{ // Nails
		if(self.spawnflags & BIG)
			// Assign Standard Spawnflag
			self.spawnflags = WEAPON_BIG2;
		else
			self.spawnflags = 0;
			
		// Translate
		self.classname = "item_spikes";
		item_spikes();
	}
	else
	if(self.spawnflags & ROCKET)
	{ // Rockets
		if(self.spawnflags & BIG)
			// Assign Standard Spawnflag
			self.spawnflags = WEAPON_BIG2;
		else
			self.spawnflags = 0;
			
		// Translate
		self.classname = "item_rockets";
		item_rockets();
	}
	/*
	
	self.touch = ammo_touch;

	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_shell1.bsp");
			setmodel (self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_shell0.bsp");
			setmodel (self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}

	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_nail1.bsp");
			setmodel (self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model ("maps/b_nail0.bsp");
			setmodel (self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}

	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model ("maps/b_rock1.bsp");
			setmodel (self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model ("maps/b_rock0.bsp");
			setmodel (self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	
	setsize (self, '0 0 0', '32 32 56');
	StartItem ();
	*/
};


/*
===============================================================================

KEYS

===============================================================================
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void key_touch()
{
	// DRESK
	// Unused Variable(s)
	// local entity	stemp;
	// local float	best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	// NOTE: Necessary to call here to apply statistic
	// even if player already has item.
	CheckUpdatedAdvancedStatistics();
	
	if (other.nCSQCStat_Keys & self.nCSQCStat_Keys)
		return;
	
	// DRESK
	// Support Global Sounds
	{ // Play Normal Sound
		if( cvar(CVAR_ITEM_POWERUP_GLOBALPICKUPSOUNDS) )
			sound (world, CHAN_AUTO, self.noise, 1, ATTN_NONE);	
		else
			sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	}
	
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	// DRESK
	// Add Key to Shared Keys
	g_nCoopSharedKeys = g_nCoopSharedKeys | self.nCSQCStat_Keys;
	// other.nCSQCStat_Keys = other.nCSQCStat_Keys | self.nCSQCStat_Keys;
	// Sync Shared Keys
	SyncSharedKeys();
	
	// DRESK
	// Support Floating Keys
	CheckFloatingKeys(other);
	
	// Check for Teleport Update
	local float bAddedTeleportKey;
	bAddedTeleportKey = PersonalTeleporter_CheckTeleportKeysUpdate(self);
	
	// DRESK
	// Check for Broadcast
	if(coop)
	{ // Broadcast
		if(bAddedTeleportKey)
		{ // New Teleport Key
			// Generate Message
			local string strMessage;
				strMessage = strcat(other.netname, "^7 acquired the ^2", self.netname, "^7!\n");
				bprint(strMessage);
		}
	}
	else
	{ // Standard System
		sprint (other, "You get the ^2");
		sprint (other, self.netname);
		sprint (other, "\n");
	}

	// DRESK
	// ALWAYS Fade Key, since in single-player you can't respawn,
	// and in cooperative the key is sent to all players and is kept through respawns.
	if( !CheckFadedItem() )
		self.model = string_null;
	self.solid = SOLID_NOT;

	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


void key_setsounds()
{
	if (world.worldtype == 0)
	{
		precache_sound ("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	else
	if (world.worldtype == 1)
	{
		precache_sound ("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	else
	if (world.worldtype == 2)
	{
		precache_sound2 ("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

/*QUAKED item_key1 (0 .5 .8) (-16 -16 -24) (16 16 32)
SILVER key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void item_key1()
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_s_key.mdl");
		setmodel (self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else if (world.worldtype == 1)
	{
		precache_model ("progs/m_s_key.mdl");
		setmodel (self, "progs/m_s_key.mdl");
		self.netname = "silver runekey";
	}
	else if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_s_key.mdl");
		setmodel (self, "progs/b_s_key.mdl");
		self.netname = "silver keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	
	// DRESK
	// Change Inventory
	// self.items = ITEM_KEY1;
	self.nCSQCStat_Keys = KEY_SILVER;
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Assign Additional Effects to Key
	self.modelflags = MF_ROTATE;
	// self.effects = self.effects | EF_STARDUST;
	
	StartItem ();
};

/*QUAKED item_key2 (0 .5 .8) (-16 -16 -24) (16 16 32)
GOLD key
In order for keys to work
you MUST set your maps
worldtype to one of the
following:
0: medieval
1: metal
2: base
*/

void item_key2()
{
	if (world.worldtype == 0)
	{
		precache_model ("progs/w_g_key.mdl");
		setmodel (self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model ("progs/m_g_key.mdl");
		setmodel (self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2 ("progs/b_g_key.mdl");
		setmodel (self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	
	
	// DRESK
	// Change Inventory
	// self.items = ITEM_KEY2;
	self.nCSQCStat_Keys = KEY_GOLD;
	
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Assign Additional Effects to Key
	self.modelflags = MF_ROTATE;
	// self.effects = self.effects | EF_STARDUST;
	
	StartItem ();
};



/*
===============================================================================

END OF LEVEL RUNES

===============================================================================
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void sigil_touch()
{
	// DRESK
	// Unused Variable(s)
	// local entity	stemp;
	// local float	best;

	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	CheckUpdatedAdvancedStatistics();

	// DRESK
	// Check for Broadcast
	if(coop)
	{ // Broadcast
		// Generate Message
		local string strMessage;
			strMessage = strcat(other.netname, "^7 acquired the ^2rune^7!\n");
			bprint(strMessage);
	}
	else
		centerprint (other, "You got the ^2rune^7!");

	// DRESK
	// Support Global Sounds
	if( cvar(CVAR_ITEM_POWERUP_GLOBALPICKUPSOUNDS) )
		sound (world, CHAN_AUTO, self.noise, 1, ATTN_NONE);	
	else
		sound (other, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	self.solid = SOLID_NOT;
	self.model = string_null;
	
	// DRESK
	// Disable Serverflags for now (not sure how I want to handle this)
	// serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";		// so rune doors won't find it
	
	activator = other;
	SUB_UseTargets();				// fire all targets / killtargets
};


/*QUAKED item_sigil (0 .5 .8) (-16 -16 -24) (16 16 32) E1 E2 E3 E4
End of level sigil, pick up to end episode and return to jrstart.
*/

void item_sigil()
{
	if (!self.spawnflags)
		objerror ("no spawnflags");

	precache_sound ("misc/runekey.wav");
	self.noise = "misc/runekey.wav";

	if (self.spawnflags & 1)
	{
		precache_model ("progs/end1.mdl");
		setmodel (self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2 ("progs/end2.mdl");
		setmodel (self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2 ("progs/end3.mdl");
		setmodel (self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2 ("progs/end4.mdl");
		setmodel (self, "progs/end4.mdl");
	}
	
	self.touch = sigil_touch;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
}

/*
===============================================================================

PLAYER BACKPACKS

===============================================================================
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void BackpackTouch()
{
	local string	s;
	local	float	best, old, new;
	local		entity	stemp;
	local	float	acount;
	
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		
	// DRESK
	// Generate Message (defer sprints)
	local string strAmmoMessage;
		
	// DRESK
	// Support Cooperative Backpack Tracking
	if( coop && cvar(CVAR_COOP_BROADCASTPLAYERBACKPACKPICKUPS) && self.owner)
	{ // Cooperative Backpack Tracking
		// Broadcast Pickup
		local string strMessage;
			strMessage = strcat(other.netname, "^7 picked up ");
			if(other == self.owner)
				strMessage = strcat(strMessage, SG_GetSexVerbiage(other.nPlayerModelSex, "his"), " backpack!\n");
			else
				strMessage = strcat(strMessage, self.owner.netname, "^7's backpack!\n");
			bprint(strMessage);
	}

	acount = 0;
	
	// Support Cooperative Shared Ammunition Pool
	if(g_bCoopSharedAmmo)
		strAmmoMessage = strcat(other.netname, "^7 got ^2");
	else
		strAmmoMessage = "You get ^2";
	// sprint (other, "You get ^2");

	if (self.nCSQCStat_Weapons)
		if ((other.nCSQCStat_Weapons & self.nCSQCStat_Weapons) == 0)
		{
			acount = 1;
			strAmmoMessage = strcat(strAmmoMessage, "^7the ^2");
			// sprint (other, "^7the ^2");
			strAmmoMessage = strcat(strAmmoMessage, self.netname);
			// sprint (other, self.netname);
			strAmmoMessage = strcat(strAmmoMessage, "^7");
			// sprint (other, "^7");
		}

// if the player was using his best weapon, change up to the new one if better		
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;

// change weapons
	// DRESK
	// Support New Player Backpack System
	// New system assigns player to max ammunition value, no longer
	// adding ammo to prevent whoring in cooperative.
	local float bReplacementBackpack;
	local string strSound;
	local float nNumAmmoTypes;
	local float fShells;
		fShells = other.ammo_shells;
	local float fNails;
		fNails = other.ammo_nails;
	local float fRockets;
		fRockets = other.ammo_rockets;
	local float fCells;
		fCells = other.ammo_cells;
	if( (coop) && (cvar(CVAR_COOP_PLAYERBACKPACKSYSTEM) == 1) && (self.owner) )
	{ // New System
		// NOTE : self.owner means the backpack dropped from a player.
		bReplacementBackpack = TRUE;
		other.ammo_shells = max(other.ammo_shells, self.ammo_shells);
			fShells = self.ammo_shells - fShells;
			if(fShells < 0)
				fShells = 0;
		other.ammo_nails = max(other.ammo_nails, self.ammo_nails);
			fNails = self.ammo_nails - fNails;
			if(fNails < 0)
				fNails = 0;
		other.ammo_rockets = max(other.ammo_rockets, self.ammo_rockets);
			fRockets = self.ammo_rockets - fRockets;
			if(fRockets < 0)
				fRockets = 0;
		other.ammo_cells = max(other.ammo_cells, self.ammo_cells);
			fCells = self.ammo_cells - fCells;
			if(fCells < 0)
				fCells = 0;
	}
	else
	{ // Old System
		bReplacementBackpack = FALSE;
		other.ammo_shells = other.ammo_shells + self.ammo_shells;
			fShells = self.ammo_shells;
		other.ammo_nails = fNails = other.ammo_nails + self.ammo_nails;
			fNails = self.ammo_nails;
		other.ammo_rockets = fRockets = other.ammo_rockets + self.ammo_rockets;
			fRockets = self.ammo_rockets;
		other.ammo_cells = fCells = other.ammo_cells + self.ammo_cells;
			fCells = self.ammo_cells;
	}

	new = self.nCSQCStat_Weapons;
	if (!new)
		new = other.weapon;
	old = other.nCSQCStat_Weapons;
	other.nCSQCStat_Weapons = other.nCSQCStat_Weapons | new;
	
	BoundAmmo(other);

	// if (self.ammo_shells)
	if(fShells > 0 || bReplacementBackpack)
	{
		if (acount)
			strAmmoMessage = strcat(strAmmoMessage, ", ^2");
			// sprint(other, ", ^2");
		acount = 1;
		// s = ftos(self.ammo_shells);
		s = ftos(fShells);
		strAmmoMessage = strcat(strAmmoMessage, s);
		// sprint (other, s);
		strAmmoMessage = strcat(strAmmoMessage, "^7 shells");
		// sprint (other, "^7 shells");
		
		// Assign Sound
		nNumAmmoTypes = nNumAmmoTypes + 1;
		strSound = SOUND_KLESHIK_ITEMS_PICKUPSHELLS;
		
		// DRESK
		// Increment Ammo Acquired
		UpdateClientStatsScore(other, CLIENTSCORE_NUMAMMOPICKEDUP, fShells);
	}
	// if (self.ammo_nails)
	if(fNails > 0 || bReplacementBackpack)
	{
		if (acount)
			strAmmoMessage = strcat(strAmmoMessage, ", ^2");
			// sprint(other, ", ^2");
		acount = 1;
		// s = ftos(self.ammo_nails);
		s = ftos(fNails);
		strAmmoMessage = strcat(strAmmoMessage, s);
		// sprint (other, s);
		strAmmoMessage = strcat(strAmmoMessage, "^7 nails");
		// sprint (other, "^7 nails");
		
		// Assign Sound
		nNumAmmoTypes = nNumAmmoTypes + 1;
		strSound = SOUND_KLESHIK_ITEMS_PICKUPNAILS;
		
		// DRESK
		// Increment Ammo Acquired
		UpdateClientStatsScore(other, CLIENTSCORE_NUMAMMOPICKEDUP, fNails);
	}
	// if (self.ammo_rockets)
	if(fRockets > 0 || bReplacementBackpack)
	{
		if (acount)
			strAmmoMessage = strcat(strAmmoMessage, ", ^2");
			// sprint(other, ", ^2");
		acount = 1;
		// s = ftos(self.ammo_rockets);
		s = ftos(fRockets);
		strAmmoMessage = strcat(strAmmoMessage, s);
		// sprint (other, s);
		strAmmoMessage = strcat(strAmmoMessage, "^7 rockets");
		// sprint (other, "^7 rockets");
		
		// Assign Sound
		nNumAmmoTypes = nNumAmmoTypes + 1;
		strSound = SOUND_KLESHIK_ITEMS_PICKUPROCKETS;
		
		// DRESK
		// Increment Ammo Acquired
		UpdateClientStatsScore(other, CLIENTSCORE_NUMAMMOPICKEDUP, fRockets);
	}
	// if (self.ammo_cells)
	if(fCells > 0 || bReplacementBackpack)
	{
		if (acount)
			strAmmoMessage = strcat(strAmmoMessage, ", ^2");
			// sprint(other, ", ^2");
		acount = 1;
		// s = ftos(self.ammo_cells);
		s = ftos(fCells);
		strAmmoMessage = strcat(strAmmoMessage, s);
		// sprint (other, s);
		strAmmoMessage = strcat(strAmmoMessage, "^7 cells");
		// sprint (other, "^7 cells");
		
		// Assign Sound
		nNumAmmoTypes = nNumAmmoTypes + 1;
		strSound = SOUND_KLESHIK_ITEMS_PICKUPCELLS;
		
		// DRESK
		// Increment Ammo Acquired
		UpdateClientStatsScore(other, CLIENTSCORE_NUMAMMOPICKEDUP, fCells);
	}
	
	strAmmoMessage = strcat(strAmmoMessage, "\n");
	// Support Disabled Item Pickup Messages
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Backpack) )
	{
		// Support Shared Cooperative Ammo
		if(g_bCoopSharedAmmo)
			bprint(strAmmoMessage);
		else
			sprint(other, strAmmoMessage);
	}
	
	// sprint (other, "\n");
	// backpack touch sound

	// DRESK
	// Support Shared Cooperative Ammo
	if(nNumAmmoTypes > 1)
		strSound = SOUND_KLESHIK_ITEMS_PICKUPBACKPACK;
	if(g_bCoopSharedAmmo)
		sound (other, CHAN_AUTO, strSound, 1, ATTN_NONE);
	else
		sound (other, CHAN_AUTO, strSound, 1, ATTN_NORM);
		
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	// remove the backpack, change self to the player
	remove(self);
	self = other;
	
	// DRESK
	// Support Shared Cooperative Ammo
	if(g_bCoopSharedAmmo)
		UpdateAllSharedAmmo(fShells, fNails, fRockets, fCells);
}

/*
===============
DropBackpack
===============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void DropBackpack()
{
	local entity	item;
	
	// DRESK
	// Support Gibbed Monster Corpse / Respawned Monster Suppression
	if( (self.flags & FL_MONSTER) && (self.bIsCorpse) )
		// Suppress
		return;
		
	// DRESK
	// Support Dropping Weapons
	if(self.flags & FL_MONSTER)
		DropWeapons();

	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
		return;	// nothing in it
		
	// DRESK
	// Support Cooperative Shared Ammo Pool
	if(self.classname == "player" && g_bCoopSharedAmmo)
		// Disable Backpack Drops
		return;

	item = spawn();
	// DRESK
	// Modified Origin
	setorigin(item, self.origin);
	// item.origin = self.origin - '0 0 24';
	// Modified Model flags
	item.modelflags = MF_GRENADE;
	
	// DRESK
	// Support Cooperative Backpack Tracking
	if(self.classname == "player")
	{ // Player Dropping Backpack
		// Assign Owner
		item.owner = self;
		if( coop && cvar(CVAR_COOP_BROADCASTPLAYERBACKPACKPICKUPS) )
		{ // Track Backpacks
			//Assign Additional Effects
			item.effects = EF_FULLBRIGHT;
			item.colormod = '0.25 0.5 1.0';
		}
	}
	
	item.nCSQCStat_Weapons = self.weapon;
	item.netname = SG_GetWeaponNameFromID(item.nCSQCStat_Weapons);

	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;

	item.velocity_z = 200 + random() * 100;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel (item, "progs/backpack.mdl");
	setsize (item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	
	// DRESK
	// Detail the Backpack Some
	item.scale = 0.8 + random() * 0.1;
	item.avelocity = randomvec() * 50;
	
	item.nextthink = time + 120;	// remove after 2 minutes
	item.think = SUB_Remove;
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
	{
		// Assign Movetype to Bounce
		item.movetype = MOVETYPE_BOUNCE;
		Gyro_ObjectMacro_Grenade(item, 800);
	}
	
	// DRESK
	// Utilize Custom Contents Transition Function
	item.contentstransition = ContentsTransition_SmallObjectInWater;
	// Assign Classname
	item.classname = "DroppedBackpack";
};