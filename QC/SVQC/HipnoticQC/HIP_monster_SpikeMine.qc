void spikemine_Home()
   {
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector dir, vtemp;

   self.frame = self.frame + 1;
   if (self.frame==9) self.frame = 0;
   self.nextthink = time + 0.2;
   self.think = spikemine_Home;

// look in our immediate vicinity

   if (self.search_time < time)
      {
      selected = world;
      cur_dist = 2000;
      head = findradius(self.origin, 2000);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
            {
            if (visible(head) && (head.health > 0))
               {
               head_dist = vlen(head.origin-self.origin);
               if (head_dist < cur_dist)
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
//      if (selected != world && selected != self.enemy)
      if (selected != world)
         sound (self, CHAN_VOICE, "hipitems/spikmine.wav", 1, ATTN_NORM);
      self.enemy = selected;
      self.search_time = time + 1.3;
      }
   if (self.enemy == world)
      {
      sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
      self.velocity = '0 0 0';
      return;
      }
   vtemp = self.enemy.origin + '0 0 10';
	dir = normalize(vtemp - self.origin);
   if (infront(self.enemy))
      {
      self.velocity = dir * ((skill*50) + 50);
      }
   else
      {
      self.velocity = dir * ((skill*50) + 150);
      }
   };

void spikemine_Touch()
{
	// DRESK
	// Remove Potential Takedamage
	self.takedamage = DAMAGE_NO;
	
	if (self.health > 0)
	{
		if (other.classname == "trap_spike_mine")
			return;
		if (other.classname == "missile")
			return;
		if (other.classname == "grenade")
			return;
		if (other.classname == "hiplaser")
			return;
		if (other.classname == "proximity_grenade")
			return;

		T_Damage(self,self,self, HITLOCATION_SELFORIGIN, DAMAGETYPE_TRAP_SPIKEMINE,self.health+10);
		//      killed_monsters = killed_monsters + 1;
		//      WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}
	//   self.effects = self.effects | EF_MUZZLEFLASH;

	T_RadiusDamage (self, self, DAMAGETYPE_TRAP_SPIKEMINE, 110, world);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	// DRESK
	// Check Update Advanced Statistics
	CheckUpdatedAdvancedStatistics();

	sound (self, CHAN_VOICE, "misc/null.wav", 1, ATTN_NORM);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
}

/*
spike_mine_first_think
*/

void spike_mine_first_think()
   {
   self.think = spikemine_Home;
   self.nextthink = time + 0.1;
   self.search_time = 0;
   self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
   };

/*QUAKED trap_spike_mine (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void trap_spike_mine()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	self.strMonsterDisplayName = "Spike Mine";
	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	self.flags = self.flags | FL_MONSTER;

	// DRESK
	// Check Monster Extra Spawn Functionality
	if( CheckMonsterPreSpawnFunctionality() )
		return;
		
	// NOTE : This is necessary to call here due to no normal monster
	// walkmove configuration.
	CheckMonsterPostSpawnFunctionality();
	
	// DRESK
	// Assigns Bleeds Sparks
	self.bBleedsSparks = TRUE;
	
	// DRESK
	// Remove Ability to Become Elite Monster
	self.bCannotBecomeEliteMonster = TRUE;
	// Assign Cannot Spawn Fliskers
	self.bCannotSpawnFliskers = TRUE;
	
	setmodel (self, "progs/spikmine.mdl");
	//   setmodel (self, "progs/spike.mdl");
	setsize (self, self.mins, self.maxs);
	self.classname = "trap_spike_mine";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;
	//   setsize (self, '0 0 0', '0 0 0');
	//   self.avelocity = '-100 100 -100';
	self.avelocity = '-50 100 150';
	
	if (cvar("skill") <= 1)
		self.health = 200;
	else
		self.health = 400;
	
	self.frame = 0;
	self.think = spike_mine_first_think;
	self.touch = spikemine_Touch;
	self.th_die = spikemine_Touch;
	self.th_stand = spikemine_Home;
	self.th_walk = spikemine_Home;
	self.th_run = spikemine_Home;
	self.th_melee = spikemine_Home;
	self.th_missile = spikemine_Home;
	self.nextthink = time + 0.2;
	total_monsters = total_monsters + 1;
	self.deathtype = "was blasted by a spike mine";
}
void trap_spike_mine_Precache()
{
	precache_model ("progs/spikmine.mdl");
	precache_sound ("weapons/r_exp3.wav");
	precache_sound ("hipitems/spikmine.wav");
	precache_sound ("misc/null.wav");
}