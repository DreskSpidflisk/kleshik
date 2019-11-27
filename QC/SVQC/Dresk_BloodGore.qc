// DRESK
// Blood / Gore Support

// Definitions
#define GIBTYPE_NONE									0
#define GIBTYPE_GIB										1
#define GIBTYPE_GIBBEDHEAD								2

#define GIBBEDHEADTYPE_SPECIFIC							0
#define GIBBEDHEADTYPE_GENERICFLESH						1
#define GIBBEDHEADTYPE_GENERICROBOT						2

#define GORE_THROWSTANDARDGIBS							ThrowGib ("progs/gib1.mdl", self.health);ThrowGib ("progs/gib2.mdl", self.health);ThrowGib ("progs/gib3.mdl", self.health)

#define GORE_STANDARDFLYINGMONSTERDEATHVELOCITY			self.velocity_x = -200 + 600*random();self.velocity_y = -200 + 600*random();self.velocity_z = 100 + 150*random()

// Fields
.float	tLastDamageFeedbackTime;

.float	bIgnoreDirectionalGibs;

.float	tGibbedHeadKickDelayTime;

.float	tGibbedHeadBecomeTime;

.void()	fpGibAngleVelocityFunc;

// Functions
void	s_explode1()		[0,		s_explode2] {};
void	s_explode2()		[1,		s_explode3] {};
void	s_explode3()		[2,		s_explode4] {};
void	s_explode4()		[3,		s_explode5] {};
void	s_explode5()		[4,		s_explode6] {};
void	s_explode6()		[5,		SUB_Remove] {};

// Prototypes
void MonsterHitGround(vector vImpactVelocity);

void BecomeExplosion()
{
	// DRESK
	// Suppress Crappy Sprite
	remove(self);
	/*
	// Remove Damageability
	self.takedamage = DAMAGE_NO;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = __NULL__;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
	*/
}
void CheckGibsOnDeath(entity enEntity)
{ // Check Gibs on Death
	local float fMaxGibs;
		fMaxGibs = rint(random() * cvar(CVAR_BLOODGORE_MAXIMUMGIBSONDEATH) );
		
	if(fMaxGibs && !enEntity.bBleedsSparks)
	{ // Valid Gibs
		// DEBUG
		/*
		local string strDebug;
		strDebug = strcat("Tossing ^2", ftos(fMaxGibs), "^7 Gibs\n");
		bprint(strDebug);
		*/
		
		local float fGibType;
		local string strGib;
		local float fCnt;
			fCnt = 0;
			
		self.bIgnoreDirectionalGibs = TRUE;
		while(fCnt < fMaxGibs)
		{ // Spawn Gib
			fGibType = rint(random() * 3);
			
			// DEBUG
			/*
			strDebug = strcat("Random Gib : ^2", ftos(fGibType), "^7\n");
			bprint(strDebug);
			*/
			
			if(fGibType == 1)
				strGib = "progs/gib1.mdl";
			else
			if(fGibType == 2)
				strGib = "progs/gib2.mdl";
			else
				strGib = "progs/gib3.mdl";
				
			// Throw Gib
			ThrowGib(strGib, self.health);
			
			// Increment Counter
			fCnt++;
		}
		self.bIgnoreDirectionalGibs = FALSE;
	}
}
void CheckBloodShowerDeath(entity enEntity)
{ // Check BloodShower Death
	if(!enEntity.bBleedsSparks)
	{ // Entity does not bleed sparks
		local float fBloodShowerAmount;
			fBloodShowerAmount = cvar(CVAR_BLOODGORE_BLOODSHOWERAMOUNTONDEATH);
		// Check for Blood Shower Death
		if(fBloodShowerAmount)
			te_DamageFeedbackWithImpactType(enEntity.origin, fBloodShowerAmount, IMPACTTYPE_NONE);
	}
}
float GetIsDamageTypeRadiusDamage(float fDamageType)
{ // Return if Damage Type is Radius Damage
	local float bReturn;
	switch(fDamageType)
	{
		case DAMAGETYPE_WEAPON_GRENADELAUNCHER:
		case DAMAGETYPE_WEAPON_ROCKETLAUNCHER:
		case DAMAGETYPE_WEAPON_LIGHTNINGDISCHARGE:
		case DAMAGETYPE_WEAPON_PROXIMITYGRENADE:
		case DAMAGETYPE_WEAPON_MULTIGRENADE:
		case DAMAGETYPE_WEAPON_MULTIROCKET:
		case DAMAGETYPE_WEAPON_PLASMA:
		case DAMAGETYPE_WEAPON_LASERGUN_ALTERNATE:
		case DAMAGETYPE_MISC_RADIUS:
		case DAMAGETYPE_ENVIRONMENT_BARRELEXPLOSION:
		case DAMAGETYPE_TRAP_SPIKEMINE:
		case DAMAGETYPE_MONSTER_SHALRATH_MISSILE:
		case DAMAGETYPE_MONSTER_TARBABY_EXPLOSION:
		case DAMAGETYPE_MONSTER_OGRE_MISSILE:
		case DAMAGETYPE_MONSTER_WIZARD_ALTMISSILE:
		case DAMAGETYPE_MONSTER_WRATH_MISSILE:
		case DAMAGETYPE_MONSTER_WRATH_DEATHEXPLOSION:
		case DAMAGETYPE_MONSTER_BABYDRAGON_MISSILE:
		case DAMAGETYPE_MONSTER_FIREFIEND_MISSILE:
			bReturn = TRUE;
			break;
		default:
			bReturn = FALSE;
			break;
	}
	return bReturn;
}
float CheckDamageTypeForceGib(entity enEntity, float fDamageType)
{ // Check Damagetype Force Gib
	// Returns if entity is to gib.
	
	local float nExplosivesAlwaysGib;
		nExplosivesAlwaysGib = cvar(CVAR_BLOODGORE_EXPLOSIVESALWAYSGIB);
	
	local float fReturn;
		fReturn = FALSE;
		
	if( GetIsDamageTypeRadiusDamage(fDamageType) )
	{ // Explosive Damage
		if(nExplosivesAlwaysGib)
		{ // Gib Time!
			enEntity.health = (enEntity.nGibHealth - 1);
			fReturn = TRUE;
		}
	}
	else
	if(fDamageType == DAMAGETYPE_MISC_TELEFRAG
		|| fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGDISCHARGE
		|| fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGBEAMDISCHARGE
		|| fDamageType == DAMAGETYPE_MISC_NOEXIT
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_PLATFORM_CRUSH
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_TRAIN_CRUSH
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_SECRETBLOCKED
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_DOORBLOCKED
		|| fDamageType == DAMAGETYPE_MONSTER_FLISKER_CORPSEBURST
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_HURTTOUCH
		// HIPNOTIC SUPPORT
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_ROTATINGDOOR_CRUSH
		// ROGUE SUPPORT
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_BUZZSAWTOUCH
		|| fDamageType == DAMAGETYPE_ENVIRONMENT_PENDULUMTOUCH
		|| fDamageType == DAMAGETYPE_MONSTER_DRAGON_SQUISH)
	{ // Other Force Gib
		enEntity.health = (enEntity.nGibHealth - 1);
		fReturn = TRUE;
	}
	else
	if(nExplosivesAlwaysGib >= 2)
		// ONLY Explosives Gib; No other gib conditions met; Ensure No Gib
		// NOTE: Assigning Gib Health + 1, so the next damage to the corpse gibs it
		enEntity.health = enEntity.nGibHealth + 1;
		// self.health = -5;
		
	return fReturn;
}
void CheckExtraDeathAesthetics(entity enEntity, float fDamageType)
{ // Check Extra Death Aesthetics
	if(enEntity.bIsCorpse)
	{ // Entity is a Corpse; Only Check Force Gib
		CheckDamageTypeForceGib(enEntity, fDamageType);
	}
	else
	{ // Entity is Fresh Death
		// Disable Corpse Shadow (for performance)
		enEntity.effects = enEntity.effects | EF_NOSHADOW;
		// Assign Low Precision
		enEntity.effects = enEntity.effects | EF_LOWPRECISION;
		// Remove Potential Fullbright
		enEntity.effects = enEntity.effects - (enEntity.effects & EF_FULLBRIGHT);
		
		// Remove Potential Alpha Setting
		RestoreEntityAlpha(enEntity);
			
		// Check Damagetype Force Gib
		if( !CheckDamageTypeForceGib(enEntity, fDamageType) )
			// Check Gibs
			CheckGibsOnDeath(enEntity);
			
		// Add Impact Sound
		if(enEntity.flags & FL_MONSTER)
			enEntity.movetypesteplandevent = MonsterHitGround;
			
		// Check Bloodshower
		CheckBloodShowerDeath(enEntity);
	}
}
void CheckCreatureBleeding(entity enCreature)
{ // Check Creature Bleeding
	// Acquire Bleeding Percentile
	local float fBleedingPercentile;
		fBleedingPercentile = SG_AUTOCVAR(kleshik_server_BloodGore_BleedAtHealthPercentile);
	if(fBleedingPercentile && enCreature.nEntityHealthAtSpawn)
	{ // Bleeding Enabled
		// Acquire Health Percentile
		local float fHealthPercentile;
			fHealthPercentile = (enCreature.health / enCreature.nEntityHealthAtSpawn) * 100;
			
		if(fHealthPercentile <= fBleedingPercentile)
		{ // Bleed
			// Assign Bleeding
			if(enCreature.bBleedsSparks)
				enCreature.modelflags = enCreature.modelflags | MF_GRENADE;
			else
				enCreature.modelflags = enCreature.modelflags | MF_GIB;
		}
		else
		{ // Not Bleeding
			// Remove Bleeding
			enCreature.modelflags = enCreature.modelflags - (enCreature.modelflags & (MF_GIB | MF_GRENADE) );
		}
	}
}
vector wall_velocity()
{
	local vector	vel;
	
	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	
	return vel;
}
void SpawnMeatSpray(vector org, vector vel)
{
	// DRESK
	// Unused Variable(s)
	// local	entity missile, mpuff;
	local entity missile;
	// DRESK
	// Bad variable
	// local	vector	org;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';
	
	// DRESK
	// Support Low Precision, No Shadow
	missile.effects = EF_LOWPRECISION | EF_NOSHADOW;
	// Assign Godmode
	missile.flags = FL_GODMODE;
	// Assign Blood Dripping
	if( random() > 0.7)
		missile.modelflags = MF_GIB;
	// Utilize Silent Contents Transition
	missile.contentstransition = SilentContentsTransition;
	
	// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
}
void ThrowGib(string gibname, float dm)
{
	local	entity newGib;

	newGib = spawn();
	newGib.origin = self.origin;
	setmodel (newGib, gibname);
	newGib.velocity = VelocityForDamage(dm, self.bIgnoreDirectionalGibs);
	newGib.movetype = MOVETYPE_BOUNCE;
	newGib.avelocity_x = random()*600;
	newGib.avelocity_y = random()*600;
	newGib.avelocity_z = random()*600;
	newGib.ltime = time;
	
	// DRESK
	// Assign Godmode (to prevent T_Damage from killing)
	newGib.flags = FL_GODMODE;
	// Assign Gib Type (normal gib)
	newGib.nGibType = GIBTYPE_GIB;
	// Assign Silent Contents Transition
	newGib.contentstransition = SilentContentsTransition;
	// Assign Blood Dripping
	newGib.modelflags = MF_GIB;
	// Assign Random Scale
	newGib.scale = 0.6 + random();
	
	// DRESK
	// Support Damageable Gibs
	if( cvar(CVAR_BLOODGORE_DAMAGEABLEGIBS) >= 2)
	{ // Damageable Gibs!
		PrepareDamageableGib(newGib);
	}
	else
	{ // Standard
		newGib.solid = SOLID_NOT;
		setsize (newGib, '0 0 0', '0 0 0');
	}
	
	// DRESK
	// Support All Gibs Persistent
	if( (self.classname == "player" && cvar(CVAR_BLOODGORE_ALLGIBSPERSISTENT) >= 2) || (self.classname != "player" && cvar(CVAR_BLOODGORE_ALLGIBSPERSISTENT) ) )
	{ // Persistent Gibs
		// newGib.nextthink = -1;
		newGib.think = __NULL__;
	}
	else
	{ // Standard Gibs
		newGib.nextthink = time + 10 + random()*10;
		newGib.think = SUB_Remove;
	}
	newGib.frame = 0;
	// newGib.flags = 0;
	
	// DRESK
	// Low Precision / No shadow
	newGib.effects = (newGib.effects | EF_LOWPRECISION | EF_NOSHADOW);
}
vector VelocityForDamage(float dm, float bLocalIgnoreDirectionalGibs)
{
	local vector v;
	
	// DRESK
	// Utilize Last Damage Velocity if Present
	// Creates Directional Gibs!
	if( SG_AUTOCVAR(kleshik_server_BloodGore_DirectionalGibs) && !bLocalIgnoreDirectionalGibs)
	{ // Use Directional Gibs
		// DEBUG
			// local string strDebug;
			// strDebug = strcat("v_x : ^2", ftos(self.vLastDamageVelocity_x), "^7, v_y : ^2", ftos(self.vLastDamageVelocity_y), "^7, v_z : ^2", ftos(self.vLastDamageVelocity_z), "\n");
			// bprint(strDebug);
			
		local vector vDirectional;
		
			// Method 1 : Strengthen
			/*
			vDirectional = self.vLastDamageVelocity * (250 + (random() * 750) );
			// Apply Additional Lifting
			vDirectional_z = vDirectional_z * (3 + random() );
			*/
			
			// Method 2 : Normalize
			local vector vDirNormalized;
				vDirNormalized = normalize(self.vLastDamageVelocity);
				
			// bprint( strcat("vDirNormalized : ", vtos(vDirNormalized), "\n") );
			vDirectional = vDirNormalized * (250 + (random() * 200) );
			// Apply Additional Lifting
			vDirectional_z = vDirectional_z + (100 + random() * 200);
			
			// Randomize Slightly
			// vDirectional = vDirectional * (random() * 5);
			/*
			vDirectional_x *= random() * 0.1;
			vDirectional_y *= random() * 0.1;
			vDirectional_z *= random() * 0.1;
			*/
			
			// DEBUG
				// strDebug = strcat("v_x : ^2", ftos(vDirectional_x), "^7, v_y : ^2", ftos(vDirectional_y), "^7, v_z : ^2", ftos(vDirectional_z), "\n");
				// bprint(strDebug);
			
		v = vDirectional;
	}
	else
	{
		/*
		v_x = 100 * crandom();
		v_y = 100 * crandom();
		v_z = 200 + 100 * random();
		*/
		v_x = 250 * SG_crandom();
		v_y = 250 * SG_crandom();
		v_z = 350 + 100 * random();

		if (dm > -50)
		{
//		dprint ("level 1\n");
			v = v * 0.7;
		}
		else if (dm > -200)
		{
//		dprint ("level 3\n");
			v = v * 2;
		}
		else
			v = v * 10;
	}

	return v;
}
void DamageableGib_PreDamageForce()
{ // Pre Damage Force
	// NOTE : Occurs before applying final damage force.
	// Apply Additional Damage Force
	self.fPreDamageForce_Multiplier = 1.5;
	// Apply Lifting Velocity
	self.velocity_z = 250 + (random() * 300);
}
void DamageableGib_PostDamageForce()
{ // Post Damage Force
	// NOTE : Occurs after applying final damage force.
	self.fpGibAngleVelocityFunc();
}
void DamageableGib_Touch()
{ // Touch Procedure
	if(time >= self.tGibbedHeadKickDelayTime)
	{ // Valid Touch
		// Normalize Collision Vector
		local vector vVelocity;
		vVelocity = normalize(other.velocity);
		
		if( (vlen(vVelocity) || vlen( normalize(self.velocity) ) ) && (other.health >= 1) && ( (other.classname == "player") || (other.flags & FL_MONSTER && other.health > 0) ) )
		{ // Valid Collision
			if( vlen(self.velocity) >= 250 && other.classname == "player")
			{ // High-speed Collision with Player
				if( !(other.flags & FL_GODMODE || other.nCSQCStat_Powerups & POWERUP_INVULNERABILITY) )
				{ // Not Invulnerable
					/*
					local string strDebug;
						strDebug = strcat("vlen : ", ftos( vlen(self.velocity) ), "\n");
						bprint(strDebug);
					*/
					// Induce Punchangle
					if(time > other.tSuppressPunchAngleTime)
					{ // Punchangle Allowed
						other.tSuppressPunchAngleTime = time + 0.5;
						other.punchangle_x = other.punchangle_x + (random() * 10);
						other.punchangle_y = other.punchangle_y + (random() * 10);
					}
					
					// Play Pain Sound
					// DISABLED FOR NOW
					/*
					if(time >= other.pain_finished)
					{ // Valid Pain Sound Time
						// Update Pain Finished
						other.pain_finished = time + 0.5;
						
						if (random() > 0.5)
							sound (other, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_NORM);
						else
							sound (other, CHAN_VOICE, "player/lburn2.wav", 1, ATTN_NORM);
					}
					*/
					
				}
			}
			// Produce Sound
			if(self.nPlayerModelSex == SEX_ROBOT)
			{
				if( random() > 0.5)
					sound (self, CHAN_AUTO, SOUND_KLESHIK_GORE_ROBOTGIBKICK1, 1, ATTN_NORM);
				else
					sound (self, CHAN_AUTO, SOUND_KLESHIK_GORE_ROBOTGIBKICK2, 1, ATTN_NORM);
			}
			else
			{
				if( random() > 0.5)
					sound (self, CHAN_AUTO, "zombie/z_miss.wav", 1, ATTN_NORM);
				else
					sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
			}
			
			if(self.flags & FL_ONGROUND)
			{ // Specific Ground Physics
				// Remove Ground Flag
				self.flags = self.flags - (self.flags & FL_ONGROUND);
				// Apply Additional Vertical Lift
				if(g_bGyroPhysicsEnabled && self.gyro_objectlist_inlist)
					vVelocity_z = 400;
				else
					vVelocity_z = 400;
				
				vVelocity_x = vVelocity_x * (450 + random() * 100);
				vVelocity_y = vVelocity_y * (450 + random() * 100);
			}
			else
				vVelocity = vVelocity * (450 + random() * 100);
				
			// Assign Velocity
			self.velocity = vVelocity;
			
			// Utilize Random Timer to defer insane touches
			self.tGibbedHeadKickDelayTime = time + 0.3;
			
			self.fpGibAngleVelocityFunc();
		}
	}
}

void DEBUG_GibbedHeadThink()
{ // NOTE : Debug Function to Determine Error when Think is Called
	local string strMessage;
	local float tTimeDiff;
	strMessage = strcat("^1WARNING^7 : ^2", self.classname, "^7 ");
	if(self.nCorpseTwitch_FinalDeathFrame)
		strMessage = strcat(strMessage, "(previously a twitching corpse) ");
	strMessage = strcat(strMessage, "Invoked NULL Think");
	// Calculate Time Since becoming Gibbed Head
	tTimeDiff = time - self.tGibbedHeadBecomeTime;
	strMessage = strcat(strMessage, " ^2", ftos(tTimeDiff), "^7 seconds after becoming a gibbed head!\n");
	bprint(strMessage);
}
void PrepareDamageableGib(entity enGib)
{ // Prepare Damageable Gib
	// Assign Damageable
	enGib.takedamage = DAMAGE_YES;
	// Assign Godmode
	enGib.flags = enGib.flags | FL_GODMODE;
	// Assign Force Damage Momentum
	enGib.bForceDamageMomentum = TRUE;
	// Assign PreDamageForce Function
	enGib.th_PreDamageForce = DamageableGib_PreDamageForce;
	// Assign PostDamageForce Function
	enGib.th_PostDamageForce = DamageableGib_PostDamageForce;
	// Assign Touch Function
	enGib.touch = DamageableGib_Touch;
	// Assign Solidity
	enGib.solid = SOLID_TRIGGER;
	// Reset Touch Timer
	enGib.tGibbedHeadKickDelayTime = 0;
	
	// Utilize Gyro Physics
	if(g_bGyroPhysicsEnabled && g_bGyroPhysics_DetailEntities)
	{ // Assign Gyro Physics Properties
		// Purge Current Gyro Properties
		Gyro_Object_ClearPhysics(enGib);
		// Assign Gib Properties
		Gyro_ObjectMacro_Gib(enGib, 600);
		// Assign Ignore Radius Damage
		// Gyro Physics takes care of damageable gibs
		enGib.bIgnoreRadiusDamage = TRUE;
	}
}

void FlamingGibbedHead_PurgeFire()
{ // Flaming Gibbed Head - Purge Fire
	self.effects = self.effects - (self.effects & EF_FLAME);
}
void QuakeGibbedHeadAngleVelocity()
{ // Quake Gibbed Head Angle Velocity
	self.avelocity = SG_crandom() * '0 900 0';
}
void GenericGibbedHeadAngleVelocity()
{ // Generic Gibbed Head Angle Velocity
	self.avelocity = randomvec() * 600;
}
void ThrowHead(string gibname, float dm, float nGibbedHeadType)
{
	setmodel (self, gibname);
	// setsize (self, '-16 -16 0', '16 16 56');
	setsize(self, '0 0 -8', '0 0 8');
	if(nGibbedHeadType == GIBBEDHEADTYPE_GENERICFLESH)
	{
		self.scale = 0.8;
		// NOTE: Do not use this size!  Bad for Q1BSP
		// setsize (self, '-8 -8 -8', '8 8 8');
		// Assign Model Flags
		self.modelflags = MF_GIB;
	}
	else
	if(nGibbedHeadType == GIBBEDHEADTYPE_GENERICROBOT)
	{
		// NOTE: Do not use this size!  Bad for Q1BSP
		// setsize (self, '-8 -8 -8', '8 8 8');
		// Assign Model Flags
		self.modelflags = MF_GRENADE;
	}
	self.frame = 0;
	self.movetype = MOVETYPE_BOUNCE;
	
	// DRESK
	// Assign Godmode (to prevent T_Damage from killing)
	self.flags |= FL_GODMODE;
	// Assign GibType (gibbed head)
	self.nGibType = GIBTYPE_GIBBEDHEAD;
	// Assign Small object in Water Transition
	self.contentstransition = ContentsTransition_SmallObjectInWater;
	// Assign Is Gibbed Corpse
	self.bIsGibbedCorpse = TRUE;
	// DEBUG : Assign Gibbed Head Become Time
	self.tGibbedHeadBecomeTime = time;
	
	// Check for Fliskers
	CheckCorpseForFliskerCorpseBursterController(self);
	
	// DRESK
	// Support Damageable Gibs
	if( cvar(CVAR_BLOODGORE_DAMAGEABLEGIBS) )
	{ // Damageable Gibs!
		PrepareDamageableGib(self);
	}
	else
	{ // Standard
		self.takedamage = DAMAGE_NO;
		self.solid = SOLID_NOT;
	}
	self.view_ofs = '0 0 8';
	self.velocity = VelocityForDamage (dm, self.bIgnoreDirectionalGibs);
	// self.origin_z = self.origin_z - 24;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	
	// DRESK
	// Assign Angle Velocity Information
	if(nGibbedHeadType == GIBBEDHEADTYPE_SPECIFIC)
		// self.fpGibAngleVelocityFunc = QuakeGibbedHeadAngleVelocity;
		self.fpGibAngleVelocityFunc = GenericGibbedHeadAngleVelocity;
	else
	if(nGibbedHeadType == GIBBEDHEADTYPE_GENERICFLESH || nGibbedHeadType == GIBBEDHEADTYPE_GENERICROBOT)
		self.fpGibAngleVelocityFunc = GenericGibbedHeadAngleVelocity;
	// Invoke Function
	self.fpGibAngleVelocityFunc();
	
	// DRESK
	// Low Precision
	self.effects = (self.effects | EF_LOWPRECISION);
	
	// DRESK
	// Remove All Think Operations
	self.nextthink = 0;
	self.think = DEBUG_GibbedHeadThink;
	
	// DRESK - HIPNOTIC SUPPORT
	// Suppress Gremlin Decision to Gorge Gibbed Head
	self.gorging = TRUE;
}
void CheckDamageBloodAndGoreFeedback(entity enAttacker, entity enTarget, vector vHitLocation, float fDamage, float fDamageType)
{ // Check Damage Blood and Gore Feedback
	if(vHitLocation == HITLOCATION_NONE)
		// Utilize Location of Target
		vHitLocation = enTarget.origin;
		
	if(enTarget.tLastDamageFeedbackTime < time
		&& fDamageType != DAMAGETYPE_MISC_FALLING
		&& fDamageType != DAMAGETYPE_MISC_DROWNING
		&& fDamageType != DAMAGETYPE_ENVIRONMENT_SLIME
		&& fDamageType != DAMAGETYPE_ENVIRONMENT_LAVA)
	{ // Proper Damage Type for Feedback
		// Update Last Damage Feedback Time
		enTarget.tLastDamageFeedbackTime = time;
		// Determine "Blood" Amount
		local float fBlood;
		fBlood = fDamage * 2;
		if(fBlood > 350)
			fBlood = 350;
		// Determine Impact Type
		local float fImpactType;
		switch(fDamageType)
		{
			// Damage Types for Generic Impact Sounds
			case DAMAGETYPE_WEAPON_SHOTGUN:
			case DAMAGETYPE_WEAPON_SUPERSHOTGUN:
			case DAMAGETYPE_MONSTER_SOLDIER_SHOTGUN:
			case DAMAGETYPE_MONSTER_SOLDIER_SUPERSHOTGUN:
			case DAMAGETYPE_WEAPON_SPIKE_TOUCH:
			case DAMAGETYPE_WEAPON_SUPERSPIKE_TOUCH:
			case DAMAGETYPE_WEAPON_FLECHETTECANNON:
			case DAMAGETYPE_WEAPON_SCATTERSHOT:
			case DAMAGETYPE_WEAPON_CHAINGUN:
				if(enTarget.bBleedsSparks || enTarget.solid == SOLID_BSP)
					fImpactType = IMPACTTYPE_METAL;
				else
					fImpactType = IMPACTTYPE_FLESH;
				break;
			default:
				if(enTarget.bBleedsSparks || enTarget.solid == SOLID_BSP)
					fImpactType = IMPACTTYPE_METAL_SILENT;
				else
					fImpactType = IMPACTTYPE_FLESH_SILENT;
				break;
			
		}
		
		// Send Temporary Entity
		te_DamageFeedbackWithImpactType(vHitLocation, fDamage, fImpactType);
		
		if(fImpactType != IMPACTTYPE_METAL && fImpactType != IMPACTTYPE_METAL_SILENT)
		{ // Spawn Additional Effects Server-Side
			// Spawn Gore Chunks
			local float nCnt;
			local float nMeatCnt;
				nMeatCnt = fDamage / 5;
				if(nMeatCnt < 0)
					nMeatCnt = 1;
				else
				if(nMeatCnt > 3)
					nMeatCnt = 3;
			for(nCnt = 0; nCnt < nMeatCnt; nCnt++)
			{ // Spawn Meat
				SpawnMeatSpray(vHitLocation, randomvec() * 150);
			}
		}
	}
}
string GetRandomGenericCorpseGibSound(entity enEntity)
{ // Return Random Generic Corpse Gib Sound
	local string strReturn;
	local float nRandom;
	if(enEntity.nPlayerModelSex == SEX_ROBOT)
	{
		nRandom = random() * 3;
		if(nRandom < 1)
			strReturn = SOUND_KLESHIK_GORE_ROBOTGIB1;
		else
		if(nRandom < 2)
			strReturn = SOUND_KLESHIK_GORE_ROBOTGIB2;
		else
			strReturn = SOUND_KLESHIK_GORE_ROBOTGIB3;
	}
	else
	{
		nRandom = random() * 6;
		if(nRandom < 1)
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB1;
		else
		if(nRandom < 2)
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB2;
		else
		if(nRandom < 3)
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB3;
		else
		if(nRandom < 4)
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB4;
		else
		if(nRandom < 5)
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB5;
		else
			strReturn = SOUND_KLESHIK_GORE_FLESHGIB6;
	}
		
	// Return Sound
	return strReturn;
}

/*
==============================================================================

BODY QUE

==============================================================================
*/

entity	bodyque_head;

void bodyque()
{	// just here so spawn functions don't complain after the world
	// creates bodyques
};

void InitBodyQue()
{
	// DRESK
	// Unused Variable(s)
	// local entity	e;
	
	// DRESK
	// Support Dynamic (at level load) BodyQue Size
	local float nCnt;
	local float nQueSize;
	local entity enQue;
		nQueSize = cvar(CVAR_BLOODGORE_PLAYERBODYQUESIZE);
		if(nQueSize < 1)
			nQueSize = 1;
		
	// Create Initial Head Body
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
		// Assign Current Body to Head Body
		enQue = bodyque_head;
	
	for(nCnt = 1; nCnt < nQueSize; nCnt++)
	{ // Create Bodies
		// Spawn Body
		enQue.owner = spawn();
		// Assign Classname
		enQue.owner.classname = "bodyque";
		
		// Assign Created Body to Current Body
		enQue = enQue.owner;
	}
	
	// Assign Linked List Loop-Around
	enQue.owner = bodyque_head;
	
	/*
	
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
	*/
}
// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void CopyToBodyQue(entity ent)
{
	bodyque_head.angles = ent.angles;		
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	// DRESK
	// Check for Final Corpse Frame
	if(ent.nPlayerFinalCorpseFrame)
		// Use final corpse frame because player corpse may have twitched, and the player respawned during the twitch anim
		bodyque_head.frame = ent.nPlayerFinalCorpseFrame;
	else
		bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	
	// DRESK
	// Copy Skin
	bodyque_head.skin = ent.skin;
	// Disable Corpse Shadow (for performance)
	bodyque_head.effects = EF_NOSHADOW | EF_LOWPRECISION;
	// Assign Is Corpse
	bodyque_head.bIsCorpse = TRUE;
	// Copy Is Gibbed Corpse
	bodyque_head.bIsGibbedCorpse = ent.bIsGibbedCorpse;
	// Copy Sex
	bodyque_head.nPlayerModelSex = ent.nPlayerModelSex;
	// Copy Jump / Land
	bodyque_head.nPlayerModelJumpLand = ent.nPlayerModelJumpLand;
	// Purge Think Operations
	bodyque_head.nextthink = -1;
	bodyque_head.think = __NULL__;
	// Copy Gib Angle Velocity Function
	bodyque_head.fpGibAngleVelocityFunc = ent.fpGibAngleVelocityFunc;
	// Copy Modelflags
	bodyque_head.modelflags = ent.modelflags;
	// Copy Scale
	bodyque_head.scale = ent.scale;
	
	bodyque_head.flags = 0;
	
	setsize (bodyque_head, ent.mins, ent.maxs);
	setorigin (bodyque_head, ent.origin);
	
	// DRESK
	// Assign GibType
	bodyque_head.nGibType = ent.nGibType;
	// Assign Player Model Type (for gibbing)
	bodyque_head.nPlayerModelType = ent.nPlayerModelType;
	// Reset Number of Corpse Twitches
	bodyque_head.nNumCorpseTwitches = 0;
	// Copy Bleeds Sparks
	bodyque_head.bBleedsSparks = ent.bBleedsSparks;
	// Determine Contents Transition
	if(bodyque_head.nGibType == GIBTYPE_GIBBEDHEAD)
		bodyque_head.contentstransition = ContentsTransition_SmallObjectInWater;
	else
		bodyque_head.contentstransition = ContentsTransition_BodyInWater;
	
	// DRESK
	if(!bodyque_head.bIsGibbedCorpse)
	{ // Not Gibbed
		// Align Bodyque Corpse Additionally
		if( cvar(CVAR_BLOODGORE_ALIGNCORPSESWITHSURFACENORMAL) )
			GetAlignedSurfaceAngles(bodyque_head);
		bodyque_head.nPlayerCorpseTwitchState = 0;
		bodyque_head.think = PlayerCorpseTwitchThink;
		bodyque_head.nextthink = time;
	}
		
	// Purge Gibbed Head Properties ALWAYS (will be overwritten following if necessary)
	// Remove Takedamage
	bodyque_head.takedamage = DAMAGE_NO;
	// Remove Solidity
	bodyque_head.solid = SOLID_NOT;
	// Remove Touch
	bodyque_head.touch = __NULL__;
	// Remove Damage Forces
	bodyque_head.th_PreDamageForce = __NULL__;
	bodyque_head.th_PostDamageForce = __NULL__;
	// Remove Ignore Radius Damage
	bodyque_head.bIgnoreRadiusDamage = FALSE;
	// Assign Force Damage Momentum
	bodyque_head.bForceDamageMomentum = ent.bForceDamageMomentum;
	
	// Remove Potential Gyro Properties
	if(g_bGyroPhysicsEnabled && g_bGyroPhysics_DetailEntities)
		Gyro_Object_ClearPhysics(bodyque_head);
	
	// DRESK
	// Support Damageable Gibbed Heads
	if(bodyque_head.nGibType == GIBTYPE_GIBBEDHEAD && cvar(CVAR_BLOODGORE_DAMAGEABLEGIBS) )
		PrepareDamageableGib(bodyque_head);
	else
	if( cvar(CVAR_BLOODGORE_CORPSESGIBBABLEWITHRADIUSDAMAGE) )
	{ // Corpses Gibbable with Radius Damage
		// Assign Damageable
		bodyque_head.takedamage = DAMAGE_YES;
		// Assign Gib Death
		bodyque_head.th_die = PlayerCorpseDie;
		// Assign Momentum
		bodyque_head.fPreDamageForce_Multiplier = 1.0;
		// Assign Force Damage Momentum
		bodyque_head.bForceDamageMomentum = TRUE;
	}
		
	bodyque_head = bodyque_head.owner;
}