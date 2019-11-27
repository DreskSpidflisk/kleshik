// Rogue Item Substitutions

void item_lava_spikes()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.classname = "item_spikes";
	item_spikes();
}

void item_multi_rockets()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.classname = "item_rockets";
	item_rockets();
}

void item_plasma()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.classname = "item_cells";
	item_cells();
}

void item_powerup_shield()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.classname = "item_armorInv";
	item_armorInv();
}
void item_powerup_belt()
{
	// DRESK
	// Game Mode Feature Detection - Rogue
	GameModeFeatureDetected_Rogue();
	
	self.classname = "item_armorInv";
	item_armorInv();
}