// DRESK
// Kleshik Monster

$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

void FireFiend_ThrowFire(float fSideOffset);
void FireFiend_Melee();

#define FIREFIEND_IDLESOUND				if(random() < 0.15){if(random() < 0.5)sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_IDLE1, 1, ATTN_IDLE);else sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_IDLE2, 1, ATTN_IDLE);}

void firefiend_stand1()					=[$stand1,		firefiend_stand2	]
{
	FIREFIEND_IDLESOUND
	ai_stand();
}
void firefiend_stand2()					=[$stand2,		firefiend_stand3	] {ai_stand();}
void firefiend_stand3()					=[$stand3,		firefiend_stand4	] {ai_stand();}
void firefiend_stand4()					=[$stand4,		firefiend_stand5	] {ai_stand();}
void firefiend_stand5()					=[$stand5,		firefiend_stand6	] {ai_stand();}
void firefiend_stand6()					=[$stand6,		firefiend_stand7	] {ai_stand();}
void firefiend_stand7()					=[$stand7,		firefiend_stand8	] {ai_stand();}
void firefiend_stand8()					=[$stand8,		firefiend_stand9	] {ai_stand();}
void firefiend_stand9()					=[$stand9,		firefiend_stand10	] {ai_stand();}
void firefiend_stand10()				=[$stand10,		firefiend_stand11	] {ai_stand();}
void firefiend_stand11()				=[$stand11,		firefiend_stand12	] {ai_stand();}
void firefiend_stand12()				=[$stand12,		firefiend_stand13	] {ai_stand();}
void firefiend_stand13()				=[$stand13,		firefiend_stand1	] {ai_stand();}

void firefiend_walk1()					=[$walk1,		firefiend_walk2	]
{
	FIREFIEND_IDLESOUND
};
void firefiend_walk2()					=[$walk2,		firefiend_walk3	] {ai_walk(6);};
void firefiend_walk3()					=[$walk3,		firefiend_walk4	] {ai_walk(6);};
void firefiend_walk4()					=[$walk4,		firefiend_walk5	] {ai_walk(7);};
void firefiend_walk5()					=[$walk5,		firefiend_walk6	] {ai_walk(4);DEMON_WALKSOUND;};
void firefiend_walk6()					=[$walk6,		firefiend_walk7	] {ai_walk(6);};
void firefiend_walk7()					=[$walk7,		firefiend_walk8	] {ai_walk(10);};
void firefiend_walk8()					=[$walk8,		firefiend_walk1	] {ai_walk(10);DEMON_WALKSOUND;};

void firefiend_run1()					=[$walk1,		firefiend_run2	]
{
	FIREFIEND_IDLESOUND
};
void firefiend_run2()					=[$walk2,		firefiend_run3	] {ai_run(4);};
void firefiend_run3()					=[$walk3,		firefiend_run4	] {ai_run(4);};
void firefiend_run4()					=[$walk4,		firefiend_run5	] {ai_run(4);};
void firefiend_run5()					=[$walk5,		firefiend_run6	] {ai_run(3);DEMON_WALKSOUND;};
void firefiend_run6()					=[$walk6,		firefiend_run7	] {ai_run(4);};
void firefiend_run7()					=[$walk7,		firefiend_run8	] {ai_run(6);};
void firefiend_run8()					=[$walk8,		firefiend_run1	] {ai_run(6);DEMON_WALKSOUND;};

void firefiend_fire1()					=[$attacka1,	firefiend_fire2	] {ai_charge(4);};
void firefiend_fire2()					=[$attacka2,	firefiend_fire3	] {ai_charge(0);};
void firefiend_fire3()					=[$attacka3,	firefiend_fire4	] {ai_charge(0);};
void firefiend_fire4()					=[$attacka4,	firefiend_fire5	] {ai_charge(1);PlayMonsterSwingSound(MONSTER_SWINGTYPE_STANDARD);};
void firefiend_fire5()					=[$attacka5,	firefiend_fire6	] {ai_charge(2); FireFiend_ThrowFire(-25); };
void firefiend_fire6()					=[$attacka6,	firefiend_fire7	] {ai_charge(1);};
void firefiend_fire7()					=[$attacka7,	firefiend_fire8	] {ai_charge(6);DEMON_WALKSOUND;};
void firefiend_fire8()					=[$attacka8,	firefiend_fire9	] {ai_charge(8);};
void firefiend_fire9()					=[$attacka9,	firefiend_fire10] {ai_charge(4);};
void firefiend_fire10()					=[$attacka10,	firefiend_fire11] {ai_charge(2);PlayMonsterSwingSound(MONSTER_SWINGTYPE_STANDARD);};
void firefiend_fire11()					=[$attacka11,	firefiend_fire12] {FireFiend_ThrowFire(25); };
void firefiend_fire12()					=[$attacka12,	firefiend_fire13] {ai_charge(5);};
void firefiend_fire13()					=[$attacka13,	firefiend_fire14] {ai_charge(8);DEMON_WALKSOUND;};
void firefiend_fire14()					=[$attacka14,	firefiend_fire15] {ai_charge(4);};
void firefiend_fire15()					=[$attacka15,	firefiend_run1] {ai_charge(4);};

void firefiend_melee1()					=[$attacka1,	firefiend_melee2	] {ai_charge(4);};
void firefiend_melee2()					=[$attacka2,	firefiend_melee3	] {ai_charge(0);};
void firefiend_melee3()					=[$attacka3,	firefiend_melee4	] {ai_charge(0);};
void firefiend_melee4()					=[$attacka4,	firefiend_melee5	] {ai_charge(1);PlayMonsterSwingSound(MONSTER_SWINGTYPE_STANDARD);};
void firefiend_melee5()					=[$attacka5,	firefiend_melee6	] {ai_charge(2); FireFiend_Melee(); };
void firefiend_melee6()					=[$attacka6,	firefiend_melee7	] {ai_charge(1);};
void firefiend_melee7()					=[$attacka7,	firefiend_melee8	] {ai_charge(6);DEMON_WALKSOUND;};
void firefiend_melee8()					=[$attacka8,	firefiend_melee9	] {ai_charge(8);};
void firefiend_melee9()					=[$attacka9,	firefiend_melee10] {ai_charge(4);};
void firefiend_melee10()				=[$attacka10,	firefiend_melee11] {ai_charge(2);PlayMonsterSwingSound(MONSTER_SWINGTYPE_STANDARD);};
void firefiend_melee11()				=[$attacka11,	firefiend_melee12] { FireFiend_Melee(); };
void firefiend_melee12()				=[$attacka12,	firefiend_melee13] {ai_charge(5);};
void firefiend_melee13()				=[$attacka13,	firefiend_melee14] {ai_charge(8);DEMON_WALKSOUND;};
void firefiend_melee14()				=[$attacka14,	firefiend_melee15] {ai_charge(4);};
void firefiend_melee15()				=[$attacka15,	firefiend_run1] {ai_charge(4);};

void firefiend_pain1()					=[$pain1,		firefiend_pain2	] {};
void firefiend_pain2()					=[$pain2,		firefiend_pain3	] {};
void firefiend_pain3()					=[$pain3,		firefiend_pain4	] {};
void firefiend_pain4()					=[$pain4,		firefiend_pain5	] {};
void firefiend_pain5()					=[$pain5,		firefiend_pain6	] {};
void firefiend_pain6()					=[$pain6,		firefiend_run1	] {};

void firefiend_death1()					=[$death1,		firefiend_death2] {};
void firefiend_death2()					=[$death2,		firefiend_death3] {};
void firefiend_death3()					=[$death3,		firefiend_death4] {};
void firefiend_death4()					=[$death4,		firefiend_death5] {};
void firefiend_death5()					=[$death5,		firefiend_death6] {};
void firefiend_death6()					=[$death6,		firefiend_death7] {};
void firefiend_death7()					=[$death7,		firefiend_death8] {};
void firefiend_death8()					=[$death8,		firefiend_death9] {MonsterAnimationSmack();};
void firefiend_death9()					=[$death9,		firefiend_death9] { PrepareEntityCorpseTwitch(1); };

void FireFiend_Melee()
{
	local vector vDistance;
	vDistance = self.enemy.origin - self.origin;

	if( (vlen(vDistance) > 100) || !(CanDamage(self.enemy, self) ) )
	{
		return;
	}
		
	local float fDamage;
		fDamage = 15 + (random() * 10);
	T_Damage(self.enemy, self, self, self.origin + v_forward * 16, DAMAGETYPE_MONSTER_FIREFIEND_MELEE, fDamage);
	
	sound(self.enemy, CHAN_AUTO, "demon/dhit2.wav", 1, ATTN_NORM);
}

void firefiend_pain(entity enAttacker, float fDamage, float fDamageType)
{
	if (self.pain_finished > time)
		return;
		
	// Update Pain Finished
	self.pain_finished = time + 3;

    // Play Sound
	if( random() < 0.5)
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_PAIN1, 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_PAIN2, 1, ATTN_NORM);
		
	firefiend_pain1();
}

void FireFiendFireTouch()
{
	T_RadiusDamage (self, self.owner, DAMAGETYPE_MONSTER_FIREFIEND_MISSILE, 90, world);
	te_FireBallExplosion(self.origin);
	remove(self);
}
void FireFiend_ThrowFire(float fSideOffset)
{
	sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_THROWFIREBALL, 1, ATTN_NORM);
	makevectors(self.angles);
	local entity enSpawn;
	enSpawn = spawn();
	enSpawn.solid = SOLID_BBOX;
	enSpawn.owner = self;
	setmodel(enSpawn, "progs/fireball.mdl");
	setsize(enSpawn, VEC_ORIGIN, VEC_ORIGIN);
	enSpawn.movetype = MOVETYPE_FLY;
	
	enSpawn.modelflags = MF_ROCKET;
	enSpawn.avelocity = '0 0 900';
	
	local vector vOrigin;
	vOrigin = self.origin + (v_forward * 15) + (v_up * 10) + (v_right * fSideOffset);
	setorigin(enSpawn, vOrigin);
	
	local float fVelocity;
		fVelocity = (600 + (random() * 600) );
	
	local vector vDestination;
	vDestination = GetLeadingProjectileOrigin(self, vOrigin, self.enemy, fVelocity, 0.05);
	
	enSpawn.velocity = normalize(vDestination) * fVelocity;
	enSpawn.angles = vectoangles(enSpawn.velocity);
	
	enSpawn.touch = FireFiendFireTouch;
	
	// Backup Attack Finished
	self.attack_finished = time + 0.5 + random();
}
void monster_kleshik_firefiend_DeathSound(float nChannel, float nAttentuation)
{
	if( cvar(CVAR_MONSTER_DEATHSOUNDHASNOATTENUATION) )
		nAttentuation = ATTN_NONE;
	if( random() < 0.5)
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_DEATH1, 1, nAttentuation);
	else
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FIREFIEND_DEATH2, 1, nAttentuation);
}
void firefiend_death(float fDamageType)
{
	// Purge Flames
	self.effects = self.effects - (self.effects & EF_FLAME);
	
	if (self.health < self.nGibHealth)
	{
		sound (self, CHAN_VOICE, GetRandomGenericCorpseGibSound(self), 1, ATTN_NORM);
		ThrowHead ("progs/h_demon.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		GORE_THROWSTANDARDGIBS;
	}
	else
	{
		// Play Sound
		self.fpMonsterDeathSoundFunction(CHAN_VOICE, ATTN_NORM);
		// Play Animation
		firefiend_death1();
	}
}

void monster_kleshik_firefiend()
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.strMonsterDisplayName = "Fire Fiend";
	
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MONSTER_LANDMONSTER_DEFAULTMOVETYPE;

	setmodel (self, "progs/demon.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 275;
	self.nGibHealth = -40;
	self.fPreDamageForce_Multiplier = 0.5;
	
	// Assign Flame Effect
	self.effects = EF_FLAME;
	
	// Assign Yaw Speed for Quick Turning
	self.yaw_speed = 35;
	
	Monster_PrepareGenericSightSoundFunction(SOUND_KLESHIK_MONSTERS_FIREFIEND_SIGHT);
	self.fpMonsterDeathSoundFunction = monster_kleshik_firefiend_DeathSound;

	self.th_stand = firefiend_stand1;
	self.th_walk = firefiend_walk1;
	self.th_run = firefiend_run1;
	self.th_melee = firefiend_melee1;
	self.th_missile = firefiend_fire1;
	self.th_pain = firefiend_pain;
	self.th_die = firefiend_death;
		
	walkmonster_start();
}
void monster_kleshik_firefiend_Precache()
{
	// Precache Assets
	precache_model("progs/demon.mdl");
	precache_model("progs/h_demon.mdl");
	precache_model("progs/fireball.mdl");
	
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_DEATH1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_DEATH2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_IDLE1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_IDLE2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_PAIN1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_PAIN2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FIREFIEND_SIGHT);
	
	precache_sound(SOUND_KLESHIK_MONSTERS_THROWFIREBALL);
	precache_sound("demon/dhit2.wav");
}