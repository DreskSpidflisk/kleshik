// DRESK
// Kleshik Sounds

// Fields
float	g_nNumKleshikAmbientSoundsSpawned;

#define SOUND_KLESHIK_MAXPLAYERFOOTSTEPS	3

string	g_strFootsteps_Boots[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_ChainBoots[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_Claws[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_Heels[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_Hooves[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_MechFoot[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_Metal[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];
string	g_strFootsteps_Water[SOUND_KLESHIK_MAXPLAYERFOOTSTEPS];

entity	g_enRumbleSoundEntity;
// entity	g_enMusicShardEntity;
entity	g_enBassyWindEntity;
entity	g_enDemonicRoarEntity;
entity	g_enViolinDistortionEntity;
entity	g_enGhostlyChantsEntity;
entity	g_enLongStringEntity;
entity	g_enCreatureRoarEntity;
entity	g_enCreatureDistantShriekEntity;
entity	g_enHumanWailsEntity;
entity	g_enGhostDeathCryEntity;

// Sound Definitions

// Fields
// NOTE : Waterfog shifted to CSQC
//. float	bCDTrackIsUnderwaterSound;

// Functions
void PreparePlayerFootstepSoundsArrays()
{ // Prepare Player Footstep Sounds Arrays
	g_strFootsteps_Boots[0] = SOUND_KLESHIK_FOOTSTEPS_BOOTS_1;
	g_strFootsteps_Boots[1] = SOUND_KLESHIK_FOOTSTEPS_BOOTS_2;
	g_strFootsteps_Boots[2] = SOUND_KLESHIK_FOOTSTEPS_BOOTS_3;
	
	g_strFootsteps_ChainBoots[0] = SOUND_KLESHIK_FOOTSTEPS_CHAINBOOTS_1;
	g_strFootsteps_ChainBoots[1] = SOUND_KLESHIK_FOOTSTEPS_CHAINBOOTS_2;
	g_strFootsteps_ChainBoots[2] = SOUND_KLESHIK_FOOTSTEPS_CHAINBOOTS_3;
	
	g_strFootsteps_Claws[0] = SOUND_KLESHIK_FOOTSTEPS_CLAWS_1;
	g_strFootsteps_Claws[1] = SOUND_KLESHIK_FOOTSTEPS_CLAWS_2;
	g_strFootsteps_Claws[2] = SOUND_KLESHIK_FOOTSTEPS_CLAWS_3;
	
	g_strFootsteps_Heels[0] = SOUND_KLESHIK_FOOTSTEPS_HEELS_1;
	g_strFootsteps_Heels[1] = SOUND_KLESHIK_FOOTSTEPS_HEELS_2;
	g_strFootsteps_Heels[2] = SOUND_KLESHIK_FOOTSTEPS_HEELS_3;
	
	g_strFootsteps_Hooves[0] = SOUND_KLESHIK_FOOTSTEPS_HOOVES_1;
	g_strFootsteps_Hooves[1] = SOUND_KLESHIK_FOOTSTEPS_HOOVES_2;
	g_strFootsteps_Hooves[2] = SOUND_KLESHIK_FOOTSTEPS_HOOVES_3;
	
	g_strFootsteps_MechFoot[0] = SOUND_KLESHIK_FOOTSTEPS_MECHFOOT_1;
	g_strFootsteps_MechFoot[1] = SOUND_KLESHIK_FOOTSTEPS_MECHFOOT_2;
	g_strFootsteps_MechFoot[2] = SOUND_KLESHIK_FOOTSTEPS_MECHFOOT_3;
	
	g_strFootsteps_Metal[0] = SOUND_KLESHIK_FOOTSTEPS_METAL_1;
	g_strFootsteps_Metal[1] = SOUND_KLESHIK_FOOTSTEPS_METAL_2;
	g_strFootsteps_Metal[2] = SOUND_KLESHIK_FOOTSTEPS_METAL_3;
	
	g_strFootsteps_Water[0] = SOUND_KLESHIK_FOOTSTEPS_WATER_1;
	g_strFootsteps_Water[1] = SOUND_KLESHIK_FOOTSTEPS_WATER_2;
	g_strFootsteps_Water[2] = SOUND_KLESHIK_FOOTSTEPS_WATER_3;
}
void PrepareKleshikSounds()
{ // Prepare Kleshik Sounds
	// Precache Server Sounds
	PrecacheKleshikSounds_Server();
	
	// Prepare Footstep Sounds
	PreparePlayerFootstepSoundsArrays();
		
		
	local entity enOneShot;
	// Spawn Rumble Sound Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Rumble Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE3);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE4);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE5);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_RUMBLE6);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 15, 15);
	g_enRumbleSoundEntity = enOneShot;
	
	// Spawn Bassy Wind Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Bassy Wind Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_BASSYWIND1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_BASSYWIND2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_BASSYWIND3);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_BASSYWIND4);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 10, 20);
	g_enBassyWindEntity = enOneShot;
	
	// Demonic Roar Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Demonic Roar Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_DEMONICROAR1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_DEMONICROAR2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_DEMONICROAR3);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 20, 30);
	g_enDemonicRoarEntity = enOneShot;
	
	// Creature Roar Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Creature Roar Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR3);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR4);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR5);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR6);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR7);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR8);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR9);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR10);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREROAR11);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 20, 30);
	g_enCreatureRoarEntity = enOneShot;
	
	// Violin Distortion Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Violin Distortion Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_VIOLINDISTORTION1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_VIOLINDISTORTION2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_VIOLINDISTORTION3);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_VIOLINDISTORTION4);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_VIOLINDISTORTION5);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 20, 30);
	g_enViolinDistortionEntity = enOneShot;
	
	// Ghostly Chants Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Ghostly Chants Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTLYCHANTS1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTLYCHANTS2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTLYCHANTS3);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTLYCHANTS4);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTLYCHANTS5);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 180, 120);
	SetAmbientOneShotSoundEntityVolume(enOneShot, 0.9);
	g_enGhostlyChantsEntity = enOneShot;
	
	// Long String Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Long String Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_LONGSTRING1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_LONGSTRING2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_LONGSTRING3);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 120, 80);
	SetAmbientOneShotSoundEntityVolume(enOneShot, 0.8);
	g_enLongStringEntity = enOneShot;
	
	// Creature Distant Shriek Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Creature Distant Shriek Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREDISTANTSHRIEK1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREDISTANTSHRIEK2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_CREATUREDISTANTSHRIEK3);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 40, 40);
	SetAmbientOneShotSoundEntityVolume(enOneShot, 1.0);
	g_enCreatureDistantShriekEntity = enOneShot;
	
	// Human Wails Entity
	enOneShot = PrepareAmbientOneShotSoundEntity("Human Wails Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_HUMANWAILS1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_HUMANWAILS2);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 60, 90);
	SetAmbientOneShotSoundEntityVolume(enOneShot, 1.0);
	g_enHumanWailsEntity = enOneShot;
	
	// Ghost Death Cry
	enOneShot = PrepareAmbientOneShotSoundEntity("Ghost Death Cry Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTDEATHCRY1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTDEATHCRY2);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_AMBIENCE_ONESHOT_GHOSTDEATHCRY3);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 60, 90);
	SetAmbientOneShotSoundEntityVolume(enOneShot, 1.0);
	g_enGhostDeathCryEntity = enOneShot;
	
	// Spawn Music Shard Entity
	/*
	enOneShot = PrepareAmbientOneShotSoundEntity("Music Shard Sound Entity");
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_MUSICSHARD1);
	AddAmbientSoundToOneShotEntity(enOneShot, SOUND_KLESHIK_MUSICSHARD2);
	SetAmbientOneShotSoundEntityTimes(enOneShot, 90, 180);
	g_enMusicShardEntity = enOneShot;
	*/
}
string GetMessageTriggerSound()
{ // Return Message Trigger Sound
	local string strReturn;
	local float nRandom;
	nRandom = random();
	
	if(nRandom < 0.20)
		strReturn = SOUND_KLESHIK_MISC_MESSAGETRIGGER1;
	else
	if(nRandom < 0.40)
		strReturn = SOUND_KLESHIK_MISC_MESSAGETRIGGER2;
	else
	if(nRandom < 0.60)
		strReturn = SOUND_KLESHIK_MISC_MESSAGETRIGGER3;
	else
	if(nRandom < 0.80)
		strReturn = SOUND_KLESHIK_MISC_MESSAGETRIGGER4;
	else
		strReturn = SOUND_KLESHIK_MISC_MESSAGETRIGGER5;
	
	return strReturn;
}

void CheckAmbientSoundSpawn()
{ // Check Ambient Sound Spawn
	// NOTE: Assumed scope is entity to spawn sound
	local string strSound;
		strSound = "";
	local float nRandom;
	local float nCheck;
	
	if( cvar(CVAR_WORLD_SPAWNADDITIONALAMBIENTSOUNDS) )
	{ // Spawn Sound
		switch(self.classname)
		{
			case "item_shells":
			case "item_nails":
			case "item_rockets":
			case "item_cells":
			case "info_teleport_destination":
			case "info_player_coop":
			case "info_player_deathmatch":
			case "info_player_start":
			case "info_player_start2":
			case "light_torch_small_walltorch":
			case "light_flame_large_yellow":
			case "light_flame_small_yellow":
			case "light_flame_small_white":
			case "weapon_supershotgun":
			case "weapon_nailgun":
			case "weapon_supernailgun":
			case "weapon_grenadelauncher":
			case "weapon_rocketlauncher":
			case "weapon_lightning":
			case "weapon_laser_gun":
			case "weapon_mjolnir":
			case "weapon_proximity_gun":
				nRandom = random() * 19;
				nCheck = 3;
				if(nRandom < nCheck++)
				{ // Choose Random Metal Flanger
					local float nSubRandom;
						nSubRandom = random() * 9;
					if(nSubRandom < 1)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER1;
					else
					if(nSubRandom < 2)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER2;
					else
					if(nSubRandom < 3)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER3;
					else
					if(nSubRandom < 4)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER4;
					else
					if(nSubRandom < 5)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER5;
					else
					if(nSubRandom < 6)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER6;
					else
					if(nSubRandom < 7)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER7;
					else
					if(nSubRandom < 8)
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER8;
					else
						strSound = SOUND_KLESHIK_AMBIENCE_METALFLANGER9;
				}
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_TREMBLEMIX1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_TREMBLEMIX2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_AIRWHISTLE1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_AIRWHISTLE2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_GENTLEHUM;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_GHOSTLYWHISPER1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_GHOSTLYWHISPER2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_WINDCHANT1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_WINDCHANT2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_WINDCHANT3;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_HALLOWCHANTS1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_HALLOWCHANTS2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_BASEMENT1;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_BASEMENT2;
				else
				if(nRandom < nCheck++)
					strSound = SOUND_KLESHIK_AMBIENCE_WINDYROOM1;
				else
					strSound = SOUND_KLESHIK_AMBIENCE_WINDYROOM2;
				break;
			case "item_artifact_invulnerability":
				strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_PENTAGRAM;
				break;
			case "item_artifact_super_damage":
				strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_QUADDAMAGE;
				break;
			case "item_artifact_invisibility":
				strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_RINGOFSHADOWS;
				break;
			case "item_health":
				nRandom = random();
				if(nRandom < 0.20)
					strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_HEALTH1;
				else
				if(nRandom < 0.40)
					strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_HEALTH2;
				else
				if(nRandom < 0.60)
					strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_HEALTH3;
				else
				if(nRandom < 0.80)
					strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_HEALTH4;
				else
					strSound = SOUND_KLESHIK_AMBIENCE_ITEMS_HEALTH5;
				break;
		}
		
		// Spawn Ambient Sound
		if(strSound != "")
		{
			ambientsound(self.origin, strSound, 1.0, ATTN_STATIC);
			g_nNumKleshikAmbientSoundsSpawned = g_nNumKleshikAmbientSoundsSpawned + 1;
		}
	}
}