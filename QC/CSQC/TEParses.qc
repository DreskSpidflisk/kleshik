// Temporary Entity Parses

float CSQC_Parse_TempEntity()
{ // Parse Temp Entity
	local float bHandled;
		bHandled  = true;
	// Acquire TE ID
	local float nTEID;
		nTEID = ReadByte();
		
	switch(nTEID)
	{
		case TE_EXPLOSION:
		case TE_EXPLOSION2:
		case TE_EXPLOSIONQUAD:
		case TE_EXPLOSIONRGB:
			ParseExplosionEffect(nTEID);
			break;
		case TE_TAREXPLOSION:
			ParseTarExplosion();
			break;
		case TE_GUNSHOT:
		case TE_GUNSHOTQUAD:
			ParseGunShotEffect(nTEID);
			break;
		case TE_WIZSPIKE:
			ParseWizardSpike();
			break;
		case TE_KNIGHTSPIKE:
			ParseKnightSpike();
			break;
		case TEMPORARYENTITY_DAMAGEFEEDBACKWITHIMPACTTYPE:
			ParseDamageFeedbackWithImpactTypeEffect();
			break;
		case TEMPORARYENTITY_CORPSEBLOODSTAIN:
			ParseCorpseBloodStain();
			break;
		case TEMPORARYENTITY_GRENADEBOUNCE:
			ParseGrenadeBounce();
			break;
		case TEMPORARYENTITY_GENERICWEAPONFIRE:
			ParseGenericWeaponFire();
			break;
		case TEMPORARYENTITY_ITEMRESPAWN:
			ParseItemRespawn();
			break;
		case TEMPORARYENTITY_LARGEOBJECTINWATER:
			ParseObjectInWater(TRUE);
			break;
		case TEMPORARYENTITY_SMALLOBJECTINWATER:
			ParseObjectInWater(FALSE);
			break;
		case TEMPORARYENTITY_SMALLDUSTKICKUP:
			ParseSmallDustKickup();
			break;
		case TEMPORARYENTITY_ELITEMONSTERDEATH:
			ParseEliteMonsterDeath();
			break;
		case TEMPORARYENTITY_ELITEMONSTERREDIRECTPROJECTILE:
			ParseEliteMonsterRedirectProjectile();
			break;
		case TEMPORARYENTITY_AXEHITMATERIAL:
			ParseAxeHitMaterial();
			break;
		case TEMPORARYENTITY_CORPSELARGEDUSTSMASH:
			ParseCorpseLargeDustSmash();
			break;
		case TEMPORARYENTITY_CORPSEDUSTSMASH:
			ParseCorpseDustSmash();
			break;
		case TEMPORARYENTITY_SIMPLELASERTOUCH:
			ParseSimpleLaserTouch();
			break;
		case TEMPORARYENTITY_LASERGUNALTTOUCH:
			ParseLaserGunAltTouch();
			break;
		case TEMPORARYENTITY_FLAREBOUNCE:
			ParseFlareBounce();
			break;
		case TEMPORARYENTITY_RAPIDLASERRICOCHET:
			ParseRapidLaserRicochet();
			break;
		case TEMPORARYENTITY_RAPIDLASERFINALTOUCH:
			ParseRapidLaserFinalTouch();
			break;
		case TEMPORARYENTITY_HEADOUTOFWATER:
			ParseHeadOutOfWater();
			break;
		case TEMPORARYENTITY_FIREBALLEXPLOSION:
			ParseFireBallExplosion();
			break;
		case TEMPORARYENTITY_ROBOTEXPLOSION:
			ParseRobotExplosion();
			break;
		case TEMPORARYENTITY_WEAPONFIRE:
			ParseWeaponFireEffect();
			break;
		case TEMPORARYENTITY_LAVABALLIMPACT:
			ParseLavaballImpact();
			break;
		default:
			bHandled = false;
			break;
	}
		
	return bHandled;
}