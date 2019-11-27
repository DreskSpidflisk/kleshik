// DRESK
// Elite Monster Support

// Definitions
#define ELITEMONSTER_DAMAGEMULTIPLIER							1.4
#define ELITEMONSTER_HEALTHMULTIPLIER							2.0
#define ELITEMONSTER_MOVEMENTADDITION							0.5
#define ELITEMONSTER_RADIUSDAMAGERATIO							0.8

#define ELITEMONSTER_LIGHTPULSATION_BASETIME					0.5
#define ELITEMONSTER_LIGHTPULSATION_STRING_1					"az"
#define ELITEMONSTER_LIGHTPULSATION_STRING_2					"az"

// Fields
.float		bIsEliteMonster;
.float		bInitiallyStealthedEliteMonster;
.float		bCannotBecomeEliteMonster;
.float		bSuppressEliteMonsterHealthAndRadiusBonuses;
.vector		vPreEliteMonsterColormod;
.entity		enEliteMonsterDetailEntity;

.float		fPreEliteMonsterRadiusDamageRatio;
.float		bPreEliteMonsterRadiusDamageRatioOverride;

.float		bRedirectedEliteMonsterProjectile;

// Functions
void PurgeEliteMonsterAttributes_WorldEffects(entity enMonster)
{ // Purge Elite Monster Attributes - WorldEffects
	// Utilize TE Effect
	te_EliteMonsterDeath(enMonster.origin - '0 0 15');
}
void PurgeEliteMonsterAttributes(entity enMonster, entity enAttacker)
{ // Purge Elite Monster Attributes
	if(enMonster.bIsEliteMonster)
	{ // Valid Elite Monster
		// Remove Effects
		enMonster.effects = enMonster.effects - (enMonster.effects & EF_RED);
		enMonster.effects = enMonster.effects - (enMonster.effects & EF_FULLBRIGHT);
		
		// Remove Detail Entity
		remove(enMonster.enEliteMonsterDetailEntity);
		
		// Restore Colormod
		enMonster.colormod = enMonster.vPreEliteMonsterColormod;
		// Remove Flags
		enMonster.bIsEliteMonster = FALSE;
		enMonster.bInitiallyStealthedEliteMonster = FALSE;
		// Restore Radius Damage Modifications
		enMonster.fRadiusDamageRatio = enMonster.fPreEliteMonsterRadiusDamageRatio;
		enMonster.bRadiusDamageRatioOverride = enMonster.bPreEliteMonsterRadiusDamageRatioOverride;
		
		// Add Health to Players
		if(enAttacker.classname == "player")
		{
			local float fPercent;
				fPercent = cvar(CVAR_ELITEMONSTER_PERCENTMONSTERHEALTHGRANTEDTOPLAYERSONDEATH) / 100;
			if(fPercent > 0)
			{ // Apply Health to Players
				// Acquire Health to Heal
				local float fHeal;
					fHeal = enMonster.nEntityHealthAtSpawn * fPercent;
				// Cap Heal
				fHeal = min(fHeal, cvar(CVAR_ELITEMONSTER_MAXMONSTERHEALTHGRANTEDTOPLAYERSONDEATH) );
				// Loop through Players
				local entity enFind;
				enFind = findflags(world, flags, FL_CLIENT);
		
				while(enFind != world)
				{ // Valid Player
					if(enFind.deadflag == DEAD_NO)
					{ // Alive
						T_Heal(enFind, fHeal, TRUE);
					}
					
					// Acquire Next Player
					enFind = findflags(enFind, flags, FL_CLIENT);
				}
			}
		}
		
		// Perform World Effects
		PurgeEliteMonsterAttributes_WorldEffects(enMonster);
	}
}
void AssignEliteMonsterAttributes_VisualEffects(entity enMonster, float bPlaySightSound)
{ // Assign Elite Monster Attributes - Visual Effects
	if( cvar(CVAR_ELITEMONSTER_INITIALCONTACTHUDSTINGER) )
		ApplyHUDStingerToAllPlayers_ClientCommand(HUD_CLIENTCOMMAND_HUDSTINGER_EVILEVENT);
	if(bPlaySightSound && enMonster.fpMonsterSightSoundFunction)
	{ // Play Sight Sound
		// Backup Self
		local entity enOldSelf;
			enOldSelf = self;
		self = enMonster;
		self.fpMonsterSightSoundFunction(CHAN_AUTO, ATTN_NONE);
		// Restore Oldself
		self = enOldSelf;
	}
	// Backup Colormod
	enMonster.vPreEliteMonsterColormod = enMonster.colormod;
	
	// Assign Visual Effects
	enMonster.colormod = '0.8 0.3 0.3';
	// enMonster.effects = enMonster.effects | EF_RED;
	enMonster.effects = enMonster.effects | EF_FULLBRIGHT;
	
	// Spawn Detail Entity
	enMonster.enEliteMonsterDetailEntity = spawn();
	setmodel(enMonster.enEliteMonsterDetailEntity, "progs/invulner.mdl");
	enMonster.enEliteMonsterDetailEntity.alpha = 0.4;
	if(enMonster.classname == "monster_shambler")
		// Extra Large Dealy for Shambler (will probably move this to an attribute if used enough)
		enMonster.enEliteMonsterDetailEntity.scale = 3.0;
	else
		enMonster.enEliteMonsterDetailEntity.scale = 1.7;
	enMonster.enEliteMonsterDetailEntity.angles = '0 0 0';
	setorigin(enMonster.enEliteMonsterDetailEntity, '0 0 -32');
	enMonster.enEliteMonsterDetailEntity.effects = EF_FULLBRIGHT;
	setattachment(enMonster.enEliteMonsterDetailEntity, enMonster, "");
	
	// Remove Initially Stealthed Elite Monster
	enMonster.bInitiallyStealthedEliteMonster = FALSE;
}
void AssignEliteMonsterAttributes(entity enMonster)
{ // Assign Elite Monster Attributes
	if(!enMonster.bIsEliteMonster && !enMonster.bCannotBecomeEliteMonster)
	{ // Valid Monster
		// Assign Elite Monster
		enMonster.bIsEliteMonster = TRUE;
		
		// Apply Movement Speed Bonus
		enMonster.fMonsterMovementMultiplier = enMonster.fMonsterMovementMultiplier + ELITEMONSTER_MOVEMENTADDITION;
		
		// Assign Double Full Health
		if(!enMonster.bSuppressEliteMonsterHealthAndRadiusBonuses)
		{ // Assign Health and Radius Damage Bonuses
			enMonster.health = (enMonster.nEntityHealthAtSpawn * ELITEMONSTER_HEALTHMULTIPLIER);
			// Backup Radius Damage Reduction
			enMonster.fPreEliteMonsterRadiusDamageRatio = enMonster.fRadiusDamageRatio;
			enMonster.bPreEliteMonsterRadiusDamageRatioOverride = enMonster.bRadiusDamageRatioOverride;
			
			// Assign Radius Damage Reduction
			enMonster.fRadiusDamageRatio = ELITEMONSTER_RADIUSDAMAGERATIO - enMonster.fPreEliteMonsterRadiusDamageRatio;
			enMonster.bRadiusDamageRatioOverride = TRUE;
			// enMonster.bIgnoreRadiusDamage = TRUE;
		}
		
		if(!enMonster.bInitiallyStealthedEliteMonster)
		{ // Assign Visual Effects
			AssignEliteMonsterAttributes_VisualEffects(enMonster, FALSE);
			// Play Sound
			sound(enMonster, CHAN_AUTO, SOUND_KLESHIK_ELITEMONSTER_BECOME, 1, ATTN_NONE);
		}
	}
}
void EliteMonsterRedirectProjectile(entity enEliteMonster, entity enProjectile)
{ // Redirect Projectile
	if(enProjectile.movetype == MOVETYPE_FLYMISSILE)
	{ // Redirect Missiles
		enProjectile.movetype = MOVETYPE_BOUNCEMISSILE;
		/*local vector vOrigin;
			vOrigin = GetLeadingProjectileOrigin(enProjectile, enProjectile.origin, enProjectile.owner, vlen(enProjectile.velocity), 0);
			enProjectile.velocity = vOrigin * vlen(enProjectile.velocity);*/
	}
	else
	if(enProjectile.movetype == MOVETYPE_BOUNCE)
	{ // Bouncing Projectile
		// Do nothing as of now
	}
	
	// Acquire Owner
	local entity enOwner;
		enOwner = enProjectile.owner;
	
	// Assign New Owner
	enProjectile.owner = enEliteMonster;
	enProjectile.bRedirectedEliteMonsterProjectile = TRUE;
	
	// Produce Effect
	te_EliteMonsterRedirectProjectile(enProjectile.origin);
	
	// Check Response to Owner (as if damaged)
	local entity enOldSelf;
		enOldSelf = self;
	self = enEliteMonster;
	CheckMonsterResponseToDamage(enOwner);
	self = enOldSelf;
}
