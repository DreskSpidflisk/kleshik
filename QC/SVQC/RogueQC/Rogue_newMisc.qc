// Miscellaneous items used in the Rogue XPACK


/*QUAKED light_lantern (0 .5 0) (-10 -10 -20) (10 10 20)
Light-emitting lantern.
Default light value is 200
Default style is 0
*/
void light_lantern()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	precache_model ("progs/lantern.mdl");
	setmodel (self, "progs/lantern.mdl");
	makestatic (self);
};

// DRESK
// Remove Various Teamplay Entities
void info_player_team1()
{
	remove(self);
}
void info_player_team2()
{
	remove(self);
}
void item_flag()
{
	remove(self);
}
void item_flag_team1()
{
	remove(self);
}
void item_flag_team2()
{
	remove(self);
}
void func_ctf_wall()
{
	remove(self);
}
void item_sphere()
{
	remove(self);
}
void dmatch_tag_token()
{
	remove(self);
}
void item_random_powerup()
{
	// DRESK
	// Replace just in case it would trigger something
	self.classname = "item_artifact_envirosuit";
	item_artifact_envirosuit();
}

/*QUAKED light_candle (0 .5 0) (-4 -4 -10) (4 4 10)
Candle
Default light value is 200
Default style is 0
*/
void light_candle()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	precache_model ("progs/candle.mdl");
	setmodel (self, "progs/candle.mdl");
	makestatic (self);
};

// ==========================================
// rubble generator
// ==========================================
void Rogue_rubble_touch()
{
	if ( other.classname == "player" || other.flags & FL_MONSTER )
	{
		if ( vlen ( self.velocity ) > 0)
		{
			T_Damage ( other, self, self, HITLOCATION_SELFORIGIN, DAMAGETYPE_ENVIRONMENT_RUBBLETOUCH, 10 );
		}
	}
};

void Rogue_rubble_throw()
{
	local vector	throw;
	local entity	rubble;
	
	rubble = find ( world, targetname, self.target );
	throw = normalize ( rubble.origin - self.origin );
	throw_x = throw_x + (random() * 0.2) - 0.1;
	throw_y = throw_y + (random() * 0.2) - 0.1;
	throw_z = throw_z + (random() * 0.2) - 0.1;
	
	rubble = spawn ();
	rubble.owner = self;
	rubble.classname = "rubble";
	rubble.movetype = MOVETYPE_BOUNCE;
	rubble.solid = SOLID_BBOX;
	rubble.velocity = throw * 300;
	setmodel ( rubble, "progs/rubble.mdl");
	setsize ( rubble, '-16 -16 -16', '16 16 16');
	setorigin ( rubble, self.origin );
	rubble.touch = Rogue_rubble_touch;
	
	rubble.think = SUB_Remove;
	rubble.nextthink = time + 30;
	
	if (self.spawnflags & 1)
		rubble.skin = 1;
	else
		rubble.skin = 0;

	self.think = Rogue_rubble_throw;
	self.nextthink = time + self.delay;
};

void Rogue_rubble_use()
{
	if (self.wait == 0)
	{
		self.think = Rogue_rubble_throw;
		self.nextthink = time + self.delay;
		self.wait = 1;
	}
	else
	{
		self.nextthink = time - 1;
		self.wait = 0;
	}
};

/*QUAKED rubble_generator (1 1 0) (-8 -8 -8) (8 8 8) LavaRock Active
Rubble Generator - cave colored rock chunks flung at the target. Triggering the generator will turn it off and on.

LavaRock - a lava rock texture, based on rich's pumice
Active - start the generator immediately.

delay - time between rubble pieces (Default 5 sec)
*/
void rubble_generator()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	precache_model ("progs/rubble.mdl");
	
	if (!self.target)
		objerror ("rubble_generator has no target!");
		
	if (!self.delay)
		self.delay = 5;
	
	self.solid = SOLID_NOT;
	self.use = Rogue_rubble_use;

	if (self.spawnflags & 2)
		Rogue_rubble_use();		
};


void trigEx_die()
{
	SUB_UseTargets();

	self.touch = SUB_Null;
	self.nextthink = time + 0.1;
	self.think = SUB_Remove;
};

/*QUAKED trigger_explosion (.5 .5 .5) ? 
Variable sized repeatable trigger.  Must be targeted at one or more entities. Only set off when killed, and is only damaged by T_RadiusDamage.

health: amount of damage needed to set off trigger.
*/
void trigger_explosion()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	InitTrigger ();

	if (!self.health)
		self.health = 20;
	
	self.max_health = self.health;
	self.th_die = trigEx_die;
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_BBOX;
	setorigin (self, self.origin);	// make sure it links into the world
};

