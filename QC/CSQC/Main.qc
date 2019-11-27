float		g_bIgnoreKeysUntilReleased;

void CSQC_Init(void)
{
	// Prepare Map Display Strings
	HUD_PrepareMapDisplayStrings();
	// Prepare Player Models
	PreparePlayerModels();
	
	// Prepare Global Weapon Entities
	SG_WeaponEntity_PrepareGlobalWeaponEntities();
	
	// Prepare HUD
	HUD_Prepare();
	
	// Precache Client Sounds
	PrecacheKleshikSounds_Client();
	
	// Precache Client Models
	precache_model("gfx/CorpseStain.spr32");
	// Precache Gibs
	precache_model(HUDEFFECT_GHOSTGIBS_GIB1);
	precache_model(HUDEFFECT_GHOSTGIBS_GIB2);
	precache_model(HUDEFFECT_GHOSTGIBS_GIB3);
	
	// Prepare Basic Mod CVars
	local string strCmd;
		strCmd = "";
		strCmd = strcat(strCmd, "chase_active 0\n");
		strCmd = strcat(strCmd, "scr_centertime 6.5\n");
		strCmd = strcat(strCmd, "ambient_level 1.0\n");
		strCmd = strcat(strCmd, "r_ambient 0\n");
		strCmd = strcat(strCmd, "cl_itembobheight 15.0\n");
		strCmd = strcat(strCmd, "cl_bobmodel_up 0.2\n");
		strCmd = strcat(strCmd, "cl_bobmodel_side 0.3\n");
		strCmd = strcat(strCmd, "cl_bobmodel_speed 8\n");
		strCmd = strcat(strCmd, "scr_printspeed 10000\n");
		strCmd = strcat(strCmd, "snd_soundradius 1250\n");
		strCmd = strcat(strCmd, "cl_sound_r_exp3 \"\"\n");
		strCmd = strcat(strCmd, "cl_sound_wizardhit \"\"\n");
		strCmd = strcat(strCmd, "cl_sound_hknighthit \"\"\n");
		strCmd = strcat(strCmd, "cl_noplayershadow 1\n");
		// Set the Music Volume to the Sound Volume
		strCmd = strcat(strCmd, "bgmvolume ", cvar_string("volume"), "\n");
		// Ensure No Quake Particles
		strCmd = strcat(strCmd, "cl_particles_quake 0\n");
		strCmd = strcat(strCmd, "v_flipped 0\n");
		strCmd = strcat(strCmd, "scr_stipple 0\n");
		strCmd = strcat(strCmd, "v_idlescale 1.2\n");
		strCmd = strcat(strCmd, "v_ipitch_cycle 1\n");
		strCmd = strcat(strCmd, "fog 0\n");
		strCmd = strcat(strCmd, "r_glsl_postprocess 0\n");
	localcmd(strCmd);
	
	// Prepare Aliases
	SG_PrepareClientAliases();
	
	// Prepare Commands
	registercommand(WEAPON_CLIENTCOMMAND_SERVERWEAPONSAVAILABLE);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_BLOODWASH);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWMIRROR);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTIPPLE);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_COLORFLASH);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_EVILEVENT);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_TUNNELVISION);
	// DEPRECATED
	// registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_DESATURATION);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_MAPNAMEDISPLAY);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_RUSHFOG);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_GHOSTGIBS);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTATIC);
	
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSHAKE);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_LETTERCRACKLES);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_CREEPCLOUD);
	registercommand(HUD_CLIENTCOMMAND_HUDSTINGER_PSYCHOVIEW);
	
	// Display Map Name
	HUD_BeginMapNameDisplay();
}
void CSQC_Shutdown(void)
{
	// Loop Music
	localcmd("cd loop Theme");
}
float CSQC_ConsoleCommand(string strMessage)
{
	local float nReturn;
		nReturn = true;
		
	// Tokenize String
	tokenize(strMessage);
	
	// Acquire Command
	local string strCmd;
		strCmd = argv(0);
	
	switch(strCmd)
	{
		case PLAYERMODEL_CLIENTCOMMAND_LISTQUAKE2PLAYERMODELS:
			ListQuake2PlayerModels();
			break;
		case PLAYERMODEL_CLIENTCOMMAND_SERVERCONFIRMPLAYERMODELCHANGE:
			ServerConfirmPlayerModelChange();
			break;
		case PLAYERMODEL_CLIENTCOMMAND_SERVERREQUESTPLAYERMODELSYNC:
			ServerRequestPlayerModelSync();
			break;
		case PLAYERMODEL_CLIENTCOMMAND_GENERATEQUAKE2SKINFILES:
			GenerateQuake2SkinFilesForAllModels();
			break;
		case PLAYERMODEL_CLIENTCOMMAND_DISPLAYPLAYERMODELINTERFACE:
			CheckDisplayPlayerModelInterface();
			break;
		case PLAYERMODEL_CLIENTCOMMAND_TOGGLEPLAYERCROUCH:
			TogglePlayerCrouch();
			break;
		case WEAPON_CLIENTCOMMAND_SERVERWEAPONSAVAILABLE:
			ParseServerWeaponsAvailable( argv(1) );
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_BLOODWASH:
			HUD_BeginBloodWash();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_VIEWMIRROR:
			HUD_BeginViewMirror();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTIPPLE:
			HUD_BeginViewStipple();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_COLORFLASH:
			HUD_BeginColorFlash('0.9 0.9 0.9', true);
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_EVILEVENT:
			HUD_BeginEvilEvent();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_TUNNELVISION:
			HUD_BeginTunnelVision();
			break;
		/*
		// DEPRECATED
		case HUD_CLIENTCOMMAND_HUDSTINGER_DESATURATION:
			HUD_BeginDesaturation();
			break;
		*/
		case HUD_CLIENTCOMMAND_HUDSTINGER_MAPNAMEDISPLAY:
			HUD_BeginMapNameDisplay();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_RUSHFOG:
			HUD_BeginRushFog();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSHAKE:
			HUD_BeginViewShake( stof(argv(1) ) );
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_GHOSTGIBS:
			HUD_BeginGhostGibs();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTATIC:
			HUD_BeginViewStatic();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_LETTERCRACKLES:
			HUD_BeginLetterCrackles();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_CREEPCLOUD:
			HUD_BeginCreepCloud();
			break;
		case HUD_CLIENTCOMMAND_HUDSTINGER_PSYCHOVIEW:
			HUD_BeginPsychoView();
			break;
			
		default:
			nReturn = false;
			break;
	}
	
	return nReturn;
}
float CSQC_InputEvent(float bKeyReleased, float nKey)
{
	local float bSkipKey;
		bSkipKey = false;
	if(bKeyReleased)
	{ // Key Released
		if(g_bIgnoreKeysUntilReleased == true)
		{
			g_bIgnoreKeysUntilReleased = false;
			bSkipKey = true;
		}
	}
	else
	{ // Key Pressed
		if(g_bIgnoreKeysUntilReleased)
			bSkipKey = true;
		else
		if(g_bPlayerModelSearchActive)
		{
			g_bIgnoreKeysUntilReleased = true;
			if( CheckPlayerModelInterfaceKeyEvent(nKey) )
				bSkipKey = true;
		}
	}
	return bSkipKey;
}
/*
float CSQC_Event_Sound(float nEntity, float nChannel, string strSound, float fVolume, float nAttenuation, vector vPosition)
{ // Sound Event
	local float bHandled;
	
	local string strDebug;
	strDebug = strcat("Received Sound Event : ", strSound);
	strDebug = strcat(strDebug, ", Volume ", ftos(fVolume) );
	strDebug = strcat(strDebug, ", Channel ", ftos(nChannel) );
	strDebug = strcat(strDebug, ", Attenuation ", ftos(nAttenuation) );
	strDebug = strcat(strDebug, ", Entity ", ftos(nEntity) );
	strDebug = strcat(strDebug, ", Position ", vtos(vPosition) );
	strDebug = strcat(strDebug, "\n");
	print(strDebug);
	
	return bHandled;
}
*/
// Non-Required Functions
/*
void CSQC_Ent_Update(float bIsNewEntity)
{
	float i;
	i = ReadByte();
}
void CSQC_Ent_Remove()
{
	remove(self);
}
void CSQC_Parse_StuffCmd(string strMessage)
{	
	localcmd(strMessage);
}
void CSQC_Parse_Print(string strMessage)
{
	print(strMessage);
}
void CSQC_Parse_CenterPrint(string strMessage)
{
	cprint(strMessage);
}
*/

void JunkFunc()
{
	local entity enDumb;
	enDumb.alpha = 0;
	enDumb.renderflags = 0;
	enDumb.colormod = '0 0 0';
	enDumb.scale = 0;
	enDumb.owner = NULL;
	intermission = 0;
	coop = 0;
	deathmatch = 0;
	dmg_take = 0;
	dmg_save = 0;
	dmg_origin = '0 0 0';
	enDumb.enCurrentWeaponEntity = world;
}
