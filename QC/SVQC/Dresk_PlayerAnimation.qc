// DRESK
// Player Animation

// Definitions
#define PLAYERANIM_ANIMSPEED_STANDARD						0.1
#define PLAYERANIM_ANIMSPEED_SLOW							0.5
#define PLAYERANIM_ANIMSPEED_NAILGUN						0.08
#define PLAYERANIM_ANIMSPEED_AXE							0.06
#define PLAYERANIM_ANIMSPEED_PAIN							0.08

// Quake2 Animation Definitions
#define PLAYERANIM_QUAKE2_STAND_BEGIN						0
#define PLAYERANIM_QUAKE2_STAND_END							39

#define PLAYERANIM_QUAKE2_RUN_BEGIN							40
#define PLAYERANIM_QUAKE2_RUN_END							45

#define PLAYERANIM_QUAKE2_ATTACK_BEGIN						46
#define PLAYERANIM_QUAKE2_ATTACK_END						53

#define PLAYERANIM_QUAKE2_PAIN1_BEGIN						54
#define PLAYERANIM_QUAKE2_PAIN1_END							57
#define PLAYERANIM_QUAKE2_PAIN2_BEGIN						58
#define PLAYERANIM_QUAKE2_PAIN2_END							61
#define PLAYERANIM_QUAKE2_PAIN3_BEGIN						62
#define PLAYERANIM_QUAKE2_PAIN3_END							65

#define PLAYERANIM_QUAKE2_JUMP_BEGIN						66
#define PLAYERANIM_QUAKE2_JUMP_END							67

#define PLAYERANIM_QUAKE2_LAND_BEGIN						68
#define PLAYERANIM_QUAKE2_LAND_END							71

#define PLAYERANIM_QUAKE2_TAUNT_FLIP_BEGIN					72
#define PLAYERANIM_QUAKE2_TAUNT_FLIP_END					83
#define PLAYERANIM_QUAKE2_TAUNT_SALUTE_BEGIN				84
#define PLAYERANIM_QUAKE2_TAUNT_SALUTE_END					94
#define PLAYERANIM_QUAKE2_TAUNT_TAUNT_BEGIN					95
#define PLAYERANIM_QUAKE2_TAUNT_TAUNT_END					111
#define PLAYERANIM_QUAKE2_TAUNT_WAVE_BEGIN					112
#define PLAYERANIM_QUAKE2_TAUNT_WAVE_END					122
#define PLAYERANIM_QUAKE2_TAUNT_POINT_BEGIN					123
#define PLAYERANIM_QUAKE2_TAUNT_POINT_END					134

#define PLAYERANIM_QUAKE2_CROUCHSTAND_BEGIN					135
#define PLAYERANIM_QUAKE2_CROUCHSTAND_END					153
#define PLAYERANIM_QUAKE2_CROUCHWALK_BEGIN					154
#define PLAYERANIM_QUAKE2_CROUCHWALK_END					159
#define PLAYERANIM_QUAKE2_CROUCHATTACK_BEGIN				160
#define PLAYERANIM_QUAKE2_CROUCHATTACK_END					168
#define PLAYERANIM_QUAKE2_CROUCHPAIN_BEGIN					169
#define PLAYERANIM_QUAKE2_CROUCHPAIN_END					172

#define PLAYERANIM_QUAKE2_CROUCHDEATH_BEGIN					173
#define PLAYERANIM_QUAKE2_CROUCHDEATH_END					177

#define PLAYERANIM_QUAKE2_DEATH1_BEGIN						178
#define PLAYERANIM_QUAKE2_DEATH1_END						183
#define PLAYERANIM_QUAKE2_DEATH2_BEGIN						184
#define PLAYERANIM_QUAKE2_DEATH2_END						189
#define PLAYERANIM_QUAKE2_DEATH3_BEGIN						190
#define PLAYERANIM_QUAKE2_DEATH3_END						197

#define PLAYERANIM_QUAKE2_VERTICALVELOCITYFORJUMPANIM		135

#define PLAYERANIM_QUAKE2_TAUNT_FLIP						0
#define PLAYERANIM_QUAKE2_TAUNT_SALUTE						1
#define PLAYERANIM_QUAKE2_TAUNT_TAUNT						2
#define PLAYERANIM_QUAKE2_TAUNT_WAVE						3
#define PLAYERANIM_QUAKE2_TAUNT_POINT						4

#define PLAYERANIM_GETISRUNNING								(self.velocity_x || self.velocity_y)
#define PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME				if(self.enQuake2PlayerModel_WeaponEntity){self.enQuake2PlayerModel_WeaponEntity.frame = self.frame;self.enQuake2PlayerModel_WeaponEntity.alpha = self.alpha;}

// Fields
.float	nPlayerAnim_WalkRunFrame;
.float	tPlayerFrameMacroSpeed;
.float	nPlayerContigAnim_Begin;
.float	nPlayerContigAnim_End;
.float	bPlayerContigAnim_FreezeAtEnd;
.float	bPlayerContigAnim_Repeat;
.float	bPlayerContigAnim_RunOverrides;
.void()	fpPlayerContigAnim_EndFunction;

/*
==============================================================================

PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base		
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

$frame rockrun1 rockrun2 rockrun3 rockrun4 rockrun5 rockrun6

//
// standing
//
$frame stand1 stand2 stand3 stand4 stand5

$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12


//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

$frame pain1 pain2 pain3 pain4 pain5 pain6


//
// death
//

$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 deatha11

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 deathc13 deathc14 deathc15

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7
$frame deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7
$frame deathe8 deathe9

//
// attacks
//
$frame nailatt1 nailatt2

$frame light1 light2

$frame rockatt1 rockatt2 rockatt3 rockatt4 rockatt5 rockatt6

$frame shotatt1 shotatt2 shotatt3 shotatt4 shotatt5 shotatt6

$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6


/*
==============================================================================
PLAYER
==============================================================================
*/

// ======================================================================
// Standing Animation
void PlayerAnim_Stand() [$axstnd1, PlayerAnim_Stand]
{
	// Check for Running
	if (self.velocity_x || self.velocity_y)
	{
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Run();
		return;
	}
	
	// Check for Jumping Animation
	if(self.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2 && (self.waterlevel == 3 || ( fabs(self.velocity_z) > PLAYERANIM_QUAKE2_VERTICALVELOCITYFORJUMPANIM && !(self.flags & FL_ONGROUND) ) ) )
	{
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Quake2_Jump();
		return;
	}
	
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			if (self.weapon == WEAPON_AXE)
			{
				if (self.nPlayerAnim_WalkRunFrame >= 12)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = $axstnd1 + self.nPlayerAnim_WalkRunFrame;
			}
			else if (self.weapon == WEAPON_MJOLNIR)
			{
				if (self.nPlayerAnim_WalkRunFrame >= 12)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = 6 + self.nPlayerAnim_WalkRunFrame;
			}
			else
			{
				if (self.nPlayerAnim_WalkRunFrame >= 5)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = $stand1 + self.nPlayerAnim_WalkRunFrame;
			}
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			if(self.bIsCrouching)
			{
				self.frame = PLAYERANIM_QUAKE2_CROUCHSTAND_BEGIN + self.nPlayerAnim_WalkRunFrame;
				if(self.frame >= PLAYERANIM_QUAKE2_CROUCHSTAND_END)
					self.nPlayerAnim_WalkRunFrame = -1;
			}
			else
			{
				self.frame = PLAYERANIM_QUAKE2_STAND_BEGIN + self.nPlayerAnim_WalkRunFrame;
				if(self.frame >= PLAYERANIM_QUAKE2_STAND_END)
					self.nPlayerAnim_WalkRunFrame = -1;
			}
			PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
		break;
	}
	
	self.nPlayerAnim_WalkRunFrame = self.nPlayerAnim_WalkRunFrame + 1;
}
// Running Animation
void PlayerAnim_Run() [$rockrun1, PlayerAnim_Run]
{	
	// Check for Return to Standing
	if (!self.velocity_x && !self.velocity_y)
	{
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Stand();
		return;
	}
	// Check for Jumping Animation
	if(self.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2 && (self.waterlevel == 3 || ( fabs(self.velocity_z) > PLAYERANIM_QUAKE2_VERTICALVELOCITYFORJUMPANIM && !(self.flags & FL_ONGROUND) ) ) )
	{
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Quake2_Jump();
		return;
	}
	
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			if (self.weapon == WEAPON_AXE)
			{
				if (self.nPlayerAnim_WalkRunFrame >= 6)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = $axrun1 + self.nPlayerAnim_WalkRunFrame;
			}
			// DRESK - HIPNOTIC SUPPORT
			else if (self.weapon == WEAPON_MJOLNIR)
			{
				if (self.nPlayerAnim_WalkRunFrame >= 6)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = self.nPlayerAnim_WalkRunFrame;
			}
			else
			{
				if (self.nPlayerAnim_WalkRunFrame >= 6)
					self.nPlayerAnim_WalkRunFrame = 0;
				self.frame = self.frame + self.nPlayerAnim_WalkRunFrame;
			}
		break;
				
		case PLAYERMODEL_MODELTYPE_MD2:
			if(self.bIsCrouching)
			{
				self.frame = PLAYERANIM_QUAKE2_CROUCHWALK_BEGIN + self.nPlayerAnim_WalkRunFrame;
				if(self.frame >= PLAYERANIM_QUAKE2_CROUCHWALK_END)
					self.nPlayerAnim_WalkRunFrame = -1;
			}
			else
			{
				self.frame = PLAYERANIM_QUAKE2_RUN_BEGIN + self.nPlayerAnim_WalkRunFrame;
				if(self.frame >= PLAYERANIM_QUAKE2_RUN_END)
					self.nPlayerAnim_WalkRunFrame = -1;
			}
			PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
		break;
	}
	
	self.nPlayerAnim_WalkRunFrame = self.nPlayerAnim_WalkRunFrame + 1;
}
// Jumping Animations
void PlayerAnim_Quake2_Land() [PLAYERANIM_QUAKE2_LAND_BEGIN, PlayerAnim_Quake2_Land]
{ // Quake2 Land
	self.frame = PLAYERANIM_QUAKE2_LAND_BEGIN + self.nPlayerAnim_WalkRunFrame;
	PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
	
	// Check for Reset
	if(!(self.flags & FL_ONGROUND) )
	{ // No Longer on Ground
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Stand();
	}
	else
	if(self.frame < PLAYERANIM_QUAKE2_LAND_END)
		// Continue to process frames until end
		self.nPlayerAnim_WalkRunFrame = self.nPlayerAnim_WalkRunFrame + 1;
	else
	{ // Return to Standing
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Stand();
	}
}
void PlayerAnim_Quake2_Jump() [PLAYERANIM_QUAKE2_JUMP_BEGIN, PlayerAnim_Quake2_Jump]
{ // Quake2 Jump
	// Check for Reset
	if(self.waterlevel != 3 && (!self.velocity_z || self.flags & FL_ONGROUND ) )
	{
		self.nPlayerAnim_WalkRunFrame = 0;
		PlayerAnim_Quake2_Land();
		return;
	}
	self.frame = PLAYERANIM_QUAKE2_JUMP_BEGIN + self.nPlayerAnim_WalkRunFrame;
	PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
	
	if(self.frame < PLAYERANIM_QUAKE2_JUMP_END)
		// Continue to process frames until end
		self.nPlayerAnim_WalkRunFrame = self.nPlayerAnim_WalkRunFrame + 1;
}
void PlayerAnim_Quake2_Taunt(float nTauntType, float tAnimSpeed)
{ // Quake2 Taunt Animation
	if(self.nPlayerModelType == PLAYERMODEL_MODELTYPE_MD2 && !self.deadflag)
	{ // Quake2 Player Model
		switch(nTauntType)
		{
			case PLAYERANIM_QUAKE2_TAUNT_FLIP:
				self.frame = PLAYERANIM_QUAKE2_TAUNT_FLIP_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_TAUNT_FLIP_END;
				break;
			case PLAYERANIM_QUAKE2_TAUNT_SALUTE:
				self.frame = PLAYERANIM_QUAKE2_TAUNT_SALUTE_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_TAUNT_SALUTE_END;
				break;
			case PLAYERANIM_QUAKE2_TAUNT_TAUNT:
				self.frame = PLAYERANIM_QUAKE2_TAUNT_TAUNT_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_TAUNT_TAUNT_END;
				break;
			case PLAYERANIM_QUAKE2_TAUNT_WAVE:
				self.frame = PLAYERANIM_QUAKE2_TAUNT_WAVE_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_TAUNT_WAVE_END;
				break;
			case PLAYERANIM_QUAKE2_TAUNT_POINT:
				self.frame = PLAYERANIM_QUAKE2_TAUNT_POINT_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_TAUNT_POINT_END;
				break;
		}
		
		PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
		
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
		self.bPlayerContigAnim_RunOverrides = FALSE;
		
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Jump(float tAnimSpeed)
{ // Jump Animation Function
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			self.nPlayerAnim_WalkRunFrame = 0;
			PlayerAnim_Quake2_Jump();
		break;
	}
}
void PlayerAnim_Stop()
{ // Stop Player Animations
	self.nextthink = -1;
	self.think = __NULL__;
	
	// Check for End Function
	if(self.fpPlayerContigAnim_EndFunction)
		self.fpPlayerContigAnim_EndFunction();
	// Purge Function
	self.fpPlayerContigAnim_EndFunction = __NULL__;
}
void PlayerAnim_Reset()
{ // Reset Player Animations
	self.nextthink = time + self.tPlayerFrameMacroSpeed;
	self.tPlayerFrameMacroSpeed = 0;
	self.bPlayerContigAnim_RunOverrides = FALSE;
	self.think = PlayerAnim_Run;
}
void PlayerAnim_Contiguous()
{ // Primary Contiguous Animation Function
	// Increment Frame
	self.frame = self.frame + 1;
	PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
	
	// Check for Run Overrides
	if(self.bPlayerContigAnim_RunOverrides && (self.velocity_x || self.velocity_y || self.velocity_z) )
	{ // Time to Return
		// Reset Animation
		PlayerAnim_Reset();
	}
	// Check if New Frame is Last
	if(self.frame == self.nPlayerContigAnim_End)
	{ // New Frame is Last; Reset Next Frame
		if(self.bPlayerContigAnim_FreezeAtEnd)
		{ // Freeze Animation
			self.bPlayerContigAnim_FreezeAtEnd = FALSE;
			self.think = PlayerAnim_Stop;
		}
		else
		if(self.bPlayerContigAnim_Repeat)
		{ // Repeat Animation
			self.frame = self.nPlayerContigAnim_Begin;
		}
		else
			// Reset Animation
			PlayerAnim_Reset();
	}
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
}
// ======================================================================
// Attacks
float PlayerAnim_Quake2_Attack()
{ // Quake2 Primary Attack
	local float bPlayAnim;
		bPlayAnim = TRUE;
	if(self.velocity_x || self.velocity_y || self.velocity_z)
		bPlayAnim = FALSE;
	else
	{
		if(self.bIsCrouching)
		{
			self.frame = PLAYERANIM_QUAKE2_CROUCHATTACK_BEGIN;
			self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_CROUCHATTACK_END;
		}
		else
		{
			self.frame = PLAYERANIM_QUAKE2_ATTACK_BEGIN;
			self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_ATTACK_END;
		}
		PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
		// Allow Movement to Override Firing Anim (Quake2 Behavior)
		self.bPlayerContigAnim_RunOverrides = TRUE;
	}
	return bPlayAnim;
}
void PlayerAnim_Attack_Axe(float nVariant, float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			if(nVariant == 0)
			{
				self.frame = $axatt1;
				self.nPlayerContigAnim_End = $axatt6;
			}
			else
			if(nVariant == 1)
			{
				self.frame = $axattb1;
				self.nPlayerContigAnim_End = $axattb6;
			}
			else
			if(nVariant == 2)
			{
				self.frame = $axattc1;
				self.nPlayerContigAnim_End = $axattc6;
			}
			else
			if(nVariant == 3)
			{
				self.frame = $axattd1;
				self.nPlayerContigAnim_End = $axattd6;
			}
		
			self.tPlayerFrameMacroSpeed = tAnimSpeed;
			
			if(self.tPlayerFrameMacroSpeed > 0)
				self.nextthink = time + self.tPlayerFrameMacroSpeed;
				
			self.think = PlayerAnim_Contiguous;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
		
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Attack_Hammer(float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = 32;
			self.nPlayerContigAnim_End = 37;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
				
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Attack_Shotgun(float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $shotatt1;
			self.nPlayerContigAnim_End = $shotatt6;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
		
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Attack_Nailgun(float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $nailatt1;
			self.nPlayerContigAnim_End = $nailatt2;
		break;
	
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
		
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Attack_Rocket(float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $rockatt1;
			self.nPlayerContigAnim_End = $rockatt6;
		break;
	
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
				
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}
void PlayerAnim_Attack_Lightning(float tAnimSpeed)
{
	local float bPlayAnim;
		bPlayAnim = TRUE;
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $light1;
			self.nPlayerContigAnim_End = $light2;
		break;
	
		case PLAYERMODEL_MODELTYPE_MD2:
			bPlayAnim = PlayerAnim_Quake2_Attack();
		break;
	}
	
	if(bPlayAnim)
	{
		self.tPlayerFrameMacroSpeed = tAnimSpeed;
			
		if(self.tPlayerFrameMacroSpeed > 0)
			self.nextthink = time + self.tPlayerFrameMacroSpeed;
			
		self.think = PlayerAnim_Contiguous;
	}
}

// ======================================================================
// Pain Animations
void PlayerAnim_Quake2_Pain()
{
	local float fRandom;
		fRandom = random();
	if(self.bIsCrouching)
	{
		self.frame = PLAYERANIM_QUAKE2_CROUCHPAIN_BEGIN;
		self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_CROUCHPAIN_END;
	}
	else
	if(fRandom < 0.33)
	{
		self.frame = PLAYERANIM_QUAKE2_PAIN1_BEGIN;
		self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_PAIN1_END;
	}
	else
	if(fRandom < 0.66)
	{
		self.frame = PLAYERANIM_QUAKE2_PAIN2_BEGIN;
		self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_PAIN2_END;
	}
	else
	{
		self.frame = PLAYERANIM_QUAKE2_PAIN3_BEGIN;
		self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_PAIN3_END;
	}
	PLAYERANIM_SYNCQUAKE2WEAPONENTITYFRAME
	
	self.bPlayerContigAnim_RunOverrides = FALSE;
}
void PlayerAnim_Pain(float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $pain1;
			self.nPlayerContigAnim_End = $pain6;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			PlayerAnim_Quake2_Pain();
		break;
	}
	
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}
void PlayerAnim_Pain_Axe(float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $axpain1;
			self.nPlayerContigAnim_End = $axpain6;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			PlayerAnim_Quake2_Pain();
		break;
	}
	
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}
void PlayerAnim_Pain_Hammer(float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = 18;
			self.nPlayerContigAnim_End = 23;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			PlayerAnim_Quake2_Pain();
		break;
	}
	
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}
// ======================================================================
// Death Animations
void PlayerAnim_Death(float nVariant, float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			if(nVariant == 0)
			{
				self.frame = $deatha1;
				self.nPlayerContigAnim_End = $deatha11;
			}
			else
			if(nVariant == 1)
			{
				self.frame = $deathb1;
				self.nPlayerContigAnim_End = $deathb9;
			}
			else
			if(nVariant == 2)
			{
				self.frame = $deathc1;
				self.nPlayerContigAnim_End = $deathc15;
			}
			else
			if(nVariant == 3)
			{
				self.frame = $deathd1;
				self.nPlayerContigAnim_End = $deathd9;
			}
			else
			if(nVariant == 4)
			{
				self.frame = $deathe1;
				self.nPlayerContigAnim_End = $deathe9;
			}
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			if(nVariant == 4)
			{ // Variant is 4; Replace with Random 0 - 3
				nVariant = rint( random() * 3);
				// bprint("New nVariant : ", ftos(nVariant), "\n");
			}
			
			if(nVariant == 0)
			{
				self.frame = PLAYERANIM_QUAKE2_DEATH1_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_DEATH1_END;
			}
			else
			if(nVariant == 1)
			{
				self.frame = PLAYERANIM_QUAKE2_DEATH2_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_DEATH2_END;
			}
			else
			if(nVariant == 2)
			{
				self.frame = PLAYERANIM_QUAKE2_DEATH3_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_DEATH3_END;
			}
			else
			if(nVariant == 3)
			{
				self.frame = PLAYERANIM_QUAKE2_CROUCHDEATH_BEGIN;
				self.nPlayerContigAnim_End = PLAYERANIM_QUAKE2_CROUCHDEATH_END;
			}
		break;
	}
	
	self.bPlayerContigAnim_RunOverrides = FALSE;
	self.bPlayerContigAnim_FreezeAtEnd = TRUE;
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}
void PlayerAnim_Death_Axe(float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = $axdeth1;
			self.nPlayerContigAnim_End = $axdeth9;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			PlayerAnim_Death(4, tAnimSpeed);
			return;
		break;
	}
	
	self.bPlayerContigAnim_FreezeAtEnd = TRUE;
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}
void PlayerAnim_Death_Hammer(float tAnimSpeed)
{
	switch(self.nPlayerModelType)
	{
		case PLAYERMODEL_MODELTYPE_MDL:
			self.frame = 24;
			self.nPlayerContigAnim_End = 31;
		break;
		case PLAYERMODEL_MODELTYPE_MD2:
			PlayerAnim_Death(4, tAnimSpeed);
			return;
		break;
	}
	
	self.bPlayerContigAnim_FreezeAtEnd = TRUE;
	self.tPlayerFrameMacroSpeed = tAnimSpeed;
	
	if(self.tPlayerFrameMacroSpeed > 0)
		self.nextthink = time + self.tPlayerFrameMacroSpeed;
		
	self.think = PlayerAnim_Contiguous;
}