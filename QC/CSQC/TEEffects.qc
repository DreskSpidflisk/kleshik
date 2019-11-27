// Temporary Entity Effects
string GetRandomExplosionSound(vector vOrigin)
{ // Get Random Explosion Sound
	local float nRandom;
	local string strSound;
	if( pointcontents(vOrigin) < -2)
	{ // In Water
		nRandom = random();
		if(nRandom < 0.25)
			strSound = SOUND_KLESHIK_EXPLOSIONS_WATER1;
		else
		if(nRandom < 0.50)
			strSound = SOUND_KLESHIK_EXPLOSIONS_WATER2;
		else
		if(nRandom < 0.75)
			strSound = SOUND_KLESHIK_EXPLOSIONS_WATER3;
		else
			strSound = SOUND_KLESHIK_EXPLOSIONS_WATER4;
	}
	else
	{ // Standard Sound
		nRandom = random() * 7;
		if(nRandom < 1)
			strSound = SOUND_KLESHIK_EXPLOSIONS_1;
		else
		if(nRandom < 2)
			strSound = SOUND_KLESHIK_EXPLOSIONS_2;
		else
		if(nRandom < 3)
			strSound = SOUND_KLESHIK_EXPLOSIONS_3;
		else
		if(nRandom < 4)
			strSound = SOUND_KLESHIK_EXPLOSIONS_4;
		else
		if(nRandom < 5)
			strSound = SOUND_KLESHIK_EXPLOSIONS_5;
		else
		if(nRandom < 6)
			strSound = SOUND_KLESHIK_EXPLOSIONS_6;
		else
			strSound = SOUND_KLESHIK_EXPLOSIONS_7;
	}
	return strSound;
}
void CorpseBloodStainRemove()
{ // Corpse Blood Stain Remove
	self.alpha -= 0.005;
	if(self.alpha <= 0)
	{
		self.think = __NULL__;
		remove(self);
	}
	else
		self.nextthink = time;
}
void CorpseBloodStainThink()
{ // Corpse Blood Stain Think
	self.scale += 0.0002;
	if(self.scale > 0.25)
	{
		self.scale = 0.25;
		self.think = CorpseBloodStainRemove;
		self.nextthink = time + 120 + (random() * 60);
	}
	else
		self.nextthink = time;
}
void ParseLavaballImpact()
{ // Parse Lavaball Impact
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_MISC_LAVABALLIMPACT1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_MISC_LAVABALLIMPACT2, 1.0, ATTN_NORM);
		
	local string strSound;
		strSound = GetRandomExplosionSound(vOrigin);
	// Play Sound
	pointsound(vOrigin, strSound, 0.6, ATTN_NORM);
		
	// Produce Effect
	pointparticles( particleeffectnum("TE_FIREBALLEXPLOSION"), vOrigin, '0 0 0', 1);

}
void ParseCorpseBloodStain()
{ // Parse Corpse Blood Stain
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	
		
	// Spawn Entity
	local string strModel;
		strModel = "gfx/CorpseStain.spr32";
	local entity enBlood;
	enBlood = spawn();
	precache_model(strModel);
	setmodel(enBlood, strModel);
	enBlood.mins = '0 0 0';
	enBlood.maxs = '0 0 0';
	enBlood.drawmask = MASK_NORMAL;
	enBlood.scale = 0.01;
	enBlood.alpha = 1.0;
	// enBlood.colormod_x = 0.1 + random() * 0.1;
	enBlood.colormod_y = -0.5
	enBlood.colormod_z = -0.5
	setorigin(enBlood, vOrigin);
	// Calculate True Ground Location
	traceline(vOrigin, vOrigin - '0 0 50', true, enBlood);
	// Bump Up Slightly
	setorigin(enBlood, trace_endpos + '0 0 0.25');
	local vector vAngles;
		vAngles_x = 90;
		vAngles_y = random() * 180;
		vAngles_z = 0;
	enBlood.angles = vAngles;
	enBlood.nextthink = time;
	enBlood.think = CorpseBloodStainThink;
}
void ParseWizardSpike()
{ // Parse Wizard Spike
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if(random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_MONSTERS_SCRAG_MISSILEIMPACT1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_MONSTERS_SCRAG_MISSILEIMPACT2, 1.0, ATTN_NORM);
		
	// Produce Effect
	te_wizspike(vOrigin);
}
void ParseHeadOutOfWater()
{ // Parse Head Out of Water
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Read Liquid Type
	local float nType;
		nType = ReadByte() * -1;
		
	// Determine Splash Type
	local string strSplashType;
		
	switch(nType)
	{
		case CONTENT_WATER:
			strSplashType = "TE_WATERSPLASH_SLOW";
			break;
		case CONTENT_SLIME:
			strSplashType = "TE_SLIMESPLASH_SLOW";
			break;
		case CONTENT_LAVA:
			strSplashType = "TE_LAVASPLASH_SLOW";
			break;
		default:
			strSplashType = "";
			break;
	}
	
	// Produce Effect
	pointparticles( particleeffectnum(strSplashType), vOrigin, '0 0 20', 20);
		
	// Play Sound
	pointsound(vOrigin, SOUND_KLESHIK_PLAYER_HEADOUTWATER, 1.0, ATTN_NORM);
}
void ParseRapidLaserRicochet()
{ // Parse Rapid Laser Ricochet
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Produce Effect
	pointparticles( particleeffectnum("TE_RAPIDLASERRICOCHET"), vOrigin, '0 0 0', 1);
	
	// Play Sound
	if( random() < 0.40)
	{
		local float nRandom;
			nRandom = random();
		if(nRandom < 0.33)
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_RAPIDLASERRICOCHET1, 1.0, ATTN_NORM);
		else
		if(nRandom < 0.66)
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_RAPIDLASERRICOCHET2, 1.0, ATTN_NORM);
		else
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_RAPIDLASERRICOCHET3, 1.0, ATTN_NORM);
	}
}
void ParseRapidLaserFinalTouch()
{ // Parse Rapid Laser Final Touch
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Produce Effect
	pointparticles( particleeffectnum("TE_RAPIDLASERFINALTOUCH"), vOrigin, '0 0 0', 1);
	
	// Play Sound
	pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_LASERIMPACT1, 1.0, ATTN_NORM);
}
void ParseRobotExplosion()
{ // Parse Robot Explosion
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	te_customflash(vOrigin, 512, 1, '1 1 1');
	te_explosion(vOrigin);
	
	// Produce Quick Sparks
	pointparticles( particleeffectnum("TE_EXPLOSIONQUICKSPARKS"), vOrigin, '0 0 0', 150);
	
	// Produce Effect
	pointparticles( particleeffectnum("TE_ROBOTEXPLOSION"), vOrigin, '0 0 0', 1);
}
void ParseKnightSpike()
{ // Parse Knight Spike
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	local float nRandom;
		nRandom = random();
	if(nRandom < 0.33)
		pointsound(vOrigin, SOUND_KLESHIK_MONSTERS_HELLKNIGHT_MISSILEIMPACT1, 1.0, ATTN_NORM);
	else
	if(nRandom < 0.66)
		pointsound(vOrigin, SOUND_KLESHIK_MONSTERS_HELLKNIGHT_MISSILEIMPACT2, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_MONSTERS_HELLKNIGHT_MISSILEIMPACT3, 1.0, ATTN_NORM);
		
	// Produce Effect
	te_knightspike(vOrigin);
}
void ParseObjectInWater(float bLarge)
{ // Parse Liquid Body Splash Effect
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	// Read Liquid Type
	local float nType;
		nType = ReadByte() * -1;
	// Determine Splash Type
	local string strSplashType;
	
	local float nAmount;
	local string strSound;
	if(bLarge)
	{ // Large Splash
		nAmount = 750;
		strSound = SOUND_KLESHIK_IMPACTS_INWATER_LARGEOBJECT;
		
		switch(nType)
		{
			case CONTENT_WATER:
				strSplashType = "TE_WATERSPLASH_FAST";
				break;
			case CONTENT_SLIME:
				strSplashType = "TE_SLIMESPLASH_FAST";
				break;
			case CONTENT_LAVA:
				strSplashType = "TE_LAVASPLASH_FAST";
				break;
			default:
				strSplashType = "";
				break;
		}
	}
	else
	{ // Small Splash
		nAmount = 45;
		strSound = SOUND_KLESHIK_IMPACTS_INWATER_SMALLOBJECT;
		
		switch(nType)
		{
			case CONTENT_WATER:
				strSplashType = "TE_WATERSPLASH_SLOW";
				break;
			case CONTENT_SLIME:
				strSplashType = "TE_SLIMESPLASH_SLOW";
				break;
			case CONTENT_LAVA:
				strSplashType = "TE_LAVASPLASH_SLOW";
				break;
			default:
				strSplashType = "";
				break;
		}
	}
	
	// Produce Effect
	pointparticles( particleeffectnum(strSplashType), vOrigin, '0 0 0', nAmount);
	
	// Produce Sound
	pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
}
void ParseFireBallExplosion()
{ // Parse Fire Ball Explosion
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Produce Effect
	pointparticles( particleeffectnum("TE_FIREBALLEXPLOSION"), vOrigin, '0 0 0', 1);
	
	if( SG_AUTOCVAR(kleshik_client_explosions_createdynamiclights) )
		// Produce Light Radius
		pointparticles( particleeffectnum("TE_FIREBALLEXPLOSION_LIGHT"), vOrigin, '0 0 0', 1);
	
	local string strSound;
		strSound = GetRandomExplosionSound(vOrigin);
	// Play Sound
	pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
}
void ParseTarExplosion()
{ // Parse Tar Explosion
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Produce Explosion
	te_tarexplosion(vOrigin);
	
	local string strSound;
		strSound = GetRandomExplosionSound(vOrigin);
	// Play Sound
	pointsound(vOrigin, strSound, 0.8, ATTN_NORM);
	// Play Sound
	pointsound(vOrigin, SOUND_KLESHIK_EXPLOSIONS_TAREXPLOSION, 1.0, ATTN_NORM);
}
void ParseExplosionEffect(float nTEID)
{ // Parse Explosion Effect
	local float bSparks;
		bSparks = false;
	// Play Random Sound, then produce local explosion
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	local string strSound;
		strSound = GetRandomExplosionSound(vOrigin);
	// Play Sound
	pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
	
	// Play Correct Effect
	if(nTEID == TE_EXPLOSION)
	{
		te_explosion(vOrigin);
		bSparks = true;
		
		if( SG_AUTOCVAR(kleshik_client_explosions_createdynamiclights) )
			// Produce Light Radius
			pointparticles( particleeffectnum("TE_EXPLOSION_LIGHT"), vOrigin, '0 0 0', 1);
	}
	else
	if(nTEID == TE_EXPLOSION2)
	{
		local float fColor;
			fColor = ReadByte();
		local float fColorLength;
			fColorLength = ReadByte();
		te_explosion2(vOrigin, fColor, fColorLength);
	}
	else
	if(nTEID == TE_EXPLOSIONQUAD)
	{
		te_explosionquad(vOrigin);
		bSparks = true;
		
		if( SG_AUTOCVAR(kleshik_client_explosions_createdynamiclights) )
			// Produce Light Radius
			pointparticles( particleeffectnum("TE_EXPLOSIONQUAD_LIGHT"), vOrigin, '0 0 0', 1);
	}
	else
	if(nTEID == TE_EXPLOSIONRGB)
	{
		// Read Colors
		local vector vColor;
			vColor_x = ReadByte();
			vColor_y = ReadByte();
			vColor_z = ReadByte();
		te_explosionrgb(vOrigin, vColor);
		bSparks = true;
	}
	
	// Produce Quick Sparks
	pointparticles( particleeffectnum("TE_EXPLOSIONQUICKSPARKS"), vOrigin, '0 0 0', 150);
	
	// Produce Sparks for Fun!
	if(bSparks)
	{
		te_spark(vOrigin, randomvec() * 300, random() * 50);
		te_spark(vOrigin, randomvec() * 300, random() * 50);
		te_spark(vOrigin, randomvec() * 300, random() * 50);
		te_spark(vOrigin, randomvec() * 300, random() * 50);
	}
}
void ParseDamageFeedbackWithImpactTypeEffect()
{ // Parse Damage Feedback with Impact Type Effect
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	// Read Damage Amount
	local float fDamageAmount;
		fDamageAmount = ReadCoord();
	// Read Impact Type
	local float nImpactType;
		nImpactType = ReadByte();
		
	// Determine "Blood" Amount
	local float fBlood;
	fBlood = fDamageAmount * SG_AUTOCVAR(kleshik_client_bloodgore_bloodmultiplierfordamage);
	if(fBlood > 350)
		fBlood = 350;
	
	local float nRandom;
	local string strSound;
	if(nImpactType == IMPACTTYPE_FLESH || nImpactType == IMPACTTYPE_FLESH_SILENT)
	{
		if(nImpactType != IMPACTTYPE_FLESH_SILENT)
		{
			nRandom = random();
			if(nRandom < 0.20)
				strSound = SOUND_KLESHIK_IMPACTS_FLESHHIT1;
			else
			if(nRandom < 0.40)
				strSound = SOUND_KLESHIK_IMPACTS_FLESHHIT2;
			else
			if(nRandom < 0.60)
				strSound = SOUND_KLESHIK_IMPACTS_FLESHHIT3;
			else
			if(nRandom < 0.80)
				strSound = SOUND_KLESHIK_IMPACTS_FLESHHIT4;
			else
				strSound = SOUND_KLESHIK_IMPACTS_FLESHHIT5;
				
			pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
		}
		
		// Produce Bloodshower
		te_bloodshower(vOrigin, vOrigin, 600, fBlood);
	
		// Produce "Spark" Blood
		pointparticles( particleeffectnum("TE_BOUNCINGBLOOD"), vOrigin, '0 0 0', fBlood);
	}
	else
	if(nImpactType == IMPACTTYPE_METAL || nImpactType == IMPACTTYPE_METAL_SILENT)
	{
		if(nImpactType != IMPACTTYPE_METAL_SILENT)
		{
			nRandom = random();
			if(nRandom < 0.25)
				strSound = SOUND_KLESHIK_IMPACTS_METALHIT1;
			else
			if(nRandom < 0.50)
				strSound = SOUND_KLESHIK_IMPACTS_METALHIT2;
			else
			if(nRandom < 0.75)
				strSound = SOUND_KLESHIK_IMPACTS_METALHIT3;
			else
				strSound = SOUND_KLESHIK_IMPACTS_METALHIT4;
				
			pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
		}
		
		// Produce Sparks
		pointparticles( particleeffectnum("TE_GENERICSPREADSPARKS"), vOrigin, '0 0 0', fBlood);
		pointparticles( particleeffectnum("TE_AXEHITMATERIAL"), vOrigin, '0 0 0', 1);
	}
}
void ParseGunShotEffect(float nTEID)
{ // Parse GunShot Effect
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if(g_tLastBulletImpactTime < time)
	{ // Sound Time
		// Update Last Bullet Impact Time
		g_tLastBulletImpactTime = time;
		local float nRandom;
		local string strSound;
			nRandom = random();
		if(nRandom < 0.11)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT1;
		else
		if(nRandom < 0.22)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT2;
		else
		if(nRandom < 0.33)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT3;
		else
		if(nRandom < 0.44)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT4;
		else
		if(nRandom < 0.55)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT5;
		else
		if(nRandom < 0.66)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT6;
		else
		if(nRandom < 0.77)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT7;
		else
		if(nRandom < 0.88)
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT8;
		else
			strSound = SOUND_KLESHIK_IMPACTS_BULLETIMPACT9;
			
		// Play Sound
		pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
	}
		
	// Produce Gunshot
	if(nTEID == TE_GUNSHOT)
		te_gunshot(vOrigin);
	else
	if(nTEID == TE_GUNSHOTQUAD)
		te_gunshotquad(vOrigin);
		
	// Produce Sparks
	pointparticles( particleeffectnum("TE_GENERICSPREADSPARKS"), vOrigin, '0 0 0', 4);
}
void ParseGrenadeBounce()
{ // Parse Grenade Bounce
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_GRENADEBOUNCE1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_GRENADEBOUNCE2, 1.0, ATTN_NORM);
		
	// Produce Sparks
	te_spark(vOrigin, '0 0 100', 75);
}
void ParseFlareBounce()
{ // Parse Flare Bounce
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_FLARES_BOUNCE1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_FLARES_BOUNCE2, 1.0, ATTN_NORM);
		
	// Produce Sparks
	te_spark(vOrigin, '0 0 50', 10);
}
void ParseGenericWeaponFire()
{ // Parse Generic Weapon Fire
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
	
	pointparticles( particleeffectnum("TE_GENERICWEAPONFIRE"), vOrigin, vForward * 900, 90);
}
void ParseAxeHitMaterial()
{ // Parse Axe Hit Material
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Effect
	pointparticles( particleeffectnum("TE_AXEHITMATERIAL"), vOrigin, '0 0 0', 1);
}
void ParseSimpleLaserTouch()
{ // Parse Simple Laser Touch
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Effect
	pointparticles( particleeffectnum("TE_SIMPLELASERTOUCH"), vOrigin, '0 0 0', 1);
	// Produce Sparks
	te_spark(vOrigin, '0 0 100', 75);
	
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_LASERIMPACT1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_LASERIMPACT2, 1.0, ATTN_NORM);
}
void ParseLaserGunAltTouch()
{ // Parse Laser Gun Alt Touch
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Effect
	pointparticles( particleeffectnum("TE_LASERGUNALTTOUCH"), vOrigin, '0 0 0', 1);
	
	// Play Sound
	pointsound(vOrigin, GetRandomExplosionSound(vOrigin), 1.0, ATTN_NORM);
	
	te_spark(vOrigin, randomvec() * 300, random() * 50);
	te_spark(vOrigin, randomvec() * 300, random() * 50);
	te_spark(vOrigin, randomvec() * 300, random() * 50);
	te_spark(vOrigin, randomvec() * 300, random() * 50);
	te_spark(vOrigin, randomvec() * 300, random() * 50);
	te_spark(vOrigin, randomvec() * 300, random() * 50);
}
void ParseItemRespawn()
{ // Parse Item Respawn
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	pointsound(vOrigin, SOUND_KLESHIK_ITEMS_RESPAWN, 1.0, ATTN_NORM);
	
	// Play Effect
	pointparticles( particleeffectnum("TE_ITEMRESPAWN"), vOrigin, '0 0 0', 1);
}
void ParseSmallDustKickup()
{
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Effect
	pointparticles( particleeffectnum("TE_SMALLDUSTKICKUP"), vOrigin, '0 0 0', 1);
}
void ParseCorpseDustSmash()
{ // Parse Corpse Dust Dmash
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	// Read Impact Type
	local float nImpactType;
		nImpactType = ReadByte();
	
	// Play Effect
	pointparticles( particleeffectnum("TE_CORPSEDUSTSMASH"), vOrigin, '0 0 0', 1);
	
	// Play Sound
	local string strSound;
	local float nRandom;
	nRandom = random();
	
	if(nImpactType == IMPACTTYPE_FLESH)
	{
		if(nRandom < 0.25)
			strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND1;
		else
		if(nRandom < 0.50)
			strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND2;
		else
		if(nRandom < 0.75)
			strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND3;
		else
			strSound = SOUND_KLESHIK_GORE_FLESHCORPSELAND4;
	}
	else
	if(nImpactType == IMPACTTYPE_METAL)
	{
		if(nRandom < 0.33)
			strSound = SOUND_KLESHIK_GORE_METALCORPSELAND1;
		else
		if(nRandom < 0.66)
			strSound = SOUND_KLESHIK_GORE_METALCORPSELAND2;
		else
			strSound = SOUND_KLESHIK_GORE_METALCORPSELAND3;
		/*
		else
			strSound = SOUND_KLESHIK_GORE_METALCORPSELAND4;
		*/
	}
	pointsound(vOrigin, strSound, 1.0, ATTN_NORM);
}
void ParseCorpseLargeDustSmash()
{ // Parse Corpse Large Dust Dmash
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
	
	// Play Effect
	pointparticles( particleeffectnum("TE_CORPSELARGEDUSTSMASH"), vOrigin, '0 0 0', 1);
	
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_GORE_LARGEFLESHCORPSELAND1, 1.0, ATTN_NONE);
	else
		pointsound(vOrigin, SOUND_KLESHIK_GORE_LARGEFLESHCORPSELAND2, 1.0, ATTN_NONE);
}
void ParseEliteMonsterDeath()
{ // Parse Elite Monster Death
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	local string strSound;
	local float nRandom;
	nRandom = random();
	
	if(nRandom < 0.5)
		strSound = SOUND_KLESHIK_ELITEMONSTER_DEATH1;
	else
		strSound = SOUND_KLESHIK_ELITEMONSTER_DEATH2;
	localcmd("play2 ", strSound, "\n");
	
	// Produce Visual Effects
	pointparticles( particleeffectnum("TE_ELITEMONSTERDEATH"), vOrigin, '0 0 0', 1);
}
void ParseEliteMonsterRedirectProjectile()
{ // Parse Elite Monster Redirect Projectile
	// Read Origin
	local vector vOrigin;
		vOrigin_x = ReadCoord();
		vOrigin_y = ReadCoord();
		vOrigin_z = ReadCoord();
		
	// Play Sound
	if( random() < 0.5)
		pointsound(vOrigin, SOUND_KLESHIK_ELITEMONSTER_REDIRECTPROJECTILE1, 1.0, ATTN_NORM);
	else
		pointsound(vOrigin, SOUND_KLESHIK_ELITEMONSTER_REDIRECTPROJECTILE2, 1.0, ATTN_NORM);
		
	// Produce Visual Effects
	pointparticles( particleeffectnum("TE_ELITEMONSTERREDIRECTPROJECTILE"), vOrigin, '0 0 0', 1);
}