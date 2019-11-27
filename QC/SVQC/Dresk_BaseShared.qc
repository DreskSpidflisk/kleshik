// DRESK - Base
// Provides the base / shared functionality for the modification.

#define BODYINWATER_HEAVYHITVELOCITY								285

// Fields
// State-Based Alpha
.float	bEntityHasActiveAlpha;
.float	fEntityRestoreAlpha;
// State-Based Colormod
.float bEntityHasActiveColormod;
.vector vEntityRestoreColormod;

void PrepareMapLoadCVars()
{ // Prepare Map Load CVars
	// Prepare Game Mode CVars
	PrepareGameModeCVars();
	
	// Update Max Velocity
	cvar_set("sv_maxvelocity", "3000");

	// Prepare Proximity Gun Allow Alt Fire Detonation
	g_bProximityGunAllowAltFireDetonation = cvar(CVAR_WEAPON_PROXIMITYGUN_ALLOWALTFIREDETONATION);
	// Prepare Night and Day Entity Vars
	g_nNightAndDayMinLightLevel = cvar(CVAR_WORLD_NIGHTANDDAY_MINLIGHTLEVEL);
	g_nNightAndDayMaxLightLevel = cvar(CVAR_WORLD_NIGHTANDDAY_MAXLIGHTLEVEL);
	// Prepare Player Model Crouch Interactivity Level
	g_nCrouch_InteractivityLevel = cvar(CVAR_PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL);
}
float CheckAndRemoveEntity(entity enOwner, .entity enEntity)
{ // Check and Remove Entity
	if(enOwner.enEntity)
	{ // Entity Exists; Remove
		remove(enOwner.enEntity);
		enOwner.enEntity = world;
		return TRUE;
	}
	else
		return FALSE;
}
float CheckBrushCrushInstantKill(entity enEntity, float fDamageType)
{ // Check Brush Crush Instant Kill
	// NOTE: Assumed scope is brush performing crush.  Returns TRUE if damage is performed
	local float fReturn;
		fReturn = TRUE;
	local float nCrushKillsLevel;
		nCrushKillsLevel = cvar(CVAR_WORLD_BRUSHCRUSHESINSTANTKILL);
		
	if(
		nCrushKillsLevel > 1
		|| (enEntity.flags & FL_MONSTER && nCrushKillsLevel > 0)
		|| (enEntity.classname == "player" && nCrushKillsLevel > 1)
	)
		T_Damage (enEntity, self, self, HITLOCATION_NONE, fDamageType, BRUSHCRUSH_INSTANTKILL_DAMAGE);
	else
		fReturn = FALSE;
		
	return fReturn;
}

void SilentContentsTransition(float nOriginalContents, float nNewContents)
{ // Silent Contents Transition
}
void SilentContentsTransition_GrenadeMFInWater(float nOriginalContents, float nNewContents)
{ // Silent Contents Transition - Grenade Model Flag in Water
	// Check for Self (DP currently has the small chance to not be valid)
	if(self)
	{ // Valid Self (good)
		if(nNewContents == CONTENT_WATER || nNewContents == CONTENT_SLIME)
			self.modelflags = self.modelflags | MF_GRENADE;
		else
			self.modelflags = self.modelflags - (self.modelflags & MF_GRENADE);
	}
}
void ContentsTransition_SmallObjectInWater(float nOriginalContents, float nNewContents)
{ // Small Object in Water Contents Transition
	if(self)
	{
		if( (nNewContents == CONTENT_WATER || nNewContents == CONTENT_SLIME || nNewContents == CONTENT_LAVA) && fabs(self.velocity_z) > 75)
			// Play Event
			te_SmallObjectInWater(self, nNewContents);
	}
}
void ContentsTransition_BodyInWater(float nOriginalContents, float nNewContents)
{ // Body in Water Contents Transition
	if(self)
	{
		if(nNewContents == CONTENT_WATER || nNewContents == CONTENT_SLIME || nNewContents == CONTENT_LAVA)
		{ // Valid New Water Contents
			if( fabs(self.velocity_z) > BODYINWATER_HEAVYHITVELOCITY)
			{ // Heavy Water Hit
				te_LargeObjectInWater(self, nNewContents);
			}
			else
			{ // Standard Water Hit
				// Play Sound
				sound (self, CHAN_AUTO, "misc/h2ohit1.wav", 1, ATTN_NORM);
			}
		}
	}
}
float GetRandomVectorValue(float fMinimumVector)
{ // Return Random Vector Value
	local float fReturn;
	
	fReturn = ( (random() * (1 - fMinimumVector) ) + fMinimumVector);
	
	return fReturn;
}

vector GetLeadingProjectileOrigin(entity enSelf, vector vSelfOrigin, entity enTarget, float fProjectileSpeed, float fLossyAmount)
{ // Get Leading Projectile Origin
	local float fSpeed;
		fSpeed = vlen(enTarget.origin - vSelfOrigin) / fProjectileSpeed;
	local vector vOrigin;
	local vector vReturn;
		vOrigin = enTarget.velocity;
		vOrigin_z = 0;
		
	vReturn = enTarget.origin + (fSpeed * vOrigin);
	
	vReturn = normalize(vReturn - vSelfOrigin);
	
	if(fLossyAmount)
	{ // Append some Miscalculation
		vReturn_x = vReturn_x + (random() * fLossyAmount);
		vReturn_y = vReturn_y + (random() * fLossyAmount);
		vReturn_z = vReturn_z + (random() * fLossyAmount);
		
		vReturn = normalize(vReturn);
	}
		
	return vReturn;
}
string AppendCVarStringToMessage(string strCVar, string strInformation, float nWidth)
{ // Append CVar String to Message
	local string strReturn;
	
	if( cvar(strCVar) )
	{ // CVar is Valid
		strReturn = strcat(strInformation, "\n");
	}
	
	return strReturn;
}

// NOTE
// Still working on this crap.
string AppendFormattedCvar(string strMessage, string strCVar, float fDesiredCVarWidth, float fDesiredLineWidth)
{ // Append Formatted CVar
	local string strReturn;
	local string strFinal;
	local float fCnt;
	local float fWidth;
	
	// Append CVar
	strReturn = strcat("\n", strCVar);
	
		// Apply Additional Spacing to CVar
		fCnt = 0;
		fWidth = fDesiredCVarWidth - strlen(strReturn);
		while(fCnt < fWidth)
		{ // Append Spaces
			strReturn = strcat(strReturn, " ");
			fCnt++;
		}
		
	// Append Separator
	strReturn = strcat(strReturn, " : ");
	
	// Append CVar Value
	strReturn = strcat(strReturn, cvar_string(strCVar) );
	
		// Apply Additional Spacing to CVar
		fCnt = 0;
		fWidth = fDesiredLineWidth - strlen(strReturn);
		while(fCnt < fWidth)
		{ // Append Spaces
			strReturn = strcat(strReturn, " ");
			fCnt++;
		}
	
	strFinal = strcat(strMessage, strReturn);
	return strFinal;
}
void GetAlignedSurfaceAngles(entity enEntity)
{ // Return Aligned Surface Angles
	// NOTE: div0 from Team Alientrap completely designed this algorithm.
	// Thanks div0!
	// Acquire Surface Normal
	traceline (enEntity.origin, enEntity.origin - '0 0 128', TRUE, enEntity);
	
	if(trace_fraction != 1)
	{ // Trace Found Surface; Continue
		local vector vNormal;
			vNormal = trace_plane_normal;
		
		// Derive Vectors
		makevectors(enEntity.angles);
			
		// Assign Aligned Angles
		enEntity.angles = vectoangles( normalize(v_forward - ( (v_forward * vNormal) / (v_up * vNormal)) * v_up) );
	}
}

void CreateSpawnPointModel()
{ // Create Spawn Point Model
	// NOTE: Assumed scope is creation of spawn point.
	local float bCreate;
		bCreate = FALSE;
		
	// Check Ambient Sound Spawn
	CheckAmbientSoundSpawn();
		
	if(self.classname == "info_player_deathmatch")
	{ // Deathmatch Spawn Point
		if(deathmatch)
			bCreate = TRUE;
	}
	else
	if(!deathmatch)
		bCreate = TRUE;
		
	if(bCreate && cvar(CVAR_WORLD_CREATESPAWNPOINTMODELS) )
	{ // Spawn Point Models Enablde
		// Backup Current Spawnpoint Entity
		local vector vOrigin;
		local entity enSpawn;
			enSpawn = self;
			
		// Create Spawn Point
		self = spawn();
			// Assign Model
			setmodel(self, "progs/invulner.mdl");
			// Assign Flags
			self.flags = 0;
			// Assign Size (item)
			setsize(self, '0 0 0', '0 0 0');
			// setsize (self, '-16 -16 -24', '16 16 32');
			// Assign Angles
			self.angles = '90 90 0';
			// Assign Scale
			self.scale = 1.0;
			// Assign Alpha Blend
			self.alpha = 1.0;
			// Assign Effects
			self.effects = EF_NOSHADOW | EF_LOWPRECISION | EF_FULLBRIGHT;
			// Assign Movetype
			self.movetype = MOVETYPE_NONE;
			// Assign Solid
			self.solid = SOLID_NOT;
			// Assign Origin
				// Step 1 : Set Spawn Origin
					vOrigin = enSpawn.origin;
					setorigin(self, vOrigin);
				// Step 2: Drop to Floor
					droptofloor();
				// Step 3 : Append Additional Raise
					setorigin(self, self.origin + '0 0 2');
				// Step 4 : Shift
					makevectors(self.angles);
					setorigin(self, self.origin + v_up * -20);
				
			// Attach to Spawn Point (prevent bobbing)
			// NOTE: Does not work.
			// Make Static (prevent bobbing)
			// NOTE: Doesn't copy effects, scale or alpha.  Definitely not a very good
			// system, but it does prevent the bobbing.
			makestatic(self);
			
		// Restore Spawn Entity
		self = enSpawn;
	}
}

void ContentsChangeReport()
{ // Simple Debug Report for Contents Changing
	bprint( strcat(self.netname, "^7 changed contents!\n") );
}
void CheckTimeDelta(entity enEntity, .float tTimeField)
{ // Check Time Delta
	bprint( strcat("Time Delta : ", ftos(time - enEntity.tTimeField), "\n") );
	enEntity.tTimeField = time;
}
void TeleporterFadingEntityCopyThink()
{ // Teleporter Fading Entity Copy Think
	if(self.alpha > 0)
	{ // Alpha Still Exists; Decrement
		// Decrement Alpha
		self.alpha = self.alpha - 0.1;
		// Update Think
		self.nextthink = time + 0.1;
	}
	else
		// Alpha Faded; Remove Entity
		remove(self);
}
void SpawnTeleporterFadingEntityCopy(entity enEntity)
{ // Spawn Teleporter Fading Entity Copy
	local entity enSpawn;
	enSpawn = spawn();
	// Assign Base Non-Interactive Properties
	enSpawn.solid = SOLID_NOT;
	enSpawn.movetype = MOVETYPE_NONE;
	enSpawn.alpha = 1;
	// Copy Properties of Entity
	setmodel(enSpawn, enEntity.model);
	setorigin(enSpawn, enEntity.origin);
	
	enSpawn.modelindex = enEntity.modelindex;
	enSpawn.colormod = enEntity.colormod;
	enSpawn.colormap = enEntity.colormap;
	enSpawn.frame = enEntity.frame;
	enSpawn.angles = enEntity.angles;
	enSpawn.skin = enEntity.skin;
	enSpawn.scale = enEntity.scale;
	
	// Setup Think Operations
	enSpawn.think = TeleporterFadingEntityCopyThink;
	enSpawn.nextthink = time + 0.2;
}
float SetNewEntityAlpha(entity enEntity, float fAlpha)
{ // Set New Entity Alpha
	local float bReturn;
		bReturn = TRUE;
	if(enEntity.bEntityHasActiveAlpha)
		bReturn = FALSE;
	else
	{ // Alpha May be Applied
		// Assign Restore Alpha
		enEntity.fEntityRestoreAlpha = enEntity.alpha;
		// Assign New Alpha
		enEntity.alpha = fAlpha;
		// Set Has Active Alpha
		enEntity.bEntityHasActiveAlpha = TRUE;
	}
	
	return bReturn;
}
void RestoreEntityAlpha(entity enEntity)
{ // Restore Entity Alpha
	if(enEntity.bEntityHasActiveAlpha)
	{ // Valid Active Alpha
		// Restore Alpha
		enEntity.alpha = enEntity.fEntityRestoreAlpha;
		// Remove Properties
		enEntity.fEntityRestoreAlpha = 0;
		enEntity.bEntityHasActiveAlpha = FALSE;
	}
}
float SetNewEntityColormod(entity enEntity, vector vColormod)
{ // Set New Entity Colormod
	local float bReturn;
		bReturn = TRUE;
	if(enEntity.bEntityHasActiveColormod)
		bReturn = FALSE;
	else
	{ // Colormod May be Applied
		// Assign Restore Colormod
		enEntity.vEntityRestoreColormod = enEntity.colormod;
		// Assign New Colormod
		enEntity.colormod = vColormod;
		// Set Player Has Active Colormod
		enEntity.bEntityHasActiveColormod = TRUE;
	}
	
	return bReturn;
}
void RestoreEntityColormod(entity enEntity)
{ // Restore Entity Colormod
	if(enEntity.bEntityHasActiveColormod)
	{ // Valid Active Colormod
		// Restore Colormod
		enEntity.colormod = enEntity.vEntityRestoreColormod;
		// Remove Properties
		enEntity.vEntityRestoreColormod = '0 0 0';
		enEntity.bEntityHasActiveColormod = FALSE;
	}
}