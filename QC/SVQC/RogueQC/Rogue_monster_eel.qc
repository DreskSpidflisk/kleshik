$cd /qwork/xpack/models/eel
$origin 0 0 0
$scale .12
$base eelrest3
$skin eelfin
$frame eelswim1 eelswim2 eelswim3 eelswim4 eelswim5 eelswim6
$frame eeldth1 eeldth2 eeldth3 eeldth4 eeldth5
$frame eeldth6 eeldth7 eeldth8 eeldth9 eeldth10
$frame eel_pain1 eel_pain2 eel_pain3 eel_pain4 eel_pain5 eel_pain6 eel_pain7

void() swimmonster_start;
void(entity enAttacker, float fDamage, float fDamageType) eel_pain1;

/*
============
T_EELZap
============
*/
void T_EELZap(entity inflictor, entity attacker, float damage)
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(inflictor.origin, damage+40);
	
	while (head)
	{
		if (head.takedamage)
		{
			org = head.origin + (head.mins + head.maxs)*0.5;
			points = 0.5*vlen (inflictor.origin - org);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points * 0.5;
			if (points > 0)
			{
				if (CanDamage (head, inflictor))
				{	// eels take no damage from this attack
					if (head.classname != "monster_eel" && 
						(head.flags & FL_INWATER))					
						T_Damage (head, inflictor, attacker, HITLOCATION_NONE, DAMAGETYPE_MONSTER_EEL_MELEE, points);
				}
			}
		}
		head = head.chain;
	}
}


void eel_pitch_change()
{
	if ( pointcontents ( self.origin ) != CONTENT_WATER )
	{
		droptofloor();
		T_Damage ( self, world, world, HITLOCATION_NONE, DAMAGETYPE_OTHER, 6);
		return;
	}
	
    if ( time < self.delay )
        return;

    if ( self.weapon > 10 )
        self.weapon = -10;

    if ( self.weapon < 0 )
        self.angles_x = self.angles_x - 1.5;
    else if ( self.weapon > 0)
        self.angles_x = self.angles_x + 1.5;

    self.weapon = self.weapon + 1;
}

void() eel_stand1  =[ $eelswim1, eel_stand2 ]
{ ai_stand(); eel_pitch_change();} ;
void() eel_stand2  =[ $eelswim2, eel_stand3 ]
{ ai_stand(); eel_pitch_change();};
void() eel_stand3  =[ $eelswim3, eel_stand4 ]
{ ai_stand(); eel_pitch_change();};
void() eel_stand4  =[ $eelswim4, eel_stand5 ]
{ ai_stand(); eel_pitch_change();};
void() eel_stand5  =[ $eelswim5, eel_stand6 ]
{ ai_stand(); eel_pitch_change();};
void() eel_stand6  =[ $eelswim6, eel_stand1 ]
{ ai_stand(); eel_pitch_change();};

void() eel_walk1  =[ $eelswim1, eel_walk2 ] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "eel/eactive1.wav", 1, ATTN_IDLE);
	ai_walk(6);
    eel_pitch_change();
};
void() eel_walk2  =[ $eelswim2, eel_walk3 ] {ai_walk(6);eel_pitch_change();};
void() eel_walk3  =[ $eelswim3, eel_walk4 ] {ai_walk(6);eel_pitch_change();};
void() eel_walk4  =[ $eelswim4, eel_walk5 ] {ai_walk(6);eel_pitch_change();};
void() eel_walk5  =[ $eelswim5, eel_walk6 ] {ai_walk(6);eel_pitch_change();};
void() eel_walk6  =[ $eelswim6, eel_walk1 ] {ai_walk(6);eel_pitch_change();};

void() eel_run1  =[      $eelswim1, eel_run2 ]
{
	if (random() < 0.4)
		sound (self, CHAN_VOICE, "eel/eactive1.wav", 1, ATTN_IDLE);
	ai_run(10);
    eel_pitch_change();
};
void() eel_run2  =[ $eelswim2, eel_run3 ] {ai_run(10);eel_pitch_change();};
void() eel_run3  =[ $eelswim3, eel_run4 ] {ai_run(10);eel_pitch_change();};
void() eel_run4  =[ $eelswim4, eel_run5 ] {ai_run(10);eel_pitch_change();};
void() eel_run5  =[ $eelswim5, eel_run6 ] {ai_run(10);eel_pitch_change();};
void() eel_run6  =[ $eelswim6, eel_run1 ] {ai_run(10);eel_pitch_change();};

void() eel_melee =
{
    local float     attackOK;

    attackOK = 1;

    traceline (self.origin, self.enemy.origin, FALSE, self);

    if (trace_ent != self.enemy)
        attackOK = FALSE;       // don't have a clear shot
	if (trace_inopen && trace_inwater)
        attackOK = FALSE;           // sight line crossed contents

    if (attackOK)
        T_EELZap (self, self, 45);
	self.skin=0;
	self.effects = self.effects - (self.effects & (EF_DIMLIGHT | EF_BRIGHTLIGHT) );
};

void() eel_attack1 =[ $eelswim1, eel_attack2 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack2 =[ $eelswim2, eel_attack3 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack3 =[ $eelswim3, eel_attack4 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack4 =[ $eelswim4, eel_attack5 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack5 =[ $eelswim5, eel_attack6 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack6 =[ $eelswim6, eel_attack7 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack7 =[ $eelswim1, eel_attack8 ]
	{ ai_charge(8); eel_pitch_change();};
void() eel_attack8 =[ $eelswim2, eel_attack9 ] 
{ 
	self.effects = self.effects | EF_DIMLIGHT;
	self.skin=1;
	ai_charge(8);
    eel_pitch_change();
    sound (self, CHAN_WEAPON, "eel/eatt1.wav", 1, ATTN_NORM);
};
void() eel_attack9 =[ $eelswim3, eel_attack10 ]
    { self.skin=2;ai_charge(8);eel_pitch_change(); };
void() eel_attack10=[ $eelswim4, eel_attack11 ]
    { self.skin=3;ai_charge(8);eel_pitch_change(); };
void() eel_attack11=[ $eelswim5, eel_attack12 ] 
    { self.effects = self.effects - (self.effects & EF_DIMLIGHT); self.effects = self.effects | EF_BRIGHTLIGHT; self.skin=4;ai_charge(8);eel_pitch_change();};
void() eel_attack12=[ $eelswim6, eel_run1 ] 
	{ self.skin=5;eel_melee(); };

void() eel_death1 =[	$eeldth1,	eel_death2	] {};
void() eel_death2 =[	$eeldth2,	eel_death3	] {};
void() eel_death3 =[	$eeldth3,	eel_death4	] {};
void() eel_death4 =[	$eeldth4,	eel_death5	] {};
void() eel_death5 =[	$eeldth3,	eel_death6	] {};
void() eel_death6 =[	$eeldth2,	eel_death7	] {};
void() eel_death7 =[	$eeldth1,	eel_death8	] {};
void() eel_death8 =[	$eeldth2,	eel_death9	] {};
void() eel_death9 =[	$eeldth3,	eel_death10	] {};
void() eel_death10 =[	$eeldth4,	eel_death11	] {};
void() eel_death11 =[	$eeldth5,	eel_death12	] {};
void() eel_death12 =[	$eeldth6,	eel_death13	] {};
void() eel_death13 =[	$eeldth7,	eel_death14	] {};
void() eel_death14 =[	$eeldth8,	eel_death15	] {};
void() eel_death15 =[	$eeldth9,	eel_death16	] {droptofloor();};
void() eel_death16 =[	$eeldth10,	eel_death16	] {};

void eel_death(float fDamageType)
{
	setsize (self, '0 0 0', '0 0 0');
	self.skin = 0;
	self.effects = 0;
	
//	self.skin = 1;		// change to bloody eel skin!
    if (self.health < self.nGibHealth)
	{
		ThrowHead ("progs/eelgib.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
		GORE_THROWSTANDARDGIBS;
	}
	else
	{
		self.fpMonsterDeathSoundFunction(CHAN_VOICE, ATTN_NORM);
		eel_death1 ();
		
		// Invoke Gyro Physics
		if(g_bGyroPhysicsEnabled && g_bGyroPhysics_DetailEntities)
			Gyro_ObjectMacro_Gib(self, 500);
	}
};

void eel_pain1(entity enAttacker, float fDamage, float fDamageType)		[	$eeldth1, eel_pain2 ]
{
	if (self.pain_finished > time)
		return;
	
	self.pain_finished = time + 1;
	sound (self, CHAN_VOICE, "eel/epain3.wav", 1, ATTN_NORM); 
	self.skin=0;
};
void() eel_pain2  =[	$eeldth2, eel_pain3 ] {};
void() eel_pain3  =[	$eeldth3, eel_pain4 ] {};
void() eel_pain4  =[	$eeldth4, eel_pain5 ] {};
void() eel_pain5  =[	$eeldth3, eel_pain6 ] {};
void() eel_pain6  =[	$eeldth2, eel_pain7 ] {};
void() eel_pain7  =[	$eeldth1, eel_run1 ] {};

/*QUAKED monster_eel (1 0 0) (-16 -16 -24) (16 16 32) Ambush
*/
void monster_eel()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.strMonsterDisplayName = "Eel";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	// DRESK
	// Check Creature Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MONSTER_LANDMONSTER_DEFAULTMOVETYPE;

	setmodel (self, "progs/eel2.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 60;
	
	// DRESK
	Monster_PrepareGenericSightSoundFunction("eel/eelc5.wav");
	Monster_PrepareGenericDeathSoundFunction("eel/edie3r.wav");
	// Assign Gib Health
	self.nGibHealth = -12;
	// Assign Cannot Spawn Fliskers
	self.bCannotSpawnFliskers = TRUE;

	self.th_stand = eel_stand1;
	self.th_walk = eel_walk1;
	self.th_run = eel_run1;
	self.th_die = eel_death;
	self.th_pain = eel_pain1;
	self.th_melee = eel_attack1;

    self.delay = time + random() * 6;
    self.weapon = 0;

	swimmonster_start ();
}
void monster_eel_Precache()
{
	precache_model ("progs/eel2.mdl");
	precache_model ("progs/eelgib.mdl");
	precache_model ("progs/gib1.mdl");
	
	precache_sound ("eel/edie3r.wav");
	precache_sound ("eel/epain3.wav");
	precache_sound ("eel/eactive1.wav");
	precache_sound ("eel/eatt1.wav");
	precache_sound ("eel/eelc5.wav");
}