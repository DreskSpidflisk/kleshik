// DRESK
// Player Models - Quake2

// Definitions
#define QUAKE2PLAYERMODEL_BASEMODELNAME								"/tris.md2"

#define QUAKE2PLAYERMODEL_GETPLAYERMODELFILE(a)						(strcat(PLAYERMODEL_DATAPATH_QUAKE2, a, QUAKE2PLAYERMODEL_BASEMODELNAME))
#define QUAKE2PLAYERMODEL_GETWEAPONMODELFILE(a,b)					(strcat(PLAYERMODEL_DATAPATH_QUAKE2, a, b))
#define QUAKE2PLAYERMODEL_GETSOUNDFILE(a,b)							(strcat(PLAYERMODEL_DATAPATH_QUAKE2, a, b))

// Fields
// entity	g_enQuake2PlayerModelTempEntity;
.entity	enQuake2PlayerModel_WeaponEntity;

// Functions
void CheckAndPrecacheQuake2PlayerModelWeaponModel(string strWeaponModelPath)
{ // Check and Precache Weapon Model
	local float nHandle;
	nHandle = search_begin(strWeaponModelPath, TRUE, TRUE);
	if(nHandle != -1)
	{ // Valid Model
		precache_model(strWeaponModelPath);
		// End Search
		search_end(nHandle);
	}
}
void CheckAndPrecacheQuake2PlayerModelSound(string strSoundPath)
{ // Check and Precache Weapon Model
	local float nHandle;
	nHandle = search_begin(strSoundPath, TRUE, TRUE);
	if(nHandle != -1)
	{ // Valid Model
		precache_sound(strSoundPath);
		// End Search
		search_end(nHandle);
	}
}
void PrecacheQuake2PlayerModelAssets(string strCurrentPlayerModelSearchName)
{ // Precache Individual Quake2 Player Model Assets
	// Check for Valid Model
	local float nHandle;
	local string strModelFileName;
	strModelFileName = strcat(strCurrentPlayerModelSearchName, QUAKE2PLAYERMODEL_BASEMODELNAME);
	nHandle = search_begin(strModelFileName, TRUE, TRUE);
	if(nHandle != -1)
	{ // Valid Model
		// End Search
		search_end(nHandle);
		// Precache Model
		precache_model(strModelFileName);
		// Precache Sounds
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/jump1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain100_1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain100_2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain75_1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain75_2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain50_1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain50_2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain25_1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/pain25_2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/gurp1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/gurp2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/fall2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/fall1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/death1.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/death2.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/death3.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/death4.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/death4.wav") );
		CheckAndPrecacheQuake2PlayerModelSound( strcat(strCurrentPlayerModelSearchName, "/drown1.wav") );
		// Precache Weapons
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/weapon.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_blaster.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_shotgun.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_sshotgun.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_machinegun.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_chaingun.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_glauncher.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_rlauncher.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_hyperblaster.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_railgun.md2") );
		CheckAndPrecacheQuake2PlayerModelWeaponModel(strcat(strCurrentPlayerModelSearchName, "/w_bfg.md2") );
	}
}
void PrecacheAllQuake2PlayerModels()
{ // Precache All Quake2 Player Models
	local string strDataPath;
	local string strCurrentPlayerModelSearchName;
	local float nPlayerModelSearchHandle;
	local float nNumCurrentSearchPlayerModels;
	local float nCnt;
	
	bprint("^2PRECACHING ALL AVAILABLE QUAKE2 PLAYER MODELS...\n");
	
	strDataPath = strcat(PLAYERMODEL_DATAPATH_QUAKE2, "*");
	nPlayerModelSearchHandle = search_begin(strDataPath, TRUE, TRUE);
	
	if(nPlayerModelSearchHandle != -1)
	{ // Players Found
		// Acquire Number of Files
		nNumCurrentSearchPlayerModels = search_getsize(nPlayerModelSearchHandle);
		// Iterate through Files
		for(nCnt = 0; nCnt < nNumCurrentSearchPlayerModels; nCnt++)
		{
			// Acquire Model Name
			strCurrentPlayerModelSearchName = search_getfilename(nPlayerModelSearchHandle, nCnt);
			// Precache Assets
			PrecacheQuake2PlayerModelAssets(strCurrentPlayerModelSearchName);
		}
		// End Search
		search_end(nPlayerModelSearchHandle);
	}
	
	bprint("^2QUAKE2 PLAYER MODEL PRECACHE COMPLETE!\n");
}
void Quake2PlayerModelCleanUp()
{ // Quake2 Player Model Clean Up
	// Remove Weapon Entity
	CheckAndRemoveEntity(self, enQuake2PlayerModel_WeaponEntity);
}
void Quake2WeaponEntity_SetIsDrawing(entity enClient, float bIsDrawing)
{ // Quake2 Weapon Entity - Set Is Drawing
	local entity enWeapon;
		enWeapon = enClient.enQuake2PlayerModel_WeaponEntity;
	if(enWeapon)
	{ // Client has Weapon Entity
		if(bIsDrawing)
			// Enable Drawing
			enWeapon.effects = enWeapon.effects - (enWeapon.effects & EF_NODRAW);
		else
			// Disable Drawing
			enWeapon.effects = enWeapon.effects | EF_NODRAW;
	}
}
void PrepareQuake2WeaponEntity(entity enClient, string strModelName, float nWeaponID)
{ // Prepare Quake2 Weapon Entity
	local entity enWeapon;
	enWeapon = enClient.enQuake2PlayerModel_WeaponEntity;
	
	if(!enWeapon)
		// Spawn Weapon Entity
		enWeapon = spawn();
		
	local string strModelFileName;
		strModelFileName = QUAKE2PLAYERMODEL_GETWEAPONMODELFILE(strModelName, SG_GetQuake2WeaponModelNameFromID(nWeaponID) );
		strModelFileName = strzone(strModelFileName);
		
	// Precache Model
	precache_model(strModelFileName);
	// Assign Model
	setmodel(enWeapon, strModelFileName);
	// Assign Owner
	enWeapon.owner = enClient;
	// Attach Model to Client
	setattachment(enWeapon, enClient, "");
	
	// Assign Weapon Entity to Client
	enClient.enQuake2PlayerModel_WeaponEntity = enWeapon;
}
void PrepareQuake2PlayerModelSounds(entity enClient, string strModelName)
{ // Prepare Quake2 Player Model Sounds
	// Unzone Sounds
	UnzonePlayerModelSounds(enClient);
	// Jump
	enClient.(strPlayerSounds[PLAYERSOUND_JUMP]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/jump1.wav") );
	
	// Pain Sounds
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN1]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain100_1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN2]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain100_2.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN3]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain75_1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN4]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain75_2.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN5]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain50_1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN6]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain50_2.wav") );
	
	enClient.(strPlayerSounds[PLAYERSOUND_AXPAIN]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain25_1.wav") );

	enClient.(strPlayerSounds[PLAYERSOUND_LAVABURN1]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain25_1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_LAVABURN2]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/pain25_2.wav") );
	
	enClient.(strPlayerSounds[PLAYERSOUND_DROWN1]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/gurp1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_DROWN2]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/gurp2.wav") );
	
	// NOTE: Gasp sounds are left blank.
	enClient.(strPlayerSounds[PLAYERSOUND_GASP1]) = strzone("");
	enClient.(strPlayerSounds[PLAYERSOUND_GASP2]) = strzone("");
	
	enClient.(strPlayerSounds[PLAYERSOUND_LANDLIGHT]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/fall2.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_LANDHEAVY]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/fall1.wav") );
	
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH1]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/death1.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH2]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/death2.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH3]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/death3.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH4]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/death4.wav") );
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH5]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/death4.wav") );
	
	enClient.(strPlayerSounds[PLAYERSOUND_DROWNDEATH]) = strzone( QUAKE2PLAYERMODEL_GETSOUNDFILE(strModelName, "/drown1.wav") );
	
	// Precache Sounds
	PrecachePlayerModelSounds(enClient);
}
float PrepareQuake2PlayerModel(entity enClient, string strModelName, float nWeaponID)
{ // Prepare Quake2 Player Model
	/*
	if(!g_enQuake2PlayerModelTempEntity)
	{ // Spawn Temp Entity
		g_enQuake2PlayerModelTempEntity = spawn();
		g_enQuake2PlayerModelTempEntity.solid = SOLID_NOT;
		g_enQuake2PlayerModelTempEntity.effects = EF_NODRAW;
	}
	*/
	local string strModelFileName;
		strModelFileName = QUAKE2PLAYERMODEL_GETPLAYERMODELFILE(strModelName);
		strModelFileName = strzone(strModelFileName);
	// Precache Model
	precache_model(strModelFileName);
	
	// Acquire Player Model String
	enClient.strCustomPlayerModel = strModelFileName;
	
	// Prepare Weapon Entity
	PrepareQuake2WeaponEntity(enClient, strModelName, nWeaponID);
	
	if(enClient.bPlayerModelUsingCustomSounds)
		// Prepare Sounds
		PrepareQuake2PlayerModelSounds(enClient, strModelName);
	else
		PrepareQuakePlayerModelSounds(enClient);
	
	return TRUE;
}
void SetPlayerModel_Quake2(entity enClient, string strModelName, string strUseSounds, string strSkinID, string strWeaponID, float bBroadcastChange)
{ // Set Player Model - Quake2
	if(strModelName == "$*")
	{ // Blank Model; Print Usage
		local string strMessage;
		strMessage = "Usage : SetPlayerModel_Quake2 ^2playermodelname sex(m/f/r/o) footsteps(0-*) usesounds(y/n) skinID(0-*) weaponID(0-11)^7\n";
		
		// Report Message
		sprint(enClient, strMessage);
	}
	else
	{
		// Calculate Use Sounds
		if(strUseSounds == "y")
			enClient.bPlayerModelUsingCustomSounds = TRUE;
		else
			enClient.bPlayerModelUsingCustomSounds = FALSE;
		local float nSkinID;
		// Calculate Skin ID
		if(strSkinID == "$*")
			// No Skin ID Provided
			nSkinID = 0;
		else
			nSkinID = stof(strSkinID);
		
		// CleanUp Current Player Model
		if(enClient.fpPlayerModelCleanUp)
		{
			local entity enOldSelf;
			enOldSelf = self;
			self = enClient;
			self.fpPlayerModelCleanUp();
			self.fpPlayerModelCleanUp = __NULL__;
			self = enOldSelf;
		}
		// Prepare Player Model
		PrepareQuake2PlayerModel(enClient, strModelName, stof(strWeaponID) );
		// Assign Skin
		enClient.skin = nSkinID;
			
		// Assign CleanUp Function
		enClient.fpPlayerModelCleanUp = Quake2PlayerModelCleanUp;
		
		// Broadcast Player Model Change
		if(bBroadcastChange)
			BroadcastClientPlayerModelChange(enClient, strModelName);
		
		// Invoke Check
		CheckPlayerModelUpdate(enClient);
	}
}