// DRESK
// Travail Triggers

// Definitions

// Fields

// Functions
void trigger_void_touch()
{

	//bprint ("void\n");
	if (other.classname == "monster_vermis")
		return;


	if (other.takedamage)
	{
		/*if (other.shield == 1)
			T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_ENVIRONMENT_VOID, other.health * 2 + 1);
		else*/
			T_Damage (other, self, self, HITLOCATION_NONE, DAMAGETYPE_ENVIRONMENT_VOID, other.health + 1);

		if (other.flags & FL_MONSTER)
		{
			remove(other);
			force_retouch = 2;
			return;
		}
	}

	if (other.classname == "gib" || other.classname == "grenade" || other.classname == "spike" || other.classname == "missile")
	{
		remove(other);
		force_retouch = 2;
		return;
	}

	if (other.flags & FL_ITEM)
		remove(other);

	force_retouch = 2;

};

/*QUAKED trigger_void (.5 .5 .5) ?
Use this for a 'void' area.  removes monsters, gibs, ammo, etc...  also kills player.
*/
void trigger_void()
{
	GameModeFeatureDetected_Travail();
	InitTrigger ();
	self.touch = trigger_void_touch;
}
void Travail_Special_teleport_touch()
{ // Teleport Touch for Spawnflags Teleporter
	local entity	t;
	local vector	org;

	if (self.targetname)
	{
		if (self.nextthink < time)
		{
			return;		// not fired yet
		}
	}

	if (self.spawnflags & PLAYER_ONLY)
	{
		if (other.classname != "player")
			return;
	}

// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	if(other.classname == "player")
		CheckUpdatedAdvancedStatistics();

	SUB_UseTargets ();

	t = find (world, targetname, self.target);
	if (!t)
		objerror ("couldn't find target");
		
	makevectors (t.mangle);
	org = t.origin;
	spawn_tdeath(t.origin, other);

	setorigin (other, t.origin);
	other.angles = t.mangle;
	if (other.classname == "player")
	{
		other.teleport_time = time + 0.7;
		if (other.flags & FL_ONGROUND)
			other.flags = other.flags - FL_ONGROUND;
	}
	other.flags = other.flags - other.flags & FL_ONGROUND;
}