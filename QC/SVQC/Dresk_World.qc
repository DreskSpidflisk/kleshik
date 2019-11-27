// DRESK - World
// Provides definitions and default values for new World features.

// Fields
.float		bHasWaterFog;
entity		g_enNightAndDayLightEntity;
.float		nNightAndDayLightEntityLightLevel;
.string		strNightAndDayLightString;
.float		bNightAndDayLightEntityIncrementing;
float		g_nNightAndDayMinLightLevel;
float		g_nNightAndDayMaxLightLevel;

void NightAndDayLightEntityThink()
{ // Night and Day Light Entity Think
	if(self.bNightAndDayLightEntityIncrementing)
	{ // Increment Light
		self.nNightAndDayLightEntityLightLevel++;
		if(self.nNightAndDayLightEntityLightLevel > g_nNightAndDayMaxLightLevel)
		{ // Reached Peak
			self.nNightAndDayLightEntityLightLevel = g_nNightAndDayMaxLightLevel - 1;
			self.bNightAndDayLightEntityIncrementing = FALSE;
		}
	}
	else
	{ // Decrement Light
		self.nNightAndDayLightEntityLightLevel = self.nNightAndDayLightEntityLightLevel - 1;
		
		if(self.nNightAndDayLightEntityLightLevel < g_nNightAndDayMinLightLevel)
		{ // Reached Slump
			self.nNightAndDayLightEntityLightLevel = g_nNightAndDayMinLightLevel;
			self.bNightAndDayLightEntityIncrementing = TRUE;
		}
	}
	
	local string strSound;
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		strSound = SOUND_KLESHIK_AMBIENCE_DAYANDNIGHTADJUST1;
	else
	if(nRandom < 0.66)
		strSound = SOUND_KLESHIK_AMBIENCE_DAYANDNIGHTADJUST2;
	else
		strSound = SOUND_KLESHIK_AMBIENCE_DAYANDNIGHTADJUST3;
	sound(world, CHAN_AUTO, strSound, 1, ATTN_NONE);
	sound(world, CHAN_AUTO, strSound, 1, ATTN_NONE);
	
	if( !GetIsWorldLightPulsationActive() )
	{ // No Light Pulsation Active; Update
		// bprint("Assigning New Lightstyle : ", substring(self.strNightAndDayLightString, self.nNightAndDayLightEntityLightLevel, 1), "\n");
		// Assign Lightstyle
		lightstyle(0, substring(self.strNightAndDayLightString, self.nNightAndDayLightEntityLightLevel, 1) );
	}
	
	self.nextthink = time + SG_AUTOCVAR(kleshik_server_world_NightAndDay_ChangeInterval);
}
void PrepareNightAndDayLightEntity()
{ // Prepare Night and Day Light Entity
	if( SG_AUTOCVAR(kleshik_server_world_NightAndDay_ChangeInterval) > 0)
	{ // Night and Day Entity Enabled
		// Sanitize Light Levels (if needed)
		if(g_nNightAndDayMaxLightLevel > 25)
			g_nNightAndDayMaxLightLevel = 25;
		if(g_nNightAndDayMinLightLevel < 0)
			g_nNightAndDayMinLightLevel = 1;
		if(g_nNightAndDayMaxLightLevel < g_nNightAndDayMinLightLevel)
			g_nNightAndDayMaxLightLevel = g_nNightAndDayMinLightLevel;
		if(g_nNightAndDayMinLightLevel > g_nNightAndDayMaxLightLevel)
			g_nNightAndDayMinLightLevel = g_nNightAndDayMaxLightLevel;
		if(!g_enNightAndDayLightEntity)
		{ // Spawn Entity
			g_enNightAndDayLightEntity = spawn();
			g_enNightAndDayLightEntity.effects = EF_NODRAW;
			g_enNightAndDayLightEntity.think = NightAndDayLightEntityThink;
			g_enNightAndDayLightEntity.nNightAndDayLightEntityLightLevel = g_nNightAndDayMaxLightLevel;
			g_enNightAndDayLightEntity.strNightAndDayLightString = "abcdefghijklmnopqrstuvwxyz";
			g_enNightAndDayLightEntity.nextthink = time + 0.5;
		}
	}
}