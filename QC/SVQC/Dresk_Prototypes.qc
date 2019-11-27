// DRESK
// Prototypes

// ---------------------------------------------------------------------------------------------------------------
// Standard Quake / Hipnotic / Rogue Prototypes

// Damage
	void T_Damage(entity enTarget, entity enInflictor, entity enAttacker, vector vHitLocation, float fDamageType, float fDamage);
	void T_Damage_Direction(entity enTarget, entity enInflictor, entity enAttacker, vector vHitLocation, float fDamageType, float fDamage, float bHasDirection, vector vDamageDirection);
	void T_RadiusDamage(entity enInflictor, entity enAttacker, float fDamageType, float fDamage, entity enIgnoreEntity);
	
// Weapons
	void SuperDamageSound();
	void BecomeExplosion();
	void W_AxeAttack();
	float W_BestWeapon();
	void BoundAmmo(entity enEntity);
	void Deathmatch_Weapon(float nOld, float nNew);
	float RankForWeapon(float w);
	// Hipnotic
		void ProximityExplode();
		
// Intermission
	float intermission_running;
	float intermission_exittime;
	float intermission_bViewedAdvancedStats;
	float intermission_bViewedClientScores;
	float intermission_running;

// Misc
	entity SelectSpawnPoint();
	void misc_explobox2();
	void misc_explobox();
	void barrel_explode(float fDamageType);
	void CheckRules();
	void SUB_regen();
	void SUB_Null();
	void SUB_Null_Pain(entity enAttacker, float fDamage, float fAttacker);
	void SUB_Null_Die(float fDamageType);
	// Rogue
		void Rogue_EarthQuake();
		void xpackEnding();
		
// Monsters
	void FoundTarget();
	void monster_death_use();
	void monster_army();
	void monster_enforcer();
	void monster_demon1();
	void monster_dog();
	void monster_fish();
	void monster_hell_knight();
	void monster_knight();
	void monster_ogre();
	void monster_shalrath();
	void monster_shambler();
	void monster_tarbaby();
	void monster_wizard();
	void monster_zombie();
	// Hipnotic
		void monster_gremlin();
		void monster_scourge();
		void monster_armagon();
	// Rogue
		void monster_eel();
		void monster_sword();
		void monster_mummy();
		void monster_wrath();
		void monster_super_wrath();
		void monster_morph();
		void monster_lava_man();
		
// Items
	void item_armor1();
	void item_armor2();
	void item_armorInv();
	
	void item_artifact_envirosuit();
	void item_artifact_invisibility();
	void item_artifact_invulnerability();
	void item_artifact_super_damage();
	
	void weapon_touch();
	void health_touch();
	void armor_touch();
	void ammo_touch();
	
	void powerup_touch();
	
	void StartItem();
	
	// Hipnotic
	void item_artifact_empathy_shields();
	void ProximityGrenadeExplode(float fDamageType);
	
// Weapons
	void weapon_supershotgun();
	void weapon_nailgun();
	void weapon_supernailgun();
	void weapon_grenadelauncher();
	void weapon_rocketlauncher();
	void weapon_lightning();
	void FireBullets(float fDamageType, float fDamage, float shotcount, vector dir, vector spread);
	entity launch_spike(vector org, vector dir);
	
	// Hipnotic
	void weapon_proximity_gun();
	void weapon_laser_gun();
	void weapon_mjolnir();
	
	// Kleshik
	void weapon_laser_gun_kleshik();
	void weapon_flechette_cannon();
	void weapon_chain_gun();
	
	// Rogue
	void launch_fireball(vector org, vector dir);
	entity launch_lava_spike(vector org, vector dir);

// Player
	void InitBodyQue();
	void set_suicide_frame();
	void DecodeLevelParms();
	void PlayerDie(float fDamageType);
	
	void W_WeaponFrame();
	void W_SetCurrentAmmo(float bOnlyAmmo);
	void spawn_tfog(vector vOrigin, entity enEntity);
	void spawn_tdeath(vector org, entity death_owner);
	
	void ClientObituary (entity targ, entity attacker, entity enInflictor, float fDamageType);
	
	void player_pain(entity enAttacker, float fDamage, float fDamageType);

// ---------------------------------------------------------------------------------------------------------------
// Kleshik Prototypes

// Coop
// Coop Shared Ammo / Weapons
	float g_bCoopSharedAmmo;
	float UpdateSharedAmmo(float nAmmoType, float nModify);
	float CheckCooperativeSharedWeaponAddition(entity enPlayer, float nWeapon);
	
// Advanced Statistics
	void CheckUpdatedAdvancedStatistics();
	void RegisterAdvancedGameStatistic(float fType);
	
// Client Stats Score
	void UpdateClientStatsScore(entity enClient, float nScoreType, float fMod);
	
// Game Modes
	void PrepareGameModeCVars();
	
	float	g_bKleshikWeaponsEnabled;
	
// Items
	.float	bIsCloneItem;
	.float	bIsDroppedItem;
	.entity	enCloneItem;
	
	entity SpawnCloneItem(entity enHostItem, string strClassname, void() fpItemFunc);
	void DropNewArmor(float nArmorType);
	void DropNewPowerup(float nPowerupType, float tPowerupTime);
	float CheckCooperativeItemRespawn(float nRespawnTime);
	float CheckFadedItem();
	void TossItem(entity enOwner, entity enItem);

// Weapons
	void WeaponEvents_Main(float nFiringMode, float bMuzzleFlash);
	void WeaponEvents_WeaponAnim(float nBeginAnim, float nEndAnim, float tAnimSpeed, void(float nState) fpStateFunction);
	void ViewWeapon_Think();
	void ViewWeapon_PurgeThink();
	void ViewWeapon_ToggleDraw(entity enClient, float bDraw);
	void EliteMonsterRedirectProjectile(entity enEliteMonster, entity enProjectile);
	
	void RemoveProximityBombFromEntityLinkedList(entity enEntity, entity enBomb);
	
	.float	bIsProximityBombInLinkedList;
	
	float	g_nNumCurrentProximityBombs;
	
// Exploding Item Boxes
	.float bSuppressExplodingItemBox;

// Client / Player
	.float	bUseInvisibilityEyes;
	.float	bIsCrouching;
	.float	nCurrentArmorMaxArmorValue;
	.float	nPlayerFinalCorpseFrame;
	.float	nPlayerCorpseTwitchState;
	
	void PlayerCorpseDie(float fDamageType);
	float CheckAndRemoveEntity(entity enOwner, .entity enEntity);
	void SetPlayerSize(entity enPlayer);
	void PlayerCorpseTwitchThink();
	
// Player Animation
	void PlayerAnim_Contiguous();
	void PlayerAnim_Run();
	void PlayerAnim_Quake2_Jump();
	
// Player Models
	float	g_nCrouch_InteractivityLevel;
	void CheckPlayerModelUpdate(entity enPlayer);
	void SetPlayerModel_Quake2(entity enClient, string strModelName, string strUseSounds, string strSkinID, string strWeaponID, float bBroadcastChange);
	void Quake2WeaponEntity_SetIsDrawing(entity enClient, float bIsDrawing);
	
// Blood / Gore
	void CheckCreatureBleeding(entity enCreature);
	vector VelocityForDamage(float dm, float bIgnoreDirectionalGibs);
	void DamageableGib_Touch();
	void ThrowGib(string gibname, float dm);
	void ThrowHead(string gibname, float dm, float nGibbedHeadType);
	void SpawnMeatSpray(vector org, vector vel);
	// void spawn_touchblood(float damage);
	// void SpawnBlood(vector org, vector vel, float damage);
	void PrepareDamageableGib(entity enGib);
	
// Misc
	void SilentContentsTransition(float nOriginalContents, float nNewContents);
	void ContentsTransition_SmallObjectInWater(float nOriginalContents, float nNewContents);
	void ContentsTransition_BodyInWater(float nOriginalContents, float nNewContents);
	float GetRandomVectorValue(float fMinimumVector);
	void RestoreEntityAlpha(entity enEntity);
	void GetAlignedSurfaceAngles(entity enEntity);
	void ListHipnoticSpawnEntities(entity enClient);
	void ListNODRAWMonsters(entity enClient);
	
	void PerformGlobalPrecaches();
	
// Monsters
	void CheckMonsterResponseToDamage(entity enAttacker);
	void RemoveAllMonsterCorpses(entity enClient);
	void KillAllMonsters(entity enClient);
	float SetNewEntityAlpha(entity enEntity, float fAlpha);
	
	void monster_kleshik_firefiend();
	void monster_kleshik_babydragon();
	void monster_kleshik_flisker();
	void CheckFliskerSpawnCorpseBursterController(entity enCorpse);
	void CheckCorpseForFliskerCorpseBursterController(entity enCorpse);
	
	.float nNumCorpseTwitches;
	
	float g_nNumSpawnedMonsters;
	float g_nNumKilledSpawnedMonsters;
	
	.float		bIsHipnoticSpawnCreature;
	
	.string strMonsterDisplayName;
	
	.float	bCannotSpawnFliskers;
	// Hipnotic
		.float bStrongScourge;
		
// Elite Monsters
	void AssignEliteMonsterAttributes(entity enMonster);
	
	.float bIsEliteMonster;
	.float bInitiallyStealthedEliteMonster;
	.float bCannotBecomeEliteMonster;
	
// Floating Items
	void CheckFloatingWeapon(entity enPlayer);
	
// FlashLight
	void ToggleFlashLight(float nFlashLightTypeForce);
	void CheckFlashLightSourceEntity();
	
// Help
	void BroadcastClientPlayerModelChange(entity enClient, string strModelName);
	
// Travail
#ifdef COMPILE_MODSUPPORT_TRAVAIL
	// Enforcer
		.float	nEnforcerType;
		void Travail_Enforcer_Attack();
		void Travail_Enforcer_FireRocket();
		void Travail_Enforcer_FireParticleBeam();
		void Travail_Enforcer_FireKnight(float offset);
		void Travail_fireball_use();
		void Travail_GibFountain_Think();
		
	void Travail_Special_teleport_touch();
	void Travail_Enforcer_Attack();
	float Travail_orig_random();
	void monster_ubs();
#endif