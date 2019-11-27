// DRESK - Player Death
// Provides definitions and default values for Player Death features.

// Player Death Light Pulsations Removed
/*
#define PLAYERDEATH_LIGHTPULSATION_TIME							1.8
#define PLAYERDEATH_LIGHTPULSATION_STRING_1						"aaaakk"
#define PLAYERDEATH_LIGHTPULSATION_STRING_2						"aaaaaaaz"
#define PLAYERDEATH_LIGHTPULSATION_STRING_3						"zzza"
#define PLAYERDEATH_LIGHTPULSATION_STRING_4						"zanhsa"
*/

// Fields

// Functions
/*
void PlayerDeath_CheckLightPulsation()
{ // Player Death - Check Light Pulsation
	// Check for Current Pulsation
	if( !GetIsWorldLightPulsationActive() )
	{ // Available Pulsation
		local string strPulsation;
		local string strSound;
			strSound = "";
		local float tSoundTime;
		// Acquire Random Number
		local float fRandom;
			fRandom = random();
		// Invoke Pulsation
		if(fRandom >= 0.25)
			strPulsation = PLAYERDEATH_LIGHTPULSATION_STRING_1;
		else
		if(fRandom >= 0.50)
			strPulsation = PLAYERDEATH_LIGHTPULSATION_STRING_2;
		else
		if(fRandom >= 0.75)
			strPulsation = PLAYERDEATH_LIGHTPULSATION_STRING_3;
		else
			strPulsation = PLAYERDEATH_LIGHTPULSATION_STRING_4;
			
		if( random() >= 0.80)
		{ // Play Sound
			if( random() > 0.50)
				strSound = SOUND_KLESHIK_AMBIENT_EVENTS_PLAYERDEATHLIGHTPULSATION1;
			else
				strSound = SOUND_KLESHIK_AMBIENT_EVENTS_PLAYERDEATHLIGHTPULSATION2;
			tSoundTime = 0.5;
		}
			
		// Activate Pulsation
		ActivateWorldLightPulsation(strPulsation, PLAYERDEATH_LIGHTPULSATION_TIME + ( random() ), strSound, tSoundTime);
	}
}
*/

void PlayerDeath_ApplyBloodExplosionToAllPlayers()
{ // Player Death - Check Blood Explosion
	// Cycle through Players
	local entity enPlayer;
	
	enPlayer = find(world, classname, "player");
	
	while(enPlayer != world)
	{ // Valid Player
		if(enPlayer.deadflag == DEAD_NO)
		{ // Player Alive
			// Create Bloodshower
			if(!enPlayer.bBleedsSparks)
				te_bloodshower (enPlayer.origin + enPlayer.mins, enPlayer.origin + enPlayer.maxs, 1200, 150);
			// Apply Punchangle
			enPlayer.punchangle = enPlayer.punchangle + '8 8 8';
		}
	
		// Acquire Next Player
		enPlayer = find(enPlayer, classname, "player");
	}
	
	// Play Sound
	// sound(world, CHAN_AUTO, "player/tornoff2.wav", 1, ATTN_NONE);
}
void PlayerDeath_CheckEntityBecomesEliteMonster(entity enEntity)
{ // Player Death - Check Entity Becomes Elite Monster
	// Check Monster Becomes Elite
	if(enEntity.flags & FL_MONSTER && !enEntity.bIsEliteMonster && !enEntity.bCannotBecomeEliteMonster && enEntity.health > 0)
	{ // Valid Potential Monster
		local float fPercentChance;
		// Acquire Monster Bonus Percent Chance
		fPercentChance = cvar(CVAR_PLAYERDEATH_ELITEMONSTERPERCENTCHANCE);
			// Recompute Percentile
			fPercentChance = 1.0 - (fPercentChance / 100);
		
		if( random() >= fPercentChance)
			// Assign Elite Monster Attributes
			AssignEliteMonsterAttributes(enEntity);
	}
}
void PlayerDeath_CheckDeathFeedback(float bRespawning, entity enKiller)
{ // Player Death - Check Death Feedback
	local float fPercentChance;
	
	if(bRespawning)
	{ // Player Respawning
		// Acquire HUD Stinger Percent Chance
			fPercentChance = cvar(CVAR_PLAYERDEATH_HUDSTINGERPERCENTCHANCE);
			// Recompute Percentile
			fPercentChance = 1.0 - (fPercentChance / 100);
			
		if( random() >= fPercentChance)
			// Apply HUD Stinger
			ApplyHUDStingerToAllPlayers_Pentagram();
	}
	else
	{ // Player Died
		// Check Light Pulsation
		/*
		if( cvar(CVAR_PLAYERDEATH_USELIGHTPULSATION) )
			PlayerDeath_CheckLightPulsation();
		*/
		// Apply HUD Stinger
		// ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_DESATURATION);
			
		// Check Blood Explosion
			// Acquire Percent Chance
			fPercentChance = cvar(CVAR_PLAYERDEATH_BLOODEXPLOSIONPERCENTCHANCE);
			// Recompute Percentile
			fPercentChance = 1.0 - (fPercentChance / 100);
		if( random() >= fPercentChance)
			PlayerDeath_ApplyBloodExplosionToAllPlayers();
		
		// Check Elite Monster
		PlayerDeath_CheckEntityBecomesEliteMonster(enKiller);
	}
}