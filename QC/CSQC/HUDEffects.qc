// Dresk
// HUD Effects

// Definitions
#define HUDIMAGE_KLESHIK_BLOODWASH						"HUD/BloodWash.tga"
#define HUDIMAGE_KLESHIK_EVILEVENT1						"HUD/EvilEvent1.tga"
#define HUDIMAGE_KLESHIK_EVILEVENT2						"HUD/EvilEvent2.tga"
#define HUDIMAGE_KLESHIK_EVILEVENT3						"HUD/EvilEvent3.tga"

#define HUDEFFECT_STATE_NONE							0
#define HUDEFFECT_STATE_STARTING						1
#define HUDEFFECT_STATE_ENDING							2

#define HUDEFFECT_RUSTFOG_MAXDENSITY					1.00

#define HUDEFFECT_GHOSTGIBS_GIB1						"progs/gib1.mdl"
#define HUDEFFECT_GHOSTGIBS_GIB2						"progs/gib2.mdl"
#define HUDEFFECT_GHOSTGIBS_GIB3						"progs/gib3.mdl"
#define HUDEFFECT_GHOSTGIBS_NUMGHOSTGIBS				40

#define HUDEFFECT_VIEWSTATIC_NUMLINES					13

#define HUDEFFECT_LETTERCRACKLES_NUMLETTERS				500
#define HUDEFFECT_LETTERCRACKLES_LETTER_BASESIZE		5
#define HUDEFFECT_LETTERCRACKLES_LETTER_SIZEVARIATION	35

// Prototype Map Data
string g_strMapDisplayName;

void UpdateFluidContents(float bForceUpdate);

// Fields

// Blood Wash Effect
float			g_fBloodWashAlpha;
float			g_fBloodWashSizeMod;
float			g_fBloodWashSizeOffset;
vector			g_vBloodWashColor;

// Color Flash
float			g_fColorFlashState;
float			g_fColorFlashAlpha;
vector			g_vColorFlashColor;

// Rush Fog
float			g_fRushFogState;
float			g_fRushFogDensity;
entity			g_enRushFogController;

// View Mirror Effect
entity			g_enViewMirrorFlipController;

// View Stipple
entity			g_enViewStippleController;

// View Shake
entity			g_enViewShakeController;

// Evil Event
vector			g_vEvilEventLocation;
vector			g_vEvilEventSize;
string			g_strEvilEventImage;
float			g_fEvilEventState;
float			g_fEvilEventAlpha;

// Tunnel Vision
float			g_fTunnelVisionState;
float			g_fTunnelVisionMod;
float			g_nTunnelVisionFOV;

// Desaturation
/*
// DEPRECATED
float			g_fDesaturationState;
float			g_fDesaturationMod;
*/

// Map Name Display
float			g_fMapNameDisplayState;
vector			g_vMapNameDisplaySize;
float			g_fMapNameDisplayAlpha;
vector			g_vMapNameDisplayLocation;

// Ghost Gibs
float			g_fGhostGibsState;
float			g_tGhostGibsReverseTime;
float			g_tGhostGibScreenFillTime;
entity			g_enGhostGibs[HUDEFFECT_GHOSTGIBS_NUMGHOSTGIBS];
.vector			vGhostGib_AngleMod;
.float			fGhostGib_DirectionRight;
.float			fGhostGib_DirectionUp;
.float			fGhostGib_MaxDistance;
.float			fGhostGib_CurrentDistance;
.float			fGhostGib_CurrentDistanceMod;

// View Static
float			g_fViewStaticState;
float			g_fViewStaticFillAlpha;
entity			g_enViewStaticLines[HUDEFFECT_VIEWSTATIC_NUMLINES];
.float			fViewStaticLine_OriginOffset;
.float			fViewStaticLine_DirectionIsRight;

// Letter Crackles
float			g_fLetterCracklesState;
float			g_fLetterCracklesAlpha;
vector			g_vLetterCracklesBaseOrigins[HUDEFFECT_LETTERCRACKLES_NUMLETTERS];
vector			g_vLetterCracklesBaseSizes[HUDEFFECT_LETTERCRACKLES_NUMLETTERS];
string			g_strLetterCrackleStrings[HUDEFFECT_LETTERCRACKLES_NUMLETTERS];
entity			g_enLetterCracklesSoundController;

// Creep Cloud
entity			g_enCreepCloud;
float			g_fCreepCloudDistance;

// Psycho View
entity			g_enPsychoViewController;



// Functions
entity HUD_GhostGibs_SpawnGhostGib()
{ // Spawn Ghost Gib
	local entity enGib;
		enGib = spawn();
	// Acquire Model
	local string strModel;
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		strModel = HUDEFFECT_GHOSTGIBS_GIB1;
	else
	if(nRandom < 0.66)
		strModel = HUDEFFECT_GHOSTGIBS_GIB2;
	else
		strModel = HUDEFFECT_GHOSTGIBS_GIB3;
	// Set Render Flags
	enGib.drawmask = MASK_NORMAL;
	// Assign No Shadow
	enGib.effects = EF_NOSHADOW;
	// Set Model
	setmodel(enGib, strModel);
	// Assign Default Alpha
	enGib.alpha = 1;
	// Calculate Scale
	enGib.scale = 0.5 + (random() * 0.5);
	// Calculate Direction Modifications
	enGib.fGhostGib_DirectionRight = random() * 1;
	if( random() < 0.5)
		enGib.fGhostGib_DirectionRight *= -1;
	enGib.fGhostGib_DirectionUp = random() * 1;
	/*if( random() < 0.5)
		enGib.fGhostGib_DirectionUp *= -1;*/
	// Calculate Angle Mod
	enGib.vGhostGib_AngleMod = randomvec() * 10;
	// Calculate Max Distance
	enGib.fGhostGib_MaxDistance = 100 + (random() * 125);
	// Set Standard Distance Mod
	enGib.fGhostGib_CurrentDistanceMod = 175 + (random() * 150);
	
	// Return Gib
	return enGib;
}
void HUD_UpdateGhostGibs()
{ // Update Ghost Gibs
	local float nCnt;
	local entity enGhostGib;
	local vector vOrigin;
	local vector vDestination;
	local float bPurgeGhostGibs;
	local string strSound;
	local float nRandom;
	
	// Determine if Ending
	if(time > g_tGhostGibsReverseTime && g_fGhostGibsState != HUDEFFECT_STATE_ENDING)
	{
		g_fGhostGibsState = HUDEFFECT_STATE_ENDING;
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_GHOSTGIBSEND, "\n");
	}
	// Get Vectors of Local Inputs
	makevectors(input_angles);
	// Acquire Origin
	vOrigin = pmove_org;
	
	if(g_tGhostGibScreenFillTime > time)
	{ // Fill the Screen
		vDestination_x = g_nVideoWidth;
		vDestination_y = g_nVideoHeight;
		drawfill('0 0 0', vDestination, '0.4 0 0', 0.8, 0);
	}
	else
	if(random() > 0.97)
	{ // Prepare a Screen Fill
		g_tGhostGibScreenFillTime = time + 0.03;
	}
	
	for(nCnt = 0; nCnt < HUDEFFECT_GHOSTGIBS_NUMGHOSTGIBS; nCnt++)
	{ // Cycle through Ghost Gibs
		// Acquire Ghost Gib
		enGhostGib = g_enGhostGibs[nCnt];
		
		// Update Distance
		enGhostGib.fGhostGib_CurrentDistance += (enGhostGib.fGhostGib_CurrentDistanceMod * frametime);
		if(enGhostGib.fGhostGib_CurrentDistance >= enGhostGib.fGhostGib_MaxDistance)
		{ // Reached Max Distance; Reverse
			enGhostGib.fGhostGib_CurrentDistanceMod *= -1;
			// Play Sound
			if(random() > 0.8)
			{
				nRandom = random();
				if(nRandom < 0.20)
					strSound = SOUND_KLESHIK_IMPACTS_GIBS_GIBIMPACT1;
				else
				if(nRandom < 0.40)
					strSound = SOUND_KLESHIK_IMPACTS_GIBS_GIBIMPACT2;
				else
				if(nRandom < 0.60)
					strSound = SOUND_KLESHIK_IMPACTS_GIBS_GIBIMPACT3;
				else
				if(nRandom < 0.80)
					strSound = SOUND_KLESHIK_IMPACTS_GIBS_GIBIMPACT4;
				else
					strSound = SOUND_KLESHIK_IMPACTS_GIBS_GIBIMPACT5;
				localcmd("play2 ", strSound, "\n");
				te_bloodshower(enGhostGib.origin, enGhostGib.origin, 1500, 150);
			}
		}
		else
		if(enGhostGib.fGhostGib_CurrentDistance <= 0)
		{ // Reached Min Distance; Reverse
			enGhostGib.fGhostGib_CurrentDistanceMod *= -1;
		}
		
		// Calculate Destination
		vDestination = vOrigin + (v_forward * enGhostGib.fGhostGib_CurrentDistance);
		// Add Right
		vDestination += (v_right * enGhostGib.fGhostGib_DirectionRight * enGhostGib.fGhostGib_CurrentDistance);
		// Add Up
		vDestination += (v_up * enGhostGib.fGhostGib_DirectionUp * enGhostGib.fGhostGib_CurrentDistance);
		
		// Perform Trace
		traceline(vOrigin, vDestination, FALSE, self);
		
		// Jitter End Position Z
		if(random() > 0.8)
		{
			if(random() < 0.5)
				trace_endpos_z += 1;
			else
				trace_endpos_z -= 1;
		}
		
		// Update Origin
		setorigin(enGhostGib, trace_endpos);
		
		// Shift Angles
		enGhostGib.angles += enGhostGib.vGhostGib_AngleMod;
		
		if(g_fGhostGibsState == HUDEFFECT_STATE_ENDING)
		{ // Ending; Mod Alpha
			enGhostGib.alpha -= (frametime * 0.9);
			if(enGhostGib.alpha <= 0)
			{ // Gib Reached No Alpha; Stop
				bPurgeGhostGibs = TRUE;
			}
		}
	}
	
	if(bPurgeGhostGibs)
	{ // Purge Ghost Gibs
		for(nCnt = 0; nCnt < HUDEFFECT_GHOSTGIBS_NUMGHOSTGIBS; nCnt++)
		{ // Cycle through Ghost Gibs
			// Remove Entity
			remove(g_enGhostGibs[nCnt] );
		}
		// End State
		g_fGhostGibsState = HUDEFFECT_STATE_NONE;
	}
}
void HUD_BeginGhostGibs()
{ // Begin Ghost Gibs
	local float nCnt;
	
	if(g_fGhostGibsState == HUDEFFECT_STATE_NONE)
	{ // No State; Begin
		// Assign State
		g_fGhostGibsState = HUDEFFECT_STATE_STARTING;
		// Calculate Reverse Time
		g_tGhostGibsReverseTime = time + 3 + (random() * 1.5);
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_GHOSTGIBSSTART, "\n");
		// Spawn Ghost Gibs
		for(nCnt = 0; nCnt < HUDEFFECT_GHOSTGIBS_NUMGHOSTGIBS; nCnt++)
		{ // Prepare Max Gibs
			// Spawn Gib
			g_enGhostGibs[nCnt] = HUD_GhostGibs_SpawnGhostGib();
		}
	}
}
void HUD_BeginBloodWash()
{ // Begin Blood Wash
	if(g_fBloodWashAlpha == 0)
	{
		// Assign Initial Blood Wash Alpha
		g_fBloodWashAlpha = 1.0;
		// Acquire Random Color
		g_vBloodWashColor_x = 0.6 + (random() * 0.4);
		
		// Acquire Random Size Mod
		g_fBloodWashSizeMod = 1000 + (random() * 1000);
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_BLOODWASH, "\n");
	}
}
void HUD_LetterCracklesEntityThink()
{
	// Play Sound
	local string strSound;
	local float nCnt;
	nCnt = random() * 5;
	if(nCnt < 1)
		strSound = SOUND_KLESHIK_STINGER_LETTERCRACKLE1;
	else
	if(nCnt < 2)
		strSound = SOUND_KLESHIK_STINGER_LETTERCRACKLE2;
	else
	if(nCnt < 3)
		strSound = SOUND_KLESHIK_STINGER_LETTERCRACKLE3;
	else
	if(nCnt < 4)
		strSound = SOUND_KLESHIK_STINGER_LETTERCRACKLE4;
	else
		strSound = SOUND_KLESHIK_STINGER_LETTERCRACKLE5;
	localcmd("play2 ", strSound, "\n");
	
	// Update Timer
	g_enLetterCracklesSoundController.nextthink = time + random() * 0.8;
}
void HUD_BeginLetterCrackles()
{ // Begin Letter Jitters
	local float nCnt;
	local vector vOrigin;
	local vector vSize;
	local float nRandom;
	if(g_fLetterCracklesState == HUDEFFECT_STATE_NONE)
	{
		g_fLetterCracklesState = HUDEFFECT_STATE_STARTING;
		g_fLetterCracklesAlpha = 0;
		
		// Check and Prepare Entity
		if(!g_enLetterCracklesSoundController)
		{
			g_enLetterCracklesSoundController = spawn();
			g_enLetterCracklesSoundController.classname = "Letter Crackles Sound Controller";
			g_enLetterCracklesSoundController.think = HUD_LetterCracklesEntityThink;
		}
		g_enLetterCracklesSoundController.nextthink = time + random() * 0.8;
		
		// Spawn Letter Origins
		for(nCnt = 0; nCnt < HUDEFFECT_LETTERCRACKLES_NUMLETTERS; nCnt++)
		{
			// Assign Random Letter Origin
			vOrigin_x = random() * g_nVideoWidth;
			vOrigin_y = random() * g_nVideoHeight;
			g_vLetterCracklesBaseOrigins[nCnt] = vOrigin;
			// Assign Random Size
			vSize_x = HUDEFFECT_LETTERCRACKLES_LETTER_BASESIZE + ( random() * HUDEFFECT_LETTERCRACKLES_LETTER_SIZEVARIATION);
			if( random() < 0.5)
				vSize_x *= -1;
			vSize_y = HUDEFFECT_LETTERCRACKLES_LETTER_BASESIZE + ( random() * HUDEFFECT_LETTERCRACKLES_LETTER_SIZEVARIATION);
			if( random() < 0.5)
				vSize_y *= -1;
			g_vLetterCracklesBaseSizes[nCnt] = vSize;
			// Assign Random String
			nRandom = random();
			if(nRandom < 0.33)
				g_strLetterCrackleStrings[nCnt] = "Z";
			else
			if(nRandom < 0.66)
				g_strLetterCrackleStrings[nCnt] = "T";
			else
				g_strLetterCrackleStrings[nCnt] = "X";
		}
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_LETTERCRACKLESTART, "\n");
	}
}
void HUD_UpdateLetterCrackles()
{
	if(g_fLetterCracklesState == HUDEFFECT_STATE_STARTING)
	{
		g_fLetterCracklesAlpha += (frametime * 0.15);
		
		if(g_fLetterCracklesAlpha > 1)
		{
			g_fLetterCracklesState = HUDEFFECT_STATE_ENDING;
			g_fLetterCracklesAlpha = 1;
		}
	}
	else
	{
		g_fLetterCracklesAlpha -= (frametime * 0.40);
		
		// Stinger Finished
		if(g_fLetterCracklesAlpha < 0)
		{
			g_fLetterCracklesState = HUDEFFECT_STATE_NONE;
			g_fLetterCracklesAlpha = 0;
			// Stop Sound Controller
			g_enLetterCracklesSoundController.nextthink = 0;
		}
	}
	
	// Draw Letters!
	local float nCnt;
	local vector vOrigin;
	local vector vSize;
	local vector vColor;
	vColor = '1 0 0';
	for(nCnt = 0; nCnt < HUDEFFECT_LETTERCRACKLES_NUMLETTERS; nCnt++)
	{
		vOrigin = g_vLetterCracklesBaseOrigins[nCnt];
		if( random() < 0.022)
		{ // Jitter
			vOrigin_x += random() * 15;
			vOrigin_y += random() * 15;
		}
		vSize = g_vLetterCracklesBaseSizes[nCnt];
		vColor_x = 0.1 + (random() * 0.9);
		drawstring(vOrigin, g_strLetterCrackleStrings[nCnt], vSize, vColor, g_fLetterCracklesAlpha, 0);
	}
}
void HUD_UpdateColorFlash()
{ // Update Color Flash
	local vector vSize;
	if(g_fColorFlashState == HUDEFFECT_STATE_STARTING)
	{
		g_fColorFlashAlpha = g_fColorFlashAlpha + (frametime * 0.95);
		if(g_fColorFlashAlpha > 0.80)
			g_fColorFlashState = HUDEFFECT_STATE_ENDING;
		
		vSize_x = g_nVideoWidth;
		vSize_y = g_nVideoHeight;
			
		drawfill('0 0 0', vSize, g_vColorFlashColor, g_fColorFlashAlpha, 0);
	}
	else
	{
		g_fColorFlashAlpha = g_fColorFlashAlpha - (frametime * 0.22);
		if(g_fColorFlashAlpha < 0)
			g_fColorFlashState = HUDEFFECT_STATE_NONE;
		
		vSize_x = g_nVideoWidth;
		vSize_y = g_nVideoHeight;
			
		drawfill('0 0 0', vSize, g_vColorFlashColor, g_fColorFlashAlpha, 0);
	}
}
void HUD_BeginColorFlash(vector vColor, float bPlaySound)
{ // Begin Color Flash
	if(g_fColorFlashState == HUDEFFECT_STATE_NONE)
	{
		// Assign State
		g_fColorFlashState = HUDEFFECT_STATE_STARTING;
		// Assign Alpha
		g_fColorFlashAlpha = 0.1;
		// Assign Color
		g_vColorFlashColor = vColor;
		
		// Play Sound
		if(bPlaySound)
		{
			if( random() < 0.5)
				localcmd("play2 ", SOUND_KLESHIK_STINGER_COLORFLASH1, "\n");
			else
				localcmd("play2 ", SOUND_KLESHIK_STINGER_COLORFLASH2, "\n");
		}
	}
}
void HUD_UpdateCreepCloud()
{
	local vector vOrigin;
	
	if(g_fCreepCloudDistance > 0)
	{ // Draw In Creep Cloud
		// Get Vectors of Local Inputs
		makevectors(input_angles);
		// Acquire Origin
		vOrigin = pmove_org;
		// Place Origin
		traceline(vOrigin, vOrigin + (v_forward * g_fCreepCloudDistance), FALSE, self);
		
		// Spawn Particles
		pointparticles( particleeffectnum("TE_BLOODSMOKE"), trace_endpos, '0 0 0', 3);
		te_bloodshower(trace_endpos, trace_endpos, 300, 30);
		
		// Draw in Creep Cloud
		g_fCreepCloudDistance = g_fCreepCloudDistance - 6.5;
		self.nextthink = time + 0.075;
	}
	else
	{ // Kill Creep Cloud
		remove(g_enCreepCloud);
		g_enCreepCloud = world;
		
		// Play Sound
		local float nRandom;
		local string strSound;
			nRandom = random();
		if(nRandom < 0.33)
			strSound = SOUND_KLESHIK_STINGER_CREEPCLOUDEND1;
		else
		if(nRandom < 0.66)
			strSound = SOUND_KLESHIK_STINGER_CREEPCLOUDEND2;
		else
			strSound = SOUND_KLESHIK_STINGER_CREEPCLOUDEND3;
			
		localcmd("play2 ", strSound, "\n");
		localcmd("play2 ", strSound, "\n");
		
		// Flash Screen Red
		HUD_BeginColorFlash('1 0 0', false);
	}
}
void HUD_BeginCreepCloud()
{ // Begin Creep Cloud
	if(!g_enCreepCloud)
	{ // Spawn Entity
		g_enCreepCloud = spawn();
		// Set Distance
		g_fCreepCloudDistance = 350;
		// Set Think
		g_enCreepCloud.think = HUD_UpdateCreepCloud;
		g_enCreepCloud.nextthink = time + 1;
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_CREEPCLOUDSTART, "\n");
		localcmd("play2 ", SOUND_KLESHIK_STINGER_CREEPCLOUDSTART, "\n");
	}
}
void HUD_UpdateEvilEvent()
{ // Update Evil Event
	local vector vLocation;
	if(g_fEvilEventState == HUDEFFECT_STATE_STARTING)
	{
		g_fEvilEventAlpha = g_fEvilEventAlpha + (frametime * 0.35);
		if(g_fEvilEventAlpha > 0.65)
			g_fEvilEventState = HUDEFFECT_STATE_ENDING;
			
		if( random() < 0.04)
		{ // Jiggle It Around
			vLocation = g_vEvilEventLocation;
			vLocation_x += random() * 12;
			vLocation_y += random() * 12;
			drawpic(vLocation, g_strEvilEventImage, g_vEvilEventSize, '0.6 0 0', g_fEvilEventAlpha, 0);
		}
		else
			drawpic(g_vEvilEventLocation, g_strEvilEventImage, g_vEvilEventSize, '0.6 0 0', g_fEvilEventAlpha, 0);
	}
	else
	{
		g_fEvilEventAlpha = g_fEvilEventAlpha - (frametime * 0.60);
		if(g_fEvilEventAlpha < 0)
			g_fEvilEventState = HUDEFFECT_STATE_NONE;
			
		if( random() < 0.04)
		{ // Jiggle It Around
			vLocation = g_vEvilEventLocation;
			vLocation_x += random() * 12;
			vLocation_y += random() * 12;
			drawpic(vLocation, g_strEvilEventImage, g_vEvilEventSize, '0.6 0 0', g_fEvilEventAlpha, 0);
		}
		else
			drawpic(g_vEvilEventLocation, g_strEvilEventImage, g_vEvilEventSize, '0.6 0 0', g_fEvilEventAlpha, 0);
	}
}
void HUD_BeginEvilEvent()
{ // Begin Evil Event
	if(g_fEvilEventState == HUDEFFECT_STATE_NONE)
	{
		// Assign State
		g_fEvilEventState = HUDEFFECT_STATE_STARTING;
		// Assign Alpha
		g_fEvilEventAlpha = 0.1;
		
		local float nRandom;
			nRandom = random();
		
		// Calculate Image and Sound
		if(nRandom < 0.33)
		{
			g_strEvilEventImage = HUDIMAGE_KLESHIK_EVILEVENT1;
			localcmd("play2 ", SOUND_KLESHIK_STINGER_EVILEVENT1, "\n");
		}
		else
		if(nRandom < 0.66)
		{
			g_strEvilEventImage = HUDIMAGE_KLESHIK_EVILEVENT2;
			localcmd("play2 ", SOUND_KLESHIK_STINGER_EVILEVENT2, "\n");
		}
		else
		{
			g_strEvilEventImage = HUDIMAGE_KLESHIK_EVILEVENT3;
			localcmd("play2 ", SOUND_KLESHIK_STINGER_EVILEVENT3, "\n");
		}
		// Calculate Location
		g_vEvilEventSize = draw_getimagesize(g_strEvilEventImage);
		g_vEvilEventLocation_x = (g_nVideoWidth - g_vEvilEventSize_x) / 2;
		g_vEvilEventLocation_y = (g_nVideoHeight - g_vEvilEventSize_y) / 2;
	}
}
void HUD_UpdateBloodWash()
{ // Update Blood Wash
	// Calculate Size
	local vector vSize;
		vSize_x = g_nVideoWidth;
		vSize_y += g_fBloodWashSizeOffset;
	// Update Size Offset
	g_fBloodWashSizeOffset = g_fBloodWashSizeOffset + (frametime * g_fBloodWashSizeMod);
	// Update Alpha
	g_fBloodWashAlpha = g_fBloodWashAlpha - (frametime * 0.45);
	
	if(g_fBloodWashAlpha > 0)
	{ // Draw
		// Forward
		drawpic('0 -50 0', HUDIMAGE_KLESHIK_BLOODWASH, vSize, g_vBloodWashColor, g_fBloodWashAlpha, 0);
	}
	else
	{ // Finished
		g_fBloodWashAlpha = 0;
		g_fBloodWashSizeOffset = 0;
	}
}
void HUD_ViewMirrorEntityThink()
{ // View Mirror Entity Think
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_VIEWMIRROR_REMOVE, "\n");
	
	// UnFlip View
	localcmd("v_flipped 0\n");
}
void HUD_BeginViewMirror()
{ // Begin View Mirror
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_VIEWMIRROR, "\n");
	
	// Flip View
	localcmd("v_flipped 1\n");
	
	// Check and Prepare Entity
	if(!g_enViewMirrorFlipController)
	{
		g_enViewMirrorFlipController = spawn();
		g_enViewMirrorFlipController.classname = "View Mirror Flip Controller";
		g_enViewMirrorFlipController.think = HUD_ViewMirrorEntityThink;
	}
	// Assign Think Time
	g_enViewMirrorFlipController.nextthink = time + 3.0 + (random() * 2);
}
void HUD_PsychoViewEntityThink()
{ // View Mirror Entity Think
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_PSYCHOVIEWEND, "\n");
	localcmd("play2 ", SOUND_KLESHIK_STINGER_PSYCHOVIEWEND, "\n");
	
	// UnFlip View
	localcmd("v_psycho 0\n");
	
	// Flash Screen
	te_customflash(pmove_org, 1000, 3, '1 0 0');
}
void HUD_BeginPsychoView()
{ // Begin Psycho View
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_PSYCHOVIEWBEGIN, "\n");
	
	// Flip View
	localcmd("v_psycho 1\n");
	
	// Check and Prepare Entity
	if(!g_enPsychoViewController)
	{
		g_enPsychoViewController = spawn();
		g_enPsychoViewController.classname = "Psycho View Controller";
		g_enPsychoViewController.think = HUD_PsychoViewEntityThink;
	}
	// Assign Think Time
	g_enPsychoViewController.nextthink = time + 5.7 + (random() * 0.3);
}
void HUD_ViewStippleEntityThink()
{ // View Mirror Entity Think
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_VIEWMIRROR_REMOVE, "\n");
	
	// UnStipple View
	localcmd("scr_stipple 0\n");
}
void HUD_BeginViewStipple()
{ // Begin View Stipple
	// Play Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_VIEWSTIPPLE, "\n");
	
	// Stipple View
	localcmd("scr_stipple 3\n");
	
	// Check and Prepare Entity
	if(!g_enViewStippleController)
	{
		g_enViewStippleController = spawn();
		g_enViewStippleController.classname = "View Stipple Controller";
		g_enViewStippleController.think = HUD_ViewStippleEntityThink;
	}
	// Assign Think Time
	g_enViewStippleController.nextthink = time + 3.0 + (random() * 2);
}
entity HUD_ViewStatic_SpawnLine()
{
	local entity enLine;
		enLine = spawn();
	// Assign Default Alpha
	enLine.alpha = random();
	// Assign Size
	enLine.velocity_x = 0.3 + (random() * 2);
	enLine.velocity_y = g_nVideoHeight;
	// Assign Default Origin
	enLine.origin_x = random() * g_nVideoWidth;
	// Assign Origin Offset
	enLine.fViewStaticLine_OriginOffset = 170 + (random() * 650);
	// Assign Direction is Right
	if( random() > 0.50)
		enLine.fViewStaticLine_DirectionIsRight = TRUE;
	else
		enLine.fViewStaticLine_DirectionIsRight = FALSE;
	
	// Return Line
	return enLine;
}
void HUD_BeginViewStatic()
{
	local float nCnt;
	
	if(g_fViewStaticState == HUDEFFECT_STATE_NONE)
	{ // No State; Begin
		// Assign State
		g_fViewStaticState = HUDEFFECT_STATE_STARTING;
		// Reset Fill Alpha
		g_fViewStaticFillAlpha = 0;
	
		// Spawn Line Controllers
		for(nCnt = 0; nCnt < HUDEFFECT_VIEWSTATIC_NUMLINES; nCnt++)
		{
			// Spawn Line Controller
			g_enViewStaticLines[nCnt] = HUD_ViewStatic_SpawnLine();
		}
		
		// Play Sound
		if(random() < 0.5)
			localcmd("play2 ", SOUND_KLESHIK_STINGER_DESATURATION1, "\n");
		else
			localcmd("play2 ", SOUND_KLESHIK_STINGER_DESATURATION2, "\n");
	}
}
void HUD_UpdateViewStatic()
{
	local float nCnt;
	local entity enLine;
	local vector vFillSize;
		vFillSize_x = g_nVideoWidth;
		vFillSize_y = g_nVideoHeight;
	if(g_fViewStaticState == HUDEFFECT_STATE_STARTING)
	{
		g_fViewStaticFillAlpha = g_fViewStaticFillAlpha + (frametime * 0.85);
		if(g_fViewStaticFillAlpha > 1.2)
			g_fViewStaticState = HUDEFFECT_STATE_ENDING;
	}
	else
	{
		g_fViewStaticFillAlpha = g_fViewStaticFillAlpha - (frametime * 0.45);
		if(g_fViewStaticFillAlpha < 0)
		{
			g_fViewStaticState = HUDEFFECT_STATE_NONE;
			// Purge Lines
			for(nCnt = 0; nCnt < HUDEFFECT_VIEWSTATIC_NUMLINES; nCnt++)
				remove(g_enViewStaticLines[nCnt]);
			// Play Sound
			localcmd("play2 ", SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATIONEND, "\n");
		}
	}
	
	// Draw Main Fill
	drawfill('0 0 0', vFillSize, '0.3 0.0 0.0', min(g_fViewStaticFillAlpha, 0.8), 0);
	
	for(nCnt = 0; nCnt < HUDEFFECT_VIEWSTATIC_NUMLINES; nCnt++)
	{ // Cycle through Lines
		// Acquire Line
		enLine = g_enViewStaticLines[nCnt];
		
		// Update Origin
		if(enLine.fViewStaticLine_DirectionIsRight)
		{
			enLine.origin_x += (frametime * enLine.fViewStaticLine_OriginOffset);
			if(enLine.origin_x > g_nVideoWidth)
				enLine.fViewStaticLine_DirectionIsRight = FALSE;
		}
		else
		{
			enLine.origin_x -= (frametime * enLine.fViewStaticLine_OriginOffset);
			if(enLine.origin_x < 0)
				enLine.fViewStaticLine_DirectionIsRight = TRUE;
		}
		
		// Update Alpha if Stinger is Ending
		if(g_fViewStaticState == HUDEFFECT_STATE_ENDING)
		{
			enLine.alpha -= (frametime * 0.35);
		}
		
		// Draw Line
		drawfill(enLine.origin, enLine.velocity, '1 0 0', enLine.alpha, 0);
	}
}
void HUD_RushFogEntityThink()
{ // Rush Fog Entity Think
	// Reverse Rush Fog
	g_fRushFogState = HUDEFFECT_STATE_ENDING;
	// Reset Density to Max
	g_fRushFogDensity = HUDEFFECT_RUSTFOG_MAXDENSITY;
	
	// Pay Sound
	localcmd("play2 ", SOUND_KLESHIK_STINGER_RUSHFOGEND, "\n");
	
	// Remove Nextthink
	self.nextthink = 0;
}
void HUD_UpdateRushFog()
{ // Update Rush Fog
	local float nRed;
		nRed = 1;
	if(g_fRushFogState == HUDEFFECT_STATE_STARTING)
	{
		g_fRushFogDensity += (frametime * 1.00);
		if(g_fRushFogDensity >= HUDEFFECT_RUSTFOG_MAXDENSITY)
		{
			// Prepare Controller Entity
			if(!g_enRushFogController.nextthink)
				g_enRushFogController.nextthink = time + 3.7;
			// Calculate Red
			nRed = 0.90 + (random() * 0.1);
		}
		// Update Fog
		localcmd("fog ", ftos( min(g_fRushFogDensity, HUDEFFECT_RUSTFOG_MAXDENSITY) ), " ", ftos(nRed), " 0 0 0.5\n");
	}
	else
	{
		g_fRushFogDensity -= (frametime * 0.75);
		if(g_fRushFogDensity < 0)
		{
			g_fRushFogDensity = 0;
			g_fRushFogState = HUDEFFECT_STATE_NONE;
			
			// Update Fluid Contents
			UpdateFluidContents(true);
		}
		else
			// Update Fog
			localcmd("fog ", ftos( min(g_fRushFogDensity, HUDEFFECT_RUSTFOG_MAXDENSITY) ), " 1 0 0 0.5\n");
	}
}
void HUD_BeginRushFog()
{ // Begin Rush Fog
	if(g_fRushFogState == HUDEFFECT_STATE_NONE)
	{
		// Assign State
		g_fRushFogState = HUDEFFECT_STATE_STARTING;
		// Assign Mod
		g_fRushFogDensity = 0.01;
		
		// Check and Prepare Entity
		if(!g_enRushFogController)
		{
			g_enRushFogController = spawn();
			g_enRushFogController.classname = "RushFog Controller";
			g_enRushFogController.think = HUD_RushFogEntityThink;
		}
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_RUSHFOGSTART, "\n");
	}
}
void HUD_ViewShakeEntityThink()
{ // View Shake Entity Think
	// Stop View Shake
	localcmd("v_ipitch_cycle 1\n");
}
void HUD_BeginViewShake(float tTime)
{ // Begin View Shake
	if(tTime > 0)
	{ // Valid End Time
		// Begin View Shake
		localcmd("v_ipitch_cycle 55\n");
		
		// Check and Prepare Entity
		if(!g_enViewShakeController)
		{
			g_enViewShakeController = spawn();
			g_enViewShakeController.classname = "View Shake Controller";
			g_enViewShakeController.think = HUD_ViewShakeEntityThink;
		}
		// Assign Think Time
		g_enViewShakeController.nextthink = time + tTime;
	}
}
void HUD_UpdateTunnelVision()
{ // Update Tunnel Vision
	// Acquire Current Field of View
	local float fFov;
		fFov = SG_AUTOCVAR(fov);
	if(g_fTunnelVisionState == HUDEFFECT_STATE_STARTING)
	{
		g_fTunnelVisionMod += (frametime * 17);
		if(fFov + g_fTunnelVisionMod > 168)
		{
			g_fTunnelVisionMod = 168 - fFov;
			g_fTunnelVisionState = HUDEFFECT_STATE_ENDING;
			// Play Sound
			localcmd("play2 ", SOUND_KLESHIK_STINGER_VIEWMIRROR_REMOVE, "\n");
		}
	}
	else
	{
		g_fTunnelVisionMod -= (frametime * 220);
		if(g_fTunnelVisionMod < 0)
		{
			g_fTunnelVisionMod = 0;
			g_fTunnelVisionState = HUDEFFECT_STATE_NONE;
		}
	}
	// Update Field of View
	setproperty(g_nTunnelVisionFOV, fFov + g_fTunnelVisionMod);
}
void HUD_BeginTunnelVision()
{ // Begin Tunnel Vision
	if(g_fTunnelVisionState == HUDEFFECT_STATE_NONE)
	{
		// Assign State
		g_fTunnelVisionState = HUDEFFECT_STATE_STARTING;
		// Assign Mod
		g_fTunnelVisionMod = 0;
		
		// Assign FOV to Modify
		if( random() < 0.5)
			g_nTunnelVisionFOV = VF_FOVX;
		else
			// Always Using X for Now
			g_nTunnelVisionFOV = VF_FOVX;
			// g_nTunnelVisionFOV = VF_FOVY;
		
		// Play Sound
		localcmd("play2 ", SOUND_KLESHIK_STINGER_TUNNELVISION, "\n");
	}
}
/*
// DEPRECATED
void HUD_UpdateDesaturation()
{ // Update Desaturation
	if(g_fDesaturationState == HUDEFFECT_STATE_STARTING)
	{
		g_fDesaturationMod += (frametime * 20);
		
		if(g_fDesaturationMod > 40)
		{
			g_fDesaturationState = HUDEFFECT_STATE_ENDING;
		}
	}
	else
	{
		g_fDesaturationMod -= (frametime * 30);
		
		if(g_fDesaturationMod < 0)
		{
			g_fDesaturationMod = 0;
			g_fDesaturationState = HUDEFFECT_STATE_NONE;
			// Disable Base Post Process CVars
			localcmd("r_glsl_postprocess 0\n");
			// Play Sound
			localcmd("play2 ", SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATIONEND, "\n");
		}
	}
	
	// Update Desaturation
	localcmd("r_glsl_postprocess_uservec1 \"1 0 0 ", ftos(g_fDesaturationMod), "\"\n");
}
void HUD_BeginDesaturation()
{ // Begin Desaturation
	if(g_fDesaturationState == HUDEFFECT_STATE_NONE)
	{
		// Assign State
		g_fDesaturationState = HUDEFFECT_STATE_STARTING;
		// Assign Mod
		g_fDesaturationMod = 0;
		
		// Update Base Post Process CVars
		localcmd("r_glsl_postprocess 1\n");
		localcmd("r_glsl_postprocess_uservec1 \"1 0 0 0\"\n");
		
		// Play Sound
		if(random() < 0.5)
			localcmd("play2 ", SOUND_KLESHIK_STINGER_DESATURATION1, "\n");
		else
			localcmd("play2 ", SOUND_KLESHIK_STINGER_DESATURATION2, "\n");
	}
}
*/
void HUD_UpdateMapNameDisplay()
{ // Update Map Name Display
	if(g_fMapNameDisplayState == HUDEFFECT_STATE_STARTING)
	{
		g_fMapNameDisplayAlpha += (frametime * 0.25);
		
		if(g_fMapNameDisplayAlpha > 1)
		{
			g_fMapNameDisplayState = HUDEFFECT_STATE_ENDING;
			g_fMapNameDisplayAlpha = 1;
		}
	}
	else
	{
		g_fMapNameDisplayAlpha -= (frametime * 0.38);
		
		if(g_fMapNameDisplayAlpha < 0)
		{
			g_fMapNameDisplayState = HUDEFFECT_STATE_NONE;
			g_fMapNameDisplayAlpha = 0;
		}
	}
	
	if( random() < 0.03)
	{ // Jiggle It Around
		local vector vLocation;
		vLocation = g_vMapNameDisplayLocation;
		vLocation_x += random() * 4;
		vLocation_y += random() * 4;
		
		// Draw Map Name
		drawstring(vLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
	}
	else
		// Draw Map Name
		drawstring(g_vMapNameDisplayLocation, world.message, g_vMapNameDisplaySize, '1 0 0', g_fMapNameDisplayAlpha, 0);
}
void HUD_BeginMapNameDisplay()
{ // Begin Map Name Display
	if(g_fMapNameDisplayState == HUDEFFECT_STATE_NONE)
	{
		// Calculate Location (do it here, instead of in the update)
		// Calculate Pixel Width of Display
		local float nWidth;
			nWidth = strlen(world.message) * 20;
			if(nWidth > g_nVideoWidth)
			{ // Too Large; Shrink it Big Time
				g_vMapNameDisplaySize_x = 13;
				nWidth = strlen(world.message) * 13;
			}
			else
				g_vMapNameDisplaySize_x = 20;
			g_vMapNameDisplaySize_y = g_vMapNameDisplaySize_x;
			g_vMapNameDisplaySize_z = 0;
			
		// Determine Center Point
		g_vMapNameDisplayLocation_x = (g_nVideoWidth - nWidth) / 2;
		
		// Assign Relative Coords
		g_vMapNameDisplayLocation_y = g_nVideoHeight / 4.5;
		g_vMapNameDisplayLocation_z = 0;
		// Assign State
		g_fMapNameDisplayState = HUDEFFECT_STATE_STARTING;
		// Assign Alpha
		g_fMapNameDisplayAlpha = 0;
		
		// Play Sound
		local float nRandom;
			nRandom = random();
		if(nRandom < 0.33)
			localcmd("play2 ", SOUND_KLESHIK_STINGER_MAPDISPLAY1, "\n");
		else
		if(nRandom < 0.66)
			localcmd("play2 ", SOUND_KLESHIK_STINGER_MAPDISPLAY2, "\n");
		else
			localcmd("play2 ", SOUND_KLESHIK_STINGER_MAPDISPLAY3, "\n");
	}
}