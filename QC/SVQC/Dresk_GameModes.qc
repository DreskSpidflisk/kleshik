// DRESK - Help
// Provides functionality for additional Game Modes.

// Fields
float		g_bGyroPhysicsEnabled;
float		g_bGyroPhysics_DetailEntities;
float		g_bHipnoticEnabled;
float		g_bHipnoticLegacyItemsEnabled;
float		g_bRogueEnabled;

float		g_nNumEntityNoSpawnFunctions;
float		g_bNoSpawnFunctionConcern;
string		g_strNoSpawnFunctionClassnames;

float		g_nNumRandomEntitiesDetectedCnt;

float		g_bKleshikMonstersEnabled;

// TRAVAIL SUPPORT
#ifdef COMPILE_MODSUPPORT_TRAVAIL
float		g_bTravailEnabled;
float		g_nTravailFeatureDetectedCnt;
float		g_bTravailConcern;
#endif

float		g_nHipnoticFeatureDetectedCnt;
float		g_bHipnoticConcern;
float		g_nRogueFeatureDetectedCnt;
float		g_bRogueConcern;
.float		bIgnoreGameModeDetected;

// Functions
void SV_OnEntityNoSpawnFunction()
{ // Called when an Entity does not have a spawn function
	// Increment Counter
	g_nNumEntityNoSpawnFunctions = g_nNumEntityNoSpawnFunctions + 1;
	g_bNoSpawnFunctionConcern = TRUE;
	
	// Update Class String
	local float nNumTokens;
	nNumTokens = tokenize(g_strNoSpawnFunctionClassnames);
	local string strClassname;
	local float bAddClassname;
		bAddClassname = TRUE;
	local float bNotDone;
		bNotDone = TRUE;
	local float nCnt;
	
	for(nCnt = 0; nCnt < nNumTokens; nCnt++)
	{
		strClassname = argv(nCnt);
		if(strClassname == self.classname)
		{ // Classname Found
			bAddClassname = FALSE;
			nCnt = nNumTokens;
		}
	}
	
	if(bAddClassname)
	{ // Add Classname to Listing
		g_strNoSpawnFunctionClassnames = strcat(g_strNoSpawnFunctionClassnames, self.classname, "\n");
		// Zone String
		g_strNoSpawnFunctionClassnames = strzone(g_strNoSpawnFunctionClassnames);
	}
}
void GameModeFeatureDetected_Hipnotic()
{ // Hipnotic Feature Detected
	if(!self.bIgnoreGameModeDetected)
	{ // Include Feature
		// Increment Feature Detected Counter
		g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
		
		if(!g_bHipnoticEnabled)
			g_bHipnoticConcern = TRUE;
	}
}

void GameModeFeatureDetected_Rogue()
{ // Rogue Feature Detected
	if(!self.bIgnoreGameModeDetected)
	{ // Include Feature
		// Increment Feature Detected Counter
		g_nRogueFeatureDetectedCnt = g_nRogueFeatureDetectedCnt + 1;
		
		if(!g_bRogueEnabled)
			g_bRogueConcern = TRUE;
	}
}
#ifdef COMPILE_MODSUPPORT_TRAVAIL
void GameModeFeatureDetected_Travail()
{ // Travail Feature Detected
	if(!self.bIgnoreGameModeDetected)
	{ // Include Feature
		// Increment Feature Detected Counter
		g_nTravailFeatureDetectedCnt = g_nTravailFeatureDetectedCnt + 1;
		
		if(!g_bTravailEnabled)
			g_bTravailConcern = TRUE;
	}
}
#endif

void DisplayGameModeConcerns(entity enClient)
{ // Display Game Mode Concerns
	local string strMessage;
		strMessage = "";
	local float bNeedsComma;
		bNeedsComma = FALSE;
		
	if( SG_MathModulus( GetClientStatsScore(enClient, CLIENTSCORE_NUMDEATHS), 10) == 0)
	{ // Display Concern
		// Check for Bad Spawn Function Entities
		if(g_bNoSpawnFunctionConcern)
		{
			// Generate Message
			strMessage = strcat(strMessage, "^1WARNING^7\n\nKLESHIK DETECTED ^2", ftos(g_nNumEntityNoSpawnFunctions), "^7 ENTITIES ON THIS MAP THAT HAVE NO SPAWN FUNCTIONS\n^2");
			strMessage = strcat(strMessage, "^7", g_strNoSpawnFunctionClassnames);
			strMessage = strcat(strMessage, "\n\n");
		}
		
		#ifdef COMPILE_MODSUPPORT_TRAVAIL
		if(g_bHipnoticConcern || g_bRogueConcern || g_bTravailConcern)
		#else
		if(g_bHipnoticConcern || g_bRogueConcern)
		#endif
		{
			// Generate Message
			strMessage = strcat(strMessage, "^1WARNING^7\n\nKLESHIK DETECTED THIS MAP USES FEATURES\nFROM THE FOLLOWING GAME(S)\n\n^2");
			
			// Apply Game Modes
			if(g_bHipnoticConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, "HIPNOTIC");
				bNeedsComma = TRUE;
			}
			if(g_bRogueConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, "ROGUE");
				bNeedsComma = TRUE;
			}
			#ifdef COMPILE_MODSUPPORT_TRAVAIL
			if(g_bTravailConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, "TRAVAIL");
				bNeedsComma = TRUE;
			}
			#endif
				
			// Apply Console Variables
			bNeedsComma = FALSE;
			strMessage = strcat(strMessage, "^7\n\n\bPLEASE ENABLE THE FOLLOWING CVARS\b\n\n^2");
			if(g_bHipnoticConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, CVAR_GAMEMODE_HIPNOTIC_ENABLED);
				bNeedsComma = TRUE;
			}
			if(g_bRogueConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, CVAR_GAMEMODE_ROGUE_ENABLED);
				bNeedsComma = TRUE;
			}
			#ifdef COMPILE_MODSUPPORT_TRAVAIL
			if(g_bTravailConcern)
			{
				if(bNeedsComma)
					strMessage = strcat(strMessage, "^7, ^2");
					
				strMessage = strcat(strMessage, CVAR_GAMEMODE_TRAVAIL_ENABLED);
				bNeedsComma = TRUE;
			}
			#endif
		}
		
		// Display Message
		if(strMessage != "")
			centerprint(enClient, strMessage);
	}
}
void PrepareGameModeCVars()
{ // Prepare Game Mode CVars
	// Enable Coop if Deathmatch Not Enabled
	if(!deathmatch && !coop)
		cvar_set("coop", "1");
	// Prepare Hipnotic Enabled
	g_bHipnoticEnabled = cvar(CVAR_GAMEMODE_HIPNOTIC_ENABLED);
	
	if(g_bHipnoticEnabled)
	{ // Check for Extended Hipnotic Functionality
		g_bHipnoticLegacyItemsEnabled = cvar(CVAR_GAMEMODE_HIPNOTIC_LEGACYITEMS);
	}
	
	// Prepare Rogue Enabled
	g_bRogueEnabled = cvar(CVAR_GAMEMODE_ROGUE_ENABLED);
	
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	// Prepare Travail Enabled
	g_bTravailEnabled = cvar(CVAR_GAMEMODE_TRAVAIL_ENABLED);
	#endif
	
	// Prepare Gyro Physics Enabled
	g_bGyroPhysicsEnabled = cvar(CVAR_GAMEMODE_GYROPHYSICS_ENABLED);
		// Assign Detail Entities
		g_bGyroPhysics_DetailEntities = cvar(CVAR_GAMEMODE_GYROPHYSICS_DETAILENTITIES);
		
	// Prepare Kleshik Weapons Enabled
	g_bKleshikWeaponsEnabled = cvar(CVAR_GAMEMODE_KLESHIKWEAPONS_ENABLED);
	
	// Prepare Kleshik Monsters Enabled
	g_bKleshikMonstersEnabled = cvar(CVAR_GAMEMODE_KLESHIKMONSTERS_ENABLED);
}
void CheckLegacyItemSpawn()
{ // Check Legacy Item Spawn
	if(self.bIsCloneItem)
		// Remove Solidity of Clone Items
		self.solid = SOLID_NOT;
		
	if(g_bHipnoticLegacyItemsEnabled)
	{ // Hipnotic Legacy Items Enabled
		// NOTE: Assumed scope is host item to spawn entity.
		if(self.classname == "weapon_grenadelauncher")
		{ // Provide Proximity Gun
			SpawnCloneItem(self, "weapon_proximity_gun", weapon_proximity_gun);
		}
		else
		if(self.classname == "weapon_rocketlauncher")
		{ // Provide Mjolnir
			SpawnCloneItem(self, "weapon_mjolnir", weapon_mjolnir);
		}
		else
		if(self.classname == "weapon_lightning")
		{ // Provide Laser Gun
			SpawnCloneItem(self, "weapon_laser_gun", weapon_laser_gun);
		}
	}
	if(self.classname == "weapon_supershotgun")
	{ // Provide Laser Gun - Kleshik
		SpawnCloneItem(self, "weapon_laser_gun_kleshik", weapon_laser_gun_kleshik);
	}
	else
	if(self.classname == "weapon_nailgun")
	{ // Provide Flechette Cannon
		SpawnCloneItem(self, "weapon_flechette_cannon", weapon_flechette_cannon);
	}
	else
	if(self.classname == "weapon_supernailgun")
	{ // Provide Chain Gun
		SpawnCloneItem(self, "weapon_chain_gun", weapon_chain_gun);
	}
}

