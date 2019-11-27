// DRESK
// Kleshik Monster

$base base
$skin base

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11 idle12 idle13
$frame dangle1 dangle2 dangle3 dangle4 dangle5 dangle6
$frame fall1 fall2 fall3 fall4 fall5
$frame walk1 walk2 walk3 walk4 walk5
$frame run1 run2 run3 run4
$frame leap1 leap2 leap3 leap4 leap5 leap6
$frame bite1 bite2 bite3 bite4 bite5 bite6 bite7
$frame pain1 pain2
$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7
$frame main1
$frame base

void flisker_LeapTouch();
void flisker_bite();

.entity	enFliskerCorpseBurster_Corpse;
.entity	enFliskerCorpseBursterController;
.entity	enFliskerHealthDegradeController;
.float	bFliskerSkipWalkMonsterStart;
.float	bFliskerLeapTouchNoDamage;

#define FLISKER_IDLESOUND				if(random() < 0.08){if(random() < 0.5)sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_IDLE1, 1, ATTN_IDLE);else sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_IDLE2, 1, ATTN_IDLE);}

void flisker_stand1()					=[$idle1,		flisker_stand2	]
{
	FLISKER_IDLESOUND
	ai_stand();
}
void flisker_stand2()					=[$idle2,		flisker_stand3	] {ai_stand();}
void flisker_stand3()					=[$idle3,		flisker_stand4	] {ai_stand();}
void flisker_stand4()					=[$idle4,		flisker_stand5	] {ai_stand();}
void flisker_stand5()					=[$idle5,		flisker_stand6	] {ai_stand();}
void flisker_stand6()					=[$idle6,		flisker_stand7	] {ai_stand();}
void flisker_stand7()					=[$idle7,		flisker_stand8	] {ai_stand();}
void flisker_stand8()					=[$idle8,		flisker_stand9	] {ai_stand();}
void flisker_stand9()					=[$idle9,		flisker_stand10	] {ai_stand();}
void flisker_stand10()					=[$idle10,		flisker_stand11	] {ai_stand();}
void flisker_stand11()					=[$idle11,		flisker_stand12	] {ai_stand();}
void flisker_stand12()					=[$idle12,		flisker_stand13	] {ai_stand();}
void flisker_stand13()					=[$idle13,		flisker_stand1	] {ai_stand();}

void flisker_walk1()					=[$walk1,		flisker_walk2	]
{
	FLISKER_IDLESOUND
	ai_walk(5);
}
void flisker_walk2()					=[$walk2,		flisker_walk3	] {ai_walk(5);}
void flisker_walk3()					=[$walk3,		flisker_walk4	] {ai_walk(5);}
void flisker_walk4()					=[$walk4,		flisker_walk5	] {ai_walk(5);}
void flisker_walk5()					=[$walk5,		flisker_walk1	] {ai_walk(5);}

void flisker_run1()						=[$run1,		flisker_run2	]
{
	FLISKER_IDLESOUND
	FLISKER_WALKSOUND;
	ai_run(18);
}
void flisker_run2()						=[$run2,		flisker_run3	] {ai_run(18);}
void flisker_run3()						=[$run3,		flisker_run4	] {ai_run(18);FLISKER_WALKSOUND;}
void flisker_run4()						=[$run4,		flisker_run1	] {ai_run(18);}

void flisker_fall1()					=[$fall1,		flisker_fall2	] {self.nextthink = time + 0.05 + random() * 0.1;}
void flisker_fall2()					=[$fall2,		flisker_fall3	] {self.nextthink = time + 0.05 + random() * 0.1;}
void flisker_fall3()					=[$fall3,		flisker_fall4	] {self.nextthink = time + 0.05 + random() * 0.1;}
void flisker_fall4()					=[$fall4,		flisker_fall5	] {self.nextthink = time + 0.05 + random() * 0.1;}
void flisker_fall5()					=[$fall5,		flisker_stand1	] {}

void flisker_pain1()					=[$pain1,		flisker_pain2	] {}
void flisker_pain2()					=[$pain2,		flisker_run1	] {}

void flisker_leap1()					=[$leap1,		flisker_leap2	]
{
	if(random() < 0.5)
		sound(self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_LEAP1, 1.0, ATTN_NORM);
	else
		sound(self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_LEAP2, 1.0, ATTN_NORM);
	ai_face();
}
void flisker_leap2()					=[$leap2,		flisker_leap3	] {ai_face();}
void flisker_leap3()					=[$leap3,		flisker_leap4	] {ai_face();}
void flisker_leap4()					=[$leap4,		flisker_leap5	]
{
	MONSTER_JUMPSOUND;
	ai_face();
	
	self.touch = flisker_LeapTouch;
	makevectors (self.angles);
	
	// Remove Potential Damage Suppress
	self.bFliskerLeapTouchNoDamage = FALSE;
	
	// Jump Directly At Target
	local vector vDestination;
	vDestination = GetLeadingProjectileOrigin(self, self.origin, self.enemy, 800, 0.05);
	
	self.velocity = normalize(vDestination) * 800 + '0 0 225';
	
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
		
	self.attack_finished = time + random() + 1.3;
}
void flisker_leap5()					=[$leap5,		flisker_leap6	] {}
void flisker_leap6()					=[$leap6,		flisker_leap6	] {}

void flisker_bite1()					=[$bite1,		flisker_bite2	] {self.nextthink = time + 0.05; ai_face();}
void flisker_bite2()					=[$bite2,		flisker_bite3	] {self.nextthink = time + 0.05; ai_face();}
void flisker_bite3()					=[$bite3,		flisker_bite4	]
{
	self.nextthink = time + 0.05;
	ai_charge(2);
	flisker_bite();
}
void flisker_bite4()					=[$bite4,		flisker_bite5	] {self.nextthink = time + 0.05; ai_face();}
void flisker_bite5()					=[$bite5,		flisker_bite6	] {self.nextthink = time + 0.05; ai_face();}
void flisker_bite6()					=[$bite6,		flisker_bite7	] {self.nextthink = time + 0.05; ai_face();}
void flisker_bite7()					=[$bite7,		flisker_run1	] {self.nextthink = time + 0.05; }

void flisker_deatha1()					=[$deatha1,		flisker_deatha2	] {};
void flisker_deatha2()					=[$deatha2,		flisker_deatha3	] {};
void flisker_deatha3()					=[$deatha3,		flisker_deatha4	] {};
void flisker_deatha4()					=[$deatha4,		flisker_deatha5	] {};
void flisker_deatha5()					=[$deatha5,		flisker_deatha6	] {};
void flisker_deatha6()					=[$deatha6,		flisker_deatha6	] {PrepareEntityCorpseTwitch(1); };

void flisker_deathb1()					=[$deathb1,		flisker_deathb2	] {};
void flisker_deathb2()					=[$deathb2,		flisker_deathb3	] {};
void flisker_deathb3()					=[$deathb3,		flisker_deathb4	] {};
void flisker_deathb4()					=[$deathb4,		flisker_deathb5	] {};
void flisker_deathb5()					=[$deathb5,		flisker_deathb6	] {};
void flisker_deathb6()					=[$deathb6,		flisker_deathb7	] {};
void flisker_deathb7()					=[$deathb7,		flisker_deathb7	] {PrepareEntityCorpseTwitch(1); };

void flisker_LeapTouch()
{
	local float fDamage;
	if (self.health <= 0)
		return;
		
	if(other.takedamage && !self.bFliskerLeapTouchNoDamage)
	{
		// Suppress Damage until Next Leap
		self.bFliskerLeapTouchNoDamage = TRUE;
		fDamage = 5 + (random() * 5);
		T_Damage(other, self, self, HITLOCATION_NONE, DAMAGETYPE_MONSTER_FLISKER_LEAPTOUCH, fDamage);
		
		if(random() < 0.5)
			sound(other, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT1, 1, ATTN_NORM);
		else
			sound(other, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT2, 1, ATTN_NORM);
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = __NULL__;
			self.think = flisker_run1;
			self.nextthink = time + 0.1;
		}
		return;
	}

	self.touch = __NULL__;
	self.think = flisker_run1;
	self.nextthink = time + 0.1;
}

void flisker_bite()
{
	local vector vDistance;
	vDistance = self.enemy.origin - self.origin;

	if( (vlen(vDistance) > 70) || !(CanDamage(self.enemy, self) ) )
	{
		sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABMISS, 1, ATTN_NORM);
		return;
	}
		
	local float fDamage;
		fDamage = 5 + (random() * 5);
	T_Damage(self.enemy, self, self, self.origin + v_forward * 16, DAMAGETYPE_MONSTER_FLISKER_MELEE, fDamage);
	
	if(random() < 0.5)
		sound(self.enemy, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT1, 1, ATTN_NORM);
	else
		sound(self.enemy, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT2, 1, ATTN_NORM);
}

void flisker_pain(entity enAttacker, float fDamage, float fDamageType)
{
	local string strSound;
	local float nRandom;
	
	if (self.pain_finished > time || fDamageType == DAMAGETYPE_MONSTER_FLISKER_HEALTHDEGRADE)
		return;
		
	// Update Pain Finished
	self.pain_finished = time + 3;
	
	flisker_pain1();
	
	nRandom = random();
	if(nRandom < 0.33)
		strSound = SOUND_KLESHIK_MONSTERS_FLISKER_PAIN1;
	else
	if(nRandom < 0.66)
		strSound = SOUND_KLESHIK_MONSTERS_FLISKER_PAIN2;
	else
		strSound = SOUND_KLESHIK_MONSTERS_FLISKER_PAIN3;
		
	sound(self, CHAN_VOICE, strSound, 1, ATTN_NORM);
}
void monster_kleshik_flisker_DeathSound(float nChannel, float nAttentuation)
{
	// Never play without attenuation (annoying!)
	/*if( cvar(CVAR_MONSTER_DEATHSOUNDHASNOATTENUATION) )
		nAttentuation = ATTN_NONE;*/
	if( random() < 0.5)
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_DEATH1, 1, nAttentuation);
	else
		sound (self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_FLISKER_DEATH2, 1, nAttentuation);
}
void flisker_death(float fDamageType)
{
	// Remove Health Degrade Controller
	CheckAndRemoveEntity(self, enFliskerHealthDegradeController);
	
	if (self.health < self.nGibHealth)
	{
		sound(self, CHAN_VOICE, GetRandomGenericCorpseGibSound(self), 1, ATTN_NORM);
		ThrowHead ("Models/Monsters/Flisker/FliskerLeg.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		GORE_THROWSTANDARDGIBS;
	}
	else
	{
		self.fpMonsterDeathSoundFunction(CHAN_VOICE, ATTN_NORM);
		if(random() < 0.5)
			flisker_deatha1();
		else
			flisker_deathb1();
	}
}
void SpawnFliskersAtCorpse(entity enCorpse)
{
	local entity enOldSelf;
	local float nCnt;
	local float nFliskerCnt;
	enOldSelf = self;
	
	// Suppress Spawn During Intermission
	if(intermission_running)
		nFliskerCnt = 0;
	else
		// Spawn Some Fliskers
		nFliskerCnt = 1 + random() * 2;
	for(nCnt = 0; nCnt < nFliskerCnt; nCnt++)
	{
		self = spawn();
		setorigin(self, enCorpse.origin);
		self.classname = "monster_kleshik_flisker";
		self.bFliskerSkipWalkMonsterStart = TRUE;
		monster_kleshik_flisker();
		// Go into Fall Animation
		flisker_fall1();
		
		// Initialize Monster Here
		self.flags = self.flags | FL_MONSTER;
		self.takedamage = DAMAGE_AIM;
		CheckMonsterPostSpawnFunctionality();
		
		self.velocity_z = 200 + random() * 125;
		self.velocity_x = 100 + random() * 175;
		if(random() < 0.5)
			self.velocity_x *= -1;
		self.velocity_y = 100 + random() * 175;
		if(random() < 0.5)
			self.velocity_y *= -1;
		// Play Sight Sound on First Flisker(on auto channel)
		if(nCnt == 0)
			sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_FLISKER_SIGHT, 1.0, ATTN_NORM);
	}
	
	// Restore Self
	self = enOldSelf;
}
void CheckCorpseForFliskerCorpseBursterController(entity enCorpse)
{ // Check Corpse for Controller
	if(enCorpse.enFliskerCorpseBursterController)
	{ // Corpse Has Controller; Spawn Fliskers
		SpawnFliskersAtCorpse(enCorpse);
	}
}
void FliskerCorpseBursterController_GibCorpse()
{ // Gib Corpse
	if(self.enFliskerCorpseBurster_Corpse && !self.enFliskerCorpseBurster_Corpse.bIsGibbedCorpse)
	{ // Valid Corpse to Gib
		// Gib Corpse
		T_Damage(self.enFliskerCorpseBurster_Corpse, self, self, HITLOCATION_NONE, DAMAGETYPE_MONSTER_FLISKER_CORPSEBURST, self.nGibHealth);
	}
	
	// Remove Controller in Think Operation
	remove(self);
}
void CheckFliskerSpawnCorpseBursterController(entity enCorpse)
{ // Check Flisker Spawn Corpse Burster Controller
	if(!enCorpse.bCannotSpawnFliskers)
	{ // Flisker Spawn Allowed
		// Acquire Percent Chance
		local float fPercent;
		fPercent = cvar(CVAR_MONSTER_FLISKER_CORPSEBURSTPERCENTCHANCE);
			// Recompute
			fPercent = 1.0 - (fPercent / 100);
		
		if(random() >= fPercent)
		{ // Spawn Controller
			local entity enSpawn;
				enSpawn = spawn();
				
			enSpawn.effects = EF_NODRAW;
			enSpawn.classname = "FliskerCorpseBursterController";
			
			// Link Entities
			enSpawn.enFliskerCorpseBurster_Corpse = enCorpse;
			enCorpse.enFliskerCorpseBursterController = enSpawn;
			
			// Setup Think
			enSpawn.think = FliskerCorpseBursterController_GibCorpse;
			enSpawn.nextthink = time + 5 + (random() * 20);
		}
	}
}
void FliskerHealthDegrade()
{
	// Kill Owner (Flisker)
	T_Damage(self.owner, self, self, HITLOCATION_NONE, DAMAGETYPE_MONSTER_FLISKER_HEALTHDEGRADE, self.owner.health);
}
void SpawnFliskerHealthDegradeController(entity enFlisker)
{
	local entity enSpawn;
	enSpawn = spawn();
	enSpawn.effects = EF_NODRAW;
	enSpawn.owner = enFlisker;
	enSpawn.think = FliskerHealthDegrade;
	enSpawn.nextthink = time + 20 + random() * 10;
	enFlisker.enFliskerHealthDegradeController = enSpawn;
}
float FliskerCheckAttack()
{
	local float fDistance;
	fDistance = vlen(self.enemy.origin - self.origin);
	
	if(fDistance < 70)
	{ // Melee
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	else
	if(time > self.attack_finished && fDistance > 130 && fDistance < 800)
	{ // Jump
		self.attack_state = AS_MISSILE;
		return TRUE;
	}
	
	return FALSE;
}

void monster_kleshik_flisker()
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.strMonsterDisplayName = "Flisker";
	
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MONSTER_LANDMONSTER_DEFAULTMOVETYPE;

	setmodel (self, "Models/Monsters/Flisker/Flisker.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 18;
	self.nGibHealth = -20;
	
	// Assign Cannot Spawn Fliskers
	self.bCannotSpawnFliskers = TRUE;
	// Assign Cannot Become Elite Monster
	self.bCannotBecomeEliteMonster = TRUE;
	// Spawn Health Degrade Controller
	SpawnFliskerHealthDegradeController(self);
	// Assign Ignore Monster Stat Tracking
	self.bMonsterIgnoreStatTracking = TRUE;
	
	// Assign Yaw Speed for Quick Turning
	self.yaw_speed = 45;
	
	Monster_PrepareGenericSightSoundFunction(SOUND_KLESHIK_MONSTERS_FLISKER_SIGHT);
	self.fpMonsterDeathSoundFunction = monster_kleshik_flisker_DeathSound;
	self.contentstransition = ContentsTransition_SmallObjectInWater;

	self.th_stand = flisker_stand1;
	self.th_walk = flisker_walk1;
	self.th_run = flisker_run1;
	self.th_melee = flisker_bite1;
	self.th_missile = flisker_leap1;
	self.th_pain = flisker_pain;
	self.th_die = flisker_death;
	self.fpMonsterCheckAttackFunction = FliskerCheckAttack;
		
	if(!self.bFliskerSkipWalkMonsterStart)
		walkmonster_start();
}
void monster_kleshik_flisker_Precache()
{
	precache_model("Models/Monsters/Flisker/Flisker.mdl");
	precache_model("Models/Monsters/Flisker/FliskerLeg.mdl");
	
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_DEATH1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_DEATH2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_IDLE1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_IDLE2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_LEAP1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_LEAP2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_PAIN1);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_PAIN2);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_PAIN3);
	precache_sound(SOUND_KLESHIK_MONSTERS_FLISKER_SIGHT);
	
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABMISS);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT1);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT2);
}