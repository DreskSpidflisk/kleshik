// DRESK - Cooperative Main
// Provides definitions and default values for Cooperative features.

// Definitions

// Fields

// Functions

float CheckCooperativeItemRespawn(float nRespawnTime)
{ // Check Cooperative Item Respawn
	local float fReturn;
	
	if(nRespawnTime <= 0)
		fReturn = 0;
	else
	if( coop && SG_AUTOCVAR2(CVAR_ITEM_COOPITEMSRESPAWN) )
		fReturn = 1;
	else
		fReturn = 0;
		
	return fReturn;
}

void PrintCooperativeRespawnReminder(entity enPlayer)
{ // Print Cooperative Respawn Reminder
	if( coop && cvar(CVAR_COOP_RESPAWNATDEATHLOCATION_ALLOW) )
	{ // Valid Respawn Reminders
		local string strMessage;
		if(enPlayer.fRespawnAtDeathLocationReuseTime > time)
			strMessage = strcat("YOU CANNOT RESPAWN AT DEATH LOCATION FOR ^1", ftos( rint(self.fRespawnAtDeathLocationReuseTime - time) ), "^7 SECONDS\n\n");
		else
			strMessage = "PRESS ^1ATTACK^7 TO RESPAWN AT DEATH LOCATION\n\n";
		// Finish Message
		strMessage = strcat(strMessage, "PRESS ^1JUMP^7 TO RESPAWN AT COOP LOCATION");
		// Display Message
		centerprint(enPlayer, strMessage);
	}
}

float CheckCooperativeAllowRespawnAtDeathLocation()
{ // Check Cooperative Allow Respawn at Death Location
	// NOTE : Returns if respawn should continue or not.
	local float fReturn;
		fReturn = TRUE;
	// Assign Initial Default
	self.fRespawnType = 0;
	
	if(coop && cvar(CVAR_COOP_RESPAWNATDEATHLOCATION_ALLOW) )
	{ // Coop Respawn Supported
		if(self.button0)
		{ // Attack Utilized; Spawn at Death Location
			// Check Reuse Time
			if(time >= self.fRespawnAtDeathLocationReuseTime)
				// Respawn Allowed
				self.fRespawnType = 1;
			else
			{ // Respawn Not Allowed
				// Display Message
				PrintCooperativeRespawnReminder(self);
				// Suppress Respawn
				fReturn = FALSE;
			}
		}
	}
	
	return fReturn;
}

float CheckCoopCenterprintBroadcast(entity enPlayer, string strCenterMessage, string strSound)
{ // Check Coop Centerprint Broadcast
	// NOTE: Returns if broadcasted or Not
	local float fReturn;
		fReturn = FALSE;
	if( coop && cvar(CVAR_COOP_BROADCASTCENTERPRINTS) )
	{ // Broadcast Centerprints Valid
		fReturn = TRUE;
		// Broadcast Sound
		if(strSound != "")
			sound (world, CHAN_AUTO, strSound, 1, ATTN_NONE);
			
		// Generate Message
		local string strMessage;
			strMessage = strcat(enPlayer.netname, "^7 received the message :\n\n", strCenterMessage);
			
		// Loop through Players
		local entity enFind;
		enFind = find(world, classname, "player");
		
		while(enFind != world)
		{ // Cycle Players
			// Centerprint to Client
			centerprint(enFind, strMessage);
			// Acquire Next Player
			enFind = find(enFind, classname, "player");
		}
	}
	
	return fReturn;
}