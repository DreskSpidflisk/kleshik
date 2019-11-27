void W_Precache()
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
		W_PrecacheHipnoticWeapons();
	if(g_bKleshikWeaponsEnabled)
		PrecacheKleshikWeaponsData();
}
/*
================
W_FireAxe
================
*/
void W_FireAxe()
{ // Fire Axe Main
	local float fRandom;
	
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_FALSE);
	WeaponEvents_DelayedAttackFunction(W_AxeAttack, 0.1);
	WeaponEvents_SetupOriginAndDirection('0 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_AXE, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	// Acquire Random Animation
	fRandom = random();
	if(fRandom < 0.25)
	{
		WeaponEvents_WeaponAnim(1, 4, WEAPONANIMSPEED_AXE, __NULL__);
		PlayerAnim_Attack_Axe(0, PLAYERANIM_ANIMSPEED_AXE);
	}
	else
	if(fRandom < 0.5)
	{
		WeaponEvents_WeaponAnim(5, 8, WEAPONANIMSPEED_AXE, __NULL__);
		PlayerAnim_Attack_Axe(1, PLAYERANIM_ANIMSPEED_AXE);
	}
	else
	if(fRandom <0.75)
	{
		WeaponEvents_WeaponAnim(1, 4, WEAPONANIMSPEED_AXE, __NULL__);
		PlayerAnim_Attack_Axe(2, PLAYERANIM_ANIMSPEED_AXE);
	}
	else
	{
		WeaponEvents_WeaponAnim(5, 8, WEAPONANIMSPEED_AXE, __NULL__);
		PlayerAnim_Attack_Axe(3, PLAYERANIM_ANIMSPEED_AXE);
	}
}
void W_AxeAttack()
{ // Primary Axe Attack
	local	vector	source;
	local	vector	org;

	WeaponEvents_SetupOriginAndDirection('0 0 0');
	source = vCurrentShotOrigin;
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		local string strSound;
		// DRESK
		// Substitute Sparks for Blood on Brushes
		if(trace_ent.solid == SOLID_BSP)
		{ // Brush
			strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITGENERIC1;
		}
		else
		{ // Non-Brush
			// Provide Additional Sound Feedback
			local float nRandom;
				nRandom = random();
			if(nRandom < 0.33)
			{
				if(trace_ent.bBleedsSparks)
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITMETAL1;
				else
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITFLESH1;
			}
			else
			if(nRandom < 0.66)
			{
				if(trace_ent.bBleedsSparks)
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITMETAL2;
				else
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITFLESH2;
			}
			else
			{
				if(trace_ent.bBleedsSparks)
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITMETAL3;
				else
					strSound = SOUND_KLESHIK_WEAPONS_AXE_AXEHITFLESH3;
			}
		}
				
		// NOTE: Play Sound on Attacker for more "Visceral" Volume
		sound (self, CHAN_AUTO, strSound, 1, ATTN_NORM);
		
		// DRESK
		// Increased Damage of Axe
		T_Damage (trace_ent, self, self, org, DAMAGETYPE_WEAPON_AXE, 45);
	}
	else
	{	// hit wall
		// DRESK
		// Modified Sound Source
		sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
		
		// DRESK
		// Produce Sparks (server-side to make them oppose the surface)
		te_spark(org, trace_plane_normal * 100, 100);
		te_AxeHitMaterial(org);
	}
}


//============================================================================

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void ClearMultiDamage()
{
	multi_ent = world;
	multi_damage = 0;
}
// DRESK
// Support Damage Type, Direction
void ApplyMultiDamage(float fDamageType, vector vDirection)
{
	if (!multi_ent)
		return;
	// DRESK
	// Support Directional Damage
	T_Damage_Direction(multi_ent, self, self, HITLOCATION_NONE, fDamageType, multi_damage, TRUE, vDirection);
}

// DRESK
// Support Damage Type, Direction
void AddMultiDamage(entity hit, float fDamageType, float damage, vector vDirection)
{
	if (!hit)
		return;
	
	if (hit != multi_ent)
	{
		ApplyMultiDamage (fDamageType, vDirection);
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
}

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
// DRESK
// Support Damage Types
void TraceAttack(float fDamageType, float damage, vector dir)
{
	local	vector	vel, org;
	
	vel = normalize(dir + v_up*SG_crandom() + v_right*SG_crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		if( SG_AUTOCVAR(kleshik_server_weapon_AllShotguns_PerBulletDamage) )
			T_Damage_Direction(trace_ent, self, self, org, fDamageType, damage, TRUE, dir);
		else
			AddMultiDamage (trace_ent, fDamageType, damage, dir);
	}
	else
	{
		// DRESK
		// Support Quad Gunshot
		if(self.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
			te_gunshotquad(org);
		else
			te_gunshot(org);
	}
}

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
// DRESK
// Support Damage Types
void FireBullets(float fDamageType, float fDamage, float shotcount, vector dir, vector spread)
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	// DRESK
	// New Origin Logic (what is with that old shit?)
	src = vCurrentShotOrigin;
	/*
	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
	*/

	if(! SG_AUTOCVAR(kleshik_server_weapon_AllShotguns_PerBulletDamage) )
		ClearMultiDamage ();

	while (shotcount > 0)
	{
		direction = dir + SG_crandom()*spread_x*v_right + SG_crandom()*spread_y*v_up;
		// direction = normalize(direction);

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (fDamageType, fDamage, direction);

		shotcount = shotcount - 1;
	}
	
	if(! SG_AUTOCVAR(kleshik_server_weapon_AllShotguns_PerBulletDamage) )
		ApplyMultiDamage (fDamageType, dir);
}



/*
================
W_FireShotgun
================
*/
void W_FireShotgun()
{
	local vector dir;

	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SHOTGUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);

	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	// DRESK
	// Remove Aiming
	// dir = aim (self, 100000);
	dir = v_forward;
	FireBullets (DAMAGETYPE_WEAPON_SHOTGUN, WEAPON_FIREBULLETS_STANDARD_DAMAGE, WEAPON_SHOTGUN_NUMBULLETS, dir, WEAPON_SHOTGUN_SPREAD);
}

/*
================
W_FireSuperShotgun
================
*/
void W_FireSuperShotgun()
{
	local vector dir;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SUPER_SHOTGUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	// Remove Aiming
	// dir = aim (self, 100000);
	dir = v_forward;
	
	// DRESK
	// Fire Additional Bullets
	FireBullets (DAMAGETYPE_WEAPON_SUPERSHOTGUN, WEAPON_FIREBULLETS_STANDARD_DAMAGE, WEAPON_SUPER_SHOTGUN_NUMBULLETS, dir, WEAPON_SUPER_SHOTGUN_SPREAD);
	// FireBullets (DAMAGETYPE_WEAPON_SUPERSHOTGUN, 14, dir, '0.14 0.08 0');
}


/*
==============================================================================

ROCKETS

==============================================================================
*/
void T_MissileTouch()
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
	// Support Elite Monsters
	if(other.bIsEliteMonster)
	{ // Elite Monster; Redirect to Missile Owner
		EliteMonsterRedirectProjectile(other, self);
	}
	else
	{ // Standard
		damg = 110 + random()*20;
		
		// DRESK
		// Remove Potential Gyro Physics Properties
		if(g_bGyroPhysicsEnabled)
			Gyro_Object_ClearPhysics(self);
		
		// DRESK
		// Shifted All Damage to Radius Damage (no more point damage)
		/*
		if (other.health)
		{
			if (other.classname == "monster_shambler")
				T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_ROCKETLAUNCHER, damg * 0.5);
			else
				T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_ROCKETLAUNCHER, damg);
		}
		*/

		// don't do radius damage to the other, because all the damage
		// was done in the impact
		T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_ROCKETLAUNCHER, damg, world);

		self.origin = self.origin - 8*normalize(self.velocity);

		// DRESK
		// Support Quad Explosion
		if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
			te_explosionquad(self.origin);
		else
			// Standard Explosion
			te_explosion(self.origin);

		BecomeExplosion ();
	}
}
/*
================
W_FireRocket
================
*/
void W_FireRocket()
{
	// DRESK
	// Unused Variable(s)
	// local	entity missile, mpuff;
	local entity missile;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_ROCKET_LAUNCHER, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Rocket(PLAYERANIM_ANIMSPEED_STANDARD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
		
	// set missile speed	
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
	{ // Thrust Based Velocity
		// missile.velocity = aim(self, 700);
		missile.velocity = v_forward * 900;
	}
	else
	{ // Normal Velocity
		// missile.velocity = aim(self, 1000);
		missile.velocity = v_forward * 1000;
	}
	
	missile.angles = vectoangles(missile.velocity);
	
	// DRESK
	// Support Explosives Owner Velocity Ratio
	local float fExplosivesOwnerVelocityRatio;
		fExplosivesOwnerVelocityRatio = cvar(CVAR_WEAPON_PROJECTILESOWNERVELOCITYRATIO);
	if(fExplosivesOwnerVelocityRatio)
		missile.velocity = missile.velocity + (self.velocity * fExplosivesOwnerVelocityRatio);
	
	missile.touch = T_MissileTouch;
	
	// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, vCurrentShotOrigin);
	// setorigin (missile, self.origin + v_forward*8 + '0 0 16');
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Rocket(missile, 800, 1000);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
	
	// DRESK
	// Support Case Ejection
	local entity enCase;
	// Spawn Case
	enCase = spawn();
	// Assign Model
	setmodel(enCase, "progs/grenade.mdl");
	// Assign Effects
	enCase.effects = EF_LOWPRECISION | EF_NOSHADOW;
	// Assign Silent Contents Transition
	enCase.contentstransition = SilentContentsTransition;
	// Assign Scale
	enCase.scale = 0.3;
	// Assign Movetype
	enCase.movetype = MOVETYPE_TOSS;
	// Assign Non-Collision Attributes
	enCase.solid = SOLID_NOT;
	enCase.takedamage = DAMAGE_NO;
	// Assign Origin
	setorigin(enCase, missile.origin);
	// Assign Velocity
	enCase.velocity = (v_right * -1 * (75 + random() * 100) ) + (v_up * (100 + random() * 150) );
	// Assign Angle Velocity
	enCase.avelocity = '1200 0 0';
	// Assign Removal
	enCase.touch = SUB_Remove;
	enCase.nextthink = time + 0.7;
	enCase.think = SUB_Remove;
}

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
// DRESK
// Migrate Lightning Discharge to Function
void LightningDischarge(float fDamageType)
{ // Lightning Discharge
	// NOTE: Assumed scope is the client discharging.
	local float fCells;
	
	// Backup Cells
	fCells = self.ammo_cells;
	// self.ammo_cells = 0;
	
	// DRESK
	// Utilize All Ammo
	if( !SG_AUTOCVAR(kleshik_server_ammo_infinite) )
	{
		if(g_bCoopSharedAmmo)
			UpdateSharedAmmo(AMMOTYPE_CELLS, fCells * -1);
		else
			self.ammo_cells = 0;
	}
		
	W_SetCurrentAmmo(FALSE);
	
	// Create Explosion
	te_explosionrgb(self.origin, '0 1 1');
	
	// Perform Radius Damage
	T_RadiusDamage (self, self, fDamageType, 35 * fCells, world);
}
void LightningDamage(vector p1, vector p2, entity from, float damage)
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
	
	// DRESK
	// Provide Contents Mask Collision
	self.dphitcontentsmask = DPCONTENTS_SOLID | DPCONTENTS_BODY | DPCONTENTS_WATER | DPCONTENTS_SLIME;

	traceline (p1, p2, FALSE, self);
	
	// Reset Hitmask
	self.dphitcontentsmask = 0;
	
	// DRESK
	// Calculate Direction of Damage
	local vector vDirection;
		vDirection = normalize(p2 - p1);
		
	// Support Beam Discharges (ONLY for players)
	// if(trace_inwater)
	if(self.flags & FL_CLIENT && trace_dphitcontents & DPCONTENTS_WATER || trace_dphitcontents & DPCONTENTS_SLIME)
	{ // Water Hit Water; Explode
		if( SG_AUTOCVAR(kleshik_server_weapon_Thunderbolt_BeamDischarges) && getsurfacetexture(trace_ent, getsurfacenearpoint(trace_ent, trace_endpos) ) != "*teleport")
		{ // Beam Discharges
			LightningDischarge(DAMAGETYPE_WEAPON_LIGHTNINGBEAMDISCHARGE);
			return;
		}
	}
			
	if (trace_ent.takedamage)
	{
		// DRESK
		// Check for Sparks
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
			te_spike(trace_endpos);
		else
			particle (trace_endpos, '0 0 100', 225, damage*4);
		
		// DRESK
		// Support Directional Damage
		T_Damage_Direction (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_LIGHTNING, damage, TRUE, vDirection);
		// DRESK
		// Additional Feedback
		te_smallflash(trace_ent.origin);
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		// DRESK
		// Check for Sparks
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
			te_spike(trace_endpos);
		else
			particle (trace_endpos, '0 0 100', 225, damage*4);
		
		// DRESK
		// Support Directional Damage
		T_Damage_Direction (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_LIGHTNING, damage, TRUE, vDirection);
		// DRESK
		// Additional Feedback
		te_smallflash(trace_ent.origin);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		// DRESK
		// Check for Sparks
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
			te_spike(trace_endpos);
		else
			particle (trace_endpos, '0 0 100', 225, damage*4);
		
		// DRESK
		// Support Directional Damage
		T_Damage_Direction (trace_ent, from, from, trace_endpos, DAMAGETYPE_WEAPON_LIGHTNING, damage, TRUE, vDirection);
		// DRESK
		// Additional Feedback
		te_smallflash(trace_ent.origin);
	}
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void W_FireLightning()
{

	// explode if under water
	if (self.waterlevel > 1)
	{
		// DRESK
		// Utilize Function
		LightningDischarge(DAMAGETYPE_WEAPON_LIGHTNINGDISCHARGE);
		return;
	}
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_FALSE);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	// Ensures Muzzle Flash Never Disappears
	PlayerAnim_Attack_Lightning(PLAYERANIM_ANIMSPEED_NAILGUN);
	
	WEAPON_BEGININITIALFIREEVENTS
		WeaponEvents_WeaponAnim(1, 5, WEAPONANIMSPEED_STANDARD, WeaponStateFunction_RepeatAnimation);
		WeaponCSQCTemporaryEntity(etof(self), WEAPON_LIGHTNING, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	WEAPON_ENDINITIALFIREEVENTS

	// DRESK
	// Nested Logic for Weapon Sound
	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}

	// org = self.origin + '0 0 16';
	
	traceline (vCurrentShotOrigin, vCurrentShotOrigin + v_forward*600, TRUE, self);

	te_lightning2(self, vCurrentShotOrigin, trace_endpos);
	/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	*/

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
}


//=============================================================================

// DRESK
// C-STYLE FUNCTION SYNTAX
void GrenadeExplode()
{
	// DRESK
	// Restore Real Owner
	RestoreOwnerTouchableProjectileOwner(self);
		
	// Remove Potential Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_Object_ClearPhysics(self);
		
	T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_GRENADELAUNCHER, 130, world);

	// DRESK
	// Support Quad Explosion
	if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
		te_explosionquad(self.origin);
	else
		// Standard Explosion
		te_explosion(self.origin);

	BecomeExplosion ();
}
void GrenadeTouch()
{	
	// DRESK
	// Support Elite Monster and Non-Owner
	if(other.bIsEliteMonster)
		EliteMonsterRedirectProjectile(other, self);
	else
	if(other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
	
	// DRESK
	// Provide Feedback
	te_GrenadeBounce(self.origin);
}

/*
================
W_FireGrenade
================
*/
void W_FireGrenade()
{
	// DRESK
	// Unused Variable(s)
	// local	entity missile, mpuff;
	local entity missile;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_GRENADE_LAUNCHER, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Rocket(PLAYERANIM_ANIMSPEED_STANDARD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
	// set missile speed
	
	// DRESK
	// Support Additional Velocity
	local float fForwardVelocity;
		fForwardVelocity = 1200;

	// DRESK
	// Remove the "potential" straight looking calculations
	//if (self.v_angle_x)
		missile.velocity = v_forward * fForwardVelocity + v_up * 200 + SG_crandom()*v_right*10 + SG_crandom()*v_up*10;
	/*else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * fForwardVelocity;
		missile.velocity_z = 200;
	}
	*/
	
	// DRESK
	// Support Explosives Owner Velocity Ratio
	local float fExplosivesOwnerVelocityRatio;
		fExplosivesOwnerVelocityRatio = cvar(CVAR_WEAPON_PROJECTILESOWNERVELOCITYRATIO);
	if(fExplosivesOwnerVelocityRatio)
		missile.velocity = missile.velocity + (self.velocity * fExplosivesOwnerVelocityRatio);

	// missile.avelocity = '300 300 300';
	missile.avelocity = '-1200 000 000';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = GrenadeTouch;
	
// set missile duration
	// DRESK
	PrepareOwnerTouchableProjectile(missile, GrenadeExplode, 2.5);
	/*
	{ // Utilize Standard Next Think
		missile.nextthink = time + 2.5;
		missile.think = GrenadeExplode;
	}
	*/

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	// setorigin (missile, self.origin);
	setorigin (missile, vCurrentShotOrigin);
	
	// DRESK
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_Grenade(missile, 800);
		
	// Assign Small Object in Water Contents Transition
	missile.contentstransition = ContentsTransition_SmallObjectInWater;
}


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike
===============
*/
entity launch_spike(vector org, vector dir)
{
	local entity enMissile;
	enMissile = spawn ();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLYMISSILE;
	enMissile.solid = SOLID_BBOX;

	enMissile.angles = vectoangles(dir);
	
	enMissile.touch = spike_touch;
	enMissile.classname = "spike";
	enMissile.think = SUB_Remove;
	enMissile.nextthink = time + 6;
	setmodel (enMissile, "progs/spike.mdl");
	setsize (enMissile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (enMissile, org);
	
	// DRESK
	// Apply Fullbright to Spikes
	enMissile.effects = EF_FULLBRIGHT;
	
	// Utilize Silent Contents Transition
	enMissile.contentstransition = SilentContentsTransition_GrenadeMFInWater;
	// enMissile.contentstransition = SilentContentsTransition;
	
	// Provide Angle Velocity
	enMissile.avelocity = '0 0 1500';
	// Support Grenade Model Flag
	if( (enMissile.owner.watertype == CONTENT_WATER || enMissile.owner.watertype == CONTENT_SLIME) && enMissile.owner.waterlevel == 3)
		enMissile.modelflags = enMissile.modelflags | MF_GRENADE;

	enMissile.velocity = dir * 1000;
	
	return enMissile;
}
void Laser_Touch()
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	// DRESK - HIPNOTIC SUPPORT
	// Support Silent Laser Impact
	// UPDATE : Suppress Sound Entirely for Sound Channel's Sake
	// if( !(self.spawnflags & SPAWNFLAG_SILENT) )
		// sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
			
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		// DRESK
		// UPDATE: Shifted blood logic to T_Damage
		// SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_MONSTER_ENFORCER_LASER, 15);
		te_SimpleLaserTouch(org);
	}
	else
	{
		te_SimpleLaserTouch(org);
	}
	
	remove(self);
}
entity LaunchLaser(vector org, vector vec)
{
	local entity enMissile;

	vec = normalize(vec);
	
	enMissile = spawn();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLY;
	enMissile.solid = SOLID_BBOX;
	
	// DRESK
	// Modified Effects
	enMissile.effects = EF_FULLBRIGHT | EF_NOSHADOW;
	enMissile.colormod = '0.5 1 0.5';
	// enMissile.effects = EF_DIMLIGHT;
	
	// DRESK
	// Assign Glow Trail
	enMissile.glow_color = 31;
	enMissile.glow_trail = TRUE;

	setmodel (enMissile, "progs/laser.mdl");
	setsize (enMissile, '0 0 0', '0 0 0');		

	setorigin (enMissile, org);

	enMissile.velocity = vec * 600;
	enMissile.angles = vectoangles(enMissile.velocity);

	enMissile.nextthink = time + 5;
	enMissile.think = SUB_Remove;
	enMissile.touch = Laser_Touch;
	
	return enMissile;
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void W_FireSuperSpikes()
{
	local vector	dir;
	local entity	enMissile;
	
	// DRESK
	// Weapon PreFire Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	PlayerAnim_Attack_Nailgun(PLAYERANIM_ANIMSPEED_NAILGUN);
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SUPER_NAILGUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	WEAPON_BEGININITIALFIREEVENTS
		WeaponEvents_WeaponAnim(1, 8, WEAPONANIMSPEED_NAILGUNS, WeaponStateFunction_RepeatAnimation);
	WEAPON_ENDINITIALFIREEVENTS
	
	// Remove Aiming
	// dir = aim (self, 1000);
	dir = v_forward;
	enMissile = launch_spike (vCurrentShotOrigin, dir);
	enMissile.touch = superspike_touch;
	setmodel (enMissile, "progs/s_spike.mdl");
	setsize (enMissile, VEC_ORIGIN, VEC_ORIGIN);
	
	// DRESK
	// Use nGibType for Detailed Nail Touch
	enMissile.nGibType = 1;
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void W_FireSpikes()
{
	local vector	dir;
	local entity	enMissile;
	// DRESK
	// Unused Variable(s)
	// local entity	old;
	
	// Check NailGun Offset
	local float fOffset;
	local float nBeginWeaponFrame;
		fOffset = CheckNailGunOffset(self);
	
	if(fOffset == 3)
		nBeginWeaponFrame = 2;
	else
		nBeginWeaponFrame = 1;

		
	local float ox;
		ox = fOffset;
	
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(nBeginWeaponFrame, nBeginWeaponFrame, WEAPONANIMSPEED_NAILGUNS, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_NAILGUN, WEAPON_FIRINGMODE_PRIMARY, nBeginWeaponFrame, vCurrentShotOrigin + v_right*ox, v_forward);
	
	PlayerAnim_Attack_Nailgun(PLAYERANIM_ANIMSPEED_NAILGUN);
	
	// Remove Aiming
	// dir = aim (self, 1000);
	dir = v_forward;
	enMissile = launch_spike (vCurrentShotOrigin + v_right*ox, dir);
	
	// DRESK
	// Speed up Normal Nails
	enMissile.velocity = enMissile.velocity * 1.8;
	
	// DRESK
	// Use nGibType for Detailed Nail Touch
	enMissile.nGibType = 1;
}
void spike_touch()
{
	// DRESK
	// Hit Bleeder
	local float bHitBleeder;
		bHitBleeder = FALSE;
	// Unused Variable(s)
	// local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		if(other.solid != SOLID_BSP && !other.bBleedsSparks)
			bHitBleeder = TRUE;
			
		local float fDamageType;
		if(self.classname == "wizspike")
		{
			fDamageType = DAMAGETYPE_MONSTER_WIZARD_MISSILE;
			// Additionally Produce Effect Here
			te_wizspike(self.origin);
		}
		else
		if(self.classname == "knightspike")
		{
			fDamageType = DAMAGETYPE_MONSTER_KNIGHT_MISSILE;
			// Additionally Produce Effect Here
			te_knightspike(self.origin);
		}
		else
			fDamageType = DAMAGETYPE_WEAPON_SPIKE_TOUCH;
			
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, fDamageType, 9);
	}
	else
	{	
		// DRESK
		// Cleaned up code to utilize DP short-calls
		if (self.classname == "wizspike")
			te_wizspike(self.origin);
		else if (self.classname == "knightspike")
			te_knightspike(self.origin);
		else
		{ // Spike Touch
			// DRESK
			// Support Quad Sparks
			if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
				te_spikequad(self.origin);
			else
				te_spike(self.origin);
		}
	}

	// DRESK
	// Support Detailed Nail Touch
	if( SG_AUTOCVAR(kleshik_server_weapon_DetailedNailTouch) && self.nGibType == 1)
	{
		if(bHitBleeder)
			self.colormod = '1 0.6 0.6';
		self.effects |= EF_LOWPRECISION;
		self.effects |= EF_NOSHADOW;
		
		self.nextthink = time + 2.0;
		self.think = SUB_Remove;
		
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_NOT;
		self.avelocity_x = random() * 1500;
		self.avelocity_y = random() * 1500;
		self.avelocity_z = random() * 1500;
		self.velocity = self.velocity * ( random() * 1);
		self.velocity_x = self.velocity_x * ( random() * 1);
		self.velocity_y = self.velocity_y * ( random() * 1);
		self.touch = __NULL__;
	}
	else
		// Standard
		remove(self);
}

// DRESK
// C-STYLE FUNCTION SYNTAX
void superspike_touch()
{
	// DRESK
	local float bHitBleeder;
		bHitBleeder = FALSE;
	// Unused Variable(s)
	// local float rand;
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		if(other.solid != SOLID_BSP && !other.bBleedsSparks)
			bHitBleeder = TRUE;
			
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_SUPERSPIKE_TOUCH, 18);
	}
	else
	{
		// DRESK
		// Support Quad Sparks
		if(self.owner.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
			te_superspikequad(self.origin);
		else
			te_superspike(self.origin);
	}
	
	// DRESK
	// Support Detailed Nail Touch
	// NOTE: CVar check disabled for performance.  Re-enable if desired.
	// if( cvar(CVAR_WEAPON_DETAILEDNAILTOUCH) )
	if(self.nGibType == 1)
	{
		if(bHitBleeder)
			self.colormod = '1 0.6 0.6';
		self.effects |= EF_LOWPRECISION;
		self.effects |= EF_NOSHADOW;
		
		self.nextthink = time + 2.0;
		self.think = SUB_Remove;
		
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_NOT;
		self.avelocity_x = random() * 1500;
		self.avelocity_y = random() * 1500;
		self.avelocity_z = random() * 1500;
		self.velocity = self.velocity * ( random() * 1);
		self.velocity_x = self.velocity_x * ( random() * 1);
		self.velocity_y = self.velocity_y * ( random() * 1);
		self.touch = __NULL__;
	}
	else
		// Standard
		remove(self);
}


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/
void W_SetCurrentAmmo(float bOnlyAmmo)
{
	// DRESK
	// NO.  No one likes having their gun jam due to ammo pickup.
	// player_run ();		// get out of any weapon firing states

	// DRESK
	// Ammo is not tracked in items anymore
	// self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	// DRESK
	// Early Cancel Out for New Logic
	if(bOnlyAmmo)
		return;
		
	UpdateCurrentWeaponEntity(self);
	
	local string strModel;	
	
	// DRESK
	// Support Floating Weapons
	CheckFloatingWeapon(self);
	// Check Player Model Update
	CheckPlayerModelUpdate(self);
	
	strModel = self.enCurrentWeaponEntity.strWeaponEntity_ViewWeaponModel;
	
	/*
	if (self.weapon == WEAPON_AXE)
	{
		// self.currentammo = 0;
		strModel = "progs/v_axe.mdl";
	}
	else if (self.weapon == WEAPON_SHOTGUN)
	{
		// self.currentammo = self.ammo_shells;
		strModel = "progs/v_shot.mdl";
		// self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEAPON_SNIPERRIFLE)
	{
		strModel = "Models/Weapons/SniperRifle/ViewWeapon.md3";
	}
	else if (self.weapon == WEAPON_SUPER_SHOTGUN)
	{
		// self.currentammo = self.ammo_shells;
		strModel = "progs/v_shot2.mdl";
		// self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == WEAPON_NAILGUN)
	{
		// self.currentammo = self.ammo_nails;
		strModel = "progs/v_nail.mdl";
		// self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == WEAPON_SUPER_NAILGUN)
	{
		// self.currentammo = self.ammo_nails;
		strModel = "progs/v_nail2.mdl";
		// self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == WEAPON_GRENADE_LAUNCHER)
	{
		// self.currentammo = self.ammo_rockets;
		strModel = "progs/v_rock.mdl";
		// self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEAPON_ROCKET_LAUNCHER)
	{
		// self.currentammo = self.ammo_rockets;
		strModel = "progs/v_rock2.mdl";
		// self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == WEAPON_LIGHTNING)
	{
		// self.currentammo = self.ammo_cells;
		strModel = "progs/v_light.mdl";
		// self.items = self.items | IT_CELLS;
	}
	
	// **********************************************
	// DRESK - HIPNOTIC SUPPORT
	else if (self.weapon == WEAPON_LASER_CANNON)
	{
		// self.currentammo = self.ammo_cells;
		strModel = "progs/v_laserg.mdl";
		// self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == WEAPON_MJOLNIR)
	{
		// self.currentammo = self.ammo_cells;
		strModel = "progs/v_hammer.mdl";
		// self.items = self.items | IT_CELLS;
	}
	else if (self.weapon == WEAPON_PROXIMITY_GUN)
	{
		// self.currentammo = self.ammo_rockets;
		strModel = "progs/v_prox.mdl";
		// self.items = self.items | IT_ROCKETS;
	}
	// DRESK - END HIPNOTIC SUPPORT
	// **********************************************
	else
	{
		// self.currentammo = 0;
		strModel = "";
	}
	*/
	
	// Assign Weapon Frame
	// self.weaponframe = 0;
	// Assign Weapon Model
	// self.weaponmodel = strModel;
	if(!self.enViewWeapon)
	{
		self.enViewWeapon = spawn();
		self.enViewWeapon.viewmodelforclient = self;
	}
	
	setmodel(self.enViewWeapon, strModel);
	// Update View Weapon Origin Offsets
	ViewWeapon_UpdateOriginOffset(self);
}

// DRESK
// C-STYLE FUNCTION SYNTAX
float W_BestWeapon()
{	
	local	float	it;
	
	it = self.nCSQCStat_Weapons;

	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{ // Hipnotic Mode
		if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & WEAPON_LIGHTNING) )
			return WEAPON_LIGHTNING;
		else if(self.ammo_cells >= 1 && (it & WEAPON_LASER_CANNON) )
			return WEAPON_LASER_CANNON;
		else if(self.ammo_nails >= 2 && (it & WEAPON_SUPER_NAILGUN) )
			return WEAPON_SUPER_NAILGUN;
		else if(self.ammo_shells >= 2 && (it & WEAPON_SUPER_SHOTGUN) )
			return WEAPON_SUPER_SHOTGUN;
		else if(self.ammo_nails >= 1 && (it & WEAPON_NAILGUN) )
			return WEAPON_NAILGUN;
		else if(self.ammo_shells >= 1 && (it & WEAPON_SHOTGUN) )
			return WEAPON_SHOTGUN;
		else if( it & WEAPON_MJOLNIR )
			return WEAPON_MJOLNIR;
		return WEAPON_AXE;
	}
	else
	{ // Regular Mode
		if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & WEAPON_LIGHTNING) )
				return WEAPON_LIGHTNING;
		if(self.ammo_nails >= 2 && (it & WEAPON_SUPER_NAILGUN) )
			return WEAPON_SUPER_NAILGUN;
		if(self.ammo_shells >= 2 && (it & WEAPON_SUPER_SHOTGUN) )
			return WEAPON_SUPER_SHOTGUN;
		if(self.ammo_nails >= 1 && (it & WEAPON_NAILGUN) )
			return WEAPON_NAILGUN;
		if(self.ammo_shells >= 1 && (it & WEAPON_SHOTGUN) )
			return WEAPON_SHOTGUN;
		return WEAPON_AXE;
	}
}

float W_CheckNoAmmo(float nFiringMode)
{
	if(self.enCurrentWeaponEntity.nWeaponEntity_AmmoTypeUsed == AMMOTYPE_NONE)
		// No Ammo Used; Allow
		return TRUE;
	// Check Ammo Needed
	local float nAmmo;
	if(nFiringMode == WEAPON_FIRINGMODE_PRIMARY)
		nAmmo = self.enCurrentWeaponEntity.nWeaponEntity_PrimaryAmmoUsed;
	else
	if(nFiringMode == WEAPON_FIRINGMODE_SECONDARY)
		nAmmo = self.enCurrentWeaponEntity.nWeaponEntity_SecondaryAmmoUsed;
	if( GetAmmoAmountFromAmmoType(self, self.enCurrentWeaponEntity.nWeaponEntity_AmmoTypeUsed) >= nAmmo)
		// Ammo Available
		return TRUE;
		
	// No Rounds Available
	WeaponEvents_DryFireSound(SOUND_KLESHIK_WEAPONS_GENERICDRYFIRE);
	return FALSE;
	/*
	if( GetActiveWeaponAmmoAmount(self) > 0)
		return TRUE;

	if(self.weapon == WEAPON_AXE)
		return TRUE;
		
	// DRESK - HIPNOTIC SUPPORT
	if(self.weapon == WEAPON_MJOLNIR)
		return TRUE;
	
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo (FALSE);
	
	// drop the weapon down
	return FALSE;
	*/
}

/*
============
W_Attack

An attack impulse can be triggered now
============
*/

// DRESK
// C-STYLE FUNCTION SYNTAX
void W_Attack()
{
	// DRESK
	// Use Function Pointers
	local void() fpWeapon;
	local float bAttackWakesMonsters;
	local float nFiringMode;
		
	
	// Check Primary Attack
	if(self.button0)
	{
		fpWeapon = self.enCurrentWeaponEntity.fpWeaponEntity_PrimaryFireFunction;
		nFiringMode = WEAPON_FIRINGMODE_PRIMARY;
	}
	else
	// Check Secondary Attack
	if(self.button3)
	{
		fpWeapon = self.enCurrentWeaponEntity.fpWeaponEntity_SecondaryFireFunction;
		nFiringMode = WEAPON_FIRINGMODE_SECONDARY;
	}
	
	if ( !W_CheckNoAmmo(nFiringMode) )
		return;
		
	if(fpWeapon)
	{ // Invoke Weapon Function
		makevectors(self.v_angle);			// calculate forward angle for velocity
		fpWeapon();
		
		// Check for Monster Recognition
		if(self.button3 && self.enCurrentWeaponEntity.bWeaponEntity_SecondaryWakesMonsters)
			bAttackWakesMonsters = TRUE;
		else
		if(self.button0 && self.enCurrentWeaponEntity.bWeaponEntity_PrimaryWakesMonsters)
			bAttackWakesMonsters = TRUE;
		else
			bAttackWakesMonsters = FALSE;
		if(bAttackWakesMonsters)
			self.show_hostile = time + 1;
			
		// Use Quad Damage Sound
		SuperDamageSound();
	}
}

/*
============
W_ChangeWeapon

============
*/
void W_ChangeWeapon()
{
	// DRESK
	// Added ability to switch to gun, even if no ammo is had
	local	float	it, fl;
	
	it = self.nCSQCStat_Weapons;
	
	if (self.impulse == 1)
	{
		// DRESK - HIPNOTIC SUPPORT
		if(g_bHipnoticEnabled && self.weapon == WEAPON_AXE)
			fl = WEAPON_MJOLNIR;
		else
			fl = WEAPON_AXE;
	}
	else if (self.impulse == 2)
	{
		if(
			( GetWeaponIsAvailable(WEAPON_LASER_GUN) && self.weapon == WEAPON_SHOTGUN)
			|| ( GetWeaponIsAvailable(WEAPON_LASER_GUN) && !(self.nCSQCStat_Weapons & WEAPON_SHOTGUN) )
			)
			fl = WEAPON_LASER_GUN;
		else
			fl = WEAPON_SHOTGUN;
	}
	else if (self.impulse == 3)
	{
		fl = WEAPON_SUPER_SHOTGUN;
	}		
	else if (self.impulse == 4)
	{
		if(
			( GetWeaponIsAvailable(WEAPON_FLECHETTE_CANNON) && self.weapon == WEAPON_NAILGUN)
			|| ( GetWeaponIsAvailable(WEAPON_FLECHETTE_CANNON) && !(self.nCSQCStat_Weapons & WEAPON_NAILGUN) )
			)
			fl = WEAPON_FLECHETTE_CANNON;
		else
			fl = WEAPON_NAILGUN;
	}
	else if (self.impulse == 5)
	{
		if(
			( GetWeaponIsAvailable(WEAPON_CHAIN_GUN) && self.weapon == WEAPON_SUPER_NAILGUN)
			|| ( GetWeaponIsAvailable(WEAPON_CHAIN_GUN) && !(self.nCSQCStat_Weapons & WEAPON_SUPER_NAILGUN) )
			)
			fl = WEAPON_CHAIN_GUN;
		else
			fl = WEAPON_SUPER_NAILGUN;
	}
	else if (self.impulse == 6)
	{
		// DRESK - HIPNOTIC SUPPORT
		if(
			( GetWeaponIsAvailable(WEAPON_PROXIMITY_GUN) && self.weapon == WEAPON_GRENADE_LAUNCHER)
			|| ( GetWeaponIsAvailable(WEAPON_PROXIMITY_GUN) && !(self.nCSQCStat_Weapons & WEAPON_GRENADE_LAUNCHER) )
			)
			fl = WEAPON_PROXIMITY_GUN;
		else
			fl = WEAPON_GRENADE_LAUNCHER;
	}
	else if (self.impulse == 7)
	{
		fl = WEAPON_ROCKET_LAUNCHER;
	}
	else if (self.impulse == 8)
	{
		fl = WEAPON_LIGHTNING;
	}
	// **********************************************
	// DRESK - HIPNOTIC SUPPORT
	else if (self.impulse == 9)
	{
		fl = WEAPON_LASER_CANNON;
	}
	// DRESK - END HIPNOTIC SUPPORT
	// **********************************************

	self.impulse = 0;
	
	if (!(self.nCSQCStat_Weapons & fl))
	{	// don't have the weapon or the ammo
		sprint(self, strcat("You do not have the ^2", SG_GetWeaponNameFromID(fl), "\n") );
		return;
	}
	
	/*if (am)
	{	// don't have the ammo
		sprint(self, strcat("You do not have enough ammo for the ^2", SG_GetWeaponNameFromID(fl), "\n") );
		return;
	}*/

//
// set weapon, set ammo
//
	self.weapon = fl;
	UpdateCurrentWeaponEntity(self);
	W_SetCurrentAmmo (FALSE);
}

/*
============
CheatCommand
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void CheatCommand()
{
	// DRESK
	local float nCheatType;
	// Support sv_cheats
	// if (deathmatch || coop)
	if(cvar("sv_cheats") == 0)
		return;

	// Assign Max Ammunition
	self.ammo_rockets = cvar(CVAR_AMMO_MAXROCKETS);
	self.ammo_nails = cvar(CVAR_AMMO_MAXNAILS);
	self.ammo_shells = cvar(CVAR_AMMO_MAXSHELLS);
	self.ammo_cells = cvar(CVAR_AMMO_MAXCELLS);
	
	// Give All Weapons
	self.nCSQCStat_Weapons = self.nCSQCStat_Weapons | g_nAllWeapons;
	// Give All Keys
	// self.nCSQCStat_Keys = self.nCSQCStat_Keys | KEY_SILVER | KEY_GOLD;
	
	// DRESK
	// Check for Shared Ammo Cheat
	if(g_bCoopSharedAmmo)
	{ // Shared Ammo Cheat Used
		// Assign Max Coop Shared Ammo Levels
		UpdateAllSharedAmmo(COOPSHAREDAMMO_AMMOMAX_SHELLS, COOPSHAREDAMMO_AMMOMAX_NAILS, COOPSHAREDAMMO_AMMOMAX_ROCKETS, COOPSHAREDAMMO_AMMOMAX_CELLS);
		// Assign Shared Weapons
		UpdatePlayerSharedWeaponsPool();
		
		nCheatType = HELP_CHEAT_ALLAMMOWEAPONSKEYSSHARED;
	}
	else
		nCheatType = HELP_CHEAT_ALLAMMOWEAPONSKEYS;
	
	self.impulse = 0;
	
	// DRESK
	// Support Floating Keys
	CheckFloatingKeys(self);
	
	// DRESK
	// Report Cheat
	BroadcastClientCheat(self, nCheatType, "");
}

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void CycleWeaponCommand()
{
	local	float	it, am;
	
	it = self.nCSQCStat_Weapons;
	self.impulse = 0;
	
	while (1)
	{
		am = 0;

		// DRESK - HIPNOTIC SUPPORT
		if(self.weapon == WEAPON_MJOLNIR)
		{
			self.weapon = WEAPON_AXE;
		}
		else if (self.weapon == WEAPON_LIGHTNING)
		{
			// DRESK - HIPNOTIC SUPPORT
			if( GetWeaponIsAvailable(WEAPON_LASER_CANNON) )
			{
				self.weapon = WEAPON_LASER_CANNON;
				if (self.ammo_cells < 1)
					am = 1;
			}
			else
				self.weapon = WEAPON_AXE;
		}
		// DRESK - HIPNOTIC SUPPORT
		else if (self.weapon == WEAPON_LASER_CANNON)
		{
			self.weapon = WEAPON_MJOLNIR;
		}
		else if (self.weapon == WEAPON_AXE)
		{
			self.weapon = WEAPON_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_SHOTGUN)
		{
			if( GetWeaponIsAvailable(WEAPON_LASER_GUN) )
			{
				self.weapon = WEAPON_LASER_GUN;
				if(self.ammo_cells < 1)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_SUPER_SHOTGUN;
				if (self.ammo_shells < 2)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_LASER_GUN)
		{
			self.weapon = WEAPON_SUPER_SHOTGUN;
				if (self.ammo_shells < 2)
					am = 1;
		}
		else if (self.weapon == WEAPON_SUPER_SHOTGUN)
		{
			self.weapon = WEAPON_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_NAILGUN)
		{
			if( GetWeaponIsAvailable(WEAPON_FLECHETTE_CANNON) )
			{
				self.weapon = WEAPON_FLECHETTE_CANNON;
				if(self.ammo_nails < 15)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_SUPER_NAILGUN;
				if (self.ammo_nails < 2)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_FLECHETTE_CANNON)
		{
			self.weapon = WEAPON_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == WEAPON_SUPER_NAILGUN)
		{
			if( GetWeaponIsAvailable(WEAPON_CHAIN_GUN) )
			{
				self.weapon = WEAPON_CHAIN_GUN;
				if(self.ammo_nails < 1)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_GRENADE_LAUNCHER;
				if (self.ammo_rockets < 1)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_CHAIN_GUN)
		{
			self.weapon = WEAPON_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_GRENADE_LAUNCHER)
		{
			// DRESK - HIPNOTIC SUPPORT
			if( GetWeaponIsAvailable(WEAPON_PROXIMITY_GUN) )
				self.weapon = WEAPON_PROXIMITY_GUN;
			else
				self.weapon = WEAPON_ROCKET_LAUNCHER;
				
			if (self.ammo_rockets < 1)
				am = 1;
		}
		// DRESK - HIPNOTIC SUPPORT
		else if (self.weapon == WEAPON_PROXIMITY_GUN)
		{
			self.weapon = WEAPON_ROCKET_LAUNCHER;
				
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_ROCKET_LAUNCHER)
		{
			self.weapon = WEAPON_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			UpdateCurrentWeaponEntity(self);
			W_SetCurrentAmmo (FALSE);
			return;
		}
	}
}

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void CycleWeaponReverseCommand()
{
	local	float	it, am;
	
	it = self.nCSQCStat_Weapons;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		// **********************************************
		// DRESK - HIPNOTIC SUPPORT
		if(self.weapon == WEAPON_MJOLNIR)
		{
			self.weapon = WEAPON_LASER_CANNON;
			if (self.ammo_cells < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_LASER_CANNON)
		{
			self.weapon = WEAPON_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
		// DRESK - END HIPNOTIC SUPPORT
		// **********************************************
		else if (self.weapon == WEAPON_LIGHTNING)
		{
			self.weapon = WEAPON_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_ROCKET_LAUNCHER)
		{
			// DRESK - HIPNOTIC SUPPORT
			if( GetWeaponIsAvailable(WEAPON_PROXIMITY_GUN) )
				self.weapon = WEAPON_PROXIMITY_GUN;
			else
				self.weapon = WEAPON_GRENADE_LAUNCHER;
			
			if (self.ammo_rockets < 1)
				am = 1;
		}
		// DRESK - HIPNOTIC SUPPORT
		else if (self.weapon == WEAPON_PROXIMITY_GUN)
		{
			self.weapon = WEAPON_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_GRENADE_LAUNCHER)
		{
			if( GetWeaponIsAvailable(WEAPON_CHAIN_GUN) )
			{
				self.weapon = WEAPON_CHAIN_GUN;
				if (self.ammo_nails < 1)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_SUPER_NAILGUN;
				if (self.ammo_nails < 2)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_CHAIN_GUN)
		{
			self.weapon = WEAPON_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == WEAPON_SUPER_NAILGUN)
		{
			if( GetWeaponIsAvailable(WEAPON_FLECHETTE_CANNON) )
			{
				self.weapon = WEAPON_FLECHETTE_CANNON;
				if (self.ammo_nails < 15)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_NAILGUN;
				if (self.ammo_nails < 1)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_FLECHETTE_CANNON)
		{
			self.weapon = WEAPON_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == WEAPON_NAILGUN)
		{
			self.weapon = WEAPON_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}		
		else if (self.weapon == WEAPON_SUPER_SHOTGUN)
		{
			if( GetWeaponIsAvailable(WEAPON_LASER_GUN) )
			{
				self.weapon = WEAPON_LASER_GUN;
				if (self.ammo_cells < 1)
					am = 1;
			}
			else
			{
				self.weapon = WEAPON_SHOTGUN;
				if (self.ammo_shells < 1)
					am = 1;
			}
		}
		else if (self.weapon == WEAPON_LASER_GUN)
		{
			self.weapon = WEAPON_SHOTGUN;
				if (self.ammo_shells < 1)
					am = 1;
		}
		else if (self.weapon == WEAPON_SHOTGUN)
		{
			self.weapon = WEAPON_AXE;
		}
		else if (self.weapon == WEAPON_AXE)
		{
			// DRESK - HIPNOTIC SUPPORT
			if( GetWeaponIsAvailable(WEAPON_MJOLNIR) )
				self.weapon = WEAPON_MJOLNIR;
			else
			{
				self.weapon = WEAPON_LIGHTNING;
				
				if (self.ammo_cells < 1)
					am = 1;
			}
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			UpdateCurrentWeaponEntity(self);
			W_SetCurrentAmmo (FALSE);
			return;
		}
	}

}
void QuadCheat()
{
	if(cvar("sv_cheats") == 0)
		return;
	// DRESK
	// Spawn Quad Damage Item at Location
	local entity enOldSelf;
		enOldSelf = self;
	self = spawn();
	// Assign Dropped Item
	self.bIsDroppedItem = TRUE;
	
	// Invoke Item Routine
	self.classname = "item_artifact_super_damage";
	item_artifact_super_damage();
	// Toss Item
	TossItem(enOldSelf, self);
	// Restore Self
	self = enOldSelf;
	
	// DRESK
	// Report Cheat
	BroadcastClientCheat(self, HELP_CHEAT_QUADDAMAGE, "");
}
void AllPowerupsCheat()
{
	if(cvar("sv_cheats") == 0)
		return;
		
	// Spawn Powerups at Location
	DropNewPowerup(POWERUPTYPE_ENVIROSUIT, 0);
	DropNewPowerup(POWERUPTYPE_INVULNERABILITY, 0);
	DropNewPowerup(POWERUPTYPE_INVISIBILITY, 0);
	DropNewPowerup(POWERUPTYPE_QUADDAMAGE, 0);
	DropNewPowerup(POWERUPTYPE_EMPATHYSHIELDS, 0);
	
	// DRESK
	// Report Cheat
	BroadcastClientCheat(self, HELP_CHEAT_GIVEALLPOWERUPS, "");
}
/*
============
ImpulseCommands

============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void ImpulseCommands(float bNoWeapons)
{
	// DRESK
	local float bParsedImpulse;
		bParsedImpulse = TRUE;
	// Support Cooperative Teleport System
	// Acquire Teleport Impulse
	local float fContinue;
	if(self.nPersonalTeleporter_NumTeleportTargets && self.impulse != 0)
		// Viewing Teleport System
		fContinue = !PersonalTeleport_ParseTeleportImpulse();
	else
		fContinue = TRUE;
		
	if(fContinue)
	{ // Standard Impulse System
		// DRESK
		// Support Advanced Impulses
		if(self.impulse == 102)
			// Help - Map Info
			Help_DisplayMapInfo(self);
		else
		if(self.impulse == KLESHIK_IMPULSE_SERVER_PERSONALTELEPORTER && !deathmatch)
			// Valid Teleport Impulse
			PreparePersonalTeleporter();
		else
		if(self.impulse == KLESHIK_IMPULSE_SERVER_TOGGLEFLASHLIGHT)
			// Valid Flash Light Impulse
			ToggleFlashLight(FLASHLIGHT_TYPE_NONE);
		else
		if(self.impulse == KLESHIK_IMPULSE_SERVER_THROWFLARE)
			ThrowFlare();
		else
		if (self.impulse >= 1 && self.impulse <= 9 && !bNoWeapons)
			W_ChangeWeapon ();
		else
		// DRESK
		// Modified Impulses for Cheating
		if(self.impulse == CHEATIMPULSE_GIVEALL)
			CheatCommand ();
		else
		if (self.impulse == 10 && !bNoWeapons)
			CycleWeaponCommand ();
		else
		if (self.impulse == 12 && !bNoWeapons)
			CycleWeaponReverseCommand ();
		else
		if( self.impulse == CHEATIMPULSE_GIVEALLPOWERUPS)
			AllPowerupsCheat();
		else
		if (self.impulse == CHEATIMPULSE_QUADDAMAGE)
			QuadCheat ();
		else
			bParsedImpulse = FALSE;
	}
		
	// DRESK
	// Support Deferred Weapon Impulses
	if( !(!bParsedImpulse && bNoWeapons) )
		self.impulse = 0;
}

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
void W_WeaponFrame()
{		
	// DRESK
	// Only allow ALIVE Clients
	if(self.deadflag)
		return;
		
	// DRESK
	// Check for Flare Available
	if(!self.nCSQCStat_FlareAvailable && time > self.tThrowableFlareRefireTime)
		self.nCSQCStat_FlareAvailable = TRUE;
		
	// DRESK
	// Support NoWeapon Impulse Commands
	local float bNoWeapon;
	if (time < self.attack_finished)
	{ // Attacking
		bNoWeapon = TRUE;
	}
	else
	{ // Available to Attack / Not Attacking
		bNoWeapon = FALSE;
		if(! (self.button0 || self.button3) )
		{ // Not Attacking
			// Reset Initially Fired
			self.bWeaponInitiallyFired = FALSE;
			// Signal Weapon State Function
			if(self.enViewWeapon.fpWeaponAnimationController_StateFunction)
			{ // State Function Exists; Signal
				local entity enOldSelf;
					enOldSelf = self;
				self = enOldSelf.enViewWeapon;
					self.fpWeaponAnimationController_StateFunction(WEAPONSTATE_STOPPEDFIRING);
				self = enOldSelf;
			}
		}
	}

	if(self.impulse)
		ImpulseCommands(bNoWeapon);
	
	// check for attack
	if ( (self.button3 || self.button0) && (!bNoWeapon) )
		W_Attack();
		
	// DRESK
	// Consistently Update Attack Finished
	if (self.attack_finished < (time) )
		self.attack_finished = time;
}

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void SuperDamageSound()
{
	if (self.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_AUTO, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
}


