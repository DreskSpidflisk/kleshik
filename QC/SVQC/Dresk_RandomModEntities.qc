// DRESK - Random Mod Entities

// *****************************************
// MARCHER FORTRESS
void monster_imp()
{ // Imp
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	self.classname = "monster_wizard";
	monster_wizard();
}

void monster_ogre_spikeshooter()
{ // Ogre Spikeshooter
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	self.classname = "monster_ogre";
	monster_ogre();
}

// *****************************************
// ABANDON
void monster_stego()
{ // Stego
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	self.classname = "monster_dog";
	monster_dog();
}

void monster_orb()
{ // Orb
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	self.classname = "monster_enforcer";
	monster_enforcer();
}

// *****************************************
// INSOMNIA
void ambient_bfall()
{
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	remove(self);
}

// *****************************************
// WOLF3DDM
void monster_cyberdemon()
{
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	self.classname = "monster_shambler";
	monster_shambler();
}

// *****************************************
// Medieval Evil (med)
void amb_thunder()
{
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	precache_sound ("ambience/thunder1.wav");
	ambientsound (self.origin, "ambience/thunder1.wav", 0.5, ATTN_STATIC);
}
void amb_mood()
{
	g_nNumRandomEntitiesDetectedCnt = g_nNumRandomEntitiesDetectedCnt + 1;
	remove(self);
}