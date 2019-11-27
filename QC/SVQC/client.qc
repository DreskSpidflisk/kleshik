/*
=============================================================================

				LEVEL CHANGING / INTERMISSION

=============================================================================
*/

/*QUAKED info_intermission (1 0.5 0.5) (-16 -16 -16) (16 16 16)
This is the camera point for the intermission.
Use mangle instead of angle, so you can set pitch or roll as well as yaw.  'pitch roll yaw'
*/

void info_intermission()
{
}
void SetChangeParms()
{
	if (self.health <= 0 || deathmatch)
	{
		SetNewParms ();
		return;
	}

	// DRESK
	// Remove Keys
	self.nCSQCStat_Keys = 0;
	// self.items = self.items - (self.items & (ITEM_KEY1 | ITEM_KEY2) );
	
	// DRESK
	// Remove Powerups
	self.nCSQCStat_Powerups = 0;
	// DRESK - HIPNOTIC SUPPORT
	self.gravity = 1.0;
	
	// DRESK
	// Check for Refill Health and Armor
	local float nRefillHealthArmor;
		nRefillHealthArmor = cvar(CVAR_COOP_REFILLHEALTHANDARMOREVERYLEVEL);
		
	if(nRefillHealthArmor)
		self.health = 100;
	else
	{ // Standard Behavior
		// cap super health
		if (self.health > 100)
			self.health = 100;
		if (self.health < 50)
			self.health = 50;
	}
	if(nRefillHealthArmor)
	{ // Refill Armor Value
		self.armorvalue = self.nCurrentArmorMaxArmorValue;
	}
	else
	{ // Reset Armor Values
		self.items = self.items - (self.items & (ITEM_ARMOR1 | ITEM_ARMOR2 | ITEM_ARMOR3));
		self.armorvalue = 0;
	}
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.armorvalue;
	if (self.ammo_shells < 25)
		parm4 = 25;
	else
		parm4 = self.ammo_shells;
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.weapon;
	
	// DRESK
	parm9 = self.nCSQCStat_Weapons;
	// Support Cooperative Transition Frags
	if(!deathmatch)
		// Assign Current Frag Count
		parm10 = self.frags;
	else
		parm10 = 0;
		
	// Support Initial Help Displayed
	parm11 = self.bInitialHelpDisplayed;
}

void SetNewParms()
{
	parm1 = 0;
	parm2 = 100;
	parm3 = 0;
	parm4 = g_fStartingAmmo[AMMOTYPE_SHELLS];
	parm5 = g_fStartingAmmo[AMMOTYPE_NAILS];
	parm6 = g_fStartingAmmo[AMMOTYPE_ROCKETS];
	parm7 = g_fStartingAmmo[AMMOTYPE_CELLS];
	parm8 = WEAPON_SHOTGUN;
	parm9 = g_nStartingWeapons;
	
	// DRESK
	// Support Cooperative Transition Frags
	// Reset Frag Count for New Episode
	parm10 = 0;
	
	// Still Utilize Initial Help Displayed if Possible
	parm11 = self.bInitialHelpDisplayed;
}
void DecodeLevelParms()
{
	// DRESK
	// Suppress Check for Runes
	// if (serverflags)
	{
		// DRESK
		// Utilize Initial Help Displayed Prior to Reset
		self.bInitialHelpDisplayed = parm11;
		
		if (world.model == "maps/start.bsp")
			SetNewParms ();		// take away all stuff on starting new episode
		// DRESK - HIPNOTIC SUPPORT
		else
		if (world.model == "maps/hip1m1.bsp")
			SetNewParms ();      // take away all stuff on starting new episode
		else
		if (world.model == "maps/hip2m1.bsp")
			SetNewParms ();      // take away all stuff on starting new episode
		else
		if (world.model == "maps/hip3m1.bsp")
			SetNewParms ();      // take away all stuff on starting new episode
		// DRESK - TRAVAIL SUPPORT
		#ifdef COMPILE_MODSUPPORT_TRAVAIL
		else
		if(g_bTravailEnabled && world.items & 1)
			// Reset Items
			SetNewParms();
		#endif
	}
	
	self.items = parm1;
	self.health = parm2;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.weapon = parm8;
	UpdateCurrentWeaponEntity(self);
	
	// DRESK
	// Use Parm9 for Weapons
	self.nCSQCStat_Weapons = parm9;
	
	
	// DRESK
	// Check if Armor Should be Assigned
	if(!self.bNewLevelArmorAssigned)
	{ // Assign Armor
		self.armorvalue = parm3;
		// Decode Armor Type from Items
		DecodeArmorTypeFromItems(self);
		
		// Toggle Armor Assigned
		self.bNewLevelArmorAssigned = TRUE;
	}
	
	// Support Cooperative Transition Frags
	if(!self.bFragsSetAtTransition)
	{ // Frags not set yet; Assign
		self.frags = parm10;
		self.bFragsSetAtTransition = TRUE;
	}
	
	// Support Initial Help Displayed
	self.bInitialHelpDisplayed = parm11;
}

/*
============
FindIntermission

Returns the entity to view from
============
*/
entity FindIntermission()
{
	local	entity spot;
	local	float cyc;

// look for info_intermission first
	spot = find (world, classname, "info_intermission");
	if (spot)
	{	// pick a random one
		cyc = random() * 4;
		while (cyc > 1)
		{
			spot = find (spot, classname, "info_intermission");
			if (!spot)
				spot = find (spot, classname, "info_intermission");
			cyc = cyc - 1;
		}
		return spot;
	}

// then look for the start position
	spot = find (world, classname, "info_player_start");
	if (spot)
		return spot;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
	
	objerror ("FindIntermission: no spot");
	// DRESK
	// No intermission?  Return world!
	return world;
};


string nextmap;
// DRESK
// C-STYLE FUNCTION SYNTAX
void GotoNextMap()
{
	if (cvar("samelevel"))	// if samelevel is set, stay on same level
		changelevel (mapname);
	else
		changelevel (nextmap);
}


// DRESK
// C-STYLE FUNCTION SYNTAX
void ExitIntermission()
{
// skip any text in deathmatch
	if (deathmatch)
	{
		GotoNextMap ();
		return;
	}
	
	intermission_exittime = time + 1;
	intermission_running = intermission_running + 1;
	
	// DRESK
	// Play Sound
	sound (world, CHAN_AUTO, "sound/misc/menu2.wav", 1, ATTN_NONE);

//
// run some text if at the end of an episode
//
	if (intermission_running == 2)
	{
		// DRESK
		// Support Advanced Statistics at Intermission
		if(!intermission_bViewedAdvancedStats && cvar(CVAR_MISC_ADVANCEDSTATISTICSATINTERMISSION) )
		{ // Advanced Statistics Enabled
			// Flag Advanced Stats Viewed
			intermission_bViewedAdvancedStats = TRUE;
			// Reset Intermission Running
			intermission_running = 1;
			
			WriteByte (MSG_ALL, SVC_FINALE);
			PrintAdvancedStatistics(world, TRUE);
			return;
		}
		// Dresk Client Scores
		else
		if(!intermission_bViewedClientScores && cvar(CVAR_MISC_PLAYERSCORESATINTERMISSION) )
		{ // Player Scores Enabled
			// Flag Client Scores Viewed
			intermission_bViewedClientScores = TRUE;
			// Reset Intermission Running
			intermission_running = 1;
			
			WriteByte (MSG_ALL, SVC_FINALE);
			PrintClientScoring(world, TRUE);
			return;
		}
		else
		if (world.model == "maps/e1m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			if (!cvar("registered"))
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in the other three\nhaunted lands of Quake. Or are you? If\nyou don't register Quake, you'll never\nknow what awaits you in the Realm of\nBlack Magic, the Netherworld, and the\nElder World!");
			}
			else
			{
				WriteByte (MSG_ALL, SVC_FINALE);
				WriteString (MSG_ALL, "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!");
			}
			return;
		}
		else if (world.model == "maps/e2m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.");
			return;
		}
		else if (world.model == "maps/e3m6.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.");
			return;
		}
		else if (world.model == "maps/e4m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);

			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.");
			return;
		}
		// ********************************************
		// DRESK - HIPNOTIC SUPPORT
		else if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 6);
			WriteByte (MSG_ALL, 3);
			
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Deep within the bowels of the\nResearch Facility, you discover the\npassage that the followers of Quake\nhave used to enter our world.\nThe bastards used some type of\ngigantic teleporter to overload\none of our own slipgates!  As long as\nthis portal exists, Earth will never\nbe safe from Quake's cruel minions." );
			return;
		}
		else if (world.model == "maps/hip2m5.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 6);
			WriteByte (MSG_ALL, 3);
			
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "After destroying the power generator,\nyou pass beyond the gate of Mortum's\nKeep.  A wave of nausea suddenly flows\nover you and you find yourself cast\nout into a liquid void.  You float\nlifelessly, yet aware, in a lavender\nsea of energy." );
			return;
		}
		else if (world.model == "maps/hipend.bsp")
		{
			WriteByte (MSG_ALL, SVC_CDTRACK);
			WriteByte (MSG_ALL, 2);
			WriteByte (MSG_ALL, 3);
			
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "After the last echoes of Armagon's\ndeath yell fade away, you breathe a\nheavy sigh of relief.  With the loss\nof his magic, Armagon's fortress\nbegins to collapse.  The rift he\ncreated to send his grisly troops\nthrough time slowly closes and seals\nitself forever.  In the chaos that\nensues, a wall collapses, revealing\none remaining time portal.  With your\nchances to escape rapidly growing\nslim, you race for the portal,\nmindless of your destination.  In a\nflash of light, you find yourself\nback at Command HQ, safe and sound." );
			return;
		}
		// DRESK - END HIPNOTIC SUPPORT
		// ********************************************
		
		// ********************************************
		// DRESK - ROGUE SUPPORT
		else if (world.model == "maps/r1m7.bsp")
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Victory! The Overlord's mangled\nremains are the evidence.  His evil\nWrath army?  Cast out to wander\naimlessly throughout time.\n\nAs the Slipgate fog surrounds you,\nthoughts rage into your consciousness:\nHas Quake's oppressive reign ended?\nIs it Salvation, or Damnation, which\nwaits beyond the Vortex?\n\nAnother thought, not quite your own,\nrazors through the haze.  \"Forgiveness\ncan yet be granted; Our Master remains\nto absolve your sins against his Chosen.\nFall down upon your knees-pray for\nQuake's mercy.\"");
			return;
		}
		// DRESK - END ROGUE SUPPORT
		// ********************************************

		GotoNextMap();
	}
	
	if (intermission_running == 3)
	{
		if (!cvar("registered"))
		{	// shareware episode has been completed, go to sell screen
			WriteByte (MSG_ALL, SVC_SELLSCREEN);
			return;
		}
		
		if ( (serverflags&15) == 15)
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.");
			return;
		}
		// ********************************************
		// DRESK - HIPNOTIC SUPPORT
		if (world.model == "maps/hip1m4.bsp")
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "If you can find the source of the\nportal's power, you can shut it\ndown--possibly forever!  With only a\nmoment's consideration for your own\nsafety, you re-enter the dark domain,\nknowing Hell would be a better fate\nthan experiencing the reign of Quake." );
			return;
		}
		else if (world.model == "maps/hip2m5.bsp")
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "After what seems like an eternity,\nyou feel the presence of a diabolical\nintelligence.  You are held helpless\nfor a moment as your mind is open to\nthat of Armagon--Quake's General and\nmaster of this realm.  Recognizing\nyou as the one who foiled his\nattempt to conquer Earth, a hellish\nhowl fills your mind and blots out\nall consciousness.  When you awake,\nyou find yourself on the shores of\nreality, but in a time and place\nunknown to you." );
			return;
		}
		else if (world.model == "maps/hipend.bsp")
		{
			WriteByte (MSG_ALL, SVC_FINALE);
			WriteString (MSG_ALL, "Congratulations!  You are victorious!\nThe minions of Quake have once again\nfallen before your mighty hand.\nIs this the last you will see of\nQuake's hellions?\n\nOnly time will tell..." );
			intermission_exittime = time + 10000000;  // never allow exit
			return;
		}
		// DRESK - END HIPNOTIC SUPPORT
		// ********************************************
		
	}
	GotoNextMap();
}

/*
============
IntermissionThink

When the player presses attack or jump, change to the next level
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void IntermissionThink()
{
	// DRESK
	// Stupid Flash Light Temporary Entity Support
	// Purge Quake2 Weapon Entity
	CheckAndRemoveEntity(self, enQuake2PlayerModel_WeaponEntity);
	
	if(self.button3 && !self.bSpawnedFlashLightTemporaryEntity)
	{
		// Spawn TE!
		FlashLightSpawnTE(te_explosion, "");
		// Flag
		self.bSpawnedFlashLightTemporaryEntity = TRUE;
	}
	else
	if(self.bSpawnedFlashLightTemporaryEntity && !self.button3)
		// Unflag
		self.bSpawnedFlashLightTemporaryEntity = FALSE;
		
	if (time < intermission_exittime)
		return;

	if (!self.button0 && !self.button1 && !self.button2)
		return;
	
	ExitIntermission ();
};

// DRESK
// C-STYLE FUNCTION SYNTAX
void execute_changelevel()
{
	local entity	pos;

	intermission_running = 1;
	
// enforce a wait time before allowing changelevel
	if (deathmatch)
		intermission_exittime = time + 5;
	else
		intermission_exittime = time + 2;

	WriteByte (MSG_ALL, SVC_CDTRACK);
	
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
		WriteByte (MSG_ALL, 9);
	else
		WriteByte (MSG_ALL, 3);
		
	WriteByte (MSG_ALL, 3);
	
	pos = FindIntermission ();

	other = find (world, classname, "player");
	while (other != world)
	{
		other.view_ofs = '0 0 0';
		other.angles = other.v_angle = pos.mangle;
		other.fixangle = TRUE;		// turn this way immediately
		other.nextthink = time + 0.5;
		other.takedamage = DAMAGE_NO;
		other.solid = SOLID_NOT;
		other.movetype = MOVETYPE_NONE;
		other.modelindex = 0;
		setorigin (other, pos.origin);
		
		// DRESK
		// Disable Drawing of View Weapon
		ViewWeapon_ToggleDraw(other, FALSE);
		// Purge Quake2 Weapon Entity
		CheckAndRemoveEntity(other, enQuake2PlayerModel_WeaponEntity);
		
		other = find (other, classname, "player");
	}	

	WriteByte (MSG_ALL, SVC_INTERMISSION);
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void changelevel_touch()
{
	// DRESK
	// Unused Variable(s)
	// local entity	pos;

	if (other.classname != "player")
		return;
	// DRESK
	// Prevent dead-player exit (it happens!)
	if (other.health <= 0)
		return;

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start")))
	{
		T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_MISC_NOEXIT, 50000);
		return;
	}

	if (coop || deathmatch)
	{
		// DRESK
		// Advanced Exit Message
		local string strMessage;
			strMessage = other.netname;
			strMessage = strcat(strMessage, "^7 exited to the new level ^2");
			strMessage = strcat(strMessage, self.map);
			strMessage = strcat(strMessage, "^7...\n");
		bprint(strMessage);
		/*
		bprint (other.netname);
		bprint ("^7 exited the level\n");
		*/
	}
	
	nextmap = self.map;

	SUB_UseTargets ();

	if ( (self.spawnflags & 1) && (deathmatch == 0) )
	{	// NO_INTERMISSION
		GotoNextMap();
		return;
	}
	
	self.touch = __NULL__;

	// we can't move people right now, because touch functions are called
	// in the middle of C movement code, so set a think time to do it
	self.think = execute_changelevel;
	self.nextthink = time + 0.1;
}

/*QUAKED trigger_changelevel (0.5 0.5 0.5) ? NO_INTERMISSION
When the player touches this, he gets sent to the map listed in the "map" variable.  Unless the NO_INTERMISSION flag is set, the view will go to the info_intermission spot and display stats.
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void trigger_changelevel()
{
	if (!self.map)
		objerror ("changelevel trigger doesn't have map");
	
	InitTrigger ();
	self.touch = changelevel_touch;
};


/*
=============================================================================

				PLAYER GAME EDGE FUNCTIONS

=============================================================================
*/

// called by ClientKill and DeadThink
void respawn()
{
	if (coop)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// get the spawn parms as they were at level start
		setspawnparms (self);
		// respawn
		PutClientInServer ();
	}
	else if (deathmatch)
	{
		// make a copy of the dead body for appearances sake
		CopyToBodyQue (self);
		// set default spawn parms
		SetNewParms ();
		// respawn		
		PutClientInServer ();
	}
	else
	{	// restart the entire server
		localcmd ("restart\n");
	}
}


/*
============
ClientKill

Player entered the suicide command
============
*/
void ClientKill()
{
	// DRESK
	// Use REAL Suicide System
	
	// Purge Godmode
	if(self.flags & FL_GODMODE)
		self.flags = self.flags - (self.flags & FL_GODMODE);
	// Purge Invulnerability
	self.tCSQCStat_PowerupEndTime_Invulnerability = 0;
	self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - (self.nCSQCStat_Powerups & POWERUP_INVULNERABILITY);
		
	// Ignore Damage Momentum
	self.bIgnoreDamageMomentum = TRUE;
	T_Damage (self, self, self, HITLOCATION_NONE, DAMAGETYPE_MISC_SUICIDE, 10000);
	// Remove Ignore Damage Momentum
	self.bIgnoreDamageMomentum = FALSE;
}

/*
============
SelectSpawnPoint

Returns the entity to spawn at
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
entity SelectSpawnPoint()
{
	local	entity spot;
	local	entity thing;
	local	float  pcount;
	
// testinfo_player_start is only found in regioned levels
	spot = find (world, classname, "testplayerstart");
	if (spot)
		return spot;
		
// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find (lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		spot = lastspawn;
		while (1)
		{
			spot = find(spot, classname, "info_player_deathmatch");
			if (spot != world)
			{
				if (spot == lastspawn)
					return lastspawn;
				pcount = 0;
				thing = findradius(spot.origin, 32);
				while(thing)
				{
					if (thing.classname == "player")
						pcount = pcount + 1;
					thing = thing.chain;
				}
				if (pcount == 0)
				{
					lastspawn = spot;
					return spot;
				}
			}
		}
	}

	if (serverflags)
	{	// return with a rune to start
		spot = find (world, classname, "info_player_start2");
		if (spot)
			return spot;
	}
	
	spot = find (world, classname, "info_player_start");
	if (!spot)
		error ("PutClientInServer: no info_player_start on level");
	
	return spot;
}
/*
===========
PutClientInServer

called each time a player is spawned
============
*/
void PutClientInServer()
{
	local	entity spot;

	spot = SelectSpawnPoint ();

	self.classname = "player";
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	self.show_hostile = 0;
	self.max_health = 100;
	self.flags = FL_CLIENT;
	self.air_finished = time + 12;
	self.dmg = 2;   		// initial water damage
	self.effects = 0;
	
	// Reset Powerups
	// NOTE : Not necessary, waste of bandwidth
	/*
	self.tCSQCStat_PowerupEndTime_Invisibility = 0;
	self.tCSQCStat_PowerupEndTime_Invulnerability = 0;
	self.tCSQCStat_PowerupEndTime_Biosuit = 0;
	self.tCSQCStat_PowerupEndTime_QuadDamage = 0;
	self.tCSQCStat_PowerupEndTime_EmpathyShields = 0;
	self.invincible_time = 0;
	// DRESK - HIPNOTIC SUPPORT
	self.wetsuit_finished = 0;
	self.empathy_finished = 0;
	*/
	// self.items2 = 0;
	self.gravity = 1.0;

	DecodeLevelParms ();

	self.attack_finished = time;
	self.th_pain = player_pain;
	self.th_die = PlayerDie;
	
	self.deadflag = DEAD_NO;
// paustime is set by teleporters to keep the player from moving a while
	self.pausetime = 0;
	
//	spot = SelectSpawnPoint ();

	// DRESK
	// Reset Potential Gyro Physics Properties (mainly from gibbed head)
	if(g_bGyroPhysicsEnabled && g_bGyroPhysics_DetailEntities)
		Gyro_Object_ClearPhysics(self);
		
	// Check for Bleeding
	CheckCreatureBleeding(self);
	// Check and Spawn View Weapon
	ViewWeapon_CheckAndSpawn(self);
	// Reset Ignores Radius Damage
	self.bIgnoreRadiusDamage = FALSE;
	// Reset GibType
	self.nGibType = GIBTYPE_NONE;
	// Attack Finished Hack to Prevent Immediate Attack if Respawning by Attack
	self.attack_finished = time + 0.3;
	// Support Shared Weapons Pool
	UpdatePlayerSharedWeaponsPool();
	// Support Shared Ammunition Pool
	UpdatePlayerAllSharedAmmo();
	// Assign Gib Health
	self.nGibHealth = -40;
	// Assign Health At Spawn
	self.nEntityHealthAtSpawn = self.max_health;
	// Remove Contents Transition Function
	self.contentstransition = __NULL__;
	// Remove Is Corpse
	self.bIsCorpse = FALSE;
	// Remove Is Gibbed Corpse
	self.bIsGibbedCorpse = FALSE;
	// Reset Number of Corpse Twitches
	self.nNumCorpseTwitches = 0;
	// Reset Corpse Twitch State
	self.nPlayerCorpseTwitchState = 0;
	// Remove Is Crouching
	self.bIsCrouching = FALSE;
	// Remove Use Invisibility Eyes
	self.bUseInvisibilityEyes = FALSE;
	// Remove Final Corpse Frame
	self.nPlayerFinalCorpseFrame = 0;
	// Enable Quake2 Weapon Entity Drawing
	Quake2WeaponEntity_SetIsDrawing(self, TRUE);
	
	// Check for Respawn using Last Equipped Weapon
	if( cvar(CVAR_PLAYER_RESPAWNUSINGLASTEQUIPPEDWEAPON) )
	{ // Prepare Last Equipped Weapon
		if(self.nCSQCStat_Weapons & self.nLastEquippedWeapon)
		{ // Has Weapon; Equip
			self.weapon = self.nLastEquippedWeapon;
			UpdateCurrentWeaponEntity(self);
		}
	}
	
	W_SetCurrentAmmo(FALSE);

	// DRESK
	// Remove Pre/Post/Multiplier Damage Force Attributes
	// NOTE : These settings may have occured as a result of
	// a gibbed player head.  Considering removing bouncing
	// gibbed player heads, due to the ugly nature of this system.
	self.th_PreDamageForce = __NULL__;
	self.th_PostDamageForce = __NULL__;
	self.bForceDamageMomentum = FALSE;
	self.fPreDamageForce_Multiplier = 1.0;
	// Purge Gibbed Head Angle Velocity Function
	self.fpGibAngleVelocityFunc = __NULL__;
	
	// Force Teleport Print Update
	// NOTE: For performance reasons, this is accomplished by flagging
	// a global variable for the next frame.
	g_nPersonalTeleporter_NumFramesForcePrint = 2;
	
	// DRESK
	// Kill Velocity (prevent flying respawn from gibbing!)
	self.velocity = '0 0 0';
	// Kill Punchangle
	self.punchangle = '0 0 0';
	// Kill Jump Flag (prevent falling damage at spawn)
	self.jump_flag = 0;
	// Kill Angle Velocity
	self.avelocity = '0 0 0';
	
	// DRESK
	// Remove Potential Touch from Gibbed Head
	if(self.touch == DamageableGib_Touch)
		self.touch = __NULL__;
		
	// DRESK
	// Immediately Clear Potential Respawn Type Centerprint
	if( cvar(CVAR_COOP_RESPAWNATDEATHLOCATION_ALLOW) )
		centerprint(self, "");
		
	// Display Game Mode Concerns
	DisplayGameModeConcerns(self);

	// DRESK
	// Support Respawn Type
	local float bSuppressTelefrag;
		bSuppressTelefrag = FALSE;
	if(self.fRespawnType == 0)
	{ // Regular Respawn Type
		// Update Origin to Spawn Point
		// self.origin = spot.origin + '0 0 1';
		setorigin(self, spot.origin + '0 0 1');
		self.angles = spot.angles;
	}
	else
	{ // Respawn at Death Location
		// Assign Last Death Origin
		// self.origin = self.vLastDeathOrigin;
		setorigin(self, self.vLastDeathOrigin);
		// Face Direction of Viewpoint
		self.angles = self.v_angle;
		// Suppress Telefrag
		bSuppressTelefrag = TRUE;
		// Assign New Reuse Time
		self.fRespawnAtDeathLocationReuseTime = time + cvar(CVAR_COOP_RESPAWNATDEATHLOCATION_REUSETIME);
	}
	// Reset Respawn Type
	self.fRespawnType = 0;
	
	// DRESK
	// Set Full Flashlight Battery
	SetFlashLightFullBattery(self);
	// Check for Immediate Activation of Flash Light
	if(self.nFlashLightTypeEnableOnSpawn)
		ToggleFlashLight(FLASHLIGHT_TYPE_NONE);
	
	// DRESK
	// Sync Shared Keys
	SyncPlayerKeysToSharedKeys(self);
	// Support Floating Weapons
	CheckFloatingWeapon(self);
	
	// DRESK
	// Support Player Death Feedback (at respawn)
	if(coop)
		PlayerDeath_CheckDeathFeedback(TRUE, world);
		
	// DRESK
	// Check for Fullbright
	if( coop && cvar(CVAR_COOP_FULLBRIGHTPLAYERS) )
		self.effects = self.effects | EF_FULLBRIGHT;
	
	self.fixangle = TRUE;		// turn this way immediately
	
	// DRESK
	// Check Player Model Update
	CheckPlayerModelUpdate(self);
	
	self.view_ofs = PLAYER_VIEWOFFSETS_NORMAL;

	PlayerAnim_Stand();
	
	spawn_tfog(self.origin, self);

	// DRESK
	// Check for Suppressed Telefrag
	if( (coop && cvar(CVAR_COOP_SUPPRESSTELEFRAGONSPAWN) ) )
		bSuppressTelefrag = TRUE;
		
	if(!bSuppressTelefrag)
		spawn_tdeath (self.origin, self);
}


/*
=============================================================================

				QUAKED FUNCTIONS

=============================================================================
*/


/*QUAKED info_player_start (1 0 0) (-16 -16 -24) (16 16 24)
The normal starting point for a level.
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void info_player_start()
{
	// DRESK
	// Potentially Create Spawn Point Model
	CreateSpawnPointModel();
};


/*QUAKED info_player_start2 (1 0 0) (-16 -16 -24) (16 16 24)
Only used on start map for the return point from an episode.
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void info_player_start2()
{
	// DRESK
	// Potentially Create Spawn Point Model
	CreateSpawnPointModel();
}

/*
saved out by quaked in region mode
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void testplayerstart()
{
}

/*QUAKED info_player_deathmatch (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for deathmatch games
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void info_player_deathmatch()
{
	// DRESK
	// Potentially Create Spawn Point Model
	CreateSpawnPointModel();
}

/*QUAKED info_player_coop (1 0 1) (-16 -16 -24) (16 16 24)
potential spawning position for coop games
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void info_player_coop()
{
	// DRESK
	// Potentially Create Spawn Point Model
	CreateSpawnPointModel();
}

/*
===============================================================================

RULES

===============================================================================
*/

/*
go to the next level for deathmatch
only called if a time or frag limit has expired
*/
void NextLevel()
{
	local entity o;

	// DRESK - HIPNOTIC SUPPORT
	if (!g_bHipnoticEnabled && mapname == "start")
	// if (mapname == "start")
	{
		if (!cvar("registered"))
		{
			mapname = "e1m1";
		}
		else if (!(serverflags & 1))
		{
			mapname = "e1m1";
			serverflags = serverflags | 1;
		}
		else if (!(serverflags & 2))
		{
			mapname = "e2m1";
			serverflags = serverflags | 2;
		}
		else if (!(serverflags & 4))
		{
			mapname = "e3m1";
			serverflags = serverflags | 4;
		}
		else if (!(serverflags & 8))
		{
			mapname = "e4m1";
			serverflags = serverflags - 7;
		}

		o = spawn();
		o.map = mapname;
	}
	else
	{
		// find a trigger changelevel
		o = find(world, classname, "trigger_changelevel");

		// go back to start if no trigger_changelevel
		if (!o)
		{
			mapname = "start";
			o = spawn();
			o.map = mapname;
		}
	}

	nextmap = o.map;
	gameover = TRUE;
	
	if (o.nextthink < time)
	{
		o.think = execute_changelevel;
		o.nextthink = time + 0.1;
	}
}

/*
============
CheckRules

Exit deathmatch games upon conditions
============
*/
void CheckRules()
{
	local	float		timelimit;
	local	float		fraglimit;
	
	if (gameover)	// someone else quit the game already
		return;
		
	timelimit = cvar("timelimit") * 60;
	fraglimit = cvar("fraglimit");
	
	if (timelimit && time >= timelimit)
	{
		NextLevel ();
		return;
	}
	
	if (fraglimit && self.frags >= fraglimit)
	{
		NextLevel ();
		return;
	}	
};

//============================================================================

void PlayerDeathThink()
{
	// DRESK
	// Unused Variable(s)
	// local entity	old_self;
	local float		forward;

	if ((self.flags & FL_ONGROUND))
	{
		forward = vlen (self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward * normalize(self.velocity);
	}

	// wait for all buttons released
	if (self.deadflag == DEAD_DEAD)
	{
		if (self.button2 || self.button1 || self.button0)
			return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	// wait for any button down
	if (!self.button2 && !self.button1 && !self.button0)
		return;
		
	// DRESK
	// Support Respawn Types
	local float fContinueRespawn;
	fContinueRespawn = CheckCooperativeAllowRespawnAtDeathLocation();

	self.button0 = 0;
	self.button1 = 0;
	self.button2 = 0;
	
	if(fContinueRespawn)
		respawn();
}
void PlayerJump()
{
	// DRESK
	// Unused Variable(s)
	// local vector start, end;
	
	if (self.flags & FL_WATERJUMP)
		return;
	
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 50;

		// play swiming sound
		// DRESK
		// Shifted Swim Sound to Generic Movement
		/*
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_AUTO, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_AUTO, "misc/water2.wav", 1, ATTN_NORM);
		}
		*/

		return;
	}

	if (!(self.flags & FL_ONGROUND))
		return;

	if ( !(self.flags & FL_JUMPRELEASED) )
		return;		// don't pogo stick

	self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	
	self.button2 = 0;
	// player jumping sound
	local string strSound;
	local float nChannel;
	nChannel = CHAN_AUTO;
	switch(self.nPlayerModelJumpLand)
	{
		case PLAYERMODEL_JUMPLAND_HUMANOID:
			strSound = SOUND_KLESHIK_PLAYER_GENERICJUMP;
			break;
		case PLAYERMODEL_JUMPLAND_ROBOTIC:
			strSound = SOUND_KLESHIK_PLAYER_GENERICROBOTJUMP;
			break;
		case PLAYERMODEL_JUMPLAND_MODELSOUNDS:
			nChannel = CHAN_VOICE;
			strSound = GETPLAYERMODELSOUND(self, PLAYERSOUND_JUMP);
			break;
		default:
			strSound = SOUND_KLESHIK_PLAYER_GENERICJUMP;
			break;
	}
	sound (self, nChannel, strSound, 1, ATTN_NORM);
	
	// Produce Dust
	te_SmallDustKickup(self.origin);
	
	// DRESK
	// Support Ground Entity Additive Velocity
	if( SG_AUTOCVAR(kleshik_server_player_AddGroundVelocityToJump) )
		self.velocity = self.velocity + self.groundentity.velocity + '0 0 270';
	else
		self.velocity_z = self.velocity_z + 270;
}


/*
===========
WaterMove

============
*/
.float	dmgtime;

// WATER LEVEL REFERENCE
// 0 = not in
// 1 = feet
// 2 = waste
// 3 = eyes (or in water)

void WaterMove()
{
	if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;
		
	// DRESK
	// Support Water Fog Hacks
	if(self.waterlevel == 3)
	{ // Under Water
		// Apply Swim Sounds Here
		if (self.swim_flag < time && (self.velocity_x || self.velocity_y) )
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
				sound (self, CHAN_AUTO, "misc/water1.wav", 1, ATTN_NORM);
			else
				sound (self, CHAN_AUTO, "misc/water2.wav", 1, ATTN_NORM);
		}
		
		if(self.bHasWaterFog == FALSE)
		{ // Water Fog Hacks Needed
			// NOTE : Waterfog shifted to CSQC
			/*
			if( cvar(CVAR_WORLD_WATERFOGHACKSENABLED) )
				UpdateWaterFogHack(self, 1);
			*/
			// Assign Has Fog
			self.bHasWaterFog = TRUE;
			
			// Apply Underwater CD Track Hack
			/*
			if( cvar(CVAR_WORLD_WATERCDTRACK) )
			{ // Valid CD Track
				if(self.bCDTrackIsUnderwaterSound)
					stuffcmd(self, "cd resume\n");
				else
				{
					// Generate Command
					local string strCommand;
						strCommand = strcat("cd loop ", cvar_string(CVAR_WORLD_WATERCDTRACK), "\n");
					stuffcmd(self, strCommand);
				}
				self.bCDTrackIsUnderwaterSound = TRUE;
			}
			*/
			
			// Check for Underwater Bubble Entities
			CheckPlayerUnderwaterBubbleTrailEntities(self);
		}
	}

	if (self.waterlevel != 3)
	{ // Not under water / may just have left
		if (self.air_finished < time)
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_GASP2), 1, ATTN_NORM);
		else
		if (self.air_finished < time + 9)
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_GASP1), 1, ATTN_NORM);
			
		// DRESK
		if(self.bHasWaterFog)
		{ // Has Fog and No Longer Under Water
			// NOTE : Waterfog shifted to CSQC
			/*
			if( cvar(CVAR_WORLD_WATERFOGHACKSENABLED) )
				UpdateWaterFogHack(self, 0);
			*/
			// Assign Has No Fog
			self.bHasWaterFog = FALSE;
			
			// Play Head Out Water Sound
			te_HeadOutOfWater(self, self.watertype);
			// sound(self, CHAN_AUTO, SOUND_KLESHIK_PLAYER_HEADOUTWATER, 1, ATTN_NORM);
				
			// Check for Underwater Bubble Entities
			CheckPlayerUnderwaterBubbleTrailEntities(self);
		}
		
			
		// Reset Air Timer and Damage
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else
	if (self.air_finished < time)
	{	// drown!
		if (self.pain_finished < time)
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			T_Damage (self, world, world, HITLOCATION_NONE, DAMAGETYPE_MISC_DROWNING, self.dmg);
			self.pain_finished = time + 1;
		}
	}
	
	// **********************************************
	// Check for Not in ANY Water
	if (!self.waterlevel)
	{
		if (self.flags & FL_INWATER)
		{
			// play leave water sound
			sound (self, CHAN_AUTO, "misc/outwater.wav", 1, ATTN_NORM);
			self.flags = self.flags - FL_INWATER;
		}
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{	// do damage
		if (self.dmgtime < time)
		{
			if (self.nCSQCStat_Powerups & POWERUP_BIOSUIT)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;

			T_Damage (self, world, world, HITLOCATION_NONE, DAMAGETYPE_ENVIRONMENT_LAVA, 10*self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{	// do damage
		if (self.dmgtime < time && !(self.nCSQCStat_Powerups & POWERUP_BIOSUIT) )
		{
			self.dmgtime = time + 1;
			T_Damage (self, world, world, HITLOCATION_NONE, DAMAGETYPE_ENVIRONMENT_SLIME, 4*self.waterlevel);
		}
	}
	
	if ( !(self.flags & FL_INWATER) )
	{
		// player enter water sound
		// DRESK
		// Support Heavy in Water Sound (replace all standard sounds)
		if( fabs(self.velocity_z) > BODYINWATER_HEAVYHITVELOCITY)
		{ // Heavy Hit
			te_LargeObjectInWater(self, self.watertype);
		}
		else
		if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_AUTO, "player/inlava.wav", 1, ATTN_NORM);
		else
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_AUTO, "player/inh2o.wav", 1, ATTN_NORM);
		else
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);

		self.flags = self.flags + FL_INWATER;
		self.dmgtime = 0;
	}
	
	if (! (self.flags & FL_WATERJUMP) )
		self.velocity = self.velocity - 0.8*self.waterlevel*frametime*self.velocity;
}

void CheckWaterJump()
{
	local vector start, end;

	// check for a jump-out-of-water
	makevectors (self.angles);
	start = self.origin;
	start_z = start_z + 8; 
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward*24;
	traceline (start, end, TRUE, self);
	if (trace_fraction < 1)
	{	// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward*24;
		self.movedir = trace_plane_normal * -50;
		traceline (start, end, TRUE, self);
		if (trace_fraction == 1)
		{	// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
}


/*
================
PlayerPreThink

Called every frame before physics are run
================
*/
void PlayerPreThink()
{
	// DRESK
	// Unused Variable(s)
	// local	float	mspeed, aspeed;
	// local	float	r;
	
	// DRESK
	// Sync Additional Monsters - Killed
	self.nCSQCStat_AdditionalMonsters_Killed = g_nNumKilledSpawnedMonsters;

	if (intermission_running)
	{
		// DRESK
		// Fun Flashlight hack!  Be sure to update vectors here as well
			if(self.nFlashLightTypeActive != FLASHLIGHT_TYPE_POINTSOURCE)
			{ // Flash Light Type is Not Point Source
				if(self.nFlashLightTypeActive)
					// Turn off Flash Light
					ToggleFlashLight(FLASHLIGHT_TYPE_NONE);
				// Turn On Flash Light with Forced Type
				ToggleFlashLight(FLASHLIGHT_TYPE_POINTSOURCE);
			}
			// Remove Flash Light No Draw on Client
			self.enFlashLightSource.nodrawtoclient = world;
			makevectors(self.v_angle);
			self.fFlashLightDistance = 500;
			if(self.enFlashLightSource.glow_size == 0)
			{ // Assign Glow Trail to Flash Light
				self.enFlashLightSource.glow_size = 1;
				self.enFlashLightSource.glow_trail = 1;
				self.enFlashLightSource.effects = self.enFlashLightSource.effects | EF_STARDUST;
			}
			UpdateFlashLight();
		// End Flashlight hack
		
		IntermissionThink ();	// otherwise a button could be missed between
		return;					// the think tics
	}

	W_WeaponFrame();

	WaterMove();

	if (self.waterlevel == 2)
		CheckWaterJump ();

	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink ();
		return;
	}
	
	if (self.deadflag == DEAD_DYING)
	{
		// DRESK
		// Check for Respawn Time to Set DEAD_DEAD
		if(time > self.tPlayerRespawnTime)
			// Respawn Allowed
			self.deadflag = DEAD_DEAD;
			
		return;	// dying, so do nothing
	}
	
	// DRESK
	// Check for Crouching
	if(self.bIsCrouching)
	{
		if(!self.button5 || !(self.flags & FL_ONGROUND) || self.waterlevel > 2)
		{ // Can't Crouch Anymore
			sound(self, CHAN_AUTO, SOUND_KLESHIK_PLAYER_CROUCHUP, 1, ATTN_NORM);
			self.bIsCrouching = FALSE;
			
			// Update View Weapon Origin Offsets
			ViewWeapon_UpdateOriginOffset(self);
			
			if(g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
			{ // Interactive Crouch
				// Update View Offsets
				self.view_ofs = PLAYER_VIEWOFFSETS_NORMAL;
				// Update Player Size
				SetPlayerSize(self);
			}
		}
	}
	else
	{
		if(self.button5 && g_nCrouch_InteractivityLevel && self.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2 && self.flags & FL_ONGROUND && self.waterlevel < 3)
		{ // Wants to Crouch
			// Check if New Origin is Underwater
			if( pointcontents(self.origin - PLAYER_VIEWOFFSETS_CROUCH) > CONTENT_WATER)
			{
				sound(self, CHAN_AUTO, SOUND_KLESHIK_PLAYER_CROUCHDOWN, 1, ATTN_NORM);
				self.bIsCrouching = TRUE;
				// Update View Weapon Origin Offsets
				ViewWeapon_UpdateOriginOffset(self);
				
				if(g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
				{ // Interactive Crouch
					// Update View Offsets
					self.view_ofs = PLAYER_VIEWOFFSETS_CROUCH;
					
					// Update Player Size
					SetPlayerSize(self);
				}
			}
		}
	}
	
	// Update Crouching Flag to CSQC
	self.nCSQCStat_PlayerIsCrouching = self.bIsCrouching;
	
	// DRESK
	// Check for Crouching Speed Cap
	if(self.bIsCrouching && g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
	{
		// Cap based on velocities (movement vector does not seem to work)
		if( vlen(self.velocity) > 150)
			self.velocity = normalize(self.velocity) * 150;
	}

	if (self.button2)
	{
		PlayerJump ();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

// teleporters can force a non-moving pause time
	if (time < self.pausetime)
		self.velocity = '0 0 0';

	// DRESK - HIPNOTIC SUPPORT
	if(time > self.attack_finished && GetActiveWeaponAmmoAmount(self) == 0 && self.weapon != WEAPON_AXE && self.weapon != WEAPON_MJOLNIR)
	{
		self.weapon = W_BestWeapon ();
		UpdateCurrentWeaponEntity(self);
		W_SetCurrentAmmo(FALSE);
	}
	
	// DRESK
	// Check Teleport Targets Print Time
	if(self.tPersonalTeleporter_TeleportPrintTime && (g_nPersonalTeleporter_NumFramesForcePrint || time > self.tPersonalTeleporter_TeleportPrintTime) )
		self.nPersonalTeleporter_NumTeleportTargets = PersonalTeleporter_PrintTeleportTargets();
		
	// DRESK
	// Check Flash Light
	// if(self.bFlashLightActive || self.tFlashLightBrightHackedTime)
	UpdateFlashLight();
		
	// DRESK
	// Shifting Weapon Parsing to Pre-Think
	// DISABLED FOR NOW
	// W_WeaponFrame ();
}

/*
================
PlayerPostThink

Called every frame after physics are run
================
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void PlayerPostThink()
{
	// DRESK
	// Unused Variable(s)
	// local	float	mspeed, aspeed;
	// local	float	r;
	local string strSound;
	local float nChannel;

	if (intermission_running)
	{
		// DRESK - HIPNOTIC SUPPORT
		// FIXME : Does bHipnoticEnabled need to be checked?  Should it be checked?
		// Enabling Earthquakes without Hipnotic or Rogue specified to support potential mods
		// if(bHipnoticEnabled)
			if (hip_earthquake_time > time)
				Hipnotic_earthquake_postthink();
		
		return;		// intermission or finale
	}
	
	// DRESK - HIPNOTIC SUPPORT
	// FIXME : Does bHipnoticEnabled need to be checked?
	// Enabling Earthquakes without Hipnotic or Rogue specified to support potential mods
	// if(bHipnoticEnabled)
		if (hip_earthquake_time > time)
			Hipnotic_earthquake_postthink();
	// else
	// if(bRogueEnabled)
		if(rog_earthquake_active)
			Rogue_EarthQuake();
			
	// DRESK
	// Check Chat Bubble BEFORE Deadflag
	CheckClientChatBubble(self);
		
	if (self.deadflag)
	{ // Dead
		// DRESK
		// Update Jump Flag Here
		if (!(self.flags & FL_ONGROUND))
			self.jump_flag = self.velocity_z;
		// Check for Corpse Land Sound
		if( (self.jump_flag < -50) && (self.flags & FL_ONGROUND) && !self.bIsGibbedCorpse)
		{ // Corpse Land Sound
			local float nRandom;
				nRandom = random();
			if(nRandom < 0.25)
			{
				if(self.bBleedsSparks)
					strSound = SOUND_KLESHIK_GORE_METALCORPSELAND1;
				else
					strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND1;
			}
			else
			if(nRandom < 0.50)
			{
				if(self.bBleedsSparks)
					strSound = SOUND_KLESHIK_GORE_METALCORPSELAND2;
				else
					strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND2;
			}
			else
			if(nRandom < 0.75)
			{
				if(self.bBleedsSparks)
					strSound = SOUND_KLESHIK_GORE_METALCORPSELAND3;
				else
					strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND3;
			}
			else
			{
				if(self.bBleedsSparks)
					strSound = SOUND_KLESHIK_GORE_METALCORPSELAND1;
				else
					strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND4;
			}
				
			// Play Sound
			sound(self, CHAN_AUTO, strSound, 1, ATTN_NORM);
			if(!self.bBleedsSparks)
			{ // Produce Some Blood
				te_bloodshower(self.origin, self.origin, 600, 500);
				te_CorpseStain(self.origin);
			}
				
			// Align Corpse with Surface Normal
			if( cvar(CVAR_BLOODGORE_ALIGNCORPSESWITHSURFACENORMAL) )
				GetAlignedSurfaceAngles(self);
			
			// Reset Jump Flag
			self.jump_flag = 0;
		}
		return;
	}
		
	// DRESK - ROGUE SUPPORT
	if(g_bRogueEnabled && g_RogueCutScene_Running)
		xpackEnding();
		
// do weapon stuff

	// DRESK
	// Shifting Weapon Parsing to Pre-Think
	// KEEPING IT HERE FOR NOW
	// W_WeaponFrame ();

	// check to see if player landed and play landing sound	
	if ((self.jump_flag < -400) && (self.flags & FL_ONGROUND) && (self.health > 0))
	{
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_AUTO, "player/h2ojump.wav", 1, ATTN_NORM);
		else if (self.jump_flag < -675 && !(self.flags & FL_GODMODE || self.nCSQCStat_Powerups & POWERUP_INVULNERABILITY) )
		{
			// DRESK
			// Additional Falling Damage
			local float nFallingDamage;
				nFallingDamage = rint( ( (self.jump_flag * -1) / 425) * 10);
				if(nFallingDamage > 60)
					nFallingDamage = 60;
					
			T_Damage (self, world, world, self.origin - '0 0 20', DAMAGETYPE_MISC_FALLING, nFallingDamage); 
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_LANDHEAVY), 1, ATTN_NORM);
			self.deathtype = "falling";
			
			// Produce Dust
			te_SmallDustKickup(self.origin);
		}
		else
		{
			switch(self.nPlayerModelJumpLand)
			{
				case PLAYERMODEL_JUMPLAND_HUMANOID:
					strSound = SOUND_KLESHIK_PLAYER_GENERICLIGHTLAND;
					break;
				case PLAYERMODEL_JUMPLAND_ROBOTIC:
					strSound = SOUND_KLESHIK_PLAYER_GENERICROBOTLIGHTLAND;
					break;
				case PLAYERMODEL_JUMPLAND_MODELSOUNDS:
					nChannel = CHAN_VOICE;
					strSound = GETPLAYERMODELSOUND(self, PLAYERSOUND_LANDLIGHT);
					break;
				default:
					strSound = SOUND_KLESHIK_PLAYER_GENERICLIGHTLAND;
					break;
			}
			sound (self, nChannel, strSound, 1, ATTN_NORM);
				
			// Produce Dust
			te_SmallDustKickup(self.origin);
		}

		self.jump_flag = 0;
	}

	if (!(self.flags & FL_ONGROUND))
		self.jump_flag = self.velocity_z;

	CheckPowerups ();
	
	// DRESK
	// Check Footsteps
	// if(self.nPlayerModelFootstepType)
		CheckFootsteps();
}


/*
===========
ClientConnect

called when a player connects to a server
============
*/
void ClientConnect()
{
	bprint (self.netname);
	bprint("^7 has joined the ^1fray^7\n");
	// bprint (" entered the game\n");
	
	// DRESK
	// Send Raw Stuff Command Aliases
	RawStuffCmdToClient_SendAliases(self);
	
	// Send Weapons Available
	stuffcmd(self, strcat(WEAPON_CLIENTCOMMAND_SERVERWEAPONSAVAILABLE, " ", ftos(g_nAllWeapons), "\n") );
	
	// Prepare Client Edict Num on Server
	self.nCSQCStat_ClientEdictNumOnServer = num_for_edict(self);
	// Send Skill
	self.nCSQCStat_Skill = skill;
	// Send Additional Monsters - Total
	self.nCSQCStat_AdditionalMonsters_Total = g_nNumSpawnedMonsters;
	
	// Immediately Disable CD Track
	stuffcmd(self, "cd stop\n");
	
	// Prepare Quake Player Model Sounds
	if(!self.bPlayerModelUsingCustomSounds)
		PrepareQuakePlayerModelSounds(self);
		
	// Request Player Model Sync
	stuffcmd(self, strcat(PLAYERMODEL_CLIENTCOMMAND_SERVERREQUESTPLAYERMODELSYNC, "\n") );
	
	// a client connecting during an intermission can cause problems
	if (intermission_running)
		ExitIntermission ();
}

/*
===========
ClientDisconnect

called when a player disconnects from a server
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void ClientDisconnect()
{
	if (gameover)
		return;
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving
	
	// DRESK
	// Clear Additional Entities
		// Remove Flash Light
		CheckAndRemoveEntity(self, enFlashLightSource);
		// Remove Floating Weapon Model
		CheckAndRemoveEntity(self, enFloatingWeapon);
		// Remove Floating Keys
		CheckAndRemoveEntity(self, enFloatingKey1);
		CheckAndRemoveEntity(self, enFloatingKey2);
		// Remove Chat Bubble
		CheckAndRemoveEntity(self, enChatBubble);
		// Remove HUD Stingers
		CheckAndRemoveEntity(self, enHUDStinger_Pentagram);
		// Purge Weapon Entities
		PurgeWeaponEntities(self);
		// Purge Quake2 Weapon Entity
		CheckAndRemoveEntity(self, enQuake2PlayerModel_WeaponEntity);
		// Purge Underwater Bubble Trail Entities
		PurgeUnderwaterBubbleTrailEntities(self);

	// let everyone else know
	bprint (self.netname);
	bprint ("^7 left the ^1fray^7 with ^2");
	bprint (ftos(self.frags));
	bprint ("^7 frags\n");
	sound (self, CHAN_AUTO, "player/tornoff2.wav", 1, ATTN_NONE);
	set_suicide_frame ();
}
