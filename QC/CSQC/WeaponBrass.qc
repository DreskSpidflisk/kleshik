// DRESK
// Client-side Weapon Brass

#define OBJECT_BRASSCASING_SHELL								"Models/Objects/BrassCasings/CasingShell.mdl"
#define OBJECT_BRASSCASING_BRONZE								"Models/Objects/BrassCasings/CasingBronze.mdl"
#define OBJECT_BRASSCASING_STEEL								"Models/Objects/BrassCasings/CasingSteel.mdl"

// #define OBJECT_BRASSCASING_DEFAULTVOLUME						(random() * 0.7) + 0.3
#define OBJECT_BRASSCASING_DEFAULTVOLUME						1.0

#define OBJECT_BRASSCASING_DEFAULTSCALE							1.0

.float tNextBrassImpactTime;

void BrassImpact_Shotgun(vector vMaxParticleVelocity, vector vOrigin)
{
	if(time > self.tNextBrassImpactTime && vlen(vMaxParticleVelocity) > 200)
	{
		if( random() > 0.5)
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_SHOTGUNSHELLIMPACT1, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		else
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_SHOTGUNSHELLIMPACT2, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		self.tNextBrassImpactTime = time + 0.1;
	}
}
void BrassImpact_Metal(vector vMaxParticleVelocity, vector vOrigin)
{
	local float nRandom;
	if(time > self.tNextBrassImpactTime && random() > 0.7 && vlen(vMaxParticleVelocity) > 200)
	{
		nRandom = random();
		if(nRandom < 0.33)
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT1, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		else
		if(nRandom < 0.66)
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT2, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		else
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_METALBRASSIMPACT3, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		self.tNextBrassImpactTime = time + 0.1;
	}
}
void BrassImpact_Bronze(vector vMaxParticleVelocity, vector vOrigin)
{
	local float nRandom;
	if(time > self.tNextBrassImpactTime && random() > 0.7 && vlen(vMaxParticleVelocity) > 200)
	{
		nRandom = random();
		if(nRandom < 0.5)
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_BRONZEBRASSIMPACT1, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		else
		{
			pointsound(vOrigin, SOUND_KLESHIK_IMPACTS_BRASS_BRONZEBRASSIMPACT2, OBJECT_BRASSCASING_DEFAULTVOLUME, ATTN_NORM);
		}
		self.tNextBrassImpactTime = time + 0.1;
	}
}
void PrecacheWeaponBrass()
{
	precache_model(OBJECT_BRASSCASING_SHELL);
	precache_model(OBJECT_BRASSCASING_BRONZE);
	precache_model(OBJECT_BRASSCASING_STEEL);
}

void Brass_Shotgun(vector vOrigin, vector vDirection, float nExtendedData)
{
	makevectors( vectoangles(vDirection) );
	local float fRandom;
		fRandom = random() * 10;
	local entity enBrass;
	
	enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
		v_right * 120 + v_up * 120 + v_forward * fRandom,
		vOrigin + v_forward * 2,
		v_right * 80 + v_up * 130 + v_forward * fRandom,
		OBJECT_BRASSCASING_SHELL,
		OBJECT_BRASSCASING_DEFAULTSCALE,
		8 + random() * 5);
		
	enBrass.fpImpactFunction = BrassImpact_Shotgun;
}
void Brass_SuperShotgun(vector vOrigin, vector vDirection, float nExtendedData)
{
	makevectors( vectoangles(vDirection) );
	local float fRandom;
		fRandom = random() * 10;
	local entity enBrass;
	
	enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
		v_right * 120 + v_up * 80 + v_forward * fRandom,
		vOrigin + v_forward * 2,
		v_right * 80 + v_up * 90 + v_forward * fRandom,
		OBJECT_BRASSCASING_SHELL,
		OBJECT_BRASSCASING_DEFAULTSCALE,
		8 + random() * 5);
		
	enBrass.fpImpactFunction = BrassImpact_Shotgun;
		
	enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
		v_right * -120 + v_up * 120,
		vOrigin + v_forward * 2,
		v_right * -80 + v_up * 130,
		OBJECT_BRASSCASING_SHELL,
		OBJECT_BRASSCASING_DEFAULTSCALE,
		8 + random() * 5);
		
	enBrass.fpImpactFunction = BrassImpact_Shotgun;
}
void Brass_Nailgun(vector vOrigin, vector vDirection, float nExtendedData)
{
	if(nExtendedData != 3)
	{ // Produce Brass
		makevectors( vectoangles(vDirection) );
		local entity enBrass;
		local float fRandom;
			fRandom = random() * 10;
		
		if(nExtendedData == 1)
		{
			enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
				v_right * -120 + v_up * 120 + v_forward * fRandom,
				vOrigin + v_forward * 2,
				v_right * -80 + v_up * 130 + v_forward * fRandom,
				OBJECT_BRASSCASING_STEEL,
				0.5,
				3 + random() * 5);
		}
		else
		{
			enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
				v_right * 120 + v_up * 120 + v_forward * fRandom,
				vOrigin + v_forward * 2,
				v_right * 80 + v_up * 130 + v_forward * fRandom,
				OBJECT_BRASSCASING_STEEL,
				0.5,
				3 + random() * 5);
		}
		
		enBrass.fpImpactFunction = BrassImpact_Metal;
	}
}
void Brass_ChainGun(vector vOrigin, vector vDirection, float nExtendedData)
{
	makevectors( vectoangles(vDirection) );
	local entity enBrass;
	local float fRandom;
		fRandom = random() * 10;
	local float fRandom2;
		fRandom2 = random() * 2;
	
	// Pick a Side
	if(random() < 0.5)
	{
		enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
			v_right * -120 + v_up * 120 + v_forward * fRandom,
			vOrigin + v_forward * 2,
			v_right * -80 + v_up * 130 + v_forward * fRandom,
			OBJECT_BRASSCASING_BRONZE,
			0.6,
			3 + random() * 5);
	}
	else
	{
		enBrass = Ragdoll_ThrowCasing(vOrigin + v_forward * 4,
			v_right * 120 + v_up * 120 + v_forward * fRandom,
			vOrigin + v_forward * 2,
			v_right * 80 + v_up * 130 + v_forward * fRandom,
			OBJECT_BRASSCASING_BRONZE,
			0.6,
			3 + random() * 5);
	}
		
	enBrass.fpImpactFunction = BrassImpact_Bronze;
}