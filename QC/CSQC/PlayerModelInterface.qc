// Player Model Interface

// Definitions
#define HUDIMAGE_BACKGROUND									"gfx/bigbox"

#define FILESEARCH_BASENUMOFFSET							0

#define PLAYERMODELINTERFACE_KEY_ACCEPT1					13
#define PLAYERMODELINTERFACE_KEY_ACCEPT2					172

#define PLAYERMODELINTERFACE_KEY_CANCEL						27

#define PLAYERMODELINTERFACE_KEY_INCREMENTELEMENT			131
#define PLAYERMODELINTERFACE_KEY_DECREMENTELEMENT			130

#define PLAYERMODELINTERFACE_KEY_NEXTELEMENT				129
#define PLAYERMODELINTERFACE_KEY_PREVIOUSELEMENT			128

#define PLAYERMODELINTERFACE_SOUND_INTERFACETOGGLE			localcmd("play2 misc/menu2.wav\n")
#define PLAYERMODELINTERFACE_SOUND_NEWELEMENT				localcmd("play2 misc/menu1.wav\n")
#define PLAYERMODELINTERFACE_SOUND_ELEMENTSHIFT				localcmd("play2 misc/menu3.wav\n")

#define PLAYERMODELINTERFACE_IMAGE_NOFACE					"gfx/bigbox"

// Elements
#define ELEMENT_MODELTYPE									0
#define ELEMENT_MODEL										1
#define ELEMENT_SKIN										2
#define ELEMENT_VIEWWEAPON									3
#define ELEMENT_USESOUNDS									4
#define ELEMENT_SEX											5
#define ELEMENT_FOOTSTEPS									6
#define ELEMENT_JUMPLAND									7

#define ELEMENT_ACCEPT										8
#define ELEMENT_CANCEL										9

#define ELEMENT_MAX											9

#define ELEMENT_DISABLED_NOT								0
#define ELEMENT_DISABLED_NOSELECT							1
#define ELEMENT_DISABLED_NODRAW								2

// Fields
float	g_bPlayerModelSearchActive;
float	g_nPlayerModelSearchHandle;
float	g_nNumCurrentSearchPlayerModels;
float	g_nCurrentPlayerModelSearchNum;
float	g_bCurrentPlayerModelSearchValid;
string	g_strCurrentPlayerModelSearchName;

float	g_nCurrentPlayerModelSearchElementSelection;
float	g_nElementDisabled[ELEMENT_MAX];

// Base (Shared) Properties
float	g_nCurrentPlayerModelSearchModelType;
float	g_nCurrentPlayerModelSearchSex;
float	g_nCurrentPlayerModelSearchFootsteps;
float	g_nCurrentPlayerModelSearchJumpLand;
float	g_nCurrentPlayerModelSearchUseSounds;
float	g_nCurrentPlayerModelSearchHasSounds;

float	g_nCurrentPlayerModelSearchSkin;
float	g_nCurrentPlayerModelSearchNumSkins;

float	g_nCurrentPlayerModelSearchViewWeapon;
float	g_nCurrentPlayerModelSearchNumViewWeapons;
float	g_nCurrentPlayerModelSearchAvailableViewWeapons;

float	g_nCurrentPlayerModelSearchNumSounds;
float	g_nCurrentPlayerModelSearchAvailableSounds;

// entity	g_enPlayerModel;

string	g_strCurrentPlayerModelSearchFace;

// Prototypes
void EndPlayerModelSearch();
void BeginPlayerModelSearch();
void UpdateCurrentPlayerModelSearchInfo(float bStartAtLocalModel);

// Functions
void CheckCurrentSearchIsValid()
{ // Check Current Search Is Valid
	local string strBaseModelFolder;
	local string strFileCheck;
	local float nHandle;
	// Acquire Search Base Model Folder
	strBaseModelFolder = search_getfilename(g_nPlayerModelSearchHandle, g_nCurrentPlayerModelSearchNum + FILESEARCH_BASENUMOFFSET);
	
	g_bCurrentPlayerModelSearchValid = true;
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{ // Validate MDL
		// Search for /player.mdl
		strFileCheck = strcat(strBaseModelFolder, "/player.mdl");
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{ // Validate MD2
		// Search for /tris.md2
		strFileCheck = strcat(strBaseModelFolder, "/tris.md2");
	}
	else
		// Err, what are we working with?
		g_bCurrentPlayerModelSearchValid = false;
		
	// Search
	nHandle = search_begin(strFileCheck, true, true);
	if(nHandle != -1)
	{ // Valid Model
		g_bCurrentPlayerModelSearchValid = true;
		// End Search
		search_end(nHandle);
	}
	else
		g_bCurrentPlayerModelSearchValid = false;
		
	if(g_bCurrentPlayerModelSearchValid)
	{ // Valid Model
		if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
		{
			g_nElementDisabled[ELEMENT_USESOUNDS] = ELEMENT_DISABLED_NOSELECT;
			g_nElementDisabled[ELEMENT_VIEWWEAPON] = ELEMENT_DISABLED_NOSELECT;
			g_nElementDisabled[ELEMENT_SKIN] = ELEMENT_DISABLED_NOSELECT;
		}
		else
		if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
		{
			g_nElementDisabled[ELEMENT_USESOUNDS] = ELEMENT_DISABLED_NOT;
			g_nElementDisabled[ELEMENT_VIEWWEAPON] = ELEMENT_DISABLED_NOT;
			g_nElementDisabled[ELEMENT_SKIN] = ELEMENT_DISABLED_NOT;
			g_nElementDisabled[ELEMENT_FOOTSTEPS] = ELEMENT_DISABLED_NOT;
			g_nElementDisabled[ELEMENT_SEX] = ELEMENT_DISABLED_NOT;
		}
		g_nElementDisabled[ELEMENT_FOOTSTEPS] = ELEMENT_DISABLED_NOT;
		g_nElementDisabled[ELEMENT_JUMPLAND] = ELEMENT_DISABLED_NOT;
		g_nElementDisabled[ELEMENT_SEX] = ELEMENT_DISABLED_NOT;
		g_nElementDisabled[ELEMENT_ACCEPT] = ELEMENT_DISABLED_NOT;
	}
	else
	{ // Invalid Model
		// Reset Certain Counters
		g_nCurrentPlayerModelSearchNumSkins = 0;
		g_nCurrentPlayerModelSearchNumViewWeapons = 0;
		
		g_nElementDisabled[ELEMENT_SKIN]				= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_VIEWWEAPON]			= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_USESOUNDS]			= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_SEX]					= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_FOOTSTEPS]			= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_JUMPLAND]			= ELEMENT_DISABLED_NOSELECT;
		g_nElementDisabled[ELEMENT_ACCEPT]				= ELEMENT_DISABLED_NOSELECT;
	}
}
void UpdateCurrentPlayerModelSearchFace()
{ // Update Current Player Model Search Face
	// Check for Zoned String
	if(g_strCurrentPlayerModelSearchFace != "")
	{
		// Unzone String
		strunzone(g_strCurrentPlayerModelSearchFace);
		// Blank Out String
		g_strCurrentPlayerModelSearchFace = "";
	}
	
	if(g_bCurrentPlayerModelSearchValid)
	{ // Valid Model; Acquire Face
		// Update Face
		if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
		{ // Standard Quake Face
			g_strCurrentPlayerModelSearchFace = strzone("gfx/face1");
		}
		else
		if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
		{
			g_strCurrentPlayerModelSearchFace = GetQuake2PlayerModelFaceStringZoned(g_strCurrentPlayerModelSearchName, g_nCurrentPlayerModelSearchSkin);
		}
	}
	else
		// Use Blank Face
		g_strCurrentPlayerModelSearchFace = strzone(PLAYERMODELINTERFACE_IMAGE_NOFACE);
}
void UpdateCurrentPlayerModelSearchNumberOfSkins()
{ // Update Current Player Model Search Number of Skins
	local float nHandle;
	local string strSearch;
	
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{ // Quake Models have 1 Skin
		g_nCurrentPlayerModelSearchNumSkins = 0;
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{ // Quake2 Logic
		// Calculate Number of Skins
		strSearch = strcat(PLAYERMODEL_DATAPATH_QUAKE2, g_strCurrentPlayerModelSearchName, "/*_i.pcx");
		nHandle = search_begin(strSearch, true, true);

		if(nHandle != -1)
		{ // Valid Files
			// Acquire Number of Files
			g_nCurrentPlayerModelSearchNumSkins = search_getsize(nHandle);
			
			// Free Search
			search_end(nHandle);
		}
		else
			// No Skins?
			g_nCurrentPlayerModelSearchNumSkins = 0;
	}
}
void CheckCurrentPlayerModelHasViewWeapon(string strWeapon, float nWeaponBit)
{ // Check Current Player Model Has View Weapon
	local float nHandle;
	local string strSearch;
	
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{
		strSearch = strcat(PLAYERMODEL_DATAPATH_QUAKE2, g_strCurrentPlayerModelSearchName, strWeapon);
		nHandle = fopen(strSearch, FILE_READ);
		if(nHandle >= 0)
		{
			g_nCurrentPlayerModelSearchAvailableViewWeapons |= nWeaponBit;
			g_nCurrentPlayerModelSearchNumViewWeapons++;
			fclose(nHandle);
		}
	}
}
void CheckCurrentPlayerModelHasSound(string strSound, float nSoundBit)
{ // Check Current Player Model Has Sound
	local float nHandle;
	local string strSearch;
	
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{
		strSearch = strcat(PLAYERMODEL_DATAPATH_QUAKE2, g_strCurrentPlayerModelSearchName, strSound);
		nHandle = fopen(strSearch, FILE_READ);
		if(nHandle >= 0)
		{
			g_nCurrentPlayerModelSearchAvailableSounds |= nSoundBit;
			g_nCurrentPlayerModelSearchNumSounds++;
			fclose(nHandle);
		}
	}
}
void UpdateCurrentPlayerModelSearchAvailableViewWeapons()
{ // Update Current Player Model Search Available View Weapons
	// NOTE:
	// Use Static Searches for Weapons to properly generate a bitwise float.
	/*
	local float nHandle;
	local string strSearch;
	
	g_nCurrentPlayerModelSearchNumViewWeapons = 0;
	strSearch = strcat("data/players/Quake2/", g_strCurrentPlayerModelSearchName, "/w_*.md2");
	nHandle = search_begin(strSearch, true, true);
	
	if(nHandle != -1)
	{ // Valid Files
		// Acquire Number of Files
		g_nCurrentPlayerModelSearchNumViewWeapons = search_getsize(nHandle);
		
		// Free Search
		search_end(nHandle);
	}
	// Always Increment Number of Weapons (for standard weapon.md2 file)
	g_nCurrentPlayerModelSearchNumViewWeapons = g_nCurrentPlayerModelSearchNumViewWeapons + 1;
	*/
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{ // Quake Models 0 View Weapons
		g_nCurrentPlayerModelSearchNumViewWeapons = 0;
		g_nCurrentPlayerModelSearchAvailableViewWeapons = 0;
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{
		g_nCurrentPlayerModelSearchAvailableViewWeapons = 0;
		g_nCurrentPlayerModelSearchNumViewWeapons = 0;
		
		CheckCurrentPlayerModelHasViewWeapon("/weapon.md2", QUAKE2PLAYERMODEL_WEAPONID_DEFAULT);
		CheckCurrentPlayerModelHasViewWeapon("/w_blaster.md2", QUAKE2PLAYERMODEL_WEAPONID_BLASTER);
		CheckCurrentPlayerModelHasViewWeapon("/w_shotgun.md2", QUAKE2PLAYERMODEL_WEAPONID_SHOTGUN);
		CheckCurrentPlayerModelHasViewWeapon("/w_sshotgun.md2", QUAKE2PLAYERMODEL_WEAPONID_SUPERSHOTGUN);
		CheckCurrentPlayerModelHasViewWeapon("/w_machinegun.md2", QUAKE2PLAYERMODEL_WEAPONID_MACHINEGUN);
		CheckCurrentPlayerModelHasViewWeapon("/w_chaingun.md2", QUAKE2PLAYERMODEL_WEAPONID_CHAINGUN);
		CheckCurrentPlayerModelHasViewWeapon("/w_glauncher.md2", QUAKE2PLAYERMODEL_WEAPONID_GRENADELAUNCHER);
		CheckCurrentPlayerModelHasViewWeapon("/w_rlauncher.md2", QUAKE2PLAYERMODEL_WEAPONID_ROCKETLAUNCHER);
		CheckCurrentPlayerModelHasViewWeapon("/w_hyperblaster.md2", QUAKE2PLAYERMODEL_WEAPONID_HYPERBLASTER);
		CheckCurrentPlayerModelHasViewWeapon("/w_railgun.md2", QUAKE2PLAYERMODEL_WEAPONID_RAILGUN);
		CheckCurrentPlayerModelHasViewWeapon("/w_bfg.md2", QUAKE2PLAYERMODEL_WEAPONID_BFG);
	}
}
void UpdateCurrentPlayerModelSearchAvailableSounds()
{ // Update Current Player Model Search Available Sounds
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{ // Quake Models 0 Sounds
		g_nCurrentPlayerModelSearchNumSounds = 0;
		g_nCurrentPlayerModelSearchAvailableSounds = 0;
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{
		g_nCurrentPlayerModelSearchNumSounds = 0;
		g_nCurrentPlayerModelSearchAvailableSounds = 0;
		
		CheckCurrentPlayerModelHasSound("/bump1.wav", QUAKE2PLAYERMODEL_SOUNDID_BUMP1);
		CheckCurrentPlayerModelHasSound("/death1.wav", QUAKE2PLAYERMODEL_SOUNDID_DEATH1);
		CheckCurrentPlayerModelHasSound("/death2.wav", QUAKE2PLAYERMODEL_SOUNDID_DEATH2);
		CheckCurrentPlayerModelHasSound("/death3.wav", QUAKE2PLAYERMODEL_SOUNDID_DEATH3);
		CheckCurrentPlayerModelHasSound("/death4.wav", QUAKE2PLAYERMODEL_SOUNDID_DEATH4);
		CheckCurrentPlayerModelHasSound("/drown1.wav", QUAKE2PLAYERMODEL_SOUNDID_DROWN1);
		CheckCurrentPlayerModelHasSound("/fall1.wav", QUAKE2PLAYERMODEL_SOUNDID_FALL1);
		CheckCurrentPlayerModelHasSound("/fall2.wav", QUAKE2PLAYERMODEL_SOUNDID_FALL2);
		CheckCurrentPlayerModelHasSound("/gurp1.wav", QUAKE2PLAYERMODEL_SOUNDID_GURP1);
		CheckCurrentPlayerModelHasSound("/gurp2.wav", QUAKE2PLAYERMODEL_SOUNDID_GURP2);
		CheckCurrentPlayerModelHasSound("/jump1.wav", QUAKE2PLAYERMODEL_SOUNDID_JUMP1);
		CheckCurrentPlayerModelHasSound("/pain25_1.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN25_1);
		CheckCurrentPlayerModelHasSound("/pain25_2.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN25_2);
		CheckCurrentPlayerModelHasSound("/pain50_1.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN50_1);
		CheckCurrentPlayerModelHasSound("/pain50_2.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN50_2);
		CheckCurrentPlayerModelHasSound("/pain75_1.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN75_1);
		CheckCurrentPlayerModelHasSound("/pain75_2.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN75_2);
		CheckCurrentPlayerModelHasSound("/pain100_1.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN100_1);
		CheckCurrentPlayerModelHasSound("/pain100_2.wav", QUAKE2PLAYERMODEL_SOUNDID_PAIN100_2);
	}
}
void CheckCurrentModelHasSounds()
{ // Check Current Model has Sounds
	// Check if Model has Sounds
	local float nHandle;
	local string strSearch;
	strSearch = strcat(PLAYERMODEL_DATAPATH_QUAKE2, g_strCurrentPlayerModelSearchName, "/jump1.wav");
	nHandle = search_begin(strSearch, true, true);
	if(nHandle != -1)
	{ // Model Has Sounds
		g_nElementDisabled[ELEMENT_USESOUNDS] = ELEMENT_DISABLED_NOT;
		g_nCurrentPlayerModelSearchHasSounds = true;
		// Free Search
		search_end(nHandle);
	}
	else
	{ // Model has no Sounds
		g_nCurrentPlayerModelSearchHasSounds = false;
		g_nElementDisabled[ELEMENT_USESOUNDS] = ELEMENT_DISABLED_NOSELECT;
	}
}
float AssignCurrentPlayerModelSearchInfoToLocalModel()
{ // Assign Current Player Model Search Info to Local Model
	local float nCnt;
	local float bFound;
		bFound = false;
	local string strLocalModelName;
	local string strSearchModelName;
		
	// Assign Base Properties
	// Assign Sex
	g_nCurrentPlayerModelSearchSex = SG_GetSexIDFromAbbreviatedSexString( cvar_string(PLAYERMODELS_CVAR_BASE_SEX) );
	// Assign Footsteps
	g_nCurrentPlayerModelSearchFootsteps = SG_GetFootstepIDFromFootstepString( cvar_string(PLAYERMODELS_CVAR_BASE_FOOTSTEPS) );
	// Assign Jump / Land
	g_nCurrentPlayerModelSearchJumpLand = SG_GetJumpLandIDFromJumpLandString( cvar_string(PLAYERMODELS_CVAR_BASE_JUMPLAND) );
		
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{ // Quake Player Model
		strLocalModelName = cvar_string(PLAYERMODELS_CVAR_BASE_MODELNAME);
		for(nCnt = 0; nCnt < (g_nNumCurrentSearchPlayerModels - FILESEARCH_BASENUMOFFSET); nCnt++)
		{ // Cycle through Models until Local is Found
			// Acquire Player Name
			strSearchModelName = search_getfilename(g_nPlayerModelSearchHandle, nCnt + FILESEARCH_BASENUMOFFSET);
			// Cull Directory Path
			strSearchModelName = substring(strSearchModelName, 19, 100);
			// Lowercase String
			strSearchModelName = strtolower(strSearchModelName);
			
			if(strSearchModelName == strLocalModelName)
			{ // Model Found!
				// Zone Name
				g_strCurrentPlayerModelSearchName = strzone(strLocalModelName);
				// Assign Current Search Number
				g_nCurrentPlayerModelSearchNum = nCnt;
				// Assign Skin
				g_nCurrentPlayerModelSearchSkin = 0;
				
				// Check Current Search is Valid
				CheckCurrentSearchIsValid();
			}
		}
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{ // Quake2 Player Model
		strLocalModelName = cvar_string(PLAYERMODELS_CVAR_BASE_MODELNAME);
		for(nCnt = 0; nCnt < (g_nNumCurrentSearchPlayerModels - FILESEARCH_BASENUMOFFSET); nCnt++)
		{ // Cycle through Models until Local is Found
			// Acquire Player Name
			strSearchModelName = search_getfilename(g_nPlayerModelSearchHandle, nCnt + FILESEARCH_BASENUMOFFSET);
			// Cull Directory Path
			strSearchModelName = substring(strSearchModelName, 20, 100);
			// Lowercase String
			strSearchModelName = strtolower(strSearchModelName);
			
			if(strSearchModelName == strLocalModelName)
			{ // Model Found!
				// Zone Name
				g_strCurrentPlayerModelSearchName = strzone(strLocalModelName);
				// Assign Current Search Number
				g_nCurrentPlayerModelSearchNum = nCnt;
				// Check Current Search is Valid
				CheckCurrentSearchIsValid();
				
				// Calculate Number of Skins
				UpdateCurrentPlayerModelSearchNumberOfSkins();
				// Calculate Number of View Weapons
				UpdateCurrentPlayerModelSearchAvailableViewWeapons();
				// Calculate Number of Sounds
				UpdateCurrentPlayerModelSearchAvailableSounds();
				
				// Assign Skin
				g_nCurrentPlayerModelSearchSkin = cvar(PLAYERMODELS_CVAR_QUAKE2_SKIN);
				
				// Validate Skin
				if(g_nCurrentPlayerModelSearchSkin > g_nCurrentPlayerModelSearchNumSkins)
					g_nCurrentPlayerModelSearchSkin = 0;
					
				// Assign Use Sounds
				CheckCurrentModelHasSounds();
				if( cvar_string(PLAYERMODELS_CVAR_QUAKE2_USESOUNDS) == "y" && g_nCurrentPlayerModelSearchHasSounds)
					g_nCurrentPlayerModelSearchUseSounds = true;
				else
					g_nCurrentPlayerModelSearchUseSounds = false;

				// Assign and Validate View Weapon
				if( !( cvar(PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON) & g_nCurrentPlayerModelSearchAvailableViewWeapons) )
					g_nCurrentPlayerModelSearchViewWeapon = QUAKE2PLAYERMODEL_WEAPONID_DEFAULT;
				else
					g_nCurrentPlayerModelSearchViewWeapon = cvar(PLAYERMODELS_CVAR_QUAKE2_VIEWWEAPON);
				// End Loop
				nCnt = g_nNumCurrentSearchPlayerModels;
				bFound = true;
			}
		}
	}
	
	return !bFound;
}
void UpdateCurrentPlayerModelSearchInfo(float bStartAtLocalModel)
{ // Update Current Player Model Search Info
	if(g_strCurrentPlayerModelSearchName != "")
	{ // String Zoned; Unzone
		strunzone(g_strCurrentPlayerModelSearchName);
		g_strCurrentPlayerModelSearchName = "";
	}
	if(g_bPlayerModelSearchActive)
	{ // Search Active
		local float bInitial;
			bInitial = true;
		if(bStartAtLocalModel)
			// Start at Local Model
			bInitial = AssignCurrentPlayerModelSearchInfoToLocalModel();
		if(bInitial)
		{ // Start at 0
			// Acquire Player Name
			g_strCurrentPlayerModelSearchName = search_getfilename(g_nPlayerModelSearchHandle, g_nCurrentPlayerModelSearchNum + FILESEARCH_BASENUMOFFSET);
			// Cull Directory Path
			if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
				g_strCurrentPlayerModelSearchName = substring(g_strCurrentPlayerModelSearchName, 19, 100);
			else
			if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
				g_strCurrentPlayerModelSearchName = substring(g_strCurrentPlayerModelSearchName, 20, 100);
					
			// Zone Name
			g_strCurrentPlayerModelSearchName = strzone(g_strCurrentPlayerModelSearchName);
			
			// Reset Skin
			g_nCurrentPlayerModelSearchSkin = 0;
			
			// Check Current Search is Valid
			CheckCurrentSearchIsValid();
			
			if(g_bCurrentPlayerModelSearchValid)
			{ // Model is Valid; Continue Parsing
				// Calculate Number of Skins
				UpdateCurrentPlayerModelSearchNumberOfSkins();
				// Calculate Number of View Weapons
				UpdateCurrentPlayerModelSearchAvailableViewWeapons();
				// Calculate Number of Sounds
				UpdateCurrentPlayerModelSearchAvailableSounds();
				
				if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
				{ // Quake Model
				}
				else
				if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
				{ // Quake2 Model
					// Reset View Weapon
					g_nCurrentPlayerModelSearchViewWeapon = QUAKE2PLAYERMODEL_WEAPONID_DEFAULT;
			
					// Calculate Number of Skins
					UpdateCurrentPlayerModelSearchNumberOfSkins();
					// Calculate Number of View Weapons
					UpdateCurrentPlayerModelSearchAvailableViewWeapons();
					
					// Check if Model has Sounds
					CheckCurrentModelHasSounds();
					// Assign Default Use Sounds Based on Has Sounds
					g_nCurrentPlayerModelSearchUseSounds = g_nCurrentPlayerModelSearchHasSounds;
				}
			}
		}
		// Update Player Model Face
		UpdateCurrentPlayerModelSearchFace();
	}
}
void BeginPlayerModelSearch()
{ // Begin Player Model Search
	local string strDataPath;
	// Search for Players
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MDL)
	{
		strDataPath = strcat(PLAYERMODEL_DATAPATH_QUAKE, "*");
		g_nPlayerModelSearchHandle = search_begin(strDataPath, true, true);
	}
	else
	if(g_nCurrentPlayerModelSearchModelType == PLAYERMODEL_MODELTYPE_MD2)
	{
		strDataPath = strcat(PLAYERMODEL_DATAPATH_QUAKE2, "*");
		g_nPlayerModelSearchHandle = search_begin(strDataPath, true, true);
	}
	
	if(g_nPlayerModelSearchHandle != -1)
	{ // Players Found
		// Acquire Number of Files
		g_nNumCurrentSearchPlayerModels = search_getsize(g_nPlayerModelSearchHandle);
		
		// Flag Active Search
		g_bPlayerModelSearchActive = true;
		
		// Reset Menu Selections
		g_nCurrentPlayerModelSearchNum = 0;
		g_nCurrentPlayerModelSearchElementSelection = 0;
		
		// Initially Update
		UpdateCurrentPlayerModelSearchInfo(true);
	}
}
void EndPlayerModelSearch()
{ // End Player Model Search
	if(g_bPlayerModelSearchActive)
	{ // Search Active; End
		g_bPlayerModelSearchActive = false;
		// Free Search
		search_end(g_nPlayerModelSearchHandle);
		
		PLAYERMODELINTERFACE_SOUND_INTERFACETOGGLE;
	}
	else
	{ // No Search Active
		print("^1WARNING ^7: Player Model Search Ended when None Active!\n");
	}
}
void DrawPlayerModelInterface()
{ // Draw Player Model Interface
	// ***********************************************
	// Draw Main Background
		local vector vBackgroundLocation;
		local vector vBackgroundSize;
		
		// Calculate Size
		vBackgroundSize_x = 450;
		vBackgroundSize_y = 205;
		
		// Calculate Location
		vBackgroundLocation_x = (g_nVideoWidth - vBackgroundSize_x) / 2;
		vBackgroundLocation_y = (g_nVideoHeight - vBackgroundSize_y) / 2;
		vBackgroundLocation_z = 0;
		
		// Draw
		drawfill(vBackgroundLocation, vBackgroundSize, '0.01 0.01 0.01', 0.5, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Header Text
		local vector vHeaderTextLocation;
		local vector vHeaderTextSize;
		local string strHeaderText;
		
		// Calculate Size
		vHeaderTextSize_x = 10;
		vHeaderTextSize_y = 10;
		
		// Calculate Location
		vHeaderTextLocation_x = vBackgroundLocation_x + (vHeaderTextSize_x * 0.8);
		vHeaderTextLocation_y = vBackgroundLocation_y + (vHeaderTextSize_y * 0.8);
		
		// Calculate Header Text
		strHeaderText = strcat(g_strCurrentPlayerModelSearchName, "; ");
		if(g_bCurrentPlayerModelSearchValid)
		{
			strHeaderText = strcat(strHeaderText, ftos(g_nCurrentPlayerModelSearchNumSkins), " Skin(s)");
			strHeaderText = strcat(strHeaderText, ", ", ftos(g_nCurrentPlayerModelSearchNumViewWeapons), " Weapon(s)");
		}
		else
			strHeaderText = strcat(strHeaderText, "INVALID MODEL");
		
		// Draw
		drawstring(vHeaderTextLocation, strHeaderText, vHeaderTextSize, '1 1 1', 1, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Header Bar
		local vector vHeaderBarLocation;
		local vector vHeaderBarSize;
		
		// Calculate Size
		vHeaderBarSize_x = vBackgroundSize_x * 0.95;
		vHeaderBarSize_y = 1.5;
		
		// Calculate Location
		vHeaderBarLocation_x = vHeaderTextLocation_x + 1.5;
		vHeaderBarLocation_y = vHeaderTextLocation_y + vHeaderTextSize_y + 3;
		
		// Draw
		// drawpic(vHeaderBarLocation, HUDIMAGE_BACKGROUND, vHeaderBarSize, '1 1 1', 1, 0);
		drawfill(vHeaderBarLocation, vHeaderBarSize, '0.8 0 0', 1, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Player Model Background
	/*
		local vector vPlayerModelBackgroundLocation;
		local vector vPlayerModelBackgroundSize;
		
		// Calculate Size
		vPlayerModelBackgroundSize_x = (vBackgroundSize_x / 3.0);
		vPlayerModelBackgroundSize_y = (vBackgroundSize_y / 1.5);
		
		// Calculate Location
		vPlayerModelBackgroundLocation_x = vBackgroundLocation_x + 25;
		vPlayerModelBackgroundLocation_y = vHeaderBarLocation_y + 9;
		
		// Draw
		drawfill(vPlayerModelBackgroundLocation, vPlayerModelBackgroundSize, '0.4 0 0', 0.2, 0);
	*/
	// ***********************************************
	
	// ***********************************************
	// Draw Player Face
		local vector vPlayerFaceLocation;
		local vector vPlayerFaceSize;
		
		// Calculate Size
		vPlayerFaceSize = g_vIconSize_BottomGeneric * 1.5;
		
		// Calculate Location
		/*
		vPlayerFaceLocation_x = vPlayerModelBackgroundLocation_x + vPlayerModelBackgroundSize_x + 5;
		vPlayerFaceLocation_y = vPlayerModelBackgroundLocation_y;
		*/
		vPlayerFaceLocation_x = vBackgroundLocation_x + 25;
		vPlayerFaceLocation_y = vHeaderBarLocation_y + 9;
		
		// Draw
		drawpic(vPlayerFaceLocation, g_strCurrentPlayerModelSearchFace, vPlayerFaceSize, '1 1 1', 1, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Element Bar
		local vector vElementBarLocation;
		local vector vElementBarSize;
		
		// Calculate Location
		vElementBarLocation_x = vPlayerFaceLocation_x + vPlayerFaceSize_x + 15;
		vElementBarLocation_y = vHeaderBarLocation_y + 9;
		
		// Calculate Size
		vElementBarSize_x = 1.5;
		vElementBarSize_y = vBackgroundSize_y * 0.75;
		
		// Draw
		drawfill(vElementBarLocation, vElementBarSize, '0.8 0 0', 1, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Elements
		local vector vElementLocation;
		local vector vElementSize;
		local vector vElementColor;
		local string strElement;
		local float fElementYOffset;
		local float nElementCnt;
			nElementCnt = 0;
		
		// Calculate Size
		vElementSize_x = 9;
		vElementSize_y = 9;
		
		// Calculate Location
		vElementLocation_x = vElementBarLocation_x + 15;
		fElementYOffset = fElementYOffset + (vElementSize_y);
		vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
		
		// Draw
		// Model Type
		if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt++)
			vElementColor = '0 1 0';
		else
			vElementColor = '1 1 1';
		strElement = strcat("Model Type      - ", SG_GetModelTypeStringFromModelTypeID(g_nCurrentPlayerModelSearchModelType) );
		drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		
		// Model
		fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
		vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
		if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt++)
			vElementColor = '0 1 0';
		else
			vElementColor = '1 1 1';
		strElement = strcat("Model           - ", g_strCurrentPlayerModelSearchName);
		drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		
		// Draw Element Bar
		// Calculate Size
		vElementBarSize_x = 9 * 25;
		vElementBarSize_y = 0.3;
		
		// Calculate Location
		vElementBarLocation_x = vElementLocation_x;
		vElementBarLocation_y = vElementLocation_y + (vElementSize_y * 1.25);
		
		// Draw
		drawfill(vElementBarLocation, vElementBarSize, '0.8 0 0', 1, 0);
		
		// Increment Location Again
		fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
		vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
		
		// ************************************************************
		// BEGIN DRAW MODEL SPECIFIC ELEMENTS
		if(g_nElementDisabled[ELEMENT_SKIN] != ELEMENT_DISABLED_NODRAW)
		{
			// Skin
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_SKIN] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			strElement = strcat("Skin            - ", ftos(g_nCurrentPlayerModelSearchSkin + 1), "(", ftos(g_nCurrentPlayerModelSearchNumSkins), ")");
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
			nElementCnt++;
		}
		
		if(g_nElementDisabled[ELEMENT_VIEWWEAPON] != ELEMENT_DISABLED_NODRAW)
		{
			// View Weapon
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_VIEWWEAPON] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			strElement = strcat("View Weapon     - ", SG_GetQuake2WeaponStringFromWeaponID(g_nCurrentPlayerModelSearchViewWeapon) );
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
			nElementCnt++;
		}
		if(g_nElementDisabled[ELEMENT_USESOUNDS] != ELEMENT_DISABLED_NODRAW)
		{
			// Use Sounds
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if(g_nElementDisabled[ELEMENT_USESOUNDS] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			nElementCnt++;
			strElement = "Use Sounds      - ";
			if(!g_nCurrentPlayerModelSearchHasSounds)
				strElement = strcat(strElement, "N/A");
			else
			if(g_nCurrentPlayerModelSearchUseSounds)
				strElement = strcat(strElement, "Yes (", ftos(g_nCurrentPlayerModelSearchNumSounds), " of ", ftos(QUAKE2PLAYERMODEL_SOUNDS_EXPECTEDNUMBER), ")");
			else
				strElement = strcat(strElement, "No");
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		}
		
		// END DRAW MODEL SPECIFIC ELEMENTS
		// ************************************************************
		
		// Draw Element Bar
		// Calculate Location
		vElementBarLocation_y = vElementLocation_y + (vElementSize_y * 1.25);
		
		// Draw
		drawfill(vElementBarLocation, vElementBarSize, '0.8 0 0', 1, 0);
		
		// Increment Location Again
		fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
		vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
		
		// Sex
		if(g_nElementDisabled[ELEMENT_SEX] != ELEMENT_DISABLED_NODRAW)
		{
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_SEX] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			nElementCnt++;
			strElement = strcat("Sex             - ", SG_GetSexStringFromSexID(g_nCurrentPlayerModelSearchSex));
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		}
		
		// Footsteps
		if(g_nElementDisabled[ELEMENT_FOOTSTEPS] != ELEMENT_DISABLED_NODRAW)
		{
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_FOOTSTEPS] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			nElementCnt++;
			strElement = strcat("Footsteps       - ", SG_GetFootstepStringFromFootstepID(g_nCurrentPlayerModelSearchFootsteps));
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		}
		// Jump / Land
		if(g_nElementDisabled[ELEMENT_JUMPLAND] != ELEMENT_DISABLED_NODRAW)
		{
			fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_JUMPLAND] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			nElementCnt++;
			strElement = strcat("Jump / Land     - ", SG_GetJumpLandStringFromJumpLandID(g_nCurrentPlayerModelSearchJumpLand));
			drawstring(vElementLocation, strElement, vElementSize, vElementColor, 1, 0);
		}
		
		// Accept
		if(g_nElementDisabled[ELEMENT_ACCEPT] != ELEMENT_DISABLED_NODRAW)
		{
			fElementYOffset = fElementYOffset + (vElementSize_y * 2.0);
			vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
			if( g_nElementDisabled[ELEMENT_ACCEPT] == ELEMENT_DISABLED_NOSELECT)
				vElementColor = '0.3 0.3 0.3';
			else
			if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt)
				vElementColor = '0 1 0';
			else
				vElementColor = '1 1 1';
			nElementCnt++;
			drawstring(vElementLocation, "Accept (enter)", vElementSize, vElementColor, 1, 0);
		}
		// Cancel
		fElementYOffset = fElementYOffset + (vElementSize_y * 1.5);
		vElementLocation_y = vHeaderBarLocation_y + fElementYOffset;
		if(g_nCurrentPlayerModelSearchElementSelection == nElementCnt++)
			vElementColor = '0 1 0';
		else
			vElementColor = '1 1 1';
		drawstring(vElementLocation, "Cancel (esc)", vElementSize, vElementColor, 1, 0);
	// ***********************************************
	
	// ***********************************************
	// Draw Player Model
	/*
		// Clear Current Scene
		R_ClearScene();
		
		// Purge Post-Buffer
		R_SetView(VF_CLEARSCREEN, FALSE);
		// Remove Perspective Render
		R_SetView(VF_PERSPECTIVE, FALSE);
		// Purge World Drawing
		R_SetView(VF_DRAWWORLD, FALSE);
		
		// Add Player Model Entity
		if(!g_enPlayerModel)
		{
			g_enPlayerModel = spawn();
			g_enPlayerModel.model = "data/players/";
		}
		R_AddEntity(g_enPlayerModel);
		
		// Setup Viewport
		R_SetView(VF_VIEWPORT, vPlayerFaceLocation, '150 150 0');
		
		// Render Viewport
		R_RenderScene();
	*/
	// ***********************************************
}
void ShiftCurrentElement(float bForward)
{ // Shift Current Element
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_MODELTYPE)
	{ // Shift Model Type
		if(bForward)
		{
			g_nCurrentPlayerModelSearchModelType = g_nCurrentPlayerModelSearchModelType + 1;
			if(g_nCurrentPlayerModelSearchModelType > PLAYERMODEL_MODELTYPE_MAX)
				g_nCurrentPlayerModelSearchModelType = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchModelType = g_nCurrentPlayerModelSearchModelType - 1;
			if(g_nCurrentPlayerModelSearchModelType < 0)
				g_nCurrentPlayerModelSearchModelType = PLAYERMODEL_MODELTYPE_MAX;
		}
		
		// Save Immediately
		// localcmd("seta ", PLAYERMODELS_CVAR_BASE_MODELTYPE, " \"", ftos(g_nCurrentPlayerModelSearchModelType), "\"\n");
		
		EndPlayerModelSearch();
		BeginPlayerModelSearch();
		UpdateCurrentPlayerModelSearchInfo(false);
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_MODEL)
	{ // Shift Model
		if(bForward)
		{
			g_nCurrentPlayerModelSearchNum = g_nCurrentPlayerModelSearchNum + 1;
			if(g_nCurrentPlayerModelSearchNum > (g_nNumCurrentSearchPlayerModels - (FILESEARCH_BASENUMOFFSET + 1) ) )
				g_nCurrentPlayerModelSearchNum = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchNum = g_nCurrentPlayerModelSearchNum - 1;
			if(g_nCurrentPlayerModelSearchNum < 0)
				g_nCurrentPlayerModelSearchNum = g_nNumCurrentSearchPlayerModels - (FILESEARCH_BASENUMOFFSET + 1);
		}
		UpdateCurrentPlayerModelSearchInfo(false);
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_SKIN)
	{ // Shift Skin
		if(bForward)
		{
			g_nCurrentPlayerModelSearchSkin = g_nCurrentPlayerModelSearchSkin + 1;
			if(g_nCurrentPlayerModelSearchSkin > (g_nCurrentPlayerModelSearchNumSkins - 1) )
				g_nCurrentPlayerModelSearchSkin = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchSkin = g_nCurrentPlayerModelSearchSkin - 1;
			if(g_nCurrentPlayerModelSearchSkin < 0)
				g_nCurrentPlayerModelSearchSkin = (g_nCurrentPlayerModelSearchNumSkins - 1);
		}
		UpdateCurrentPlayerModelSearchFace();
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_SEX)
	{ // Shift Sex
		if(bForward)
		{
			g_nCurrentPlayerModelSearchSex = g_nCurrentPlayerModelSearchSex + 1;
			if(g_nCurrentPlayerModelSearchSex > SEX_MAX)
				g_nCurrentPlayerModelSearchSex = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchSex = g_nCurrentPlayerModelSearchSex - 1;
			if(g_nCurrentPlayerModelSearchSex < 0)
				g_nCurrentPlayerModelSearchSex = SEX_MAX;
		}
		
		// Save Immediately
		// localcmd("seta ", PLAYERMODELS_CVAR_BASE_SEX, " \"", SG_GetAbbreviatedSexStringFromSexID(g_nCurrentPlayerModelSearchSex), "\"\n");
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_FOOTSTEPS)
	{ // Shift Footsteps
		if(bForward)
		{
			g_nCurrentPlayerModelSearchFootsteps = g_nCurrentPlayerModelSearchFootsteps + 1;
			if(g_nCurrentPlayerModelSearchFootsteps > PLAYERMODEL_FOOTSTEPS_MAX)
				g_nCurrentPlayerModelSearchFootsteps = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchFootsteps = g_nCurrentPlayerModelSearchFootsteps - 1;
			if(g_nCurrentPlayerModelSearchFootsteps < 0)
				g_nCurrentPlayerModelSearchFootsteps = PLAYERMODEL_FOOTSTEPS_MAX;
		}
		
		// Save Immediately
		// localcmd("seta ", PLAYERMODELS_CVAR_BASE_FOOTSTEPS, " \"", SG_GetFootstepStringFromFootstepID(g_nCurrentPlayerModelSearchFootsteps), "\"\n");
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_JUMPLAND)
	{ // Shift Jump / Land
		if(bForward)
		{
			g_nCurrentPlayerModelSearchJumpLand = g_nCurrentPlayerModelSearchJumpLand + 1;
			if(g_nCurrentPlayerModelSearchJumpLand > PLAYERMODEL_JUMPLAND_MAX)
				g_nCurrentPlayerModelSearchJumpLand = 0;
		}
		else
		{
			g_nCurrentPlayerModelSearchJumpLand = g_nCurrentPlayerModelSearchJumpLand - 1;
			if(g_nCurrentPlayerModelSearchJumpLand < 0)
				g_nCurrentPlayerModelSearchJumpLand = PLAYERMODEL_JUMPLAND_MAX;
		}
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_VIEWWEAPON)
	{ // Shift View Weapon
		if(g_nCurrentPlayerModelSearchNumViewWeapons)
		{ // At least 1 weapon exists
			if(bForward)
			{
				g_nCurrentPlayerModelSearchViewWeapon = g_nCurrentPlayerModelSearchViewWeapon * 2;
				while( !(g_nCurrentPlayerModelSearchAvailableViewWeapons & g_nCurrentPlayerModelSearchViewWeapon) )
				{ // Weapon Not Available
					if(g_nCurrentPlayerModelSearchViewWeapon >= QUAKE2PLAYERMODEL_WEAPONID_MAX)
					{ // Max Weapon Reached; Return to Default
						g_nCurrentPlayerModelSearchViewWeapon = QUAKE2PLAYERMODEL_WEAPONID_DEFAULT;
					}
					else
						// Skip to Next Weapon
						g_nCurrentPlayerModelSearchViewWeapon = g_nCurrentPlayerModelSearchViewWeapon * 2;
				}
			}
			else
			{
				g_nCurrentPlayerModelSearchViewWeapon = g_nCurrentPlayerModelSearchViewWeapon / 2;
				while( !(g_nCurrentPlayerModelSearchAvailableViewWeapons & g_nCurrentPlayerModelSearchViewWeapon) )
				{ // Weapon Not Available
					if(g_nCurrentPlayerModelSearchViewWeapon < 1)
					{ // Minimum Weapon Reached; Return to Max
						g_nCurrentPlayerModelSearchViewWeapon = QUAKE2PLAYERMODEL_WEAPONID_BFG;
					}
					else
						// Skip to Next Weapon
						g_nCurrentPlayerModelSearchViewWeapon = g_nCurrentPlayerModelSearchViewWeapon / 2;
				}
			}
		}
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_USESOUNDS)
	{ // Shift Use Sounds
		g_nCurrentPlayerModelSearchUseSounds = !g_nCurrentPlayerModelSearchUseSounds;
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_ACCEPT)
	{ // Accept Model
		// Save Model Information Locally First
		RegisterPlayerModel(g_nCurrentPlayerModelSearchModelType,
		g_strCurrentPlayerModelSearchName,
		g_nCurrentPlayerModelSearchSex,
		g_nCurrentPlayerModelSearchFootsteps,
		g_nCurrentPlayerModelSearchJumpLand,
		g_nCurrentPlayerModelSearchUseSounds,
		g_nCurrentPlayerModelSearchSkin,
		g_nCurrentPlayerModelSearchViewWeapon
		);
		
		// Execute Model Sync Command
		SyncPlayerModel();
		
		EndPlayerModelSearch();
	}
	else
	if(g_nCurrentPlayerModelSearchElementSelection == ELEMENT_CANCEL)
	{ // Cancel
		EndPlayerModelSearch();
	}
	
	PLAYERMODELINTERFACE_SOUND_ELEMENTSHIFT;
}
void ShiftActiveElement(float bForward)
{ // Shift Active Element
	if(bForward)
	{
		g_nCurrentPlayerModelSearchElementSelection = g_nCurrentPlayerModelSearchElementSelection + 1;
		if(g_nCurrentPlayerModelSearchElementSelection > ELEMENT_MAX)
			g_nCurrentPlayerModelSearchElementSelection = 0;
			
		while( g_nElementDisabled[g_nCurrentPlayerModelSearchElementSelection] )
			g_nCurrentPlayerModelSearchElementSelection = g_nCurrentPlayerModelSearchElementSelection + 1;
	}
	else
	{
		g_nCurrentPlayerModelSearchElementSelection = g_nCurrentPlayerModelSearchElementSelection - 1;
		if(g_nCurrentPlayerModelSearchElementSelection < 0)
			g_nCurrentPlayerModelSearchElementSelection = ELEMENT_MAX;
			
		while( g_nElementDisabled[g_nCurrentPlayerModelSearchElementSelection] )
			g_nCurrentPlayerModelSearchElementSelection = g_nCurrentPlayerModelSearchElementSelection - 1;
	}
	
	PLAYERMODELINTERFACE_SOUND_NEWELEMENT;
}
float CheckPlayerModelInterfaceKeyEvent(float nKey)
{ // Check Player Model Interface Key Event
	// NOTE : Returns true if key event was for interface.
	local float bReturn;
		bReturn = true;
	if(g_bPlayerModelSearchActive)
	{ // Player Model Search Active
		if(nKey == PLAYERMODELINTERFACE_KEY_INCREMENTELEMENT)
		{ // Increment Element
			ShiftCurrentElement(true);
		}
		else
		if(nKey == PLAYERMODELINTERFACE_KEY_DECREMENTELEMENT)
		{ // Decrement Element
			ShiftCurrentElement(false);
		}
		else
		if(nKey == PLAYERMODELINTERFACE_KEY_NEXTELEMENT)
		{ // Next Element
			ShiftActiveElement(true);
		}
		else
		if(nKey == PLAYERMODELINTERFACE_KEY_PREVIOUSELEMENT)
		{ // Previous Element
			ShiftActiveElement(false);
		}
		else
		if(nKey == PLAYERMODELINTERFACE_KEY_ACCEPT1
			|| nKey == PLAYERMODELINTERFACE_KEY_ACCEPT2)
		{ // Accept
			if(g_bCurrentPlayerModelSearchValid)
			{ // Valid Model
				// Force Element Selection
				g_nCurrentPlayerModelSearchElementSelection = ELEMENT_ACCEPT;
				// Apply Element Shift
				ShiftCurrentElement(true);
			}
		}
		else
		if(nKey == PLAYERMODELINTERFACE_KEY_CANCEL)
		{ // Cancel
			// Force Element Selection
			g_nCurrentPlayerModelSearchElementSelection = ELEMENT_CANCEL;
			// Apply Element Shift
			ShiftCurrentElement(true);
		}
		else
			bReturn = false;
	}
	else
		bReturn = false;
	
	return bReturn;
}
void CheckDisplayPlayerModelInterface()
{ // Check Display Player Model Interface
	if(!g_bPlayerModelSearchActive)
	{ // Search not Active; Begin
		PLAYERMODELINTERFACE_SOUND_INTERFACETOGGLE;
		
		// Attempt to Identify Model Type
		g_nCurrentPlayerModelSearchModelType = cvar(PLAYERMODELS_CVAR_BASE_MODELTYPE);
		// Search for Players
		BeginPlayerModelSearch();
	}
}