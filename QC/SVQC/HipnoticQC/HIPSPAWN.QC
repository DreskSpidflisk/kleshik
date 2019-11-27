//=====================================================================
//
// Spawning Functions (Hipnotic)
//
//=====================================================================

// DRESK
// Additional Fields
.float		bIsHipnoticSpawnEntity;

// spawn variables
.void()     spawnfunction;
.string     spawnclassname;
.float      spawnsolidtype;
.string     spawnmodel;
.void()     spawnthink;
.entity     spawnmaster;
.vector     spawnmins;
.vector     spawnmaxs;
.float      spawnsilent;
.float      spawnmulti;

// DRESK
// Debug Statement
void ListHipnoticSpawnEntities(entity enClient)
{ // List Hipnotic Spawn Entities
	local entity enFind;
	local string strMessage;
	local float nCnt;
	
	enFind = findfloat(world, bIsHipnoticSpawnEntity, TRUE);
	while(enFind)
	{
		nCnt = nCnt + 1;
		strMessage = strcat(etos(enFind), " (", enFind.classname, ") '", enFind.spawnmaster.classname);
		strMessage = strcat(strMessage, "' (", etos(enFind.spawnmaster), ")\n");
		sprint(enClient, strMessage);
		enFind = findfloat(enFind, bIsHipnoticSpawnEntity, TRUE);
	}
	
	strMessage = strcat("'", ftos(nCnt), "' Total Spawn Entities\n");
	sprint(enClient, strMessage);
}
void ListNODRAWMonsters(entity enClient)
{ // List NODRAW Monsters
	local entity enFind;
	local string strMessage;
	local float nCnt;
	
	enFind = findfloat(world, bIsMonster, TRUE);
	while(enFind)
	{
		if(enFind.effects & EF_NODRAW)
		{ // No Draw Enabled
			nCnt = nCnt + 1;
			strMessage = strcat(etos(enFind), " (", enFind.classname, ") '\n");
			sprint(enClient, strMessage);
		}
		enFind = findfloat(enFind, bIsHipnoticSpawnEntity, TRUE);
	}
	
	strMessage = strcat("'", ftos(nCnt), "' Total NODRAW Monsters\n");
	sprint(enClient, strMessage);
}

//================
//
// spawn_think
//
//================

void spawn_think()
{
	// NOTE: Think Operation for monsters to be spawned.
	self.think = spawn_think;
	self.nextthink = time + 1;
	
	bprint( etos(self), " Spawning '", self.classname, "'\n");
	
	// DRESK
	// Append NODRAW Effect
	self.effects = self.effects | EF_NODRAW;
}

//================
//
// spawn_use
//
//================

void spawn_use()
{
   local entity spawnentity;
   // local entity tempself;
   
	// DRESK
	// Check Update Advanced Statistics
	CheckUpdatedAdvancedStatistics();

	if ((self.spawnmulti == 1) || (horn_active))
	{
		// spawn the new entity
		spawnentity = spawn();
		// copy the master mold
		SUB_CopyEntity(self.spawnmaster,spawnentity);
	}
	else
	{
		spawnentity = self.spawnmaster;
	}
	if(!spawnentity)
	{
		bprint( strcat("^1WARNING ^7 : Spawn Entity Bad on '", etos(self), "'!\n") );
		return;
	}
	// DRESK
	// Remove NODRAW Effect
	spawnentity.effects = spawnentity.effects - (spawnentity.effects & EF_NODRAW);
	// Reassign Take Damage
	// NOTE: Not necessary since walkmonster functions assign take damage
	// spawnentity.takedamage = spawnentity.nHipnoticSpawn_InitialTakeDamage;
	// Assign Spawn Creature Spawned
	spawnentity.bHipnoticSpawnCreature_Spawned = TRUE;
	
	// restore the model
	// spawnentity.model = spawnentity.spawnmodel;
	//restore solid flag
	spawnentity.solid = spawnentity.spawnsolidtype;
	//restore thinking function
	spawnentity.think = spawnentity.spawnthink;
	spawnentity.nextthink = time;
	// setmodel (spawnentity, spawnentity.model);
	setorigin (spawnentity, spawnentity.origin);
	/*
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize (spawnentity, spawnentity.mins, spawnentity.maxs);
	*/
	
	// spawn the teleport effect
	// DRESK
	// Always use spawn effect
	// if (self.spawnsilent == 0)
		spawn_tfog (spawnentity.origin, spawnentity);
		
//   horn_active = 0;
//   horn_charmer = find( world, classname, "player" );
   // call spawnentity think function
   if (horn_active)
      {
      spawnentity.charmer = horn_charmer;
      spawnentity.charmed = 1;
      }
//   if (spawnentity.think)
//      {
//      spawnentity.nextthink = time+0.1;
//      tempself = self;
//      self = spawnentity;
//      self.think();
//      self = tempself;
//      spawnentity.nextthink = time+0.1;
//      self.nextthink = 1;
//      if (spawnentity.nextthink < time)
//         spawnentity.nextthink = 1;
//      }
	// check to see if it is a monster
	if (spawnentity.flags & FL_MONSTER)
	{
		// DRESK
		// Disable Monster Increment
		/*
		if ((self.spawnmulti != 0) && (horn_active == 0))
		{
			total_monsters = total_monsters + 1;
			WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
			WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
			WriteLong (MSG_BROADCAST, total_monsters);
		}
		*/
		// spawn the telefrag effect
		//      if (self.spawnsilent == 0)
		//         spawn_tdeath(spawnentity.origin, spawnentity);
		if (horn_active)
		{
			spawnentity.effects = spawnentity.effects | EF_DIMLIGHT;
			//         spawnentity.effects = spawnentity.effects | EF_BRIGHTFIELD;
		}
	}
	if ((self.spawnmulti == 0) && (horn_active == 0))
	{
		remove(self);
	}
}

//================
//
// func_spawn
//
//================
/*QUAKED func_spawn (0 .5 .8) (-32 -32 -24) (32 32 64) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

void func_spawn()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	// DRESK
	// Register Advanced Statistic
	if(self.spawnmulti)
	{ // Multi Monster Spawn
		// Override Classname for Advanced Statistics
		self.classname = "func_spawn_multimonster";
	}
	else
	if(!self.spawnfunction)
	{ // Random Monster Spawn
		// Override Classname for Advanced Statistics
		self.classname = "func_spawn_random";
	}
	else
	if( substring(self.spawnclassname, 0, 7) != "monster" && self.spawnclassname != "trap_spike_mine")
	{ // Non-Monster Spawn
		// Override Classname for Advanced Statistics
		self.classname = "func_spawn_nonmonster";
	}
	RegisterAdvancedGameStatistic(ADVANCEDSTATISTIC_TYPE_OTHER);
	
	local entity enSpawner;
	local entity enMonsterToSpawn;
	local string strClassname;
	local void() fpSpawn;
	local float nDeathmatchBackup;
	
	// local float temptotal_monsters;
	
	// Prepare Spawn Entity
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.use = spawn_use;
	// DRESK
	// Remove Drawing on Spawn Entity
	self.effects = self.effects | EF_NODRAW;
	self.bIsHipnoticSpawnEntity = TRUE;

	// save off deathmatch and zero it out
	enSpawner = self;
	nDeathmatchBackup = deathmatch;
	deathmatch = 0;
	
	if (!self.spawnfunction)
	{ // No Spawn Function Provided
		// DRESK
		// Redone Random Spawn Logic
		local float fRandom;
			fRandom = random();
		if(fRandom < 0.5)
		{ // Utilize Dog
			fpSpawn = monster_dog;
			strClassname = "monster_dog";
		}
		else
		if(fRandom < 0.8)
		{ // Utilize Ogre
			fpSpawn = monster_ogre;
			strClassname = "monster_ogre";
		}
		else
		if(fRandom < 0.92)
		{ // Utilize Demon
			fpSpawn = monster_demon1;
			strClassname = "monster_demon1";
		}
		else
		if(fRandom < 0.92)
		{ // Utilize Zombie
			fpSpawn = monster_zombie;
			strClassname = "monster_zombie";
		}
		else
		{ // Utilize Shambler
			fpSpawn = monster_shambler;
			strClassname = "monster_shambler";
		}
	}
	else
	{ // Spawn Function Provided
		fpSpawn = self.spawnfunction;
		if (self.spawnclassname == string_null)
			objerror("No spawnclassname defined");
		else
			strClassname = self.spawnclassname;
	}
	
	// Begin Spawn Monster
	self = spawn();
	// Copy Over Entity Details
	SUB_CopyEntity(enSpawner, self);
	// Remove Use Function (otherwise monster acquires spawn_use)
	self.use = __NULL__;
	// Invoke Spawn
	// Assign Is Hipnotic Spawn Creature
	self.bIsHipnoticSpawnCreature = TRUE;
	// Copy Classname
	self.classname = strClassname;
	self.spawnclassname = self.classname;
	// Copy Spawn Function to Local Function for Execution
	self.spawnfunction = fpSpawn;
		self.spawnfunction();
	// save off solid flag
	self.spawnsolidtype = self.solid;
	self.solid = SOLID_NOT;
	// get rid of his thinking
	self.spawnthink = self.think;
	// DRESK
	// Purge Thinking Completely
	self.think = __NULL__;
	self.nextthink = 0;
	/*
	self.think = spawn_think;
	self.nextthink = time + 1;
	*/
	// Remove Take Damage
	self.takedamage = DAMAGE_NO;
	// Remove Drawing on Monster
	self.effects = self.effects | EF_NODRAW;
	// Assign Origin
	self.origin = enSpawner.origin;
	// Finish Monster
	enMonsterToSpawn = self;
	
	// Restore func_spawn to self
	self = enSpawner;
	self.spawnmaster = enMonsterToSpawn;
	
	// Restore Deathmatch
	deathmatch = nDeathmatchBackup;
}

// DRESK
// OLD SPAWN CODE
/*
		
		// Spawn Monster
			self = spawn();
			SUB_CopyEntity(enSpawner, self);
			self.spawnfunction = fpSpawn;
			self.spawnclassname = strClassname;
			self.classname = self.spawnclassname;
			// Invoke Spawn
			// DRESK
			// Assign Is Hipnotic Spawn Creature
			self.bIsHipnoticSpawnCreature = TRUE;
			self.spawnfunction();
			// DRESK
			// Reread Classname (incase of monster substitution)
			self.spawnclassname = self.classname;
			
			self.spawnmodel = self.model;
			self.spawnmins = self.mins;
			self.spawnmaxs = self.maxs;
			setsize (self, self.spawnmins, self.spawnmaxs);
			//save off solid flag
			self.spawnsolidtype = self.solid;
			self.solid = SOLID_NOT;
			//save off think func and
			//get rid of his thinking
			self.spawnthink = self.think;
			self.think = spawn_think;
			self.nextthink = time + 1;
		// Finish
		enMonsterToSpawn = self;
		/*
			
		local float spawnchance;

		spawnchance = random();
		monster = tempself;

		// save off monster count so it doesn't get f'ed up
		temptotal_monsters = total_monsters;

		// spawn dog
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(tempself,self);
		self.spawnfunction = monster_dog;
		self.spawnclassname = "monster_dog";
		self.classname = self.spawnclassname;

		// call the named spawn function
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, "");
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;

		if (spawnchance<0.5 && monster==tempself)
		{
			monster = self;
		}

		// spawn ogre
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(tempself,self);
		self.spawnfunction = monster_ogre;
		self.spawnclassname = "monster_ogre";
		self.classname = self.spawnclassname;

		// call the named spawn function
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, "");
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;

		if (spawnchance<0.8 && monster==tempself)
		{
			monster = self;
		}

		// spawn fiend
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(tempself,self);
		self.spawnfunction = monster_demon1;
		self.spawnclassname = "monster_demon1";
		self.classname = self.spawnclassname;

		// call the named spawn function
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, "");
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;

		if (spawnchance<0.92 && monster==tempself)
		{
			monster = self;
		}

		// spawn zombie
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(tempself,self);
		self.spawnfunction = monster_zombie;
		self.spawnclassname = "monster_zombie";
		self.classname = self.spawnclassname;

		// call the named spawn function
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, "");
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;

		if (spawnchance<0.97 && monster==tempself)
		{
			monster = self;
		}

		// spawn shambler
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(tempself,self);
		self.spawnfunction = monster_shambler;
		self.spawnclassname = "monster_shambler";
		self.classname = self.spawnclassname;

		// call the named spawn function
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel (self, "");
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;

		if (monster==tempself)
		{
			monster = self;
		}
		// make sure monster count is correct
		total_monsters = temptotal_monsters + 1;
		*/
	/*
	}
	else
	{
		// spawn the new entity
		self = spawn();
		// copy over everything
		SUB_CopyEntity(enSpawner, self);

		// save off monster count so it doesn't get f'ed up
		// temptotal_monsters = total_monsters;
		if (self.spawnclassname == string_null)
		{
			objerror("No spawnclassname defined");
		}
		self.classname = self.spawnclassname;

		// call the named spawn function
		// DRESK
		// Assign Is Hipnotic Spawn Creature
		self.bIsHipnoticSpawnCreature = TRUE;
		self.spawnfunction();
		
		// DRESK
		// Reread Classname (incase of monster substitution)
		self.spawnclassname = self.classname;
		
		if (self.spawnmulti != 0)
		{
			// make sure monster count is correct
			// total_monsters = temptotal_monsters;
		}
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setsize (self, self.spawnmins, self.spawnmaxs);
		//save off solid flag
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		//save off think func and
		//get rid of his thinking
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + 1;
		enMonsterToSpawn = self;
	}
	*/

//================
//
// func_spawn_small
//
//================
/*QUAKED func_spawn_small (0 .5 .8) (-16 -16 -24) (16 16 40) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

void func_spawn_small()
{
   func_spawn();
}
