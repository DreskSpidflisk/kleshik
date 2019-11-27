// DRESK
// Spawned Monsters

// Fields
.float		bDisableMonsterCloning;
.entity		enSpawnedMonster_OriginalMonster;

.float		bMonsterIgnoreStatTracking;
.float		nNumClonedMonsters;

float		g_nNumSpawnedMonsters;
float		g_nNumKilledSpawnedMonsters;
float		g_nNumInvalidSpawnedMonsterAttempts;

float CheckSpawnAdditionalMonster(entity enMonster)
{
	local float bInvalid;
	if(!enMonster.bDisableMonsterCloning && !enMonster.bMonsterIsClone && !enMonster.target && !enMonster.bIsHipnoticSpawnCreature)
	{ // Not a clone; not a class replacement; not an "objective" monster; not a Hipnotic Spawn Creature
		// Acquire Number of Monsters to Spawn
		local float nSpawn;
			nSpawn = cvar(CVAR_MONSTER_SPAWNADDITIONALCREATURES);
		local float nCnt;
		local float nRandom;
		// Backup Self
		local entity enOldSelf;
			enOldSelf = self;
			
		while(nCnt < nSpawn)
		{ // Spawn Clones
			// Disable Possible Future Spawning
			enMonster.bDisableMonsterCloning = TRUE;
			// Increment Counter
			nCnt = nCnt + 1;
			// Reset Invalid
			bInvalid = FALSE;
			
			// Spawn
			self = spawn();
			
			// Assign Previous Origin
			setorigin(self, enMonster.origin);
			// Assign Original Monster
			self.enSpawnedMonster_OriginalMonster = enMonster;
			// Raise off Floor (prior to random displacement)
			self.origin_z = self.origin_z + 1;
			// Assign Previous Angles
			self.angles = enMonster.angles;
			// Random Angles
			self.angles_y = random() * 360;
				
			// Assign Monster IsClone
			self.bMonsterIsClone = TRUE;
			// Assign Owner Classname
			self.classname = enMonster.classname;
			// Assign New Start Time Delay
			// NOTE: Necessary to allow for non-clipping cloned monsters
			// at spawn.
			self.tMonsterStartTimeDelay = 2.0 + random();
			
			// Invoke Spawn Class
			if(enMonster.classname == "monster_army")
				monster_army();
			else
			if(enMonster.classname == "monster_demon1")
				monster_demon1();
			else
			if(enMonster.classname == "monster_dog")
				monster_dog();
			else
			if(enMonster.classname == "monster_enforcer")
				monster_enforcer();
			else
			if(enMonster.classname == "monster_fish")
				monster_fish();
			else
			if(enMonster.classname == "monster_hell_knight")
				monster_hell_knight();
			else
			if(enMonster.classname == "monster_knight")
				monster_knight();
			else
			if(enMonster.classname == "monster_ogre")
				monster_ogre();
			else
			if(enMonster.classname == "monster_shalrath")
			{
				// Mix Shalrath Up
				nRandom = random() * 3;
				if(nRandom < 1)
				{
					self.classname = "monster_tarbaby";
					monster_tarbaby();
				}
				else
				if(nRandom < 2)
				{
					self.classname = "monster_ogre";
					monster_ogre();
				}
				else
				{ // Bad Shalrath!
					monster_shalrath();
				}
			}
			else
			if(enMonster.classname == "monster_shambler")
			{
				// Mix Shambler Up
				nRandom = random() * 4;
				if(nRandom < 1)
				{
					self.classname = "monster_hell_knight";
					monster_hell_knight();
				}
				else
				if(nRandom < 2)
				{
					self.classname = "monster_demon1";
					monster_demon1();
				}
				else
				if(nRandom < 3)
				{
					self.classname = "monster_ogre";
					monster_ogre();
				}
				else
				{ // You got the shambler!  Oh noes!
					monster_shambler();
				}
			}
			else
			if(enMonster.classname == "monster_tarbaby")
				monster_tarbaby();
			else
			if(enMonster.classname == "monster_wizard")
				monster_wizard();
			else
			if(enMonster.classname == "monster_zombie")
				monster_zombie();
			// HIPNOTIC SUPPORT
			else
			if(enMonster.classname == "monster_gremlin")
				monster_gremlin();
			else
			if(enMonster.classname == "monster_scourge")
				monster_scourge();
			else
			if(enMonster.classname == "monster_armagon")
				monster_armagon();
			// ROGUE SUPPORT
			else
			if(enMonster.classname == "monster_eel")
				monster_eel();
			else
			if(enMonster.classname == "monster_sword")
				monster_sword();
			else
			if(enMonster.classname == "monster_mummy")
				monster_mummy();
			else
			if(enMonster.classname == "monster_wrath")
				monster_wrath();
			else
			if(enMonster.classname == "monster_super_wrath")
				monster_super_wrath();
			else
			if(enMonster.classname == "monster_morph")
				monster_morph();
			else
			{ // Monster Not Supported; Remove Additional Spawn
				g_nNumInvalidSpawnedMonsterAttempts = g_nNumInvalidSpawnedMonsterAttempts + 1;
				remove(self);
				bInvalid = TRUE;
			}
			
			if(!bInvalid)
			{ // Assign Random Velocity
				// Apply Solidity at Spawn
				self.nSolidityAtSpawn = self.solid;
				// Assign Movetype at Spawn
				self.nMovetypeAtSpawn = self.movetype;
				
				// Assign Initial Lack of Solidity
				// NOTE : Will be removed in start procedure.
				self.solid = SOLID_NOT;
				// Assign Movetype
				self.movetype = MOVETYPE_TOSS;
				
				self.velocity_x = 50 + (random() * 700);
				if( random() >= 0.50)
					self.velocity_x = self.velocity_x * -1;
				self.velocity_y = 50 + (random() * 700);
				if( random() >= 0.50)
					self.velocity_y = self.velocity_y * -1;
				self.velocity_z = 100 + (random() * 300);
				
				// Increment Number of Spawned Monsters
				g_nNumSpawnedMonsters = g_nNumSpawnedMonsters + 1;
				enOldSelf.nNumClonedMonsters = enOldSelf.nNumClonedMonsters + 1;
			}
		}
		// Restore Self
		self = enOldSelf;
	}
	return bInvalid;
}