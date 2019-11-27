// DRESK
// Support for 'soe' mod

float	g_nSOEFeatureDetectedCnt;

void ambient_wind1()
{
	GenericAmbientSound("ambience/wind1.wav");
	g_nSOEFeatureDetectedCnt++;
}
void misc_meat()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}
void misc_corpse()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}
void monster_axeman()
{
	g_nSOEFeatureDetectedCnt++;
	self.classname = "monster_knight";
	monster_knight();
}
void monster_bane()
{
	g_nSOEFeatureDetectedCnt++;
	self.classname = "monster_demon1";
	monster_demon1();
}
void misc_tree()
{
	// NOTE: This thing was reverse-engineered by hand (not decompiled), so, I hope it's all good
	g_nSOEFeatureDetectedCnt++;
	
	// Precache Models
	precache_model("progs/tree.mdl");
	precache_model("progs/tree2.mdl");
	
	// Assign Solid Type
	self.solid = SOLID_BBOX;
	
	if(self.cnt == 1)
	{
		setmodel(self, "progs/tree2.mdl");
		self.skin = 0;
	}
	else
	if(self.cnt == 2)
	{
		setmodel(self, "progs/tree2.mdl");
		self.skin = 1;
	}
	else
	if(self.cnt == 0)
	{ // Use Tree Model
		setmodel(self, "progs/tree.mdl");
	}
	
	// Assign Size
	setsize(self, '-16 -16 0', '16 16 128');
	// Drop to Floor
	droptofloor();
}
void trigger_camera()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}
void info_script()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}
void info_movie_camera()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}
void monster_sorceror()
{
	g_nSOEFeatureDetectedCnt++;
	self.classname = "monster_demon1";
	monster_demon1();
}
void monster_acolyte()
{
	g_nSOEFeatureDetectedCnt++;
	self.classname = "monster_demon1";
	monster_demon1();
}
void monster_voreling()
{
	g_nSOEFeatureDetectedCnt++;
	self.classname = "monster_shalrath";
	monster_shalrath();
}
void explode_nulldmg()
{
	g_nSOEFeatureDetectedCnt++;
	remove(self);
}