// DRESK
// World Ambient OneShot Sounds

// Definitions
// #define AMBIENTONESHOTSOUND_DEBUG
#define AMBIENTONESHOTSOUND_MAXSOUNDS				12

// Fields
.string	strAmbientOneShotSound_Sound[AMBIENTONESHOTSOUND_MAXSOUNDS];
.float	nAmbientOneShotSound_NumSounds;

.float	tAmbientOneShotSound_MinimumNextTime;
.float	tAmbientOneShotSound_RandomNextTime;

.float	fAmbientOneShotSound_Volume;

// Functions
void AddAmbientSoundToOneShotEntity(entity enEntity, string strSound)
{
	if(enEntity.nAmbientOneShotSound_NumSounds < AMBIENTONESHOTSOUND_MAXSOUNDS)
	{ // Sound Allowed
		// Register Sound to Slot
		enEntity.(strAmbientOneShotSound_Sound[enEntity.nAmbientOneShotSound_NumSounds]) = strSound;
		
		// Increment Number of Sounds
		enEntity.nAmbientOneShotSound_NumSounds = enEntity.nAmbientOneShotSound_NumSounds + 1;
	}
}
entity PrepareAmbientOneShotSoundEntity(string strClassname)
{
	local entity enSpawn;
	enSpawn = spawn();
	enSpawn.classname = strClassname;
	enSpawn.effects = EF_NODRAW;
	enSpawn.fAmbientOneShotSound_Volume = 1;
	
	return enSpawn;
}
void AmbientOneShotSoundEntityThink()
{
	local string strSound;
	local float nRandom;
	
	nRandom = rint(random() * (self.nAmbientOneShotSound_NumSounds - 1) );
		strSound = self.(strAmbientOneShotSound_Sound[nRandom]);
		
	#ifdef AMBIENTONESHOTSOUND_DEBUG
	bprint( strcat("One Shot Sound Play #", ftos(nRandom), " : ", strSound, "\n") );
	#endif
		
	// Play Sound
	if( cvar(CVAR_WORLD_PLAYRANDOMWORLDSOUNDS) )
		sound(world, CHAN_AUTO, strSound, self.fAmbientOneShotSound_Volume, ATTN_NONE);
		
	// Assign Next Think Time
	self.nextthink = time + self.tAmbientOneShotSound_MinimumNextTime + (random() * self.tAmbientOneShotSound_RandomNextTime);
}
void SetAmbientOneShotSoundEntityTimes(entity enEntity, float tMinimumTime, float tRandomTime)
{
	enEntity.tAmbientOneShotSound_MinimumNextTime = tMinimumTime;
	enEntity.tAmbientOneShotSound_RandomNextTime = tRandomTime;
	// Assign Think Function
	enEntity.think = AmbientOneShotSoundEntityThink;
	// Assign Next Think Time
	enEntity.nextthink = time + self.tAmbientOneShotSound_MinimumNextTime + (random() * self.tAmbientOneShotSound_RandomNextTime);
}
void SetAmbientOneShotSoundEntityVolume(entity enEntity, float fVolume)
{
	enEntity.fAmbientOneShotSound_Volume = fVolume;
}
