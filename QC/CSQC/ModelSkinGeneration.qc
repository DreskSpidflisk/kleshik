// DRESK
// Model Skin Generation

// Definitions
#define QUAKE2PLAYERMODEL_BASEPATH									"players/quake2/"

// Fields

// Functions
void GenerateQuake2SkinFilesForModel(string strModelName)
{ // Generate Quake2 Skin Files for Model
	local string strSkinName;
	local string strSkinFilename;
	local string strModelPath;
	local string strWrite;
	local float nHandle;
	local float nFileHandle;
	local float nLength;
	local float nNumFiles;
	local float nNumFilesWritten;
	local float nCnt;
	
	// Print Header
	print("^2Quake2 Skin File Generation - ^1", strModelName, "\n");
	
	// Generate Model Path
	strModelPath = strcat(QUAKE2PLAYERMODEL_BASEPATH, strModelName, "/");
	
	// Begin Search for Quake2 Head Files
	local string strSearch;
		strSearch = strcat("data/", strModelPath, "*_i.pcx");
		
	// Search for Files
	nHandle = search_begin(strSearch, true, true);
	
	if(nHandle != -1)
	{ // Valid Handle
		// Acquire Number of Files
		nNumFiles = search_getsize(nHandle);
		
		// Generate Skin Files
		for(nCnt = 0; nCnt < nNumFiles; nCnt++)
		{
			// Cull _i.pcx
			nLength = strlen( search_getfilename(nHandle, nCnt) );
			strSkinName = substring( search_getfilename(nHandle, nCnt), 0, nLength - 6);
			
			// Prepare Skin Filename
			strSkinFilename = strcat(strModelPath, "tris.md2_", ftos(nCnt), ".skin");
			
			// Open File
			nFileHandle = fopen(strSkinFilename, FILE_WRITE);
			
			if(nFileHandle >= 0)
			{ // File Opened Successfully
				// Write Skin Line
				print("  Writing Skin File : ^2", strSkinFilename, "\n");
				strWrite = strcat("replace \"default\" \"", strSkinName, "\"");
				fputs(nFileHandle, strWrite);
				
				// Close File
				fclose(nFileHandle);
				
				// Increment Files Written
				nNumFilesWritten = nNumFilesWritten + 1;
			}
		}
		// Free Search
		search_end(nHandle);
		
		// Write Weapon Skin
		strSkinFilename = strcat(strModelPath, "weapon.md2_0.skin");
		// Open File
		nFileHandle = fopen(strSkinFilename, FILE_WRITE);
		
		if(nFileHandle >= 0)
		{ // File Opened Successfully
			// Write Skin Line
			strSkinName = strcat("data/", strModelPath, "weapon");
			print("  Writing Skin File : ^2", strSkinFilename, "\n");
			strWrite = strcat("replace \"default\" \"", strSkinName, "\"");
			fputs(nFileHandle, strWrite);
			
			// Close File
			fclose(nFileHandle);
			
			// Increment Files Written
			nNumFilesWritten = nNumFilesWritten + 1;
		}
		
		// Generate Skins for View Weapons
		strSearch = strcat("data/", strModelPath, "w_*.md2");
		
		// Search for Files
		nHandle = search_begin(strSearch, true, true);
		
		if(nHandle != -1)
		{ // Valid Handle
			// Acquire Number of Files
			nNumFiles = search_getsize(nHandle);
		
			// Generate Viewable Weapon Skin Files
			for(nCnt = 0; nCnt < nNumFiles; nCnt++)
			{
				// Cull .md2
				nLength = strlen( search_getfilename(nHandle, nCnt) );
				strSkinName = substring( search_getfilename(nHandle, nCnt), 0, nLength - 4);
				
				// Prepare Skin Filename
				strSkinFilename = strcat( search_getfilename(nHandle, nCnt), "_0.skin");
				// Cull Initial data/
				strSkinFilename = substring(strSkinFilename, 5, 500);
				
				// Open File
				nFileHandle = fopen(strSkinFilename, FILE_WRITE);
				
				if(nFileHandle >= 0)
				{ // File Opened Successfully
					// Check for Local PCX Texture
					local float nPCXFile;
					local string strPCXTexture;
						strPCXTexture = strcat(strSkinName, ".pcx");
					nPCXFile = fopen(strPCXTexture, FILE_READ);
					
					if(nPCXFile < 0)
					{ // PCX File does NOT Exist; Try Using id's default file
						// Cull Down to Weapon Name
						local string strWeaponName;
							strWeaponName = substring(strSkinName, 21 + strlen(strModelName), 100);
						strSkinName = strcat("data/players/Q2WeapTextures/", strWeaponName);
					}
					else
						// Close PCX File
						fclose(nPCXFile);
						
					// Write Skin Line
					print("  Writing Weapon Skin File : ^2", strSkinFilename, "\n");
					strWrite = strcat("replace \"default\" \"", strSkinName, "\"");
					fputs(nFileHandle, strWrite);
					
					// Close File
					fclose(nFileHandle);
					
					// Increment Files Written
					nNumFilesWritten = nNumFilesWritten + 1;
				}
			}
			// Free Search
			search_end(nHandle);
		}
		else
			// Report Warning
			print("Model '^2", strModelName, "^7' Has no View Weapons\n");
		
		// Report Files Written
		print("Number of Skin Files Written : ^2", ftos(nNumFilesWritten), "\n");
	}
	else
	{ // Report Failure
		print("^1ERROR^7 : No Files Found in Search ^2", strSearch, "^7!\n");
	}
}
void GenerateQuake2SkinFilesForAllModels()
{ // Generate Quake2 Skin Files for All Models
	local float nHandle;
	local float nNumFiles;
	local string strPlayerName;
	local float nCnt;
	
	// Search for Players
	nHandle = search_begin("data/players/quake2/*", true, true);
	
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
			
			// Zone Name
			strPlayerName = strzone(strPlayerName);
			
			if(strPlayerName != "." && strPlayerName != ".." && strPlayerName != ".svn")
				// Valid Player Name
				GenerateQuake2SkinFilesForModel(strPlayerName);
			
			// Unzone Name
			strunzone(strPlayerName);
		}
		
		// Free Search
		search_end(nHandle);
	}
	else
	{ // Report Failure
		print("^1ERROR^7 : No Players Found in Search ^2", "data/players/quake2", "^7!\n");
	}
}