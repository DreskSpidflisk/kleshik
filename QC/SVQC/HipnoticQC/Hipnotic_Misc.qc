void trap_shooter_use()
{
	self.state = 1 - self.state;
}
   
/*QUAKED trap_switched_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
Continuously fires spikes.
"wait" time between spike (1.0 default)
"nextthink" delay before firing first spike, so multiple shooters can be stagered.
"state" 0 initially off, 1 initially on. (0 default)
*/
void trap_switched_shooter()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
		
	trap_spikeshooter();

	if (self.wait == 0)
		self.wait = 1;
		
	self.nextthink = self.nextthink + self.wait + self.ltime;
	self.think = shooter_think;
	
	self.use = trap_shooter_use;
}