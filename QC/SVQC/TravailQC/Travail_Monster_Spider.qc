/*
==============================================================================

SPIDER

==============================================================================
*/
$cd /raid/quake/id1/models/spider
$origin 0 0 -24
$base base
$skin skin
$scale 0.7

$frame frame1 frame2 frame3 frame4 frame5 frame6 frame7 frame8 frame9 frame10
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10 pain11

void() spid_leap1;
void() spider_pain;


void() spid_stand     =[      $frame1,       spid_stand    ] {ai_stand();};

void() spid_walk1     =[      $frame1,       spid_walk2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "spider/sidle.wav", 1, ATTN_IDLE);
ai_walk(4);};
void() spid_walk2     =[      $frame2,       spid_walk3    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
        ai_walk(4);};
void() spid_walk3     =[      $frame3,       spid_walk4    ] {ai_walk(4);};
void() spid_walk4     =[      $frame4,       spid_walk5    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
        ai_walk(4);};
void() spid_walk5     =[      $frame5,       spid_walk6    ] {ai_walk(4);};
void() spid_walk6     =[      $frame6,       spid_walk7    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
        ai_walk(4);};
void() spid_walk7     =[      $frame7,       spid_walk8    ] {ai_walk(4);};
void() spid_walk8     =[      $frame8,       spid_walk9    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
        ai_walk(4);};
void() spid_walk9     =[      $frame9,       spid_walk10    ] {ai_walk(4);};
void() spid_walk10    =[      $frame10,       spid_walk1    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
        ai_walk(4);};

void() spid_run1     =[      $frame1,       spid_run2    ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "spider/sidle.wav", 1, ATTN_IDLE);
ai_run(12);};
void() spid_run2     =[      $frame3,       spid_run3    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
	ai_run(12);};
void() spid_run3     =[      $frame5,       spid_run4    ] {ai_run(12);};
void() spid_run4     =[      $frame7,       spid_run5    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
	ai_run(12);};
void() spid_run5     =[      $frame9,       spid_run6    ] {ai_run(12);};
void() spid_run6     =[      $frame1,       spid_run7    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
	ai_run(12);};
void() spid_run7     =[      $frame3,       spid_run8    ] {ai_run(12);};
void() spid_run8     =[      $frame5,       spid_run9    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
	ai_run(12);};
void() spid_run9     =[      $frame7,       spid_run10    ] {ai_run(12);};
void() spid_run10    =[      $frame9,       spid_run1    ] {
	sound (self,CHAN_VOICE, "spider/swalk.wav", 1, ATTN_IDLE);
	ai_run(12);};

//SC

void() spid_pain1       =[      $pain1, spid_pain2      ] {};
void() spid_pain2       =[      $pain2, spid_pain3      ] {};
void() spid_pain3       =[      $pain3, spid_pain4      ] {};
void() spid_pain4       =[      $pain4, spid_pain5      ] {};
void() spid_pain5       =[      $pain5, spid_pain6      ] {};
void() spid_pain6       =[      $pain6, spid_pain7      ] {};
void() spid_pain7       =[      $pain7, spid_pain8      ] {};
void() spid_pain8       =[      $pain8, spid_pain9      ] {};
void() spid_pain9       =[      $pain9, spid_pain10     ] {};
void() spid_pain10      =[      $pain10, spid_pain11    ] {};
void() spid_pain11      =[      $pain11, spid_run1      ] {};

void() spid_death1      =[      $death1,        spid_death3     ] {};
void() spid_death2      =[      $death1,        spid_death3     ] {};
void() spid_death3      =[      $death2,        spid_death4     ] {};
void() spid_death4      =[      $death3,        spid_death5     ] {};
void() spid_death5      =[      $death4,        spid_death6     ] {};
void() spid_death6      =[      $death5,        spid_death7     ] {};
void() spid_death7      =[      $death6,        spid_death8    ] {};
void() spid_death8      =[      $death7,        spid_death9    ] {};
void() spid_death9      =[      $death8,        spid_death10    ] {};
void() spid_death10     =[      $death9,        spid_death11    ] {};
void() spid_death11     =[      $death10,       spid_death11    ] {};

void spider_pain()
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "spider/spain.wav", 1, ATTN_NORM);
	self.velocity_x = -50 - 50 * random();
	self.velocity_y = 0;
	self.velocity_z = 150 + 150*random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	spid_pain1();
	self.pain_finished = time + 3;
}

void spider_die()
{
	// check for gib
	if(self.health < self.nGibHealth)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/gib2.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

	sound (self, CHAN_VOICE, "spider/sdeath.wav", 1, ATTN_NORM);
	spid_death1();
}

/*
==============
CheckSpiderJump

==============
*/
float CheckSpiderJump()
{
	local	vector	dist;
	local	float	d;

   if (random() < 0.4)
      return TRUE;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;

	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;

	dist = self.enemy.origin - self.origin;
	dist_z = 0;

	d = vlen(dist);

	if (d < 100)
		return FALSE;

	if (d > 200)
	{
		if (random() < 0.9)
			return FALSE;
        }

	return TRUE;
}


void Spider_JumpTouch()
{
	local	float	ldmg;

	if (self.health <= 0)
		return;

	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 300 )
		{
			sound (self, CHAN_AUTO, "spider/sattack2.wav", 1, ATTN_NORM);
			ldmg = 10 + 10*random();
			T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_OTHER, ldmg);
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
			self.think = spid_leap1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}
	self.think = spid_run1;
	self.nextthink = time + 0.1;
}

void spid_leap1() [	$death1,		spid_leap2	]
{
	local vector dir;
	local float dist;

	if (self.health <= 0)
	{
		self.touch = SUB_Null;
		self.think = spid_death1;
		return;
	}

	ai_face();

	self.touch = Spider_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	if (self.enemy.origin_z > self.origin_z + 40)
	{
		if ( infront(self.enemy) || self.waterlevel == 1 )
		{
			dir = normalize(self.enemy.origin - self.origin);
			dist = vlen(self.enemy.origin - self.origin);
			self.velocity = dir * dist;
		}
		else
			self.velocity = v_forward * 150;

		dist = self.enemy.origin_z - self.origin_z;

		// a vertical velocity to jump just above player's head
		// for any given distance between z origins.
		// (hack numbers that work for Quake)
		dist = dist - 237;
		self.velocity_z = 714 + dist;
	}
	else
	{
		// slow forward to fall off ledge if player down
		// else normal horizontal velocity
		if (self.enemy.origin_z < self.origin_z - 40)
			self.velocity = v_forward * 150;
		else
			self.velocity = v_forward * 600;

		// check for wall in front
		traceline( self.origin - '0 0 16',
		(self.origin - '0 0 16') + v_forward*150, TRUE, self);

		// attempt to jump wall or normal vel.
		if (trace_fraction < 1)
		{
			self.velocity = v_forward * 110;
			self.velocity_z = 250 * (random() + 1);
		}
		else
			self.velocity_z = 250;
	}


	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
}
void() spid_leap2	=[	$death2,		spid_leap3	] {};
void() spid_leap3	=[	$death3,		spid_run1	]
{
	self.nextthink = time + 3;
}


void spider_attack()
{
	if (CheckSpiderJump())
	{
		sound (self, CHAN_VOICE, "spider/sattack.wav", 1, ATTN_NORM);
		spid_leap1();
	}
	return;
}

//=================================================================

/*QUAKED monster_spider (1 0 0) (-32 -32 -24) (32 32 48) Ambush
*/
void monster_spider()
{
	GameModeFeatureDetected_Travail();
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.strMonsterDisplayName = "Spider";
	
	// DRESK
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;
		
	precache_model ("progs/spider.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("spider/swalk.wav");
	precache_sound ("spider/sattack.wav");
	precache_sound ("spider/sattack2.wav");
	precache_sound ("spider/shit.wav");
	precache_sound ("spider/sdeath.wav");
	precache_sound ("spider/sidle.wav");
	precache_sound ("spider/spain.wav");
	precache_sound ("spider/ssight.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/spider.mdl");
	setsize (self, '-32 -32 -24', '32 32 5');
	self.health = 200;
	
	// DRESK
	Monster_PrepareGenericSightSoundFunction("spider/ssight.wav");
	// Assign Gib Health
	self.nGibHealth = -40;

	self.th_stand = spid_stand;
	self.th_walk = spid_walk1;
	self.th_run = spid_run1;
	self.th_die = spider_die;
	self.th_pain = spider_pain;
	self.th_missile = spider_attack;

	walkmonster_start ();
}
