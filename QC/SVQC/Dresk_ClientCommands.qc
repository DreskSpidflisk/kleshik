// DRESK - Client Commands
// Provides functionality for client command monitoring.

// Prototypes
void PrintAdvancedStatistics(entity enPlayer, float bIntermission);

void SetModelOnPrydonCursorEntity(entity enClient, string strModel)
{ // Set Model on Prydon Cursor Entity
	// Precache Model
	precache_model(strModel);
	// Assign to Prydon Cursor Entity
	if(enClient.cursor_trace_ent)
		setmodel(enClient.cursor_trace_ent, strModel);
}
void ToggleCheatFlag(entity enClient, float nFlag)
{ // Toggle Cheat Flag
	if(enClient.flags & nFlag)
		enClient.flags = enClient.flags - (enClient.flags & nFlag);
	else
		enClient.flags = enClient.flags | nFlag;
}
void ToggleCheatMovetype(entity enClient, float nMovetype)
{ // Toggle Cheat Movetype
	if(enClient.movetype == nMovetype)
		enClient.movetype = MOVETYPE_WALK;
	else
		enClient.movetype = nMovetype;
}
void SV_ParseClientCommand(string strCommand)
{ // Main Client Command Parse
	local float bValidCommand;
		bValidCommand = TRUE;
	// Tokenize String
	tokenize(strCommand);
	
	// Check for Cheat Commands
	if( cvar("sv_cheats") )
	{ // Cheats Enabled; Check
		local float nCheatID;
		local float nCheatFlag;
		local float nCheatMovetype;
		if( argv(0) == "god")
		{
			nCheatID = HELP_CHEAT_GODMODE;
			nCheatFlag = FL_GODMODE;
		}
		else
		if( argv(0) == "notarget")
		{
			nCheatID = HELP_CHEAT_NOTARGET;
			nCheatFlag = FL_NOTARGET;
		}
		else
		if( argv(0) == "noclip")
		{
			nCheatID = HELP_CHEAT_NOCLIP;
			nCheatMovetype = MOVETYPE_NOCLIP;
		}
		else
		if( argv(0) == "give")
		{
			nCheatID = HELP_CHEAT_GIVE;
		}
		
		if(nCheatID || nCheatMovetype)
		{ // Cheated
			BroadcastClientCheat(self, nCheatID, "");
			if(nCheatFlag)
				ToggleCheatFlag(self, nCheatFlag);
			else
			if(nCheatMovetype)
				ToggleCheatMovetype(self, nCheatMovetype);
				
			bValidCommand = FALSE;
		}
	}
	if( argv(0) == "RemoveAllMonsterCorpses")
	{ // Remove All Monster Corpses
		RemoveAllMonsterCorpses(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "ttt")
	{
	}
	else
	if( argv(0) == "random")
	{
		local float nRandom;
			nRandom = random() * stof(argv(1) );
		local string strMessage;
			strMessage = strcat("random() * ", argv(1), " = ", ftos(nRandom), "\n");
		sprint(self, strMessage);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "KillAllMonsters")
	{ // Kill All Monsters
		KillAllMonsters(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "RawStuffCmdToClient")
	{ // Raw StuffCmd to Client
		RawStuffCmdToClient_SendStuffCmd();
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "ResetCooperativeSharedAmmoPoolAndItems")
	{ // Raw StuffCmd to Client
		ResetCooperativeSharedAmmoPoolAndItems(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "SetModelOnPrydonCursorEntity")
	{ // Set Model on Prydon Cursor Entity
		SetModelOnPrydonCursorEntity(self, argv(1) );
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "ListHipnoticSpawnEntities")
	{
		ListHipnoticSpawnEntities(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == "ListNODRAWMonsters")
	{
		ListNODRAWMonsters(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_CLIENTSCORES)
	{
		PrintClientScoring(self, FALSE);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_ADVANCEDSTATISTICS)
	{
		PrintAdvancedStatistics(self, FALSE);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_GAMESETTINGS)
	{
		Help_DisplayGameSettings(self);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_RESETPLAYERMODEL)
	{ // Reset Player Model
		ResetPlayerModel(self, TRUE);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_QUAKE2TAUNTANIM)
	{ // Quake2 Taunt Anim
		PlayerAnim_Quake2_Taunt( stof(argv(1)) , PLAYERANIM_ANIMSPEED_STANDARD);
		bValidCommand = FALSE;
	}
	else
	if( argv(0) == KLESHIK_COMMAND_SERVER_UPDATEPLAYERMODEL)
	{ // Update Player Model
		ParsePlayerModelCVarString(self, argv(1), argv(2), argv(3), argv(4), argv(5), argv(6), argv(7), argv(8) );
		bValidCommand = FALSE;
	}
	
	// Invoke Command
	if(bValidCommand)
		clientcommand(self, strCommand);
}