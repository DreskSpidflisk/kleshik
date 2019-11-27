// DRESK
// Client / Player Functions

// Definitions
#define PLAYER_NUMUNDERWATERBUBBLEENTITIES							6
#define PLAYER_CROUCH_VIEWOFFSETS									'0 0 -8'

// Fields
.float	tPlayerRespawnTime;
.float	bIsCrouching;
.float	bUseInvisibilityEyes;
.float	nPlayerCorpseTwitchState;
.float	nPlayerFinalCorpseFrame;

.float	bNewLevelArmorAssigned;

.entity	enUnderwaterBubbleEntities[PLAYER_NUMUNDERWATERBUBBLEENTITIES];

// Functions
entity SpawnUnderwaterBubbleTrailEntity(entity enPlayer, vector vOffset)
{ // Spawn Underwater Bubble Trail Entity
	local entity enSpawn;
	
	enSpawn = spawn();
	enSpawn.modelflags = MF_GRENADE;
	setmodel(enSpawn, "progs/s_bubble.spr");
	enSpawn.alpha = 0.01;
	setattachment(enSpawn, enPlayer, "");
	setorigin(enSpawn, vOffset + enPlayer.maxs_z * '0 0 1');
	
	return enSpawn;
}
void CheckPlayerUnderwaterBubbleTrailEntities(entity enPlayer)
{ // Check Player Underwater Bubble Trail Entities
	local float nCnt;
	if(enPlayer.waterlevel == 3)
	{ // Player is Underwater
		if(enPlayer.(enUnderwaterBubbleEntities[0]) )
		{ // Valid Entities
			for(nCnt = 0; nCnt < PLAYER_NUMUNDERWATERBUBBLEENTITIES; nCnt++)
				enPlayer.(enUnderwaterBubbleEntities[nCnt]).effects = 0;
		}
		else
		{ // Spawn Entities
			nCnt = 0;
			local vector vOffset;
				vOffset_z = -5;
				vOffset_x = -3;
				vOffset_y = 7;
				for(nCnt = 0; nCnt < PLAYER_NUMUNDERWATERBUBBLEENTITIES; nCnt++)
				{
					vOffset_y = vOffset_y * -1;
					if( SG_MathModulus(nCnt, 2) == 0)
						vOffset_z = vOffset_z - 10;
					enPlayer.(enUnderwaterBubbleEntities[nCnt]) = SpawnUnderwaterBubbleTrailEntity(enPlayer, vOffset);
				}
		}
	}
	else
	{ // Player is Not Underwater; Purge Entity Model Effects
		if(enPlayer.(enUnderwaterBubbleEntities[0]) )
		{ // Valid Entities
			for(nCnt = 0; nCnt < PLAYER_NUMUNDERWATERBUBBLEENTITIES; nCnt++)
				enPlayer.(enUnderwaterBubbleEntities[nCnt]).effects = EF_NODRAW;
		}
	}
}
void PurgeUnderwaterBubbleTrailEntities(entity enPlayer)
{ // Purge Underwater Bubble Trail Entities
	local float nCnt;
	
	for(nCnt = 0; nCnt < PLAYER_NUMUNDERWATERBUBBLEENTITIES; nCnt++)
	{
		if( enPlayer.(enUnderwaterBubbleEntities[nCnt]) )
			remove( enPlayer.(enUnderwaterBubbleEntities[nCnt]) );
	}
}
void SetPlayerSize(entity enPlayer)
{ // Set Player Size
	if(enPlayer.bIsCrouching)
	{ // Crouching
		setsize(enPlayer, PLAYER_CROUCH_MINS, PLAYER_CROUCH_MAXS);
	}
	else
	{ // Not Crouching
		setsize(enPlayer, VEC_HULL_MIN, VEC_HULL_MAX);
	}
}
void PlayerCorpseTwitchThink()
{ // Player Corpse Twitch Think
	if(self.nPlayerCorpseTwitchState == 1)
	{ // Corpse Twitch
		self.frame = self.frame - 1;
		self.nPlayerCorpseTwitchState = 2;
		// Increment Number of Twitches
		self.nNumCorpseTwitches = self.nNumCorpseTwitches + 1;
		// Assign Next Twitch Time
		self.nextthink = time + 0.1;
	}
	else
	{
		if(self.nPlayerCorpseTwitchState == 2)
			// Return to Original Frame
			self.frame = self.frame + 1;
			
		if(self.nNumCorpseTwitches < SG_AUTOCVAR(kleshik_server_BloodGore_CorpseTwitchMaximum) )
		{ // Twitch Time!
			self.nPlayerCorpseTwitchState = 1;
			// Assign Next Twitch Time
			self.nextthink = time + (random() * 7);
		}
		else
		{ // Disable Twitching
			self.nextthink = 0;
			self.think = __NULL__;
		}
	}
}
void PreparePlayerCorpseTwitch()
{ // Prepare Player Corpse Twitch
	// Assign Final Corpse Frame (just in case the body is copied to the queue during a twitch frame)
	self.nPlayerFinalCorpseFrame = self.frame;
	
	// DRESK
	// DEBUG
	/*
	if(self.frame != PLAYERANIM_QUAKE2_CROUCHDEATH_END
		&& self.frame != PLAYERANIM_QUAKE2_DEATH1_END
		&& self.frame != PLAYERANIM_QUAKE2_DEATH2_END
		&& self.frame != PLAYERANIM_QUAKE2_DEATH3_END
		)
	{ // Error
		bprint("^1WARNING ^7: Player Corpse Initial Frame ^2", ftos(self.frame), "^7 is ^1NOT^7 Death End Frame!\n");
	}
	*/
	
	// Assign Standard Corpse Twitch Think
	self.think = PlayerCorpseTwitchThink;
	self.nextthink = time;
}