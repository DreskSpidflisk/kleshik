
// DRESK
// Unused Variable(s)
// entity stemp, otemp, s, old;
entity s;


void trigger_reactivate()
{
	self.solid = SOLID_TRIGGER;
};

//=============================================================================

float	SPAWNFLAG_NOMESSAGE = 1;
float	SPAWNFLAG_NOTOUCH = 1;

// the wait time has passed, so set back up for another activation
void multi_wait()
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};


// the trigger was just touched/killed/used
// self.enemy should be set to the activator so it can be held through a delay
// so wait for the delay time before firing
void multi_trigger()
{
	if (self.nextthink > time)
	{
		return;		// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		found_secrets = found_secrets + 1;
		WriteByte (MSG_ALL, SVC_FOUNDSECRET);
		
		// DRESK
		// Update Number of Secrets Found
		UpdateClientStatsScore(self.enemy, CLIENTSCORE_NUMSECRETSFOUND, 1);
		
		// Support Broadcast Client Secret Areas
		if(coop)
		{ // Broadcast
			// Generate Message
			local string strMessage;
			strMessage = strcat(self.enemy.netname, "^7 found a ^2secret area^7!\n");
			bprint(strMessage);
		}
		
		// DRESK
		// Check Update Advanced Statistics
		CheckUpdatedAdvancedStatistics();
	}
	
	if (self.noise)
	{
		// DRESK
		// Support Global Sounds
		sound (world, CHAN_AUTO, self.noise, 1, ATTN_NONE);
	}

// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;
	
	SUB_UseTargets();

	if (self.wait > 0)	
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{	// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
	
	// DRESK - HIPNOTIC SUPPORT
	if (self.cnt > 0)
	{ // Trigger has counter
		self.cnt = self.cnt - 1;
		if (self.cnt == 0)
		{ // Trigger counter expired
			// Check for Potential Issue
			if(!g_bHipnoticEnabled)
				bprint( strcat("^1WARNING^7 : Trigger ^2", self.classname, "^7 has expired counter, but Hipnotic is NOT enabled!\n") );
				
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

void multi_killed()
{
	self.enemy = damage_attacker;
	
	// DRESK
	// Check Update Advanced Statistics
	CheckUpdatedAdvancedStatistics();
	
	multi_trigger();
};

void multi_use()
{
	self.enemy = activator;
	multi_trigger();
};

void multi_touch()
{
	if (other.classname != "player")
		return;
	
// if the trigger has an angles field, check player's facing direction
	if (self.movedir != '0 0 0')
	{
		makevectors (other.angles);
		if (v_forward * self.movedir < 0)
			return;		// not facing the right way
	}
	
	self.enemy = other;
	multi_trigger ();
};

/*QUAKED trigger_multiple (.5 .5 .5) ? notouch
Variable sized repeatable trigger.  Must be targeted at one or more entities.  If "health" is set, the trigger must be killed to activate each time.
If "delay" is set, the trigger waits some time after activating before firing.
"wait" : Seconds between triggerings. (.2 default)
If notouch is set, the trigger is only fired by other entities, not by touching.
NOTOUCH has been obsoleted by trigger_relay!
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void trigger_multiple()
{
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = GetMessageTriggerSound();
	}
	else if (self.sounds == 3)
	{
		precache_sound ("misc/trigger1.wav");
		self.noise = "misc/trigger1.wav";
	}
	
	if (!self.wait)
		self.wait = 0.2;
	self.use = multi_use;

	InitTrigger ();

	if (self.health)
	{
		if (self.spawnflags & SPAWNFLAG_NOTOUCH)
			objerror ("health and notouch don't make sense\n");
			
		// DRESK
		// Register Advanced Statistic
		RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_OTHER);
		
		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		
		// DRESK
		// Assign Bleeds Sparks
		self.bBleedsSparks = TRUE;
		
		setorigin (self, self.origin);	// make sure it links into the world
	}
	else
	{
		if ( !(self.spawnflags & SPAWNFLAG_NOTOUCH) )
		{
			self.touch = multi_touch;
		}
	}
	
	// DRESK - HIPNOTIC SUPPORT
	if(self.cnt == 0)
		// No counter specified; Utilize unlimited amount (legacy support)
		self.cnt = -1;
	else
		g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
};


/*QUAKED trigger_once (.5 .5 .5) ? notouch
Variable sized trigger. Triggers once, then removes itself.  You must set the key "target" to the name of another object in the level that has a matching
"targetname".  If "health" is set, the trigger must be killed to activate.
If notouch is set, the trigger is only fired by other entities, not by touching.
if "killtarget" is set, any objects that have a matching "target" will be removed when the trigger is fired.
if "angle" is set, the trigger will only fire when someone is facing the direction of the angle.  Use "360" for an angle of 0.
sounds
1)	secret
2)	beep beep
3)	large switch
4)
set "message" to text string
*/
void trigger_once()
{
	self.wait = -1;
	trigger_multiple();
};

//=============================================================================

/*QUAKED trigger_relay (.5 .5 .5) (-8 -8 -8) (8 8 8)
This fixed size trigger cannot be touched, it can only be fired by other events.  It can contain killtargets, targets, delays, and messages.
*/
void trigger_relay()
{
	self.use = SUB_UseTargets;
};


//=============================================================================

/*QUAKED trigger_secret (.5 .5 .5) ?
secret counter trigger
sounds
1)	secret
2)	beep beep
3)
4)
set "message" to text string
*/
void trigger_secret()
{
	total_secrets = total_secrets + 1;
	self.wait = -1;
	
	// DRESK
	// Also check for standard message (in case map author just copied and pasted)
	if (!self.message || self.message == "You found a secret area!")
	{
		// DRESK
		// Use Solidity at Spawn to Mark Non-Unique Message
		self.nSolidityAtSpawn = TRUE;
		
		self.message = "You found a \bsecret area\b!";
	}
	if (!self.sounds)
		self.sounds = 1;
	
	if (self.sounds == 1)
	{
		precache_sound ("misc/secret.wav");
		self.noise = "misc/secret.wav";
	}
	else if (self.sounds == 2)
	{
		precache_sound ("misc/talk.wav");
		self.noise = GetMessageTriggerSound();
	}
	
	// DRESK
	// Register Advanced Statistic
	RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_OTHER);

	trigger_multiple ();
};

//=============================================================================


void counter_use()
{
	// DRESK
	// Unused Variable(s)
	// local string junk;

	self.count = self.count - 1;
	if (self.count < 0)
		return;
	
	if (self.count != 0)
	{
		if (activator.classname == "player"
		&& (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
		{
			// DRESK
			//Support Advanced Message
			// Generate Message
			local string strMessage;
				strMessage = strcat("^2", ftos(self.count), "^7 more to go...");
				
			// DRESK
			// Support Coop Broadcast Centerprint
			CheckCoopCenterprintBroadcast(activator, strMessage, GetMessageTriggerSound());
			
			centerprint(activator, strMessage);
			/*
			if (self.count >= 4)
				centerprint (activator, "There are more to go...");
			else if (self.count == 3)
				centerprint (activator, "Only 3 more to go...");
			else if (self.count == 2)
				centerprint (activator, "Only 2 more to go...");
			else
				centerprint (activator, "Only 1 more to go...");
			*/
		}
		return;
	}
	
	if (activator.classname == "player" && (self.spawnflags & SPAWNFLAG_NOMESSAGE) == 0)
	{
		// DRESK
		// Support Coop Broadcast Centerprint
		CheckCoopCenterprintBroadcast(activator, "\bSequence Completed!\b", SOUND_KLESHIK_AMBIENCE_EVENTS_SEQUENCECOMPLETED);
		
		centerprint(activator, "\bSequence Completed!\b");
	}
	self.enemy = activator;
	multi_trigger ();
};

/*QUAKED trigger_counter (.5 .5 .5) ? nomessage
Acts as an intermediary for an action that takes multiple inputs.

If nomessage is not set, t will print "1 more.. " etc when triggered and "sequence complete" when finished.

After the counter has been triggered "count" times (default 2), it will fire all of it's targets and remove itself.
*/
void trigger_counter()
{
	self.wait = -1;
	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};


/*
==============================================================================

TELEPORT TRIGGERS

==============================================================================
*/

float	PLAYER_ONLY	= 1;
float	SILENT = 2;

void play_teleport()
{
	local	float v;
	local	string tmpstr;

	// DRESK
	// Check for Monster Teleporter
	if(self.owner.flags & FL_MONSTER)
	{ // Monster Teleport Sound
		v = random() * 3;
		if(v < 1)
			tmpstr = SOUND_KLESHIK_MONSTERS_MONSTERTELEPORT1;
		else
		if(v < 2)
			tmpstr = SOUND_KLESHIK_MONSTERS_MONSTERTELEPORT2;
		else
			tmpstr = SOUND_KLESHIK_MONSTERS_MONSTERTELEPORT3;
	}
	else
	{
		v = random() * 5;
		if (v < 1)
			tmpstr = "misc/r_tele1.wav";
		else if (v < 2)
			tmpstr = "misc/r_tele2.wav";
		else if (v < 3)
			tmpstr = "misc/r_tele3.wav";
		else if (v < 4)
			tmpstr = "misc/r_tele4.wav";
		else
			tmpstr = "misc/r_tele5.wav";
	}

	sound (self, CHAN_AUTO, tmpstr, 1, ATTN_NORM);
	remove (self);
}
void spawn_tfog(vector vOrigin, entity enEntity)
{
	s = spawn ();
	s.origin = vOrigin;
	// DRESK
	// Append Owner to Sound Spawner
	s.owner = enEntity;
	s.nextthink = time + 0.2;
	s.think = play_teleport;

	te_teleport(vOrigin);
	
	// DRESK
	// Additional Effects
	te_smallflash(vOrigin);
	te_customflash(vOrigin, 100, 2, '0.9 0 0.3');
}
void tdeath_touch()
{
	if (other == self.owner)
		return;

	// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.nCSQCStat_Powerups & POWERUP_INVULNERABILITY)
			self.classname = "teledeath2";
		if (self.owner.classname != "player")
		{	// other monsters explode themselves
			T_Damage (self.owner, self, self, HITLOCATION_NONE, DAMAGETYPE_MISC_TELEFRAG, 50000);
			return;
		}
		
	}

	if (other.health)
	{
		// DRESK
		// Ensure Monsters do NOT telefrag monsters
		if( !( (self.owner.flags & FL_MONSTER) && (other.flags & FL_MONSTER) && (!intermission_running) ) )
			T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_MISC_TELEFRAG, 50000);
	}
}
void spawn_tdeath(vector org, entity death_owner)
{
	local entity	death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	
	// DRESK
	// Tighter Removal Time
	// death.nextthink = time + 0.2;
	death.nextthink = time + 0.1;
	death.think = SUB_Remove;
	death.owner = death_owner;
	// DRESK
	// Disable Drawing on Entity
	death.effects = EF_NODRAW;
	
	force_retouch = 2;		// make sure even still objects get hit
};

void teleport_touch()
{
	local entity	t;
	local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	if(other.classname == "player")
		CheckUpdatedAdvancedStatistics();

	SUB_UseTargets ();

	// put a tfog where the player was
	spawn_tfog (other.origin, other);
	
	// Check for Fading Entity Copy
	local float nFadingCopy;
		nFadingCopy = cvar(CVAR_WORLD_SPAWNFADINGCOPYATTELEPORT);
	if(nFadingCopy)
	{ // Potential Fading Copy
		if(other.classname == "player" || (nFadingCopy > 1) )
			// Spawn Teleporter Fading Entity Copy
			SpawnTeleporterFadingEntityCopy(other);
	}

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
	// spawn a tfog flash in front of the destination
	makevectors (t.mangle);
	org = t.origin + 32 * v_forward;

	spawn_tfog (org, other);
	spawn_tdeath(t.origin, other);

	// move the player and lock him down for a little while
	if( !(other.health) )
	{
		other.origin = t.origin;
		other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y);
		return;
	}

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.fixangle = 1;		// turn this way immediately
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
		other.velocity = v_forward * 300;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
}

/*QUAKED info_teleport_destination (.5 .5 .5) (-8 -8 -8) (8 8 32)
This is the destination marker for a teleporter.  It should have a "targetname" field with the same value as a teleporter's "target" field.
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void info_teleport_destination()
{
	// this does nothing, just serves as a target spot
	
	// DRESK
	// Check for Ambient Sound Spawn
	CheckAmbientSoundSpawn();
	
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = "";
	self.origin = self.origin + '0 0 27';
	// DRESK
	// Disable Drawing
	self.effects = EF_NODRAW;
	if (!self.targetname)
		objerror ("no targetname");
};

// DRESK
// C-STYLE FUNCTION SYNTAX
void teleport_use()
{
	self.nextthink = time + 0.2;
	force_retouch = 2;		// make sure even still objects get hit
	self.think = SUB_Null;
};

/*QUAKED trigger_teleport (.5 .5 .5) ? PLAYER_ONLY SILENT
Any object touching this will be transported to the corresponding info_teleport_destination entity. You must set the "target" field, and create an object with a "targetname" field that matches.

If the trigger_teleport has a targetname, it will only teleport entities when it has been fired.
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void trigger_teleport()
{
	local vector o;

	InitTrigger ();
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(self.spawnflags & 4)
	{
		GameModeFeatureDetected_Travail();
		self.touch = Travail_Special_teleport_touch;
	}
	else
	#endif
		self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror ("no target");
	self.use = teleport_use;

	if (!(self.spawnflags & SILENT))
	{
		precache_sound ("ambience/hum1.wav");
		o = (self.mins + self.maxs)*0.5;
		ambientsound (o, "ambience/hum1.wav",0.5 , ATTN_STATIC);
	}
	
	// DRESK
	// Register Advanced Statistic
	if(self.spawnflags & PLAYER_ONLY)
		RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_OTHER);
}

/*
==============================================================================

trigger_setskill

==============================================================================
*/

void trigger_skill_touch()
{
	if (other.classname != "player")
		return;
		
	// Acquire Current Skill
	local string strSkill;
		strSkill = cvar_string("skill");
	cvar_set ("skill", self.message);
	
	// DRESK
	// Broadcast Skill Change
	if(!deathmatch && strSkill != self.message)
	{
		bprint( strcat(other.netname, "^7 Triggered a ^2Skill Change^7 : ^1", self.message, "\n") );
		// Play Sound
		sound (world, CHAN_AUTO, "sound/misc/menu2.wav", 1, ATTN_NONE);
	}
};

/*QUAKED trigger_setskill (.5 .5 .5) ?
sets skill level to the value of "message".
Only used on start map.
*/
void trigger_setskill()
{
	InitTrigger ();
	self.touch = trigger_skill_touch;
};


/*
==============================================================================

ONLY REGISTERED TRIGGERS

==============================================================================
*/

void trigger_onlyregistered_touch()
{
	if (other.classname != "player")
		return;
	if (self.attack_finished > time)
		return;

	self.attack_finished = time + 2;
	if (cvar("registered"))
	{
		self.message = "";
		SUB_UseTargets ();
		remove (self);
	}
	else
	{
		if (self.message != "")
		{
			centerprint (other, self.message);
			sound (other, CHAN_BODY, GetMessageTriggerSound(), 1, ATTN_NORM);
		}
	}
};

/*QUAKED trigger_onlyregistered (.5 .5 .5) ?
Only fires if playing the registered version, otherwise prints the message
*/
void trigger_onlyregistered()
{
	precache_sound ("misc/talk.wav");
	InitTrigger ();
	self.touch = trigger_onlyregistered_touch;
};

//============================================================================

// DRESK - HIPNOTIC SUPPORT
void hurt_setdamage(entity ent, float amount)
{
	ent.dmg = amount;
	if ( !amount )
	{
		ent.solid = SOLID_NOT;
	}
	else
	{
		ent.solid = SOLID_TRIGGER;
	}
	ent.nextthink = -1;
};

void hurt_on()
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void hurt_touch()
{
	if (other.takedamage)
	{
		self.solid = SOLID_NOT;
		self.think = hurt_on;
		self.nextthink = time + 1;
		
		// DRESK
		// Check for Potential Healing Hurt Triggers
		if(self.dmg < 0)
		{ // Trigger Heals
			// Play Heal Sound on Target
			sound(other, CHAN_AUTO, "items/health1.wav", 1, ATTN_NORM);
			// Heal Target
			T_Heal(other, self.dmg * -1, TRUE);
		}
		else
			// Trigger Damages
			T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_ENVIRONMENT_HURTTOUCH, self.dmg);
		
		// DRESK - HIPNOTIC SUPPORT
		if (self.cnt > 0)
		{ // Trigger has counter
			self.cnt = self.cnt - 1;
			if (self.cnt == 0)
			{ // Trigger count expired; disable
				// Check for Potential Issue
				if(!g_bHipnoticEnabled)
					bprint( strcat("^1WARNING^7 : Trigger ^2", self.classname, "^7 has expired counter, but Hipnotic is NOT enabled!\n") );
				
				self.touch = SUB_Null;
				self.nextthink = time + 0.1;
				self.think = SUB_Remove;
			}
		}
	}

	return;
};

/*QUAKED trigger_hurt (.5 .5 .5) ?
Any object touching this will be hurt
set dmg to damage amount
defalt dmg = 5
*/
void trigger_hurt()
{
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
		
	// DRESK - HIPNOTIC SUPPORT
	if(self.cnt == 0)
		// No counter specified; Utilize unlimited amount (legacy support)
		self.cnt = -1;
	else
		g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
};

//============================================================================

float PUSH_ONCE = 1;

void trigger_push_touch()
{
	if (other.classname == "grenade")
		other.velocity = self.speed * self.movedir * 10;
	else if (other.health > 0)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			// DRESK
			// TRAVAIL SUPPORT
			if (other.fly_sound < time && !(self.spawnflags & 2) )
			{
				other.fly_sound = time + 1.5;
				sound (other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	if (self.spawnflags & PUSH_ONCE)
		remove(self);
};


/*QUAKED trigger_push (.5 .5 .5) ? PUSH_ONCE
Pushes the player
*/
void trigger_push()
{
	InitTrigger ();
	precache_sound ("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void trigger_monsterjump_touch()
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if ( !(other.flags & FL_ONGROUND) )
		return;
	
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
	
	// DRESK - HIPNOTIC SUPPORT
	if(self.cnt > 0)
	{ // Trigger has counter
		self.cnt = self.cnt - 1;
		if (self.cnt == 0)
		{ // Trigger counts expired; disable
			// Check for Potential Issue
			if(!g_bHipnoticEnabled)
				bprint( strcat("^1WARNING^7 : Trigger ^2", self.classname, "^7 has expired counter, but Hipnotic is NOT enabled!\n") );
			
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void trigger_monsterjump()
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
		
	// DRESK - HIPNOTIC SUPPORT
	if(self.cnt == 0)
		// No counter specified; Utilize unlimited amount (legacy support)
		self.cnt = -1;
	else
		g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
		
	InitTrigger ();
	self.touch = trigger_monsterjump_touch;
};

