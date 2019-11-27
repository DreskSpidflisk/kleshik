// DRESK - Client Statistics / Scoring
// Provides definitions and default values for client scoring / statistics.

#define CLIENTSCORE_NUMKILLS												0
#define CLIENTSCORE_NUMDEATHS												1
#define CLIENTSCORE_NUMAMMOPICKEDUP											2
#define CLIENTSCORE_NUMAMMOUSED												3
#define CLIENTSCORE_NUMSECRETSFOUND											4
#define CLIENTSCORE_TOTALDAMAGEDEALT										5
#define CLIENTSCORE_TOTALDAMAGERECEIVED										6

#define CLIENTSCORE_NUMSTATS												6
#define CLIENTSCORE_COLUMN_LENGTH											10

#define CLIENTSCORE_ALIGNMENT_LEFT											1
#define CLIENTSCORE_ALIGNMENT_RIGHT											2

#define CLIENTSCORE_COLUMNNAME_1											"\bClient /"
#define CLIENTSCORE_COLUMNNAME_1_ROW_2										"\bSecrets"
#define CLIENTSCORE_COLUMNWIDTH_1											25

#define CLIENTSCORE_COLUMNNAME_2											"\bKills /"
#define CLIENTSCORE_COLUMNNAME_2_ROW_2										"\bDeaths"
#define CLIENTSCORE_COLUMNWIDTH_2											12

#define CLIENTSCORE_COLUMNNAME_3											"\bAmmo Used /"
#define CLIENTSCORE_COLUMNNAME_3_ROW_2										"\bAcquired"
#define CLIENTSCORE_COLUMNWIDTH_3											20

#define CLIENTSCORE_COLUMNNAME_4											"\bDamage Given /"
#define CLIENTSCORE_COLUMNNAME_4_ROW_2										"\bTaken"
#define CLIENTSCORE_COLUMNWIDTH_4											20

// Specify if Array Storage Should be Used
// #define CLIENTSCORE_USEARRAYSTORAGE

// Prepare Scoring Array Here for Automated Header Printer
#ifdef CLIENTSCORE_USEARRAYSTORAGE
string strClientScoreHeaders[CLIENTSCORE_NUMSTATS];
string strClientScoreArray[CLIENTSCORE_NUMSTATS];
#endif

// Support Additional Client Scores	
// NOTE: Not using Client Score Array System until FTEQCC supports field arrays (not just global arrays)
// UPDATE: Thanks to div0 for pointing out FTEQCC does support field arrays.
// UPDATE 2: FTEQCC is crashing when using arrays, so making it a preprocessor definition
// UPDATE 3: FTEQCC is crashing when using #ifdefs, so NOW I am making it variable based
// UPDATE 4: I officially have no idea what the fuck is going on.
// UPDATE 5: Array Storage support is pretty much nonexistant.  The entire system works without using arrays.

// Field / Global Definitions
#ifdef CLIENTSCORE_USEARRAYSTORAGE
.float		nClientScores[CLIENTSCORE_NUMSTATS];
#else
.float		nClientScore_NumKills;
.float		nClientScore_NumDeaths;
.float		nClientScore_NumAmmoPickedUp;
.float		nClientScore_NumAmmoUsed;
.float		nClientScore_NumSecretsFound;
.float		nClientScore_TotalDamageDealt;
.float		nClientScore_TotalDamageReceived;
#endif

float GetClientStatsScore(entity enClient, float nScoreType)
{ // Return Clients Stats Score
	// NOTE: The primary usage of this function is to allow for easy IFDEF capability for switching between
	// the array storage method or the multiple variable storage method.
	local float nReturn;
	
	#ifdef CLIENTSCORE_USEARRAYSTORAGE
	nReturn = enClient.(nClientScores[nScoreType]);
	#else
	if(nScoreType == CLIENTSCORE_NUMKILLS)
		nReturn = enClient.nClientScore_NumKills;
	else
	if(nScoreType == CLIENTSCORE_NUMDEATHS)
		nReturn = enClient.nClientScore_NumDeaths;
	else
	if(nScoreType == CLIENTSCORE_NUMAMMOPICKEDUP)
		nReturn = enClient.nClientScore_NumAmmoPickedUp;
	else
	if(nScoreType == CLIENTSCORE_NUMAMMOUSED)
		nReturn = enClient.nClientScore_NumAmmoUsed;
	else
	if(nScoreType == CLIENTSCORE_NUMSECRETSFOUND)
		nReturn = enClient.nClientScore_NumSecretsFound;
	else
	if(nScoreType == CLIENTSCORE_TOTALDAMAGEDEALT)
		nReturn = enClient.nClientScore_TotalDamageDealt;
	else
	if(nScoreType == CLIENTSCORE_TOTALDAMAGERECEIVED)
		nReturn = enClient.nClientScore_TotalDamageReceived;
	#endif
	
	// Return Value
	return nReturn;
}
void UpdateClientStatsScore(entity enClient, float nScoreType, float fMod)
{ // Update Clients Stats Score
	// NOTE: The primary usage of this function is to allow for easy IFDEF capability for switching between
	// the array storage method or the multiple variable storage method.
	#ifdef CLIENTSCORE_USEARRAYSTORAGE
	enClient.(nClientScores[nScoreType]) = enClient.(nClientScores[nScoreType]) + fMod;
	#else
	if(nScoreType == CLIENTSCORE_NUMKILLS)
		enClient.nClientScore_NumKills = enClient.nClientScore_NumKills + fMod;
	else
	if(nScoreType == CLIENTSCORE_NUMDEATHS)
		enClient.nClientScore_NumDeaths = enClient.nClientScore_NumDeaths + fMod;
	else
	if(nScoreType == CLIENTSCORE_NUMAMMOPICKEDUP)
		enClient.nClientScore_NumAmmoPickedUp = enClient.nClientScore_NumAmmoPickedUp + fMod;
	else
	if(nScoreType == CLIENTSCORE_NUMAMMOUSED)
		enClient.nClientScore_NumAmmoUsed = enClient.nClientScore_NumAmmoUsed + fMod;
	else
	if(nScoreType == CLIENTSCORE_NUMSECRETSFOUND)
		enClient.nClientScore_NumSecretsFound = enClient.nClientScore_NumSecretsFound + fMod;
	else
	if(nScoreType == CLIENTSCORE_TOTALDAMAGEDEALT)
		enClient.nClientScore_TotalDamageDealt = enClient.nClientScore_TotalDamageDealt + fMod;
	else
	if(nScoreType == CLIENTSCORE_TOTALDAMAGERECEIVED)
		enClient.nClientScore_TotalDamageReceived = enClient.nClientScore_TotalDamageReceived + fMod;
	#endif
}

#ifdef CLIENTSCORE_USEARRAYSTORAGE
void PrepareClientScoringHeaderArray()
{ // Prepare Client Scoring Header Array
	local float nCnt;
		nCnt = 0;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_1;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_2;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_3;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_4;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_5;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_6;
		nCnt = nCnt + 1;
	strClientScoreHeaders[nCnt] = CLIENTSCORE_COLUMNNAME_7;
		nCnt = nCnt + 1;
	/*
	strClientScoreHeaders[nCnt] = "Damage Taken";
		nCnt = nCnt + 1;
	*/
}
#endif
#ifdef CLIENTSCORE_USEARRAYSTORAGE
void PrepareClientScoringArray(entity enPlayer)
{ // Prepare Client Scoring Array
	local float nCnt;
		nCnt = 0;
	// Player Name
	strClientScoreArray[nCnt] = enPlayer.netname;
		nCnt = nCnt + 1;
	// Number of Kills
	strClientScoreArray[nCnt] = strzone(ftos( GetClientStatsScore(enPlayer, CLIENTSCORE_NUMKILLS) ));
		nCnt = nCnt + 1;
	// Number of Deaths
	strClientScoreArray[nCnt] = strzone(ftos( GetClientStatsScore(enPlayer, CLIENTSCORE_NUMDEATHS) ));
		nCnt = nCnt + 1;
	// Number of Items Picked Up
	strClientScoreArray[nCnt] = strzone(ftos( GetClientStatsScore(enPlayer, CLIENTSCORE_NUMAMMOPICKEDUP) ));
		nCnt = nCnt + 1;
	// Number of Secrets Found
	strClientScoreArray[nCnt] = strzone(ftos( GetClientStatsScore(enPlayer, CLIENTSCORE_NUMSECRETSFOUND) ));
		nCnt = nCnt + 1;
	// Total Damage Dealt / Taken
	strClientScoreArray[nCnt] = strzone(ftos( GetClientStatsScore(enPlayer, CLIENTSCORE_NUMKILLS) ));
		nCnt = nCnt + 1;
}
#endif
#ifdef CLIENTSCORE_USEARRAYSTORAGE
void PurgeClientScoringArray()
{ // Purge Client Scoring Array
	local float nCnt;
	
	for(nCnt = 1; nCnt < CLIENTSCORE_NUMSTATS; nCnt++)
		strunzone( strClientScoreArray[nCnt] );
}
#endif
string AppendRowElement(string strMessage, string strRowElement, float nAlignment, float nColumnSize, float bUseNoColorLength)
{ // Append Row Element
	local float nSpacingCnt;
	local float nSpacingNeeded;
	
	// Calculate Spacing Needed
	if(bUseNoColorLength)
		nSpacingNeeded = nColumnSize - (strlennocol(strRowElement));
	else
		nSpacingNeeded = nColumnSize - (strlen(strRowElement));
	
	if(nAlignment == CLIENTSCORE_ALIGNMENT_RIGHT)
	{ // Left Alignment
		// Append Spacing
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
	}
	// Append Content
	strMessage = strcat(strMessage, strRowElement);
	if(nAlignment == CLIENTSCORE_ALIGNMENT_LEFT)
	{ // Right Alignment
		// Append Spacing
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
	}
	
	// Return Appended String
	return strMessage;
}
string AppendClientScoringRow(string strMessage, entity enPlayer)
{ // Append Client Scoring Row	
	// Append Return
	strMessage = strcat(strMessage, "\n");
	
	#ifdef CLIENTSCORE_USEARRAYSTORAGE
	local float nCnt;
	local float nSpacingCnt;
	local float nSpacingNeeded;
	// Generate Client Scoring Array
	PrepareClientScoringArray(enPlayer);
	
	for(nCnt = 0; nCnt < CLIENTSCORE_NUMSTATS; nCnt++)
	{ // Traverse Scoring Array
		// Calculate Spacing Needed
		nSpacingNeeded = CLIENTSCORE_COLUMN_LENGTH - strlennocol( strClientScoreArray[nCnt]);
		// Append Spacing
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
		// Append Content
		strMessage = strcat(strMessage, strClientScoreArray[nCnt]);
	}
	
	// Purge Client Scoring Array
	PurgeClientScoringArray();
	#else
	local string strElement;
	local float nShift;
	local float bUseNoColorLength;
		nShift = 0;
		bUseNoColorLength = TRUE;
	
	// Name / Secrets
	strElement = strcat(enPlayer.netname, "^7");
	strElement = strcat(strElement, " / ", ftos(enPlayer.nClientScore_NumSecretsFound) );
	strMessage = AppendRowElement(strMessage, strElement, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_1, bUseNoColorLength);
	
	// Kills / Deaths
	if(enPlayer.nClientScore_NumKills < enPlayer.nClientScore_NumDeaths)
		strElement = strcat("^1", ftos(enPlayer.nClientScore_NumKills) );
	else
		strElement = strcat("^7", ftos(enPlayer.nClientScore_NumKills) );
	strElement = strcat(strElement, " / ", ftos(enPlayer.nClientScore_NumDeaths) );
	strMessage = AppendRowElement(strMessage, strElement, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_2, bUseNoColorLength);
	
	// Ammo Used / Acquired
	if(enPlayer.nClientScore_NumAmmoPickedUp < enPlayer.nClientScore_NumAmmoUsed)
		strElement = strcat("^1", ftos( rint(enPlayer.nClientScore_NumAmmoUsed)) );
	else
		strElement = strcat("^7", ftos( rint(enPlayer.nClientScore_NumAmmoUsed)) );
	strElement = strcat(strElement, " / ", ftos(enPlayer.nClientScore_NumAmmoPickedUp) );
	strMessage = AppendRowElement(strMessage, strElement, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_3, bUseNoColorLength);
	
	// Damage Given / Taken
	if(enPlayer.nClientScore_TotalDamageDealt < enPlayer.nClientScore_TotalDamageReceived)
		strElement = strcat("^1", ftos(enPlayer.nClientScore_TotalDamageDealt) );
	else
		strElement = strcat("^7", ftos(enPlayer.nClientScore_TotalDamageDealt) );
	strElement = strcat(strElement, " / ", ftos(enPlayer.nClientScore_TotalDamageReceived));
	strMessage = AppendRowElement(strMessage, strElement, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_4, bUseNoColorLength);
	#endif
	
	// Return Appended String
	return strMessage;
}
string AppendClientScoringRowHeaders(string strMessage)
{ // Append Client Scoring Row Headers	
	// Append Return
	strMessage = strcat(strMessage, "\n");
	
	#ifdef CLIENTSCORE_USEARRAYSTORAGE
	local float nCnt;
	local float nSpacingCnt;
	local float nSpacingNeeded;
	for(nCnt = 0; nCnt < CLIENTSCORE_NUMSTATS; nCnt++)
	{ // Traverse Scoring Array
		// Calculate Spacing Needed
		nSpacingNeeded = CLIENTSCORE_COLUMN_LENGTH - strlen( strClientScoreHeaders[nCnt]);
		// Append Header
		strMessage = strcat(strMessage, strClientScoreHeaders[nCnt]);
		// Append Spacing
		for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
			strMessage = strcat(strMessage, " ");
	}
	#else
	local float bUseNoColorLength;
		bUseNoColorLength = FALSE;
		
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_1, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_1, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_2, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_2, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_3, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_3, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_4, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_4, bUseNoColorLength);
	// Skip to Second Row for Headers
	strMessage = strcat(strMessage, "\n");
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_1_ROW_2, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_1, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_2_ROW_2, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_2, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_3_ROW_2, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_3, bUseNoColorLength);
	strMessage = AppendRowElement(strMessage, CLIENTSCORE_COLUMNNAME_4_ROW_2, CLIENTSCORE_ALIGNMENT_LEFT, CLIENTSCORE_COLUMNWIDTH_4, bUseNoColorLength);
	#endif
	
	// Return New String
	return strMessage;
}
void PrintClientScoring(entity enPlayer, float bIntermission)
{ // Print Client Scoring
	local string strMessage;
	local entity enPlayerFind;
	
	#ifdef CLIENTSCORE_USEARRAYSTORAGE
	PrepareClientScoringHeaderArray();
	#endif

	// Print Title
	strMessage = "\bKLESHIK CLIENT SCORING\b\n\n";
	
	// Print Row Headers
	strMessage = AppendClientScoringRowHeaders(strMessage);
	
	// Append Return
	strMessage = strcat(strMessage, "\n");
	
	// Print Client Rows
	// Acquire First Player
	enPlayerFind = find(world, classname, "player");
	while(enPlayerFind != world)
	{ // Valid Player
		// Append Client Scoring Raw
		strMessage = AppendClientScoringRow(strMessage, enPlayerFind);
		
		// Append Two Returns
		strMessage = strcat(strMessage, "\n^7\n");
		
		// Acquire Next Player
		enPlayerFind = find(enPlayerFind, classname, "player");
	}
	
		// Display to Entity
	if(bIntermission)
		WriteString(MSG_ALL, strMessage);
	else
	{
		// Centerprint
		centerprint(enPlayer, strMessage);
		// Play Sound
		stuffcmd(enPlayer, "play2 sound/misc/menu2\n");
	}
}