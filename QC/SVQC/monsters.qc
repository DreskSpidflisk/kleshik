/* ALL MONSTERS SHOULD BE 1 0 0 IN COLOR */

#define MONSTER_MAXRANDOMSTARTTIME			0.05

// name =[framenum,	nexttime, nextthink] {code}
// expands to:
// name ()
// {
//		self.frame=framenum;
//		self.nextthink = time + nexttime;
//		self.think = nextthink
//		<code>
// };


/*
================
monster_use

Using a monster makes it angry at the current activator
================
*/
void monster_use()
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.nCSQCStat_Powerups & POWERUP_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	
// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

/*
================
monster_death_use

When a mosnter dies, it fires all of its targets with the current
enemy as activator.
================
*/
void monster_death_use()
{
	// DRESK
	// Unused Variable(s)
	// local entity 	ent, otemp, stemp;

// fall to ground
	if (self.flags & FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags & FL_SWIM)
		self.flags = self.flags - FL_SWIM;

	if (!self.target)
		return;

	activator = self.enemy;
	SUB_UseTargets ();
};


//============================================================================

void walkmonster_start_go()
{
	// DRESK
	// Unused Variable(s)
	// local string	stemp;
	// local entity	etemp;

	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	droptofloor();
	
	// DRESK
	if(self.bMonsterIsClone)
	{ // Clone Monster; Reapply Properties
		// Apply Solidity
		self.solid = self.nSolidityAtSpawn;
		// Apply Movetype
		self.movetype = self.nMovetypeAtSpawn;
	}
	
	if (!walkmove(0,0))
	{
		// DRESK
		// Increment Debug Counter
		g_nNumWallStuckMonsters = g_nNumWallStuckMonsters + 1;
		// self.colormod = '1 0 0';
		
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}
	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	
	self.flags = self.flags | FL_MONSTER;
	
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	if(self.bMonsterIsClone)
	{ // Cloned Monster
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 1)
			// Monster should NOT Roam
			self.pausetime = 99999999;
		self.th_stand ();
	}
	else
	{
		// DRESK
		// Check for Potential Roam
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 2)
			self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
};


void walkmonster_start()
{
	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time

	// DRESK - HIPNOTIC SUPPORT
	// FIXME : Should this flag assignment also apply to vanilla Quake?
	if(g_bHipnoticEnabled)
		self.flags = self.flags | FL_MONSTER;
		
	// DRESK
	//Support Delayed Start Times
	if(self.tMonsterStartTimeDelay)
		self.nextthink = time + self.tMonsterStartTimeDelay;
	else
	{
		self.nextthink = time;
		// self.nextthink = time + random()*0.5;
	}
		
	self.think = walkmonster_start_go;
	if(!self.bMonsterIsClone && !self.bMonsterIgnoreStatTracking)
		total_monsters = total_monsters + 1;
	
	// DRESK
	// Check Monster Post Spawn Functionality
	CheckMonsterPostSpawnFunctionality();
};



void flymonster_start_go()
{
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 25';
	self.use = monster_use;

	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	
	// DRESK
	if(self.bMonsterIsClone)
	{ // Clone Monster; Reapply Properties
		// Apply Solidity
		self.solid = self.nSolidityAtSpawn;
		// Apply Movetype
		self.movetype = self.nMovetypeAtSpawn;
	}

	if (!walkmove(0,0))
	{
		// DRESK
		// Increment Debug Counter
		g_nNumWallStuckMonsters = g_nNumWallStuckMonsters + 1;
		
		dprint ("flymonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk ();
		else
			self.pausetime = 99999999;
			self.th_stand ();
	}
	else
	if(self.bMonsterIsClone)
	{ // Cloned Monster
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 1)
			// Monster should NOT Roam
			self.pausetime = 99999999;
		self.th_stand ();
	}
	else
	{
		// DRESK
		// Check for Potential Roam
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 2)
			self.pausetime = 99999999;
		self.th_stand ();
	}
};

void flymonster_start()
{
// spread think times so they don't all happen at same time
	// DRESK - HIPNOTIC SUPPORT
	// FIXME : Should this flag assignment also apply to vanilla Quake?
	if(g_bHipnoticEnabled)
		self.flags = self.flags | FL_MONSTER;
		
	// DRESK
	//Support Delayed Start Times
	if(self.tMonsterStartTimeDelay)
		self.nextthink = time + self.tMonsterStartTimeDelay;
	else
	{
		self.nextthink = time;
		// self.nextthink = time + random()*MONSTER_MAXRANDOMSTARTTIME;
	}
		
	self.think = flymonster_start_go;
	if(!self.bMonsterIsClone && !self.bMonsterIgnoreStatTracking)
		total_monsters = total_monsters + 1;
	
	// DRESK
	// Check Monster Post Spawn Functionality
	CheckMonsterPostSpawnFunctionality();
}

void swimmonster_start_go()
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
	
	// DRESK
	// Double Monster Count Increment Bug
	// total_monsters = total_monsters + 1;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 10;
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	
	// DRESK
	if(self.bMonsterIsClone)
	{ // Clone Monster; Reapply Properties
		// Apply Solidity
		self.solid = self.nSolidityAtSpawn;
		// Apply Movetype
		self.movetype = self.nMovetypeAtSpawn;
	}

	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint ("Monster can't find target at ");
			dprint (vtos(self.origin));
			dprint ("\n");
		}
// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk ();
	}
	else
	if(self.bMonsterIsClone)
	{ // Cloned Monster
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 1)
			// Monster should NOT Roam
			self.pausetime = 99999999;
		self.th_stand ();
	}
	else
	{
		// DRESK
		// Check for Potential Roam
		if( SG_AUTOCVAR(kleshik_server_monster_MonstersRoam) < 2)
			self.pausetime = 99999999;
		self.th_stand ();
	}

// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;
}

void swimmonster_start()
{
// spread think times so they don't all happen at same time
	// DRESK - HIPNOTIC SUPPORT
	// FIXME : Should this flag assignment also apply to vanilla Quake?
	if(g_bHipnoticEnabled)
		self.flags = self.flags | FL_MONSTER;
		
	// DRESK
	//Support Delayed Start Times
	if(self.tMonsterStartTimeDelay)
		self.nextthink = time + self.tMonsterStartTimeDelay;
	else
	{
		self.nextthink = time;
		// self.nextthink = time + random()*MONSTER_MAXRANDOMSTARTTIME;
	}
		
	self.think = swimmonster_start_go;
	if(!self.bMonsterIsClone && !self.bMonsterIgnoreStatTracking)
		total_monsters = total_monsters + 1;
	
	// DRESK
	// Check Monster Post Spawn Functionality
	CheckMonsterPostSpawnFunctionality();
};


