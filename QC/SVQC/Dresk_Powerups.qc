// DRESK
// Powerups

// Definitions

// Fields
.float	tPowerupApplyTime;

// Functions
void powerup_touch()
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;
		
	// DRESK
	// Check Update Advanced Statistics
	if(!self.bIsDroppedItem)
		CheckUpdatedAdvancedStatistics();

	// DRESK
	// Generate Pickup Message at Bottom
	local float fAddTime;
		fAddTime = 0;

	if (deathmatch)
	{
		self.mdl = self.model;
		
		if ((self.classname == "item_artifact_invulnerability") ||
			(self.classname == "item_artifact_invisibility"))
			self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_POWERUP) * 7;
		else
			self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_POWERUP);
		
		self.think = SUB_regen;
	}	
	
	// DRESK
	// Support Coop Respawn Items
	if ( CheckCooperativeItemRespawn( cvar(CVAR_ITEM_RESPAWNTIME_POWERUP) ) )
	{ // Cooperative Item Respawn
		self.nextthink = time + cvar(CVAR_ITEM_RESPAWNTIME_POWERUP);
		self.think = SUB_regen;
	}

	// DRESK
	// Support Global Sounds
	if( cvar(CVAR_ITEM_POWERUP_GLOBALPICKUPSOUNDS) )
		sound (world, CHAN_AUTO, self.noise, 1, ATTN_NONE);
	else
		sound (other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		
	#ifndef SUPPRESSCLIENTBFCOMMANDS
	stuffcmd (other, "bf\n");
	#endif
	
	// Add Powerup to Powerup Stats
	other.nCSQCStat_Powerups = other.nCSQCStat_Powerups | self.nCSQCStat_Powerups;
	
	// DRESK
	// Support Faded Items
	if( !CheckFadedItem() )
		self.model = string_null;
	self.solid = SOLID_NOT;

	// Apply the Powerup
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.tCSQCStat_PowerupEndTime_Biosuit - time);
			if(fAddTime < 1)
				fAddTime = 0;
			
		other.tCSQCStat_PowerupEndTime_Biosuit = time + self.tPowerupApplyTime + fAddTime;
		// other.radsuit_finished = time + 30;
	}
	else
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.tCSQCStat_PowerupEndTime_Invulnerability - time);
			if(fAddTime < 1)
				fAddTime = 0;
		
		other.tCSQCStat_PowerupEndTime_Invulnerability = time + self.tPowerupApplyTime + fAddTime;
		// other.invincible_finished = time + 30;
	}
	else
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.tCSQCStat_PowerupEndTime_Invisibility - time);
			if(fAddTime < 1)
				fAddTime = 0;

		other.tCSQCStat_PowerupEndTime_Invisibility = time + self.tPowerupApplyTime + fAddTime;
		
		// Modify View Weapon Alpha
		ViewWeapon_SetAlpha(other, VIEWWEAPON_INVISIBILITY_ALPHA);
		// Potentially Modify Self Alpha
		if( cvar(CVAR_ITEM_POWERUP_INVISIBILITY_USEALPHALEVEL) )
			SetNewEntityAlpha(other, cvar(CVAR_ITEM_POWERUP_INVISIBILITY_USEALPHALEVEL) );
		else
		{ // Use Invisibility Eyes
			other.bUseInvisibilityEyes = TRUE;
			// Check Player Model Update
			CheckPlayerModelUpdate(other);
		}
	}
	else
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.tCSQCStat_PowerupEndTime_QuadDamage - time);
			if(fAddTime < 1)
				fAddTime = 0;
		
		other.tCSQCStat_PowerupEndTime_QuadDamage = time + self.tPowerupApplyTime + fAddTime;
		// other.super_damage_finished = time + 30;
		
		// DRESK
		// Check Updated Flash Light on Other
		local entity enOldSelf;
			enOldSelf = self;
			self = other;
		CheckFlashLightSourceEntity();
			self = enOldSelf;
	}
	/*
	else
	if (self.classname == "item_artifact_wetsuit" )
	{
		other.wetsuit_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.wetsuit_finished - time);
			if(fAddTime < 1)
				fAddTime = 0;
		
		other.wetsuit_finished = time + self.tPowerupApplyTime + fAddTime;
		// other.wetsuit_finished = time + 30;
	}
	*/
	else
	if (self.classname == "item_artifact_empathy_shields" )
	{
		other.empathy_time = 1;
		
		// DRESK
		// Utilize Artifact Powerup Time
		if( cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
			// Support Additive Times
			fAddTime = rint(other.tCSQCStat_PowerupEndTime_EmpathyShields - time);
			if(fAddTime < 1)
				fAddTime = 0;
		
		other.tCSQCStat_PowerupEndTime_EmpathyShields = time + self.tPowerupApplyTime + fAddTime;
		// other.empathy_finished = time + 30;
	}
	
	// DRESK
	// Advanced Message
	local string strTime;
		// Support Additive Times
		if(fAddTime > 0 && cvar(CVAR_ITEM_POWERUP_TIMESADDED) )
		{ // Additive Time String
			strTime = ftos(fAddTime);
			strTime = strcat(strTime, " + ");
			strTime = strcat(strTime, ftos(self.tPowerupApplyTime) );
		}
		else
			strTime = ftos(self.tPowerupApplyTime);
			
	local string strMessage;
	strMessage = strcat("You get the ^2", self.netname, "^7 (^2", strTime, "^7 seconds)\n");
	// Support Disabled Item Pickup Messages
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Powerup) )
		sprint(other, strMessage);
	// Write PowerupDuration
	// te_PowerupDuration(other, self.nCSQCStat_Powerups, self.tPowerupApplyTime + fAddTime);
	
	// DRESK
	// Remove Dropped Item
	if(self.bIsDroppedItem)
		remove(self);
	else
	{
		activator = other;
		SUB_UseTargets();				// fire all targets / killtargets
	}
}
// Support Drop Powerups
void DropPowerups()
{ // Drop Powerups
	// NOTE: Assumed scope is entity to drop powerups.
	local entity enDropper;
	local entity enPowerup;
	
	// Backup Entity
	enDropper = self;
	self = enPowerup;
	
	// Check for Envirosuit Drop
	if(enDropper.tCSQCStat_PowerupEndTime_Biosuit)
	{ // Drop Powerup
		// Spawn New Item
		self = spawn();
		// Assign Dropped Item
		self.bIsDroppedItem = TRUE;
		
		item_artifact_envirosuit();
		self.classname = "item_artifact_envirosuit";
		self.tPowerupApplyTime = rint(enDropper.tCSQCStat_PowerupEndTime_Biosuit - time);
		TossItem(enDropper, self);
	}
	// Check for Invulnerability Drop
	if(enDropper.tCSQCStat_PowerupEndTime_Invulnerability)
	{ // Drop Powerup
		// Spawn New Item
		self = spawn();
		// Assign Dropped Item
		self.bIsDroppedItem = TRUE;
		
		item_artifact_invulnerability();
		self.classname = "item_artifact_invulnerability";
		self.tPowerupApplyTime = rint(enDropper.tCSQCStat_PowerupEndTime_Invulnerability - time);
		TossItem(enDropper, self);
	}
	// Check for Invisibility Drop
	if(enDropper.tCSQCStat_PowerupEndTime_Invisibility)
	{ // Drop Powerup
		// Spawn New Item
		self = spawn();
		// Assign Dropped Item
		self.bIsDroppedItem = TRUE;
		
		item_artifact_invisibility();
		self.classname = "item_artifact_invisibility";
		self.tPowerupApplyTime = rint(enDropper.tCSQCStat_PowerupEndTime_Invisibility - time);
		TossItem(enDropper, self);
	}
	// Check for Quad Damage Drop
	if(enDropper.tCSQCStat_PowerupEndTime_QuadDamage)
	{ // Drop Powerup
		// Spawn New Item
		self = spawn();
		// Assign Dropped Item
		self.bIsDroppedItem = TRUE;
		
		item_artifact_super_damage();
		self.classname = "item_artifact_super_damage";
		self.tPowerupApplyTime = rint(enDropper.tCSQCStat_PowerupEndTime_QuadDamage - time);
		TossItem(enDropper, self);
	}
	// HIPNOTIC SUPPORT
	// Check for Empathy Shields Drop
	if(enDropper.tCSQCStat_PowerupEndTime_EmpathyShields)
	{ // Drop Powerup
		// Spawn New Item
		self = spawn();
		// Assign Dropped Item
		self.bIsDroppedItem = TRUE;
		
		item_artifact_empathy_shields();
		self.classname = "item_artifact_empathy_shields";
		self.tPowerupApplyTime = rint(enDropper.tCSQCStat_PowerupEndTime_EmpathyShields - time);
		TossItem(enDropper, self);
	}
	
	// Restore Entity
	self = enDropper;
}
void DropNewPowerup(float nPowerupType, float tNewPowerupTime)
{ // Drop New Armor
	// NOTE: Assumed scope is entity to drop powerup.
	local entity enDropper;
	local entity enPowerup;
	
	// Backup Entity
	enDropper = self;
	self = enPowerup;
	
	// Spawn Powerup
	self = spawn();
	// Assign Dropped Item
	self.bIsDroppedItem = TRUE;
	
	// Invoke Spawn Class
	if(nPowerupType == POWERUPTYPE_ENVIROSUIT)
	{ // Envirosuit
		item_artifact_envirosuit();
		self.classname = "item_artifact_envirosuit";
	}
	else
	if(nPowerupType == POWERUPTYPE_INVULNERABILITY)
	{ // Invulnerability
		item_artifact_invulnerability();
		self.classname = "item_artifact_invulnerability";
	}
	else
	if(nPowerupType == POWERUPTYPE_INVISIBILITY)
	{ // Invisibility
		item_artifact_invisibility();
		self.classname = "item_artifact_invisibility";
	}
	else
	if(nPowerupType == POWERUPTYPE_QUADDAMAGE)
	{ // Quad Damage
		item_artifact_super_damage();
		self.classname = "item_artifact_super_damage";
	}
	// HIPNOTIC SUPPORT
	else
	if(nPowerupType == POWERUPTYPE_EMPATHYSHIELDS)
	{ // Empathy Shields
		item_artifact_empathy_shields();
		self.classname = "item_artifact_empathy_shields";
	}
	
	// Check Powerup Time
	if(tNewPowerupTime != 0)
		self.tPowerupApplyTime = tNewPowerupTime;
	
	// Toss Item
	TossItem(enDropper, self);
	
	// Apply Gyro Physics Properties
	if(g_bGyroPhysicsEnabled)
	{
		// Assign Movetype to Bounce
		self.movetype = MOVETYPE_BOUNCE;
		Gyro_ObjectMacro_Grenade(self, 800);
	}
	
	// Restore Entity
	self = enDropper;
}
/*QUAKED item_artifact_invulnerability (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invulnerable for 30 seconds
*/
void item_artifact_invulnerability()
{
	self.touch = powerup_touch;

	precache_model ("progs/invulner.mdl");
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel (self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.nCSQCStat_Powerups = POWERUP_INVULNERABILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Utilize Powerup Time
	self.tPowerupApplyTime = 30;
	// Assign Bleeding
	self.modelflags = MF_GIB | MF_ROTATE;
	
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
}

/*QUAKED item_artifact_envirosuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from water or slime for 30 seconds
*/
void item_artifact_envirosuit()
{
	self.touch = powerup_touch;

	precache_model ("progs/suit.mdl");
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel (self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.nCSQCStat_Powerups = POWERUP_BIOSUIT;
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Utilize Powerup Time
	// Provide Additional Time for Envirosuit
	self.tPowerupApplyTime = 90;
	
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
}


/*QUAKED item_artifact_invisibility (0 .5 .8) (-16 -16 -24) (16 16 32)
Player is invisible for 30 seconds
*/
void item_artifact_invisibility()
{
	self.touch = powerup_touch;

	precache_model ("progs/invisibl.mdl");
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel (self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.nCSQCStat_Powerups = POWERUP_INVISIBILITY;
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Utilize Powerup Time
	self.tPowerupApplyTime = 30;
	
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
}


/*QUAKED item_artifact_super_damage (0 .5 .8) (-16 -16 -24) (16 16 32)
The next attack from the player will do 4x damage
*/
void item_artifact_super_damage()
{
	self.touch = powerup_touch;

	precache_model ("progs/quaddama.mdl");
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel (self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.nCSQCStat_Powerups = POWERUP_QUADDAMAGE;
	setsize (self, '-16 -16 -24', '16 16 32');
	
	// DRESK
	// Utilize Powerup Time
	self.tPowerupApplyTime = 30;
	
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
}

/*QUAKED item_artifact_wetsuit (0 .5 .8) (-16 -16 -24) (16 16 32)
Player takes no damage from electrical attacks and swims faster for 30 seconds
*/
void item_artifact_wetsuit()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	// DRESK
	// Substitute Wetsuit
	self.classname = "item_artifact_envirosuit";
	item_artifact_envirosuit();
	/*
	
	self.touch = hip_powerup_touch;

	precache_model ("progs/wetsuit.mdl");
	precache_sound ("misc/wetsuit.wav");
	precache_sound ("misc/weton.wav");
	precache_sound ("items/suit2.wav");
	self.noise = "misc/weton.wav";
	setmodel (self, "progs/wetsuit.mdl");
	self.netname = "Wetsuit";
	self.items2 = HIP_IT_WETSUIT;
	setsize (self, '-16 -16 -24', '16 16 32');

	StartItem ();
	*/
}
/*QUAKED item_artifact_empathy_shields (0 .5 .8) (-16 -16 0) (16 16 32)
Empathy Shield.
*/
void item_artifact_empathy_shields()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	self.touch = powerup_touch;

	precache_model("progs/empathy.mdl");
	precache_sound("hipitems/empathy.wav");
	precache_sound("hipitems/empathy2.wav");
	precache_sound ("items/suit2.wav");
	setmodel(self, "progs/empathy.mdl");
	self.noise = "hipitems/empathy.wav";
	self.netname = "Empathy Shields";
	self.nCSQCStat_Powerups = POWERUP_EMPATHYSHIELDS;
	setsize (self, '-16 -16 0', '16 16 32');
	
	// DRESK
	// Utilize Powerup Time
	self.tPowerupApplyTime = 30;
	// Decrease Item Scale
	self.scale = 0.7;
	
	// Check for Dropped Item
	if(!self.bIsDroppedItem)
		StartItem ();
}
/*QUAKED item_hornofconjuring (0 .5 .8) (-16 -16 0) (16 16 32)
Horn of Conjuring.
You must make func_spawn entities connected to this entity
to spawn the charmed creature.
*/
void item_hornofconjuring()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	// DRESK
	// Substitute Horn of Conjuring (because it's a fucking weird item)
	self.classname = "item_armorInv";
	item_armorInv();
	/*

	self.touch = horn_touch;

	precache_model("progs/horn.mdl");
	precache_sound("hipitems/horn.wav");
	setmodel(self, "progs/horn.mdl");
	self.noise = "hipitems/horn.wav";
	setsize (self, '-16 -16 0', '16 16 32');
	StartItem ();
	*/
}
/*
================
CheckPowerups

Check for turning off powerups
================
*/
void CheckPowerups()
{
	local string strMessage;
	local float fEffect;
	// invisibility
	if (self.tCSQCStat_PowerupEndTime_Invisibility)
	{
		// sound and screen flash when items starts to run out
		if (self.invisible_sound < time)
		{
			sound (self, CHAN_AUTO, "items/inv3.wav", 0.5, ATTN_IDLE);
			self.invisible_sound = time + ((random() * 3) + 1);
		}


		if (self.tCSQCStat_PowerupEndTime_Invisibility < time + 3)
		{
			if (self.invisible_time == 1)
			{
				strMessage = "^2Ring of Shadows^7 magic is ^1fading^7...\n";
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
				
				sound (self, CHAN_AUTO, "items/inv2.wav", 1, ATTN_NORM);
				self.invisible_time = time + 1;
			}
			
			if (self.invisible_time < time)
			{
				self.invisible_time = time + 1;
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
			}
		}

		if (self.tCSQCStat_PowerupEndTime_Invisibility < time)
		{	// just stopped
			self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - POWERUP_INVISIBILITY;
			self.tCSQCStat_PowerupEndTime_Invisibility = 0;
			self.invisible_time = 0;
			// DRESK
			// Re-enable Modelflags on Self
			self.effects = self.effects - (self.effects & EF_NOMODELFLAGS);
			// Remove Weapon Alpha
			ViewWeapon_SetAlpha(self, 0);
			
			if(self.bUseInvisibilityEyes)
			{ // Restore Model
				// Enable Quake2 Weapon Entity Drawing
				Quake2WeaponEntity_SetIsDrawing(self, TRUE);
				// Check Player Model Update
				CheckPlayerModelUpdate(self);
				self.bUseInvisibilityEyes = FALSE;
			}
			else
			{ // Restore Alpha
				RestoreEntityAlpha(self);
			}
		}
		// DRESK
		// Disable Modelflags on Self
		self.effects = self.effects | EF_NOMODELFLAGS;
	}

	// invincibility
	if (self.tCSQCStat_PowerupEndTime_Invulnerability)
	{
		// sound and screen flash when items starts to run out
		if (self.tCSQCStat_PowerupEndTime_Invulnerability < time + 3)
		{
			if (self.invincible_time == 1)
			{
				strMessage = "^2Protection^7 is ^1almost burned out^7...\n";
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
				
				sound (self, CHAN_AUTO, "items/protect2.wav", 1, ATTN_NORM);
				self.invincible_time = time + 1;
			}
			
			if (self.tCSQCStat_PowerupEndTime_Invulnerability < time)
			{
				self.invincible_time = time + 1;
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
			}
		}
		
		// DRESK
		// Support Colored Powerups
		fEffect = EF_RED;
		
		if (self.tCSQCStat_PowerupEndTime_Invulnerability < time)
		{	// just stopped
			self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - POWERUP_INVULNERABILITY;
			self.invincible_time = 0;
			self.tCSQCStat_PowerupEndTime_Invulnerability = 0;
		}
		if (self.tCSQCStat_PowerupEndTime_Invulnerability > time)
			self.effects = self.effects | fEffect;
		else
			self.effects = self.effects - (self.effects & fEffect);
	}

// super damage
	if (self.tCSQCStat_PowerupEndTime_QuadDamage)
	{

// sound and screen flash when items starts to run out

		if (self.tCSQCStat_PowerupEndTime_QuadDamage < time + 3)
		{
			if (self.super_time == 1)
			{
				strMessage = "^2Quad Damage^7 is ^1wearing off^7...\n";
				stuffcmd (self, "bf\n");
				sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
				self.super_time = time + 1;
			}	  
			
			if (self.super_time < time)
			{
				self.super_time = time + 1;
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
			}
		}

		if (self.tCSQCStat_PowerupEndTime_QuadDamage < time)
		{	// just stopped
			self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - POWERUP_QUADDAMAGE;
			self.tCSQCStat_PowerupEndTime_QuadDamage = 0;
			self.super_time = 0;
			
			// DRESK
			// Check Updated Flash Light
			CheckFlashLightSourceEntity();
		}
		
		// DRESK
		// Support Colored Powerups
		fEffect = EF_BLUE;
			
		if (self.tCSQCStat_PowerupEndTime_QuadDamage > time)
		// DRESK
		// Utilize Blue Glow
			self.effects = self.effects | fEffect;
		else
			self.effects = self.effects - (self.effects & fEffect);
	}	

// suit	
	if (self.tCSQCStat_PowerupEndTime_Biosuit)
	{
		self.air_finished = time + 12;		// don't drown

// sound and screen flash when items starts to run out
		if (self.tCSQCStat_PowerupEndTime_Biosuit < time + 3)
		{
			if (self.rad_time == 1)
			{
				strMessage = "Air supply in ^2Biosuit^7 is ^1expiring^7...\n";
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
				
				sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
				self.rad_time = time + 1;
			}
			
			if (self.rad_time < time)
			{
				self.rad_time = time + 1;
				
				#ifndef SUPPRESSCLIENTBFCOMMANDS
				stuffcmd (self, "bf\n");
				#endif
			}
		}

		if (self.tCSQCStat_PowerupEndTime_Biosuit < time)
		{	// just stopped
			self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - POWERUP_BIOSUIT;
			self.rad_time = 0;
			self.tCSQCStat_PowerupEndTime_Biosuit = 0;
		}
	}
	
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{
		// Check Empathy Shields
		if (self.tCSQCStat_PowerupEndTime_EmpathyShields)
		{
			// sound and screen flash when items starts to run out
			if (self.tCSQCStat_PowerupEndTime_EmpathyShields < time + 3)
			{
				if (self.empathy_time == 1)
				{
					strMessage = "^2Empathy Shields^7 are ^1running out^7...\n";
					
					#ifndef SUPPRESSCLIENTBFCOMMANDS
					stuffcmd (self, "bf\n");
					#endif
					
					sound (self, CHAN_AUTO, "items/suit2.wav", 1, ATTN_NORM);
					self.empathy_time = time + 1;
				}

				if (self.empathy_time < time)
				{
					self.empathy_time = time + 1;
					
					#ifndef SUPPRESSCLIENTBFCOMMANDS
					stuffcmd (self, "bf\n");
					#endif
				}
			}

			if (self.tCSQCStat_PowerupEndTime_EmpathyShields < time)
			{	// just stopped
				self.nCSQCStat_Powerups = self.nCSQCStat_Powerups - POWERUP_EMPATHYSHIELDS;
				self.empathy_time = 0;
				self.tCSQCStat_PowerupEndTime_EmpathyShields = 0;
			}
			
			// DRESK
			// Remove Empathy Shield Effect
			/*
			if (self.empathy_finished > time)
				self.effects = self.effects | EF_DIMLIGHT;
			else
				self.effects = self.effects - (self.effects & EF_DIMLIGHT);
			*/
		}
	}
	
	if(!SG_AUTOCVAR(kleshik_server_item_DisablePickupMessage_Powerup) && strMessage != "")
		sprint(self, strMessage);
}
