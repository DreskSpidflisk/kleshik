//============================================================================

/*
============
CanDamage

Returns true if the inflictor can directly damage the target.  Used for
explosions and melee attacks.
============
*/
// DRESK
// C-STYLE FUNCTION SYNTAX
float CanDamage(entity targ, entity inflictor)
{
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;

	return FALSE;
}


/*
============
Killed
============
*/
// DRESK
// Support Damage Types
// DRESK
// C-STYLE FUNCTION SYNTAX
void Killed(entity targ, entity attacker, entity enInflictor, float fDamageType)
{
	local entity oself;

	oself = self;
	self = targ;
	
	local float bIsPlayer;
		if(self.classname == "player")
			bIsPlayer = TRUE;
		else
			bIsPlayer = FALSE;
	
	// DRESK
	// Check to ensure player, else some monsters may not be gibbable
	if(self.health < -99 && bIsPlayer)
	// if (self.health < -99)
		self.health = -99;		// don't let sbar look bad if a player

	// DRESK
	// Suppress Additional Processing of Exploding Item Box
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE || self.classname == "exploding_item_box")
	// if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{	// doors, triggers, etc
		self.th_die(fDamageType);
		self = oself;
		return;
	}

	self.enemy = attacker;

	// Check Monster Effects
	if ( (self.flags & FL_MONSTER) && !(self.bIsCorpse) )
	{
		// DRESK
		// Purge Elite Monster Effects
		PurgeEliteMonsterAttributes(self, attacker);
		
		// Remove Ability to Become Elite Monster
		self.bCannotBecomeEliteMonster = TRUE;
			
		// Increment Number of Times Killed Counter
		// NOTE: For potential future monster respawning.
		self.nNumTimesKilled = self.nNumTimesKilled + 1;
		
		if(self.nNumTimesKilled == 1)
		{ // Initial Kill
			// Check Update Advanced Statistics
			CheckUpdatedAdvancedStatistics();
		
			// First Kill; Send
			if(!self.bMonsterIgnoreStatTracking)
			{
				if(self.bMonsterIsClone)
				{ // Additional Monster Kill
					g_nNumKilledSpawnedMonsters = g_nNumKilledSpawnedMonsters + 1;
				}
				else
				{ // Standard Monster Kill
					killed_monsters = killed_monsters + 1;
					WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
				}
			}
			
			// Check for Flisker Corpse Burster Controller
			CheckFliskerSpawnCorpseBursterController(self);
		}
		
		// Support Cooperative Frags Based on Monsters Killed
		if(attacker.classname == "player")
		{ // Player is Attacker
			if(coop)
				attacker.frags = attacker.frags + 1;
			// Update Number of Kills for Client
			UpdateClientStatsScore(attacker, CLIENTSCORE_NUMKILLS, 1);
		}
	}
	
	// DRESK
	// Check for Alive Client
	if(self.flags & FL_CLIENT && !self.bIsCorpse)
		ClientObituary(self, attacker, enInflictor, fDamageType);
	
	// Remove Damageable and Touch
	self.takedamage = DAMAGE_NO;
	self.touch = __NULL__;
	// Remove Solidity Immediately
	self.solid = SOLID_NOT;
	// Assign Body Contents Transition
	self.contentstransition = ContentsTransition_BodyInWater;
	
	// DRESK
	// Align Corpse with Surface Normal
	if( cvar(CVAR_BLOODGORE_ALIGNCORPSESWITHSURFACENORMAL) )
		GetAlignedSurfaceAngles(self);
		
	// DRESK
	// Support Bleeding
	CheckCreatureBleeding(self);
		
	// DRESK
	// Check for Gibbable Corpses
	if( cvar(CVAR_BLOODGORE_CORPSESGIBBABLEWITHRADIUSDAMAGE) )
	{ // Valid Gibbable Corpse
		// Assign Damageable
		self.takedamage = DAMAGE_YES;
	}
	
	// DRESK
	// Only Invoke monster_death_use on first monster death
	if( (self.flags & FL_MONSTER) )
	{ // Valid Monster
		if(self.nNumTimesKilled == 1)
			// Initial Kill; Invoke Death Use
			monster_death_use();
	}
	
	// DRESK
	// Check Extra Death Aesthetics
	// NOTE: Necessary before calling death routine
	CheckExtraDeathAesthetics(self, fDamageType);
	
	if( !(self.bIsCorpse && self.health >= self.nGibHealth) )
	{ // Skip Death Routine if Entity is Corpse and is not gibbing
		// DRESK
		// Provide Verbose Error Feedback
		if(self.th_die)
			self.th_die(fDamageType);
		else
			bprint( strcat("^1ERROR : ^2", self.classname, "^7, killed by ^2", attacker.classname, "^7, had no th_die!\n") );
	}
		
	// Assign Is Corpse
	self.bIsCorpse = TRUE;
	
	// Restore Killer
	self = oself;
}


/*
============
T_Damage

The damage is coming from inflictor, but get mad at attacker
This should be the only function that ever reduces health.
============
*/
// DRESK
// Support New T_Damage Function with Direction Support
// Utilize Old Direction Logic if no Direction Specified

void T_Damage_Direction(entity enTarget, entity enInflictor, entity enAttacker, vector vHitLocation, float fDamageType, float fDamage, float bHasDirection, vector vDamageDirection)
{
	local	vector	dir;
	local	entity	oldself;
	local	float	save;
	local	float	take;
	
	if (!enTarget.takedamage)
		return;
		
	// DRESK
	// Support Deferred Remove Armor
	local	float	bRemoveArmor;
		bRemoveArmor = FALSE;

	// used by buttons and triggers to set activator for target firing
	damage_attacker = enAttacker;

	// check for quad damage powerup on the attacker
	if (enAttacker.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
		fDamage = fDamage * 4;
		
	// DRESK
	// Check for Bonus Monster
	if(enAttacker.bIsEliteMonster)
		fDamage = fDamage * ELITEMONSTER_DAMAGEMULTIPLIER;
		
	// Check for Crouching Player
	if(enTarget.bIsCrouching && g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
		fDamage = fDamage * (1 + (SG_AUTOCVAR(kleshik_server_PlayerModel_Crouch_DamageReceivedMod) / 100) );
		
	// DRESK
	// Support Mirror Friendly Damage
	if(coop && enTarget != enAttacker && (enTarget.flags & FL_CLIENT) && (enAttacker.flags & FL_CLIENT) )
	{ // Potential Mirror Damage Setup
		if( cvar(CVAR_COOP_MIRRORFRIENDLYDAMAGE) )
		{ // Mirror Friendly Damage Enabled
			// Switch Target and Attacker; Continue with Function
			enAttacker = enTarget;
			enTarget = damage_attacker;
		}
	}
	
	// DRESK - HIPNOTIC SUPPORT
	// Check for Empathy Shields
	if(g_bHipnoticEnabled)
	{
		if( (enTarget.nCSQCStat_Powerups & POWERUP_EMPATHYSHIELDS)
			&& !(enInflictor.nCSQCStat_Powerups & POWERUP_EMPATHYSHIELDS)
			&& (enTarget != enAttacker)
			)
		{
			fDamage = fDamage / 2;
			T_Damage (enAttacker, enTarget, enTarget, HITLOCATION_NONE, DAMAGETYPE_WEAPON_EMPATHYSHIELDS, fDamage);
		}
	}

	// save damage based on the target's armor level
	// DRESK
	// Do NOT Save on Falling Damage / Drowning
	save = 0;
	if(fDamageType != DAMAGETYPE_MISC_DROWNING
		&& fDamageType != DAMAGETYPE_MISC_FALLING)
	{ // Valid Damagetype
		save = ceil(enTarget.armortype * fDamage);
		
		if (save >= enTarget.armorvalue)
		{ // Damage to Save is Greater than Armor Available; Cap to Armor and Remove Armor
			save = enTarget.armorvalue;
			
			// DRESK
			// Reduce Armor Value AFTER Godmode / Pentagram Checks
			bRemoveArmor = TRUE;
			// targ.armortype = 0;	// lost all armor
			// targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		}
	}
	
	// DRESK
	// Reduce Armor Value AFTER Godmode / Pentagram Checks
	// targ.armorvalue = targ.armorvalue - save;
	take = ceil(fDamage - save);

	// figure momentum add
	// DRESK
	// Support Creature Damage Force
	if ( (enInflictor != world) && (!enTarget.bIgnoreDamageMomentum) &&
		( (enTarget.movetype == MOVETYPE_WALK)
		|| ( SG_AUTOCVAR(kleshik_server_monster_AllowDamageForce) && enTarget.movetype == MOVETYPE_STEP)
		|| (enTarget.bForceDamageMomentum) ) )
	{ // Valid Entity for Momentum
		// Calculate Direction of Force
		// NOTE: Standard system utilizes directional difference based on inflictor position (not very good)
		if(!bHasDirection)
		{ // Calculate Direction Using Standard System
			dir = enTarget.origin - (enInflictor.absmin + enInflictor.absmax) * 0.5;
			dir = normalize(dir);
		}
		else
		{ // Direction Supplied
			dir = vDamageDirection;
		}
		local vector vDamageForce;
		
		// DRESK
		// Support Additional Lift Velocity
		if( ( (enTarget.movetype == MOVETYPE_STEP) && SG_AUTOCVAR(kleshik_server_monster_ApplyAdditionalLiftVelocity) ) || (enTarget.bForceDamageMomentum) )
		{ // Target is Creature and Requires Additional Lift
			if(enTarget.flags & FL_ONGROUND) 
			{ // Apply Lifting Velocity
				// enTarget.velocity_z = enTarget.velocity_z + (30.0 + (fDamage * (random() * 5) ) );
				enTarget.velocity_z = enTarget.velocity_z + (30.0 + (random() * 5) );
				// Remove Ground Flag (in case additional damage this frame occurs)
				enTarget.flags = enTarget.flags - (enTarget.flags & FL_ONGROUND);
				
				if( SG_AUTOCVAR(kleshik_server_weapon_AllShotguns_PerBulletDamage) && fDamageType == DAMAGETYPE_WEAPON_SHOTGUN || fDamageType == DAMAGETYPE_WEAPON_SUPERSHOTGUN || fDamageType == DAMAGETYPE_WEAPON_SCATTERSHOT)
					// Apply Additional Lift for Shotguns
					enTarget.velocity_z = enTarget.velocity_z * 5;
			}
				
			vDamageForce = dir * fDamage * 4;
		}
		else
			vDamageForce = dir * fDamage * 8;
			
		// Utilize PreDamageForce Function
		// NOTE: Must assign self to target here for function pointers to work.
		oldself = self;
		self = enTarget;
		if(self.th_PreDamageForce)
			self.th_PreDamageForce();
			
		if(self.fPreDamageForce_Multiplier == 0)
			bprint( strcat("WARNING : ^2", self.classname, "^7 has 0 Damage Force Multiplier!\n") );
			
		vDamageForce = vDamageForce * enTarget.fPreDamageForce_Multiplier;
			
		// Apply Damage Force
		self.velocity = self.velocity + vDamageForce;
		
		if(self.th_PostDamageForce)
			self.th_PostDamageForce();
			
		// Restore Self
		self = oldself;
	}

	// check for godmode or invincibility
	if (enTarget.flags & FL_GODMODE)
		return;
		
	if (enTarget.nCSQCStat_Powerups & POWERUP_INVULNERABILITY)
	{ // Target Has Invulnerability
		if (enTarget.invincible_sound < time)
		{ // Play Invulnerability Sound
			sound (enTarget, CHAN_AUTO, "items/protect3.wav", 1, ATTN_NORM);
			enTarget.invincible_sound = time + 2;
		}
		return;
	}
	
	// team play damage avoidance
	// DRESK
	// Clean this up a bit for now (random deathmatch teams?  Too odd)
	// if ( (teamplay == 1) && (enTarget.team > 0) && (enTarget.team == enAttacker.team) )
	if( SG_AUTOCVAR(kleshik_server_coop_DisableFriendlyFire) && (enAttacker != enTarget) && enAttacker.flags & FL_CLIENT && enTarget.flags & FL_CLIENT)
		return;
		
	// add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	// FIXME: remove after combining shotgun blasts?
	if (enTarget.flags & FL_CLIENT)
	{
		enTarget.dmg_take = enTarget.dmg_take + take;
		enTarget.dmg_save = enTarget.dmg_save + save;
		enTarget.dmg_inflictor = enInflictor;
	}
	
	// DRESK - HIPNOTIC SUPPORT
	// Play Potential Empathy Sound
	if (g_bHipnoticEnabled && enTarget.nCSQCStat_Powerups & POWERUP_EMPATHYSHIELDS)
	{ // Target has Empathy Shields
		if (self.empathy_sound < time)
		{ // Play Empathy Shields Sound
			sound (enTarget, CHAN_AUTO, "hipitems/empathy2.wav", 1, ATTN_NORM);
			self.empathy_sound = time + 0.5;
		}
	}
		
	// DRESK
	// Damage Armor Here
	if(bRemoveArmor)
	{ // Armor to be Removed (due to damage being >= to amount saved from armor)
		enTarget.armortype = 0;	// lost all armor
		enTarget.items = enTarget.items - (enTarget.items & (ITEM_ARMOR1 | ITEM_ARMOR2 | ITEM_ARMOR3));
	}
	enTarget.armorvalue = enTarget.armorvalue - save;
	
	// DRESK
	// Check for Elite Monster
	if(enTarget.bInitiallyStealthedEliteMonster && enAttacker.flags & FL_CLIENT)
	{ // Reveal Elite Monster
		AssignEliteMonsterAttributes_VisualEffects(enTarget, TRUE);
	}
		
	// DO THE DAMAGE
	enTarget.health = enTarget.health - take;
	
	// DRESK
	// Add to Attacker Total Damage Dealt (after all processing)
	if(fDamageType != DAMAGETYPE_MISC_SUICIDE)
	{ // Ignore Suicides
		if(enAttacker.flags & FL_CLIENT && enAttacker == enTarget)
			// Injured Self; Subtract
			UpdateClientStatsScore(enAttacker, CLIENTSCORE_TOTALDAMAGEDEALT, take * -1);
		else
		{
			if( (enAttacker.flags & FL_CLIENT) && (enTarget.flags & FL_MONSTER) && (enTarget.nNumTimesKilled == 0) )
				UpdateClientStatsScore(enAttacker, CLIENTSCORE_TOTALDAMAGEDEALT, take);
			// Add to Target Total Damage Received (after all processing)
			if(enTarget.flags & FL_CLIENT)
				UpdateClientStatsScore(enTarget, CLIENTSCORE_TOTALDAMAGERECEIVED, take);
		}
	}
	
	// DRESK
	// Assign Last Damage Velocity (used primarily for Directional Gibs)
	enTarget.vLastDamageVelocity = dir;
	
	// DRESK
	// Check for Bleeding
	CheckCreatureBleeding(enTarget);
	// Check Damage Blood and Gore Feedback
	CheckDamageBloodAndGoreFeedback(enAttacker, enTarget, vHitLocation, take, fDamageType);
			
	if (enTarget.health <= 0)
	{ // Target Killed
		Killed (enTarget, enAttacker, enInflictor, fDamageType);
		return;
	}

	// react to the damage
	oldself = self;
	self = enTarget;

	if ( (self.flags & FL_MONSTER) && enAttacker != world)
		CheckMonsterResponseToDamage(enAttacker);

	if (self.th_pain)
	{ // Perform Pain Function
		self.th_pain(enAttacker, take, fDamageType);
		// nightmare mode monsters don't go into pain frames often
		// DRESK
		// Check to Make Sure FL_MONSTER
		if (skill == 3 && (self.flags & FL_MONSTER) )
			self.pain_finished = time + 5;
	}

	self = oldself;
}
// DRESK
// Support Damage Types, Direction of Damage
void T_Damage(entity enTarget, entity enInflictor, entity enAttacker, vector vHitLocation, float fDamageType, float fDamage)
{
	// Execute Directional Damage Version with Standard Calculation
	T_Damage_Direction(enTarget, enInflictor, enAttacker, vHitLocation, fDamageType, fDamage, FALSE, '0 0 0');
}

/*
============
T_RadiusDamage
============
*/
// DRESK
// Support Damage Types
void T_RadiusDamage(entity enInflictor, entity enAttacker, float fDamageType, float fDamage, entity enIgnoreEntity)
{
	local	float 	points;
	local	entity	head;
	local	vector	org;

	head = findradius(enInflictor.origin, fDamage+40);
	
	// DRESK
	// Support Gyro Physics Explosion
	if(g_bGyroPhysicsEnabled)
		Gyro_ForceMacro_Explosion(enInflictor.origin, fDamage + 40, 800);
	
	while (head)
	{
		if (head != enIgnoreEntity)
		{
			// DRESK
			// Support Ignore Radius Damage
			if(head.takedamage && !head.bIgnoreRadiusDamage)
			// if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs)*0.5;
				points = 0.5*vlen (enInflictor.origin - org);
				if (points < 0)
					points = 0;
				points = fDamage - points;
				
				// Reduce Damage if Attacker is Self
				if (head == enAttacker)
					points = points * 0.5;
					
				// DRESK
				// Reduce Radius Damage (if enabled)
				if(head.bRadiusDamageRatioOverride)
					points = points * head.fRadiusDamageRatio;
					
				if (points > 0)
				{
					if (CanDamage (head, enInflictor))
					{
						T_Damage (head, enInflictor, enAttacker, HITLOCATION_NONE, fDamageType, points);
					}
				}
			}
		}
		head = head.chain;
	}
}