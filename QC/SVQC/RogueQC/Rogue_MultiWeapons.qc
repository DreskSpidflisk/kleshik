//=============================================================================
// Multi Grenade Code
//=============================================================================
void MultiGrenadeTouch();

//================================
//================================
void MiniGrenadeExplode()
{
	if ( self.owner.classname == "player")
		T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_MULTIGRENADE, 90, world);
	else
		T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_MULTIGRENADE, 60, world);
	
	// DRESK
	// Use Fireball Explosion
	te_FireBallExplosion(self.origin);
	// te_explosion2(self.origin, 230, 5);

	BecomeExplosion ();
};

//================================
//================================
void MiniGrenadeLaunch(float offsetAngle)
{
	// local	entity missile, mpuff;
	local entity missile;
	local	float	tempRand;
	
	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MiniGrenade";
		
// set missile speed	
	missile.v_angle = self.v_angle;
	missile.v_angle_y = missile.v_angle_y + offsetAngle;
	makevectors (missile.v_angle);
		
		missile.velocity = v_forward*100 + v_up*400;
		tempRand = (SG_crandom()*90) - 30;
		missile.velocity = missile.velocity + tempRand * v_forward;
		tempRand = (SG_crandom()*70) - 20;
		missile.velocity = missile.velocity + tempRand * v_right;
		tempRand = (SG_crandom()*90) - 30;
		missile.velocity = missile.velocity + tempRand * v_up;

	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);

// set missile duration
	missile.nextthink = time + 1 + (SG_crandom() * 0.5);
	missile.think = MiniGrenadeExplode;
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Grenade(missile, 800);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
};

//================================
//================================
void MultiGrenadeExplode()
{
	// DRESK - 11/25/06
	// Provide Simple Flash Feedback
	te_smallflash(self.origin);
	
	// Play Sound
	sound(self, CHAN_AUTO, SOUND_KLESHIK_WEAPONS_MULTIGRENADES_DEPLOY, 1, ATTN_NORM);
	
	MiniGrenadeLaunch(0);
	MiniGrenadeLaunch(72);
	MiniGrenadeLaunch(144);
	MiniGrenadeLaunch(216);
	MiniGrenadeLaunch(288);

	remove (self);
};

void MultiGrenadeTouch()
{
	if (other == self.owner)
		return;		// don't explode on owner
		
	// DRESK
	// Support Elite Monster
	if(other.bIsEliteMonster)
		EliteMonsterRedirectProjectile(other, self);
	else
	if (other.takedamage == DAMAGE_AIM)
	{
		if (self.classname == "MiniGrenade")
		{
			MiniGrenadeExplode();
			return;
		}
		/*
		else
		{
			// DRESK
			// Modify Multi Grenade Logic to Launch Multi Grenades on Touch
			MultiGrenadeExplode();
			return;
		}
		*/
	}
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
		
	// DRESK
	// Provide Feedback
	te_GrenadeBounce(self.origin);
}
//================================
void W_FireMultiGrenade()
{
	// local	entity missile, mpuff;
	local entity missile;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_GRENADE_LAUNCHER, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Rocket(PLAYERANIM_ANIMSPEED_STANDARD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiGrenade";
	
	// DRESK
	// Support Additional Velocity
	local float fForwardVelocity;
		fForwardVelocity = 900;
		
	missile.velocity = v_forward * fForwardVelocity + v_up * 200 + SG_crandom()*v_right*10 + SG_crandom()*v_up*10;
	
	// DRESK
	// Support Explosives Owner Velocity Ratio
	local float fExplosivesOwnerVelocityRatio;
		fExplosivesOwnerVelocityRatio = cvar(CVAR_WEAPON_PROJECTILESOWNERVELOCITYRATIO);
	if(fExplosivesOwnerVelocityRatio)
		missile.velocity = missile.velocity + (self.velocity * fExplosivesOwnerVelocityRatio);

	// missile.avelocity = '300 300 300';
	missile.avelocity = '-1200 000 000';
	
	missile.angles = vectoangles(missile.velocity);
	missile.touch = MultiGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + random() + 1;
	missile.think = MultiGrenadeExplode;

	setmodel (missile, "progs/mervup.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, vCurrentShotOrigin);
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Grenade(missile, 800);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
}

//=============================================================================
// Multi Rocket Code
//=============================================================================

//================================
//================================
void MultiRocketExplode()
{
	local float	damg;

//	Stock Single Rocket Damage...
//	damg = 100 + random()*20;

	damg = 60 + random()*15;

	// DRESK
	// Shifted All Damage to Radius Damage (no more point damage)
	/*
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		if (other.classname == "monster_dragon")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_MULTIROCKET, damg );
	}*/

	// don't do radius damage to the other, because all the damage
	// was done in the impact
//	Stock single rocket damage.
//	T_RadiusDamage (self, self.owner, 120, other);

	T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_MULTIROCKET, damg, world);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
	
	// DRESK
	// Support Quad Explosion
	if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
		te_explosionquad(self.origin);
	else
		// Standard Explosion
		te_explosion(self.origin);

	BecomeExplosion ();
};

//================================
//================================
void MultiRocketTouch()
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	// DRESK
	// Support Elite Monster
	if(other.bIsEliteMonster)
		EliteMonsterRedirectProjectile(other, self);
	else
	{ // Standard
		MultiRocketExplode ();
	}
};


//================================
//================================
void HomingMissileThink()
{
	local vector	dir;

	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}

	dir = normalize(self.enemy.origin - self.origin);
	self.velocity = dir * 1000;
	self.nextthink = time + 0.1;
	self.think = HomingMissileThink;	
};


//================================
//================================
void HomingMissileAcquire()
{
	local vector	oldVelocity;
	local vector	aimangle;

	if ( self.delay < time )
	{
		MultiRocketExplode ();
		return;
	}

	oldVelocity = self.velocity;
	makevectors (self.v_angle);
	self.velocity = aim (self, 1000);
	self.velocity = self.velocity * 1000;

	aimangle = self.origin + self.velocity;	
	traceline ( self.origin, aimangle, FALSE, self );
	if (trace_fraction < 1)
	{
		if (trace_ent.flags & FL_MONSTER)
		{
			self.enemy = trace_ent;
			HomingMissileThink();
			return;
		}
	}
	
	self.velocity = oldVelocity;
	self.v_angle = vectoangles ( self.velocity );
	self.angles = self.v_angle;
	self.think = HomingMissileAcquire;
	self.nextthink = time + 0.2;
};

//================================
//================================
void MultiRocketLaunch(float offset, float frameNum)
{
	// local entity 	missile, mpuff;
	local entity missile;
	local vector	aimangle;
	
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "MultiRocket";
	missile.delay = time + 4;
	missile.frame = frameNum;
	missile.touch = MultiRocketTouch;

	// DRESK
	// Always use non-lit rocket
	//if (deathmatch || coop)
		setmodel (missile, "progs/rockup_d.mdl");
	/*else
		setmodel (missile, "progs/rockup.mdl");*/

	setsize (missile, '0 0 0', '0 0 0');		
	// setorigin (missile, self.origin + v_forward*8 + '0 0 16');
	setorigin (missile, vCurrentShotOrigin);
	
	if ( coop || deathmatch)
	{
		aimangle = self.v_angle;
		aimangle_y = aimangle_y + (offset * 0.66);
		makevectors (aimangle);
		missile.velocity = aim(self, 1000);
		missile.velocity = missile.velocity * 1000;
		missile.angles = vectoangles(missile.velocity);

		missile.think = MultiRocketExplode;
		missile.nextthink = time + 4;
	}
	else
	{
		makevectors (self.v_angle);
		missile.velocity = v_forward * 1000 - v_right*offset*8;
		missile.angles = vectoangles(missile.velocity);
		missile.v_angle = self.v_angle;	

		aimangle = missile.origin + missile.velocity;
		traceline ( missile.origin, aimangle, FALSE, self );
		if (trace_fraction < 1)
		{
			if (trace_ent.flags & FL_MONSTER)
			{
				missile.enemy = trace_ent;
				missile.think = HomingMissileThink;
				return;
			}
		}

		missile.think = HomingMissileAcquire;
		missile.nextthink = time + 0.1;
	}
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Rocket(missile, 800, 1000);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
};

//================================
//================================
void W_FireMultiRocket()
{
	// DRESK
	// Branch to Regular Rocket due to ammo
	if(self.ammo_rockets < 4)
	{
		W_FireRocket();
		return;
	}
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_ROCKET_LAUNCHER, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Rocket(PLAYERANIM_ANIMSPEED_STANDARD);
	
	MultiRocketLaunch ( -10, 2 );
	MultiRocketLaunch ( -5, 3 );
	MultiRocketLaunch ( 5, 0 );
	MultiRocketLaunch ( 10, 1 );
}

//=============================================================================
// Plasma Gun Code
//=============================================================================
void PlasmaDamage(vector p1, vector p2, entity from, float damage)
{
	local entity		e1, e2;
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, trace_endpos, DAMAGETYPE_WEAPON_PLASMADISCHARGE, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, trace_endpos, DAMAGETYPE_WEAPON_PLASMADISCHARGE, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from.owner, trace_endpos, DAMAGETYPE_WEAPON_PLASMADISCHARGE, damage);
	}
};

//================================
//================================
void PlasmaDischarge(entity current, float doDamage)
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, current);
	WriteCoord (MSG_BROADCAST, current.origin_x);
	WriteCoord (MSG_BROADCAST, current.origin_y);
	WriteCoord (MSG_BROADCAST, current.origin_z);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	sound (self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
	if (doDamage == 1)
        PlasmaDamage (self.origin, current.origin, self, 50);
};

//================================
//================================
void PlasmaGroundOut()
{
	local entity 	current, start;
	local float		monstersHit;
	
	monstersHit = 0;
	current = findradius ( self.origin, 320 );
	start = current;
	while ( monstersHit < 5 )
	{
		// DRESK
		// Check for Alive Target; Prevent Player Damage in Coop
		if ( (current.takedamage) && (current.flags & FL_MONSTER || (current.classname == "player" && !coop) ) && current.health > 0)
		{
			if ( current != self.owner )
			{
				traceline ( self.origin, current.origin, TRUE, world );
				if (trace_fraction == 1)
				{
					monstersHit = monstersHit + 1;
					PlasmaDischarge ( current, 1 );
				}
			}
		}
		current = current.chain;
		if (start == current || !current)
			return;
	}
};

//================================
//================================
void PlasmaTouch()
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	// DRESK
	// Check for Elite Monster
	if(other.bIsEliteMonster)
	{
		EliteMonsterRedirectProjectile(other, self);
		return;
	}

	damg = 80 + random()*20;
	sound (self, CHAN_WEAPON, "plasma/explode.wav", 1, ATTN_NORM);
	
	
	// DRESK
	// Shifted All Damage to Radius Damage (no more point damage)
	/*
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_PLASMA, damg );
	}
	*/

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_PLASMA, damg, other);

	te_explosion2(self.origin, 244, 3);

	PlasmaGroundOut();
	remove (self);
};

//================================
//================================
void PlasmaLaunch()
{
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 1250;

	self.nextthink = time + 5;
	self.think = SUB_Remove;
};

void launch_plasma(vector org, vector dir)
{
	// local entity	missile, mpuff;
	local entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	
// set missile speed	
	missile.velocity = dir * 0.01;
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = PlasmaTouch;
	
	setmodel (missile, "progs/plasma.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);

	sound (missile, CHAN_WEAPON, "plasma/flight.wav", 1, ATTN_NORM);
	// DRESK
	// Modified Effects
	// if (!deathmatch && !coop)
	missile.effects = EF_BLUE;
	
	// DRESK
	// Modified Plasma to Fire Immediately (why was it delayed?)
	missile.velocity = normalize(missile.velocity);
	missile.velocity = missile.velocity * 1250;

	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	// set missile duration
	/*
	missile.think = PlasmaLaunch;
	missile.nextthink = time + 0.1;
	*/
	
	// DRESK
	// Provide Additional Effects
	missile.glow_color = 46;
	missile.glow_trail = 1;
	missile.effects = missile.effects | EF_NOSHADOW;
};

//================================
//================================
// DRESK
void W_FirePlasma()
{	
	local vector 	dir;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 1, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_LIGHTNING, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);

	dir = v_forward;
	launch_plasma (vCurrentShotOrigin, dir);
}

entity launch_lava_spike(vector org, vector dir)
{
	local entity enMissile;
	enMissile = spawn ();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLYMISSILE;
	enMissile.solid = SOLID_BBOX;

	enMissile.angles = vectoangles(dir);
	
	enMissile.touch = spike_touch;
	enMissile.classname = "lava_spike";
	enMissile.think = SUB_Remove;
	enMissile.nextthink = time + 6;
	setmodel (enMissile, "progs/lspike.mdl");	
	setsize (enMissile, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (enMissile, org);
	
	// DRESK
	// Apply Fullbright to Spikes
	enMissile.effects = EF_FULLBRIGHT;
	// Provide Angle Velocity
	enMissile.avelocity = '0 0 1500';
	
	// DRESK
	// Use nGibType for Detailed Nail Touch
	enMissile.nGibType = 1;

	enMissile.velocity = dir * 1000;
	
	return enMissile;
}