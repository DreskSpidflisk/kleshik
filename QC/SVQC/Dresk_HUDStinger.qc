// DRESK
// HUD Stinger Support

// Definitions
#define HUDSTINGER_PENTAGRAM_TIME								1.0

#define HUDSTINGER_THINKTIME									time + 60 + (random() * 120)

// Fields
.entity		enHUDStinger_Pentagram;

// entity		g_enHUDStingerController_BloodWash;
// entity		g_enHUDStingerController_ViewMirror;
entity		g_enRandomHUDStingerController;

// Functions
void HUDStinger_Pentagram_Think()
{ // HUD Stinger - Think
	// Assign NODRAW Effect
	self.effects = self.effects | EF_NODRAW;
}
void ApplyHUDStinger_Pentagram(entity enEntity)
{ // Apply HUD Stinger
	if(!enEntity.enHUDStinger_Pentagram)
	{ // Spawn
		enEntity.enHUDStinger_Pentagram = spawn();
		// Assign Model
		setmodel(enEntity.enHUDStinger_Pentagram, "progs/invulner.mdl");
		// Assign Solidity
		enEntity.enHUDStinger_Pentagram.solid = SOLID_NOT;
		// Assign View Model
		enEntity.enHUDStinger_Pentagram.viewmodelforclient = enEntity;
		// Assign Origin
		enEntity.enHUDStinger_Pentagram.origin = '22 0 -17';
		// Assign Angles
		enEntity.enHUDStinger_Pentagram.angles = '0 0 0';
		// Assign Effects
		enEntity.enHUDStinger_Pentagram.effects = EF_FULLBRIGHT | EF_NOGUNBOB;
		// Assign Alpha
		enEntity.enHUDStinger_Pentagram.alpha = 0.50;
	}
	else
		// Remove NODRAW Effect
		enEntity.enHUDStinger_Pentagram.effects = enEntity.enHUDStinger_Pentagram.effects - (enEntity.enHUDStinger_Pentagram.effects & EF_NODRAW);
		
	// Assign Think Operation
	enEntity.enHUDStinger_Pentagram.think = HUDStinger_Pentagram_Think;
	enEntity.enHUDStinger_Pentagram.nextthink = time + HUDSTINGER_PENTAGRAM_TIME;
}
void ApplyHUDStingerToAllPlayers_Pentagram()
{ // Apply HUD Stinger to All Players - Pentagram
	// Cycle through Players
	local entity enPlayer;
	
	enPlayer = find(world, classname, "player");
	
	while(enPlayer != world)
	{ // Valid Player
		// Apply HUD Stinger
		ApplyHUDStinger_Pentagram(enPlayer);
		
		// Acquire Next Player
		enPlayer = find(enPlayer, classname, "player");
	}
	
	// Play Sound
	sound(world, CHAN_AUTO, SOUND_KLESHIK_STINGER_PENTAGRAM, 1, ATTN_NONE);
}
void ApplyHUDStingerToAllPlayers_ClientCommand(string strCommand)
{ // Apply HUD Stinger to All Players - White Flash
	// Create String
	local string strCmd;
		strCmd = strcat(strCommand, "\n");
	// Cycle through Players
	local entity enPlayer;
	
	enPlayer = find(world, classname, "player");
	
	while(enPlayer != world)
	{ // Valid Player
		// Apply HUD Stinger
		stuffcmd(enPlayer, strCmd);
		
		// Acquire Next Player
		enPlayer = find(enPlayer, classname, "player");
	}
}
void ApplyRandomHUDStingerToAllPlayers()
{ // Apply Random HUD Stinger to All Players
	if( !intermission_running && cvar(CVAR_WORLD_ENABLERANDOMHUDSTINGERS) )
	{ // Random HUD Stingers Enabled
		local float nRandom;
			nRandom = random() * 11;
		if(nRandom < 1)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_BLOODWASH);
		else
		if(nRandom < 2)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWMIRROR);
		else
		if(nRandom < 3)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_COLORFLASH);
		else
		if(nRandom < 4)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_TUNNELVISION);
		else
		if(nRandom < 5)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTIPPLE);
		else
		if(nRandom < 6)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_RUSHFOG);
		else
		if(nRandom < 7)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_VIEWSTATIC);
		else
		if(nRandom < 8)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_GHOSTGIBS);
		else
		if(nRandom < 9)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_LETTERCRACKLES);
		else
		if(nRandom < 10)
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_CREEPCLOUD);
		else
			ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_PSYCHOVIEW);
	}
		
	self.nextthink = HUDSTINGER_THINKTIME;
}
/*
void PrepareBloodWashHUDStingerEntity()
{ // Prepare Blood Wash HUD Stinger Entity
	g_enHUDStingerController_BloodWash = spawn();
	g_enHUDStingerController_BloodWash.effects = EF_NODRAW;
	g_enHUDStingerController_BloodWash.classname = "Blood Wash HUD Stinger";
	g_enHUDStingerController_BloodWash.think = ApplyHUDStingerToAllPlayers_BloodWash;
	g_enHUDStingerController_BloodWash.nextthink = time + 60 + (random() * 60);
}
void PrepareViewMirrorHUDStingerEntity()
{ // Prepare Blood Wash HUD Stinger Entity
	g_enHUDStingerController_ViewMirror = spawn();
	g_enHUDStingerController_ViewMirror.effects = EF_NODRAW;
	g_enHUDStingerController_ViewMirror.classname = "View Mirror HUD Stinger";
	g_enHUDStingerController_ViewMirror.think = ApplyHUDStingerToAllPlayers_ViewMirror;
	g_enHUDStingerController_ViewMirror.nextthink = time + 120 + (random() * 120);
}
*/
void PrepareRandomHUDStingerEntity()
{ // Prepare Random HUD Stinger Entity
	g_enRandomHUDStingerController = spawn();
	g_enRandomHUDStingerController.effects = EF_NODRAW;
	g_enRandomHUDStingerController.classname = "Random HUD Stinger";
	g_enRandomHUDStingerController.think = ApplyRandomHUDStingerToAllPlayers;
	g_enRandomHUDStingerController.nextthink = HUDSTINGER_THINKTIME;
}