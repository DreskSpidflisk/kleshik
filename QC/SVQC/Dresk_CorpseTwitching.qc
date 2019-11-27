// DRESK
// Corpse Twitching

// Definitions
#define CORPSETWITCH_STATE_NONE						0
#define CORPSETWITCH_STATE_BEGINTWITCH				1
#define CORPSETWITCH_STATE_TWITCHING				2

// Fields
.float	nCorpseTwitch_State;
.float	nCorpseTwitch_InitialTwitchFrame;
.float	nCorpseTwitch_FinalDeathFrame;
.float	nCorpseTwitch_NumTwitches;

// Functions
void EntityCorpseTwitchThink()
{
	if(self.nCorpseTwitch_State == CORPSETWITCH_STATE_BEGINTWITCH)
	{ // Begin Corpse Twitch
		// Assign Frame to Initial Twitch Frame
		self.frame = self.nCorpseTwitch_InitialTwitchFrame;
		// Increment Number of Twitches
		self.nCorpseTwitch_NumTwitches = self.nCorpseTwitch_NumTwitches + 1;
		
		self.nCorpseTwitch_State = CORPSETWITCH_STATE_TWITCHING;
		
		// Assign Next Twitch Time
		self.nextthink = time + 0.1;
	}
	else
	if(self.nCorpseTwitch_State == CORPSETWITCH_STATE_TWITCHING)
	{ // Actively Twitching
		if(self.frame == self.nCorpseTwitch_FinalDeathFrame)
		{ // Finished Twitching
			self.nCorpseTwitch_State = CORPSETWITCH_STATE_NONE;
			self.nextthink = time;
		}
		else
		{ // Continue Active Twitch
			self.frame = self.frame + 1;
			self.nextthink = time + 0.1;
		}
	}
	else
	if(self.nCorpseTwitch_State == CORPSETWITCH_STATE_NONE)
	{ // No Present State; Determine Action
		if(self.nCorpseTwitch_NumTwitches < SG_AUTOCVAR(kleshik_server_BloodGore_CorpseTwitchMaximum) )
		{ // Twitch Time!
			self.nCorpseTwitch_State = CORPSETWITCH_STATE_BEGINTWITCH;
			// Assign Next Twitch Time
			self.nextthink = time + (random() * 7);
		}
		else
		{ // Stop Twitching
			self.nextthink = 0;
			self.think = __NULL__;
		}
	}
}
void PrepareEntityCorpseTwitch(float nNumFrames)
{
	// Assign Final Death Frame
	self.nCorpseTwitch_FinalDeathFrame = self.frame;
	// Assign Initial Twitch Frame
	self.nCorpseTwitch_InitialTwitchFrame = self.frame - nNumFrames;
	
	// Begin Corpse Twitch Think
	self.nextthink = time;
	self.think = EntityCorpseTwitchThink;
}