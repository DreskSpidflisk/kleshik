// Definitions
#define PLAYERMODELS_CVAR_BASE_MODELTYPE						"klpm_Base_ModelType"
#define PLAYERMODELS_CVAR_BASE_MODELNAME						"klpm_Base_ModelName"
#define PLAYERMODELS_CVAR_BASE_SEX								"klpm_Base_Sex"
#define PLAYERMODELS_CVAR_BASE_FOOTSTEPS						"klpm_Base_Footsteps"
#define PLAYERMODELS_CVAR_BASE_JUMPLAND							"klpm_Base_JumpLand"
#define PLAYERMODELS_CVAR_QUAKE2_SKIN							"klpm_Quake2_Skin"
#define PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON						"klpm_Quake2_ViewWeapon"
#define PLAYERMODELS_CVAR_QUAKE2_USESOUNDS						"klpm_Quake2_UseSounds"

// Input Buttons
#define PLAYERMODEL_INPUTBUTTON_CROUCH							16

void SyncPlayerModel()
{ // Sync Player Model
	local string strModelType;
		strModelType = cvar_string(PLAYERMODELS_CVAR_BASE_MODELTYPE);
	if(strModelType != "")
	{ // Valid Model Type
		// Generate Sync String
		local string strSync;
		strSync = strcat(strModelType, " ", cvar_string(PLAYERMODELS_CVAR_BASE_MODELNAME) );
		strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_BASE_SEX) );
		strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_BASE_FOOTSTEPS) );
		strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_BASE_JUMPLAND) );
		if( stof(strModelType) == PLAYERMODEL_MODELTYPE_MD2)
		{ // Quake2 Model
			strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_QUAKE2_USESOUNDS) );
			strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_QUAKE2_SKIN) );
			strSync = strcat(strSync, " ", cvar_string(PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON) );
		}
		
		// Execute Command
		localcmd("cmd ", KLESHIK_COMMAND_SERVER_UPDATEPLAYERMODEL, " ", strSync, "\n");
	}
}
void CheckAndCreateDefaultPlayerModelCVar(string strCVarName, string strValue)
{ // CheckAndCreateDefaultPlayerModelCVar
	if( cvar_string(strCVarName) == "" || cvar_string(strCVarName) == " ")
		localcmd("seta \"", strCVarName, "\" \"", strValue, "\"\n");
}
void CheckBlankPlayerModelVariables()
{ // Check Blank Player Model Variables
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_BASE_MODELTYPE, "0");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_BASE_MODELNAME, "quakeguy");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_BASE_SEX, "m");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_BASE_FOOTSTEPS, "Boots");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_BASE_JUMPLAND, "Humanoid");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_QUAKE2_SKIN, "0");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON, "1");
	CheckAndCreateDefaultPlayerModelCVar(PLAYERMODELS_CVAR_QUAKE2_USESOUNDS, "y");
}
void PreparePlayerModels()
{
	// Register Commands
	registercommand(PLAYERMODEL_CLIENTCOMMAND_LISTQUAKE2PLAYERMODELS);
	registercommand(PLAYERMODEL_CLIENTCOMMAND_SERVERCONFIRMPLAYERMODELCHANGE);
	registercommand(PLAYERMODEL_CLIENTCOMMAND_SERVERREQUESTPLAYERMODELSYNC);
	registercommand(PLAYERMODEL_CLIENTCOMMAND_GENERATEQUAKE2SKINFILES);
	registercommand(PLAYERMODEL_CLIENTCOMMAND_DISPLAYPLAYERMODELINTERFACE);
	registercommand(PLAYERMODEL_CLIENTCOMMAND_TOGGLEPLAYERCROUCH);
	
	// Remove Crouch Input Button
	input_buttons = input_buttons - (input_buttons & PLAYERMODEL_INPUTBUTTON_CROUCH);
	
	// Check for Blank Player Model Variables
	CheckBlankPlayerModelVariables();
}
void TogglePlayerCrouch()
{ // Toggle Player Crouch
	// print("Input Buttons : ", ftos(input_buttons), "\n");
	if(input_buttons & PLAYERMODEL_INPUTBUTTON_CROUCH)
		// Crouch Enabled
		localcmd("-button5\n");
	else
		localcmd("+button5\n");
}

void ListQuake2PlayerModels()
{ // List Quake2 Player Models
	local float nHandle;
	local float nNumFiles;
	local string strPlayerName;
	local float bZebra;
	local float nCnt;
	
	// Print Header
	print("^1Quake2 Player Model List\n");
	
	// Search for Players
	nHandle = search_begin("data/players/Quake2/*", true, true);
	
	if(nHandle != -1)
	{ // Players Found
		// Acquire Number of Files
		nNumFiles = search_getsize(nHandle);
		
		for(nCnt = 0; nCnt < nNumFiles; nCnt++)
		{ // Parse through Players
			// Acquire Player Name
			strPlayerName = search_getfilename(nHandle, nCnt);
			// Cull Directory Path
			strPlayerName = substring(strPlayerName, 20, 100);
			
			if(strPlayerName != "." && strPlayerName != "..")
			{// Valid Player Name
				/*
				if(bZebra)
					print("^2");
				*/
				print(strPlayerName, ", ");
				
				bZebra = !bZebra;
			}
		}
		// Print Return
		print("\n");
		
		// Free Search
		search_end(nHandle);
	}
	else
	{ // Report Failure
		print("^1ERROR^7 : No Players Found in Search ^2", "data/players/Quake2", "^7!\n");
	}
}
string GetQuake2PlayerModelFaceStringZoned(string strModelName, float nSkinID)
{ // Get Quake2 Player Model Face String Zoned
	local float nHandle;
	local float nNumFiles;
	local string strFaceName;
	
	local string strDataPath;
	strDataPath = strcat("data/players/Quake2/", strModelName, "/*_i.pcx");
	
	// Search for Faces
	nHandle = search_begin(strDataPath, true, true);
	
	if(nHandle != -1)
	{ // Faces Found
		// Acquire Number of Files
		nNumFiles = search_getsize(nHandle);
		if(nSkinID > nNumFiles)
		{ // Bad Skin
			print("^1WARNING ^7: Model ^2", strModelName, "^7 trying to use invalid skin ID ^2", nSkinID, "^7!\n");
			strFaceName = "NOFACE";
		}
		else
		{
			// Acquire Face Name
			strFaceName = search_getfilename(nHandle, nSkinID);
			
			// Free Search
			search_end(nHandle);
		}
	}
	else
	{ // Report Failure
		print("^1ERROR^7 : No Faces Found in Search ^2", strDataPath, "^7!\n");
		strFaceName = "NOFACE";
	}
	
	// Zone Face
	strFaceName = strzone(strFaceName);
	return strFaceName;
}
void RegisterPlayerModel(float nModelType, string strModelName, float nSex, float nFootsteps, float nJumpLand, float bUseSounds, float nSkinID, float nViewWeaponID)
{ // Register Player Model
	local void(string) fpFunc;
		fpFunc = localcmd;
		// fpFunc = print;
	// local string strCommand;
	
	// Save Model to Local CVars
	// NOTE: Do NOT use local commands due to the delay they create
	cvar_set(PLAYERMODELS_CVAR_BASE_MODELTYPE, ftos(nModelType) );
	cvar_set(PLAYERMODELS_CVAR_BASE_MODELNAME, strtolower(strModelName) );
	cvar_set(PLAYERMODELS_CVAR_BASE_SEX, SG_GetAbbreviatedSexStringFromSexID(nSex) );
	cvar_set(PLAYERMODELS_CVAR_BASE_FOOTSTEPS, SG_GetFootstepStringFromFootstepID(nFootsteps) );
	cvar_set(PLAYERMODELS_CVAR_BASE_JUMPLAND, SG_GetJumpLandStringFromJumpLandID(nJumpLand) );
	/*
	strCommand = strcat("seta ", PLAYERMODELS_CVAR_BASE_MODELTYPE, " \"", ftos(nModelType), "\"\n");
	fpFunc(strCommand);
	strCommand = strcat("seta ", PLAYERMODELS_CVAR_BASE_MODELNAME, " \"", strtolower(strModelName), "\"\n");
	fpFunc(strCommand);
	strCommand = strcat("seta ", PLAYERMODELS_CVAR_BASE_SEX, " \"", SG_GetAbbreviatedSexStringFromSexID(nSex), "\"\n");
	fpFunc(strCommand);
	strCommand = strcat("seta ", PLAYERMODELS_CVAR_BASE_FOOTSTEPS, " \"", SG_GetFootstepStringFromFootstepID(nFootsteps), "\"\n");
	fpFunc(strCommand);
	*/
		
	// Model Specific Values
	if(nModelType == PLAYERMODEL_MODELTYPE_MD2)
	{ // Quake2 Player Model
		cvar_set(PLAYERMODELS_CVAR_QUAKE2_SKIN, ftos(nSkinID) );
		if(bUseSounds)
			cvar_set(PLAYERMODELS_CVAR_QUAKE2_USESOUNDS, "y");
		else
			cvar_set(PLAYERMODELS_CVAR_QUAKE2_USESOUNDS, "n");
		cvar_set(PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON, ftos(nViewWeaponID) );
		/*
		strCommand = strcat("seta ", PLAYERMODELS_CVAR_QUAKE2_SKIN, " \"", ftos(nSkinID), "\"\n");
		fpFunc(strCommand);
		if(bUseSounds)
			strCommand = strcat("seta ", PLAYERMODELS_CVAR_QUAKE2_USESOUNDS, " \"", "y", "\"\n");
		else
			strCommand = strcat("seta ", PLAYERMODELS_CVAR_QUAKE2_USESOUNDS, " \"", "n", "\"\n");
		fpFunc(strCommand);
		strCommand = strcat("seta ", PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON, " \"", ftos(nViewWeaponID), "\"\n");
		fpFunc(strCommand);
		*/
	}
}
void ServerConfirmPlayerModelChange()
{ // Server Confirmed Player Model Change
	// Prepare Custom Face
	if(g_strCustomFace != "")
	{ // Free Current Face
		strunzone(g_strCustomFace);
		g_strCustomFace = "";
	}
	
	// Update Face from Local CVars
	if( cvar(PLAYERMODELS_CVAR_BASE_MODELTYPE) == PLAYERMODEL_MODELTYPE_MD2)
		g_strCustomFace = GetQuake2PlayerModelFaceStringZoned( cvar_string(PLAYERMODELS_CVAR_BASE_MODELNAME), cvar(PLAYERMODELS_CVAR_QUAKE2_SKIN) );
}
void ServerRequestPlayerModelSync()
{ // Server Request Player Model Sync
	// Sync Player Model
	SyncPlayerModel();
}