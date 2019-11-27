// DRESK
// Kleshik Weapons

// Definitions

// Fields
float	g_bKleshikWeaponsEnabled;
.float	nSniperCasingNumTouches;
.float	tSniperCasingSoundDelay;
.float	nSniperBulletNumTargetsHit;

.float	bIsFlechetteRound;
.float	nFlechetteMaxBounces;
.float	nFlechetteBounceCnt;

// Prototypes

// Functions
void W_FireScitheGun()
{
	local vector	vDirection;
	local entity	enMissile;
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
		
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(nBeginWeaponFrame, nBeginWeaponFrame, WEAPONANIMSPEED_NAILGUNS, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_NAILGUN, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin + v_right*ox, v_forward);
	
	PlayerAnim_Attack_Nailgun(PLAYERANIM_ANIMSPEED_NAILGUN);
	
	vDirection = v_forward;
	enMissile = launch_spike(vCurrentShotOrigin + v_right*ox, vDirection);
	
	// DRESK
	// Speed up Normal Nails
	enMissile.velocity = enMissile.velocity * 1.8;
	
	// DRESK
	// Use nGibType for Detailed Nail Touch
	enMissile.nGibType = 1;
}
void W_FireChainGun()
{
	// DRESK
	WEAPON_BEGININITIALFIREEVENTS
		WeaponEvents_WeaponAnim(1, 8, WEAPONANIMSPEED_CHAINGUN, WeaponStateFunction_RepeatAnimation);
		// Reset ChainGun Bullets Fired
		self.nChainGun_BulletsFired = 0;
	WEAPON_ENDINITIALFIREEVENTS
	
	// Weapon PreFire Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_SetupOriginAndDirection('8 -2 0');
	PlayerAnim_Attack_Nailgun(PLAYERANIM_ANIMSPEED_NAILGUN);
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_CHAIN_GUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	local vector vDirection;
		vDirection = v_forward;
	FireBullets (DAMAGETYPE_WEAPON_CHAINGUN, WEAPON_CHAINGUN_BULLETDAMAGE, 1, vDirection, WEAPON_CHAIN_GUN_SPREAD);
}
void SniperCasingTouch()
{
	if(other.solid == SOLID_BSP)
	{ // Touched World
		self.nSniperCasingNumTouches = self.nSniperCasingNumTouches + 1;
		local string strSound;
		local float nRandom;
		
		if(time > self.tSniperCasingSoundDelay)
		{ // Play Sound
			nRandom = random();
			if(nRandom < 0.33)
				strSound = SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT1;
			else
			if(nRandom < 0.66)
				strSound = SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT2;
			else
				strSound = SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT3;
				
			// Play Sound
			sound(self, CHAN_AUTO, strSound , 1, ATTN_NORM);
			
			// Increase Sound Delay
			self.tSniperCasingSoundDelay = time + 0.5;
		}
			
		// Prepare Quick Remove
		if(self.nSniperCasingNumTouches == 1)
		{ // First Touch; Remove
			self.think = SUB_Remove;
			self.nextthink = time + 1.5;
		}
	}
}
void SniperBulletThink()
{ // Sniper Bullet Think
	local float bHitBleeder;
	local float tRemoveTime;
	local string strSound;
	local float nRandom;
		strSound = "";
	// Makevectors
	makevectors(self.angles);
	// Shift Projectile Forward
	traceline(self.origin, self.origin + self.velocity * frametime, FALSE, self);
	
	// Check for Water Sound
	if(trace_inopen && trace_inwater)
	{ // Crossed Water
		if( random() < 0.5)
			strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTWATER1;
		else
			strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTWATER2;
		sound(self, CHAN_AUTO, strSound , 1, ATTN_NORM);
	}
	
	// ************************************************************************************************
	// BEGIN ENTITY CHECK
	if(trace_ent)
	{ // Hit Entity
		// Determine Sound
		if(trace_ent.solid == SOLID_BSP || trace_ent.bBleedsSparks)
		{ // Solid Hit
			nRandom = random();
			if(nRandom < 0.33)
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID1;
			else
			if(nRandom < 0.66)
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID2;
			else
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID3;
		}
		else
		{ // Flesh Hit
			nRandom = random();
			if(nRandom < 0.33)
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH1;
			else
			if(nRandom < 0.66)
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH2;
			else
				strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH3;
			bHitBleeder = TRUE;
		}
		
		if(trace_ent.takedamage)
		{ // Perform Damage to Target
			if(trace_ent.bIsEliteMonster)
			{ // Elite Monster!
				EliteMonsterRedirectProjectile(trace_ent, self);
				// Reverse Direction
				self.velocity = self.velocity * -1;
				// Update Angles
				self.angles = vectoangles(self.velocity);
				
				// Reverse Bullet
				self.nextthink = time;
				return;
			}
			// Increment Number of Targets Hit
			self.nSniperBulletNumTargetsHit = self.nSniperBulletNumTargetsHit + 1;
			// Assign to Trace Ent as well if Player
			if(trace_ent.flags & FL_CLIENT)
				trace_ent.nSniperBulletNumTargetsHit = self.nSniperBulletNumTargetsHit;
			// Backup Trace Entity
			local entity enHit;
				enHit = trace_ent;
			// Produce Damage
			T_Damage_Direction(enHit, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_SNIPERRIFLE, 180, TRUE, normalize(self.velocity) );
			
			if(bHitBleeder)
			{ // Color Bullet Red
				self.colormod = '1 0.6 0.6';
			}
			
			// Play Determined Sound
			sound(self, CHAN_AUTO, strSound , 1, ATTN_NORM);
		
			// Check for Dead Target
			if(!enHit.bIsCorpse)
			{ // Target Survived; Bounce
				// Shift into Target
				setorigin(self, trace_endpos);
				self.movetype = MOVETYPE_BOUNCE;
				self.avelocity_x = random() * 3500;
				self.avelocity_y = random() * 3500;
				self.avelocity_z = random() * 3500;
				self.velocity = self.velocity * ( random() * 0.2) * -1;
				self.velocity_x = self.velocity_x * ( random() * 1);
				self.velocity_y = self.velocity_y * ( random() * 1);
				tRemoveTime = 2.0;
			}
			else
			{ // Target Dead
				// Recurse Function Call to Trace Again
				// SniperBulletThink();
				// NOTE: Changed to think function for performance reasons
				self.nextthink = time;
				return;
			}
		}
		else
		{ // Hit Non-Damageable World Element
			// Shift into Target
			setorigin(self, trace_endpos);
			self.movetype = MOVETYPE_BOUNCE;
			self.avelocity_x = random() * 3500;
			self.avelocity_y = random() * 3500;
			self.avelocity_z = random() * 3500;
			self.velocity = self.velocity * ( random() * 0.2) * -1;
			self.velocity_x = self.velocity_x * ( random() * 1);
			self.velocity_y = self.velocity_y * ( random() * 1);
			tRemoveTime = 2.0;
		}
	}
	// END ENTITY CHECK
	// ************************************************************************************************
	else
	if(trace_fraction != 1)
	{ // Hit Something, Not Entity, So World
		nRandom = random();
		if(nRandom < 0.33)
			strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID1;
		else
		if(nRandom < 0.66)
			strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID2;
		else
			strSound = SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID3;
		
		// Shift into Wall
		setorigin(self, trace_endpos - (v_forward * 5.5) );
		tRemoveTime = 10.0;
		
		// Produce Sparks
		te_spark(self.origin, v_forward * -126, 100);
	}
	else
	{ // Hit Nothing
		// Check for Sky
		if( pointcontents(self.origin) == -2)
		{ // Hit Sky
			// Remove Now
			tRemoveTime = time;
		}
		else
			// Update Origin
			setorigin(self, trace_endpos);
	}
		
	// Play Potential Sound
	if(strSound != "")
		sound(self, CHAN_AUTO, strSound , 1, ATTN_NORM);
	
	if(tRemoveTime)
	{ // Time to Remove
		self.think = SUB_Remove;
		self.nextthink = time + tRemoveTime;
	}
	else
	{ // Reset Think Time
		self.nextthink = time;
	}
}
void W_FireSniperRifle()
{
	if(self.ammo_shells < 18)
	{ // Not Enough Ammo
		// Play Dry Fire Sound
		WeaponEvents_DryFireSound(SOUND_KLESHIK_WEAPONS_GENERICDRYFIRE);
		return;
	}
		
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SHOTGUN, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	local entity enBullet;
	enBullet = spawn();
	setmodel(enBullet, "progs/s_spike.mdl");
	setsize(enBullet, VEC_ORIGIN, VEC_ORIGIN);
	enBullet.owner = self;
	enBullet.modelflags = MF_GRENADE;
	enBullet.effects = EF_FULLBRIGHT;
	enBullet.scale = 1.6;
	setorigin(enBullet, vCurrentShotOrigin);
	
	enBullet.movetype = MOVETYPE_NONE;
	enBullet.solid = SOLID_NOT;
	enBullet.think = SniperBulletThink;
	// Delay Nextthink Slightly for Proper Client Interpolation
	enBullet.nextthink = time + 0.05;
	// enBullet.nextthink = time;
	enBullet.velocity = v_forward * 7000;
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
}
void LaserGunTouch()
{
	local vector org;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	// org = self.origin - 8 * normalize(self.velocity);
	org = self.origin - 4 * normalize(self.velocity);

	if (other.takedamage)
	{
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_LASERGUN, 45);
	}
	
	te_SimpleLaserTouch(org);
	
	remove(self);
}
void LaserGunMissile_Think()
{
	self.glow_color = 31;
	self.glow_trail = TRUE;
	
	// Drunk Missile
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_DrunkMissile(self, 25, 200);
}
void W_FireLaserGun()
{
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 2 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_LASER_GUN, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	local entity enMissile;
	
	enMissile = spawn();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLY;
	enMissile.solid = SOLID_BBOX;
	
	enMissile.effects = EF_FULLBRIGHT | EF_NOSHADOW;
	enMissile.colormod = '0.5 1 0.5';
	
	enMissile.think = LaserGunMissile_Think;
	enMissile.nextthink = time + 0.08;
	
	// Assign Silent Contents Transition
	enMissile.contentstransition = SilentContentsTransition;

	setmodel (enMissile, "progs/laser.mdl");
	setsize (enMissile, '0 0 0', '0 0 0');

	setorigin (enMissile, vCurrentShotOrigin);

	enMissile.velocity = v_forward * 1600;
	enMissile.angles = vectoangles(enMissile.velocity);

	enMissile.touch = LaserGunTouch;
}
void LaserGunAltTouch()
{
	local vector org;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	// Support Elite Monsters
	if(other.bIsEliteMonster)
	{ // Elite Monster; Redirect to Missile Owner
		EliteMonsterRedirectProjectile(other, self);
	}
	else
	{
		org = self.origin - 8 * normalize(self.velocity);
		
		T_RadiusDamage (self, self.owner, DAMAGETYPE_WEAPON_LASERGUN_ALTERNATE, 85, world);
		te_LaserGunAltTouch(org);
		remove(self);
	}
}
void LaserGunAltMissile_Think()
{
	self.glow_color = 70;
	self.glow_trail = TRUE;
	
	// Drunk Missile
	if(g_bGyroPhysicsEnabled)
		Gyro_ObjectMacro_DrunkMissile(self, 10, 200);
}
void W_FireAltLaserGun()
{
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 2 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_LASER_GUN, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	local entity enMissile;
	
	enMissile = spawn();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_FLYMISSILE;
	enMissile.solid = SOLID_BBOX;
	
	enMissile.effects = EF_FULLBRIGHT | EF_NOSHADOW;
	enMissile.colormod = '1 0 0';
	
	enMissile.think = LaserGunAltMissile_Think;
	enMissile.nextthink = time + 0.08;
	enMissile.scale = 2.5;
	
	// Assign Silent Contents Transition
	enMissile.contentstransition = SilentContentsTransition;

	setmodel (enMissile, "progs/laser.mdl");
	setsize (enMissile, '0 0 0', '0 0 0');

	setorigin (enMissile, vCurrentShotOrigin);

	enMissile.velocity = v_forward * 3000;
	enMissile.angles = vectoangles(enMissile.velocity);

	enMissile.touch = LaserGunAltTouch;
}
void FlechetteTouch()
{
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	// Calculate Velocity Vector Length
	local float fVelocity;
		fVelocity = vlen(self.velocity);
	if(fVelocity < 400)
	{
		remove(self);
		return;
	}

	if(!other.bIsFlechetteRound && other != self.owner)
	{ // Not Touching Another Flechette / Owner
		if(other.takedamage)
		{ // Other Receives Damage
			// Restore Real Owner
			RestoreOwnerTouchableProjectileOwner(self);
			
			T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_WEAPON_FLECHETTECANNON, 10);
			remove(self);
		}
		else
		{ // Touched Other
			self.nFlechetteBounceCnt = self.nFlechetteBounceCnt + 1;
			if(self.nFlechetteBounceCnt > self.nFlechetteMaxBounces)
			{
				te_FlareBounce(self.origin);
				remove(self);
			}
			else
			{
				if( random() < 0.2)
					te_FlareBounce(self.origin);
			}
		}
	}
}
void LaunchFlechette(float nMaxBounces, float fMinVelocity)
{
	local entity enMissile;
	
	enMissile = spawn();
	enMissile.owner = self;
	enMissile.movetype = MOVETYPE_BOUNCE;
	enMissile.solid = SOLID_BBOX;
	enMissile.bIsFlechetteRound = TRUE;
	
	enMissile.effects = EF_FULLBRIGHT | EF_NOSHADOW;
	
	// Assign Silent Contents Transition
	enMissile.contentstransition = SilentContentsTransition;
	
	// Assign Max Bounces
	enMissile.nFlechetteMaxBounces = nMaxBounces;
	
	if( random() < 0.5)
		setmodel(enMissile, "progs/spike.mdl");
	else
		setmodel(enMissile, "progs/s_spike.mdl");
	setsize(enMissile, '0 0 0', '0 0 0');
	enMissile.modelflags = MF_TRACER2;
	enMissile.gravity = 0.5;
		
	setorigin(enMissile, vCurrentShotOrigin);
	
	enMissile.velocity = (v_forward + (randomvec() * 0.15) ) * (fMinVelocity + random() * 200);
	enMissile.angles = vectoangles(enMissile.velocity);
	
	enMissile.touch = FlechetteTouch;
	PrepareOwnerTouchableProjectile(enMissile, SUB_Remove, 4);
	// enMissile.nextthink = time + 3;
	// enMissile.think = SUB_Remove;
}
void W_FireFlechetteCannon()
{
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_PRIMARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_FLECHETTE_CANNON, WEAPON_FIRINGMODE_PRIMARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	local float nCnt;
	for(nCnt = 0; nCnt < 20; nCnt++)
		LaunchFlechette(4, 1800);
}
void W_FireAltFlechetteCannon()
{
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_FLECHETTE_CANNON, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	local float nCnt;
	for(nCnt = 0; nCnt < 20; nCnt++)
		LaunchFlechette(6, 600);
}
void W_FireScatterShot()
{ // Fire Scatter Shot
	local vector dir;
	// DRESK
	// Weapon Events
	WeaponEvents_Main(WEAPON_FIRINGMODE_SECONDARY, WEAPON_MUZZLEFLASH_TRUE);
	WeaponEvents_WeaponAnim(1, 6, WEAPONANIMSPEED_STANDARD, __NULL__);
	WeaponEvents_SetupOriginAndDirection('8 0 0');
	WeaponCSQCTemporaryEntity(etof(self), WEAPON_SUPER_SHOTGUN, WEAPON_FIRINGMODE_SECONDARY, WEAPON_EXTENDEDDATA_NONE, vCurrentShotOrigin, v_forward);
	
	PlayerAnim_Attack_Shotgun(PLAYERANIM_ANIMSPEED_STANDARD);
	
	// Remove Aiming
	// dir = aim (self, 100000);
	dir = v_forward;
	
	FireBullets (DAMAGETYPE_WEAPON_SCATTERSHOT, WEAPON_FIREBULLETS_STANDARD_DAMAGE, WEAPON_SUPER_SHOTGUN_NUMBULLETS * 3.5, dir, WEAPON_SUPER_SHOTGUN_SPREAD * 3.2);
}

void PrecacheKleshikWeaponsData()
{ // Precache Kleshik Weapons Data
	// Sniper Rifle
	precache_sound(SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT1);
	precache_sound(SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT2);
	precache_sound(SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT3);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH1);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH2);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTFLESH3);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID1);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID2);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTSOLID3);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTWATER1);
	precache_sound(SOUND_KLESHIK_WEAPONS_SNIPERRIFLE_IMPACTWATER2);
	
	// Laser Gun
	precache_model("progs/laser.mdl");
	
	// Scatter Shot
}