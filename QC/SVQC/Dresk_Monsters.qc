// DRESK - Monsters
// Provides functionality for monsters.

// Definitions
#define MONSTER_SWINGTYPE_STANDARD						0
#define MONSTER_SWINGTYPE_LARGE							1

#define MONSTER_LANDMONSTER_DEFAULTMOVETYPE				MOVETYPE_STEP

// Fields
.float		bIsHipnoticSpawnCreature;
.float		bHipnoticSpawnCreature_Spawned;

.float		fMonsterMovementMultiplier;
.float		fMonsterMovementMaximum;

.float		tMonsterNewPlayerEnemyTime;

.float		tShalrathMissileExplodeTime;
.float		tWrathMissileExplodeTime;

.float		bIsMonster;
.float		bIgnoreWaterDamage;

.float		nCurrentRefireAmount;

.float()	fpMonsterCheckAttackFunction;

.float		bIsMonsterStatue;

.string		strMonsterDisplayName;

.void(float nChannel, float nAttenuation) fpMonsterSightSoundFunction;
.void(float nChannel, float nAttenuation) fpMonsterDeathSoundFunction;
.string		strMonsterGenericSightSound;
.string		strMonsterDeathSound;

// Monster Frame System
// Specify if monster frame system should use a think entity
// If a think entity is not used, MonsterFrame is run every server
// frame.
#define MONSTERFRAMESYSTEM_USETHINKENTITY
// Specify the Monster Frame Entity Think Time
#define MONSTERFRAMESYSTEM_USETHINKENTITY_TIME				1.0

#ifdef MONSTERFRAMESYSTEM_USETHINKENTITY
entity	g_enMonsterFrameThinkEntity;
#endif

#define APPLYMONSTERATTACKRANDOMNEXTTHINK					self.nextthink = time + 0.05 + (random() * 0.05)

void Monster_GenericSightSound(float nChannel, float nAttentuation)
{ // Monster Generic Sight Sound
	sound(self, nChannel, self.strMonsterGenericSightSound, 1, nAttentuation);
}
void Monster_GenericDeathSound(float nChannel, float nAttentuation)
{ // Monster Generic Death Sound
	if( cvar(CVAR_MONSTER_DEATHSOUNDHASNOATTENUATION) )
		sound(self, nChannel, self.strMonsterDeathSound, 1, ATTN_NONE);
	else
		sound(self, nChannel, self.strMonsterDeathSound, 1, ATTN_NORM);
}
void MonsterHitGround(vector vImpactVelocity)
{ // Monster Hit Ground
	// Spawn Dust
	if(self.bBleedsSparks)
		te_CorpseDustSmash(self.origin, IMPACTTYPE_METAL);
	else
		te_CorpseDustSmash(self.origin, IMPACTTYPE_FLESH);
}
void Monster_PrepareGenericSightSoundFunction(string strSightSound)
{ // Monster Generic Sight Sound
	self.strMonsterGenericSightSound = strSightSound;
	self.fpMonsterSightSoundFunction = Monster_GenericSightSound;
}
void Monster_PrepareGenericDeathSoundFunction(string strDeathSound)
{ // Monster Death Sound
	self.strMonsterDeathSound = strDeathSound;
	self.fpMonsterDeathSoundFunction = Monster_GenericDeathSound;
}

void CheckMonsterResponseToDamage(entity enAttacker)
{ // Check Monster Response to Damage
	// NOTE: Assumed scope is monster.
	if(self != enAttacker && enAttacker != self.enemy)
	{ // New Attacker
		if( (self.classname != enAttacker.classname) 
		|| (self.classname == "monster_army" )
		|| (self.classname == "monster_armagon") )
		{ // Attack this Target
			if(self.classname != "monster_dragon")
			{ // Dragon has Superceeding AI
				if (self.enemy.classname == "player")
				{ // Currently Attacking Player
					if(self.tMonsterNewPlayerEnemyTime > time && enAttacker.classname == "player")
					{ // New Target is Player; New Player Enemy Time Not Met
						return;
					}
					// Backup Current Player Enemy
					self.oldenemy = self.enemy;
				}
				// Assign New Enemy
				self.enemy = enAttacker;
				// Trigger Fount Target
				FoundTarget();
				// Update New Player Enemy Timer
				if(enAttacker.classname == "player")
					self.tMonsterNewPlayerEnemyTime = time + 5;
			}
		}
	}
}
void CheckMonsterWaterVolumeDamage(entity enMonster)
{ // Check Monster Water Volume Damage
	// NOTE: Potentially called many times in a single frame.  Be careful
	// with usage.
	local float nDamageType;
	local float nDamage;
	// local float fReport;
		// fReport = 1;
	if(enMonster.watertype == CONTENT_SLIME)
	{ // Slime
		nDamageType = DAMAGETYPE_ENVIRONMENT_SLIME;
		nDamage = 30;
	}
	else
	if(enMonster.watertype == CONTENT_LAVA)
	{ // Lava
		nDamageType = DAMAGETYPE_ENVIRONMENT_LAVA;
		nDamage = 90;
	}
	
	if(nDamage > 0)
	{ // Valid Damage to be Applied
		if(enMonster.classname == "monster_zombie")
			// Monster is Zombie; Gib Immediately
			nDamage = self.nGibHealth * -2;
		// Apply Damage
		T_Damage (enMonster, world, world, HITLOCATION_NONE, nDamageType, nDamage * enMonster.waterlevel);
	}
	// else
		// fReport = 0;
	
	// if(fReport)
		// bprint( strcat(enCreature.netname, " : I'm walking in damaging water!\n") );
}
vector GetRandomMonsterColor()
{ // Return Random Monster Color
	local vector vColorMod;
	
	vColorMod_x = GetRandomVectorValue(0.5);
	vColorMod_y = GetRandomVectorValue(0.5);
	vColorMod_z = GetRandomVectorValue(0.5);
	
	return vColorMod;
}
void ApplyRandomMonsterAesthetics()
{ // Apply Random Monster Aesthetics
	// NOTE: Function encapsulates all monsters for ease of importing into
	// other mods.
	
	// Acquire Creature Global Alpha Level
	local float fGlobalAlpha;
		fGlobalAlpha = cvar(CVAR_MONSTER_GLOBALALPHALEVEL);
	local float fNewAlpha;
		fNewAlpha = 0;
	local vector vNewColormod;
	
	// Restore Potential Modifications First
	RestoreEntityAlpha(self);
	RestoreEntityColormod(self);
	
	if( cvar(CVAR_MONSTER_APPLYRANDOMAESTHETICS) )
	{ // Random Creature Aesthetics Valid; Apply
		if(self.classname == "monster_wizard")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_zombie")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
		}
		else
		if(self.classname == "monster_tarbaby")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_fish")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_dog")
		{
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_shambler")
		{
			local float nRandom;
				nRandom = GetRandomVectorValue(0.4);
			vNewColormod_x = nRandom;
			vNewColormod_y = nRandom;
			vNewColormod_z = 1.0;
		}
		// HIPNOTIC SUPPORT
		else
		if(self.classname == "trap_spike_mine")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
		}
		// ROGUE SUPPORT
		else
		if(self.classname == "monster_eel")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.5) );
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_sword")
		{
			vNewColormod = GetRandomMonsterColor();
			self.glow_trail = 1;
			self.glow_color = 75;
			self.effects = self.effects | EF_FULLBRIGHT;
		}
		else
		if(self.classname == "monster_wrath" || self.classname == "monster_super_wrath")
		{
			fNewAlpha = min(fGlobalAlpha, GetRandomVectorValue(0.8) );
			vNewColormod = GetRandomMonsterColor();
		}
		// TRAVAIL SUPPORT
		else
		if(self.classname == "monster_spider")
		{
			vNewColormod = GetRandomMonsterColor();
		}
		// KLESHIK MONSTERS SUPPORT
		else
		if(self.classname == "monster_kleshik_babydragon")
		{
			vNewColormod = GetRandomMonsterColor();
		}
		else
		if(self.classname == "monster_kleshik_flisker")
		{
			vNewColormod = GetRandomMonsterColor();
		}
		
		// Apply Alpha
		if(fNewAlpha)
			SetNewEntityAlpha(self, fNewAlpha);
		// Apply Colormod
		if(vNewColormod != '0 0 0')
			SetNewEntityColormod(self, vNewColormod);
	}
}
void CheckMonsterPostSpawnFunctionality()
{ // Check Monster Post Spawn Functionality
	// Register Advanced Statistics
	RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_MONSTER);
		
	// Assign Movement Multiplier
	self.fMonsterMovementMultiplier = cvar(CVAR_MONSTER_MOVEMENTMULTIPLIER);
	if(self.fMonsterMovementMultiplier < 1)
		self.fMonsterMovementMultiplier = 1;
		
	self.fMonsterMovementMaximum = cvar(CVAR_MONSTER_MOVEMENTMAXIMUM);
	
	// Assign Default Force Multiplier
	self.fPreDamageForce_Multiplier = 1.0;
	
	// Assign Health at Spawn
	self.nEntityHealthAtSpawn = self.health;
	
	// Assign Body Contents Transition
	if(self.contentstransition == __NULL__)
		self.contentstransition = ContentsTransition_BodyInWater;
	
	// Check for Elite Monster Chance
	if(!self.bIsEliteMonster && !self.bCannotBecomeEliteMonster)
	{ // Valid Potential Elite Monster
		local float fPercentChance;
			fPercentChance = cvar(CVAR_ELITEMONSTER_BASEPERCENTCHANCE);
			// Recompute
			fPercentChance = 1.0 - (fPercentChance / 100);
		if( random() >= fPercentChance)
		{ // Become Elite Monster
			self.bInitiallyStealthedEliteMonster = TRUE;
			AssignEliteMonsterAttributes(self);
		}
	}
		
}
void MonsterAnimationSmack()
{ // Monster Animation Smack
	// Used for additional feedback when a monster's animation results in smacking a surface.
	if(self.flags & FL_ONGROUND && self.nNumCorpseTwitches == 0)
	{ // On Ground
		// Spawn Dust
		if(self.bBleedsSparks)
			te_CorpseDustSmash(self.origin, IMPACTTYPE_METAL);
		else
			te_CorpseDustSmash(self.origin, IMPACTTYPE_FLESH);
	}
}
void MonsterAnimationEarthQuake(float fPunchStrength, float fRadius)
{ // Monster Animation Earth Quake
	// Used for additional feedback when a monster's animation results in smacking a surface.
	
	if(self.flags & FL_ONGROUND)
	{ // On Ground
		local entity enFind;
		enFind = findradius(self.origin, fRadius);
		
		while(enFind)
		{ // Valid Entity
			if(enFind.flags & FL_ONGROUND && enFind != self)
			{ // On Ground
				// Apply Vertical Lift
				if( (enFind.flags & FL_MONSTER || enFind.classname == "player") )
					enFind.velocity_z = enFind.velocity_z + (fPunchStrength * 10) + ( random() * (fPunchStrength * 20));
					
				// Apply Punchangle
				if(enFind.classname == "player")
				{ // Valid Player
					//if( !(other.flags & FL_GODMODE || other.invincible_finished >= time) )
						// Not Invulnerable; Apply Punchangle
						enFind.punchangle = enFind.punchangle + (randomvec() * fPunchStrength);
				}
			}
			
			// Acquire Next Entity
			enFind = enFind.chain;
		}
	}
}
void CheckMonsterDropArmor(float fPercentChance, float nArmorType)
{ // Check Monster Drop Armor
	if(!self.bIsCorpse && cvar(CVAR_MONSTER_DROPADDITIONALITEMS) && random() <= fPercentChance)
	{ // Chance Met
		// Drop Armor
		DropNewArmor(nArmorType);
	}
}
void CheckMonsterDropPowerup(float fPercentChance, float nPowerupType, float tPowerupTime)
{ // Check Monster Drop Armor
	if(!self.bIsCorpse && cvar(CVAR_MONSTER_DROPADDITIONALITEMS) && random() <= fPercentChance)
	{ // Chance Met
		// Drop Armor
		DropNewPowerup(nPowerupType, tPowerupTime);
	}
}
float CheckMonsterPreSpawnFunctionality()
{ // Check Monster PreSpawn Functionality
	// NOTE: Returns if creature was removed
	local float bRemoved;
		
	// Support "nomonsters" CVar
	if( cvar("nomonsters") )
	{ // No Monsters; Remove
		bRemoved = TRUE;
	}
	else
	{ // Include Monster
		bRemoved = FALSE;
		// Assign Is Monster
		self.bIsMonster = TRUE;
		
		// Apply Random Monster Aesthetics
		ApplyRandomMonsterAesthetics();
		// Apply Creature Global Alpha Level
		if( cvar(CVAR_MONSTER_GLOBALALPHALEVEL) != 1)
			self.alpha = cvar(CVAR_MONSTER_GLOBALALPHALEVEL);
			
		// Assign Base Yaw Speed
		self.yaw_speed = 60;
		
		// Check Spawn Additional Monster
		CheckSpawnAdditionalMonster(self);
	}
	
	// Return Removal
	return bRemoved;
}
void MonsterFrame()
{ // Monster Frame
	// NOTE: This function either runs under StartFrame, executing once every frame
	// for the server, or is invoked by a entity through the think function.  The primary
	// purpose of utilizing a think entity is to reduce performance concerns on maps with
	// 500+ monsters.
	local entity enMonster;
	
	// Find Monsters
	enMonster = findfloat(world, bIsMonster, TRUE);
	
	while(enMonster)
	{ // Cycle through Monsters
		if(enMonster.health > 0)
		{ // Monster Alive
			// Check Monster Water Volume Damage
			if(!enMonster.bIgnoreWaterDamage && (enMonster.watertype == CONTENT_SLIME || enMonster.watertype == CONTENT_LAVA) )
				CheckMonsterWaterVolumeDamage(enMonster);
		}
		
		// Acquire Next Monster
		enMonster = findfloat(enMonster, bIsMonster, TRUE);
	}
	
	#ifdef MONSTERFRAMESYSTEM_USETHINKENTITY
	self.nextthink = time + MONSTERFRAMESYSTEM_USETHINKENTITY_TIME;
	#endif
}
void PrepareMonsterFrameSystem()
{ // Prepare Monster Frame System
	#ifdef MONSTERFRAMESYSTEM_USETHINKENTITY
	// Spawn Entity
	g_enMonsterFrameThinkEntity = spawn();
	g_enMonsterFrameThinkEntity.solid = SOLID_NOT;
	g_enMonsterFrameThinkEntity.effects = EF_NODRAW;
	
	// Assign Think Functionality
	g_enMonsterFrameThinkEntity.nextthink = time + MONSTERFRAMESYSTEM_USETHINKENTITY_TIME;
	g_enMonsterFrameThinkEntity.think = MonsterFrame;
	#endif
}
void RemoveAllMonsterCorpses(entity enClient)
{ // Remove All Monster Corpses
	// NOTE: Used for maps like say, oh I don't know,
	// THE MASQUE OF RED DEATH (best map ever)
	local entity enFind;
	local float nCorpseCnt;
		nCorpseCnt = 0;
	
	// Loop through Monsters
	enFind = findfloat(world, bIsMonster, TRUE);
	
	while(enFind != world)
	{ // Valid Monster
		if(enFind.health <= 0)
		{ // Dead; Remove
			remove(enFind);
			nCorpseCnt = nCorpseCnt + 1;
		}
			
		// Acquire Next Monster
		enFind = findfloat(enFind, bIsMonster, TRUE);
	}
	
	// Report Corpses Removed
	local string strMessage;
		strMessage = strcat("Removed ^2", ftos(nCorpseCnt), "^7 Monster Corpses\n");
		if(enClient != world)
			strMessage = strcat(enClient.netname, "^7 invoked ^2RemoveAllMonsterCorpses^7; ", strMessage);
	bprint(strMessage);
}
void KillAllMonsters(entity enClient)
{ // Kill All Monsters
	local entity enFind;
	local float nMonsterCnt;
		nMonsterCnt = 0;
	
	// Loop through Monsters
	enFind = findfloat(world, bIsMonster, TRUE);
	
	while(enFind != world)
	{ // Valid Monster
		if(enFind.health > 0 && enFind.takedamage)
		{ // Alive; Kill
			// Ignore Damage Momentum
			enFind.bIgnoreDamageMomentum = TRUE;
			T_Damage (enFind, enClient, enClient, HITLOCATION_NONE, DAMAGETYPE_OTHER, 10000);
			// Remove Ignore Damage Momentum
			enFind.bIgnoreDamageMomentum = FALSE;
			
			nMonsterCnt = nMonsterCnt + 1;
		}
			
		// Acquire Next Monster
		enFind = findfloat(enFind, bIsMonster, TRUE);
	}
	
	// Report Monsters Killed
	local string strMessage;
		strMessage = strcat("Killed ^2", ftos(nMonsterCnt), "^7 Monsters\n");
		if(enClient != world)
			strMessage = strcat(enClient.netname, "^7 invoked ^2KillAllMonsters^7; ", strMessage);
	bprint(strMessage);
}
void PlayMonsterSwingSound(float nSwingType)
{ // Play Monster Swing Sound
	local string strSound;
	local float nRandom;
	
	if(nSwingType == MONSTER_SWINGTYPE_STANDARD)
	{
		nRandom = random();
		if(nRandom < 0.33)
			strSound = SOUND_KLESHIK_MONSTERS_MONSTERSWING1;
		else
		if(nRandom < 0.66)
			strSound = SOUND_KLESHIK_MONSTERS_MONSTERSWING2;
		else
			strSound = SOUND_KLESHIK_MONSTERS_MONSTERSWING3;
	}
	else
	if(nSwingType == MONSTER_SWINGTYPE_LARGE)
		strSound = SOUND_KLESHIK_MONSTERS_MONSTERSWINGLARGE;
	else
		strSound = "";
		
	// Play Sound
	sound(self, CHAN_AUTO, strSound, 1, ATTN_NORM);
}