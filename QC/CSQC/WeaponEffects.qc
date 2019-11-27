// DRESK
// Client-side Weapon Effects

// Definitions
#define WEAPONEFFECT_BASESPARKSPEED									65

// Fields

// Functions
void ShotgunTracerFire(vector vOrigin, vector vDirection, float nNumTracers, vector vSpread)
{ // Shotgun Tracer Fire
	local float nCnt;
	local vector vRandDir;
	makevectors(vDirection);
	for(nCnt = 0; nCnt < nNumTracers; nCnt++)
	{ // Spawn Tracer
		vRandDir = vDirection + SG_crandom() * vSpread_x * v_right + SG_crandom() * vSpread_y * v_up;
		te_particlerain(vOrigin, vOrigin, vRandDir * (1800 + (random() * 200) ) , 5, 20);
	}
}
void ScatterPopThink()
{ // Scatter Pop Think
	// Play Sound
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.45)
		pointsound(self.origin, SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP1, 1.0, ATTN_NORM);
	else
	if(nRandom < 0.90)
		pointsound(self.origin, SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP2, 1.0, ATTN_NORM);
	else
		pointsound(self.origin, SOUND_KLESHIK_WEAPONS_SCATTERSHOT_SCATTERPOP3, 1.0, ATTN_NORM);
		
	// Produce Effect
	pointparticles( particleeffectnum("TE_SCATTERPOP"), self.origin, '0 0 0', 1);
	// Produce Sparks
	te_spark(self.origin, randomvec() * 200, random() * 20);
	
	// Remove Self
	remove(self);
}
float SpawnScatterPop(vector vOrigin, float tDelayTime)
{ // Spawn Scatter Pop
	local float tRandomDelay;
	local entity enScatterPop;
		enScatterPop = spawn();
		
	enScatterPop.classname = "Scatter Pop";
	setorigin(enScatterPop, vOrigin);
	enScatterPop.think = ScatterPopThink;
	
	// Calculate Delay Time
	tRandomDelay = random() * 0.38;
	
	// Assign Time for Pop
	enScatterPop.nextthink = time + tDelayTime + tRandomDelay;
	
	return tRandomDelay;
}
void ProduceScatterPops(vector vOrigin, vector vForward)
{ // Produce Scatter Pops
	local float tScatterDelay;
	local float nCnt;
	for(nCnt = 0; nCnt < 8; nCnt++)
	{
		// Perform Trace
		traceline(vOrigin, vOrigin + ( (vForward + (randomvec() * 0.55) )* 85), FALSE, self);
		tScatterDelay = SpawnScatterPop(trace_endpos, tScatterDelay);
	}
}
void ParseWeaponFireEffect()
{ // Parse Weapon Fire Effect
	local float nSoundChannel;
		nSoundChannel = CHAN_AUTO;
	local float nEdictNumOnServer;
		nEdictNumOnServer = getstati(STAT_KLESHIK_CLIENTEDICTNUMONSERVER);
		
	// Read Edict Firing Weapon
	local float nEdict;
		nEdict = ReadByte();
	// Read Weapon ID
	local float nWeaponID;
		nWeaponID = ReadByte();
		nWeaponID = GetWeaponIDFromByteEncoded(nWeaponID);
	// Read Firing Mode
	local float nFiringMode;
		nFiringMode = ReadByte();
	// Read Extended Data
	local float nExtendedData;
		nExtendedData = ReadByte();
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	// Read Forward Direction
	local vector vForward;
		vForward_x = ReadByte();
			vForward_x = (vForward_x / 127.5) - 1.0;
		vForward_y = ReadByte();
			vForward_y = (vForward_y / 127.5) - 1.0;
		vForward_z = ReadByte();
			vForward_z = (vForward_z / 127.5) - 1.0;
		// Re-normalize Vector
		vForward = normalize(vForward);
		
	// Produce Effects
	switch(nWeaponID)
	{
		case WEAPON_SHOTGUN:
		case WEAPON_SUPER_SHOTGUN:
		case WEAPON_GRENADE_LAUNCHER:
		case WEAPON_ROCKET_LAUNCHER:
		case WEAPON_PROXIMITY_GUN:
		case WEAPON_LASER_GUN:
		case WEAPON_FLECHETTE_CANNON:
			if(nEdictNumOnServer == nEdict)
				pointparticles( particleeffectnum("TE_GENERICWEAPONFIRE_SELF"), vOrigin, vForward * 900, 90);
			else
				pointparticles( particleeffectnum("TE_GENERICWEAPONFIRE"), vOrigin, vForward * 900, 90);
			if(nWeaponID == WEAPON_SUPER_SHOTGUN && nFiringMode == WEAPON_FIRINGMODE_SECONDARY)
				ProduceScatterPops(vOrigin, vForward);
			break;
		case WEAPON_NAILGUN:
		case WEAPON_SUPER_NAILGUN:
		case WEAPON_LASER_CANNON:
		case WEAPON_CHAIN_GUN:
			if(nEdictNumOnServer == nEdict)
				pointparticles( particleeffectnum("TE_NAILGUNFIRE"), vOrigin, vForward * 900, 8);
			else
				pointparticles( particleeffectnum("TE_NAILGUNFIRE_SELF"), vOrigin, vForward * 900, 8);
			break;
		case WEAPON_LIGHTNING:
			if(nFiringMode == WEAPON_FIRINGMODE_SECONDARY)
			{
				if(nEdictNumOnServer == nEdict)
					pointparticles( particleeffectnum("TE_GENERICWEAPONFIRE_SELF"), vOrigin, vForward * 900, 90);
				else
					pointparticles( particleeffectnum("TE_GENERICWEAPONFIRE"), vOrigin, vForward * 900, 90);
			}
			else
				te_customflash(vOrigin, 125, 2, '0.3 0.3 1');
			break;
	}
	
	// Acquire Weapon Entity
	local entity enWeaponEntity;
		enWeaponEntity = SG_WeaponEntity_GetWeaponEntityFromWeaponID(nWeaponID);
	
	// Acquire Firing Sound for Weapon
	local string strSound;
		strSound = SG_GetWeaponFiringSound(enWeaponEntity, nFiringMode);
	
	if(strSound != "")
	{ // Valid Sound
		if(nEdictNumOnServer == nEdict)
		{ // Local Client Fired Weapon; Play Sound Globally
			pointsound(vOrigin, strSound, 1.0, ATTN_NONE);
		}
		else
		{ // Non-Local Client Fired Weapon; Standard Sound Location
			pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
		}
	}
	
	// Produce Brass
	if( SG_AUTOCVAR(kleshik_client_brassejection_enabled) )
	{ // Brass Ejection Enabled
		if(nFiringMode == WEAPON_FIRINGMODE_PRIMARY)
		{
			if(enWeaponEntity.fpWeaponEntity_PrimaryBrassFunction)
				enWeaponEntity.fpWeaponEntity_PrimaryBrassFunction(vOrigin, vForward, nExtendedData);
		}
		else
		{
			if(enWeaponEntity.fpWeaponEntity_SecondaryBrassFunction)
				enWeaponEntity.fpWeaponEntity_SecondaryBrassFunction(vOrigin, vForward, nExtendedData);
		}
	}
}