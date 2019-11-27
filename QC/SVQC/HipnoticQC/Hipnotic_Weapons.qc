// DRESK
// Additional Variables
.entity enProximityBombAttachedTo;

.float	nHipnoticLaserBounceMax;

void W_PrecacheHipnoticWeapons()
{ // Precache Hipnotic Weapons
	//MED
	precache_sound ("enforcer/enfstop.wav");   // laser cannon
	//MED 11/06/96
	precache_sound ("knight/sword1.wav");   // laser cannon
	precache_sound ("hipweap/laserg.wav");   // laser cannon
	precache_sound ("hipweap/laserric.wav");   // laser cannon ricochet
	precache_sound ("hipweap/proxwarn.wav");   // proximity bomb
	precache_sound ("hipweap/proxbomb.wav");   // proximity bomb
	//MED 11/19/96
	precache_sound ("hipweap/mjolhit.wav");   // mjolnir
	precache_sound ("hipweap/mjolslap.wav");   // mjolnir
	precache_sound ("hipweap/mjoltink.wav");   // mjolnir
}

void ProximityExplode()
{
	// DRESK
	// Remove Bomb from Linked List
	if(g_bProximityGunAllowAltFireDetonation)
		RemoveProximityBombFromEntityLinkedList(self.owner, self);
		
	T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_PROXIMITYGRENADE, 110, world);

	// DRESK
	// Support Quad Explosion
	if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
		te_explosionquad(self.origin);
	else
		// Standard Explosion
		te_explosion(self.origin);

	BecomeExplosion ();
};
/*
================
ProximityGrenadeExplode
================
*/
void ProximityGrenadeExplode(float fDamageType)
{
	self.takedamage = DAMAGE_NO;
	g_nNumCurrentProximityBombs = g_nNumCurrentProximityBombs - 1;
	self.deathtype = "exploding";
	self.nextthink = time + 0.1 + (random() * 0.01);
	// self.owner = self.lastvictim;
	self.think = ProximityExplode;
};

/*
================
ProximityGrenadeTouch
================
*/
void ProximityGrenadeTouch()
{
	if (other == self)
		return;
	if (other.classname == self.classname)
		return;
		
	// DRESK
	// Do NOT force the movetype to toss automatically
	// self.movetype = MOVETYPE_TOSS;
	
	if (self.state == 1)
		return;
		
	// DRESK
	// Support Elite Monster Behavior
	if(other.bIsEliteMonster)
	{
		// Remove Proximity Bomb from Linked List Here
		RemoveProximityBombFromEntityLinkedList(self.owner, self);
		EliteMonsterRedirectProjectile(other, self);
		return;
	}
		
	// Explode on moving brushes; happens to trigger on entities as well
	if ( (vlen(other.velocity) > 0))
	{
		ProximityGrenadeExplode(DAMAGETYPE_OTHER);
		self.think();
		return;
	}
	
	// Explode on Normal Take Damage Entities
	if (other.takedamage == DAMAGE_AIM)
	{
		ProximityGrenadeExplode(DAMAGETYPE_OTHER);
		self.think();
		return;
	}
	
	self.movetype = MOVETYPE_NONE;
	setsize (self, '-8 -8 -8', '8 8 8');
	self.state = 1;
	
	// Assign Brush / Entity
	self.enProximityBombAttachedTo = other;
	
	// DRESK
	// Provide Feedback
	te_GrenadeBounce(self.origin);
}

/*
================
ProximityBomb
================
*/
void ProximityBomb()
{
	local entity   head;
	local float    blowup;
	
	// Acquire Number of Allowed Proximity Bombs
	local float nNumAllowedProximityBombs;
		nNumAllowedProximityBombs = SG_AUTOCVAR(kleshik_server_weapon_ProximityGun_MaxBombs);

	// Check for Bomb Explosion
	if (( ( SG_AUTOCVAR(kleshik_server_weapon_ProximityGun_BombLifetime) > 0) && (time > self.delay) ) // Timed Explosion
		|| ( (nNumAllowedProximityBombs > 0) && (g_nNumCurrentProximityBombs > nNumAllowedProximityBombs) ) // Explosion due to too many bombs
		|| ( vlen(self.enProximityBombAttachedTo.velocity)>0) ) // Entity / brush the bomb is attached to; if it moves, the bomb explodes
	{
		ProximityGrenadeExplode(DAMAGETYPE_OTHER);
		self.think();
		return;
	}
	// self.owner = world;
	self.takedamage = DAMAGE_YES;
	head = findradius(self.origin, 140);
	blowup = 0;

	while (head)
	{
		// Check for Alive Player / Monster
		if ((head != self) && (head.health > 0) && !(head.bIsEliteMonster) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
			blowup = 1;
		// Check for Nearby Proximity Bomb
		// DRESK
		// Support Configurable Triggle on Other Bombs
		if ( !(blowup) && (head.classname == self.classname) && (head.state==0) && SG_AUTOCVAR(kleshik_server_weapon_ProximityGun_TriggerOtherBombs) )
			blowup = 1;
			
		// Check for Line of Sight
		if(blowup == 1)
		{ // Going to Blow Up; Line of Sight Check Needed
			traceline(self.origin,head.origin,TRUE,self);
			if (trace_fraction != 1.0)
				blowup = 0;
		}
		if (blowup==1)
		{
			sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
			ProximityGrenadeExplode(DAMAGETYPE_OTHER);
			self.nextthink = time + 0.5;
			return;
		}
		head = head.chain;
	}
	
	// DRESK
	// Increase Think Time
	self.nextthink = time + 1;
	// self.nextthink = time + 0.25;
}

/*
================
W_FireProximityGrenade
================
*/
void W_FireProximityGrenade()
{
	// local entity missile, mpuff;
	local entity missile;

	g_nNumCurrentProximityBombs = g_nNumCurrentProximityBombs + 1;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_PROXIMITY_GUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Rocket(PLAYERANIM_ANIMSPEED_STANDARD);

	missile = spawn ();
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = 5;
	missile.state = 0;
	
	// Assign Bleeds Sparks
	missile.bBleedsSparks = TRUE;

	// set missile speed
	
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

	// missile.avelocity = '100 600 100';
	missile.avelocity = '-1800 000 000';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = ProximityGrenadeTouch;

	// set missile duration
	missile.nextthink = time + 2;
	// DRESK
	// Support Configurable Duration
	missile.delay = time + SG_AUTOCVAR(kleshik_server_weapon_ProximityGun_BombLifetime);
	// missile.delay = time + 15 + (10*random());
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;

	setmodel (missile, "progs/proxbomb.mdl");
	setorigin (missile, vCurrentShotOrigin);
	setsize (missile, '-1 -1 -1', '1 1 1');
	
	// DRESK
	// Utilize Linked List of Bombs
	if(g_bProximityGunAllowAltFireDetonation)
		AppendProximityBombToEntityLinkedList(self, missile);
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Grenade(missile, 800);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
}
/*
================
HIPNOTIC WEAPONS
================
*/
void HIP_LaserTouch()
{
	local vector org;
	local vector spot1,spot2;
	local vector oldvel;
	// local float mag;

	self.owner = world;
	self.cnt = self.cnt + 1;
	
	// Check for Sky Hit
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	oldvel = normalize(self.old_velocity);
	spot1 = self.origin - (16*oldvel);
	spot2 = self.origin + (16*oldvel);
	traceline (spot1, spot2, FALSE, self);  // see through other monsters
	self.origin = trace_endpos;

	org = self.origin;

	if (other.health)
	{
		if (self.lastvictim == other)
		{
			self.dmg = self.dmg / 2;
		}
		// DRESK
		// Check for Sparks
		// UPDATE: Shifted blood logic to T_Damage
		/*
		if(other.solid == SOLID_BSP || other.bBleedsSparks)
			te_spike(self.origin);
		else
			spawn_touchblood (self.dmg);
		*/
			
		// DRESK
		// Damagetype Support
		T_Damage(other, self, self.lastvictim, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_LASERCANNON, self.dmg);
		
		te_RapidLaserFinalTouch(self.origin);
		remove(self);
	}
	// DRESK
	// Parse Bounce Max from Variable
	else if ((self.cnt >= self.nHipnoticLaserBounceMax) )// || (random()<0.15))
	{
		// DRESK
		// sound (self, CHAN_AUTO, "enforcer/enfstop.wav", 1, ATTN_STATIC);
		te_RapidLaserFinalTouch(self.origin);
		remove(self);
	}
	else
	{
		//      self.dmg = 0.66 * self.dmg;
		self.dmg = 0.9 * self.dmg;
		//      self.speed = 0.95 * self.speed;
		self.velocity = oldvel+(2*trace_plane_normal);
		self.velocity = normalize(self.velocity);
		self.velocity = self.speed * self.velocity;
		self.old_velocity = self.velocity;
		
		if (self.flags & FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
			
		te_RapidLaserRicochet(self.origin);
		// sound (self, CHAN_AUTO, "hipweap/laserric.wav", 1, ATTN_STATIC);
	}
}
void HIP_LaserThink()
   {
   // local float delta;


   if (time>self.attack_finished)
      {
      remove(self);
      return;
      }
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;
   self.velocity = self.old_velocity;
   self.angles = vectoangles(self.velocity);
   self.nextthink = time+0.1;
   };

entity HIP_LaunchLaser(vector org, vector vec, float light)
{
	local entity enMissile;
	vec = normalize(vec);

	enMissile = spawn();
	enMissile.owner = self;
	enMissile.classname = "hiplaser";
	enMissile.lastvictim = self;
	enMissile.movetype = MOVETYPE_FLYMISSILE;
	enMissile.solid = SOLID_BBOX;
   
	// DRESK
	// Always suppress light
	/*
	if (light)
		enMissile.effects = EF_DIMLIGHT;
	*/


	setmodel (enMissile, "progs/lasrspik.mdl");
	setsize (enMissile, '0 0 0', '0 0 0');

	setorigin (enMissile, org);

	enMissile.speed = 1000;
	enMissile.dmg = 18;
	enMissile.velocity = vec * enMissile.speed;
	enMissile.old_velocity = enMissile.velocity;
	enMissile.angles = vectoangles(enMissile.velocity);
	enMissile.avelocity = '0 0 400';
	// DRESK
	// Disable Shadow
	enMissile.effects = EF_NOSHADOW;
	
	// Acquire Random Amount of Max Bounces
	enMissile.nHipnoticLaserBounceMax = 3 + rint((random() * 2));

	enMissile.nextthink = time;
	enMissile.attack_finished = time + 5;
	enMissile.think = HIP_LaserThink;
	enMissile.touch = HIP_LaserTouch;
	enMissile.count = 0;
   
   // DRESK
   // Assign Silent Contents Transition
   enMissile.contentstransition = SilentContentsTransition;
   
   return enMissile;
}

/*
=================
HIP_FireLaser
=================
*/
void HIP_FireLaser()
{
	local vector org;
	local vector dir;
	local vector out;
	local float ofs;
	local float aofs;
	local entity enMissile;
	
	// DRESK
	// Acquire Stat
	local float stat;
	stat = CheckLaserGunStat(self);

	ofs = 6;
	out = v_forward;
	out_z = 0;
	out = normalize(out);
	// org = self.origin + ((12-ofs) * v_up) + (12*out);
	WeaponEvents_SetupOriginAndDirection('16 0 0');
	org = vCurrentShotOrigin;
	//   org = self.origin + (1*v_forward);
	dir = v_forward;
	aofs = ofs * 0.707;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	
	PlayerAnim_Attack_Nailgun(PLAYERANIM_ANIMSPEED_NAILGUN);
	
	WEAPON_BEGININITIALFIREEVENTS
		WeaponEvents_WeaponAnim(1, 5, WEAPONANIMSPEED_STANDARD, WeaponStateFunction_RepeatAnimation);
	WEAPON_ENDINITIALFIREEVENTS
		
	if (stat == 0)
	{
		org = org + (aofs*v_right);
		org = org - (aofs*v_up);
		HIP_LaunchLaser(org, dir, 0);
		org = org - (2*aofs*v_right);
		HIP_LaunchLaser(org, dir, 0);
	}
	else if (stat == 1)
	{
		org = org + (ofs*v_up);
		if (random()<0.1)
		{
			enMissile = HIP_LaunchLaser(org, dir, 1);
			enMissile.dmg = 25;
		}
		else
		HIP_LaunchLaser(org, dir, 0);
	}
	
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_LASER_CANNON, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, org, v_forward);
}

/*
=================
HIP_HammerDamage
=================
*/
void HIP_HammerDamage(vector p1, vector p2, entity from, float damage)
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
//JIM
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		// DRESK
		// Damagetype Support
		T_Damage (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_MJOLNIRLIGHTNING, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		// DRESK
		// Damagetype Support
		T_Damage (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_MJOLNIRLIGHTNING, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		// DRESK
		// Damagetype Support
		T_Damage (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_MJOLNIRLIGHTNING, damage);
	}
};

/*
void() HIP_DiversionLightningThink =
   {
   local vector   org,end;

   if (time > self.delay)
      {
      remove(self);
      return;
      }

   makevectors(self.v_angle);
   org = self.origin;
   end = org + v_forward*200;
//   end = end + (((200*random()) - 100) * v_up);
   end = end + (((400*random()) - 200) * v_right);

   traceline (org, end, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);

   self.nextthink = time + 0.1;
   };
*/

//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void HIP_LightningThink()
{
	local vector org;
	local vector dst;
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector vec;
	local float dot;
	local float oldstate;
	local float dam;


	if (time > self.delay)
	{
		if (self.enemy != world)
			self.enemy.struck_by_mjolnir = 0;
		remove(self);
		return;
	}
	oldstate = self.state;
	if (self.state==0)
	{
		// look in our immediate vicinity
		self.enemy = world;
		selected = world;
		cur_dist = self.distance;
		head = findradius(self.owner.origin, self.distance);
		while(head)
		{
			// DRESK
			// Prevent Lightning from Striking Other Players in Coop
			if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || ( (head.flags & FL_CLIENT) && !coop)))
			{
				//            if (visible(head) && (head!=self.owner.owner) && (head.health>0))
				if ((visible(head)) && (head!=self.owner.owner) && (head.health>0))
				{
					head_dist = vlen(head.origin - self.lastvictim.origin);
					if ((head_dist<cur_dist) && (head.struck_by_mjolnir==0))
					{
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
		if (selected != world)
		{
			self.state = 1;
			self.enemy = selected;
			self.enemy.struck_by_mjolnir = 1;
		}
		else
		{
			// DRESK
			// Duplicate Variable Removal
			local vector end;
			// local vector   org,end;

			makevectors(self.v_angle);
			org = self.owner.origin;
			end = org + v_forward*200;
			end = end + (((400*random()) - 200) * v_right);

			traceline (org, end, TRUE, self);

			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity (MSG_BROADCAST, self);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
			WriteCoord (MSG_BROADCAST, trace_endpos_x);
			WriteCoord (MSG_BROADCAST, trace_endpos_y);
			WriteCoord (MSG_BROADCAST, trace_endpos_z);

			self.nextthink = time + 0.1;
			//         self.think = HIP_DiversionLightningThink;
			//         self.nextthink = time;
			//         self.delay = time + 0.30;
			//         self.origin = self.owner.origin;
			//         self.think();
			return;
		}
	}
	org = self.lastvictim.origin;
	dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
	dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
	traceline (org, dst, TRUE, self.owner.owner);

	if (trace_fraction != 1.0 || self.enemy.health<=0)
	{
		self.enemy.struck_by_mjolnir = 0;
		self.state = 0;
		self.nextthink = time + 0.1;
		return;
	}
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	vec = normalize(self.enemy.origin - self.owner.origin);
	dot = vec * self.owner.movedir;
	head = self;
	self = self.owner.owner;
	if (oldstate==0)
		dam = 80;
	else
		dam = 30;
	if (dot>0.3)
		HIP_HammerDamage (org, trace_endpos, self, dam);
	else
		HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
	self = head;

	self.nextthink = time + 0.2;
}

void HIP_SpawnMjolnirLightning(entity prev, entity own, float dst)
{
	local entity light;
	// spawn actual lightning
	light = spawn();
	light.delay = time + 0.8;
	light.state = 0;
	light.lastvictim = prev;
	light.distance = dst;
	light.owner = own;
	light.v_angle = self.angles;
	light.v_angle_x = 0;
	light.v_angle_z = 0;
	light.origin = own.origin;
	light.think = HIP_LightningThink;
	light.nextthink = time;
}

void HIP_SpawnMjolnirBase()
{
	local entity light;
	// spawn lightning base
	light = spawn();
	//   light.origin = self.origin - '0 0 24' + (32*v_forward);
	light.origin = trace_endpos;
	light.flags = 0;
	light.owner = self;
	light.struck_by_mjolnir = 1;
	light.think = SUB_Remove;
	light.nextthink = time + 1;
	sound (light, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
	sound (light, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
	makevectors(self.v_angle);
	light.movedir = v_forward;
	HIP_SpawnMjolnirLightning( light, light, 350 );
	HIP_SpawnMjolnirLightning( light, light, 350 );
	HIP_SpawnMjolnirLightning( light, light, 350 );
	HIP_SpawnMjolnirLightning( light, light, 350 );
}

void HIP_FireMjolnirLightning()
{
	// local vector	org;
	local float		cells;

	// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		// DRESK
		// Utilize All Ammo
		if( !SG_AUTOCVAR(kleshik_server_ammo_infinite) )
		{
			if(g_bCoopSharedAmmo)
				UpdateSharedAmmo(AMMOTYPE_CELLS, cells * -1);
			else
				self.ammo_cells = 0;
		}
			
		discharged = 1;
		T_RadiusDamage (self, self, DAMAGETYPE_WEAPON_MJOLNIR, 35*cells, world);
		discharged = 0;
		W_SetCurrentAmmo(FALSE);
		return;
	}

	//   if (self.t_width < time)
	//   {
	//      sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
	//      self.t_width = time + 0.6;
	//   }
	//   self.punchangle_x = 12;

	// DRESK
	if( !SG_AUTOCVAR(kleshik_server_ammo_infinite) )
	{
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_CELLS, -50);
		else
			self.ammo_cells = self.ammo_cells - 50;
	}

	HIP_SpawnMjolnirBase();
}

void HIP_FireMjolnir_NoLightning()
{
	local vector source;
	local vector org;
	local float damage;
	
	WeaponEvents_SetupOriginAndDirection('0 0 0');
	source = vCurrentShotOrigin;
	traceline (source, source + v_forward*64, FALSE, self);
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		damage = 50;
		if (trace_ent.classname == "monster_zombie")
			damage = 70;
		
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
		{
			sound (trace_ent, CHAN_AUTO, "hipweap/mjoltink.wav", 1, ATTN_NORM);
		}
		else
		{ // Fleshy
			// DRESK
			// Play a sound!
			sound (trace_ent, CHAN_AUTO, "demon/dhit2.wav", 1, ATTN_NORM);
		}
		
		// DRESK
		// Damagetype Support
		T_Damage (trace_ent, self, self, org, DAMAGETYPE_WEAPON_MJOLNIR, damage);
	}
	else
	{  // hit wall
		if (trace_fraction != 1.0)
		{
			//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
			sound (self, CHAN_AUTO, "hipweap/mjoltink.wav", 1, ATTN_NORM);
			// DRESK
			// Produce Sparks (server-side to make them oppose the surface)
			te_spark(org, trace_plane_normal * 100, 100);
			te_AxeHitMaterial(org);
		}
		// DRESK
		// Attack Sound ALWAYS Played in Initial Attack
		/*
		else
		{
			sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
		}
		*/
	}
}
void HIP_FireMjolnir()
{
	local vector	org;
	// local float		cells;
	local float		damage;
	local vector	source;
	// local vector	ang;


	// self.attack_finished = time + 0.4;
	WeaponEvents_SetupOriginAndDirection('0 0 0');
	source = vCurrentShotOrigin;
	//   ang = self.angles;
	//   ang_x = 0;
	//   ang_y = 0;
	traceline (source, source + v_forward*64, FALSE, self);
	
	if (trace_fraction == 1.0 && (self.ammo_cells >= 30) )
	{
		source = source + v_forward*32;
		traceline (source , source - v_up*50, FALSE, self);
		//      dprint("fraction = ");
		//      dprint(ftos(trace_fraction));
		//      dprint("\n");
		if (trace_fraction > 0.3 && trace_fraction< 1.0)
		{
			HIP_FireMjolnirLightning();
			self.attack_finished = time + 1.5;
			return;
		}
	}
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		damage = 50;
		if (trace_ent.classname == "monster_zombie")
			damage = 70;
		
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
		{
			sound (trace_ent, CHAN_AUTO, "hipweap/mjoltink.wav", 1, ATTN_NORM);
		}
		else
		{ // Fleshy
			// DRESK
			// Play a sound!
			sound (trace_ent, CHAN_AUTO, "demon/dhit2.wav", 1, ATTN_NORM);
		}
		
		// DRESK
		// Damagetype Support
		T_Damage (trace_ent, self, self, org, DAMAGETYPE_WEAPON_MJOLNIR, damage);
	}
	else
	{  // hit wall
		if (trace_fraction != 1.0)
		{
			//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
			sound (self, CHAN_AUTO, "hipweap/mjoltink.wav", 1, ATTN_NORM);
			// DRESK
			// Produce Sparks (server-side to make them oppose the surface)
			te_spark(org, trace_plane_normal * 100, 100);
			te_AxeHitMaterial(org);
		}
		// DRESK
		// Attack Sound ALWAYS Played in Initial Attack
		/*
		else
		{
			sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
		}
		*/
	}
	
	// self.attack_finished = time + 0.4;
}

// DRESK
// Create Standard Mjolrnir Attack Function
void W_FireMjolnir()
{ // Mjolrnir Attack
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_FALSE);
	WeaponEvents_WeaponAnim(1, 4, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('0 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_MJOLNIR, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Hammer(PLAYERANIM_ANIMSPEED_STANDARD);
	
	if(self.button3 || self.ammo_cells < 30)
		// Do NOT Invoke Lightning
		WeaponEvents_DelayedAttackFunction(HIP_FireMjolnir_NoLightning, 0.2);
		// HIP_FireMjolnir(TRUE);
	else
		// Invoke Lightning
		WeaponEvents_DelayedAttackFunction(HIP_FireMjolnir, 0.2);
}

void DumpEntities()
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      dprint(ftos(i));
      dprint(" ");
      dprint(head.classname);
      dprint("\n");
      head = nextent(head);
      i = i + 1;
      }
   };

void DumpLiveEntities()
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      if (head.health > 0)
         {
         dprint(ftos(i));
         dprint(" ");
         dprint(head.classname);
         dprint(" ");
         dprint(vtos(head.origin));
         dprint("\n");
         dprint("--------------------\n");
         }
      head = nextent(head);
      i = i + 1;
      }
   };

void Genocide()
   {
   local entity   head;

   if (deathmatch || coop)
		return;
   bprint("Genocide!\n");
   head = nextent(world);
   while (head!=world)
      {
      if ((head.health > 0) && (head.flags & FL_MONSTER))
         {
         T_Damage(head,world,world, HITLOCATION_NONE, DAMAGETYPE_MISC_GENOCIDE, head.health+10);
         }
      head = nextent(head);
      }
   };

float dump_coord;
void ToggleDump()
   {
   dump_coord = 1 - dump_coord;
   if (dump_coord == 1)
      bprint("Dumping Player Location\n");
   };
void DumpCoordinates()
   {
   local entity pl;
   pl = checkclient();
   if (pl)
      {
      bprint("Player: ");
      bprint(vtos(pl.origin));
      bprint("\n");
      }
   };