
/*QUAKED info_null (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for spotlights, etc.
*/
void info_null()
{
	remove(self);
}

/*QUAKED info_notnull (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as a positional target for lightning.
*/
void info_notnull()
{
}

//============================================================================

float START_OFF = 1;

void light_use()
{
	if (self.spawnflags & START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

/*QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
*/
void light()
{
	if (!self.targetname)
	{	// inert light
		remove(self);
		return;
	}
	
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
};

/*QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Non-displayed light.
Default light value is 300
Default style is 0
If targeted, it will toggle between on or off.
Makes steady fluorescent humming sound
*/
void light_fluoro()
{
	if (self.style >= 32)
	{
		self.use = light_use;
		if (self.spawnflags & START_OFF)
			lightstyle(self.style, "a");
		else
			lightstyle(self.style, "m");
	}
	
	precache_sound ("ambience/fl_hum1.wav");
	ambientsound (self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
Non-displayed light.
Default light value is 300
Default style is 10
Makes sparking, broken fluorescent sound
*/
void light_fluorospark()
{
	if (!self.style)
		self.style = 10;

	precache_sound ("ambience/buzz1.wav");
	ambientsound (self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

/*QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
Sphere globe light.
Default light value is 300
Default style is 0
*/
void light_globe()
{
	precache_model ("progs/s_light.spr");
	setmodel (self, "progs/s_light.spr");
	makestatic (self);
};

void FireAmbient()
{
	precache_sound ("ambience/fire1.wav");
	
	// DRESK
	// Support Additional Fire Loop Sounds
	local string strSound;
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		strSound = "ambience/fire1.wav";
	else
	if(nRandom < 0.66)
		strSound = SOUND_KLESHIK_AMBIENCE_FIRELOOPS_FIRELOOP1;
	else
		strSound = SOUND_KLESHIK_AMBIENCE_FIRELOOPS_FIRELOOP2;
		
	ambientsound (self.origin, strSound, 1.0, ATTN_STATIC);
	
	// DRESK
	// Check for Ambient Sound Spawn
	CheckAmbientSoundSpawn();
}

/*QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
Short wall torch
Default light value is 200
Default style is 0
*/
void light_torch_small_walltorch()
{
	precache_model ("progs/flame.mdl");
	setmodel (self, "progs/flame.mdl");
	
	// DRESK - ROGUE SUPPORT
	if (g_bRogueEnabled && !(self.spawnflags & 1))
		FireAmbient ();
		
	makestatic (self);
};

/*QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
Large yellow flame ball
*/
void light_flame_large_yellow()
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	self.frame = 1;
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
Small yellow flame ball
*/
void light_flame_small_yellow()
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

/*QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
Small white flame ball
*/
void light_flame_small_white()
{
	precache_model ("progs/flame2.mdl");
	setmodel (self, "progs/flame2.mdl");
	FireAmbient ();
	makestatic (self);
};

//============================================================================


/*QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
Lava Balls
*/

void() fire_fly;
void() fire_touch;

void misc_fireball()
{
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled && self.spawnflags & 2)
	{ // Gib Fountain
		GameModeFeatureDetected_Travail();
		precache_sound ("gibfnt/gf_sprt1.wav");
		precache_sound ("gibfnt/gf_sprt2.wav");
		precache_sound ("gibfnt/gf_plop.wav");
		precache_sound ("gibfnt/gf_sbig.wav");
		self.nextthink = time + (random() * 2);
		self.think = Travail_GibFountain_Think;
	}
	else
	#endif
	{ // Standard Lavaball Spewer
		precache_model ("progs/lavaball.mdl");
		self.nextthink = time + (random() * 5);
		
		self.think = fire_fly;
	}
	self.classname = "fireball";
	
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled && self.targetname)
	{ // Target-Based Spewer
		// Purge Think Operation
		self.nextthink = 0;
		self.use = Travail_fireball_use;
	}
	#endif
		
	if (!self.speed)
		// DRESK
		// Huh?  Assigning SOMETHING
		self.speed = 1000;
}
void fire_fly()
{
	local entity	fireball;

	fireball = spawn();
	fireball.solid = SOLID_TRIGGER;
	fireball.movetype = MOVETYPE_TOSS;
	fireball.velocity = '0 0 1000';
	
	fireball.velocity_x = (random() * 100) - 50;
	fireball.velocity_y = (random() * 100) - 50;
	
	// DRESK
	// Assign Angle Velocity
	fireball.avelocity = randomvec() * 1200;
	
	fireball.velocity_z = self.speed + (random() * 200);
	fireball.classname = "fireball";
	setmodel (fireball, "progs/lavaball.mdl");
	setsize (fireball, '0 0 0', '0 0 0');
	setorigin (fireball, self.origin);
	
	// DRESK
	// Significantly Increase Time
	// fireball.nextthink = time + 5;
	fireball.nextthink = time + 15;
	fireball.think = SUB_Remove;
	fireball.touch = fire_touch;
	
	// DRESK
	// Play Sound on Fireball
	if( random() < 0.5)
		sound(fireball, CHAN_AUTO, SOUND_KLESHIK_MISC_LAVABALLBURST1, 1, ATTN_NORM);
	else
		sound(fireball, CHAN_AUTO, SOUND_KLESHIK_MISC_LAVABALLBURST2, 1, ATTN_NORM);
	// Assign Large Body Contents Transition
	fireball.contentstransition = ContentsTransition_BodyInWater;
	
	self.nextthink = time + (random() * 5) + 3;
	
	self.think = fire_fly;
};

void fire_touch()
{
	T_Damage (other, self, self, HITLOCATION_SELFORIGIN, DAMAGETYPE_ENVIRONMENT_LAVABALL, 20);
	
	// DRESK
	// Play Effect
	te_LavaballImpact(self.origin);
		
	remove(self);
}

//============================================================================


void barrel_explode(float fDamageType)
{
	self.takedamage = DAMAGE_NO;
	
	// DRESK
	// Suppress Classname Change with Exploding Item
	if(self.classname != "exploding_item_box")
		self.classname = "explo_box";
	
	// DRESK
	// Utilize CVar Radius for Exploding Item Boxes
	local float fDamage;
		if(self.classname == "exploding_item_box")
			fDamage = cvar(CVAR_EXPLODINGITEMBOX_DAMAGE);
		else
			fDamage = 160;
			
	T_RadiusDamage (self, self, DAMAGETYPE_ENVIRONMENT_BARRELEXPLOSION, fDamage, world);
	// T_RadiusDamage (self, self, DAMAGETYPE_ENVIRONMENT_BARRELEXPLOSIION, 160, world);
	te_explosion(self.origin);

	self.origin_z = self.origin_z + 32;
	BecomeExplosion ();
}



/*QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
TESTING THING
*/

void misc_explobox()
{
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(self.spawnflags & 1)
	{
		GameModeFeatureDetected_Travail();
		precache_model("progs/explob.mdl");
		setmodel(self, "progs/explob.mdl");
	}
	else
	#endif
	{
		precache_model ("maps/b_explob.bsp");
		setmodel (self, "maps/b_explob.bsp");
	}
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	
	// DRESK
	// Assign Bleeds Sparks
	self.bBleedsSparks = TRUE;
	// Assign Size
	setsize(self, '0 0 0', '32 32 64');

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}




/*QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
Smaller exploding box, REGISTERED ONLY
*/

void misc_explobox2()
{
	local float	oldz;
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(self.spawnflags & 1)
	{
		GameModeFeatureDetected_Travail();
		precache_model("progs/exbox2.mdl");
		setmodel(self, "progs/exbox2.mdl");
	}
	else
	#endif
	{
		precache_model2 ("maps/b_exbox2.bsp");
		setmodel (self, "maps/b_exbox2.bsp");
	}
	precache_sound ("weapons/r_exp3.wav");
	self.health = 20;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_AIM;
	
	// DRESK
	// Assign Bleeds Sparks
	self.bBleedsSparks = TRUE;
	// Assign Size
	setsize(self, '0 0 0', '32 32 32');

	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor();
	if (oldz - self.origin_z > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
	}
}

//============================================================================

// DRESK
// Spawnflags Shifted to Hipnotic Definitions
/*
float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;
*/
// Modified Spawnflag Names to Represent Mission Pack
float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;
// Hipnotic Spawnflags
float SPAWNFLAG_HIPNOTIC_LAVABALL = 4;
float SPAWNFLAG_HIPNOTIC_ROCKET = 8;
float SPAWNFLAG_HIPNOTIC_SILENT = 16;
// Rogue Spawnflags
float SPAWNFLAG_ROGUE_LAVASPIKE = 4;
float SPAWNFLAG_ROGUE_SUPERLAVA = 8;
float SPAWNFLAG_ROGUE_LAVASKILL = 16;
float SPAWNFLAG_ROGUE_FIREBALL = 32;

// FIXME UPDATED : Merged code paths, logic handles Hipnotic / Legacy.
// The notes below no longer apply.

// FIXME : I am lazy; the code takes two different paths currently.
// I should consider merging this logic.

// I also kept the functions separate due to my worry that vanilla Quake's
// triggers will have issues using Hipnotic's system.  I may do some testing
// later to confirm or deny that worry.

// DRESK - 11/25/06
// Utilize Different Functions for Spikeshooters for Ease of Usage
void spikeshooter_use_Standard()
{ // Spikeshooter - Standard
	local entity enMissile;
	if (!self.bIsSilentSpikeshooter)
		WeaponCSQCTemporaryEntity(etof(self), WEAPON_SUPER_NAILGUN, WEAPON_FIRINGMODE_PRIMARY, 3, self.origin, self.movedir);
		
	enMissile = launch_spike (self.origin, self.movedir);
	
	// Assign Velocity
	enMissile.velocity = self.movedir * 500;
	
	if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
		enMissile.touch = superspike_touch;
		
	// DRESK
	// Use nGibType for Detailed Nail Touch
	enMissile.nGibType = 1;
}
void spikeshooter_use_Laser()
{ // Spikeshooter - Laser
	local entity enMissile;
	if (!self.bIsSilentSpikeshooter)
		sound (self, CHAN_VOICE, "enforcer/enfire.wav", 1, ATTN_NORM);
		
	enMissile = LaunchLaser (self.origin, self.movedir);
	enMissile.spawnflags = self.spawnflags;
}
// HIPNOTIC SUPPORT
void spikeshooter_use_Hipnotic_Lavaball()
{ // Spikeshooter - Lavaball
	local entity lavaball;
	
	if (!self.bIsSilentSpikeshooter)
		sound (self, CHAN_VOICE, "misc/spike.wav", 1, ATTN_NORM);
		
	//Spawn Lavaball
	lavaball = spawn();
	lavaball.movetype = MOVETYPE_FLYMISSILE;
	lavaball.solid = SOLID_BBOX;
	lavaball.classname = "lavaball";
	
	// set lavaball speed
	lavaball.velocity = self.movedir * 300;
	
	lavaball.angles = vectoangles(lavaball.velocity);
	lavaball.owner = self;
	lavaball.touch = T_MissileTouch;
	setmodel (lavaball, "progs/lavarock.mdl");
	setsize (lavaball, '-4 -4 -4', '4 4 4');
	setorigin (lavaball, self.origin);
	lavaball.avelocity = '0 0 400';
	lavaball.nextthink = time + 5;
	lavaball.think = SUB_Remove;
}
void spikeshooter_use_Hipnotic_Rocket()
{ // Spikeshooter - Rocket
	local entity enMissile;
	if (!self.bIsSilentSpikeshooter)
		sound (self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
		
	// DRESK
	// Embedded Rocket Firing Logic into Function
	// W_FireRocket();
	makevectors(self.v_angle);
	enMissile = spawn ();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLYMISSILE;
	enMissile.solid = SOLID_BBOX;
	enMissile.classname = "missile";
	enMissile.velocity = v_forward * 1000;
	enMissile.angles = vectoangles(enMissile.velocity);
	enMissile.touch = T_MissileTouch;
	enMissile.nextthink = time + 5;
	enMissile.think = SUB_Remove;
	setmodel (enMissile, "progs/missile.mdl");
	setsize (enMissile, '0 0 0', '0 0 0');
	setorigin (enMissile, self.origin + v_forward*8 + '0 0 16');
	enMissile.contentstransition = ContentsTransition_SmallObjectInWater;
	
	// Assign Velocity
	enMissile.velocity = self.movedir*1000;
	
	enMissile.angles = vectoangles(enMissile.velocity);
	setorigin (enMissile, self.origin + self.movedir*8);
}
// ROGUE SUPPORT
void spikeshooter_use_Rogue_Fireball()
{ // Spikeshooter - Fireball
	launch_fireball (self.origin, self.movedir);
}
void spikeshooter_use_Rogue_Lavaspike()
{ // Spikeshooter - Lavaspike
	local entity enMissile;
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SUPER_NAILGUN, WEAPON_FIRINGMODE_PRIMARY, 3, self.origin, self.movedir);
	
	enMissile = launch_lava_spike (self.origin, self.movedir);
	
	enMissile.velocity = self.movedir * 500;
	if (self.spawnflags & SPAWNFLAG_ROGUE_SUPERLAVA)
		enMissile.touch = superspike_touch;
	else if((self.spawnflags & SPAWNFLAG_ROGUE_LAVASKILL) && (skill > 1))
		enMissile.touch = superspike_touch;
}

void shooter_think()
{
	// DRESK - HIPNOTIC SUPPORT
	if (self.state)
		// Shooter Enabled; Shoot
		// DRESK - Invoke Spikeshooter USE Function
		self.use();
		// spikeshooter_use();
		
	self.nextthink = time + self.wait;
	
	// DRESK - HIPNOTIC SUPPORT
	// Suppress Velocity Assignment Here
	// NOTE: The velocity is assigned in the use function, to allow for
	// different velocities based on the projectile fired.
	// newmis.velocity = self.movedir * 500;
}


/*QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
When triggered, fires a spike in the direction set in QuakeEd.
Laser is only for REGISTERED.
*/

void trap_spikeshooter()
{
	// NOTE: Supporting Both Hipnotic and Rogue in this feature is complicated, because
	// the two expansion packs have overlapping SPAWNFLAGS for different purposes.
	// Therefore, in this scenario, I am going to ONLY ALLOW the expansion pack SPAWNFLAGS
	// if the expansion pack is EXPLICITLY enabled through the relevant CVars.  This does prevent
	// the nice automation and feature warning checks, but it is necessary due to the overlapping spawn flags.
	
	SetMovedir ();
	
	// Assign Default Not Silent Spikeshooter
	self.bIsSilentSpikeshooter = FALSE;
	
	// DRESK - 11/25/06
	// Utilize Correct Codepath
	if(g_bHipnoticEnabled)
	{ // Hipnotic Mission Pack Enabled
		// Check for Silent Shooter
		if(self.spawnflags & SPAWNFLAG_HIPNOTIC_SILENT)
			self.bIsSilentSpikeshooter = TRUE;
			
		// Hipnotic Supports Standard Shooters; Check First
		if (self.spawnflags & SPAWNFLAG_LASER)
		{
			precache_model2 ("progs/laser.mdl");

			precache_sound2 ("enforcer/enfire.wav");
			precache_sound2 ("enforcer/enfstop.wav");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Laser;
		}
		else
		if (self.spawnflags & SPAWNFLAG_HIPNOTIC_LAVABALL)
		{
			// DRESK
			// Increment Hipnotic Feature Detected Counter
			g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bHipnoticEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Hipnotic Spawnflag, but Hipnotic is ^1NOT enabled^7!\n") );
					
			precache_model ("progs/lavarock.mdl");
			//      self.classname = "fireball";
			precache_sound2 ("misc/spike.wav");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Hipnotic_Lavaball;
		}
		else
		if (self.spawnflags & SPAWNFLAG_HIPNOTIC_ROCKET)
		{
			// DRESK
			// Increment Hipnotic Feature Detected Counter
			g_nHipnoticFeatureDetectedCnt = g_nHipnoticFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bHipnoticEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Hipnotic Spawnflag, but Hipnotic is ^1NOT enabled^7!\n") );
				
			precache_model ("progs/missile.mdl");
			precache_sound ("weapons/sgun1.wav");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Hipnotic_Rocket;
		}
		else
		{ // Standard Spikeshooter
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Standard;
		}
	}
	else
	if(g_bRogueEnabled)
	{ // Rogue Mission Pack Enabled
		// Rogue Supports Standard Shooters; Check First
		if (self.spawnflags & SPAWNFLAG_LASER)
		{
			precache_model2 ("progs/laser.mdl");

			precache_sound2 ("enforcer/enfire.wav");
			precache_sound2 ("enforcer/enfstop.wav");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Laser;
		}
		else
		if (self.spawnflags & SPAWNFLAG_ROGUE_LAVASPIKE)
		{
			// DRESK
			// Increment Rogue Feature Detected Counter
			g_nRogueFeatureDetectedCnt = g_nRogueFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bRogueEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Rogue Spawnflag, but Rogue is ^1NOT enabled^7!\n") );
				
			precache_model2 ("progs/lspike.mdl");
			precache_sound2 ("lavagun/snail.wav");		// lava nail gun cooldown
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Rogue_Lavaspike;
		}
		else if (self.spawnflags & SPAWNFLAG_ROGUE_SUPERLAVA)
		{
			// DRESK
			// Increment Rogue Feature Detected Counter
			g_nRogueFeatureDetectedCnt = g_nRogueFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bRogueEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Rogue Spawnflag, but Rogue is ^1NOT enabled^7!\n") );
				
			precache_model2 ("progs/lspike.mdl");
			precache_sound2 ("lavagun/snail.wav");		// lava nail gun cooldown
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Rogue_Lavaspike;
		}
	    else if (self.spawnflags & SPAWNFLAG_ROGUE_LAVASKILL)
	    {
			// DRESK
			// Increment Rogue Feature Detected Counter
			g_nRogueFeatureDetectedCnt = g_nRogueFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bRogueEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Rogue Spawnflag, but Rogue is ^1NOT enabled^7!\n") );
				
			precache_model2 ("progs/lspike.mdl");
			precache_sound2 ("lavagun/snail.wav");		// lava nail gun cooldown
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Rogue_Lavaspike;
	    }
	    else if (self.spawnflags & SPAWNFLAG_ROGUE_FIREBALL)
	    {
			// DRESK
			// Increment Rogue Feature Detected Counter
			g_nRogueFeatureDetectedCnt = g_nRogueFeatureDetectedCnt + 1;
			
			// Check for Potential Issue
			if(!g_bRogueEnabled)
				bprint( strcat("^1WARNING^7 : Trap ^2", self.classname, "^7 uses Rogue Spawnflag, but Rogue is ^1NOT enabled^7!\n") );
				
	        precache_model ("progs/fireball.mdl");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Rogue_Fireball;
	    }
		else
		{ // Standard Spikeshooter
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Standard;
		}
	}
	else
	{ // No Mission Packs Enabled
		if (self.spawnflags & SPAWNFLAG_LASER)
		{
			precache_model2 ("progs/laser.mdl");

			precache_sound2 ("enforcer/enfire.wav");
			precache_sound2 ("enforcer/enfstop.wav");
			
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Laser;
		}
		else
		{ // Standard Spikeshooter
			// Assign Shooter Use Function
			self.use = spikeshooter_use_Standard;
		}
	}
}

/*QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
*/

// DRESK - HIPNOTIC SUPPORT
void trap_shooter()
{
	// Invoke Spikeshooter Trap
	trap_spikeshooter();

	if (self.wait == 0)
		self.wait = 1;
	
	// DRESK - HIPNOTIC SUPPORT
	// Assign Default State of Enabled (legacy support)
	self.state = 1;
	
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
}

/*
===============================================================================


===============================================================================
*/


void() make_bubbles;
void() bubble_remove;
void() bubble_bob;

/*QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)

testing air bubbles
*/

void air_bubbles()

{
	if (deathmatch)
	{
		remove (self);
		return;
	}
	precache_model ("progs/s_bubble.spr");
	self.nextthink = time + 1;
	self.think = make_bubbles;
};

void make_bubbles()
{
	local entity	bubble;

	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + random() + 0.5;
	self.think = make_bubbles;
};

void bubble_split()
{
	local entity	bubble;
	
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.origin);
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = self.velocity;
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.touch = bubble_remove;
	bubble.classname = "bubble";
	bubble.frame = 1;
	bubble.cnt = 10;
	// DRESK
	// Assign Modelflag to Bubbles
	bubble.modelflags = MF_GRENADE;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.frame = 1;
	self.cnt = 10;
	if (self.waterlevel != 3)
		remove (self);
};

void bubble_remove()
{
	if (other.classname == self.classname)
	{
//		dprint ("bump");
		return;
	}
	remove(self);
};

void bubble_bob()
{
	local float		rnd1, rnd2, rnd3;
	// DRESK
	// Unused Variable(s)
	// local vector	vtmp1, modi;

	self.cnt = self.cnt + 1;
	if (self.cnt == 4)
		bubble_split();
	if (self.cnt == 20)
	{
		remove(self);
		return;
	}
	// DRESK
	// Remove if Not in Water
	if(self.waterlevel != 3)
	{
		remove(self);
		return;
	}

	rnd1 = self.velocity_x + (-10 + (random() * 20));
	rnd2 = self.velocity_y + (-10 + (random() * 20));
	rnd3 = self.velocity_z + 10 + random() * 10;

	if (rnd1 > 10)
		rnd1 = 5;
	if (rnd1 < -10)
		rnd1 = -5;
		
	if (rnd2 > 10)
		rnd2 = 5;
	if (rnd2 < -10)
		rnd2 = -5;
		
	if (rnd3 < 10)
		rnd3 = 15;
	if (rnd3 > 30)
		rnd3 = 25;
	
	self.velocity_x = rnd1;
	self.velocity_y = rnd2;
	self.velocity_z = rnd3;
		
	self.nextthink = time + 0.5;
	self.think = bubble_bob;
};

/*~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>
~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~<~>~*/

/*QUAKED viewthing (0 .5 .8) (-8 -8 -8) (8 8 8)

Just for the debugging level.  Don't use
*/

void viewthing()

{
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	precache_model ("progs/player.mdl");
	setmodel (self, "progs/player.mdl");
};


/*
==============================================================================

SIMPLE BMODELS

==============================================================================
*/

void func_wall_use()
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

/*QUAKED func_wall (0 .5 .8) ?
This is just a solid wall if not inhibitted
*/
void func_wall()
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled && self.spawnflags & 1)
	{
		GameModeFeatureDetected_Travail();
		self.solid = SOLID_NOT;
	}
	else
	#endif
		self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
}


/*QUAKED func_illusionary (0 .5 .8) ?
A simple entity that looks solid but lets you walk through it.
*/
void func_illusionary()
{
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel (self, self.model);
	// DRESK
	// makestatic requires entity parameter; assigning self
	makestatic(self);
}

/*QUAKED func_episodegate (0 .5 .8) ? E1 E2 E3 E4
This bmodel will appear if the episode has allready been completed, so players can't reenter it.
*/
void func_episodegate()

{
	if (!(serverflags & self.spawnflags))
		return;			// can still enter episode

	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

/*QUAKED func_bossgate (0 .5 .8) ?
This bmodel appears unless players have all of the episode sigils.
*/
void func_bossgate()

{
	if ( (serverflags & 15) == 15)
		return;		// all episodes completed
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_wall_use;
	setmodel (self, self.model);
};

//============================================================================

void noise_think()
{
	self.nextthink = time + 0.5;
	sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
	sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
	sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
	sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
	sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
	sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
	sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
};

/*QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10)

For optimzation testing, starts a lot of sounds.
*/

void misc_noisemaker()

{
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/idle1.wav");

	self.nextthink = time + 0.1 + random();
	self.think = noise_think;
};
