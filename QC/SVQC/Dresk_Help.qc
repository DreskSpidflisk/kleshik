// DRESK - Help
// Provides functionality for modification help.

#define HELP_REMINDER_DEATHCOUNT											10

#define HELP_QUICKHELP_NAME_LENGTH											35
#define HELP_QUICKHELP_VALUE_LENGTH											35

#define HELP_CHEAT_ALLAMMOWEAPONSKEYS										1
#define HELP_CHEAT_ALLAMMOWEAPONSKEYSSHARED									2
#define HELP_CHEAT_QUADDAMAGE												3
#define HELP_CHEAT_GODMODE													4
#define HELP_CHEAT_NOCLIP													5
#define HELP_CHEAT_NOTARGET													6
#define HELP_CHEAT_GIVE														7
#define HELP_CHEAT_GIVEALLPOWERUPS											8

// Impulse Aliases
#define IMPULSEALIAS_BASENAME												"kl_"
#define IMPULSEALIAS_PERSONALTELEPORTER										"PersonalTeleporter"
#define IMPULSEALIAS_TOGGLEFLASHLIGHT										"ToggleFlashlight"
#define IMPULSEALIAS_THROWFLARE												"ThrowFlare"

// Command Aliases
#define COMMANDALIAS_CLIENTSCORES											"ClientScores"
#define COMMANDALIAS_ADVANCEDSTATISTICS										"AdvancedStatistics"
#define COMMANDALIAS_RESETPLAYERMODEL										"ResetPlayerModel"
#define COMMANDALIAS_SETPLAYERMODEL_QUAKE2									"SetPlayerModel_Quake2"
#define COMMANDALIAS_QUAKE2TAUNTANIM_FLIP									"Q2Taunt_Flip"
#define COMMANDALIAS_QUAKE2TAUNTANIM_SALUTE									"Q2Taunt_Salute"
#define COMMANDALIAS_QUAKE2TAUNTANIM_TAUNT									"Q2Taunt_Taunt"
#define COMMANDALIAS_QUAKE2TAUNTANIM_WAVE									"Q2Taunt_Wave"
#define COMMANDALIAS_QUAKE2TAUNTANIM_POINT									"Q2Taunt_Point"

// Fields
.float 		bInitialHelpDisplayed;

// Prototypes
float		g_nNesp09FeatureDetectedCnt;
float		g_nSOEFeatureDetectedCnt;

float BroadcastClientCheat(entity enClient, float fCheatType, string strCheatString)
{ // Broadcast Client Cheat
	local string strMessage;
	local float bBroadcasted;
		bBroadcasted = TRUE;
	if( cvar(CVAR_MISC_BROADCASTPLAYERCHEATS) )
	{ // Broadcast Player Cheats Enabled
		// Generate Message
		strMessage = enClient.netname;
		strMessage = strcat(strMessage, "^7 used a ^1cheat^7 : ^2");
		
		if(fCheatType == HELP_CHEAT_ALLAMMOWEAPONSKEYS)
			strMessage = strcat(strMessage, "Give All Impulse");
		else
		if(fCheatType == HELP_CHEAT_ALLAMMOWEAPONSKEYSSHARED)
			strMessage = strcat(strMessage, "Shared Give All Impulse");
		else
		if(fCheatType == HELP_CHEAT_QUADDAMAGE)
			strMessage = strcat(strMessage, "Quad Damage");
		else
		if(fCheatType == HELP_CHEAT_GIVEALLPOWERUPS)
			strMessage = strcat(strMessage, "Give All Powerups");
		else
		if(fCheatType == HELP_CHEAT_GODMODE)
		{
			if(self.flags & FL_GODMODE)
				strMessage = strcat(strMessage, "Disable GodMode");
			else
				strMessage = strcat(strMessage, "Enable GodMode");
		}
		else
		if(fCheatType == HELP_CHEAT_NOCLIP)
		{
			if(self.movetype == MOVETYPE_NOCLIP)
				strMessage = strcat(strMessage, "Disable NoClip");
			else
				strMessage = strcat(strMessage, "Enable NoClip");
		}
		else
		if(fCheatType == HELP_CHEAT_NOTARGET)
		{
			if(self.flags & FL_NOTARGET)
				strMessage = strcat(strMessage, "Disable NoTarget");
			else
				strMessage = strcat(strMessage, "Enable NoTarget");
		}
		else
		if(fCheatType == HELP_CHEAT_GIVE)
			strMessage = strcat(strMessage, strCheatString);
		else
			strMessage = strcat(strMessage, "UNKNOWN");
			
		// Finish and Send Message
		strMessage = strcat(strMessage, "\n");
		bprint(strMessage);
		
		// Play Sound
		sound (world, CHAN_AUTO, "sound/misc/menu2.wav", 1, ATTN_NONE);
	}
	else
		bBroadcasted = FALSE;
		
	return bBroadcasted;
}
void BroadcastClientPlayerModelChange(entity enClient, string strModelName)
{ // Broadcast Client Player Model Change
	local string strMessage;
	
	strMessage = enClient.netname;
	strMessage = strcat(strMessage, "^7 changed to a ^1");
	if(enClient.nPlayerModelType == PLAYERMODEL_MODELTYPE_MDL)
		strMessage = strcat(strMessage, "Quake 1");
	else
	if(enClient.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2)
		strMessage = strcat(strMessage, "Quake 2");
		
	strMessage = strcat(strMessage, "^7 Player Model : ^2", strModelName);
	
	strMessage = strcat(strMessage, "^7 (^2Skin ", ftos(enClient.skin + 1), "^7)");
	// strMessage = strcat(strMessage, SG_GetSexStringFromSexID(enClient.nPlayerModelSex), "^7)");
	/*strMessage = strcat(strMessage, SG_GetFootstepStringFromFootstepID(enClient.nPlayerModelFootstepType), " Footsteps");
		
	strMessage = strcat(strMessage, "^7, ^2");
	if(enClient.bPlayerModelUsingCustomSounds)
		strMessage = strcat(strMessage, "Using Model Sounds");
	else
		strMessage = strcat(strMessage, "Not Using Model Sounds");
	strMessage = strcat(strMessage, "^7)");*/
	
	// Finish and Send Message
	strMessage = strcat(strMessage, "\n");
	bprint(strMessage);
		
	// Play Sound
	sound (world, CHAN_AUTO, "sound/misc/menu2.wav", 1, ATTN_NONE);
}

string Help_AppendQuickHelpNameFloatValue(string strMessage, string strName, float fValue, float bBooleanEnglish)
{ // Append QuickHelp Name Float Value
	local float nSpacingNeeded;
	local float nSpacingCnt;
	
	strMessage = strcat(strMessage, "^7\n");
	
	// Convert Value
	local string strValue;
		if(bBooleanEnglish)
		{ // Utilize English
			if(fValue)
				strValue = strzone("True");
			else
				strValue = strzone("False");
		}
		else
			// Utilize Value
			strValue = strzone(ftos(fValue) );
	
	// Append Spacing
		nSpacingNeeded = HELP_QUICKHELP_NAME_LENGTH - ( strlen(strName) );
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
			
	strMessage = strcat(strMessage, strName);
	strMessage = strcat(strMessage, " : ^2");
			
	strMessage = strcat(strMessage, strValue);
	// Append Spacing
		nSpacingNeeded = HELP_QUICKHELP_VALUE_LENGTH - ( strlen(strValue) );
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
			
	strunzone(strValue);
	
	// Return Message
	return strMessage;
}
string Help_AppendQuickHelpNameStringValue(string strMessage, string strName, string strValue)
{ // Append QuickHelp Name String Value
	local float nSpacingNeeded;
	local float nSpacingCnt;
	
	strMessage = strcat(strMessage, "^7\n");
	
	// Append Spacing
		nSpacingNeeded = HELP_QUICKHELP_NAME_LENGTH - ( strlen(strName) );
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
			
	strMessage = strcat(strMessage, strName);
	strMessage = strcat(strMessage, " : ^2");
			
	strMessage = strcat(strMessage, strValue);
	// Append Spacing
		nSpacingNeeded = HELP_QUICKHELP_VALUE_LENGTH - ( strlen(strValue) );
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
	
	// Return Message
	return strMessage;
}
void Help_DisplayMapInfo(entity enPlayer)
{ // Display Map Info
	local string strMessage;
	// ******************************************************
	// Display Map Info Listing
		strMessage = strcat(strMessage, "\n^7\n\bMAP INFO\b");
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# Hipnotic Features Detected", g_nHipnoticFeatureDetectedCnt, FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# Rogue Features Detected", g_nRogueFeatureDetectedCnt, FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# nesp09 Features Detected", g_nNesp09FeatureDetectedCnt, FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# SOE Features Detected", g_nSOEFeatureDetectedCnt, FALSE);
		#ifdef COMPILE_MODSUPPORT_TRAVAIL
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# Travail Features Detected", g_nTravailFeatureDetectedCnt, FALSE);
		#endif
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# Random Features Detected", g_nNumRandomEntitiesDetectedCnt, FALSE);
	
	// Display Message
	centerprint(enPlayer, strMessage);
	// Play Sound
	stuffcmd(enPlayer, "play2 sound/misc/menu2\n");
}
void Help_DisplayGameSettings(entity enPlayer)
{ // Display Quick Help
	local string strMessage;
	
	strMessage = "\bKLESHIK GAME SETTINGS\b\n\n";
	// ******************************************************
	// Display Quick Coop Info Listing
	if(coop)
	{ // Coop Enabled
		strMessage = strcat(strMessage, "\n^7\n\bQUICK COOP INFO\b");
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Shared Weapons Pool", cvar(CVAR_COOP_SHAREDWEAPONSPOOL), TRUE );
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Shared Ammo Pool", g_bCoopSharedAmmo, TRUE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Respawn at Death Location Allowed", cvar(CVAR_COOP_RESPAWNATDEATHLOCATION_ALLOW), TRUE );
	}
	
	// ******************************************************
	// Display Quick Monsters Settings Listing
	if(!deathmatch)
	{ // Deathmatch Disnabled
		strMessage = strcat(strMessage, "\n^7\n\bQUICK MONSTERS INFO\b");
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "# Spawn Additional Monsters", cvar(CVAR_MONSTER_SPAWNADDITIONALCREATURES), FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Elite Monster Percent Chance", cvar(CVAR_ELITEMONSTER_BASEPERCENTCHANCE), FALSE);
		strMessage = Help_AppendQuickHelpNameStringValue(strMessage, "Global Movement Multiplier", cvar_string(CVAR_MONSTER_MOVEMENTMULTIPLIER) );
	}
	
	// ******************************************************
	// Display Exploding Items Settings Listing
	
		strMessage = strcat(strMessage, "\n^7\n\bEXPLODING ITEM BOXES INFO\b");
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Exploding Item Box Percent", cvar(CVAR_EXPLODINGITEMBOX_PERCENTCHANCE), FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Explosive Damage", cvar(CVAR_EXPLODINGITEMBOX_DAMAGE), FALSE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Include Item Respawns", cvar(CVAR_EXPLODINGITEMBOX_INCLUDEITEMRESPAWNS), TRUE);
		
	// ******************************************************
	// Display GameMode Settings Listing
		strMessage = strcat(strMessage, "\n^7\n\bGAMEMODE INFO\b");
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Kleshik Weapons Enabled", g_bKleshikWeaponsEnabled, TRUE);
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Hipnotic Mission Pack Enabled", g_bHipnoticEnabled, TRUE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Rogue Mission Pack Enabled", g_bRogueEnabled, TRUE);
		#ifdef COMPILE_MODSUPPORT_TRAVAIL
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Travail Enabled", g_bTravailEnabled, TRUE);
		#endif
		
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Cheats Enabled", cvar("sv_cheats"), TRUE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Infinite Ammo", SG_AUTOCVAR(kleshik_server_ammo_infinite), TRUE);
		strMessage = Help_AppendQuickHelpNameFloatValue(strMessage, "Gyro Physics Enabled", g_bGyroPhysicsEnabled, TRUE);
	
	// Display Message
	centerprint(enPlayer, strMessage);
	// Play Sound
	stuffcmd(enPlayer, "play2 sound/misc/menu2\n");
}