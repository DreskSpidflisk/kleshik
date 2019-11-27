// DRESK
// Kleshik Monster

#define BABYDRAGON_WALKSPEED				12
#define BABYDRAGON_RUNSPEEDMAX				22

#define BABYDRAGON_RUNACCELERATION			2.5
#define BABYDRAGON_ATTACKDECELERATION		3

#define BABYDRAGON_WINGFLAP					if(random() < 0.5) sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_WING1, 1, ATTN_NORM);else sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_WING1, 1, ATTN_NORM);
#define BABYDRAGON_ATTACKVOICE				if(random() < 0.5) sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_ATTACK1, 1, ATTN_NORM);else sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_ATTACK2, 1, ATTN_NORM);

$base dragrest
$skin dragskin

$frame dragon6

$frame drgfly01 drgfly02 drgfly03 drgfly04
$frame drgfly05 drgfly06 drgfly07 drgfly08
$frame drgfly09 drgfly10 drgfly11 drgfly12 drgfly13

$frame drgtrn01 drgtrn02 drgtrn03 drgtrn04 drgtrn05 drgtrn06

$frame drgslh01 drgslh02 drgslh03 drgslh04 drgslh05 drgslh06
$frame drgslh07 drgslh08 drgslh09 drgslh10 drgslh11 drgslh12 drgslh13

$frame drgfir01 drgfir02 drgfir03 drgfir04 drgfir05
$frame drgfir06 drgfir07 drgfir08 drgfir09 drgfir10

$frame drgfix1a drgfix1b drgfix1c
$frame drgfix2a drgfix2b drgfix2c
$frame drgfix3a drgfix3b drgfix3c
$frame drgfix4a drgfix4b drgfix4c
$frame drgfix5a drgfix5b drgfix5c
$frame drgfix6a drgfix6b drgfix6c drgfix6d

$frame drgpan1a drgpan1b drgpan1c
$frame drgpan2a drgpan2b drgpan2c
$frame drgpan3a drgpan3b drgpan3c
$frame drgpan4a drgpan4b drgpan4c
$frame drgpan5a drgpan5b drgpan5c
$frame drgpan6a drgpan6b drgpan6c

$frame drgdth01 drgdth02 drgdth03 drgdth04 drgdth05 drgdth06
$frame drgdth07 drgdth08 drgdth09 drgdth10 drgdth11 drgdth12
$frame drgdth13 drgdth14 drgdth15 drgdth16 drgdth17 drgdth18
$frame drgdth19 drgdth20 drgdth21

// Local Prototypes
void babydragon_SpitFire();
void babydragon_Stab();
void BabyDragonAccelerate(float fAmount);
void BabyDragonDecelerate(float fAmount);

// Fields
.float	fCurrentSpeed;

void babydragon_stand1()			[$drgfly01, babydragon_stand2]	{ai_stand();}
void babydragon_stand2()			[$drgfly02, babydragon_stand3]	{ai_stand();}
void babydragon_stand3()			[$drgfly03, babydragon_stand4]	{ai_stand();}
void babydragon_stand4()			[$drgfly04, babydragon_stand5]	{ai_stand();}
void babydragon_stand5()			[$drgfly05, babydragon_stand6]	{ai_stand();BABYDRAGON_WINGFLAP}
void babydragon_stand6()			[$drgfly06, babydragon_stand7]	{ai_stand();}
void babydragon_stand7()			[$drgfly07, babydragon_stand8]	{ai_stand();}
void babydragon_stand8()			[$drgfly08, babydragon_stand9]	{ai_stand();}
void babydragon_stand9()			[$drgfly09, babydragon_stand10]	{ai_stand();}
void babydragon_stand10()			[$drgfly10, babydragon_stand11]	{ai_stand();BABYDRAGON_WINGFLAP}
void babydragon_stand11()			[$drgfly11, babydragon_stand12]	{ai_stand();}
void babydragon_stand12()			[$drgfly12, babydragon_stand13]	{ai_stand();}
void babydragon_stand13()			[$drgfly13, babydragon_stand1]	{ai_stand();}

void babydragon_walk1()				[$drgfly01, babydragon_walk2]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk2()				[$drgfly02, babydragon_walk3]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk3()				[$drgfly03, babydragon_walk4]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk4()				[$drgfly04, babydragon_walk5]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk5()				[$drgfly05, babydragon_walk6]	{ai_walk(BABYDRAGON_WALKSPEED);BABYDRAGON_WINGFLAP}
void babydragon_walk6()				[$drgfly06, babydragon_walk7]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk7()				[$drgfly07, babydragon_walk8]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk8()				[$drgfly08, babydragon_walk9]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk9()				[$drgfly09, babydragon_walk10]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk10()			[$drgfly10, babydragon_walk11]	{ai_walk(BABYDRAGON_WALKSPEED);BABYDRAGON_WINGFLAP}
void babydragon_walk11()			[$drgfly11, babydragon_walk12]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk12()			[$drgfly12, babydragon_walk13]	{ai_walk(BABYDRAGON_WALKSPEED);}
void babydragon_walk13()			[$drgfly13, babydragon_walk1]	{ai_walk(BABYDRAGON_WALKSPEED);}

void babydragon_run1()				[$drgfly01, babydragon_run2]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run2()				[$drgfly02, babydragon_run3]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run3()				[$drgfly03, babydragon_run4]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run4()				[$drgfly04, babydragon_run5]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run5()				[$drgfly05, babydragon_run6]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);BABYDRAGON_WINGFLAP}
void babydragon_run6()				[$drgfly06, babydragon_run7]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run7()				[$drgfly07, babydragon_run8]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run8()				[$drgfly08, babydragon_run9]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run9()				[$drgfly09, babydragon_run10]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run10()				[$drgfly10, babydragon_run11]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);BABYDRAGON_WINGFLAP}
void babydragon_run11()				[$drgfly11, babydragon_run12]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run12()				[$drgfly12, babydragon_run13]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}
void babydragon_run13()				[$drgfly13, babydragon_run1]	{BabyDragonAccelerate(BABYDRAGON_RUNACCELERATION);ai_run(self.fCurrentSpeed);}

void babydragon_fire1()				[$drgfir01, babydragon_fire2]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);BABYDRAGON_ATTACKVOICE}
void babydragon_fire2()				[$drgfir02, babydragon_fire3]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire3()				[$drgfir03, babydragon_fire4]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);BABYDRAGON_WINGFLAP}
void babydragon_fire4()				[$drgfir04, babydragon_fire5]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire5()				[$drgfir05, babydragon_fire6]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire6()				[$drgfir06, babydragon_fire7]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire7()				[$drgfir07, babydragon_fire8]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);babydragon_SpitFire(); }
void babydragon_fire8()				[$drgfir08, babydragon_fire9]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire9()				[$drgfir09, babydragon_fire10]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire10()			[$drgfir10, babydragon_fire11]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
// Begin Reversing Frames
void babydragon_fire11()			[$drgfir09, babydragon_fire12]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire12()			[$drgfir08, babydragon_fire13]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire13()			[$drgfir07, babydragon_fire14]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire14()			[$drgfir02, babydragon_fire15]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
void babydragon_fire15()			[$drgfir01, babydragon_run1]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);}
/*
void babydragon_fire16()			[$drgfir04, babydragon_fire17]	{ai_face();}
void babydragon_fire17()			[$drgfir03, babydragon_fire18]	{ai_face();}
void babydragon_fire18()			[$drgfir02, babydragon_fire19]	{ai_face();}
void babydragon_fire19()			[$drgfir01, babydragon_run1]	{ai_face();}
*/

void babydragon_stab1()				[$drgslh01, babydragon_stab2]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);BABYDRAGON_ATTACKVOICE};
void babydragon_stab2()				[$drgslh02, babydragon_stab3]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab3()				[$drgslh03, babydragon_stab4]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab4()				[$drgslh04, babydragon_stab5]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab5()				[$drgslh05, babydragon_stab6]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab6()				[$drgslh06, babydragon_stab7]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab7()				[$drgslh07, babydragon_stab8]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);BABYDRAGON_WINGFLAP};
void babydragon_stab8()				[$drgslh08, babydragon_stab9]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab9()				[$drgslh09, babydragon_stab10]	{self.nextthink = time + 0.05; BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab10()			[$drgslh10, babydragon_stab11]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);babydragon_Stab();};
void babydragon_stab11()			[$drgslh11, babydragon_stab12]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab12()			[$drgslh12, babydragon_stab13]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};
void babydragon_stab13()			[$drgslh13, babydragon_run1]	{BabyDragonDecelerate(BABYDRAGON_ATTACKDECELERATION);ai_charge(self.fCurrentSpeed);};

void babydragon_painA1()			[$drgpan3a, babydragon_painA2]	{}
void babydragon_painA2()			[$drgpan3b, babydragon_painA3]	{}
void babydragon_painA3()			[$drgpan3c, babydragon_run1]	{}

void babydragon_painB1()			[$drgpan4a, babydragon_painB2]	{}
void babydragon_painB2()			[$drgpan4b, babydragon_painB3]	{}
void babydragon_painB3()			[$drgpan4c, babydragon_run1]	{}

void babydragon_death1()			[$drgdth01, babydragon_death2]
{
	// Reduce Size to Fit Dragon into Ground
	setsize(self, '-16 -16 -8', '16 16 0');
	
	// Assign Scrag Death Velocities
	GORE_STANDARDFLYINGMONSTERDEATHVELOCITY;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
}
void babydragon_death2()			[$drgdth02, babydragon_death3]	{}
void babydragon_death3()			[$drgdth03, babydragon_death4]	{self.angles_z = 45;}
void babydragon_death4()			[$drgdth04, babydragon_death5]	{}
void babydragon_death5()			[$drgdth05, babydragon_death6]	{}
void babydragon_death6()			[$drgdth06, babydragon_death7]	{self.angles_z = 90;}
void babydragon_death7()			[$drgdth07, babydragon_death8]	{}
void babydragon_death8()			[$drgdth08, babydragon_death8]	{self.angles_z = 135;PrepareEntityCorpseTwitch(1);}
/*
// Unused death frames
void babydragon_death9()			[$drgdth09, babydragon_death10]	{}
void babydragon_death10()			[$drgdth10, babydragon_death11]	{}
void babydragon_death11()			[$drgdth11, babydragon_death12]	{}
void babydragon_death12()			[$drgdth12, babydragon_death16]	{}
void babydragon_death13()			[$drgdth13, babydragon_death14]	{}
void babydragon_death14()			[$drgdth14, babydragon_death15]	{}
void babydragon_death15()			[$drgdth15, babydragon_death20]	{}
void babydragon_death16()			[$drgdth16, babydragon_death20]	{}
void babydragon_death17()			[$drgdth17, babydragon_death18]	{}
void babydragon_death18()			[$drgdth18, babydragon_death19]	{}
void babydragon_death19()			[$drgdth19, babydragon_death20]	{}
void babydragon_death20()			[$drgdth20, babydragon_death21]	{}
void babydragon_death21()			[$drgdth21, babydragon_death21]	{}
*/

void BabyDragonAccelerate(float fAmount)
{
	self.fCurrentSpeed = self.fCurrentSpeed + fAmount;
	if(self.fCurrentSpeed > BABYDRAGON_RUNSPEEDMAX)
		self.fCurrentSpeed = BABYDRAGON_RUNSPEEDMAX;
}
void BabyDragonDecelerate(float fAmount)
{
	self.fCurrentSpeed = self.fCurrentSpeed - fAmount;
	if(self.fCurrentSpeed < 0)
		self.fCurrentSpeed = 0;
}

void BabyDragonSpitFireTouch()
{
	T_RadiusDamage (self, self.owner, DAMAGETYPE_MONSTER_BABYDRAGON_MISSILE, 65, world);
	te_FireBallExplosion(self.origin);
	remove(self);
}
void babydragon_SpitFire()
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
	vOrigin = self.origin + (v_forward * 15) + (v_up * 10);
	setorigin(enSpawn, vOrigin);
	
	local vector vDestination;
	vDestination = GetLeadingProjectileOrigin(self, vOrigin, self.enemy, 800, 0.2);
	
	enSpawn.velocity = normalize(vDestination) * 800;
	enSpawn.angles = vectoangles(enSpawn.velocity);
	
	enSpawn.touch = BabyDragonSpitFireTouch;
	
	// Backup Attack Finished
	self.attack_finished = time + random() + 0.5;
}
void babydragon_Stab()
{
	local vector vDistance;
	vDistance = self.enemy.origin - self.origin;

	if( (vlen(vDistance) > 100) || !(CanDamage(self.enemy, self) ) )
	{
		sound(self, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABMISS, 1, ATTN_NORM);
		return;
	}
		
	local float fDamage;
		fDamage = 35 + (random() * 20);
	T_Damage(self.enemy, self, self, self.origin + v_forward * 16, DAMAGETYPE_MONSTER_BABYDRAGON_MELEE, fDamage);
	
	if(random() < 0.5)
		sound(self.enemy, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT1, 1, ATTN_NORM);
	else
		sound(self.enemy, CHAN_AUTO, SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT2, 1, ATTN_NORM);
}

void babydragon_pain(entity enAttacker, float fDamage, float fDamageType)
{
	if(self.pain_finished > time)
		return;
		
	// Update Pain Finished
	self.pain_finished = time + 3;
	
	if(random() < 0.5)
		sound(self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_BABYDRAGON_PAIN1, 1, ATTN_NORM);
	else
		sound(self, CHAN_VOICE, SOUND_KLESHIK_MONSTERS_BABYDRAGON_PAIN2, 1, ATTN_NORM);
	
	if(random() < 0.5)
		babydragon_painA1();
	else
		babydragon_painB1();
}

void babydragon_death(float fDamageType)
{
	if (self.health < self.nGibHealth)
	{
		sound (self, CHAN_VOICE, GetRandomGenericCorpseGibSound(self), 1, ATTN_NORM);
		ThrowHead ("progs/drggib01.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		// Reduce Scale Further
		self.scale = 0.2;
		// Use Standards Gibs for Proper Scale
		GORE_THROWSTANDARDGIBS;
	}
	else
	{
		self.fpMonsterDeathSoundFunction(CHAN_VOICE, ATTN_NORM);
		babydragon_death1();
	}
}

void monster_kleshik_babydragon()
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.strMonsterDisplayName = "Baby Dragon";
	
	// DRESK
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;
	
	// Adjust Scale from Base Dragon
	self.scale = 0.4;
	
	// Assign Cannot Become Elite Monster
	self.bCannotBecomeEliteMonster = TRUE;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MONSTER_LANDMONSTER_DEFAULTMOVETYPE;

	setmodel(self, "progs/dragon.mdl");

	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 315;
	self.nGibHealth = -40;
	
	// Assign Yaw Speed for Quick Turning
	self.yaw_speed = 35;
	
	Monster_PrepareGenericSightSoundFunction(SOUND_KLESHIK_MONSTERS_BABYDRAGON_SIGHT);
	Monster_PrepareGenericDeathSoundFunction(SOUND_KLESHIK_MONSTERS_BABYDRAGON_DEATH);

	self.th_stand = babydragon_stand1;
	self.th_walk = babydragon_walk1;
	self.th_run = babydragon_run1;
	self.th_melee = babydragon_stab1;
	self.th_missile = babydragon_fire1;
	self.th_pain = babydragon_pain;
	self.th_die = babydragon_death;
		
	flymonster_start ();
}
void monster_kleshik_babydragon_Precache()
{
	// Precache Assets
	precache_model("progs/dragon.mdl");
	precache_model("progs/fireball.mdl");
	precache_model("progs/drggib01.mdl");
	precache_model("progs/drggib02.mdl");
	precache_model("progs/drggib03.mdl");
	
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_ATTACK1);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_ATTACK2);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_DEATH);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_PAIN1);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_PAIN2);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_SIGHT);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT1);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABHIT2);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_STABMISS);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_WING1);
	precache_sound(SOUND_KLESHIK_MONSTERS_BABYDRAGON_WING2);
	
	precache_sound(SOUND_KLESHIK_MONSTERS_THROWFIREBALL);
}