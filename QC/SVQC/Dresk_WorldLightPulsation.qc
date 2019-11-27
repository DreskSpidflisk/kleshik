// DRESK
// World Light Pulsation Support

// Definitions
#define LIGHTPULSATION_DARKNESS						"aaacdgigdc"

// Fields
float		g_tWorldLightPulsation_LightPulsationEndTime;
float		g_bWorldLightPulsation_LightPulsationActive;
float		g_tWorldLightPulsation_LightPulsationSoundTime;
string		g_strWorldLightPulsation_LightPulsationSound;

entity		g_enDarknessLightPulsation;

// Functions
float GetIsWorldLightPulsationActive()
{ // Return is World Light Pulsation Active
	if(g_bWorldLightPulsation_LightPulsationActive)
		return TRUE;
	else
		return FALSE;
}
void ActivateWorldLightPulsation(string strPulsationString, float tPulsationTime, string strPulsationSound, float tPulsationSoundTime)
{ // Activate World Light Pulsation
	if( !cvar(CVAR_WORLD_DISABLEALLDYNAMICLIGHTPULSATIONS) )
	{ // Light Pulsations Allowed
		// Assign Lightstyle
		lightstyle(0, strPulsationString);
		
		// Assign Purge Time
		g_tWorldLightPulsation_LightPulsationEndTime = time + tPulsationTime;
		// Assign Active
		g_bWorldLightPulsation_LightPulsationActive = TRUE;
		
		// Shake View
		local string strCommand;
			strCommand = strcat(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSHAKE, " ", ftos(tPulsationTime) );
		ApplyHUDStingerToAllPlayers_ClientCommand(strCommand);
		
		if(strPulsationSound != "")
		{ // Pulsation Sound Provided
			if(tPulsationSoundTime == 0)
			{ // Play Sound Immediately
				sound(world, CHAN_AUTO, strPulsationSound, 1, ATTN_NONE);
				g_tWorldLightPulsation_LightPulsationSoundTime = 0;
			}
			else
			{ // Delay Sound
				// Assign Sound Time
				g_tWorldLightPulsation_LightPulsationSoundTime = time + tPulsationSoundTime;
				// Assign Sound
				g_strWorldLightPulsation_LightPulsationSound = strPulsationSound;
			}
		}
	}
}
void DarknessLightPulsationThink()
{ // Darkness Light Pulsation
	local string strSound;
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.20)
		strSound = SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATION1;
	else
	if(nRandom < 0.40)
		strSound = SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATION2;
	else
	if(nRandom < 0.60)
		strSound = SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATION3;
	else
	if(nRandom < 0.80)
		strSound = SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATION4;
	else
		strSound = SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATION5;
		
	if( cvar(CVAR_WORLD_ENABLERANDOMWORLDLIGHTPULSATIONS) )
		// Activate Light Pulsation (regardless of current)
		ActivateWorldLightPulsation(LIGHTPULSATION_DARKNESS, 3.5, strSound, 0);
	
	// Assign Next Think Time
	g_enDarknessLightPulsation.nextthink = time + 80 + ( random() * 120);
}
void PrepareDarknessLightPulsationEntity()
{ // Prepare Darkness Light Pulsation Entity
	g_enDarknessLightPulsation = spawn();
	g_enDarknessLightPulsation.effects = EF_NODRAW;
	g_enDarknessLightPulsation.think = DarknessLightPulsationThink;
	
	// Assign Next Think Time
	g_enDarknessLightPulsation.nextthink = time + 80 + ( random() * 120);
}