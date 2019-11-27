// DRESK
// Weapon Functions

// Definitions
// Muzzleflash (readability purposes)
#define WEAPON_MUZZLEFLASH_TRUE										TRUE
#define WEAPON_MUZZLEFLASH_FALSE									FALSE

// Initial Firing
#define WEAPON_BEGININITIALFIREEVENTS								if(!self.bWeaponInitiallyFired){self.bWeaponInitiallyFired = TRUE;
#define WEAPON_ENDINITIALFIREEVENTS									}

// States
#define WEAPONSTATE_ANIMATIONEND									0
#define WEAPONSTATE_STOPPEDFIRING									1

// View Weapon
#define WEAPONANIMSPEED_SLOW										0.2
#define WEAPONANIMSPEED_STANDARD									0.1
#define WEAPONANIMSPEED_NAILGUNS									0.06
#define WEAPONANIMSPEED_CHAINGUN									0.05
#define WEAPONANIMSPEED_AXE											0.06

#define VIEWWEAPON_INVISIBILITY_ALPHA								0.25

// Owner Touchable Projectile
#define WEAPON_OWNERTOUCHABLEPROJECTILE_SETTHINKTIME				0.2

// Prototypes

// Fields
float	g_bProximityGunAllowAltFireDetonation;

.float	nPreviousWeaponFired;

.float	bWeaponInitiallyFired;

.float	tDryFireSoundTime;

.float	bIsProximityBombInLinkedList;

// Firing Data
vector	vCurrentShotOrigin;

// Support Owner Touchable Projectiles
.float	bOwnerTouchableProjectile;
.entity	enTouchableProjectileOwner;
.void()	fpOwnerTouchableThinkFunction;
.float	tOwnerTouchableThinkTime;

// Weapon Animation Controller Entity
.void(float nState)	fpWeaponAnimationController_StateFunction;

.float	tAnimationController_AnimSpeed;
.float	nAnimationController_AnimBeginFrame;
.float	nAnimationController_AnimEndFrame;
.float	nAnimationController_FramesProcessed;
.float	nAnimationController_MaxFrames;

.float	nWeaponAnimationController_CurrentWeapon;

// View Weapon Entity
.entity	enViewWeapon;

// Delayed Weapon Attack Controller Entity
.entity	enDelayedWeaponAttackController;
.void()	fpDelayedWeaponAttackController_AttackFunction;

// Proximity Bomb Linked List
.entity	enPrevProximityBomb;
.entity	enNextProximityBomb;
.entity enLastProximityBomb;

// Data
.float	fWeaponData_NailgunOffset;
.float	fWeaponData_LaserGunStat;

// Functions
entity GenericWeaponControllerSpawn(entity enOwner, string strClassname)
{ // Generic Weapon Controller Spawn
	local entity enController;
	
	enController = spawn();
	enController.effects = EF_NODRAW;
	enController.owner = self;
	enController.classname = strClassname;
	
	return enController;
}
void WeaponEvents_WeaponAnim(float nBeginAnim, float nEndAnim, float tAnimSpeed, void(float nState) fpStateFunction)
{ // Weapon Events
	// Assign Current Weapon
	self.enViewWeapon.nWeaponAnimationController_CurrentWeapon = self.weapon;
	
	// Assign State Function
	self.enViewWeapon.fpWeaponAnimationController_StateFunction = fpStateFunction;
	// Start Weapon Frame
	self.enViewWeapon.frame = nBeginAnim;
	// Assign Anim Begin Frame
	self.enViewWeapon.nAnimationController_AnimBeginFrame = nBeginAnim;
	// Assign Anim End Frame
	self.enViewWeapon.nAnimationController_AnimEndFrame = nEndAnim;
	// Assign Anim Speed
	self.enViewWeapon.tAnimationController_AnimSpeed = tAnimSpeed;
	// Assign Update Time
	self.enViewWeapon.nextthink = time + tAnimSpeed;
	// Assign Think Function
	self.enViewWeapon.think = ViewWeapon_Think;
}
void PlayerAnimationController_Think()
{ // Player Animation Controller - Think
	if(self.owner.frame == self.nAnimationController_AnimEndFrame
		|| self.nAnimationController_FramesProcessed == self.nAnimationController_MaxFrames)
	{ // Animation Ended
		// Purge Controller Properties
		self.think = __NULL__;
		// Restore Player Next Think
		self.owner.nextthink = time;
	}
	else
	{ // Continue Animation
		// Next Frame
		self.owner.frame = self.owner.frame + 1;
		// Increment Frames Processed
		self.nAnimationController_FramesProcessed = self.nAnimationController_FramesProcessed + 1;
		
		// bprint( strcat("Continuing from frame ", ftos(self.owner.frame - 1), " to frame ", ftos(self.owner.frame), "\n") );
		// Assign Next Think
		self.nextthink = time + self.tAnimationController_AnimSpeed;
	}
}
void WeaponEvents_Main(float nFiringMode, float bMuzzleFlash)
{ // Weapon Events
	// Acquire Weapon Entity
	local entity enWeapon;
		enWeapon = self.enCurrentWeaponEntity;
	// Acquire Weapon Ammo Type
	local float nAmmoType;
		nAmmoType = enWeapon.nWeaponEntity_AmmoTypeUsed;
	local float fAmmoMod;
	local float tAttackTime;
	local float fPunchAngle;
	if(nFiringMode == WEAPON_FIRINGMODE_PRIMARY)
	{
		fAmmoMod = enWeapon.nWeaponEntity_PrimaryAmmoUsed;
		tAttackTime = SG_GetWeaponRefireTime(enWeapon, WEAPON_FIRINGMODE_PRIMARY);
		fPunchAngle = enWeapon.fWeaponEntity_PrimaryRecoil;
	}
	else
	{
		fAmmoMod = enWeapon.nWeaponEntity_SecondaryAmmoUsed;
		tAttackTime = SG_GetWeaponRefireTime(enWeapon, WEAPON_FIRINGMODE_SECONDARY);
		fPunchAngle = enWeapon.fWeaponEntity_SecondaryRecoil;
	}
	// Support Infinite Ammo
	if(!SG_AUTOCVAR(kleshik_server_ammo_infinite) && nAmmoType != AMMOTYPE_NONE)
	{ // Infinite Ammo Disabled
		// Support Cooperative Shared Ammo Pool
		#ifdef WEAPON_UPDATECURRENTAMMO
		#define AMMOPREFIX self.currentammo =
		#else
		#define AMMOPREFIX
		#endif
		if(g_bCoopSharedAmmo)
			AMMOPREFIX UpdateSharedAmmo(nAmmoType, (fAmmoMod * -1) );
		else
		{ // Standard Ammo
			if(nAmmoType == AMMOTYPE_SHELLS)
				AMMOPREFIX self.ammo_shells = self.ammo_shells - fAmmoMod;
			else
			if(nAmmoType == AMMOTYPE_NAILS)
				AMMOPREFIX self.ammo_nails = self.ammo_nails - fAmmoMod;
			else
			if(nAmmoType == AMMOTYPE_ROCKETS)
				AMMOPREFIX self.ammo_rockets = self.ammo_rockets - fAmmoMod;
			else
			if(nAmmoType == AMMOTYPE_CELLS)
				AMMOPREFIX self.ammo_cells = self.ammo_cells - fAmmoMod;
		}
			
		// DRESK
		// Increment Ammo Used
		UpdateClientStatsScore(self, CLIENTSCORE_NUMAMMOUSED, fAmmoMod);
	}
	
	// Modify Attack Finished Time
	if(tAttackTime != -1)
	{
		// Reduce Attack Finished if Crouching
		if(self.bIsCrouching && g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY)
		{
			local float tAttackReduceTime;
			tAttackReduceTime = (100 - SG_AUTOCVAR(kleshik_server_PlayerModel_Crouch_AttackRefireMod) ) / 100;
			if(tAttackReduceTime < 1)
				tAttackTime = tAttackTime * tAttackReduceTime;
		}
		// Check for Minimum Attack Refire Time
		if(tAttackTime < 0.03)
			tAttackTime = 0.03;
		self.attack_finished = self.attack_finished + tAttackTime;
	}
		
	// Show Muzzleflash
	if(bMuzzleFlash)
		self.effects = self.effects | EF_MUZZLEFLASH;

	// Modified Punchangle to be additive
	if( !(self.bIsCrouching && g_nCrouch_InteractivityLevel == PLAYERMODEL_CROUCH_INTERACTIVITYLEVEL_GAMEPLAY) )
		self.punchangle_x = self.punchangle_x - fPunchAngle;
	/*
	// Additional Punchangle from Flashlight
	if(self.bFlashLightActive)
	{ // Additional FlashLight Punchangle
		self.punchangle_y = self.punchangle_x;
		if( random() > 0.50)
			self.punchangle_y = self.punchangle_y * -1;
	}
	*/
	
	if(self.nPreviousWeaponFired != self.weapon)
		// Remove Initially Fired
		self.bWeaponInitiallyFired = FALSE;
	
	// Assign New Previous Weapon Fired
	self.nPreviousWeaponFired = self.weapon;
}
void WeaponEvents_DryFireSound(string strSound)
{ // Weapon Events
	if(time > self.tDryFireSoundTime)
	{ // Sound Allowed
		sound (self, CHAN_AUTO, strSound, 1, ATTN_NORM);
		// Update Dry Fire Time
		self.tDryFireSoundTime = time + 0.5;
	}
}
void WeaponEvents_InitialFire(string strSound)
{ // Weapon Events
	if(!self.bWeaponInitiallyFired)
	{ // Initial Fire Events
		// Play Sound
		if(strSound != "")
			sound (self, CHAN_AUTO, strSound, 1, ATTN_NORM);
			
		// Assign Initially Fired
		self.bWeaponInitiallyFired = TRUE;
	}
}
void WeaponEvents_SetupOriginAndDirection(vector vOffset)
{ // Weapon Events
	// Setup Shot Origin
	// NOTE : Always subtract 8 from the view offsets
	vCurrentShotOrigin = self.origin + self.view_ofs + '0 0 -8' + (v_forward * vOffset_x) + (v_right * vOffset_y) + (v_up * vOffset_z);
}
void DelayedAttackController_Think()
{ // Delayed Attack Controller - Think
	// Backup Self
	local entity enOldSelf;
		enOldSelf = self;
	// Acquire Owner as Self
	self = enOldSelf.owner;
	if(!self.deadflag)
	{ // Owner not Dead; Invoke
		// Assign Attack Function to Owner
		self.fpDelayedWeaponAttackController_AttackFunction = enOldSelf.fpDelayedWeaponAttackController_AttackFunction;
		// Create Vectors for Attack Function
		makevectors(self.v_angle);
		// Invoke Owner Attack Function
		self.fpDelayedWeaponAttackController_AttackFunction();
	}
	// Purge Attack Function
	self.fpDelayedWeaponAttackController_AttackFunction = __NULL__;
	// Restore Old Self
	self = enOldSelf;
	// Purge Think
	self.think = __NULL__;
}
void WeaponEvents_DelayedAttackFunction(void() fpAttackFunction, float tDelay)
{ // Weapon Events
	// Check for Entity
	if(!self.enDelayedWeaponAttackController)
	{ // Spawn
		self.enDelayedWeaponAttackController = GenericWeaponControllerSpawn(self, "Delayed Weapon Attack Controller");
	}
	
	// Assign Attack Function
	self.enDelayedWeaponAttackController.fpDelayedWeaponAttackController_AttackFunction = fpAttackFunction;
	// Assign Nextthink
	self.enDelayedWeaponAttackController.nextthink = time + tDelay;
	// Assign Think
	self.enDelayedWeaponAttackController.think = DelayedAttackController_Think;
}
void AppendProximityBombToEntityLinkedList(entity enEntity, entity enBomb)
{ // Append Proximity Bomb to Entity Linked List
	local entity enOwner;
	
	// Setup Initial List
	enOwner = enEntity;
	
	// Assign Is Proximity Bomb (used for entity remove)
	enBomb.bIsProximityBombInLinkedList = TRUE;
	
	if(enOwner.enLastProximityBomb)
	{ // Append to End
		// New Bomb
		enOwner.enLastProximityBomb.enNextProximityBomb = enBomb;
		enOwner.enLastProximityBomb.enNextProximityBomb.enPrevProximityBomb = enOwner.enLastProximityBomb;
		
		// Assign New Last Bomb
		enOwner.enLastProximityBomb = enBomb;
	}
	else
	{ // New List
		enOwner.enNextProximityBomb = enBomb;
		enOwner.enLastProximityBomb = enBomb;
		enOwner.enPrevProximityBomb = world;
	}
}
void RemoveProximityBombFromEntityLinkedList(entity enEntity, entity enBomb)
{ // Remove Proximity Bomb from Entity Linked List
	if(enBomb.bIsProximityBombInLinkedList)
	{ // Linked List Bomb
		if(enEntity.enLastProximityBomb == enBomb)
		{ // Last Bomb
			if(enBomb.enPrevProximityBomb && enBomb.enPrevProximityBomb != enEntity)
			{ // Previous Bomb Valid
				// Assign New Last Bomb
				enEntity.enLastProximityBomb = enBomb.enPrevProximityBomb;
				// Remove Last Bomb Next
				enEntity.enLastProximityBomb.enNextProximityBomb = world;
			}
			else
			{ // Last Bomb and ONLY Bomb
				enEntity.enNextProximityBomb = world;
				enEntity.enLastProximityBomb = world;
			}
		}
		else
		if(enEntity.enNextProximityBomb == enBomb)
		{ // First Bomb and NOT Only Bomb
			// Assign New First Bomb
			enEntity.enNextProximityBomb = enBomb.enNextProximityBomb;
			// Remove New First Bomb Previous
			enEntity.enNextProximityBomb.enPrevProximityBomb = world;
		}
		else
		{ // Bomb NOT First or Last
			// Assign Previous Bomb - Next
			enBomb.enPrevProximityBomb.enNextProximityBomb = enBomb.enNextProximityBomb;
			// Assign Next Bomb - Previous
			enBomb.enNextProximityBomb.enPrevProximityBomb = enBomb.enPrevProximityBomb;
		}
		
		// Remove IsProximity Bomb Status
		enBomb.bIsProximityBombInLinkedList = FALSE;
	}
}
void W_DetonateProximityBombs()
{ // Detonate Proximity Bombs
	local entity enOldSelf;
	local entity enBomb;
	
	// Backup Self
	enOldSelf = self;
	
	// Always Play Dry Fire Sound
	WeaponEvents_DryFireSound("buttons/switch04.wav");
	
	// Acquire Initial Bomb
	enBomb = self.enNextProximityBomb;
	
	if(enBomb)
	{ // Bombs Exist
		while(enBomb)
		{ // Valid Proximity Bomb
			// Assign Current Bomb to Blow
			self = enBomb;
			
			// Acquire Next Bomb
			if(self.enNextProximityBomb)
				enBomb = self.enNextProximityBomb;
			else
				enBomb = world;
			
			// Blow Bomb
			if(self.think != ProximityExplode)
			{ // Bomb is Not Exploding
				sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
				ProximityGrenadeExplode(DAMAGETYPE_OTHER);
				self.nextthink = time + 0.5;
			}
		}
		
		// Restore Self
		self = enOldSelf;
	}
}
float CheckNailGunOffset(entity enPlayer)
{ // Check Nailgun Offset
	// Acquire Ox
	if(enPlayer.fWeaponData_NailgunOffset == 0)
		// Assign Initial Ox
		enPlayer.fWeaponData_NailgunOffset = 3;
	else
	if(enPlayer.fWeaponData_NailgunOffset == 3)
		enPlayer.fWeaponData_NailgunOffset = -3;
	else
		enPlayer.fWeaponData_NailgunOffset = 3;
		
	return enPlayer.fWeaponData_NailgunOffset;
}
float CheckLaserGunStat(entity enPlayer)
{ // Check Laser Gun Stat
	if(enPlayer.fWeaponData_LaserGunStat == 0)
		enPlayer.fWeaponData_LaserGunStat = 1;
	else
		enPlayer.fWeaponData_LaserGunStat = 0;
		
	return enPlayer.fWeaponData_LaserGunStat;
}
void PurgeWeaponEntities(entity enClient)
{ // Purge Weapon Entities
	CheckAndRemoveEntity(enClient, enViewWeapon);
	CheckAndRemoveEntity(enClient, enDelayedWeaponAttackController);
}
void WeaponStateFunction_RepeatAnimation(float nState)
{ // Weapon State Function
	if(nState == WEAPONSTATE_ANIMATIONEND)
	{ // Ended Animation
		if(self.owner.weapon == self.nWeaponAnimationController_CurrentWeapon)
		{ // Valid Repeat
			// Start Weapon Frame
			self.frame = self.nAnimationController_AnimBeginFrame;
			// Assign Update Time
			self.nextthink = time + self.tAnimationController_AnimSpeed;
		}
		else
			ViewWeapon_PurgeThink();
	}
	else
	if(nState == WEAPONSTATE_STOPPEDFIRING)
	{ // Stopped Firing
		ViewWeapon_PurgeThink();
	}
}

// ***********************************
// View Weapon Functions
void ViewWeapon_PurgeThink()
{ // View Weapon - Purge Think
	// Remove Active Weapon Frame
	self.frame = 0;
	// Remove Think Function
	self.think = __NULL__;
	self.nextthink = 0;
	// Purge State Function
	self.fpWeaponAnimationController_StateFunction = __NULL__;
}
void ViewWeapon_Think()
{ // View Weapon - Think
	local float bContinueAnimation;
		bContinueAnimation = TRUE;
		
	
	// Check for Base End of Weapon Frames
	if( (self.owner.deadflag) // Owner is Dead
		|| (self.nWeaponAnimationController_CurrentWeapon != self.owner.weapon) // Owner Weapon Changed
		|| (self.frame == 0) ) // Weapon Frame is 0
	{ // End of Animation
		bContinueAnimation = FALSE;
	}
	else
	// Check for End of Frames
	if(self.frame == self.nAnimationController_AnimEndFrame)
	{ // Weapon Frame Play Completed
		bContinueAnimation = FALSE;
	}
	
	if(bContinueAnimation)
	{ // Continue Animation
		// Increment Weapon Frame
		self.frame = self.frame + 1;
		// Provide Nextthink
		self.nextthink = time + self.tAnimationController_AnimSpeed;
	}
	else
	{ // End Animation
		if(self.fpWeaponAnimationController_StateFunction)
			// State Function Available; Execute
			self.fpWeaponAnimationController_StateFunction(WEAPONSTATE_ANIMATIONEND);
		else
			ViewWeapon_PurgeThink();
	}
}
void ViewWeapon_CheckAndSpawn(entity enClient)
{ // Check and Spawn View Weapon
	if(!enClient.enViewWeapon)
	{ // Spawn View Weapon
		enClient.enViewWeapon = spawn();
		enClient.enViewWeapon.classname = "View Weapon";
		enClient.enViewWeapon.viewmodelforclient = enClient;
		enClient.enViewWeapon.owner = enClient;
	}
}
void ViewWeapon_UpdateOriginOffset(entity enClient)
{ // Update Origin Offset
	vector vNewOrigin;
	
	vNewOrigin = self.enCurrentWeaponEntity.vWeaponEntity_ViewWeaponOriginOffset;
	if(enClient.bIsCrouching)
	{ // Client Crouching; Shift Origin a Tad
		vNewOrigin += '-4 0 3';
	}
	// Update Origin
	setorigin(enClient.enViewWeapon, vNewOrigin);
}
void ViewWeapon_SetAlpha(entity enClient, float fAlpha)
{ // Set View Weapon Alpha
	if(enClient.enViewWeapon)
	{ // Valid View Weapon
		enClient.enViewWeapon.alpha = fAlpha;
	}
}
void ViewWeapon_ToggleDraw(entity enClient, float bDraw)
{ // Toggle View Weapon Drawing
	if(enClient.enViewWeapon)
	{ // Valid View Weapon
		if(bDraw)
			enClient.enViewWeapon.effects = enClient.enViewWeapon.effects - (enClient.enViewWeapon.effects & EF_NODRAW);
		else
			enClient.enViewWeapon.effects = enClient.enViewWeapon.effects | EF_NODRAW;
	}
}
void ViewWeapon_ToggleDrawOnAllClients(float bDraw)
{ // Toggle View Drawing on All Clients
	local entity enClient;
	
	// Find Initial Client
	enClient = find(world, classname, "player");
	
	while(enClient)
	{ // Valid Client
		ViewWeapon_ToggleDraw(enClient, bDraw);
		// Acquire Next Client
		enClient = find(enClient, classname, "player");
	}
}
// ***************************
// Owner Touchable Projectile Functions
void OwnerTouchableProjectileThink()
{ // Owner Touchable Projectile Think
	if(self.bOwnerTouchableProjectile)
	{ // Valid Owner Touchable Projectile
		// Assign Owner as Self
		self.owner = self;
		
		// Assign Natural Think Function
		self.think = self.fpOwnerTouchableThinkFunction;
		self.nextthink = time + (self.tOwnerTouchableThinkTime - WEAPON_OWNERTOUCHABLEPROJECTILE_SETTHINKTIME);
	}
}
float GetIsEntityOwnerTouchableProjectileOwner(entity enProjectile, entity enToucher)
{ // Return if Entity is Owner Touchable Projectile Owner
	if(enToucher == enProjectile.enTouchableProjectileOwner)
		return TRUE;
	else
		return FALSE;
}
entity GetOwnerTouchableProjectileOwner(entity enProjectile)
{ // Return Owner Touchable Projectile Owner
	if(enProjectile.enTouchableProjectileOwner)
		return(enProjectile.enTouchableProjectileOwner);
	else
		return(enProjectile.owner);
}
void RestoreOwnerTouchableProjectileOwner(entity enProjectile)
{ // Restore Owner Touchable Projectile Owner
	if(enProjectile.bOwnerTouchableProjectile)
	{
		enProjectile.owner = enProjectile.enTouchableProjectileOwner;
		enProjectile.enTouchableProjectileOwner = world;
		enProjectile.bOwnerTouchableProjectile = FALSE;
	}
}
void PrepareOwnerTouchableProjectile(entity enProjectile, void() fpRealThink, float tRealThinkTime)
{ // Prepare Owner Touchable Projectile
	if(!enProjectile.bOwnerTouchableProjectile)
	{ // Not Owner Touchable Projectile
		enProjectile.bOwnerTouchableProjectile = TRUE;
		// Assign Current Owner to Backup
		enProjectile.enTouchableProjectileOwner = enProjectile.owner;
		
		// Assign Think Function and Time
		if(fpRealThink)
		{ // Valid Think Function
			enProjectile.fpOwnerTouchableThinkFunction = fpRealThink;
			enProjectile.tOwnerTouchableThinkTime = tRealThinkTime;
		}
		
		// Enable Think Operation
		enProjectile.nextthink = time + WEAPON_OWNERTOUCHABLEPROJECTILE_SETTHINKTIME;
		enProjectile.think = OwnerTouchableProjectileThink;
	}
}