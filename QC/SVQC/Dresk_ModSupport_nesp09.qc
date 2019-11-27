// DRESK
// Support for 'nesp09' mod

float	g_nNesp09FeatureDetectedCnt;

void GenericAmbientSound(string strSound)
{ // Generic Ambient Sound
	precache_sound(strSound);
	ambientsound(self.origin, strSound, 1, ATTN_STATIC);
}
void amb_highwind()
{
	GenericAmbientSound("ambience/highwind.wav");
	g_nNesp09FeatureDetectedCnt = g_nNesp09FeatureDetectedCnt + 1;
}
void amb_lava()
{
	GenericAmbientSound("ambience/lava.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_lava2()
{
	GenericAmbientSound("ambience/lava2.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_mine()
{
	GenericAmbientSound("ambience/mine.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_metal()
{
	GenericAmbientSound("ambience/metal.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_birds()
{
	GenericAmbientSound("ambience/birds.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_lavafall()
{
	GenericAmbientSound("ambience/lavafall.wav");
	g_nNesp09FeatureDetectedCnt++;
}
void amb_underwater()
{
	GenericAmbientSound("ambience/under.wav");
	g_nNesp09FeatureDetectedCnt++;
}

void monster_demon2()
{ // Demon2
	g_nNesp09FeatureDetectedCnt++;
	self.skin = 1;
	self.classname = "monster_demon1";
	monster_demon1();
}
void monster_hell_knight2()
{ // Hell Knight2
	g_nNesp09FeatureDetectedCnt++;
	self.skin = 1;
	self.classname = "monster_hell_knight";
	monster_hell_knight();
}
void monster_hell_knight3()
{ // Hell Knight3
	g_nNesp09FeatureDetectedCnt++;
	self.skin = 1;
	self.classname = "monster_hell_knight";
	monster_hell_knight();
}
void monster_shambler1()
{ // Shambler1
	g_nNesp09FeatureDetectedCnt++;
	self.skin = 1;
	self.classname = "monster_shambler";
	monster_shambler();
}
void monster_shambler2()
{ // Shambler2
	g_nNesp09FeatureDetectedCnt++;
	self.skin = 2;
	self.classname = "monster_shambler";
	monster_shambler();
}
void monster_ogre2()
{
	g_nNesp09FeatureDetectedCnt++;
	self.nCSQCStat_Weapons = WEAPON_NAILGUN;
	self.classname = "monster_ogre";
	monster_ogre();
}

void monster_nevir()
{ // Nevir
	g_nNesp09FeatureDetectedCnt++;
	self.classname = "monster_demon1";
	monster_demon1();
}

void info_spawnpoint()
{
	g_nNesp09FeatureDetectedCnt++;
	self.effects = EF_NODRAW;
	// What does this do?  How does it work?
}