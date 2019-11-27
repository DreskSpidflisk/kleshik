// DRESK
// Travail Items

// Definitions

// Fields

// Functions
void item_artifact_trinity()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Travail();
	
	// DRESK
	// Substitute Item
	self.classname = "item_artifact_super_damage";
	item_artifact_super_damage();
	
	/*
	self.touch = powerup_touch;

	precache_model ("progs/trinity.mdl");
	precache_sound ("items2/trintake.wav");
	precache_sound ("items2/trinuse.wav");
	precache_sound ("items2/trinend.wav");
	self.noise = "items2/trintake.wav";
	setmodel (self, "progs/trinity.mdl");
	self.netname = "Trinity";
	self.items = IT_EXTRA_WEAPON;
	setsize (self, '-16 -16 -24', '16 16 32');
	StartItem ();
	*/
}