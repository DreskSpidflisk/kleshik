// DRESK
// View CSQC Operations

// NOTE: Much functionality is done without functions or through function macros for performance reasons (called every rendered frame).

// Definitions
// Define if HiResolution Images Should be Used
#define HUD_USEHIRES
#define HUD_HIRES_FLATAMMO

#define HUDIMAGE_WIDGET_STANDARDBOX						"HUD/Widgets/StandardBox"
#define HUDIMAGE_WIDGET_STANDARDBOX_SKULL				"HUD/Widgets/StandardBox.Skull"
#define HUDIMAGE_WIDGET_STANDARDBOX_CRACKED				"HUD/Widgets/StandardBox.Cracked"

#define HUDIMAGE_WIDGET_STANDALONEHORIZONTALLINE		"HUD/Widgets/StandaloneHorizontalLine"

// Ammo
#ifdef HUD_USEHIRES
#define HUDIMAGE_AMMO_SHELLS							"HUD/HiRes/Ammo.Shells"
#define HUDIMAGE_AMMO_NAILS								"HUD/HiRes/Ammo.Nails"
#define HUDIMAGE_AMMO_ROCKETS							"HUD/HiRes/Ammo.Rockets"
#define HUDIMAGE_AMMO_CELLS								"HUD/HiRes/Ammo.Cells"
#else
#define HUDIMAGE_AMMO_SHELLS							"gfx/sb_shells"
#define HUDIMAGE_AMMO_NAILS								"gfx/sb_nails"
#define HUDIMAGE_AMMO_ROCKETS							"gfx/sb_rocket"
#define HUDIMAGE_AMMO_CELLS								"gfx/sb_cells"
#endif

// Armor
#ifdef HUD_USEHIRES
#define HUDIMAGE_ARMOR1									"HUD/HiRes/Armor1"
#define HUDIMAGE_ARMOR2									"HUD/HiRes/Armor2"
#define HUDIMAGE_ARMOR3									"HUD/HiRes/Armor3"
#else
#define HUDIMAGE_ARMOR1									"gfx/sb_armor1"
#define HUDIMAGE_ARMOR2									"gfx/sb_armor2"
#define HUDIMAGE_ARMOR3									"gfx/sb_armor3"
#endif

// Player Faces
#define HUDIMAGE_PLAYERFACE1							"gfx/face1"
#define HUDIMAGE_PLAYERFACE1_PAIN						"gfx/face_p1"
#define HUDIMAGE_PLAYERFACE2							"gfx/face2"
#define HUDIMAGE_PLAYERFACE2_PAIN						"gfx/face_p2"
#define HUDIMAGE_PLAYERFACE3							"gfx/face3"
#define HUDIMAGE_PLAYERFACE3_PAIN						"gfx/face_p3"
#define HUDIMAGE_PLAYERFACE4							"gfx/face4"
#define HUDIMAGE_PLAYERFACE4_PAIN						"gfx/face_p4"
#define HUDIMAGE_PLAYERFACE5							"gfx/face5"
#define HUDIMAGE_PLAYERFACE5_PAIN						"gfx/face_p5"

#define HUDIMAGE_PLAYERFACE_INVISIBLE					"gfx/face_invis"
#define HUDIMAGE_PLAYERFACE_INVULNERABLE				"gfx/face_invul2"
#define HUDIMAGE_PLAYERFACE_QUAD						"gfx/face_quad"
#define HUDIMAGE_PLAYERFACE_INVISINVULN					"gfx/face_inv2"

// Powerups
#define HUDIMAGE_POWERUP_INVISIBILITY					"gfx/sb_invis"
#define HUDIMAGE_POWERUP_INVULNERABILITY				"gfx/sb_invuln"
#define HUDIMAGE_POWERUP_ENVIROSUIT						"gfx/sb_suit"
#define HUDIMAGE_POWERUP_QUAD							"gfx/sb_quad"
#define HUDIMAGE_POWERUP_EMPATHYSHIELDS					"gfx/sb_eshld"

// Keys
#define HUDIMAGE_KEY1									"gfx/sb_key1"
#define HUDIMAGE_KEY2									"gfx/sb_key2"

#define PLAYERFACEPAINTIME								0.3
#define PLAYERFACE_CVAR_CUSTOMFACE						"klcustface"

#define HUDIMAGE_GENERICBOTTOMELEMENTSIZE				'36 36 0'

// Scoreboard
#define HUD_SCOREBOARD_POS_X							25
#define HUD_SCOREBOARD_ELEMENT_SIZE_X					10
#define HUD_SCOREBOARD_ELEMENT_SIZE_Y					10
#define HUD_SCOREBOARD_ALPHAMODMULTIPLIER				2.2

#define HUD_MAPINFO_POS_X								25
#define HUD_MAPINFO_POS_Y								75

// Constants
const vector	vHudImageSize_Weapon					= '30 20 0';

// Fields
float			g_nVideoWidth;
float			g_nVideoHeight;

float			g_nDrawOffset;

float			g_tPlayerPainTime;
float			g_bIsAlive;

float			g_bPreviousFrameFlareAvailable;
float			g_bPreviousFrameFluidContents;
string			g_strActiveCDTrack;

float			g_fScoreboardAlpha;

// NOTE : Using these variables for more optimized code.
float			g_nPreviousFrameActiveWeapon;
string			g_strPreviousFrameCurrentAmmoIcon;
float			g_nPreviousFrameCurrentAmmoIndex;

float			g_nPreviousFrameAmmo[4];
float			g_nFloatingAmmoDisplay[4];
float			g_nFloatingAmmoAlpha[4];

// Chase Camera
float			g_bDeathCVarsAssigned;
float			g_bHadChaseCameraAtDeath;

// Map Strings
string			g_strMapDisplayName;
string			g_strMapFileName;

// Icon Sizes
vector			g_vIconSize_Weapon;
vector			g_vIconSize_Weapon_LightningBolt;
vector			g_vIconSize_SmallAmmo;
vector			g_vIconSize_Powerup;
vector			g_vIconSize_Key;
vector			g_vIconSize_BottomGeneric;

// Custom Face
string			g_strCustomFace;

float			g_tNewPingTime;

float			g_nWeaponsAvailable;

// Functions
void HUD_Prepare()
{ // HUD - Prepare
	// Prepare Icon Sizes
	g_vIconSize_Weapon = draw_getimagesize(g_enWeaponEntity_Shotgun.strWeaponEntity_HUDIcon) * 1.5;
	g_vIconSize_Weapon_LightningBolt = draw_getimagesize(g_enWeaponEntity_Thunderbolt.strWeaponEntity_HUDIcon) * 1.5;
	g_vIconSize_SmallAmmo = draw_getimagesize(HUDIMAGE_AMMO_SHELLS) * 0.15;
	g_vIconSize_Powerup = draw_getimagesize(HUDIMAGE_POWERUP_INVISIBILITY) * 1.8;
	g_vIconSize_Key = draw_getimagesize(HUDIMAGE_KEY1) * 1.2;
	g_vIconSize_BottomGeneric = HUDIMAGE_GENERICBOTTOMELEMENTSIZE;
	
	// Prepare Initial Sizes
	g_bPreviousFrameFlareAvailable = true;
}
void HUD_PrepareMapDisplayStrings()
{ // HUD - Prepare Map Display Strings
	local float nLength;
	// Acquire Filename + .bsp
	g_strMapFileName = substring(mapname, 5, 100);
	// Cull .bsp
	nLength = strlen(g_strMapFileName);
	g_strMapFileName = substring(g_strMapFileName, 0, nLength - 4);
	// Add Parenthesis
	g_strMapFileName = strcat("(", g_strMapFileName, ")");
	
	// Acquire Map Display Name
	g_strMapDisplayName = world.message;
	
	// Zone Strings
	g_strMapDisplayName = strzone(g_strMapDisplayName);
	g_strMapFileName = strzone(g_strMapFileName);
}
void HUD_DrawWeaponIcon(entity enWeaponEntity, float bNested)
{ // HUD - Draw Weapon Icon
	local float fAlpha;
	local vector vColor;
		vColor = '1 1 1';
	local vector vLocation;
	local vector vSize;
	
	// Acquire Weapon from Weapon Entity
	local float nWeapon;
		nWeapon = enWeaponEntity.nWeaponEntity_WeaponID;
	
	if(g_nWeaponsAvailable & nWeapon)
	{ // Weapon Available
		local string strIcon;
		// Acquire Image Size (prior to replacement)
		if(nWeapon == WEAPON_LIGHTNING)
			vSize = g_vIconSize_Weapon_LightningBolt;
		else
			vSize = g_vIconSize_Weapon;
		
		if( getstati(STAT_KLESHIK_WEAPONS) & nWeapon)
		{ // Player Has Weapon
			if(getstati(STAT_ACTIVEWEAPON) & nWeapon)
			{ // Weapon is Active
				fAlpha = 1;
				vColor = '1 0.6 0.6';
			}
			else
				fAlpha = 0.4;
			// Acquire Icon from Weapon Entity
			strIcon = enWeaponEntity.strWeaponEntity_HUDIcon;
		}
		else
		{ // Player does NOT have Weapon
			fAlpha = 0.2;
			vColor = '0.5 0.5 0.5';
			strIcon = HUDIMAGE_WIDGET_STANDARDBOX;
		}

		// Calculate Location
		if(bNested)
		{ // Nested Icon
			vLocation_x = g_nVideoWidth - (vSize_x * 2);
			vLocation_y = (g_nVideoHeight - 375) + g_nDrawOffset - vSize_y;
		}
		else
		{
			vLocation_x = g_nVideoWidth - vSize_x;
			vLocation_y = (g_nVideoHeight - 375) + g_nDrawOffset;
			// Update Draw Offset
			g_nDrawOffset = g_nDrawOffset + vSize_y;
		}
		vLocation_z = 0;
		
		// Draw Icon
		drawpic(vLocation, strIcon, vSize, vColor, fAlpha, 0);
	}
}
void HUD_DrawAmmoIconAndText(float nAmmo, float nPreviousAmmoIndex, vector vBottomGenericSize, string strIcon)
{ // HUD - Draw Ammo Icon
	local vector vLocation;
	local vector vSize;
	local vector vColor;
	
	// Prepare 'Redness' Factor
	vColor_x = 1;
	if(nAmmo < 100)
	{
		vColor_y = nAmmo / 100;
		vColor_z = nAmmo / 100;
	}
	else
	{
		vColor_y = 1;
		vColor_z = 1;
	}
	
	// Calculate Background Icon Size
	vSize = g_vIconSize_SmallAmmo;
	vSize_x = vSize_x * 3.1;
	
	// Calculate Location
	vLocation_x = g_nVideoWidth - (vSize_x + g_nDrawOffset);
	vLocation_y = g_nVideoHeight - (vBottomGenericSize_y + 55);
	vLocation_z = 0;
	
	// Draw Background
	drawpic(vLocation, HUDIMAGE_WIDGET_STANDARDBOX, vSize, '0.5 0.5 0.5', 1, 0);

	// Update Draw Offset
	g_nDrawOffset = g_nDrawOffset + vSize_x;
	
	// Draw Icon
	vSize = g_vIconSize_SmallAmmo;
	// vSize_y = vSize_y * 0.9;
	drawpic(vLocation, strIcon, vSize, '1 1 1', 1, 0);
	
	// Draw Text
	vLocation_x = vLocation_x + vSize_x + 2;
	vLocation_y = vLocation_y + 5;
	vSize = g_vIconSize_SmallAmmo * 0.5;
	drawstring(vLocation, ftos(nAmmo), vSize, vColor, 1, 0);
	
	// Check for Floating Ammo Display
	if(nAmmo > (g_nPreviousFrameAmmo[nPreviousAmmoIndex]) )
	{ // More Ammo
		// Assign New Amount
		g_nFloatingAmmoDisplay[nPreviousAmmoIndex] = (nAmmo - g_nPreviousFrameAmmo[nPreviousAmmoIndex]);
		// Assign New Alpha
		g_nFloatingAmmoAlpha[nPreviousAmmoIndex] = 1.0;
	}
	// Acquire Potential Floating Ammo Display
	local float nFloatingAmmo;
		nFloatingAmmo = g_nFloatingAmmoDisplay[nPreviousAmmoIndex];
	if(nFloatingAmmo)
	{ // Floating Ammo Display Current
		if(g_nFloatingAmmoAlpha[nPreviousAmmoIndex] < 0)
		{ // Finish Displaying
			g_nFloatingAmmoDisplay[nPreviousAmmoIndex] = 0;
		}
		else
		{
			// Draw Text
			vSize = vSize * 1.2;
			vLocation_x = vLocation_x - vSize_x;
			vLocation_y = vLocation_y - (vSize_y * 1.5);
			// Acquire Alpha
			local float fAlpha;
				fAlpha = g_nFloatingAmmoAlpha[nPreviousAmmoIndex];
			drawstring(vLocation, strcat("+", ftos(nFloatingAmmo) ), vSize, '0 1 0', fAlpha, 0);
			// Decrement Alpha
			g_nFloatingAmmoAlpha[nPreviousAmmoIndex] = g_nFloatingAmmoAlpha[nPreviousAmmoIndex] - (frametime * 1);
		}
	}
	
	// Update Previous Frame Ammo
	g_nPreviousFrameAmmo[nPreviousAmmoIndex] = nAmmo;
}
void HUD_DrawKeyIcon(float nItem, string strIcon)
{ // HUD - Draw Key Icon
	local vector vSize;
	local vector vLocation;
	
	// Calculate Icon Size
	vSize = g_vIconSize_Key;
	
	if( getstati(STAT_KLESHIK_KEYS) & nItem)
	{ // Has Key
	
		// Calculate Location
		vLocation_x = g_nVideoWidth - vSize_x - g_nDrawOffset;
		vLocation_y = g_nVideoHeight - (g_vIconSize_BottomGeneric_y + 20);
	
		// Draw Icon
		drawpic(vLocation, strIcon, vSize, '1 1 1', 1, 0);
	}
	// Update Draw Offset
	g_nDrawOffset += (vSize_x * 1.2);
}
void HUD_DrawPowerupIcon(float nItem, string strIcon)
{ // HUD - Draw Powerup Icon
	local vector vLocation;
	local vector vDurationLocation;
	local vector vDurationSize;
	local vector vSize;
	local vector vColor;
	local float fAlpha;
	
	// Calculate Icon Size
	vSize = g_vIconSize_Powerup;
	
	if( getstati(STAT_KLESHIK_POWERUPS) & nItem || SG_AUTOCVAR(kleshik_client_hud_alwaysdrawpoweruplist) )
	{ // Has Item
		// Calculate Location
		vLocation_x = 10;
		vLocation_y = g_nVideoHeight - (g_vIconSize_BottomGeneric_y + 115) - g_nDrawOffset;
		
		if( getstati(STAT_KLESHIK_POWERUPS) & nItem)
		{ // Draw Duration
			local float tPowerupDuration;
				tPowerupDuration = GetPowerupDuration(nItem);
			local string strTime;
				strTime = SG_GetFormattedTimeStringUnZoned(tPowerupDuration);
				vDurationSize = vSize * 0.56;
				
			vDurationLocation = vLocation;
			vDurationLocation_x += vSize_x + 5;
			vDurationLocation_y += vSize_y * 0.25;
			
			// Prepare 'Redness' Factor
			vColor_x = 0;
			if(tPowerupDuration < 10)
			{
				vColor_x = 1;
				vColor_y = tPowerupDuration / 10;
				vColor_z = tPowerupDuration / 10;
			}
			else
			{
				vColor_y = 1;
				vColor_z = 0;
			}
			
			drawstring(vDurationLocation, strTime, vDurationSize, vColor, 1, 0);
			fAlpha = 1;
		}
		else
			fAlpha = 0.4;
		
		// Draw Icon
		drawpic(vLocation, strIcon, vSize, '1 1 1', fAlpha, 0);
	}
	/*
	else
	{ // Does not Have Item
		fAlpha = 0.2;
		vColor = '0.5 0.5 0.5';
		strIcon = HUDIMAGE_WIDGET_STANDARDBOX;
	}
	*/
		
	// Update Draw Offset
	g_nDrawOffset = g_nDrawOffset + (vSize_y * 1.1);
}
void HUD_DrawMapInfoElement(string strInfo, vector vColor, vector vSize)
{ // HUD - Draw Map Info Element
	local vector vLocation;
	
	// Calculate Location
	vLocation_x = HUD_SCOREBOARD_POS_X + 5;
	vLocation_y = HUD_MAPINFO_POS_Y + 5 + g_nDrawOffset;
	
	// Draw Info
	drawstring(vLocation, strInfo, vSize, vColor, g_fScoreboardAlpha, 0);
	
	// Update Draw Offset
	g_nDrawOffset = g_nDrawOffset + (vSize_y);
}
void HUD_DrawMapInfo()
{ // HUD - Draw MapInfo
	local vector vLocation;
	local vector vSize;
	local vector vColor;
	local string strMessage;
	
	// Reset Draw Offset
	g_nDrawOffset = 0;
	
	// Calculate Location
	vLocation_x = HUD_SCOREBOARD_POS_X;
	vLocation_y = HUD_MAPINFO_POS_Y;
	vLocation_z = 0;
	
	// Calculate Size
	vSize_x = HUD_SCOREBOARD_ELEMENT_SIZE_X * 50;
	if(!deathmatch)
		vSize_y = (HUD_SCOREBOARD_ELEMENT_SIZE_Y * 9);
	else
		vSize_y = (HUD_SCOREBOARD_ELEMENT_SIZE_Y * 5);
	
	// Draw Background
	drawfill(vLocation, vSize, '0.01 0.01 0.01', g_fScoreboardAlpha * 0.5, 0);
	
	// Draw Elements
	
	// Map Display Name
	vColor = '1 0 0';
	vSize_x = HUD_SCOREBOARD_ELEMENT_SIZE_X;
	vSize_y = HUD_SCOREBOARD_ELEMENT_SIZE_Y;
	vSize_z = 0;
	HUD_DrawMapInfoElement(g_strMapDisplayName, vColor, vSize);
	// Map File Name
	HUD_DrawMapInfoElement(g_strMapFileName, vColor, vSize);
	
	// Update Draw Offset for additional spacing
	g_nDrawOffset = g_nDrawOffset + vSize_y;
	
	vColor = '1 1 1';
	
	if(!deathmatch)
	{ // Draw Singleplayer / Coop Information
		// Skill
		strMessage = strcat("Skill         : ", SG_GetSkillNameFromSkillNum(getstati(STAT_KLESHIK_SKILL)));
		HUD_DrawMapInfoElement(strMessage, vColor, vSize);
		// Monsters
		strMessage = strcat("Monsters      : ", ftos(getstati(STAT_MONSTERS)), " / ", ftos(getstati(STAT_TOTALMONSTERS)) );
		HUD_DrawMapInfoElement(strMessage, vColor, vSize);
		// Additional Monsters
		strMessage = strcat("Add. Monsters : ", ftos(getstati(STAT_KLESHIK_ADDITIONALMONSTERS_KILLED)), " / ", ftos(getstati(STAT_KLESHIK_ADDITIONALMONSTERS_TOTAL)) );
		HUD_DrawMapInfoElement(strMessage, vColor, vSize);
		// Secrets
		strMessage = strcat("Secrets       : ", ftos(getstati(STAT_SECRETS)), " / ", ftos(getstati(STAT_TOTALSECRETS)) );
		HUD_DrawMapInfoElement(strMessage, vColor, vSize);
	}
	
	// Time
	local string strTime;
	strTime = SG_GetFormattedTimeStringUnZoned(time);
	strMessage = strcat("Time          : ", strTime);
	HUD_DrawMapInfoElement(strMessage, vColor, vSize);
	
	// Update Draw Offset for additional spacing
	g_nDrawOffset = g_nDrawOffset + (vSize_y * 2);
}
void HUD_DrawPlayerInfo(string strInfo, float nPosY, vector vColor, vector vSize, float bUseColorCodedString)
{
	local vector vLocation;
		vLocation_x = HUD_SCOREBOARD_POS_X + 5;
	// Calculate Location
	vLocation_y = nPosY + 5 + g_nDrawOffset;
		
	// Draw Info
	if(bUseColorCodedString)
		drawcolorcodedstring(vLocation, strInfo, vSize, g_fScoreboardAlpha, 0);
	else
		drawstring(vLocation, strInfo, vSize, vColor, g_fScoreboardAlpha, 0);
		
	// Update Draw Offset
	g_nDrawOffset = g_nDrawOffset + (vSize_y);
}
void HUD_DrawPlayers(float nPosY)
{ // HUD - Draw Players
	local float nCnt;
	local float nPlayerCnt;
	local vector vLocation;
	local vector vSize;
	local vector vColor;
	local string strName;
	local string strPing;
	local string strPacketLoss;
	local string strFrags;
	local string strSpacedName;
	local string strSpacedPing;
	local string strSpacedFrags;
	local string strMessage;
	
	if(time > g_tNewPingTime)
	{ // Update Pings
		localcmd("pings\n");
		g_tNewPingTime = time + 2;
	}
	
	// Reset Draw Offset
	g_nDrawOffset = 0;
	
	// Calculate Location
	vLocation_x = HUD_SCOREBOARD_POS_X;
	vLocation_y = nPosY;
	vLocation_z = 0;
	
	// Acquire Number of Players (for background size)
	for(nCnt = 0; nCnt < maxclients; nCnt++)
	{
		strName = getplayerkeyvalue(nCnt, "name");
		// Player Check is Based on having text in your name?  Bah, bad method.
		if(strName != "")
			nPlayerCnt = nPlayerCnt + 1;
	}
	
	// Calculate Size
	vSize_x = HUD_SCOREBOARD_ELEMENT_SIZE_X * 50;
	vSize_y = 30 + (HUD_SCOREBOARD_ELEMENT_SIZE_Y * nPlayerCnt);
	
	// Draw Background
	drawfill(vLocation, vSize, '0.01 0.01 0.01', g_fScoreboardAlpha * 0.5, 0);
	
	// Draw Header
	vSize_x = HUD_SCOREBOARD_ELEMENT_SIZE_X;
	vSize_y = HUD_SCOREBOARD_ELEMENT_SIZE_Y;
	vSize_z = 0;
	vColor = '1 0 0';
	strName		= "Name                    ";
	strPing		= "Ping / PL       ";
	if(!deathmatch)
		strFrags	= "Kills          ";
	else
		strFrags	= "Frags          ";
	strMessage = strcat(strName, strPing, strFrags);
	HUD_DrawPlayerInfo(strMessage, nPosY, vColor, vSize, false);
	
	// Update Draw Offset for additional spacing
	g_nDrawOffset = g_nDrawOffset + vSize_y;
	
	// Players
	vColor = '1 1 1';
	for(nCnt = 0; nCnt < maxclients; nCnt++)
	{
		// Acquire Name
		strName = getplayerkeyvalue(nCnt, "name");
		if(strName != "")
		{ // Valid Player
			// Acquire Ping
			strPing = getplayerkeyvalue(nCnt, "ping");
			// Acquire PacketLoss
			strPacketLoss = getplayerkeyvalue(nCnt, "pl");
			// Create Full Ping String
			strPing = strcat(strPing, " / ", strPacketLoss, "%");
			// Acquire Frags
			strFrags = getplayerkeyvalue(nCnt, "frags");
			
			// Create Spaced Strings
			strSpacedName = SG_GetSpacedStringZoned(strName, 24, false);
			strSpacedPing = SG_GetSpacedStringZoned(strPing, 16, false);
			strSpacedFrags = SG_GetSpacedStringZoned(strFrags, 16, false);
			
			// Create String
			strMessage = strcat(strSpacedName, strSpacedPing, strSpacedFrags);
			HUD_DrawPlayerInfo(strMessage, nPosY, vColor, vSize, true);
			
			// Unzone Strings
			strunzone(strSpacedName);
			strunzone(strSpacedPing);
			strunzone(strSpacedFrags);
		}
	}
}
void UpdateFluidContents(float bForceUpdate)
{ // Update Fluid Contents
	local string strCommand;
	local string strCDTrack;
	// Determine Origin Location
	vector vOrigin;
		vOrigin = pmove_org;
		vOrigin_z += getstati(STAT_VIEWHEIGHT);
	// Acquire Current Contents
	local float nContents;
		nContents = pointcontents(vOrigin);
		
	if(nContents != g_bPreviousFrameFluidContents || bForceUpdate)
	{ // New Contents
		strCommand = "fog ";
		
		switch(nContents)
		{
			case CONTENT_WATER:
				strCommand = strcat(strCommand, "2.3 0.12 0.12 0.11 0.97\n");
				strCDTrack = "Underwater";
				break;
			case CONTENT_SLIME:
				strCommand = strcat(strCommand, "1.9 0.1 0.24 0.1 0.8\n");
				strCDTrack = "Underwater";
				break;
			case CONTENT_LAVA:
				strCommand = strcat(strCommand, "0.8 0.35 0.1 0.0 1\n");
				strCDTrack = "Underwater";
				break;
			default:
				// No Fluid
				strCommand = strcat(strCommand, "0\n");
				strCDTrack = "";
				break;
		}
		
		if(strCDTrack != "")
		{ // Append CD Track
			if(strCDTrack == g_strActiveCDTrack)
				strCommand = strcat(strCommand, "cd resume\n");
			else
			{
				strCommand = strcat(strCommand, "cd loop ", strCDTrack, "\n");
				// Update Active CD Track
				g_strActiveCDTrack = strCDTrack;
			}
		}
		else
		{ // Pause CD Track
			strCommand = strcat(strCommand, "cd pause\n");
		}
		
		// Execute Command
		localcmd(strCommand);
	}
	
	// Update Previous Frame Fluid Contents
	g_bPreviousFrameFluidContents = nContents;
}
void UpdateFlashLight(float fFlashLightLightLevel, float fFlashlightMinimumAmbientLevel)
{
	local vector vOrigin;
	// Use Player Origin
	vOrigin = pmove_org;
	// Shift Origin
	vOrigin = vOrigin + FLASHLIGHT_ORIGINOFFSET;
		// Check for Crouching
		local float bIsCrouching;
		bIsCrouching = getstati(STAT_KLESHIK_PLAYERISCROUCHING);
		if(bIsCrouching)
			vOrigin = vOrigin - '0 0 8';
	// Get Vectors of Local Inputs
	makevectors(input_angles);
	// Trace
	traceline(vOrigin, vOrigin + (v_forward * FLASHLIGHT_TRACEMULTIPLIER_FORWARD) + (v_right * FLASHLIGHT_TRACEMULTIPLIER_RIGHT), FALSE, self);
	// Pull Inward
	trace_endpos = trace_endpos + (v_forward * FLASHLIGHT_TRACEENDMULTIPLAYER_INWARD);
	// DEBUG
	// te_spark(trace_endpos, '0 0 100', 1);
	// Create Dynamic Light
	adddynamiclight2(trace_endpos, fFlashLightLightLevel, '2 2 2', 255, "cubemaps/1", PFLAGS_FULLDYNAMIC);
	
	// Gradually Decrease Ambient Light
	local float fAmbient;
	fAmbient = cvar("r_ambient");
	fAmbient = max(fAmbient - (35 * frametime), fFlashlightMinimumAmbientLevel);
	cvar_set("r_ambient", ftos(fAmbient) );
	
	// Force Self Shadow Off
	cvar_set("cl_noplayershadow", "1");
}
string GetAmmoHUDImageFromAmmoType(float nAmmoType)
{ // Return Ammo HUD Image from Ammo Type
	local string strReturn;
	switch(nAmmoType)
	{
		case AMMOTYPE_SHELLS:
			strReturn = HUDIMAGE_AMMO_SHELLS;
			break;
		case AMMOTYPE_NAILS:
			strReturn = HUDIMAGE_AMMO_NAILS;
			break;
		case AMMOTYPE_ROCKETS:
			strReturn = HUDIMAGE_AMMO_ROCKETS;
			break;
		case AMMOTYPE_CELLS:
			strReturn = HUDIMAGE_AMMO_CELLS;
			break;
		default:
			strReturn = "";
			break;
	}
	
	return strReturn;
}

#ifdef DEBUG_TESTMODEL
entity	g_enDebugTestModel;
float	g_fDebugTestModelRot_x;
float	g_fDebugTestModelRot_y;
void DEBUG_UpdateTestModel()
{ // DEBUG - Update Test Model
	local vector vOrigin;
	
	// Check to Spawn Entity
	if(!g_enDebugTestModel)
	{
		g_enDebugTestModel = spawn();
		g_enDebugTestModel.drawmask = MASK_NORMAL;
	}
	// Update Model
	local string strModel;
	strModel = cvar_string("dbg_testmodel");
	if( strcasecmp(strModel, "") != 0)
	{ // Valid Model
		// Add Prefix
		strModel = strcat(cvar_string("dbg_testmodel_prefix") , strModel);
		precache_model(strModel);
		setmodel(g_enDebugTestModel, strModel);
		// Update Skin
		g_enDebugTestModel.skin = cvar("dbg_testmodel_skinID");
		
		if( !cvar("dbg_testmodel_freeze") )
		{
			makevectors(input_angles);
			// Determine Location
			vOrigin = pmove_org + '0 0 20';
			// Trace
			traceline(vOrigin, vOrigin + (v_forward * cvar("dbg_testmodel_distance") ), FALSE, self);
			// Pull Inward
			// trace_endpos = trace_endpos + (v_forward * -10);
			
			// Check for Align
			if(trace_fraction != 1 && cvar("dbg_testmodel_alignagainstsurface") )
			{ // Trace Found Surface; Continue
				local vector vNormal;
					vNormal = trace_plane_normal;
				
				// Derive Vectors
				g_enDebugTestModel.angles = '0 0 0';
				makevectors(g_enDebugTestModel.angles);
				
				local vector vOrientation;
					vOrientation = v_forward;
					vOrientation = vOrientation - vNormal * (vNormal * vOrientation);
					g_enDebugTestModel.angles = vectoangles2(vOrientation, vNormal);
					
				// Assign Aligned Angles
				// g_enDebugTestModel.angles = vectoangles( normalize(v_forward - ( (v_forward * vNormal) / (v_up * vNormal)) * v_up) );
			}
			else
			{
				// Mod Rotations
				g_fDebugTestModelRot_x = g_fDebugTestModelRot_x + (frametime * cvar("dbg_testmodel_rotationspeed_x") );
				g_enDebugTestModel.angles_x = g_fDebugTestModelRot_x;
				
				g_fDebugTestModelRot_y = g_fDebugTestModelRot_y + (frametime * cvar("dbg_testmodel_rotationspeed_y") );
				g_enDebugTestModel.angles_y = g_fDebugTestModelRot_y;
				
				g_enDebugTestModel.angles_z = 0;
			}
			
			// Update Test Model Origin
			setorigin(g_enDebugTestModel, trace_endpos);
		}
	}
}
#endif
// entity g_enWeaponTest;
void CSQC_UpdateView(void)
{ // Primary Update View Function
	// Prepare Variables
	local string strIcon;
	local vector vLocation;
	local vector vColor;
	local vector vSize;
	local float nHealth;
		nHealth = getstati(STAT_HEALTH);
	local float nArmor;
		nArmor = getstati(STAT_ARMOR);
	local float nItems;
		nItems = getstati(STAT_ITEMS);
	local float nPowerups;
		nPowerups = getstati(STAT_KLESHIK_POWERUPS);
	local float nActiveWeapon;
		nActiveWeapon = getstati(STAT_ACTIVEWEAPON);
	local float bFlareAvailable;
		bFlareAvailable = getstati(STAT_KLESHIK_FLAREAVAILABLE);
	local float fFlashLightLightLevel;
		fFlashLightLightLevel = getstati(STAT_KLESHIK_FLASHLIGHTLIGHTLEVEL);
	local float fFlashlightMinimumAmbientLevel;
		fFlashlightMinimumAmbientLevel = getstati(STAT_KLESHIK_FLASHLIGHTMINIMUMAMBIENTLEVEL);
		
	// Clear Current Scene
	clearscene();
	
	// Check for Alive
	if(nHealth > 0) // NOTE : Integer check is fine due to protocol sending as integer
	{
		g_bIsAlive = true;
		
		if(g_bDeathCVarsAssigned)
		{ // Death CVars had been assigned
			if(!g_bHadChaseCameraAtDeath)
			{ // Remove Chase Camera
				// Remove
				cvar_set("chase_active", "0");
			}
			// Reset Idle Scale
			cvar_set("v_idlescale", "1.2");
			// Remove CVars Assigned
			g_bDeathCVarsAssigned = false;
		}
	}
	else
	{
		g_bIsAlive = false;
		// Check for Chase Camera Activation
		if(!g_bDeathCVarsAssigned)
		{ // CVars Needed
			// Assign Had Chase Camera at Death
			if( cvar("chase_active") )
				g_bHadChaseCameraAtDeath = true;
			else
				g_bHadChaseCameraAtDeath = false;
			// Update CVar
			cvar_set("chase_active", "1");
			// Assign Idle Scale
			cvar_set("v_idlescale", "30");
			// Set CVars Assigned
			g_bDeathCVarsAssigned = true;
		}
	}

	// Setup View Drawing
	setproperty(VF_DRAWWORLD, 1);
	if(g_bIsAlive)
		setproperty(VF_DRAWCROSSHAIR, 1);
	// setproperty(VF_DRAWENGINESBAR, 1);
	
	// Check Pre-Scene HUD Effects
	if(g_fTunnelVisionState)
		HUD_UpdateTunnelVision();
		
	// Check CSQC Flash Light
	if(g_bIsAlive && fFlashLightLightLevel)
		UpdateFlashLight(fFlashLightLightLevel, fFlashlightMinimumAmbientLevel);
	else
	{ // Check for Ambient Light Level Return
		local float fAmbient;
		fAmbient = cvar("r_ambient");
		fAmbient = min(fAmbient + (30 * frametime), 0);
		cvar_set("r_ambient", ftos(fAmbient) );
		
		// Restore Self Shadow
		cvar_set("cl_noplayershadow", "0");
	}
	
	#ifdef DEBUG_TESTMODEL
	DEBUG_UpdateTestModel();
	#endif

	// Render Entities
	addentities(MASK_NORMAL | MASK_ENGINE | MASK_ENGINEVIEWMODELS);
	// Render the Scene
	renderscene();
	
	// Check HUD Effects
	if(g_fColorFlashState)
		HUD_UpdateColorFlash();
	if(g_fEvilEventState)
		HUD_UpdateEvilEvent();
	if(g_fBloodWashAlpha)
		HUD_UpdateBloodWash();
	if(g_fMapNameDisplayState)
		HUD_UpdateMapNameDisplay();
	if(g_fRushFogState)
		HUD_UpdateRushFog();
	if(g_fGhostGibsState)
		HUD_UpdateGhostGibs();
	if(g_fViewStaticState)
		HUD_UpdateViewStatic();
	if(g_fLetterCracklesState)
		HUD_UpdateLetterCrackles();
		
	// Check for New Flare Available
	if(!g_bPreviousFrameFlareAvailable && bFlareAvailable)
	{ // Flare Available
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_FLARES_AVAILABLE, "\n");
	}
	// Update Previous Frame Flare Available
	g_bPreviousFrameFlareAvailable = bFlareAvailable;
	
	// Update Fluid Contents
	UpdateFluidContents(false);
	
	// Check for Intermission Suppression
	if(intermission)
	{
		if(deathmatch)
		{ // Always Draw Scoreboard during Deathmatch Intermission
			// Increase Alpha
			g_fScoreboardAlpha = g_fScoreboardAlpha + (frametime * HUD_SCOREBOARD_ALPHAMODMULTIPLIER);
			g_fScoreboardAlpha = min(g_fScoreboardAlpha, 1.0);
		}
		else
		if(g_fScoreboardAlpha > 0)
		{
			// Decrease Alpha
			g_fScoreboardAlpha = g_fScoreboardAlpha - (frametime * HUD_SCOREBOARD_ALPHAMODMULTIPLIER);
			g_fScoreboardAlpha = max(g_fScoreboardAlpha, 0);
		}
		if(g_fScoreboardAlpha > 0)
		{
			HUD_DrawMapInfo();
			HUD_DrawPlayers(HUD_MAPINFO_POS_Y + g_nDrawOffset);
		}
		return;
	}
	
	// Update Bottom Generic Sizes
	local vector vBottomGenericSize;
	local vector vBottomGenericBoxSize;
	local vector vBottomGenericTextSize;
	vBottomGenericSize = g_vIconSize_BottomGeneric * SG_AUTOCVAR(kleshik_client_hud_bottomscale);
	vBottomGenericBoxSize = vBottomGenericSize * 1.4;
	vBottomGenericTextSize = vBottomGenericSize * 0.9;
	
	// *********************************************
	// BEGIN DRAW ARMOR
		if(g_bIsAlive)
		{ // Alive
			// Calculate Background Icon Location
			vLocation_x = 5;
			vLocation_y = g_nVideoHeight - (vBottomGenericBoxSize_y + 5);
			vLocation_z = 0;
			
			// Draw Background Icon
			drawpic(vLocation, HUDIMAGE_WIDGET_STANDARDBOX_SKULL, vBottomGenericBoxSize, '1 1 1', 1, 0);
			
			{ // Draw Armor Information
				// Determine Armor Icon and Text Color
				if(nItems & ITEM_ARMOR1)
				{
					strIcon = HUDIMAGE_ARMOR1;
					vColor = '0 0.6 0';
				}
				else
				if(nItems & ITEM_ARMOR2)
				{
					strIcon = HUDIMAGE_ARMOR2;
					vColor = '1 1 0';
				}
				else
				{
					strIcon = HUDIMAGE_ARMOR3;
					vColor = '0.8 0 0';
				}
				
				// Calculate Armor Icon Location
				vLocation_x = vLocation_x + (vBottomGenericBoxSize_x / 7);
				vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 7);
				vLocation_z = 0;
					
				// Draw Armor Icon
				if(nArmor > 0)
					drawpic(vLocation, strIcon, vBottomGenericSize, '1 1 1', 1, 0);
				
				// Calculate Text Location
				vLocation_x = vLocation_x + (vBottomGenericBoxSize_x * 0.9);
				vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 8);
				
				// Draw Armor Text
				if(nArmor > 0)
					drawstring(vLocation, ftos(nArmor), vBottomGenericTextSize, vColor, 1, 0);
			}
		}
	// END DRAW ARMOR
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW HEALTH
		if(g_bIsAlive)
		{ // Alive
			// Calculate Background Icon Location
			vLocation_x = vLocation_x + (vBottomGenericSize_x * 0.8) * 3.6;
			vLocation_y = g_nVideoHeight - (vBottomGenericBoxSize_y + 5);
			vLocation_z = 0;
			
			// Draw Background Icon
			drawpic(vLocation, HUDIMAGE_WIDGET_STANDARDBOX_CRACKED, vBottomGenericBoxSize, '1 1 1', 1, 0);
			
			// Check for Custom Face
			if(g_strCustomFace != "")
				strIcon = g_strCustomFace;
			else
			if(nPowerups & POWERUP_INVISIBILITY && nPowerups & POWERUP_INVULNERABILITY)
				strIcon = HUDIMAGE_PLAYERFACE_INVISINVULN;
			else
			if(nPowerups & POWERUP_INVISIBILITY)
				strIcon = HUDIMAGE_PLAYERFACE_INVISIBLE;
			else
			if(nPowerups & POWERUP_INVULNERABILITY)
				strIcon = HUDIMAGE_PLAYERFACE_INVULNERABLE;
			else
			if(nPowerups & POWERUP_QUADDAMAGE)
				strIcon = HUDIMAGE_PLAYERFACE_QUAD;
			else
			{ // Potentially Pain Face
				if(dmg_take)
					// Damage Taken
					g_tPlayerPainTime = time + PLAYERFACEPAINTIME;
				if(nHealth < 20)
				{
					if(g_tPlayerPainTime > time)
						strIcon = HUDIMAGE_PLAYERFACE5_PAIN;
					else
						strIcon = HUDIMAGE_PLAYERFACE5;
				}
				else
				if(nHealth < 40)
				{
					if(g_tPlayerPainTime > time)
						strIcon = HUDIMAGE_PLAYERFACE4_PAIN;
					else
						strIcon = HUDIMAGE_PLAYERFACE4;
				}
				else
				if(nHealth < 60)
				{
					if(g_tPlayerPainTime > time)
						strIcon = HUDIMAGE_PLAYERFACE3_PAIN;
					else
						strIcon = HUDIMAGE_PLAYERFACE3;
				}
				else
				if(nHealth < 80)
				{
					if(g_tPlayerPainTime > time)
						strIcon = HUDIMAGE_PLAYERFACE2_PAIN;
					else
						strIcon = HUDIMAGE_PLAYERFACE2;
				}
				else
				{
					if(g_tPlayerPainTime > time)
						strIcon = HUDIMAGE_PLAYERFACE1_PAIN;
					else
						strIcon = HUDIMAGE_PLAYERFACE1;
				}
			}
				
			// Prepare 'Redness' Factor
			vColor_x = 1;
			if(nHealth < 100)
			{
				vColor_y = nHealth / 100;
				vColor_z = nHealth / 100;
			}
			else
			{
				vColor_y = 1;
				vColor_z = 1;
			}
			
			// Calculate Armor Icon Location
			vLocation_x = vLocation_x + (vBottomGenericBoxSize_x / 7);
			vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 7);
			vLocation_z = 0;
				
			// Draw Face Icon
			drawpic(vLocation, strIcon, vBottomGenericSize, '1 1 1', 1, 0);
			
			// Calculate Text Location
			vLocation_x = vLocation_x + (vBottomGenericBoxSize_x * 0.9);
			vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 8);
			
			// Draw Health Text
			drawstring(vLocation, ftos(nHealth), vBottomGenericTextSize, vColor, 1, 0);
		}
	
	// END DRAW HEALTH
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW WEAPONS
		if(g_bIsAlive && SG_AUTOCVAR(kleshik_client_hud_drawweaponlist))
		{ // Alive
			// Reset Draw Offset
			g_nDrawOffset = 0;
			
			HUD_DrawWeaponIcon(g_enWeaponEntity_Axe, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_Mjolnir, true);
			HUD_DrawWeaponIcon(g_enWeaponEntity_Shotgun, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_LaserGun, true);
			HUD_DrawWeaponIcon(g_enWeaponEntity_SuperShotgun, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_Nailgun, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_FlechetteCannon, true);
			HUD_DrawWeaponIcon(g_enWeaponEntity_SuperNailgun, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_ChainGun, true);
			HUD_DrawWeaponIcon(g_enWeaponEntity_GrenadeLauncher, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_ProximityGun, true);
			HUD_DrawWeaponIcon(g_enWeaponEntity_RocketLauncher, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_Thunderbolt, false);
			HUD_DrawWeaponIcon(g_enWeaponEntity_LaserCannon, false);
		}
	// END DRAW WEAPONS
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW CURRENT AMMO
		if(g_bIsAlive)
		{ // Alive
			// Acquire Weapon Entity from WeaponID
			local entity enWeapon;
				enWeapon = SG_WeaponEntity_GetWeaponEntityFromWeaponID(nActiveWeapon);
			// Calculate Background Icon Location
			vLocation_x = g_nVideoWidth - 235;
			vLocation_y = g_nVideoHeight - (vBottomGenericBoxSize_y + 5);
			vLocation_z = 0;
			
			// Draw Background Icon
			drawpic(vLocation, HUDIMAGE_WIDGET_STANDARDBOX, vBottomGenericBoxSize, '1 1 1', 1, 0);
			
			// Determine AmmoType
			if(nActiveWeapon == g_nPreviousFrameActiveWeapon)
				// Same Weapon as Before
				strIcon = g_strPreviousFrameCurrentAmmoIcon;
			else
			{ // New Weapon
				// Acquire Hud Image from Ammo Type
				strIcon = GetAmmoHUDImageFromAmmoType(enWeapon.nWeaponEntity_AmmoTypeUsed);
				
				// Update Previous Frame Current Ammo Icon
				g_strPreviousFrameCurrentAmmoIcon = strIcon;
			}
			
			if(strIcon != "")
			{ // Render Ammo
				// Calculate Ammo Icon Location
				vLocation_x = vLocation_x + (vBottomGenericBoxSize_x / 7);
				vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 7);
				vLocation_z = 0;
				
				// Acquire Ammo
				local float nAmmo;
				if(nActiveWeapon == g_nPreviousFrameActiveWeapon)
					// Same Weapon
					nAmmo = getstati(g_nPreviousFrameCurrentAmmoIndex);
				else
				{ // New Weapon
					local float nIndex;
						nIndex = GetStatIndexFromAmmoType(enWeapon.nWeaponEntity_AmmoTypeUsed);
					nAmmo = getstati(nIndex);
					// Update Previous Frame Current Ammo Index
					g_nPreviousFrameCurrentAmmoIndex = nIndex;
				}
					
				// Draw Ammo Icon
				drawpic(vLocation, strIcon, vBottomGenericSize, '1 1 1', 1, 0);
				
				// Prepare 'Redness' Factor
				vColor_x = 1;
				if(nAmmo < 100)
				{
					vColor_y = nAmmo / 100;
					vColor_z = nAmmo / 100;
				}
				else
				{
					vColor_y = 1;
					vColor_z = 1;
				}
				
				// Calculate Text Location
				vLocation_x = vLocation_x + (vBottomGenericBoxSize_x * 0.9);
				vLocation_y = vLocation_y + (vBottomGenericBoxSize_y / 8);
				
				// Draw Ammo Text
				drawstring(vLocation, ftos(nAmmo), vBottomGenericTextSize, vColor, 1, 0);
			}
		}
	// END DRAW CURRENT AMMO
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW AMMO
		if(g_bIsAlive)
		{ // Alive
			// Reset Draw Offset
			g_nDrawOffset = 0;
			
			HUD_DrawAmmoIconAndText( getstati(STAT_CELLS), 3, vBottomGenericSize, HUDIMAGE_AMMO_CELLS);
			HUD_DrawAmmoIconAndText( getstati(STAT_ROCKETS), 2, vBottomGenericSize, HUDIMAGE_AMMO_ROCKETS);
			HUD_DrawAmmoIconAndText( getstati(STAT_NAILS), 1, vBottomGenericSize, HUDIMAGE_AMMO_NAILS);
			HUD_DrawAmmoIconAndText( getstati(STAT_SHELLS), 0, vBottomGenericSize, HUDIMAGE_AMMO_SHELLS);
			
			// Draw Border Graphic
			vLocation_x = g_nVideoWidth - g_nDrawOffset - 0;
			vLocation_y = g_nVideoHeight - (vBottomGenericSize_y + 35);
			vSize_x = g_nVideoWidth - vLocation_x - 3;
			vSize_y = 20;
			drawpic(vLocation, HUDIMAGE_WIDGET_STANDALONEHORIZONTALLINE, vSize, '1 1 1', 1, 0);
		}
	// END DRAW AMMO
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW POWERUPS
		if(g_bIsAlive)
		{ // Alive
			// Reset Draw Offset
			g_nDrawOffset = 0;
			
			HUD_DrawPowerupIcon(POWERUP_INVISIBILITY, HUDIMAGE_POWERUP_INVISIBILITY);
			HUD_DrawPowerupIcon(POWERUP_INVULNERABILITY, HUDIMAGE_POWERUP_INVULNERABILITY);
			HUD_DrawPowerupIcon(POWERUP_BIOSUIT, HUDIMAGE_POWERUP_ENVIROSUIT);
			HUD_DrawPowerupIcon(POWERUP_QUADDAMAGE, HUDIMAGE_POWERUP_QUAD);
			HUD_DrawPowerupIcon(POWERUP_EMPATHYSHIELDS, HUDIMAGE_POWERUP_EMPATHYSHIELDS);
		
			// Draw Border Graphic
			/*
			vLocation_x = 0;
			vLocation_y = g_nVideoHeight - (g_vIconSize_Face_y + 30);
			vSize_x = g_nDrawOffset * 1.5;
			vSize_y = 3;
			drawpic(vLocation, HUDIMAGE_WIDGET_STANDARDBOX, vSize, '1 1 1', 1, 0);
			*/
		}
	// END DRAW POWERUPS
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW KEYS
		if(g_bIsAlive)
		{ // Alive
			// Reset Draw Offset
			g_nDrawOffset = 0;
			
			HUD_DrawKeyIcon(KEY_SILVER, HUDIMAGE_KEY1);
			HUD_DrawKeyIcon(KEY_GOLD, HUDIMAGE_KEY2);
		}
	
	// END DRAW KEYS
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW AIR LEFT BAR
	// END DRAW AIR LEFT BAR
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW SCOREBOARD
		if(sb_showscores)
		{
			// Increase Alpha
			g_fScoreboardAlpha = g_fScoreboardAlpha + (frametime * HUD_SCOREBOARD_ALPHAMODMULTIPLIER);
			g_fScoreboardAlpha = min(g_fScoreboardAlpha, 1.0);
		}
		else
		if(g_fScoreboardAlpha > 0)
		{
			// Decrease Alpha
			g_fScoreboardAlpha = g_fScoreboardAlpha - (frametime * HUD_SCOREBOARD_ALPHAMODMULTIPLIER);
			g_fScoreboardAlpha = max(g_fScoreboardAlpha, 0);
		}
		if(g_fScoreboardAlpha > 0)
		{
			HUD_DrawMapInfo();
			HUD_DrawPlayers(HUD_MAPINFO_POS_Y + g_nDrawOffset);
		}
	// END DRAW SCOREBOARD
	// *********************************************
	
	// *********************************************
	// BEGIN DRAW PLAYER MODEL INTERFACE
		if(g_bPlayerModelSearchActive)
			DrawPlayerModelInterface();
	// END DRAW PLAYER MODEL INTERFACE
	// *********************************************
	
	// *********************************************
	// BEGIN DEBUG DRAW RENDER MODEL
		/*
			// Prepare Viewport
			R_ClearScene();
			R_SetView(VF_CLEARSCREEN, TRUE);
			R_SetView(VF_PERSPECTIVE, FALSE);
			R_SetView(VF_DRAWWORLD, FALSE);
			R_SetView(VF_VIEWPORT, '0 0 0', '400 400 0');
			R_SetView(VF_ORIGIN, '0 0 0');
			R_SetView(VF_FOV, '90 90 90');
			
			if(!enTester)
			{
				enTester = spawn();
				setmodel(enTester, OBJECT_BRASSCASING_STEEL);
				enTester.origin = '0 0 0';
			}
			
			R_AddDynamicLight('0 0 0', 1000, '1 0 0');
			
			R_AddEntity(enTester);
			
			R_RenderScene();
		*/
	// END DEBUG DRAW RENDER MODEL
	// *********************************************
}