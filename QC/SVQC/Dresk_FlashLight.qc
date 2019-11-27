// DRESK - Flash Light
// Provides values, definitions, functions and more for the flash light.

#define FLASHLIGHT_TYPE_NONE									0
#define FLASHLIGHT_TYPE_POINTSOURCE								1
#define FLASHLIGHT_TYPE_CUBEMAP									2

#define FLASHLIGHT_MAXLIGHTLEVEL								500
#define FLASHLIGHT_MINBATTERY									175

#define FLASHLIGHT_USECUBEMAPLIGHT

// Field Definitions
.float		nFlashLightTypeActive;
.float		nFlashLightTypeEnableOnSpawn;
.float		fFlashLightDistance;
.entity		enFlashLightSource;
.float		fFlashLightBattery;
.float		fFlashLightMaxBattery;

.float		bSpawnedFlashLightTemporaryEntity;

void SetFlashLightFullBattery(entity enClient)
{ // Set Flash Light Full Battery
	// Update Battery Charge Here
	self.fFlashLightMaxBattery = cvar(CVAR_FLASHLIGHT_MAXBATTERYCHARGE);
	
	enClient.fFlashLightBattery = self.fFlashLightMaxBattery;
}
void UpdateFlashLight()
{ // Update Flash Light
	// NOTE: Assumed scope is flash light user during PreThink.
	// Always Send Minimum Light Level
	self.fCSQCStat_FlashLightMinimumAmbientLevel = SG_AUTOCVAR(kleshik_server_FlashLight_MinimumAmbientLevel);
	if(self.nFlashLightTypeActive)
	{ // Flash Light Active
		local float fSelfBlindingDistance;
			fSelfBlindingDistance = 45;
		// Create Vectors
		makevectors(self.v_angle);
		
		// Acquire Origin
		local vector vOrigin;
			if(self.bIsCrouching && g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
				vOrigin = self.origin + (FLASHLIGHT_ORIGINOFFSET - '0 0 8');
			else
				vOrigin = self.origin + FLASHLIGHT_ORIGINOFFSET;
		local float fDistance;
			fDistance = self.fFlashLightDistance;
			
		// Perform Trace
		traceline(vOrigin, vOrigin + (v_forward * fDistance) + (v_right * FLASHLIGHT_TRACEMULTIPLIER_RIGHT), FALSE, self);
		// Calculate Working End Position
		local vector vEndPos;
			// NOTE : No longer really need this
			// Bring inward slightly to prevent wall clipping
			// vEndPos = trace_endpos - (v_forward * 6);
			vEndPos = trace_endpos;
		if(self.nFlashLightTypeActive == FLASHLIGHT_TYPE_CUBEMAP)
		{ // Cubemap Light
			// Update Angles
			self.enFlashLightSource.angles = self.v_angle;
			self.enFlashLightSource.angles_x = self.enFlashLightSource.angles_x * -1;
			
			// Update Light Level from Battery
			if(self.fFlashLightMaxBattery)
			{
				self.enFlashLightSource.light_lev = min(self.fFlashLightBattery, FLASHLIGHT_MAXLIGHTLEVEL);
				// Sync Light Level with CSQC Light Level
				self.fCSQCStat_FlashLightLightLevel = self.enFlashLightSource.light_lev;
			}
			// Decrement Charge
			// self.fFlashLightBattery = max(self.fFlashLightBattery - (frametime * 45), FLASHLIGHT_MINBATTERY);
		}
		// Assign Flash Light Entity to Origin
		setorigin(self.enFlashLightSource, vEndPos);
		
		// Calculate Distance for Monster Detection
		traceline(vOrigin, vOrigin + (v_forward * (self.enFlashLightSource.light_lev / 1.5) ), FALSE, self);
		// Bring inward slightly to prevent wall clipping
		vEndPos = trace_endpos - (v_forward * 6);
		
		if(trace_ent.flags & FL_MONSTER && trace_ent.health > 0)
			// Wake Monsters Up
			self.show_hostile = time + 1;
	}
	else
	{ // Flash Light Off
		// Charge Battery
		self.fFlashLightBattery = min(self.fFlashLightBattery + (frametime * 95), self.fFlashLightMaxBattery);
		// Flash Light Off; Tell CSQC Light Level is 0
		self.fCSQCStat_FlashLightLightLevel = 0;
	}
}
void CheckFlashLightSourceEntity()
{ // Check Flash Light Source Entity
	if(self.nFlashLightTypeActive)
	{ // Flash Light Active; Check for Entity
		if(!self.enFlashLightSource)
		{ // Flash Light Entity Creation Necessary
			local entity enSource;
			
			// Create Entity
			enSource = spawn();
			// Assign origin
			setorigin(enSource, self.origin);
			// Assign Blank Model
			setmodel(enSource, "");
			// Assign Entity Source
			self.enFlashLightSource = enSource;
			// Disable Drawing to Owner Entity (flashlight handled in CSQC)
			self.enFlashLightSource.nodrawtoclient = self;
			
			// Prepare Cubemap Parameters
			self.enFlashLightSource.color = '2 2 2';
			self.enFlashLightSource.style = 255;
			self.enFlashLightSource.skin = 1;
		}
		
		// Check for Light Type
		if(self.nFlashLightTypeActive == FLASHLIGHT_TYPE_POINTSOURCE)
		{ // Point Source Flash Light
			if(self.nCSQCStat_Powerups & POWERUP_QUADDAMAGE)
				// Quad Damage; Bright Light
				self.enFlashLightSource.effects = EF_BRIGHTLIGHT;
			else
				// Non-Quad Damage; Dim Light
				self.enFlashLightSource.effects = EF_DIMLIGHT;
		}
		else
		if(self.nFlashLightTypeActive == FLASHLIGHT_TYPE_CUBEMAP)
		{ // Cube Map
			// Enable Rendering
			self.enFlashLightSource.pflags = PFLAGS_FULLDYNAMIC;
			// Remove All Effects
			self.enFlashLightSource.effects = 0;
		}
		// Assign Flash Light Distance Here
		// NOTE: Performed here for performance reasons, to not
		// CVar-bash every frame.
		self.fFlashLightDistance = FLASHLIGHT_TRACEMULTIPLIER_FORWARD;
		
		// Update Battery Charge Here
		self.fFlashLightMaxBattery = cvar(CVAR_FLASHLIGHT_MAXBATTERYCHARGE);
	}
	else
	{ // Flash Light Not Active; Check for Entity
		if(self.enFlashLightSource)
		{ // Flash Light Entity Exists; Assign No Draw
			self.enFlashLightSource.effects = EF_NODRAW;
			self.enFlashLightSource.pflags = 0;
		}
	}
}
void ToggleFlashLight(float nFlashLightTypeForce)
{ // Toggle Flash Light
	// NOTE: Assumed scope is flash light user.
	local string strSound;
	local string strMessage;
		strMessage = "Flash Light ^2";
	
	if(self.nFlashLightTypeActive)
	{ // Flash Light Active
		strMessage = strcat(strMessage, "Deactivated");
		// Flag Unactive Flash Light
		self.nFlashLightTypeActive = FLASHLIGHT_TYPE_NONE;
		strSound = SOUND_KLESHIK_FLASHLIGHT_OFF;
	}
	else
	{ // Flash Light Not Active
		strMessage = strcat(strMessage, "Activated");
		// Flag Active Flash Light
		if(nFlashLightTypeForce != FLASHLIGHT_TYPE_NONE)
			self.nFlashLightTypeActive = nFlashLightTypeForce;
		else
			self.nFlashLightTypeActive = FLASHLIGHT_TYPE_CUBEMAP;
		
		strSound = SOUND_KLESHIK_FLASHLIGHT_ON;
	}
	// Finish Message
	strMessage = strcat(strMessage, "^7...\n");
	// Play Sound
	sound(self, CHAN_AUTO, strSound, 1, ATTN_NORM);
	// Induce Flash
	te_smallflash(self.origin);
	// Check for Flash Light Source Entity
	CheckFlashLightSourceEntity();
	
	// Display Message
	// sprint(self, strMessage);
}
void FlashLightSpawnTE( void(vector) fpTE, string strSound)
{ // Flash Light Spawn TE
	// Fun for Random Crap!
	if(self.enFlashLightSource)
	{ // Valid Flash Light
		// Spawn Temporary Entity
		fpTE(self.enFlashLightSource.origin);
		// Apply Radius Damage
		T_RadiusDamage(self.enFlashLightSource, self, DAMAGETYPE_WEAPON_ROCKETLAUNCHER, 250, self.enFlashLightSource);
		
		if(strSound != "")
		{ // Valid Sound; Play
			sound(self.enFlashLightSource, CHAN_AUTO, strSound, 1, ATTN_NORM);
		}
	}
}
void CheckFlashLightOnDeath()
{ // Check Flash Light on Death
	// NOTE: Assumed scope is flash light user.
	// Determine Flash Light Spawn Status
	self.nFlashLightTypeEnableOnSpawn = self.nFlashLightTypeActive;
		
	// Force Disable Flash Light
	self.nFlashLightTypeActive = FLASHLIGHT_TYPE_NONE;
	CheckFlashLightSourceEntity();
}