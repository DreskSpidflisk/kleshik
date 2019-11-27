// Misc. CSQC Functions

// Definitions

// Fields

// Functions
/*
// NOTE : No longer used.
void CSQCQuickSoundEntity(entity enController, vector vOrigin, string strSound, float nChannel)
{ // Weapon Sound Entity
	local float bRemove;
		bRemove = false;
	if(enController == world)
	{ // Spawn Temporary Entity
		enController = spawn();
		bRemove = true;
	}
	// Assign Origin
	enController.origin = vOrigin;
	
	// Play Sound
	sound(enController, nChannel, strSound, 1.0, ATTN_NORM);
	
	// Remove Entity Immediately
	if(bRemove)
		remove(enController);
}
*/
float GetStatIndexFromAmmoType(float nAmmoType)
{ // Return Stat Index from Ammo Type
	local float nReturn;
	switch(nAmmoType)
	{
		case AMMOTYPE_SHELLS:
			nReturn = STAT_SHELLS;
			break;
		case AMMOTYPE_NAILS:
			nReturn = STAT_NAILS;
			break;
		case AMMOTYPE_ROCKETS:
			nReturn = STAT_ROCKETS;
			break;
		case AMMOTYPE_CELLS:
			nReturn = STAT_CELLS;
			break;
		default:
			nReturn = -1;
			break;
	}
	return nReturn;
}
void ParseServerWeaponsAvailable(string strWeapons)
{ // Parse Server Weapons Available
	g_nWeaponsAvailable = stof(strWeapons);
}
void SUB_Remove()
{
	remove(self);
}