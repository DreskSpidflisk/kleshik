// DRESK
// CSQC Temporary Entity Functions

// Fields

// Definitions

// Fields

// Functions
void te_DamageFeedbackWithImpactType(vector vOrigin, float fDamageAmount, float nImpactType)
{ // Damage Feedback with ImpactType Support
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_DAMAGEFEEDBACKWITHIMPACTTYPE);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Damage Amount
	WriteCoord(MSG_BROADCAST, fDamageAmount);
	// Write Damage Type
	WriteByte(MSG_BROADCAST, nImpactType);
}
void te_LargeObjectInWater(entity enEntity, float nContents)
{ // Large Object in Water
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_LARGEOBJECTINWATER);
	// Write Origin
	local vector vOrigin;
		vOrigin = enEntity.origin - '0 0 15';
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Contents Type
	WriteByte(MSG_BROADCAST, nContents * -1);
}
// NOTE : No longer used due to CSQCStat implementation
// Using TEs messes up save games, and can get out of sync with packet loss
/*
void te_PowerupDuration(entity enEntity, float nPowerup, float fDuration)
{ // Powerup Duration
	// Assign Message Entity
	msg_entity = enEntity;
	
	WriteByte(MSG_ONE, SVC_TEMPENTITY);
	WriteByte(MSG_ONE, TEMPORARYENTITY_POWERUPDURATION);
	
	// Write Powerup
	WriteByte(MSG_ONE, nPowerup);
	// Write Duration
	WriteShort(MSG_ONE, fDuration);
}*/
void te_LavaballImpact(vector vOrigin)
{ // Lavaball Impact
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_LAVABALLIMPACT);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);

}
void te_SmallObjectInWater(entity enEntity, float nContents)
{ // Large Object in Water
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_SMALLOBJECTINWATER);
	// Write Origin
	local vector vOrigin;
		vOrigin = enEntity.origin - '0 0 15';
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Contents Type
	WriteByte(MSG_BROADCAST, nContents * -1);
}
void te_FireBallExplosion(vector vOrigin)
{ // Fire Ball Explosion
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_FIREBALLEXPLOSION);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_RobotExplosion(vector vOrigin)
{ // Robot Explosion
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_ROBOTEXPLOSION);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_HeadOutOfWater(entity enEntity, float nContents)
{ // Head Out of Water
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_HEADOUTOFWATER);
	// Write Origin
	local vector vOrigin;
		vOrigin = enEntity.origin + '0 0 15';
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Contents Type
	WriteByte(MSG_BROADCAST, nContents * -1);
}
void te_RapidLaserRicochet(vector vOrigin)
{ // Rapid Laser Ricochet
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_RAPIDLASERRICOCHET);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_RapidLaserFinalTouch(vector vOrigin)
{ // Rapid Laser Final Touch
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_RAPIDLASERFINALTOUCH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_SmallDustKickup(vector vOrigin)
{ // Small Dust Kickup
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_SMALLDUSTKICKUP);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_GenericWeaponFire(vector vOrigin, vector vForward)
{ // Generic Weapon Fire
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_GENERICWEAPONFIRE);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Forward Vector
	local vector vByteForward;
		vByteForward_x = (vForward_x + 1.0) * 127.5;
		vByteForward_y = (vForward_y + 1.0) * 127.5;
		vByteForward_z = (vForward_z + 1.0) * 127.5;
	WriteByte(MSG_BROADCAST, vByteForward_x);
	WriteByte(MSG_BROADCAST, vByteForward_y);
	WriteByte(MSG_BROADCAST, vByteForward_z);
}
void te_CorpseStain(vector vOrigin)
{ // Corpse Stain
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_CORPSEBLOODSTAIN);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_GrenadeBounce(vector vOrigin)
{ // Grenade Bounce
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_GRENADEBOUNCE);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_FlareBounce(vector vOrigin)
{ // Flare Bounce
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_FLAREBOUNCE);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_ItemRespawn(vector vOrigin)
{ // Item Respawn
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_ITEMRESPAWN);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_CorpseLargeDustSmash(vector vOrigin)
{ // Corpse Dust Smash
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_CORPSELARGEDUSTSMASH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_CorpseDustSmash(vector vOrigin, float nImpactType)
{ // Corpse Dust Smash
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_CORPSEDUSTSMASH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Damage Type
	WriteByte(MSG_BROADCAST, nImpactType);
}
void te_AxeHitMaterial(vector vOrigin)
{ // Axe Hit Material
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_AXEHITMATERIAL);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_SimpleLaserTouch(vector vOrigin)
{ // Simple Laser Touch
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_SIMPLELASERTOUCH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_LaserGunAltTouch(vector vOrigin)
{ // Laser Gun Alt Touch
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_LASERGUNALTTOUCH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_EliteMonsterDeath(vector vOrigin)
{ // Elite Monster Death
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_ELITEMONSTERDEATH);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}
void te_EliteMonsterRedirectProjectile(vector vOrigin)
{ // Elite Monster Redirect Projectile
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_ELITEMONSTERREDIRECTPROJECTILE);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
}