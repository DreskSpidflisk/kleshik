// DRESK
// Item Functions

// Definitions

// Prototypes

// Fields
.float	bIsDroppedItem;

.entity	enCloneItem;
.float	bIsCloneItem;

float	g_fStartingAmmo[9];
float	g_nStartingWeapons;
float	g_nAllWeapons;

// Functions
float GetWeaponIsAvailable(float nWeapon)
{ // Return if Weapon is Available
	if(g_nAllWeapons & nWeapon)
		return TRUE;
	else
		return FALSE;
}
void PrepareStartingItems()
{ // Prepare Starting Items
	g_fStartingAmmo[AMMOTYPE_SHELLS] = 25;
	g_fStartingAmmo[AMMOTYPE_NAILS] = 0;
	g_fStartingAmmo[AMMOTYPE_ROCKETS] = 0;
	g_fStartingAmmo[AMMOTYPE_CELLS] = 0;
	
	g_nStartingWeapons = WEAPON_AXE | WEAPON_SHOTGUN;
	g_nAllWeapons = g_nStartingWeapons | WEAPON_SUPER_SHOTGUN | WEAPON_NAILGUN | WEAPON_SUPER_NAILGUN | WEAPON_GRENADE_LAUNCHER | WEAPON_ROCKET_LAUNCHER | WEAPON_LIGHTNING;
	if(g_bHipnoticEnabled)
		g_nAllWeapons = g_nAllWeapons | WEAPON_LASER_CANNON | WEAPON_MJOLNIR | WEAPON_PROXIMITY_GUN;
	// Custom Weapons
	g_nAllWeapons = g_nAllWeapons | WEAPON_LASER_GUN | WEAPON_FLECHETTE_CANNON | WEAPON_CHAIN_GUN;
}
float CheckFadedItem()
{ // Check Faded Item
	local float fReturn;
	if( cvar(CVAR_ITEM_FADEUNAVAILABLEITEMS) )
	{ // Faded Items Enabled
		self.colormod = '0.3 1.0 0.3';
		self.effects = (self.effects | EF_ADDITIVE);
		self.alpha = 0.3;
		fReturn = TRUE;
	}
	else
		fReturn = FALSE;
		
	return fReturn;
}
void CheckRespawnFadedItem()
{ // Check Respawn Faded Item
	if(self.alpha != 1.0)
	{ // Faded Item; Restore
		self.alpha = 1.0;
		self.colormod = '1.0 1.0 1.0';
		self.effects = self.effects - (self.effects & EF_ADDITIVE);
	}
}
// DRESK
// Support Generic Toss Item
void TossItem(entity enOwner, entity enItem)
{ // Toss Item
	// NOTE: Primarily follows logic of DropBackpack.
	
	// Assign Origin
	setorigin(enItem, enOwner.origin);
	// Assign Velocities
	enItem.velocity_z = 300;
	enItem.velocity_x = -100 + (random() * 200);
	enItem.velocity_y = -100 + (random() * 200);
	// Assign Flags
	enItem.movetype = MOVETYPE_TOSS;
	enItem.flags = FL_ITEM;
	enItem.solid = SOLID_TRIGGER;
	// Assign Removal Time
	enItem.nextthink = time + 120;
	enItem.think = SUB_Remove;
	// Assign Silent Contents Transition
	enItem.contentstransition = SilentContentsTransition;
	// Assign Model Flags
	enItem.modelflags = enItem.modelflags | MF_GRENADE;
}
// Support Drop Armor
void DropNewArmor(float nArmorType)
{ // Drop New Armor
	// NOTE: Assumed scope is entity to drop armor.
	local entity enDropper;
	local entity enArmor;
	
	// Backup Entity
	enDropper = self;
	self = enArmor;
	
	// Spawn Armor
	self = spawn();
	// Assign Dropped Item
	self.bIsDroppedItem = TRUE;
	
	// Invoke Spawn Class
	if(nArmorType == ARMORTYPE_GREEN)
	{ // Green Armor
		item_armor1();
		self.classname = "item_armor1";
	}
	else
	if(nArmorType == ARMORTYPE_YELLOW)
	{ // Yellow Armor
		item_armor2();
		self.classname = "item_armor2";
	}
	else
	if(nArmorType == ARMORTYPE_RED)
	{ // Red Armor
		item_armorInv();
		self.classname = "item_armorInv";
	}
	
	// Toss Item
	TossItem(enDropper, self);
	
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
	{
		// Assign Movetype to Bounce
		self.movetype = MOVETYPE_BOUNCE;
		Gyro_ObjectMacro_Grenade(self, 800);
	}
	
	// Restore Entity
	self = enDropper;
}
entity SpawnCloneItem(entity enHostItem, string strClassname, void() fpItemFunc)
{ // Spawn Clone Item	
	local entity enClone;
	// Backup Entity
	local entity enOldSelf;
		enOldSelf = self;
		
	// Spawn New Item
	self = spawn();
	// Assign is Clone Item
	self.bIsCloneItem = TRUE;
	// Assign Ignore GameMode Feature
	self.bIgnoreGameModeDetected = TRUE;
	// Assign origin
	self.origin = enHostItem.origin;
	// Assign Owner
	self.owner = enHostItem;
	// Assign Solidity
	self.solid = SOLID_NOT;
	// Suppress Exploding Item Box
	self.bSuppressExplodingItemBox = TRUE;
	// Assign No Draw
	self.effects = EF_NODRAW;
	
	// Assign Classname
	self.classname = strClassname;
	// Invoke Item Function
	fpItemFunc();
	
	// Assign Clone Item to Host
	enHostItem.enCloneItem = self;
	
	// Assign Clone Entity
	enClone = self;
	
	// Restore Entity
	self = enOldSelf;
	
	// Return Clone Item
	return enClone;
}
void DecodeArmorTypeFromItems(entity enClient)
{ // Decode Armor Type from Items
	local float fArmorType;
	if(enClient.items & ITEM_ARMOR3)
		fArmorType = 0.8;
	else
	if(enClient.items & ITEM_ARMOR2)
		fArmorType = 0.6;
	else
	if(enClient.items & ITEM_ARMOR1)
		fArmorType = 0.3;
		
	// Assign Armor Type
	/*
	if(enClient.armortype)
	{ // Display Warning
		bprint("^1WARNING^7 : Player '", enClient.netname, "^7' Tried to Overwrite Armor Type from Decode!\n");
	}
	else
	*/
	{ // Assign Armor Type
		enClient.armortype = fArmorType;
	}
}