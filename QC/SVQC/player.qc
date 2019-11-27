
void() bubble_bob;
void(float num_bubbles) DeathBubbles;

void PlayerPainSound(float fDamageType)
{
	local float		rs;

	if (self.health < 0)
		return;

	if (damage_attacker.classname == "teledeath")
	{
		sound (self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}

	// water pain sounds
	if (self.watertype == CONTENT_WATER && self.waterlevel == 3)
	{
		DeathBubbles(1);
		if (random() > 0.5)
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_DROWN1), 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_DROWN2), 1, ATTN_NORM);
		return;
	}

	// slime pain sounds
	if (self.watertype == CONTENT_SLIME)
	{
		// FIX ME	put in some steam here
		if (random() > 0.5)
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_LAVABURN1), 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_LAVABURN2), 1, ATTN_NORM);
		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		if (random() > 0.5)
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_LAVABURN1), 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_LAVABURN2), 1, ATTN_NORM);
		return;
	}
	

	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + random() + 0.7;

// don't make multiple pain sounds right after each other

	// ax pain sound
	if (fDamageType == DAMAGETYPE_WEAPON_AXE || fDamageType == DAMAGETYPE_WEAPON_MJOLNIR || fDamageType == DAMAGETYPE_THROWABLEFLARE_HIT)
	{
		sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_AXPAIN), 1, ATTN_NORM);
		return;
	}
	

	// DRESK
	// Apply Lava Scream Sounds as Well
	rs = rint((random() * 7) + 1);
	local float nSoundID;
	
	if (rs == 1)
		nSoundID = PLAYERSOUND_PAIN1;
	else if (rs == 2)
		nSoundID = PLAYERSOUND_PAIN2;
	else if (rs == 3)
		nSoundID = PLAYERSOUND_PAIN3;
	else if (rs == 4)
		nSoundID = PLAYERSOUND_PAIN4;
	else if (rs == 5)
		nSoundID = PLAYERSOUND_PAIN5;
	else if (rs == 6)
		nSoundID = PLAYERSOUND_PAIN6;
	else if (rs == 7)
		nSoundID = PLAYERSOUND_LAVABURN1;
	else
		nSoundID = PLAYERSOUND_LAVABURN2;

	/*
	self.noise = "";
	if (rs == 1)
		self.noise = "player/pain1.wav";
	else if (rs == 2)
		self.noise = "player/pain2.wav";
	else if (rs == 3)
		self.noise = "player/pain3.wav";
	else if (rs == 4)
		self.noise = "player/pain4.wav";
	else if (rs == 5)
		self.noise = "player/pain5.wav";
	else if (rs == 6)
		self.noise = "player/pain6.wav";
	else if (rs == 7)
		self.noise = "player/lburn1.wav";
	else
		self.noise = "player/lburn2.wav";
	/*
	else
		self.noise = "player/pain6.wav";
	*/
	
	sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, nSoundID), 1, ATTN_NORM);
	return;
}
void player_pain(entity enAttacker, float fDamage, float fDamageType)
{
	// DRESK
	// Shifted Pain Sounds to Pain Function
	// Prevents Pain not being heard due to animation issues
	PlayerPainSound(fDamageType);
	
	if (self.weaponframe)
		return;

	if (self.nCSQCStat_Powerups & POWERUP_INVULNERABILITY)
		return;		// eyes don't have pain frames

	if (self.weapon == WEAPON_AXE)
		PlayerAnim_Pain_Axe(PLAYERANIM_ANIMSPEED_PAIN);
	// DRESK - HIPNOTIC SUPPORT
	else
	if (self.weapon == WEAPON_MJOLNIR)
		PlayerAnim_Pain_Hammer(PLAYERANIM_ANIMSPEED_PAIN);
	else
		PlayerAnim_Pain(PLAYERANIM_ANIMSPEED_PAIN);
}
void DeathBubblesSpawn()
{
	local entity	bubble;
	
	// DRESK
	// Prevent Non-Removed Bubble Spawner
	if (self.owner.waterlevel != 3 && self.owner.health > 0)
	// if (self.owner.waterlevel != 3)
	{ // Bubble Spawner No Longer Necessary; Remove
		remove(self);
		return;
	}
		
	bubble = spawn();
	setmodel (bubble, "progs/s_bubble.spr");
	setorigin (bubble, self.owner.origin + '0 0 24');
	bubble.movetype = MOVETYPE_NOCLIP;
	bubble.solid = SOLID_NOT;
	bubble.velocity = '0 0 15';
	bubble.nextthink = time + 0.5;
	bubble.think = bubble_bob;
	bubble.classname = "bubble";
	bubble.frame = 0;
	bubble.cnt = 0;
	// DRESK
	// Assign Modelflag to Bubbles
	bubble.modelflags = MF_GRENADE;
	setsize (bubble, '-8 -8 -8', '8 8 8');
	self.nextthink = time + 0.1;
	self.think = DeathBubblesSpawn;
	self.air_finished = self.air_finished + 1;
	if (self.air_finished >= self.bubble_count)
		remove(self);
};

// DRESK
// C-STYLE FUNCTION SYNTAX
void DeathBubbles(float num_bubbles)
{
	local entity	bubble_spawner;
	
	bubble_spawner = spawn();
	setorigin (bubble_spawner, self.origin);
	bubble_spawner.movetype = MOVETYPE_NONE;
	bubble_spawner.solid = SOLID_NOT;
	bubble_spawner.nextthink = time + 0.1;
	bubble_spawner.think = DeathBubblesSpawn;
	bubble_spawner.air_finished = 0;
	bubble_spawner.owner = self;
	bubble_spawner.bubble_count = num_bubbles;
	return;
};

// DRESK
// C-STYLE FUNCTION SYNTAX
void DeathSound()
{
	local float		rs;

	// water death sounds
	if (self.waterlevel == 3)
	{
		DeathBubbles(20);
		sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, PLAYERSOUND_DROWNDEATH), 1, ATTN_NONE);
		return;
	}
	
	rs = rint ((random() * 4) + 1);
	local float nSoundID;
	if (rs == 1)
		nSoundID = PLAYERSOUND_DEATH1;
	else
	if (rs == 2)
		nSoundID = PLAYERSOUND_DEATH2;
	else
	if (rs == 3)
		nSoundID = PLAYERSOUND_DEATH3;
	else
	if (rs == 4)
		nSoundID = PLAYERSOUND_DEATH4;
	else
		nSoundID = PLAYERSOUND_DEATH5;
	sound (self, CHAN_VOICE, GETPLAYERMODELSOUND(self, nSoundID), 1, ATTN_NONE);
	/*
	if (rs == 1)
		self.noise = "player/death1.wav";
	if (rs == 2)
		self.noise = "player/death2.wav";
	if (rs == 3)
		self.noise = "player/death3.wav";
	if (rs == 4)
		self.noise = "player/death4.wav";
	if (rs == 5)
		self.noise = "player/death5.wav";

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NONE);
	*/
	return;
}

void GibPlayer(float fDamageType)
{
	// DRESK
	// Check for Custom Player Model Head
	if(self.nPlayerModelType != PLAYERMODEL_MODELTYPE_MDL)
	{
		if(self.nPlayerModelSex == SEX_ROBOT)
			ThrowHead (PLAYERMODEL_GENERICROBOTHEAD, self.health, GIBBEDHEADTYPE_GENERICROBOT);
		else
			ThrowHead (PLAYERMODEL_GENERICGIBBEDHEAD, self.health, GIBBEDHEADTYPE_GENERICFLESH);
	}
	else
		ThrowHead ("progs/h_player.mdl", self.health, GIBBEDHEADTYPE_SPECIFIC);
	if(self.nPlayerModelSex != SEX_ROBOT)
	{ // Throw Bloody Gibs
		GORE_THROWSTANDARDGIBS;
	}
	else
	{ // Produce Explosion Effects
		te_RobotExplosion(self.origin);
	}

	// DRESK
	// Respawn Times Supported; Suppressing Assignment
	// self.deadflag = DEAD_DEAD;
	// Determine Attenutation and Channel
	local float nAttenuation;
	local float nChannel;
	// Assign Defaults
	nAttenuation = ATTN_NONE;
	nChannel = CHAN_VOICE;
	
	if(self.bIsCorpse)
	{ // Corpse; Produce New Local Sound (to not override world-based death sound)
		nAttenuation = ATTN_NORM;
		nChannel = CHAN_AUTO;
	}

	if (fDamageType == DAMAGETYPE_MISC_TELEFRAG || fDamageType == DAMAGETYPE_MISC_INVULNERABLETELEFRAGDEFLECT)
	{
		sound (self, nChannel, "player/teledth1.wav", 1, nAttenuation);
		return;
	}
		
	// DRESK
	// Utilize Generic Corpse Gib
	sound (self, nChannel, GetRandomGenericCorpseGibSound(self), 1, nAttenuation);
	/*
	if(self.nPlayerModelType != PLAYERMODEL_MODELTYPE_MDL)
	{ // Not Using Quake Player; Use Generic Corpse Gib Sounds
		local float nRandom;
			nRandom = random();
		if(nRandom < 0.33)
			sound (self, nChannel, SOUND_GORE_GENERICCORPSEGIB1, 1, nAttenuation);
		else
		if(nRandom < 0.66)
			sound (self, nChannel, SOUND_GORE_GENERICCORPSEGIB2, 1, nAttenuation);
		else
			sound (self, nChannel, SOUND_GORE_GENERICCORPSEGIB3, 1, nAttenuation);
	}
	else
	{ // Standard Gib Sounds
		if (random() < 0.5)
			sound (self, nChannel, "player/gib.wav", 1, nAttenuation);
		else
			sound (self, nChannel, "player/udeath.wav", 1, nAttenuation);
	}
	*/
}

// DRESK
// Simple PlayerCorpseDie
void PlayerCorpseDie(float fDamageType)
{ // Player Corpse Die
	// Used for gibbing player corpses
	if(self.health < self.nGibHealth)
		GibPlayer(fDamageType);
}
void PlayerDie(float fDamageType)
{
	local	float	i;
	
	// DRESK
	// Support Drop Powerups
	if( cvar(CVAR_PLAYER_DROPPOWERUPSONDEATH) )
		DropPowerups();
		
	// DRESK
	// Assign Die as PlayerCorpseDie
	self.th_die = PlayerCorpseDie;
	
	// Purge all Powerups
	self.nCSQCStat_Powerups = 0;
	self.tCSQCStat_PowerupEndTime_Invisibility = 0;
	self.tCSQCStat_PowerupEndTime_Invulnerability = 0;
	self.tCSQCStat_PowerupEndTime_QuadDamage = 0;
	self.tCSQCStat_PowerupEndTime_Biosuit = 0;
	// DRESK - HIPNOTIC SUPPORT
	// self.wetsuit_finished = 0;
	self.tCSQCStat_PowerupEndTime_EmpathyShields = 0;
	// Remove Potential Visual Effects
	self.effects = self.effects - (self.effects & (EF_DIMLIGHT | EF_RED | EF_BLUE) );
	
	// Remove Armor
	self.armorvalue = 0;
	self.armortype = 0;
	// Remove Potential Armor Items
	self.items = self.items - (self.items & (ITEM_ARMOR1 | ITEM_ARMOR2 | ITEM_ARMOR3) );
	
	// DRESK
	// Clear Crouching
	self.bIsCrouching = FALSE;
	// Remove Weapon Alpha
	ViewWeapon_SetAlpha(self, 0);
	// Disable Quake2 Weapon Entity Drawing
	Quake2WeaponEntity_SetIsDrawing(self, FALSE);
	
	// DRESK
	// Check Player Model Update
	CheckPlayerModelUpdate(self);
	
	// DRESK
	// Assign Respawn Time
	self.tPlayerRespawnTime = time + cvar(CVAR_PLAYER_RESPAWNTIME);

	// DRESK
	// Support Suppressing Backpack Drop in Cooperative
	// if (deathmatch || coop)
	if (deathmatch || (coop && cvar(CVAR_COOP_PLAYERBACKPACKSYSTEM) != 2) )
		DropBackpack();
	
	self.weaponmodel="";
	self.view_ofs = '0 0 -8';
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < 10)
		self.velocity_z = self.velocity_z + random()*300;
		
	// DRESK
	// Check Floating Weapon
	CheckFloatingWeapon(self);
	// Check Floating Keys
	CheckFloatingKeys(self);

	if(self.health < self.nGibHealth)
	{
		GibPlayer(fDamageType);
		return;
	}
	
	// DRESK
	// Play Death Hit Sound
	local float nRandom;
	local string strSound;
	nRandom = random();
	if(nRandom < 0.25)
	{
		if(self.bBleedsSparks)
			strSound = SOUND_KLESHIK_PLAYER_METALDEATHHIT1;
		else
			strSound = SOUND_KLESHIK_PLAYER_DEATHHIT1;
	}
	else
	if(nRandom < 0.50)
	{
		if(self.bBleedsSparks)
			strSound = SOUND_KLESHIK_PLAYER_METALDEATHHIT2;
		else
			strSound = SOUND_KLESHIK_PLAYER_DEATHHIT2;
	}
	else
	if(nRandom < 0.75)
	{
		if(self.bBleedsSparks)
			strSound = SOUND_KLESHIK_PLAYER_METALDEATHHIT3;
		else
			strSound = SOUND_KLESHIK_PLAYER_DEATHHIT3;
	}
	else
	{
		if(self.bBleedsSparks)
			strSound = SOUND_KLESHIK_PLAYER_METALDEATHHIT4;
		else
			strSound = SOUND_KLESHIK_PLAYER_DEATHHIT4;
	}
	// Play Sound
	sound(self, CHAN_AUTO, strSound, 1, ATTN_NONE);

	DeathSound();
	
	self.angles_x = 0;
	self.angles_z = 0;
	
	// DRESK
	// Assign Force Damage Momentum
	self.bForceDamageMomentum = TRUE;
	
	// Assign End Function for Corpse Twitching
	self.fpPlayerContigAnim_EndFunction = PreparePlayerCorpseTwitch;
	
	if (self.weapon == WEAPON_AXE)
	{
		PlayerAnim_Death_Axe(PLAYERANIM_ANIMSPEED_STANDARD);
		return;
	}
	// DRESK - HIPNOTIC SUPPORT
	else if (self.weapon == WEAPON_MJOLNIR)
	{
		PlayerAnim_Death_Hammer(PLAYERANIM_ANIMSPEED_STANDARD);
		return;
	}
	
	// DRESK
	// Removed this crap
	/*
	i = cvar("temp1");
	if (!i)
	*/
	
	i = 1 + floor(random()*6);
	
	if (i == 1)
		PlayerAnim_Death(0, PLAYERANIM_ANIMSPEED_STANDARD);
	else if (i == 2)
		PlayerAnim_Death(1, PLAYERANIM_ANIMSPEED_STANDARD);
	else if (i == 3)
		PlayerAnim_Death(2, PLAYERANIM_ANIMSPEED_STANDARD);
	else if (i == 4)
		PlayerAnim_Death(3, PLAYERANIM_ANIMSPEED_STANDARD);
	else
		PlayerAnim_Death(4, PLAYERANIM_ANIMSPEED_STANDARD);
}
void set_suicide_frame()
{	// used by disconnect command
	if (self.model != "progs/player.mdl")
		return;	// allready gibbed
		
	// DRESK
	// Reset Player Model
	ResetPlayerModel(self, FALSE);
	
	self.frame = $deatha11;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.deadflag = DEAD_DEAD;
	self.nextthink = -1;
}
