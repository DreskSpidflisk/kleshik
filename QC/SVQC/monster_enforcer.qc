/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

// DRESK
// TRAVAIL SUPPORT
.float	nEnforcerType;

.float	nEnforcerGunType;

void EnforcetRocketTouch()
{
	local float	damg;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	// DRESK
	// Support Elite Monsters
	if(other.bIsEliteMonster)
	{ // Elite Monster; Redirect to Missile Owner
		EliteMonsterRedirectProjectile(other, self);
	}
	else
	{ // Standard
		damg = 60 + random()*30;
		
		// DRESK
		// Remove Potential Gyro Physics Properties
		if(g_bGyroPhysicsEnabled)
			Gyro_Object_ClearPhysics(self);

		T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_ROCKETLAUNCHER, damg, world);

		self.origin = self.origin - 8*normalize(self.velocity);
		te_explosion(self.origin);
		remove(self);
	}
}
void EnforcerGrenadeExplode()
{
	// Remove Potential Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_Object_ClearPhysics(self);
		
	T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_GRENADELAUNCHER, 60 + random()*30, world);
	te_explosion(self.origin);
	remove(self);
}
void EnforcerGrenadeTouch()
{
	// DRESK
	// Support Elite Monster and Non-Owner
	if(other.bIsEliteMonster)
		EliteMonsterRedirectProjectile(other, self);
	else
	if(other.takedamage == DAMAGE_AIM)
	{
		EnforcerGrenadeExplode();
		return;
	}
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
	te_GrenadeBounce(self.origin);
}
void Enforcer_FireRocket(vector vOrigin, vector vDirection)
{
	local entity missile;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	missile.velocity = vDirection * 600;
	
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, vOrigin);
	
	// Produce CSQC TE
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_ROCKET_LAUNCHER, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vOrigin, vDirection);
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Rocket(missile, 800, 1000);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
	
	// Assign Decent Attack Finished
	self.attack_finished = time + random() + 1.0;
}
void Enforcer_FireGrenade(vector vOrigin, vector vDirection)
{
	local entity missile;
	
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_GRENADE_LAUNCHER, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vOrigin, vDirection);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

	missile.velocity = vDirection * 900 + '0 0 20';

	missile.avelocity = '-1200 000 000';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = EnforcerGrenadeTouch;
	missile.think = EnforcerGrenadeExplode;
	missile.nextthink = time + 2.5;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, vOrigin);
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Grenade(missile, 800);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
	
	// Assign Decent Attack Finished
	self.attack_finished = time + random() + 0.8;
}
void Enforcer_FireSniperRifle(vector vOrigin, vector vDirection)
{
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SHOTGUN, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vOrigin, vDirection);
	local entity enBullet;
	enBullet = spawn();
	setmodel(enBullet, "progs/s_spike.mdl");
	setsize(enBullet, VEC_ORIGIN, VEC_ORIGIN);
	enBullet.owner = self;
	enBullet.modelflags = MF_GRENADE;
	enBullet.effects = EF_FULLBRIGHT;
	enBullet.scale = 1.4;
	setorigin(enBullet, vOrigin);
	
	enBullet.movetype = MOVETYPE_NONE;
	enBullet.solid = SOLID_NOT;
	enBullet.think = SniperBulletThink;
	// Delay Nextthink Slightly for Proper Client Interpolation
	enBullet.nextthink = time + 0.05;
	// enBullet.nextthink = time;
	enBullet.velocity = vDirection * 7000;
	enBullet.angles = vectoangles(enBullet.velocity);
	
	// Eject Detail Shell
	local entity enDetail;
	enDetail = spawn();
	setmodel(enDetail, "progs/grenade.mdl");
	setorigin(enDetail, vCurrentShotOrigin);
	enDetail.velocity = (v_right * -1 * (100 + random() * 125) ) + (v_up * (100 + random() * 125) );
	enDetail.owner = self;
	enDetail.contentstransition = ContentsTransition_SmallObjectInWater;
	enDetail.scale = 0.15;
	enDetail.colormod = '0.3 0.3 0.3';
	enDetail.avelocity = randomvec() * 300;
	enDetail.solid = SOLID_TRIGGER;
	enDetail.touch = SniperCasingTouch;
	enDetail.solid = SOLID_TRIGGER;
	enDetail.movetype = MOVETYPE_BOUNCE;
	enDetail.think = SUB_Remove;
	enDetail.nextthink = time + 5.0;
	
	// Assign Decent Attack Finished
	self.attack_finished = time + random() + 1.5;
}
void enforcer_fire()
{
	local vector org;
	local vector vOrigin;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	// DRESK
	// Support Leading Projectile
	if(skill >= cvar(CVAR_MONSTER_SKILLLEVELFORLEADINGPROJECTILES) )
	{ // Lead Projectile
		if(self.nEnforcerGunType == WEAPON_ROCKET_LAUNCHER || self.nEnforcerGunType == WEAPON_GRENADE_LAUNCHER)
			// Accuracy Less with Advanced Guns
			vOrigin = GetLeadingProjectileOrigin(self, org, self.enemy, 600, 0.15);
		else
			vOrigin = GetLeadingProjectileOrigin(self, org, self.enemy, 600, 0.1);
	}
	else
		vOrigin = self.enemy.origin - self.origin;
		
	// DRESK
	// Support Rocket Firing
	if(self.nEnforcerGunType == WEAPON_ROCKET_LAUNCHER)
		Enforcer_FireRocket(org, vOrigin);
	else
	if(self.nEnforcerGunType == WEAPON_GRENADE_LAUNCHER)
		Enforcer_FireGrenade(org, vOrigin);
	else
	if(self.nEnforcerGunType == WEAPON_SHOTGUN)
		Enforcer_FireSniperRifle(org, vOrigin);
	else
	{
		LaunchLaser(org, vOrigin);
		WeaponCSQCTemporaryEntity(etof(self), WEAPON_LASER_GUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, org, vOrigin);
	}
}

//============================================================================

void()	enf_stand1	=[	$stand1,	enf_stand2	] {ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

void()	enf_walk1	=[	$walk1 ,	enf_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_walk(2);};
void()	enf_walk2	=[	$walk2 ,	enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	$walk3 ,	enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4 ,	enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5 ,	enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6 ,	enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7 ,	enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8 ,	enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9 ,	enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {ai_walk(4);SOLDIERS_WALKSOUND;};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);SOLDIERS_WALKSOUND;};

void()	enf_run1	=[	$run1  ,	enf_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_run(18);};
void()	enf_run2	=[	$run2  ,	enf_run3	] {ai_run(14);};
void()	enf_run3	=[	$run3  ,	enf_run4	] {ai_run(7);SOLDIERS_WALKSOUND;};
void()	enf_run4	=[	$run4  ,	enf_run5	] {ai_run(12);};
void()	enf_run5	=[	$run5  ,	enf_run6	] {ai_run(14);};
void()	enf_run6	=[	$run6  ,	enf_run7	] {ai_run(14);SOLDIERS_WALKSOUND;};
void()	enf_run7	=[	$run7  ,	enf_run8	] {ai_run(7);};
void()	enf_run8	=[	$run8  ,	enf_run1	] {ai_run(11);};

void()	enf_atk1	=[	$attack1,	enf_atk2	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {enforcer_fire();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk8	=[	$attack8,	enf_run1	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;
if(!self.nEnforcerGunType)
	SUB_CheckRefire(enf_atk3); };
/*
void()	enf_atk9	=[	$attack5,	enf_atk10	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {enforcer_fire();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {ai_face();APPLYMONSTERATTACKRANDOMNEXTTHINK;};
void()	enf_atk14	=[	$attack10,	enf_run1	] {ai_face();
SUB_CheckRefire (enf_atk1);
APPLYMONSTERATTACKRANDOMNEXTTHINK;
};
*/

void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] {};

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] {};

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] {};
void()	enf_painc6	=[	$painc6,	enf_painc7	] {};
void()	enf_painc7	=[	$painc7,	enf_painc8	] {};
void()	enf_painc8	=[	$painc8,	enf_run1	] {};

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] {};
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1);};
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1);};
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1);SOLDIERS_WALKSOUND;};
void()	enf_paind14	=[	$paind14,	enf_paind15	] {};
void()	enf_paind15	=[	$paind15,	enf_paind16	] {};
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1);};
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1);};
void()	enf_paind18	=[	$paind18,	enf_paind19	] {};
void()	enf_paind19	=[	$paind19,	enf_run1	] {};

void enf_pain(entity attacker, float damage, float fDamageType)
{
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;

	
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(self.nEnforcerType == 4)
	{ // Ultra Enforcer
		if(r < 0.3)
			sound (self, CHAN_VOICE, "enforcer/ue_pain1.wav", 1, ATTN_NORM);
		else
		if(r < 0.6)
			sound (self, CHAN_VOICE, "enforcer/ue_pain2.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/ue_pain3.wav", 1, ATTN_NORM);
	}
	else
	#else
	{ // Standard Enforcer
		if (r < 0.5)
			sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
	}
	#endif

	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		enf_paina1 ();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1;
		enf_painb1 ();
	}
	else if (r < 0.7)
	{
		self.pain_finished = time + 1;
		enf_painc1 ();
	}
	else
	{
		self.pain_finished = time + 2;
		enf_paind1 ();
	}
}

//============================================================================


void()	enf_die1	=[	$death1,	enf_die2	] {};
void()	enf_die2	=[	$death2,	enf_die3	] {};
void()	enf_die3	=[	$death3,	enf_die4	] {};
void()	enf_die4	=[	$death4,	enf_die5	] {ai_forward(14); MonsterAnimationSmack(); };
void()	enf_die5	=[	$death5,	enf_die6	] {ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {};
void()	enf_die7	=[	$death7,	enf_die8	] {};
void()	enf_die8	=[	$death8,	enf_die9	] {};
void()	enf_die9	=[	$death9,	enf_die10	] {ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {ai_forward(5);};
void()	enf_die11	=[	$death11,	enf_die12	] {ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {ai_forward(5); MonsterAnimationSmack(); };
void()	enf_die13	=[	$death13,	enf_die14	] {};
void()	enf_die14	=[	$death14,	enf_die14	] { PrepareEntityCorpseTwitch(3); };

void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	] {};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {self.nextthink = time + 0.08;};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {self.nextthink = time + 0.08;};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {self.nextthink = time + 0.08;};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {self.nextthink = time + 0.05;};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {self.nextthink = time + 0.05;};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {self.nextthink = time + 0.05; MonsterAnimationSmack();};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {self.nextthink = time + 0.05;};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] { PrepareEntityCorpseTwitch(3); };


void enf_die(float fDamageType)
{
	// DRESK
	// Check for Powerup Drop
	CheckMonsterDropPowerup(0.15, POWERUPTYPE_ENVIROSUIT, 0);
	// Check for Potential Armor Drop
	CheckMonsterDropArmor(0.10, ARMORTYPE_GREEN);
	
	if(self.nEnforcerGunType == WEAPON_ROCKET_LAUNCHER)
	{
		if( random() > 0.80)
			self.nCSQCStat_Weapons = WEAPON_ROCKET_LAUNCHER;
	}
	else
	if(self.nEnforcerGunType == WEAPON_GRENADE_LAUNCHER)
	{
		if( random() > 0.80)
			self.nCSQCStat_Weapons = WEAPON_GRENADE_LAUNCHER;
	}
	else
	{
		// Check for Laser Gun Drop
		if( GetWeaponIsAvailable(WEAPON_LASER_GUN) && random() > 0.70)
			self.nCSQCStat_Weapons = WEAPON_LASER_GUN;
	}
	
	// Assign Ammunition Here
	// DRESK
	// TRAVAIL SUPPORT
	if(self.nEnforcerType >= 2)
	{ // Ultra Enforcer
		self.ammo_cells = 10;
		self.ammo_rockets = 2;
	}
	else
		self.ammo_cells = 5;
	self.ammo_shells = 8;
	
	// DRESK
	// Add Rockets if Advanced Gun
	if(self.nEnforcerGunType)
		self.ammo_rockets = 2;
	// Drop Backpack
	DropBackpack();
	
// check for gib
	if (self.health < self.nGibHealth)
	{
		sound (self, CHAN_VOICE, GetRandomGenericCorpseGibSound(self), 1, ATTN_NORM);
		ThrowHead ("progs/h_mega.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		GORE_THROWSTANDARDGIBS;
	}
	else
	{
		self.fpMonsterDeathSoundFunction(CHAN_VOICE, ATTN_NORM);
		if (random() > 0.5)
			enf_die1 ();
		else
			enf_fdie1 ();
	}
}

void monster_enforcer_DeathSound(float nChannel, float nAttentuation)
{
	if( cvar(CVAR_MONSTER_DEATHSOUNDHASNOATTENUATION) )
		nAttentuation = ATTN_NONE;
	// DRESK - TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if (self.nEnforcerType == 4)
	{ // Ultra Enforcer
		local float nRandom;
		nRandom = random();
		if(nRandom < 0.33)
			sound (self, CHAN_VOICE, "enforcer/ue_die1.wav", 1, nAttentuation);
		else
		if(nRandom < 0.66)
			sound (self, CHAN_VOICE, "enforcer/ue_die2.wav", 1, nAttentuation);
		else
			sound (self, CHAN_VOICE, "enforcer/ue_die3.wav", 1, nAttentuation);
	}
	else
	#endif
	{
		sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, nAttentuation);
	}
}

void monster_enforcer_SightSound(float nChannel, float nAttentuation)
{
	local float rsnd;
	// DRESK - TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if (self.nEnforcerType == 4)
	{ // Ultra Enforcer
		rsnd = random();
		if (rsnd < 0.2)
			sound (self, nChannel, "enforcer/ue_site1.wav", 1, nAttentuation);
		else if (rsnd < 0.4)
			sound (self, nChannel, "enforcer/ue_site2.wav", 1, nAttentuation);
		else if (rsnd < 0.6)
			sound (self, nChannel, "enforcer/ue_site3.wav", 1, nAttentuation);
		else if (rsnd < 0.8)
			sound (self, nChannel, "enforcer/ue_site4.wav", 1, nAttentuation);
		else
			sound (self, nChannel, "enforcer/ue_site5.wav", 1, nAttentuation);
	}
	else
	#endif
	{
		rsnd = rint(random() * 3);
		if (rsnd == 1)
			sound (self, nChannel, "enforcer/sight1.wav", 1, nAttentuation);
		else if (rsnd == 2)
			sound (self, nChannel, "enforcer/sight2.wav", 1, nAttentuation);
		else if (rsnd == 0)
			sound (self, nChannel, "enforcer/sight3.wav", 1, nAttentuation);
		else
			sound (self, nChannel, "enforcer/sight4.wav", 1, nAttentuation);
	}
}


/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void monster_enforcer()
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.strMonsterDisplayName = "Enforcer";
	
	// DRESK
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;
		
	// DRESK
	// Support Potential Monster Substitution
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if( cvar(CVAR_MONSTER_ENABLERANDOMMONSTERSUBSTITUTIONS) && !(g_bTravailEnabled && self.spawnflags) )
	#else
	if( cvar(CVAR_MONSTER_ENABLERANDOMMONSTERSUBSTITUTIONS) )
	#endif
	{
		if(g_bHipnoticEnabled && !self.bIsHipnoticSpawnCreature && cvar(CVAR_GAMEMODE_HIPNOTIC_USEHIPNOTICMONSTERREPLACEMENTS) && random() >= 0.80)
		{ // Replace with Scourge
			self.classname = "monster_scourge";
			self.bIsClassReplacement = TRUE;
			self.bIgnoreGameModeDetected = TRUE;
			monster_scourge();
			return;
		}
	}
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MONSTER_LANDMONSTER_DEFAULTMOVETYPE;

	setmodel (self, "progs/enforcer.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX + '0 0 8');
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled && self.spawnflags & 4)
	{
		GameModeFeatureDetected_Travail();
		self.nEnforcerType = 4;
		self.health = 400;
		self.skin = 2;
		self.th_missile = Travail_Enforcer_Attack;
	}
	else
	if(g_bTravailEnabled && self.spawnflags & 2)
	{
		GameModeFeatureDetected_Travail();
		self.nEnforcerType = 2;
		self.health = 200;
		self.skin = 1;
		self.th_missile = Travail_Enforcer_Attack;
	}
	else
	#endif
	{
		
		self.health = 100;
		self.th_missile = enf_atk1;
		
		// DRESK
		// Give Enforcers Random Guns
		if(random() > 0.8)
		{ // Random Gun
			local float nRandom;
				nRandom = random();
				
			if(nRandom < 0.33)
				self.nEnforcerGunType = WEAPON_ROCKET_LAUNCHER;
			else
			if(nRandom < 0.66)
				self.nEnforcerGunType = WEAPON_GRENADE_LAUNCHER;
			else
				// Use Shotgun for Sniper Rifle
				self.nEnforcerGunType = WEAPON_SHOTGUN;
		}
	}
	
	// DRESK
	self.fpMonsterSightSoundFunction = monster_enforcer_SightSound;
	self.fpMonsterDeathSoundFunction = monster_enforcer_DeathSound;
	// Assign Gib Health
	self.nGibHealth = -35;

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;

	walkmonster_start();
}
void monster_enforcer_Precache()
{
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled)
	{
		precache_model ("progs/k_spike.mdl");
		precache_sound ("enforcer/ue_fire1.wav");
		precache_sound ("enforcer/ue_die1.wav");
		precache_sound ("enforcer/ue_die2.wav");
		precache_sound ("enforcer/ue_die3.wav");
		precache_sound ("enforcer/ue_site1.wav");
		precache_sound ("enforcer/ue_site2.wav");
		precache_sound ("enforcer/ue_site3.wav");
		precache_sound ("enforcer/ue_site4.wav");
		precache_sound ("enforcer/ue_site5.wav");
		precache_sound ("enforcer/ue_pain1.wav");
		precache_sound ("enforcer/ue_pain2.wav");
		precache_sound ("enforcer/ue_pain3.wav");
		
		precache_model ("progs/k_spike.mdl");
		precache_sound ("enforcer/me_fire1.wav");
		precache_model ("progs/laser2.mdl");
	}
	#endif
}

// DRESK
// Travail Animation Control Down Here
#ifdef COMPILE_MODSUPPORT_TRAVAIL
void()	menf_atk1	=[	$attack1,	menf_atk2	] {ai_face(); };
void()	menf_atk2	=[	$attack2,	menf_atk3	] {ai_face(); };
void()	menf_atk3	=[	$attack3,	menf_atk4	] {ai_face(); };
void()	menf_atk4	=[	$attack4,	menf_atk5	] {ai_face(); };
void()	menf_atk5	=[	$attack5,	menf_atk6	] {ai_face(); };
void()	menf_atk6	=[	$attack6,	menf_atk7	] {ai_face(); Travail_Enforcer_FireParticleBeam(); };
void()	menf_atk7	=[	$attack7,	menf_atk8	] {ai_face(); };
void()	menf_atk8	=[	$attack5,	menf_atk9	] {ai_face(); };
void()	menf_atk9	=[	$attack6,	menf_atk10	] {ai_face(); Travail_Enforcer_FireParticleBeam(); };
void()	menf_atk10	=[	$attack7,	menf_atk11	] {ai_face();};
void()	menf_atk11	=[	$attack5,	menf_atk12	] {ai_face();};
void()	menf_atk12	=[	$attack6,	menf_atk13	] {Travail_Enforcer_FireParticleBeam(); };
void()	menf_atk13	=[	$attack7,	menf_atk14	] {ai_face();};
void()	menf_atk14	=[	$attack8,	menf_atk15	] {ai_face(); };
void()	menf_atk15	=[	$attack9,	menf_atk16	] {ai_face(); };
void()	menf_atk16	=[	$attack10,	enf_run1	] {ai_face(); SUB_CheckRefire (menf_atk1);};

void()	menf_zatk1	=[	$attack1,	menf_zatk2	] {ai_face(); };
void()	menf_zatk2	=[	$attack2,	menf_zatk3	] {ai_face(); };
void()	menf_zatk3	=[	$attack3,	menf_zatk4	] {ai_face(); };
void()	menf_zatk4	=[	$attack4,	menf_zatk5	] {ai_face(); };
void()	menf_zatk5	=[	$attack5,	menf_zatk6	] {ai_face();};
void()	menf_zatk6	=[	$attack6,	menf_zatk7	] {Travail_Enforcer_FireKnight(-3); };
void()	menf_zatk7	=[	$attack7,	menf_zatk8	] {Travail_Enforcer_FireKnight(-2); };
void()	menf_zatk8	=[	$attack6,	menf_zatk9	] {Travail_Enforcer_FireKnight(-1); };
void()	menf_zatk9	=[	$attack5,	menf_zatk10	] {Travail_Enforcer_FireKnight(0); };
void()	menf_zatk10	=[	$attack6,	menf_zatk11	] {Travail_Enforcer_FireKnight(1); };
void()	menf_zatk11	=[	$attack7,	menf_zatk12	] {Travail_Enforcer_FireKnight(2); };
void()	menf_zatk12	=[	$attack6,	menf_zatk13	] {Travail_Enforcer_FireKnight(3); };
void()	menf_zatk13	=[	$attack8,	menf_zatk14	] {ai_face();};
void()	menf_zatk14	=[	$attack9,	menf_zatk15	] {ai_face(); };
void()	menf_zatk15	=[	$attack10,	enf_run1	] {ai_face(); SUB_CheckRefire (menf_zatk1);};

void()	menf_gatk1	=[	$attack1,	menf_gatk2	] {ai_face();};
void()	menf_gatk2	=[	$attack2,	menf_gatk3	] {ai_face();};
void()	menf_gatk3	=[	$attack3,	menf_gatk4	] {ai_face();};
void()	menf_gatk4	=[	$attack4,	menf_gatk5	] {ai_face();};
void()	menf_gatk5	=[	$attack5,	menf_gatk6	] {ai_face();};
void()	menf_gatk6	=[	$attack6,	menf_gatk7	] {ai_face(); OgreFireGrenade();};
void()	menf_gatk7	=[	$attack7,	menf_gatk8	] {ai_face();};
void()	menf_gatk8	=[	$attack8,	menf_gatk9	] {ai_face();};
void()	menf_gatk9	=[	$attack9,	menf_gatk10	] {ai_face();};
void()	menf_gatk10	=[	$attack10,	enf_run1	] {ai_face(); SUB_CheckRefire (menf_gatk1);};

void()	menf_ratk1	=[	$attack1,	menf_ratk2	] {ai_face(); };
void()	menf_ratk2	=[	$attack2,	menf_ratk3	] {ai_face(); };
void()	menf_ratk3	=[	$attack3,	menf_ratk4	] {ai_face(); };
void()	menf_ratk4	=[	$attack4,	menf_ratk5	] {ai_face();};
void()	menf_ratk5	=[	$attack5,	menf_ratk6	] {ai_face();};
void()	menf_ratk6	=[	$attack6,	menf_ratk7	] {ai_face(); Travail_Enforcer_FireRocket();};
void()	menf_ratk7	=[	$attack7,	menf_ratk8	] {ai_face();};
void()	menf_ratk8	=[	$attack8,	menf_ratk9	] {ai_face();};
void()	menf_ratk9	=[	$attack9,	menf_ratk10	] {ai_face(); };
void()	menf_ratk10	=[	$attack10,	enf_run1	] {ai_face();  SUB_CheckRefire (menf_ratk1);};
#endif