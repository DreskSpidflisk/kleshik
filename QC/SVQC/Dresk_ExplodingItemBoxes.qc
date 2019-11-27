// DRESK - Exploding Item Boxes
// Provides values, definitions, functions and more for exploding item boxes.

// Fields
.float	bSuppressExplodingItemBox;
.entity	enExplodingItemBoxRealItem;
.entity	enExplodingItemBox_FlameDecal;

void ExplodingItemBox_Explode()
{
	// Restore Interactivity of Item
	self.enExplodingItemBoxRealItem.solid = SOLID_TRIGGER;
	self.enExplodingItemBoxRealItem.effects = self.enExplodingItemBoxRealItem.effects - (self.enExplodingItemBoxRealItem.effects & EF_NODRAW);
	
	// Drop Item to Floor
	// Remove Solidity of Explosion Box First
	self.solid = SOLID_NOT;
	local entity enOldSelf;
		// Backup Self
		enOldSelf = self;
	self = self.enExplodingItemBoxRealItem;
	droptofloor();
	self = enOldSelf;
	
	if(self.enExplodingItemBox_FlameDecal)
	{ // Delayed Explosion
		// Play Explosion Sound, Replacing Flaming Sound
		sound (self, CHAN_BODY, SOUND_KLESHIK_EXPLOSIONS_FLAMINGCONTAINEREXPLODE, 1, ATTN_NORM);
		
		// Remove Flame Decal
		remove(self.enExplodingItemBox_FlameDecal);
	}
	
	// Assign Item Origin to Explosion Origin
	// NOTE: No longer do this since the item is not being drawn, but still has
	// active physics.
	// setorigin(self.enExplodingItemRealItem, self.origin);
	
	// Remove Overridden Movetype
	// self.movetype = MOVETYPE_NONE;
	
	// Invoke Standard Explosion Routine
	barrel_explode(DAMAGETYPE_OTHER);
}
void ExplodingItemBox_Death(float fDamageType)
{
	if( GetIsDamageTypeRadiusDamage(fDamageType) )
	{ // Radius; Explode Immediately
		// Defer Very Slightly to Prevent Findradius Chain Entity Issues
		self.think = ExplodingItemBox_Explode;
		self.nextthink = time + 0.01 + random() * 0.05;
	}
	else
	{ // Delay Explosion
		// Remove Shadows on Box (hack to make flame entity look nicer)
		self.effects = self.effects | EF_NOSHADOW;
		// Remove Ability to Take Damage
		self.takedamage = DAMAGE_NO;
		
		// Assign Think to Actual Explosion
		self.think = ExplodingItemBox_Explode;
		self.nextthink = time + 0.5 + random();
		
		// Assign Flaming Sound
		sound(self, CHAN_BODY, SOUND_KLESHIK_EXPLOSIONS_FLAMINGCONTAINER, 1, ATTN_NORM);
		
		// Spawn Flame Decal
		self.enExplodingItemBox_FlameDecal = spawn();
		self.enExplodingItemBox_FlameDecal.aiment = self;
		self.enExplodingItemBox_FlameDecal.view_ofs = self.maxs * 0.5 + '0 0 10';
		self.enExplodingItemBox_FlameDecal.effects = EF_FLAME;
		self.enExplodingItemBox_FlameDecal.movetype = MOVETYPE_FOLLOW;
	}
}

void CheckExplodingItemBox()
{ // Check Exploding Item Box
	// NOTE: Assumed scope is entity that should explode.
	if(self.bSuppressExplodingItemBox)
		// Suppress Exploding Item; Return
		return;
	
	// Acquire Exploding Item Percent Chance
	local float fPercentChance;
		fPercentChance = cvar(CVAR_EXPLODINGITEMBOX_PERCENTCHANCE);
		
	local float bParseExplodingItemBox;
		if(fPercentChance <= 0)
			bParseExplodingItemBox = FALSE;
		else
		if(deathmatch)
		{ // DeathMatch
			if( cvar(CVAR_EXPLODINGITEMBOX_INDEATHMATCH) )
				// Exploding Items in Deathmatch
				bParseExplodingItemBox = TRUE;
			else
				bParseExplodingItemBox = FALSE;
		}
		else
			// Standard / Coop
			bParseExplodingItemBox = TRUE;
	
	if(bParseExplodingItemBox)
	{ // Parse Exploding Item
		if(self.touch == weapon_touch
			|| self.touch == health_touch
			|| self.touch == armor_touch
			|| self.touch == ammo_touch
			)
		{ // Valid Item for Exploding Item
			if( (random() ) <= (fPercentChance / 100) )
			{ // Spawn Exploding Item
				local entity enSpawn;
				local entity enItem;
				
				// Backup Current Item
				enItem = self;
				// Immediately Defer Collision on Original Item
				enItem.solid = SOLID_NOT;
				// Assign New Exploding Item
				self = enSpawn;
				// Spawn Exploding Item
					self = spawn();
					// Assign size
					// setsize (self, '-16 -16 0', '16 16 56');
					// Assign Origin
					setorigin(self, enItem.origin);
					// Invoke Exploding Entity
					if(enItem.touch == weapon_touch)
						// Large Box
						misc_explobox();
					else
						// Small Box
						misc_explobox2();
					// Override Death
					self.th_die = ExplodingItemBox_Death;
					// Override Classname (for death messages)
					self.classname = "exploding_item_box";
					// Override Movetype
					self.movetype = MOVETYPE_TOSS;
					/*
					self.angles_y = random() * 15;
					if(random() < 0.5)
						self.angles_y = self.angles_y * -1;
					*/
					self.health = 5 + ( random() * 20);
					// Assign Colormod
					self.colormod_x = 0.3 + random() * 0.3;
					self.colormod_y = 0.3 + random() * 0.3;
					self.colormod_z = 1.0;
					// self.colormod = '0.4 0.4 1.0';
					// Assign Bleeds Sparks
					self.bBleedsSparks = TRUE;
					// Assign Item to Real item
					self.enExplodingItemBoxRealItem = enItem;
					// Drop to Floor
					if ( !droptofloor() )
					{ // ERROR : Unable to Drop to Floor!
						// Increment Debug Counter
						nNumExplodingItemsDroppedOut = nNumExplodingItemsDroppedOut + 1;
						// Remove Exploding Item Box
						remove(self);
					}
					else
					{ // Successful Explosive Item Position
						// Defer Interactivity of Item
						enItem.solid = SOLID_NOT;
						enItem.effects |= EF_NODRAW;
					}
				
				// Restore Original Item
				self = enItem;
			}
		}
	}
}