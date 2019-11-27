float 	rog_earthquake_active;
float	rog_earthquake_intensity;

void Rogue_EarthQuake()
{
	// NOTE: Assumed scope is Player
	if (rog_earthquake_active)
	{
		if ( self.flags & FL_ONGROUND )
		{
			self.velocity_x = self.velocity_x + 
								(random() * rog_earthquake_intensity * 2) -
								rog_earthquake_intensity;
			self.velocity_y = self.velocity_y + 
								(random() * rog_earthquake_intensity * 2) -
								rog_earthquake_intensity;
			self.velocity_z = self.velocity_z + 
								(random() * rog_earthquake_intensity * 2) -
								rog_earthquake_intensity;
		}
	}
}

// earthquake

// ============================================================
// Level-Wide Earthquakes
// ============================================================
float 	EQ_RANDOM 		= 1;

void Rogue_stop_earthquake();

void Rogue_earthquake_rumble()
{
	if (self.attack_finished < time)
		Rogue_stop_earthquake();
	else
	{
		sound( self, CHAN_VOICE, "equake/rumble.wav", 1, ATTN_NONE );
		self.think = Rogue_earthquake_rumble;
		self.nextthink = time + 1;
	}
}; 

void Rogue_start_earthquake()
{
	rog_earthquake_active = 1;
	if ( self.spawnflags & EQ_RANDOM )
		self.attack_finished = time + random() * self.delay;
	else
		self.attack_finished = time + self.delay;
	Rogue_earthquake_rumble();
};

void Rogue_stop_earthquake()
{
	rog_earthquake_active = 0;
	self.think = Rogue_start_earthquake;
	if ( self.spawnflags & EQ_RANDOM )
		self.nextthink = time + random() * self.wait;
	else
		self.nextthink = time + self.wait;
};

/*QUAKED earthquake (0 1 0) (-8 -8 -8) (8 8 8) Random
The Earthquake generator.

delay - duration of the tremor (default 20)
wait - time between tremors (default 60)
weapon - richter scale of movement (default 40)

RANDOM affects the times only. It will change the randomly between
0-n where n is the duration or time between.

weapon - if you give a weapon value of 40, the X and Y displacement 
can vary between -20 and +20, a range of 40.
*/
void earthquake()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	if (!self.delay)
		self.delay = 20;
	if (!self.wait)
		self.wait = 60;
	if (!self.weapon)
		self.weapon = 40;	
	
	precache_sound ("equake/rumble.wav");
	rog_earthquake_active = 0;
	rog_earthquake_intensity = self.weapon * 0.5;
	
	setsize (self, '0 0 0', '0 0 0');
	self.think = Rogue_stop_earthquake;
	self.nextthink = time + 1;
};

// ============================================================
// Earthquake trigger
// ============================================================
void Rogue_earthquake_touch()
{
	if (self.delay)
	{
		if ( self.attack_finished < time )
		{
			sound ( self, CHAN_VOICE, "equake/rumble.wav", 1, ATTN_NORM );
			self.attack_finished = time + 1;
		}			
		
		if ( other.classname == "player" )
		{
			if ( other.flags & FL_ONGROUND )
			{
				other.velocity_x = other.velocity_x + 
									(random() * self.weapon * 2) -
									self.weapon;
				other.velocity_y = other.velocity_y + 
									(random() * self.weapon * 2) -
									self.weapon;
				other.velocity_z = other.velocity_z + 
									(random() * self.weapon * 2) -
									self.weapon;
			}
		}
	}
};

void Rogue_earthquake_use ()
{
	self.delay = !self.delay;
};

/*QUAKED trigger_earthquake (.5 .5 .5) ?
The Earthquake generator.

Anytime a person is in an active field, they shake. If the trigger is a target, it will be OFF until triggered. It will then toggle between ON and OFF.

weapon - richter scale of movement (default 40)

weapon - if you give a weapon value of 40, the X and Y displacement 
can vary between -20 and +20, a range of 40.
*/
void trigger_earthquake()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	precache_sound ("equake/rumble.wav");
	
	if (!self.weapon)
		self.weapon = 40;	
	
	self.weapon = self.weapon * 0.5;
	self.delay = 1;
	self.touch = Rogue_earthquake_touch;

	if (self.targetname)
	{
		self.use = Rogue_earthquake_use;
		self.delay = 0;
	}

	InitTrigger();
};

void Rogue_kill_earthquake()
{
	local entity 	eq;

	if ( other.classname != "player" )
		return;
	
	eq = find (world, classname, "earthquake");
	if (eq != world)
	{
		rog_earthquake_active = 0;
		remove (eq); 
	}
};

/*QUAKED trigger_earthquake_kill (.5 .5 .5) ?
Trigger to kill the level-wide earthquake.
*/
void trigger_earthquake_kill()
{
	self.touch = Rogue_kill_earthquake;

	InitTrigger();
};