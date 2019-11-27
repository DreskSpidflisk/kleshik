// DRESK
// Throwable Flares Support

// Fields
.float	tThrowableFlareRefireTime;
.float	bFlareShellDeployed;

// Functions
void FlareShellRemove()
{ // Flare Shell Remove
	// Play Sound
	sound(self, CHAN_AUTO, SOUND_KLESHIK_FLARES_FIZZLE, 1, ATTN_NORM);
	te_smallflash(self.origin);
	remove(self);
}
void FlareShellDeploy()
{ // Flare Shell Deploy
	if(!self.bFlareShellDeployed)
	{ // Deploy Flare Shell
		self.bFlareShellDeployed = TRUE;
		// Apply Initial Effects
		te_smallflash(self.origin);
		te_flamejet(self.origin, '0 0 50', SG_AUTOCVAR(kleshik_server_ThrowableFlares_FlareLightPower) );
		
		// Play Sound
		sound(self, CHAN_AUTO, SOUND_KLESHIK_FLARES_DEPLOY, 1, ATTN_NORM);
		
		// Calculate Radius
		local float fRadius;
			fRadius = 475 + (random() * 650);
		
		// Assign Flare Glow
		self.effects = EF_FULLBRIGHT;
		self.color = '1 1 0';
		self.pflags = PFLAGS_CORONA | PFLAGS_FULLDYNAMIC;
		self.style = 6;
		self.light_lev = fRadius;
		
		// Assign Flare Removal
		self.nextthink = time + cvar(CVAR_THROWABLEFLARES_FLARELIFETIME);
		self.think = FlareShellRemove;
		
		// Align with Surface Normal
		GetAlignedSurfaceAngles(self);
		
		// Acquire Owner
		local entity enOwner;
			enOwner = GetOwnerTouchableProjectileOwner(self);
		
		if( !( (enOwner.flags & FL_NOTARGET) || (enOwner.nCSQCStat_Powerups & POWERUP_INVISIBILITY) ) )
		{ // Owner is not Stealthed
			// Alert Monsters in Radius
			local entity enOldSelf;
				enOldSelf = self;
			local entity enFind;
				enFind = findradius(self.origin, fRadius);
				
			while(enFind)
			{ // Valid Entity
				if(enFind.flags & FL_MONSTER && enFind.health > 0 && enFind.takedamage)
				{ // Alert Monster
					traceline(enOldSelf.origin, enFind.origin, TRUE, enOldSelf);
					if (trace_fraction == 1.0)
					{ // Line of Sight Available
						self = enFind;
						CheckMonsterResponseToDamage(enOwner);
					}
				}
				// Acquire Next
				enFind = enFind.chain;
			}
		}
		
		// Restore Old Self
		self = enOldSelf;
	}
}
void FlareShellTouch()
{ // Flare Shell Touch
	// Calculate Velocity Vector Length
	local float fVelocity;
		fVelocity = vlen(self.velocity);
		
	if(other.takedamage && fVelocity > 375)
	{ // Hit Damageable Entity
		// Calculate Owner
		local entity enOwner;
			enOwner = GetOwnerTouchableProjectileOwner(self);
			
		T_Damage(other, self, enOwner, HITLOCATION_SELFORIGIN, DAMAGETYPE_THROWABLEFLARE_HIT, cvar(CVAR_THROWABLEFLARES_FLARETOUCHDAMAGE) );
		
		// Play Sound
		sound(self, CHAN_AUTO, SOUND_KLESHIK_FLARES_HIT, 1, ATTN_NORM);
		
		// Provide Additional Feedback
		te_spark(self.origin, '0 0 50', 25);
		
		// Deploy Flare Shell
		FlareShellDeploy();
	}
	else
	if(fVelocity > 200)
	{ // Non-Dormant Shell
		te_FlareBounce(self.origin);
	}
}
void ThrowFlare()
{ // Throw Flare
	if(time > self.tThrowableFlareRefireTime)
	{ // Flare Throw Allowed
		makevectors(self.v_angle);
		
		local entity enFlare;
		
		// Update Flare Refire Time
		self.tThrowableFlareRefireTime = time + cvar(CVAR_THROWABLEFLARES_FLAREREFIRETIME);
		// Remove Flare Available
		self.nCSQCStat_FlareAvailable = FALSE;
		
		// Play Sound Here
		sound(self, CHAN_AUTO, SOUND_KLESHIK_FLARES_THROW, 1, ATTN_NORM);
		
		// Spawn Flare
		enFlare = spawn();
		enFlare.owner = self;
		enFlare.movetype = MOVETYPE_BOUNCE;
		enFlare.solid = SOLID_BBOX;
		enFlare.scale = 0.45;
		// Assign Additional Bounce
		enFlare.bouncefactor = 0.65;
		
		setmodel(enFlare, "Models/Objects/ThrowableFlare/ThrowableFlare.mdl");
		enFlare.skin = 4;
		setsize(enFlare, '0 0 -3', '0 0 3');
		WeaponEvents_SetupOriginAndDirection('20 8 13');
		setorigin(enFlare, vCurrentShotOrigin);
		// setorigin(enFlare, self.origin + '0 0 25' + (v_right * 5) );
		
		enFlare.colormod = '1 1 0';
		
		// Assign Velocity
		enFlare.velocity = v_forward * 1000 + SG_crandom()*v_right*10 + SG_crandom()*v_up*10;
		
		// Support Explosives Owner Velocity Ratio
		local float fExplosivesOwnerVelocityRatio;
			fExplosivesOwnerVelocityRatio = cvar(CVAR_WEAPON_PROJECTILESOWNERVELOCITYRATIO);
		if(fExplosivesOwnerVelocityRatio)
			enFlare.velocity = enFlare.velocity + (self.velocity * fExplosivesOwnerVelocityRatio);
		
		enFlare.angles = vectoangles(enFlare.velocity);
		enFlare.avelocity = '900 300 450';
		
		enFlare.touch = FlareShellTouch;
		enFlare.contentstransition = ContentsTransition_SmallObjectInWater;
		
		PrepareOwnerTouchableProjectile(enFlare, FlareShellDeploy, 1.3);
		
		// DRESK
		// Apply Gyro Physics Properties
		if(g_bGyroPhysicsEnabled)
		{
			Gyro_ObjectMacro_Grenade(enFlare, 100);
			Gyro_Object_SetBouyancy(enFlare, 300);
		}
	}
}