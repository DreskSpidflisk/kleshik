// DRESK - Cooperative Shared Items
// Provides definitions and default values for cooperative shared items.

#define COOPSHAREDAMMO_AMMOMAX_SHELLS										cvar(CVAR_AMMO_MAXSHELLS)
#define COOPSHAREDAMMO_AMMOMAX_NAILS										cvar(CVAR_AMMO_MAXNAILS)
#define COOPSHAREDAMMO_AMMOMAX_ROCKETS										cvar(CVAR_AMMO_MAXROCKETS)
#define COOPSHAREDAMMO_AMMOMAX_CELLS										cvar(CVAR_AMMO_MAXCELLS)

// Field / Global Definitions
float		g_nCoopSharedWeapons;
float		g_tSharedWeaponSoundTime;

float		g_nCoopSharedKeys;

float		g_bCoopSharedAmmo;
float		g_bCoopSharedAmmoSet;

float		g_fCoopSharedAmmo_Shells;
float		g_fCoopSharedAmmo_Nails;
float		g_fCoopSharedAmmo_Rockets;
float		g_fCoopSharedAmmo_Cells;

float CheckPlayerNeedsOrAddsSharedWeapon(entity enPlayer, float nWeapon)
{ // Check Player Needs or Adds Shared Weapon
	local float bReturn;
		bReturn = FALSE;
		
	if(g_nCoopSharedWeapons & nWeapon)
	{ // Weapon in Shared Pool
		if( !(enPlayer.nCSQCStat_Weapons & nWeapon) )
		{ // Weapon Addition Necessary
			enPlayer.nCSQCStat_Weapons |= nWeapon;
			bReturn = TRUE;
		}
	}
	else
	{ // Weapon NOT in Shared Pool
		if(enPlayer.nCSQCStat_Weapons & nWeapon)
		{ // Weapon Addition Necessary
			CheckCooperativeSharedWeaponAddition(enPlayer, nWeapon);
			bReturn = TRUE;
		}
	}
	
	return bReturn;
}
void UpdatePlayerSharedWeaponsPool()
{ // Updte Player Shared Weapons Pool
	// NOTE: Assumed scope is player.
	// Called when a new item is added to the pool and at player spawn.
	
	if(coop && cvar(CVAR_COOP_SHAREDWEAPONSPOOL) )
	{ // Cooperative and Shared Weapons Pool Enabled
		// Check Needs or Adds Shared Weapons
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_SUPER_SHOTGUN);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_NAILGUN);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_SUPER_NAILGUN);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_GRENADE_LAUNCHER);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_ROCKET_LAUNCHER);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_LIGHTNING);
		// HIPNOTIC SUPPORT
		if(g_bHipnoticEnabled)
		{ // Hipnotic Available
			CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_MJOLNIR);
			CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_LASER_CANNON);
			CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_PROXIMITY_GUN);
		}
		// Custom Weapons
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_LASER_GUN);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_FLECHETTE_CANNON);
		CheckPlayerNeedsOrAddsSharedWeapon(self, WEAPON_CHAIN_GUN);
	}
}

float CheckCooperativeSharedWeaponAddition(entity enPlayer, float nWeapon)
{ // Check Cooperative Shared Weapon Addition
	local float bWeaponAdded;
		bWeaponAdded = FALSE;
	// NOTE: Assumed scope is weapon when picked up by client.
	
	if(coop && cvar(CVAR_COOP_SHAREDWEAPONSPOOL) )
	{ // Cooperative and Shared Weapons Pool Enabled
		if( !(g_nCoopSharedWeapons & nWeapon) )
		{ // Shared Weapons Addition
			bWeaponAdded = TRUE;
			// Append Weapon
			g_nCoopSharedWeapons = g_nCoopSharedWeapons | nWeapon;
			
			// Broadcast Append
			// Acquire Weapon Name
			local string strWeaponName;
				strWeaponName = SG_GetWeaponNameFromID(nWeapon);
			local string strMessage;
				strMessage = strcat(enPlayer.netname, "^7 added the ^2", strWeaponName, "^7 to the ^2shared weapons pool^7!\n");
			bprint(strMessage);
			
			// Play Sound
			if(time > g_tSharedWeaponSoundTime)
			{ // Sound Allowed
				sound (world, CHAN_AUTO, SOUND_KLESHIK_ITEMS_SHAREDWEAPONADDITION, 1, ATTN_NONE);
				// Update Sound Time
				g_tSharedWeaponSoundTime = time + 0.2;
			}
			
			// Cycle through Current Players for Addition
				// Loop through Players
				local entity enFind;
				enFind = findflags(world, flags, FL_CLIENT);
				
				while(enFind != world)
				{ // Cycle Players
					// Check Add Weapon
					if(enFind != other)
						CheckPlayerNeedsOrAddsSharedWeapon(enFind, nWeapon);
					// Acquire Next Player
					enFind = findflags(enFind, flags, FL_CLIENT);
				}
		}
	}
	
	return bWeaponAdded;
}

// ******************************************************
// Cooperative Shared Ammunition Pool

// NOTE: Copied functions and ugly code is used for PERFORMANCE reasons.
void SyncSharedAmmoType_Shells()
{ // Sync Shared Ammo Type
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.ammo_shells = g_fCoopSharedAmmo_Shells;
		
		#ifdef WEAPON_UPDATECURRENTAMMO
		if(enFind.weapon == WEAPON_SHOTGUN
		|| enFind.weapon == WEAPON_SUPER_SHOTGUN)
			enFind.currentammo = enFind.ammo_shells;
		#endif
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncSharedAmmoType_Nails()
{ // Sync Shared Ammo Type
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.ammo_nails = g_fCoopSharedAmmo_Nails;
		
		#ifdef WEAPON_UPDATECURRENTAMMO
		if(enFind.weapon == WEAPON_NAILGUN
		|| enFind.weapon == WEAPON_SUPER_NAILGUN)
			enFind.currentammo = enFind.ammo_nails;
		#endif
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncSharedAmmoType_Rockets()
{ // Sync Shared Ammo Type
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.ammo_rockets = g_fCoopSharedAmmo_Rockets;
		
		#ifdef WEAPON_UPDATECURRENTAMMO
		if(enFind.weapon == WEAPON_GRENADE_LAUNCHER
		|| enFind.weapon == WEAPON_ROCKET_LAUNCHER
		|| enFind.weapon == WEAPON_PROXIMITY_GUN)
			enFind.currentammo = enFind.ammo_rockets;
		#endif
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncSharedAmmoType_Cells()
{ // Sync Shared Ammo Type
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.ammo_cells = g_fCoopSharedAmmo_Cells;
		
		#ifdef WEAPON_UPDATECURRENTAMMO
		if(enFind.weapon == WEAPON_LIGHTNING
		|| enFind.weapon == WEAPON_LASER_CANNON
		|| enFind.weapon == WEAPON_MJOLNIR)
			enFind.currentammo = enFind.ammo_cells;
		#endif
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncSharedAmmoType_All()
{ // Sync Shared Ammo Type
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		enFind.ammo_shells = g_fCoopSharedAmmo_Shells;
		enFind.ammo_nails = g_fCoopSharedAmmo_Nails;
		enFind.ammo_rockets = g_fCoopSharedAmmo_Rockets;
		enFind.ammo_cells = g_fCoopSharedAmmo_Cells;
		
		#ifdef WEAPON_UPDATECURRENTAMMO
		// Assign Current Ammunition
		if(enFind.weapon == WEAPON_SHOTGUN
		|| enFind.weapon == WEAPON_SUPER_SHOTGUN)
			enFind.currentammo = enFind.ammo_shells;
		else
		if(enFind.weapon == WEAPON_NAILGUN
		|| enFind.weapon == WEAPON_SUPER_NAILGUN)
			enFind.currentammo = enFind.ammo_nails;
		else
		if(enFind.weapon == WEAPON_GRENADE_LAUNCHER
		|| enFind.weapon == WEAPON_ROCKET_LAUNCHER
		|| enFind.weapon == WEAPON_PROXIMITY_GUN)
			enFind.currentammo = enFind.ammo_rockets;
		else
		if(enFind.weapon == WEAPON_LIGHTNING
		|| enFind.weapon == WEAPON_LASER_CANNON
		|| enFind.weapon == WEAPON_MJOLNIR)
			enFind.currentammo = enFind.ammo_cells;
		#endif
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncSharedKeys()
{ // Sync Shared Keys
	// Loop through Players
	local entity enFind;
	enFind = findflags(world, flags, FL_CLIENT);
	
	while(enFind != world)
	{ // Cycle Players
		// Add Keys to Player
		enFind.nCSQCStat_Keys = g_nCoopSharedKeys;
		
		// Support Floating Keys
		CheckFloatingKeys(enFind);
		
		// Acquire Next Player
		enFind = findflags(enFind, flags, FL_CLIENT);
	}
}
void SyncPlayerKeysToSharedKeys(entity enClient)
{ // Sync Player Keys to Shared Keys
	enClient.nCSQCStat_Keys = g_nCoopSharedKeys;
	
	// Support Floating Keys
	CheckFloatingKeys(enClient);
}
void UpdatePlayerAllSharedAmmo()
{ // Update Player All Shared Ammo
	if(g_bCoopSharedAmmo)
	{ // System Utilized; Update
		if(g_bCoopSharedAmmoSet)
		{ // Shared Ammo Set; Assign
			self.ammo_shells = g_fCoopSharedAmmo_Shells;
			self.ammo_nails = g_fCoopSharedAmmo_Nails;
			self.ammo_rockets = g_fCoopSharedAmmo_Rockets;
			self.ammo_cells = g_fCoopSharedAmmo_Cells;
		}
		else
		{ // Shared Ammo Assignment Necessary
			// NOTE: All players should share the same ammunition at spawn, so taking the first players ammunition
			// is perfectly fine.
			g_fCoopSharedAmmo_Shells = self.ammo_shells;
			g_fCoopSharedAmmo_Nails = self.ammo_nails;
			g_fCoopSharedAmmo_Rockets = self.ammo_rockets;
			g_fCoopSharedAmmo_Cells = self.ammo_cells;
			
			// Assign Shared Ammo Set
			g_bCoopSharedAmmoSet = TRUE;
		}
	}
}
void UpdateAllSharedAmmo(float fShells, float fNails, float fRockets, float fCells)
{ // Update All Shared Ammo
	// NOTE: Used for Backpacks primarily.
	
	// Update Shared Ammo
	g_fCoopSharedAmmo_Shells = g_fCoopSharedAmmo_Shells + fShells;
	if(g_fCoopSharedAmmo_Shells > COOPSHAREDAMMO_AMMOMAX_SHELLS)
		g_fCoopSharedAmmo_Shells = COOPSHAREDAMMO_AMMOMAX_SHELLS;
		
	g_fCoopSharedAmmo_Nails = g_fCoopSharedAmmo_Nails + fNails;
	if(g_fCoopSharedAmmo_Nails > COOPSHAREDAMMO_AMMOMAX_NAILS)
		g_fCoopSharedAmmo_Nails = COOPSHAREDAMMO_AMMOMAX_NAILS;
		
	g_fCoopSharedAmmo_Rockets = g_fCoopSharedAmmo_Rockets + fRockets;
	if(g_fCoopSharedAmmo_Rockets > COOPSHAREDAMMO_AMMOMAX_ROCKETS)
		g_fCoopSharedAmmo_Rockets = COOPSHAREDAMMO_AMMOMAX_ROCKETS;
		
	g_fCoopSharedAmmo_Cells = g_fCoopSharedAmmo_Cells + fCells;
	if(g_fCoopSharedAmmo_Cells > COOPSHAREDAMMO_AMMOMAX_CELLS)
		g_fCoopSharedAmmo_Cells = COOPSHAREDAMMO_AMMOMAX_CELLS;
	
	// Sync All Shared Ammo
	SyncSharedAmmoType_All();
}
float UpdateSharedAmmo(float nAmmoType, float nModify)
{ // Update Shared Ammo
	local float fAmmoReturn;
	
	if(nAmmoType == AMMOTYPE_SHELLS)
	{ // Shells
		g_fCoopSharedAmmo_Shells = g_fCoopSharedAmmo_Shells + nModify;
		if(g_fCoopSharedAmmo_Shells < 0)
			g_fCoopSharedAmmo_Shells = 0;
		else
		if(g_fCoopSharedAmmo_Shells > COOPSHAREDAMMO_AMMOMAX_SHELLS)
			g_fCoopSharedAmmo_Shells = COOPSHAREDAMMO_AMMOMAX_SHELLS;
			
		fAmmoReturn = g_fCoopSharedAmmo_Shells;
		
		SyncSharedAmmoType_Shells();
	}
	else
	if(nAmmoType == AMMOTYPE_NAILS)
	{ // Nails
		g_fCoopSharedAmmo_Nails = g_fCoopSharedAmmo_Nails + nModify;
		if(g_fCoopSharedAmmo_Nails < 0)
			g_fCoopSharedAmmo_Nails = 0;
		else
		if(g_fCoopSharedAmmo_Nails > COOPSHAREDAMMO_AMMOMAX_NAILS)
			g_fCoopSharedAmmo_Nails = COOPSHAREDAMMO_AMMOMAX_NAILS;
			
		fAmmoReturn = g_fCoopSharedAmmo_Nails;
		
		SyncSharedAmmoType_Nails();
	}
	else
	if(nAmmoType == AMMOTYPE_ROCKETS)
	{ // Rockets
		g_fCoopSharedAmmo_Rockets = g_fCoopSharedAmmo_Rockets + nModify;
		if(g_fCoopSharedAmmo_Rockets < 0)
			g_fCoopSharedAmmo_Rockets = 0;
		else
		if(g_fCoopSharedAmmo_Rockets > COOPSHAREDAMMO_AMMOMAX_ROCKETS)
			g_fCoopSharedAmmo_Rockets = COOPSHAREDAMMO_AMMOMAX_ROCKETS;
			
		fAmmoReturn = g_fCoopSharedAmmo_Rockets;
		
		SyncSharedAmmoType_Rockets();
	}
	else
	if(nAmmoType == AMMOTYPE_CELLS)
	{ // Cells
		g_fCoopSharedAmmo_Cells = g_fCoopSharedAmmo_Cells + nModify;
		if(g_fCoopSharedAmmo_Cells < 0)
			g_fCoopSharedAmmo_Cells = 0;
		else
		if(g_fCoopSharedAmmo_Cells > COOPSHAREDAMMO_AMMOMAX_CELLS)
			g_fCoopSharedAmmo_Cells = COOPSHAREDAMMO_AMMOMAX_CELLS;
			
		fAmmoReturn = g_fCoopSharedAmmo_Cells;
		
		SyncSharedAmmoType_Cells();
	}
	
	// Return Ammo Amount
	return fAmmoReturn;
}

void PrepareCooperativeSharedAmmoPool()
{ // Prepare Cooperative Shared Ammo Pool
	// NOTE: Called during Worldspawn.
	
	if(coop && cvar(CVAR_COOP_SHAREDAMMOPOOL) )
	{ // Shared Ammo Enabled
		g_bCoopSharedAmmo = TRUE;
		
		g_fCoopSharedAmmo_Shells = 25;
		g_fCoopSharedAmmo_Nails = 0;
		g_fCoopSharedAmmo_Rockets = 0;
		g_fCoopSharedAmmo_Cells = 0;
	}
	else
		g_bCoopSharedAmmo = FALSE;
}
void ResetCooperativeSharedAmmoPoolAndItems(entity enCaller)
{ // Reset Cooperative Shared Ammo Pool and Items
	// Reset Ammo
	g_fCoopSharedAmmo_Shells = g_fStartingAmmo[AMMOTYPE_SHELLS];
	g_fCoopSharedAmmo_Nails = g_fStartingAmmo[AMMOTYPE_NAILS];
	g_fCoopSharedAmmo_Rockets = g_fStartingAmmo[AMMOTYPE_ROCKETS];
	g_fCoopSharedAmmo_Cells = g_fStartingAmmo[AMMOTYPE_CELLS];
	
	// Reset Weapons
	g_nCoopSharedWeapons = 0;
	
	if(coop)
	{ // Cooperative Enabled
		if( cvar(CVAR_COOP_SHAREDAMMOPOOL) )
			// Shared Ammo Enabled; Sync Ammo
			SyncSharedAmmoType_All();
		if( cvar(CVAR_COOP_SHAREDWEAPONSPOOL) )
		{ // Shared Weapons Enabled; Sync Weapons
			// Loop through Players
			local entity enOldSelf;
			local entity enFind;
			// Backup Self
			enOldSelf = self;
			enFind = findflags(world, flags, FL_CLIENT);
			
			while(enFind != world)
			{ // Valid Player
				// Remove Weapons
				enFind.nCSQCStat_Weapons = enFind.nCSQCStat_Weapons - (enFind.nCSQCStat_Weapons & g_nAllWeapons);
				// Add Starting Weapons
				enFind.nCSQCStat_Weapons = enFind.nCSQCStat_Weapons | g_nStartingWeapons;
				// Switch to Starting Weapon
				enFind.weapon = WEAPON_SHOTGUN;
				// Invoke Update Current Ammo
				self = enFind;
				W_SetCurrentAmmo(FALSE);
				// Acquire Next Player
				enFind = findflags(enFind, flags, FL_CLIENT);
			}
			// Restore Self
			self = enOldSelf;
		}
		
		// Report
		local string strMessage;
		if(enCaller != world)
			strMessage = strcat(enCaller.netname, "^7 invoked ^2ResetCooperativeSharedAmmoPoolAndItems^7\n");
		bprint(strMessage);
		
	}
}