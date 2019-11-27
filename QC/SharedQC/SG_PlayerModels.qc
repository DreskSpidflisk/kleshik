// Model Types
#define PLAYERMODEL_MODELTYPE_MDL										0
#define PLAYERMODEL_MODELTYPE_MD2										1
#define PLAYERMODEL_MODELTYPE_MAX										1

// Client Commands
#define PLAYERMODEL_CLIENTCOMMAND_SERVERCONFIRMPLAYERMODELCHANGE		"ServerConfirmPlayerModelChange"
#define PLAYERMODEL_CLIENTCOMMAND_SERVERREQUESTPLAYERMODELSYNC			"ServerRequestPlayerModelSync"
#define PLAYERMODEL_CLIENTCOMMAND_LISTQUAKE2PLAYERMODELS				"ListQ2PlayerModels"
#define PLAYERMODEL_CLIENTCOMMAND_DISPLAYPLAYERMODELINTERFACE			"kl_DisplayPlayerModelInterface"
#define PLAYERMODEL_CLIENTCOMMAND_GENERATEQUAKE2SKINFILES				"GenerateQuake2SkinFiles"
#define PLAYERMODEL_CLIENTCOMMAND_TOGGLEPLAYERCROUCH					"kl_TogglePlayerCrouch"

#define PLAYERMODEL_DATAPATH_QUAKE										"data/players/quake/"
#define PLAYERMODEL_DATAPATH_QUAKE2										"data/players/quake2/"

#define PLAYERMODEL_FOOTSTEPS_BOOTS										0
#define PLAYERMODEL_FOOTSTEPS_CHAINBOOTS								1
#define PLAYERMODEL_FOOTSTEPS_CLAWS										2
#define PLAYERMODEL_FOOTSTEPS_HEELS										3
#define PLAYERMODEL_FOOTSTEPS_HOOVES									4
#define PLAYERMODEL_FOOTSTEPS_MECHFOOT									5
#define PLAYERMODEL_FOOTSTEPS_METAL										6
#define PLAYERMODEL_FOOTSTEPS_MAX										6

#define PLAYERMODEL_JUMPLAND_HUMANOID									0
#define PLAYERMODEL_JUMPLAND_ROBOTIC									1
#define PLAYERMODEL_JUMPLAND_MODELSOUNDS								2
#define PLAYERMODEL_JUMPLAND_MAX										2

string SG_GetModelTypeStringFromModelTypeID(float nID)
{ // Return Model Type String from Model Type ID
	local string strReturn;
	switch(nID)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			strReturn = "Quake";
			break;
		case PLAYERMODEL_MODELTYPE_MD2:
			strReturn = "Quake2";
			break;
		default:
			strReturn = "UNKNOWN";
			break;
	}
	return strReturn;
}
string SG_GetFootstepStringFromFootstepID(float nID)
{ // Return Footstep String from Footstep ID
	local string strReturn;
	switch(nID)
	{
		case PLAYERMODEL_FOOTSTEPS_BOOTS:
			strReturn = "Boots";
			break;
		case PLAYERMODEL_FOOTSTEPS_CHAINBOOTS:
			strReturn = "ChainBoots";
			break;			
		case PLAYERMODEL_FOOTSTEPS_CLAWS:
			strReturn = "Claws";
			break;
		case PLAYERMODEL_FOOTSTEPS_HEELS:
			strReturn = "Heels";
			break;
		case PLAYERMODEL_FOOTSTEPS_HOOVES:
			strReturn = "Hooves";
			break;
		case PLAYERMODEL_FOOTSTEPS_MECHFOOT:
			strReturn = "MechFoot";
			break;
		case PLAYERMODEL_FOOTSTEPS_METAL:
			strReturn = "Metal";
			break;
		default:
			strReturn = "UNKNOWN";
			break;
	}
	return strReturn;
}

float SG_GetFootstepIDFromFootstepString(string strFootstep)
{ // Return Footstep ID From Footstep String
	local float nReturn;
	switch(strFootstep)
	{
		case "ChainBoots":
			nReturn = PLAYERMODEL_FOOTSTEPS_CHAINBOOTS;
			break;
		case "Claws":
			nReturn = PLAYERMODEL_FOOTSTEPS_CLAWS;
			break;
		case "Heels":
			nReturn = PLAYERMODEL_FOOTSTEPS_HEELS;
			break;
		case "Hooves":
			nReturn = PLAYERMODEL_FOOTSTEPS_HOOVES;
			break;
		case "MechFoot":
			nReturn = PLAYERMODEL_FOOTSTEPS_MECHFOOT;
			break;
		case "Metal":
			nReturn = PLAYERMODEL_FOOTSTEPS_METAL;
			break;
		default:
			nReturn = PLAYERMODEL_FOOTSTEPS_BOOTS;
			break;
	}
	
	return nReturn;
}
string SG_GetJumpLandStringFromJumpLandID(float nID)
{
	local string strReturn;
	switch(nID)
	{
		case PLAYERMODEL_JUMPLAND_HUMANOID:
			strReturn = "Humanoid";
			break;
		case PLAYERMODEL_JUMPLAND_ROBOTIC:
			strReturn = "Robotic";
			break;
		case PLAYERMODEL_JUMPLAND_MODELSOUNDS:
			strReturn = "ModelSounds";
			break;
		default:
			strReturn = "UNKNOWN";
			break;
	}
	return strReturn;
}
float SG_GetJumpLandIDFromJumpLandString(string strJumpLand)
{
	local float nReturn;
	switch(strJumpLand)
	{
		case "Humanoid":
			nReturn = PLAYERMODEL_JUMPLAND_HUMANOID;
			break;
		case "Robotic":
			nReturn = PLAYERMODEL_JUMPLAND_ROBOTIC;
			break;
		case "ModelSounds":
			nReturn = PLAYERMODEL_JUMPLAND_MODELSOUNDS;
			break;
		default:
			nReturn = PLAYERMODEL_JUMPLAND_HUMANOID;
			break;
	}
	return nReturn;
}