void() movetarget_f;
void() t_movetarget;
void() knight_walk1;
void() knight_bow6;
void() knight_bow1;
// DRESK
// Support Damage Types
// void(entity etemp, entity stemp, entity stemp, float fDamageType, float dmg) T_Damage;
// void(entity etemp, entity stemp, entity stemp, float dmg) T_Damage;
/*

.enemy
Will be world if not currently angry at anyone.

.movetarget
The next path spot to walk toward.  If .enemy, ignore .movetarget.
When an enemy is killed, the monster will try to return to it's path.

.huntt_ime
Set to time + something when the player is in sight, but movement straight for
him is blocked.  This causes the monster to use wall following code for
movement direction instead of sighting on the player.

.ideal_yaw
A yaw angle of the intended direction, which will be turned towards at up
to 45 deg / state.  If the enemy is in view and hunt_time is not active,
this will be the exact line towards the enemy.

.pausetime
A monster will leave it's stand state and head towards it's .movetarget when
time > .pausetime.

walkmove(angle, speed) primitive is all or nothing
*/


//
// globals
//
// DRESK
// Suppress Compiler Warning
// float	current_yaw;

//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity	sight_entity;
float	sight_entity_time;

// DRESK
// Support Variable FindTarget Times
.float	tFindTargetTime;

float anglemod(float v)
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};

/*
==============================================================================

MOVETARGET CODE

The angle of the movetarget effects standing and bowing direction, but has no effect on movement, which allways heads to the next target.

targetname
must be present.  The name of this movetarget.

target
the next spot to move to.  If not present, stop here for good.

pausetime
The number of seconds to spend standing or bowing for path_stand or path_bow

==============================================================================
*/


void movetarget_f()
{
	if (!self.targetname)
		objerror ("monster_movetarget: no targetname");
		
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize (self, '-8 -8 -8', '8 8 8');
	
};

/*QUAKED path_corner (0.5 0.3 0) (-8 -8 -8) (8 8 8)
Monsters will continue walking towards the next target corner.
*/
void path_corner()
{
	movetarget_f ();
};


/*
=============
t_movetarget

Something has bumped into a movetarget.  If it is a monster
moving towards it, change the next destination and continue.
==============
*/
void t_movetarget()
{
	local entity	temp;

	if (other.movetarget != self)
		return;
	
	if (other.enemy)
		return;		// fighting, not following a path

	temp = self;
	self = other;
	other = temp;

	if (self.classname == "monster_ogre")
		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

//dprint ("t_movetarget\n");

	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{ // Hipnotic Enabled
		if (other.target)
		{
			self.goalentity = self.movetarget = find (world, targetname, other.target);
			self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
			if (!self.movetarget)
			{
			self.pausetime = time + 999999;
			self.th_stand ();
			return;
			}
			else if (other.delay)
			{
				self.pausetime = time + other.delay;
				self.th_stand ();
			}
		}
		else
		{
			self.pausetime = time + 999999;
			self.th_stand ();
			return;
		}
	}
	else
	{ // Regular Mode
		self.goalentity = self.movetarget = find (world, targetname, other.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			self.pausetime = time + 999999;
			self.th_stand ();
			return;
		}
	}
};



//============================================================================

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/
float range(entity targ)
{
local vector	spot1, spot2;
local float		r;	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 120)
		return RANGE_MELEE;
	if (r < 500)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float visible(entity targ)
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	// DRESK
	// Support Monsters See Through Water
	if(!SG_AUTOCVAR(kleshik_server_monster_SeeThroughWater) && trace_inopen && trace_inwater)
	// if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
	{
		// DRESK - HIPNOTIC SUPPORT
		if(g_bHipnoticEnabled)
		{ // Hipnotic Mode
			visible_distance = vlen(spot2-spot1);
			return TRUE;
		}
		else
			// Regular Mode
			return TRUE;
	}
	return FALSE;
};


/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float infront(entity targ)
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.3)
	{
		return TRUE;
	}
	return FALSE;
};


//============================================================================

/*
===========
ChangeYaw

Turns towards self.ideal_yaw at self.yaw_speed
Sets the global variable current_yaw
Called every 0.1 sec by monsters
============
*/
/*

void() ChangeYaw =
{
	local float		ideal, move;

//current_yaw = self.ideal_yaw;
// mod down the current angle
	current_yaw = anglemod( self.angles_y );
	ideal = self.ideal_yaw;
	
	if (current_yaw == ideal)
		return;
	
	move = ideal - current_yaw;
	if (ideal > current_yaw)
	{
		if (move > 180)
			move = move - 360;
	}
	else
	{
		if (move < -180)
			move = move + 360;
	}
		
	if (move > 0)
	{
		if (move > self.yaw_speed)
			move = self.yaw_speed;
	}
	else
	{
		if (move < 0-self.yaw_speed )
			move = 0-self.yaw_speed;
	}

	current_yaw = anglemod (current_yaw + move);

	self.angles_y = current_yaw;
};

*/


//============================================================================

void HuntTarget()
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished (1);	// wait a while before first attack
};

void SightSound()
{
	// DRESK
	// Support Bloody HUD Stinger
	local float nChannel;
		nChannel = CHAN_AUTO;
	local float nAttentuation;
		nAttentuation = ATTN_NONE;
	if(self.bInitiallyStealthedEliteMonster)
	{ // Reveal Elite Monster
		AssignEliteMonsterAttributes_VisualEffects(self, FALSE);
	}
	else
	{ // Standard
		nAttentuation = ATTN_NORM;
		nChannel = CHAN_VOICE;
	}
	
	// Invoke Sight Sound Function
	if(self.fpMonsterSightSoundFunction)
		self.fpMonsterSightSoundFunction(nChannel, nAttentuation);
}

void FoundTarget()
{
	// DRESK
	// Prevent Notarget and Invisibility from Alerting Other Monsters
	local float bStealth;
	if( (self.enemy.flags & FL_NOTARGET) || (self.enemy.nCSQCStat_Powerups & POWERUP_INVISIBILITY) )
		bStealth = TRUE;
	else
		bStealth = FALSE;
		
	if (!bStealth && self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	// DRESK
	// Prevent Notarget and Invisibility from Alerting Other Monsters
	if(!bStealth)
		self.show_hostile = time + 1;		// wake up other monsters

	SightSound ();
	HuntTarget ();
	
	// DRESK
	// Update Search Timer Here (give it 7 seconds to find the player)
	self.search_time = time + 7;
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float FindTarget()
{
	local entity	client;
	local float		r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			// DRESK
			// Seems like this SHOULD return FALSE
			return FALSE;
			// return;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.nCSQCStat_Powerups & POWERUP_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	// DRESK - ROGUE SUPPORT
	// Dragon has superceeding AI
	if(self.classname != "dragon")
		FoundTarget ();

	return TRUE;
};


//=============================================================================

void ai_forward(float dist)
{
	// DRESK
	// Suppress Movement if Twitching
	if(self.nNumCorpseTwitches == 0)
		walkmove (self.angles_y, dist);
};

void ai_back(float dist)
{
	walkmove ( (self.angles_y+180), dist);
};


/*
=============
ai_pain

stagger back a bit
=============
*/
void ai_pain(float dist)
{
	ai_back (dist);
/*
	local float	away;
	
	away = anglemod (vectoyaw (self.origin - self.enemy.origin) 
	+ 180*(random()- 0.5) );
	
	walkmove (away, dist);
*/
};

/*
=============
ai_painforward

stagger back a bit
=============
*/
void ai_painforward(float dist)
{
	walkmove (self.ideal_yaw, dist);
};

/*
=============
ai_walk

The monster is walking it's beat
=============
*/
void ai_walk(float dist)
{
	// DRESK
	// Unused Variable(s)
	// local vector		mtemp;
	
	movedist = dist;
	
	// DRESK - ROGUE SUPPORT
	// Dragon Movement Suppressed Here
	/*
	if (self.classname == "monster_dragon")
	{
		movetogoal (dist);
		return;
	}
	*/
	
	// check for noticing a player
	if (FindTarget ())
		return;

	movetogoal (dist);
};


/*
=============
ai_stand

The monster is staying in one place for a while, with slight angle turns
=============
*/
void ai_stand()
{
	// DRESK
	// Check for FindTarget Time
	if(self.tFindTargetTime < time)
	{ // Time to Find a Target
		// Update Find Target Time
		self.tFindTargetTime = time + 0.1 + random();
		
		if (FindTarget ())
			return;
	}
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
}

/*
=============
ai_turn

don't move, but turn towards ideal_yaw
=============
*/
void ai_turn()
{
	if (FindTarget ())
		return;
	
	ChangeYaw ();
};

//=============================================================================

/*
=============
ChooseTurn
=============
*/
void ChooseTurn(vector dest3)
{
	local vector	dir, newdir;
	
	dir = self.origin - dest3;

	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);	
};

/*
============
FacingIdeal

============
*/
float FacingIdeal()
{
	local	float	delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};


//=============================================================================

float()	WizardCheckAttack;
float()	DogCheckAttack;

// DRESK - HIPNOTIC SUPPORT
float() GremlinCheckAttack;
float() ScourgeCheckAttack;
float() ArmagonCheckAttack;

float CheckAnyAttack()
{
	if (!enemy_vis)
		// DRESK
		// No Visible Enemy; Should Return some form of NULL function or FALSE condition due
		// to the logic of the call
		return FALSE;
		// return;
		
	if(self.fpMonsterCheckAttackFunction)
		return(self.fpMonsterCheckAttackFunction() );
	
	return CheckAttack ();
}


/*
=============
ai_run_melee

Turn and close until within an angle to launch a melee attack
=============
*/
void ai_run_melee()
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();

	if (FacingIdeal())
	{
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_missile

Turn in place until within an angle to launch a missile attack
=============
*/
void ai_run_missile()
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (FacingIdeal())
	{
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};


/*
=============
ai_run_slide

Strafe sideways, but stay at aproximately the same range
=============
*/
void ai_run_slide()
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;
	ChangeYaw ();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
};


/*
=============
ai_run

The monster has an enemy it is trying to kill
=============
*/

// DRESK - HIPNOTIC SUPPORT
float RUN_STRAIGHT;

void ai_run(float dist)
{
	// DRESK
	// Unused Variable(s)
	// local	vector	delta;
	local	float	axis;
	// local	float	direct, ang_rint, ang_floor, ang_ceil;
	
	// DRESK
	// Support Faster Monsters
	dist *= self.fMonsterMovementMultiplier;
	if( (self.fMonsterMovementMaximum != 0) && (dist > self.fMonsterMovementMaximum) )
		dist = rint(self.fMonsterMovementMaximum);
	
	movedist = dist;
// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			// DRESK
			// We need to forget about our old enemy now
			self.oldenemy = world;
			HuntTarget ();
			return;
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

	// Let's see if we can see the enemy by performing
	// a traceline check.  If we can see them, let's
	// update our search timer to be the current time
	// plus 5 seconds to give a decent amount of chase.
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;
	
	// DRESK
	// Try and forget about primary target if it is stealthed
	if(self.search_time < (time + 3))
	{ // We haven't seen our enemy in 2 seconds; let's see if he is stealthed
		if( (self.enemy.flags & FL_NOTARGET) || (self.enemy.nCSQCStat_Powerups & POWERUP_INVISIBILITY) )
		{ // Our enemy is stealthed and we can't see him; it's time to lose track
			self.enemy = world;
			if(self.oldenemy.health > 0)
			{ // Let's go back to our previous enemy
				self.enemy = self.oldenemy;
				// We need to forget about our old enemy now
				self.oldenemy = world;
				HuntTarget();
			}
			else
			{ // We've got no enemies left; let's walk again or stand still
				if(self.movetarget)
					self.th_walk();
				else
					self.th_stand();
			}
			return;
		}
	}

	// We haven't seen our target for the past 5 seconds;
	// let's try and find another player
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			// We found a new target; let's get him!
			return;
		else
		{ // We can't see our target and we can't find a new one
			// Goodbye Enemy!
			self.enemy = world;
			// Let's see if we have an old enemy
			if(self.oldenemy.health > 0)
			{ // We have an old one
				self.enemy = self.oldenemy;
				self.oldenemy = world;
				HuntTarget();
			}
			else
			{ // No one to see, no old enemy, let's have a beer!
				if(self.movetarget)
					self.th_walk();
				else
					self.th_stand();
			}
			return;
		}
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	// DRESK - HIPNOTIC SUPPORT
	if (g_bHipnoticEnabled && self.th_turn)
	{
		local float angledelta;

		angledelta = fabs(self.angles_y - enemy_yaw);
		if (angledelta > MIN_ANGLE_DELTA)
		{
			self.th_turn();
			return;
		}
	}
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
		ai_run_melee ();
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide ();
		return;
	}
	
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{ // Hipnotic Mode
		if (RUN_STRAIGHT && time > self.endtime)
		{
			RUN_STRAIGHT = 0;
			axis = walkmove (self.angles_y, movedist);
			if (!axis)
			{
				self.endtime = time + 3;
				movetogoal (dist);      // done in C code...
			}
		//      else
		//         ChangeYaw();
		}
		else
		{
			// head straight in
			movetogoal (dist);      // done in C code...
		}
	}
	else
	{ // Regular Mode	
		// head straight in
		movetogoal (dist);		// done in C code...
	}
};

