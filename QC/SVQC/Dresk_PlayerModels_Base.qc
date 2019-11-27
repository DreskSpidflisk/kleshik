// DRESK
// Player Models - Base

// Definitions

// Default Quake Player Models
#define PLAYERMODEL_QUAKE_NORMAL					"progs/player.mdl"
#define PLAYERMODEL_QUAKE_HAMMER					"progs/playham.mdl"
#define PLAYERMODEL_QUAKE_EYES						"progs/eyes.mdl"

// Crouching
#define PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_NONE				0
#define PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_AESTHETIC			1
#define PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY			2

// Client Commands / CVars
#define PLAYERMODEL_CLIENTCVAR_PLAYERMODELSTRING	"klplrstr"

// Models
#define PLAYERMODEL_GENERICGIBBEDHEAD				"data/players/GenericGibbedHead.md3"
#define PLAYERMODEL_GENERICROBOTHEAD				"data/players/GenericRobotHead.md3"

// Sounds
#define GETPLAYERMODELSOUND(a,b)					(a.(strPlayerSounds[b]))

// Sound Types
#define PLAYERSOUND_JUMP							0

#define PLAYERSOUND_PAIN1							1
#define PLAYERSOUND_PAIN2							2
#define PLAYERSOUND_PAIN3							3
#define PLAYERSOUND_PAIN4							4
#define PLAYERSOUND_PAIN5							5
#define PLAYERSOUND_PAIN6							6

#define PLAYERSOUND_AXPAIN							7

#define PLAYERSOUND_LAVABURN1						8
#define PLAYERSOUND_LAVABURN2						9

#define PLAYERSOUND_DROWN1							10
#define PLAYERSOUND_DROWN2							11

#define PLAYERSOUND_GASP1							12
#define PLAYERSOUND_GASP2							13

#define PLAYERSOUND_LANDLIGHT						14
#define PLAYERSOUND_LANDHEAVY						15

#define PLAYERSOUND_DEATH1							16
#define PLAYERSOUND_DEATH2							17
#define PLAYERSOUND_DEATH3							18
#define PLAYERSOUND_DEATH4							19
#define PLAYERSOUND_DEATH5							20
#define PLAYERSOUND_DROWNDEATH						21

#define PLAYERSOUND_MAXSOUNDS						22

// Fields
.float	nPlayerModelType;
.float	tPlayerModelChangeTime;
.string	strCustomPlayerModel;
.float	nPlayerModelSex;
.float	nPlayerModelJumpLand;
.float	bPlayerModelUsingCustomSounds;
.float	bPlayerSoundsZoned;
.float	nPlayerModelFootstepType;

.float	tFootstepTime;

.void()	fpPlayerModelCleanUp;

.string	strPlayerSounds[PLAYERSOUND_MAXSOUNDS];

float	g_nCrouch_InteractivityLevel;

// Functions
void UnzonePlayerModelSounds(entity enClient)
{ // Unzone Player Model Sounds
	if(enClient.bPlayerSoundsZoned)
	{ // Sounds are Zoned
		local float nCnt;
		for(nCnt = 0; nCnt < PLAYERSOUND_MAXSOUNDS; nCnt++)
			strunzone(enClient.(strPlayerSounds[nCnt]));
			
		enClient.bPlayerSoundsZoned = FALSE;
	}
}
void PrecachePlayerModelSounds(entity enClient)
{ // Precache Player Model Sounds
	local float nCnt;
	for(nCnt = 0; nCnt < PLAYERSOUND_MAXSOUNDS; nCnt++)
		precache_sound(enClient.(strPlayerSounds[nCnt]));
}
void PrepareQuakePlayerModelSounds(entity enClient)
{ // Prepare Quake Player Model Sounds
	// Unzone Sounds
	UnzonePlayerModelSounds(enClient);
	
	// Prepare Sounds
	enClient.(strPlayerSounds[PLAYERSOUND_JUMP]) = strzone("player/plyrjmp8.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN1]) = strzone("player/pain1.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN2]) = strzone("player/pain2.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN3]) = strzone("player/pain3.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN4]) = strzone("player/pain4.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN5]) = strzone("player/pain5.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_PAIN6]) = strzone("player/pain6.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_AXPAIN]) = strzone("player/axhit1.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_LAVABURN1]) = strzone("player/lburn1.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_LAVABURN2]) = strzone("player/lburn2.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_DROWN1]) = strzone("player/drown1.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_DROWN2]) = strzone("player/drown2.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_GASP1]) = strzone("player/gasp1.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_GASP2]) = strzone("player/gasp2.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_LANDLIGHT]) = strzone("player/land.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_LANDHEAVY]) = strzone("player/land2.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH1]) = strzone("player/death1.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH2]) = strzone("player/death2.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH3]) = strzone("player/death3.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH4]) = strzone("player/death4.wav");
	enClient.(strPlayerSounds[PLAYERSOUND_DEATH5]) = strzone("player/death5.wav");
	
	enClient.(strPlayerSounds[PLAYERSOUND_DROWNDEATH]) = strzone("player/h2odeath.wav");
	
	// Assign Sounds Zoned
	enClient.bPlayerSoundsZoned = TRUE;
	
	// Precache Sounds
	PrecachePlayerModelSounds(enClient);
}
void CheckPlayerModelUpdate(entity enPlayer)
{ // Check Player Model Index	
	local string strNewModel;
	switch(enPlayer.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			if(enPlayer.weapon == WEAPON_MJOLNIR)
				// Hammer
				strNewModel = PLAYERMODEL_QUAKE_HAMMER;
			else
				// Standard
				strNewModel = PLAYERMODEL_QUAKE_NORMAL;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			strNewModel = enPlayer.strCustomPlayerModel;
		break;
	}
	
	if(enPlayer.bUseInvisibilityEyes)
	{ // Player use Invisiblity Eyes
		strNewModel = PLAYERMODEL_QUAKE_EYES;
		// Disable Quake2 Weapon Entity Drawing
		Quake2WeaponEntity_SetIsDrawing(enPlayer, FALSE);
	}
	
	// Update Bleeding Based on Sex
	switch(enPlayer.nPlayerModelSex)
	{
		case SEX_ROBOT:
			enPlayer.bBleedsSparks = TRUE;
			break;
		default:
			enPlayer.bBleedsSparks = FALSE;
			break;
	}
		
	// if(enPlayer.modelindex != nNewModelIndex)
	if(strNewModel != enPlayer.model)
	{ // New Model Index
		// bprint("Setting new model!\n");
		setmodel(enPlayer, strNewModel);
		// Set Size
		SetPlayerSize(enPlayer);
		
		// Parse Additional Meanings
		if(enPlayer.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2)
		{ // Quake2 Model
			// Apply No Model Flags
			enPlayer.effects = enPlayer.effects | EF_NOMODELFLAGS;
		}
	}
}
float GetAndUpdateModelChangeAllowed(entity enClient, float nNewModelType)
{ // Get and Update Model Change Allowed
	local float bReturn;
	local string strMessage;
	
	if(enClient.deadflag)
	{ // Dead; Change Not Allowed
		strMessage = "Player Model Change - Cannot Change Model when ^1DEAD^7\n";
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	else
	if(enClient.bIsCrouching)
	{ // Crouching; Change not Allowed
		strMessage = "Player Model Change - Cannot Change Model while ^1CROUCHING^7\n";
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	else
	if(intermission_running)
	{ // Intermission; Change not Allowed
		strMessage = "Player Model Change - Cannot Change Model During ^1INTERMISSION^7\n";
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	else
	if( !cvar(CVAR_PLAYERMODEL_ALLOWPLAYERMODELCHANGES) )
	{ // Change Not Allowed
		// Report Change not Allowed
		strMessage = "Player Model Change - Model changes are currently ^1DISABLED^7\n";
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	else
	if(nNewModelType == PLAYERMODEL_MODELTYPE_MD2 && !cvar(CVAR_PLAYERMODEL_ALLOWPLAYERMODELTYPE_QUAKE2) )
	{ // Model Type Not Allowed
		// Report Change not Allowed
		strMessage = "Player Model Change - ^2Quake2^7 Player Models are currently ^1DISABLED^7\n";
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	else
	if(time > enClient.tPlayerModelChangeTime)
	{ // Changed Allowed
		// Update Player Model Change Time
		enClient.tPlayerModelChangeTime = time + cvar(CVAR_PLAYERMODEL_REUSEDELAYTIME);
		
		// Confirm Change to Client
		stuffcmd(enClient, strcat(PLAYERMODEL_CLIENTCOMMAND_SERVERCONFIRMPLAYERMODELCHANGE, "\n") );
		
		bReturn = TRUE;
	}
	else
	{ // Change not Allowed
		// Calculate Time Remaining
		local float nTimeRemaining;
			nTimeRemaining = enClient.tPlayerModelChangeTime - time;
			nTimeRemaining = rint(nTimeRemaining);
			if(nTimeRemaining < 1)
				nTimeRemaining = 1;
		// Report Change not Allowed
		strMessage = strcat("Player Model Change - You must wait ^2", ftos(nTimeRemaining), "^7 more seconds before changing your player model\n");
		sprint(enClient, strMessage);
		
		bReturn = FALSE;
	}
	
	// Return Change Allowed
	return bReturn;
}
void SetPlayerModelSharedProperties(entity enClient, float nModelType, string strSex, string strFootsteps, string strJumpLand)
{ // Set Player Model Shared Properties
	enClient.nPlayerModelType = nModelType;
	strSex = strtolower(strSex);
	enClient.nPlayerModelSex = SG_GetSexIDFromAbbreviatedSexString(strSex);
	enClient.nPlayerModelFootstepType = SG_GetFootstepIDFromFootstepString(strFootsteps);
	enClient.nPlayerModelJumpLand = SG_GetJumpLandIDFromJumpLandString(strJumpLand);
}
void ResetPlayerModel(entity enClient, float bReport)
{ // Reset Player Model
	if( GetAndUpdateModelChangeAllowed(enClient, PLAYERMODEL_MODELTYPE_MDL) )
	{ // Update Allowed
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
		// Remove Custom Model Index
		enClient.strCustomPlayerModel = "";
		// Remove Model Type
		enClient.nPlayerModelType = 0;
		// Remove Skin
		enClient.skin = 0;
		// Remove Client Sex
		enClient.nPlayerModelSex = SEX_MALE;
		// Remove Footsteps
		enClient.nPlayerModelFootstepType = 0;
		// Remove Jump Land
		enClient.nPlayerModelJumpLand = PLAYERMODEL_JUMPLAND_HUMANOID;
		// Remove Using Custom Sounds
		enClient.bPlayerModelUsingCustomSounds = FALSE;
		// Prepare Standard Sounds
		PrepareQuakePlayerModelSounds(enClient);
		
		if(bReport)
			// Broadcast Player Model Change
			BroadcastClientPlayerModelChange(enClient, "player");
		
		// Check Model Update
		CheckPlayerModelUpdate(enClient);
	}
}
void SetPlayerModel_Quake(entity enClient, string strModelName, float bBroadcastChange)
{ // Set Player Model - Quake
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
	// Purge Skin
	self.skin = 0;
	// Remove Using Custom Sounds
	enClient.bPlayerModelUsingCustomSounds = FALSE;
	
	// Prepare Standard Sounds
	PrepareQuakePlayerModelSounds(enClient);
	
	// Broadcast Player Model Change
	if(bBroadcastChange)
		BroadcastClientPlayerModelChange(enClient, strModelName);
	
	// Invoke Check
	CheckPlayerModelUpdate(enClient);
}
void ParsePlayerModelCVarString(entity enClient, string strModelType, string strModelName, string strSex, string strFootsteps, string strJumpLand, string strUseSounds, string strSkinID, string strWeaponID)
{ // Parse Player Model CVar String	
	if(strModelType != "" && strModelName != "")
	{ // Valid Parameters
		// DEBUG : Report Info
		/*
		local string strDebug;
		strDebug = strcat(enClient.netname, "^7 Player Model Sync: ", strModelType, " ");
		strDebug = strcat(strDebug, strModelName, " ", strUseSounds, " ", strSkinID, "\n");
		bprint(strDebug);
		*/
		
		if( GetAndUpdateModelChangeAllowed(enClient, stof(strModelType) ) )
		{
			// Assign Shared Properties First
			SetPlayerModelSharedProperties(enClient, stof(strModelType), strSex, strFootsteps, strJumpLand);
			
			if(strModelType == ftos(PLAYERMODEL_MODELTYPE_MDL) )
			{ // Quake Model
				SetPlayerModel_Quake(enClient, strModelName, TRUE);
			}
			else
			if(strModelType == ftos(PLAYERMODEL_MODELTYPE_MD2) )
			{ // Quake2 Model
				SetPlayerModel_Quake2(enClient, strModelName, strUseSounds, strSkinID, strWeaponID, TRUE);
			}
		}
	}
}
void CheckFootsteps()
{ // Check Footsteps
	if(self.flags & FL_ONGROUND && !self.bIsCrouching)
	{ // On Ground
		if(time > self.tFootstepTime)
		{ // Time Worthy
			if( fabs(self.velocity_x) > 250 || fabs(self.velocity_y) > 250)
			{ // Speed Worthy
				local float nRandom;
				local string strSound;
					nRandom = floor(random() * 3);
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_BOOTS)
					strSound = g_strFootsteps_Boots[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_CHAINBOOTS)
					strSound = g_strFootsteps_ChainBoots[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_CLAWS)
					strSound = g_strFootsteps_Claws[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_HEELS)
					strSound = g_strFootsteps_Heels[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_HOOVES)
					strSound = g_strFootsteps_Hooves[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_MECHFOOT)
					strSound = g_strFootsteps_MechFoot[nRandom];
				else
				if(self.nPlayerModelFootstepType == PLAYERMODEL_FOOTSTEPS_METAL)
					strSound = g_strFootsteps_Metal[nRandom];
				sound(self, CHAN_AUTO, strSound, 1, ATTN_NORM);
				
				// Check for Water Sounds
				if(self.waterlevel)
				{
					nRandom = floor(random() * 3);
					strSound = g_strFootsteps_Water[nRandom];
					sound(self, CHAN_AUTO, strSound, 1, ATTN_NORM);
				}
				
				// Update Time
				self.tFootstepTime = time + 0.26 + (random() * 0.08);
			}
		}
	}
}
void PrecacheSharedPlayerModelAssets()
{
	// Precache Generic Gibbed Head
	precache_model(PLAYERMODEL_GENERICGIBBEDHEAD);
	// Precache Generic Robot Head
	precache_model(PLAYERMODEL_GENERICROBOTHEAD);
}