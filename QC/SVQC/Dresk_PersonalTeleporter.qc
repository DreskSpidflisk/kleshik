// DRESK - Personal Teleporter System
// Provides functions, definitions and more to support the personal teleporter system.

// #define PERSONALTELEPORTER_DEBUG_ALLOWSELFTELEPORT
#define PERSONALTELEPORTER_MENU_MAIN							0
#define PERSONALTELEPORTER_MENU_DOORSANDKEYS					1

// Field / Global Definitions
.float		nPersonalTeleporter_NumTeleportTargets;
.float		nPersonalTeleporter_TeleportMenu;
.float		tPersonalTeleporter_TeleportReuseTime;
float		g_nPersonalTeleporter_NumFramesForcePrint;

.float		nPersonalTeleporter_TargetNum_CoopSpawn;
.float		nPersonalTeleporter_TargetNum_SilverKey;
.float		nPersonalTeleporter_TargetNum_GoldKey;
.float		nPersonalTeleporter_TargetNum_SilverDoor;
.float		nPersonalTeleporter_TargetNum_GoldDoor;

.float		tPersonalTeleporter_TeleportPrintTime;
entity		g_enPersonalTeleporter_Target_GoldKey;
entity		g_enPersonalTeleporter_Target_SilverKey;
entity		g_enPersonalTeleporter_Target_GoldDoor;
entity		g_enPersonalTeleporter_Target_SilverDoor;

void PersonalTeleporter_TeleportPlayer(vector vOrigin, string strTargetName)
{ // Personal Teleporter - Teleport Player
	// Display Message
	local string strMessage;
	strMessage = strcat("Personal Teleporter - ^1Teleporting^7 to ", strTargetName, "\n");

	sprint(self, strMessage);
	
	// Immediately Purge Menu
	centerprint(self, "");
	
	// Spawn Teleport Fog at Current Location
	spawn_tfog(self.origin, self);
	
	if( cvar(CVAR_WORLD_SPAWNFADINGCOPYATTELEPORT) )
		// Spawn Teleporter Fading Entity Copy
		SpawnTeleporterFadingEntityCopy(self);
	
	// Teleport Player
	setorigin(self, vOrigin);
	
	// Spawn Teleport Fog at New Location
	spawn_tfog(self.origin, self);
	
	// Update Teleport Reuse Delay Time
	self.tPersonalTeleporter_TeleportReuseTime = time + cvar(CVAR_PERSONALTELEPORTER_REUSEDELAYTIME);
}
float PersonalTeleport_ParseTeleportImpulse()
{ // Parse Teleport Impulse
	// NOTE: Returns if Impulse was Parsed
	// Allows commands such as switch weapon to function whilst displaying the menu
	local float fReturn;
		fReturn = TRUE;
	local string strMessage;
	local float bInvalidTarget;
		bInvalidTarget = FALSE;
	local float bResetTeleportMenu;
		bResetTeleportMenu = TRUE;
		
	if(self.impulse >= 1 && self.impulse <= (self.nPersonalTeleporter_NumTeleportTargets) )
	{ // Parse Teleport Target
		if( (self.tPersonalTeleporter_TeleportReuseTime > time)
		&& (self.impulse < (self.nPersonalTeleporter_NumTeleportTargets - 1) )
		)
		{ // Teleport Reuse Time Not Met
			// Calculate Time Remaining
			local float nTimeRemaining;
				nTimeRemaining = self.tPersonalTeleporter_TeleportReuseTime - time;
				nTimeRemaining = rint(nTimeRemaining);
				if(nTimeRemaining < 1)
					nTimeRemaining = 1;
				
			strMessage = strcat("Personal Teleporter - You must wait ^2", ftos(nTimeRemaining), "^7 more seconds to use the Teleport\n");
			sprint(self, strMessage);
			// Immediately Purge Menu
			centerprint(self, "");
		}
		else
		if(self.impulse == self.nPersonalTeleporter_NumTeleportTargets)
		{ // Cancel
			strMessage = "Personal Teleporter - ^1Cancelling Request\n";
			sprint(self, strMessage);
			// Immediately Purge Menu
			centerprint(self, "");
		}
		else
		if(self.nPersonalTeleporter_TeleportMenu == PERSONALTELEPORTER_MENU_MAIN)
		{ // Parse Main Menu
			if(self.impulse == self.nPersonalTeleporter_TargetNum_CoopSpawn)
			{ // Cooperative Spawn
				local entity enSpot;
					enSpot = SelectSpawnPoint();
					
				// Reset Gravity
				self.gravity = 0;
				PersonalTeleporter_TeleportPlayer(enSpot.origin, "Cooperative Spawn");
			}
			else
			if(self.impulse == (self.nPersonalTeleporter_TargetNum_CoopSpawn + 1) )
			{ // Doors and Keys
				// Modify Current Teleport Menu
				self.nPersonalTeleporter_TeleportMenu = PERSONALTELEPORTER_MENU_DOORSANDKEYS;
				// Force Redraw
				self.tPersonalTeleporter_TeleportPrintTime = time;
				// Disable Teleport Reset
				bResetTeleportMenu = FALSE;
			}
			else
			{ // Player
				local float fCurrentTarget;
				local entity enFind;
				
				enFind = find(world, classname, "player");
				while(fCurrentTarget != self.impulse && enFind != world)
				{ // Cycle Players
					#ifndef TELEPORT_DEBUG_ALLOWSELFTELEPORT
					if(enFind != self)
					#endif
					{
						// Increment Target
						fCurrentTarget++;
					}
					// Acquire Next Player
					if(fCurrentTarget != self.impulse)
						enFind = find(enFind, classname, "player");
				}
				
				if(enFind != world)
				{ // Valid Player Found
					if(enFind.deadflag == DEAD_NO)
					{ // Player is Alive; Teleport
						// Generate Nearby Origin for Teleport
						makevectors(enFind.v_angle);
						local vector vDirection;
							vDirection = v_forward;
							vDirection_z = 0;
							vDirection = normalize(vDirection);
							vDirection = vDirection * -35;
						// Utilize Tracebox to fit Players
						tracebox(enFind.origin, VEC_HULL_MIN, VEC_HULL_MAX, enFind.origin + vDirection, FALSE, enFind);
						// traceline(enFind.origin, enFind.origin + vDirection, FALSE, enFind);
						
						// Assign Gravity of Target Player
						self.gravity = enFind.gravity;
						PersonalTeleporter_TeleportPlayer(trace_endpos + '0 0 3', enFind.netname);
					}
					else
					{ // Player Not Alive
						strMessage = "Personal Teleporter - ^1PLAYER IS DEAD^7; ^1Cancelling Request\n";
						sprint(self, strMessage);
						// Immediately Purge Menu
						centerprint(self, "");
					}
				}
				else
				{ // Invalid Target
					strMessage = "Personal Teleporter - ^1INVALID TARGET^7; ^1Cancelling Request\n";
					sprint(self, strMessage);
					// Immediately Purge Menu
					centerprint(self, "");
				}
			}
		}
		else
		if(self.nPersonalTeleporter_TeleportMenu == PERSONALTELEPORTER_MENU_DOORSANDKEYS)
		{ // Doors and Keys Menu
			if(self.impulse == self.nPersonalTeleporter_TargetNum_SilverKey)
			{ // Silver Key
				if(g_enPersonalTeleporter_Target_SilverKey)
					// Valid Key
					PersonalTeleporter_TeleportPlayer(g_enPersonalTeleporter_Target_SilverKey.origin, "Silver Key");
				else
				{ // Invalid Key
					strMessage = "Personal Teleporter - ^1KEY NOT FOUND YET^7; ^1Cancelling Request\n";
					sprint(self, strMessage);
					// Immediately Purge Menu
					centerprint(self, "");
				}
			}
			else
			if(self.impulse == self.nPersonalTeleporter_TargetNum_GoldKey)
			{ // Gold Key
				if(g_enPersonalTeleporter_Target_GoldKey)
					// Valid Key
					PersonalTeleporter_TeleportPlayer(g_enPersonalTeleporter_Target_GoldKey.origin, "Gold Key");
				else
				{ // Invalid Key
					strMessage = "Personal Teleporter - ^1KEY NOT FOUND YET^7; ^1Cancelling Request\n";
					sprint(self, strMessage);
					// Immediately Purge Menu
					centerprint(self, "");
				}
			}
			else
			if(self.impulse == self.nPersonalTeleporter_TargetNum_SilverDoor)
			{ // Silver Door
				if(g_enPersonalTeleporter_Target_SilverDoor)
					// Valid Door
					PersonalTeleporter_TeleportPlayer(g_enPersonalTeleporter_Target_SilverDoor.origin, "Silver Door");
				else
				{ // Invalid Door
					strMessage = "Personal Teleporter - ^1DOOR NOT FOUND YET^7; ^1Cancelling Request\n";
					sprint(self, strMessage);
					// Immediately Purge Menu
					centerprint(self, "");
				}
			}
			else
			if(self.impulse == self.nPersonalTeleporter_TargetNum_GoldDoor)
			{ // Gold Door
				if(g_enPersonalTeleporter_Target_GoldDoor)
					// Valid Door
					PersonalTeleporter_TeleportPlayer(g_enPersonalTeleporter_Target_GoldDoor.origin, "Gold Door");
				else
				{ // Invalid Door
					strMessage = "Personal Teleporter - ^1DOOR NOT FOUND YET^7; ^1Cancelling Request\n";
					sprint(self, strMessage);
					// Immediately Purge Menu
					centerprint(self, "");
				}
			}
		}
		
		// ALWAYS Disable System if Impulse is in range
		if(bResetTeleportMenu)
		{ // Reset Teleport Menu
			self.nPersonalTeleporter_NumTeleportTargets = 0;
			self.tPersonalTeleporter_TeleportPrintTime = 0;
			self.nPersonalTeleporter_TeleportMenu = PERSONALTELEPORTER_MENU_MAIN;
		}
	}
	else
		// Out of Range Impulse
		fReturn = FALSE;
		
	if(fReturn)
		// Play Sound
		sound(self, CHAN_AUTO, SOUND_KLESHIK_PERSONALTELEPORTER_SELECT, 1, ATTN_NORM);
	
	return fReturn;
}

string PersonalTeleporter_AppendPrintTeleportTarget(string strMessage, float nNumber, string strTarget, float bValidTarget)
{ // Append Print Teleport Target
	local float nSpacingNeeded;
	local float nSpacingCnt;
	
	// Append Target Name to Message
	if(bValidTarget)
		strMessage = strcat(strMessage, "\n^7[^2", ftos(nNumber), "^7] ", strTarget);
	else
		strMessage = strcat(strMessage, "\n^7[^8", ftos(nNumber), "^7] ^8", strTarget);
	
	// Apply Additional Whitespaces for Centering
		nSpacingCnt = 0;
		// Acqurie Spacing Needed
		nSpacingNeeded = strlennocol(strTarget);
		nSpacingNeeded = 20 - nSpacingNeeded;
		while(nSpacingCnt < nSpacingNeeded)
		{
			strMessage = strcat(strMessage, " ");
			nSpacingCnt++;
		}
		
	return strMessage;
}
float PersonalTeleporter_PrintTeleportTargets()
{ // Print Teleport Targets
	// NOTE: Returns number of targets printed
	
	// Loop through Players
	local string strMessage;
	local float nCnt;
	local entity enFind;
	local float bActiveTarget;
	
	nCnt = 0;
	enFind = find(world, classname, "player");
	
	// Prepare Message
	strMessage = "\bPersonal Teleporter Targets\b\n\n";
	
	if(self.nPersonalTeleporter_TeleportMenu == PERSONALTELEPORTER_MENU_MAIN)
	{ // Main Menu
		while(enFind != world)
		{ // Cycle Players
			#ifndef PERSONALTELEPORTER_DEBUG_ALLOWSELFTELEPORT
			if(enFind != self)
			#endif
			{ // Valid Different Player
				// Increment Player Counter
				nCnt++;
				// Append Player to Message
				if(enFind.deadflag == DEAD_NO)
					// Player Alive; Standard Print
					strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, enFind.netname, TRUE);
				else
				{ // Player Dead
					// Generate Player Name Message
					local string strPlayerName;
						strPlayerName = strcat(enFind.netname, " (DEAD)");
					strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, strPlayerName, FALSE);
				}
			}
					
			// Acquire Next Player
			enFind = find(enFind, classname, "player");
		}
		
		// Append Cooperative Respawn Point
		if(nCnt > 0)
			strMessage = strcat(strMessage, "\n");
			
		nCnt++;
		strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Cooperative Spawn", TRUE);
		self.nPersonalTeleporter_TargetNum_CoopSpawn = nCnt;
		
		// Append Doors and Keys Submenu
		strMessage = strcat(strMessage, "\n");
		nCnt++;
		strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Doors and Keys", TRUE);
	}
	else
	if(self.nPersonalTeleporter_TeleportMenu == PERSONALTELEPORTER_MENU_DOORSANDKEYS)
	{ // Doors and Key
		// Append Key Teleports
		// NOTE: Deferring Check for Key Entities
		// This allows the keys to always show in the list, just as disabled
		local float bAllowKeyTeleports;
			bAllowKeyTeleports = cvar(CVAR_PERSONALTELEPORTER_ALLOWKEYTELEPORTS);
		if(bAllowKeyTeleports)
		{ // Key Teleports Allowed
			// Append Silver Key
			nCnt++;
			if(g_enPersonalTeleporter_Target_SilverKey)
				bActiveTarget = TRUE;
			else
				bActiveTarget = FALSE;
				
			strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Silver Key", bActiveTarget);
			
			self.nPersonalTeleporter_TargetNum_SilverKey = nCnt;
			
			// Append Gold Key
			nCnt++;
			if(g_enPersonalTeleporter_Target_GoldKey)
				bActiveTarget = TRUE;
			else
				bActiveTarget = FALSE;
				
			strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Gold Key", bActiveTarget);
			
			self.nPersonalTeleporter_TargetNum_GoldKey = nCnt;
		}
		else
		{ // Teleports Disabled
			self.nPersonalTeleporter_TargetNum_SilverKey = 0;
			self.nPersonalTeleporter_TargetNum_GoldKey = 0;
		}
			
		// Append Door Key Teleports
		// NOTE: Deferring Check for Key Entities
		// This allows the doorkeys to always show in the list, just as disabled
		local float bAllowDoorKeyTeleports;
			bAllowDoorKeyTeleports = cvar(CVAR_PERSONALTELEPORTER_ALLOWDOORKEYTELEPORTS);
			
		if(bAllowDoorKeyTeleports)
		{ // Door Key Teleports Allowed
			// Append Silver Door
			nCnt++;
			if(g_enPersonalTeleporter_Target_SilverDoor)
				bActiveTarget = TRUE;
			else
				bActiveTarget = FALSE;
				
			strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Silver Door", bActiveTarget);
			
			self.nPersonalTeleporter_TargetNum_SilverDoor = nCnt;
			
			// Append Gold Door
			nCnt++;
			if(g_enPersonalTeleporter_Target_GoldDoor)
				bActiveTarget = TRUE;
			else
				bActiveTarget = FALSE;
				
			strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Gold Door", bActiveTarget);
			
			self.nPersonalTeleporter_TargetNum_GoldDoor = nCnt;
		}
	}
	
	// Append Cancel
	strMessage = strcat(strMessage, "\n");
	nCnt++;
	strMessage = PersonalTeleporter_AppendPrintTeleportTarget(strMessage, nCnt, "Cancel", TRUE);

	// Display Message
	centerprint(self, strMessage);
	
	// Apply New Print Time
	self.tPersonalTeleporter_TeleportPrintTime = time + 1.5;
	
	// Return Number of Targets
	return nCnt;
}

void PreparePersonalTeleporter()
{ // Prepare Personal Teleporter
	// NOTE: Assumed scope is Player
	// Main Teleport Function
	
	// Play Sound
	sound(self, CHAN_AUTO, SOUND_KLESHIK_PERSONALTELEPORTER_INITIALIZE, 1, ATTN_NORM);
	
	// Assign Teleport Print Time
	self.tPersonalTeleporter_TeleportPrintTime = time;
}
float PersonalTeleporter_CheckTeleportKeysUpdate(entity enKey)
{ // Check Teleport Keys Update
	local float bReturn;
		bReturn = TRUE;
	if(enKey.nCSQCStat_Keys & KEY_SILVER && !g_enPersonalTeleporter_Target_SilverKey)
	{
		g_enPersonalTeleporter_Target_SilverKey = enKey;
	}
	else
	if(enKey.nCSQCStat_Keys & KEY_GOLD && !g_enPersonalTeleporter_Target_GoldKey)
	{
		g_enPersonalTeleporter_Target_GoldKey = enKey;
	}
	else
		bReturn = FALSE;
		
	if(bReturn)
	{ // Found New Key
		// Force Teleport Print Update
		g_nPersonalTeleporter_NumFramesForcePrint = 2;
		
		if( random() < 0.5)
			sound(world, CHAN_AUTO, SOUND_KLESHIK_AMBIENCE_EVENTS_ACQUIRENEWKEY1, 1.0, ATTN_NONE);
		else
			sound(world, CHAN_AUTO, SOUND_KLESHIK_AMBIENCE_EVENTS_ACQUIRENEWKEY2, 1.0, ATTN_NONE);
	}
	
	return bReturn;
}
float PersonalTeleporter_CheckTeleportDoorsUpdate(entity enDoor, entity enToucher)
{ // Check Teleport Doors Update
	local string strDoor;
	local float bReturn;
		bReturn = TRUE;
	if(enDoor.nCSQCStat_Keys & KEY_SILVER && !g_enPersonalTeleporter_Target_SilverDoor)
	{ // Silver Door
		g_enPersonalTeleporter_Target_SilverDoor = spawn();
		g_enPersonalTeleporter_Target_SilverDoor.effects = EF_NODRAW;
		setorigin(g_enPersonalTeleporter_Target_SilverDoor, enToucher.origin);
		
		// Assign Door String
		strDoor = "Silver";
	}
	else
	if(enDoor.nCSQCStat_Keys & KEY_GOLD && !g_enPersonalTeleporter_Target_GoldDoor)
	{ // Gold Door
		g_enPersonalTeleporter_Target_GoldDoor = spawn();
		g_enPersonalTeleporter_Target_GoldDoor.effects = EF_NODRAW;
		setorigin(g_enPersonalTeleporter_Target_GoldDoor, enToucher.origin);
		
		// Assign Door String
		strDoor = "Gold";
	}
	else
		bReturn = FALSE;
		
	if(bReturn)
	{ // Found New Door
		// Force Teleport Print Update
		g_nPersonalTeleporter_NumFramesForcePrint = 2;
		
		if(coop)
		{ // Cooperative; Broadcast
			// Generate Message
			local string strMessage;
				strMessage = strcat(enToucher.netname, "^7 found the ^2", strDoor, " Door^7!\n");
				bprint(strMessage);
				
			// Play Sound
			if( random() < 0.5)
				sound(world, CHAN_AUTO, SOUND_KLESHIK_AMBIENCE_EVENTS_ACQUIRENEWKEY1, 1.0, ATTN_NONE);
			else
				sound(world, CHAN_AUTO, SOUND_KLESHIK_AMBIENCE_EVENTS_ACQUIRENEWKEY2, 1.0, ATTN_NONE);
		}
	}
	
	return bReturn;
}