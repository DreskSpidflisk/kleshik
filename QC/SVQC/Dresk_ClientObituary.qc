// DRESK - Client Obituary

// Definitions

// Fields

// Functions
/*
===========
ClientObituary

called when a player dies
============
*/
void ClientObituary (entity targ, entity attacker, entity enInflictor, float fDamageType)
{
	local	float rnum;
	local	string deathstring, deathstring2;
	rnum = random();
	local float fRandom;

	if (targ.classname == "player")
	{
		// DRESK
		// Update Number of Deaths
		UpdateClientStatsScore(targ, CLIENTSCORE_NUMDEATHS, 1);
		
		if (fDamageType == DAMAGETYPE_MISC_TELEFRAG)
		{
			bprint (targ.netname);
			// DRESK
			// Print Color Escape
			bprint ("^7");
			bprint (" was ^1telefragged^7 by ");
			bprint (attacker.owner.netname);
			bprint ("\n");

			// DRESK
			// Support Cooperative Frags Based on Monsters Killed
			if(deathmatch)
				attacker.owner.frags = attacker.owner.frags + 1;
				
			return;
		}

		if (fDamageType == DAMAGETYPE_MISC_INVULNERABLETELEFRAGDEFLECT)
		{
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			// DRESK
			// Print Color Escape
			bprint ("^7");
			bprint ("'s telefrag\n");

			// DRESK
			// Support Cooperative Frags Based on Monsters Killed
			if(deathmatch)
				targ.frags = targ.frags - 1;
				
			return;
		}
		
		// DRESK
		// Check Player Death Feedback
		if(coop)
			PlayerDeath_CheckDeathFeedback(FALSE, attacker);
			
		// Force Teleport Print Update
		// NOTE: For performance reasons, this is accomplished by flagging
		// a global variable for the next frame.
		g_nPersonalTeleporter_NumFramesForcePrint = 2;
		
		// Check Disable of Teleport Display
		// NOTE: Perform this check BEFORE any other centerprints,
		// since this performs a centerprint that clears the menu (if it
		// was drawing)
		if(self.tPersonalTeleporter_TeleportPrintTime)
		{ // Display Enabled; Disable
			self.tPersonalTeleporter_TeleportPrintTime = 0;
			self.nPersonalTeleporter_NumTeleportTargets = 0;
			// Immediately Purge Menu
			centerprint(self, "");
		}
			
		// Support Coop Respawn Reminders
		PrintCooperativeRespawnReminder(targ);
		// Assign Last Death origin
		self.vLastDeathOrigin = self.origin;
		// Assign Last Equipped Weapon
		self.nLastEquippedWeapon = self.weapon;
		// Check Flash Light Events
		CheckFlashLightOnDeath();
			
		// DRESK
		// Check Extra Death Functionality
		// CheckExtraDeathFunctionality(targ);

		if (attacker.classname == "player")
		{
			if (targ == attacker)
			{ // Self Kill
				// killed self
				// DRESK
				// Support Cooperative Frags Based on Monsters Killed
				if(deathmatch)
					attacker.frags = attacker.frags - 1;
					
				bprint (targ.netname);
				// DRESK
				// Print Color Escape
				bprint ("^7");
				
				if(fDamageType == DAMAGETYPE_MISC_SUICIDE)
				{ // Suicide
					fRandom = random();
						
					if(fRandom <= 0.25)
					{
						bprint (" chokes on ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his") );
						bprint (" own ", SG_GetSexVerbiage(targ.nPlayerModelSex, "sweat"), "\n");
					}
					else
					if(fRandom <= 0.50)
					{
						bprint (" draws ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his") );
						bprint (" last ", SG_GetSexVerbiage(targ.nPlayerModelSex, "heartbeat"), "\n");
					}
					else
					if(fRandom <= 0.75)
					{
						bprint(" succumbs to ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his") );
						bprint(" ", SG_GetSexVerbiage(targ.nPlayerModelSex, "injuries"), "\n");
					}
					else
						bprint(" suicides\n");
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGDISCHARGE)
					bprint (" discharges into the water\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGBEAMDISCHARGE)
					bprint (" discharges ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " beam into the water\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_GRENADELAUNCHER)
					bprint (" tries to put the pin back in\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_ROCKETLAUNCHER)
					bprint(" rides ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own rocket\n");
				else
				// DRESK - HIPNOTIC SUPPORT
				if(fDamageType == DAMAGETYPE_WEAPON_PROXIMITYGRENADE)
				{
					if( rnum < 0.5)
						bprint (" stumbles over ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own proximity mine\n");
					else
						bprint (" makes love to ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own red balls\n");
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LASERCANNON)
					bprint (" gives ", SG_GetSexVerbiage(targ.nPlayerModelSex, "himself"), " laser surgery\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MJOLNIR)
					bprint (" tries ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " hammer in hostile waters\n");
				else
				// DRESK - ROGUE SUPPORT
				if(fDamageType == DAMAGETYPE_WEAPON_MULTIGRENADE)
					bprint (" lavishes ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own pineapples\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MULTIROCKET)
					bprint (" rapes ", SG_GetSexVerbiage(targ.nPlayerModelSex, "himself"), " with rockets\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_PLASMA)
					bprint (" treats ", SG_GetSexVerbiage(targ.nPlayerModelSex, "himself"), " with plasma\n");
				else
				if(fDamageType == DAMAGETYPE_THROWABLEFLARE_HIT)
				{
					bprint (" cracked ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his") );
					bprint (" ", SG_GetSexVerbiage(targ.nPlayerModelSex, "skull") );
					bprint (" on ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own flare shell\n");
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_FLECHETTECANNON)
					bprint (" was shredded by ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " own flechette\n");
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LASERGUN_ALTERNATE)
					bprint (" gave ", SG_GetSexVerbiage(targ.nPlayerModelSex, "himself"), " a deadly laser concussion\n");
				else
					// Unknown Damage Type
					bprint (" becomes bored with life\n");
					
				return;
			}
			else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) )
			{
				bprint (attacker.netname);
				
				if (rnum < 0.25)
					bprint(" mows down a teammate\n");
				else if (rnum < 0.50)
					bprint(" checks ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " glasses\n");
				else if (rnum < 0.75)
					bprint(" gets a frag for the other team\n");
				else
					bprint(" loses another friend\n");
				// DRESK
				// Support Cooperative Frags Based on Monsters Killed
				if(deathmatch)
					attacker.frags = attacker.frags - 1;
					
				return;
			}
			else
			{
				// DRESK
				// Support Cooperative Frags Based on Monsters Killed
				if(deathmatch)
					attacker.frags = attacker.frags + 1;

				if(fDamageType == DAMAGETYPE_WEAPON_AXE)
				{
					deathstring = " was ax-murdered by ";
					deathstring2 = "\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SHOTGUN)
				{
					deathstring = " chewed on ";
					deathstring2 = "'s boomstick\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SUPERSHOTGUN)
				{
					deathstring = " ate 2 loads of ";
					deathstring2 = "'s buckshot\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SPIKE_TOUCH)
				{
					deathstring = " was nailed by ";
					deathstring2 = "\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SUPERSPIKE_TOUCH)
				{
					deathstring = " was punctured by ";
					deathstring2 = "\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_GRENADELAUNCHER)
				{
					deathstring = " eats ";
					deathstring2 = "'s pineapple\n";
				}
				// **********************************************
				// DRESK - HIPNOTIC SUPPORT
				else
				if(fDamageType == DAMAGETYPE_WEAPON_PROXIMITYGRENADE)
				{
					if (random() < 0.5)
						deathstring = " got too friendly with ";
					else
						deathstring = " did the rhumba with ";
						
					deathstring2 = "'s bomb\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LASERCANNON)
				{
					if (random() < 0.5)
						deathstring = " was toasted by ";
					else
						deathstring = " was radiated by ";
					
					deathstring2 = "'s laser\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MJOLNIR)
				{
					deathstring = " was slammed by ";
					deathstring2 = "'s hammer\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MJOLNIRLIGHTNING)
				{
					deathstring = " was shocked by ";
					deathstring2 = "'s mjolnir lightining\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_EMPATHYSHIELDS)
				{	
					deathstring = " empathizes with ";
					deathstring2 = "'s pain\n";
				}
				// DRESK - END HIPNOTIC SUPPORT
				// **********************************************
				
				// **********************************************
				// DRESK - ROGUE SUPPORT
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MULTIGRENADE)
				{
					deathstring = " ate from ";
					deathstring2 = "'s pineapple tree\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_MULTIROCKET)
				{
					deathstring = " was raped by ";
					deathstring2 = "'s rockets\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_PLASMA || fDamageType == DAMAGETYPE_WEAPON_PLASMADISCHARGE)
				{
					deathstring = " ingested ";
					deathstring2 = "'s plasma\n";
				}
				// DRESK - END ROGUE SUPPORT
				// **********************************************
				else
				if(fDamageType == DAMAGETYPE_WEAPON_ROCKETLAUNCHER)
				{
					deathstring = " rides ";
					deathstring2 = "'s rocket\n";
				}
				else
				// DRESK
				// Modified Logic for Lightning
				if(fDamageType == DAMAGETYPE_WEAPON_LIGHTNING)
				{
					deathstring = " accepts ";
					deathstring2 = "'s shaft\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGDISCHARGE || fDamageType == DAMAGETYPE_WEAPON_LIGHTNINGBEAMDISCHARGE)
				{
					deathstring = " accepts ";
					deathstring2 = "'s discharge\n";
				}
				else
				if(fDamageType == DAMAGETYPE_THROWABLEFLARE_HIT)
				{
					deathstring = " was sodomized by ";
					deathstring2 = "'s flare shell\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SNIPERRIFLE)
				{
					deathstring = strcat(" became hit #", ftos(targ.nSniperBulletNumTargetsHit), " from ");
					deathstring2 = "'s sniper round\n";
					// Reset Sniper Bullet Hits
					targ.nSniperBulletNumTargetsHit = 0;
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LASERGUN)
				{
					deathstring = " ingested ";
					deathstring2 = "'s laser spew\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_LASERGUN_ALTERNATE)
				{
					deathstring = " sucked the concussive blast from ";
					deathstring2 = "'s laser\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_FLECHETTECANNON)
				{
					deathstring = " was shredded by ";
					deathstring2 = "'s flechette\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_SCATTERSHOT)
				{
					deathstring = " choked on ";
					deathstring2 = "'s scattershot\n";
				}
				else
				if(fDamageType == DAMAGETYPE_WEAPON_CHAINGUN)
				{
					deathstring = " was riddled with holes by ";
					deathstring2 = "'s chaingun\n";
				}
				bprint (targ.netname);
				// DRESK
				// Print Color Escape
				bprint ("^7");
				bprint (deathstring);
				bprint (attacker.netname);
				// DRESK
				// Print Color Escape
				bprint ("^7");
				bprint (deathstring2);
			}
			return;
		}
		else
		{
			// DRESK
			// Support Cooperative Frags Based on Monsters Killed
			if(deathmatch)
				targ.frags = targ.frags - 1;
				
			bprint (targ.netname);
			// DRESK
			// Print Color Escape
			bprint ("^7");

			// killed by a montser?
			if (attacker.flags & FL_MONSTER)
			{
				// DRESK
				// Check for Elite Monster Redirected Projectile
				if(enInflictor.bRedirectedEliteMonsterProjectile)
				{ // Redirected Projectile
					bprint(" was obliterated by the redirected projectile of a ");
				}
				else
				if (attacker.classname == "monster_army")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_SOLDIER_SUPERSHOTGUN)
						bprint (" was buckshotted by a ");
					else
						bprint (" was shot by a ");
				}
				else
				// DRESK
				// Support Death by Cthon
				if (attacker.classname == "monster_boss")
					bprint (" was immolated by ");
				else
				if (attacker.classname == "monster_demon1")
					bprint (" was eviscerated by a ");
				else
				if (attacker.classname == "monster_dog")
					bprint (" was mauled by a ");
				else
				if (attacker.classname == "monster_dragon")
				{
					// DRESK - ROGUE SUPPORT
					// Additional Death Messages + Proper Rogue Support
					if(attacker.classname == "monster_dragon_dead")
						bprint (" was squashed by the ");
					else
						bprint (" was annihilated by the ");
						
					// bprint (" was fried by a ^1Dragon\n");
				}
				else
				if (attacker.classname == "monster_enforcer")
				{
					if(fDamageType == DAMAGETYPE_WEAPON_ROCKETLAUNCHER)
						bprint(" ate the rocket of an ");
					else
					if(fDamageType == DAMAGETYPE_WEAPON_GRENADELAUNCHER)
						bprint(" consumed the grenade of an ");
					else
					if(fDamageType == DAMAGETYPE_WEAPON_SNIPERRIFLE)
						bprint(" was picked off by an ");
					else
						bprint (" was blasted by an ");
				}
				else
				if (attacker.classname == "monster_fish")
					bprint (" was fed to the ");
				else
				if (attacker.classname == "monster_hell_knight")
				{
					// DRESK
					// Additional Death Messages
					if(fDamageType == DAMAGETYPE_MONSTER_KNIGHT_MISSILE)
						bprint (" was energetically-raped by a ");
					else
						bprint (" was gutted by a ");
				}
				else
				if (attacker.classname == "monster_knight")
					bprint (" was slashed by a ");
				else
				if (attacker.classname == "monster_ogre")
				{
					// DRESK
					// Additional Death Messages
					if(fDamageType == DAMAGETYPE_MONSTER_OGRE_MISSILE)
						bprint (" ate the pineapple of an ");
					else
					if(fDamageType == DAMAGETYPE_WEAPON_MULTIGRENADE)
						bprint (" ate from the pineapple tree of an ");
					else
						bprint (" was chainsawwed by an ");
				}
				else
				if (attacker.classname == "monster_oldone")
					bprint (" became one with ");
				else
				if (attacker.classname == "monster_shalrath")
					bprint (" was exploded by a ");
				else
				if (attacker.classname == "monster_shambler")
				{
					// DRESK
					// Additional Death Messages
					if(fDamageType == DAMAGETYPE_MONSTER_SHAMBLER_MELEE)
						bprint (" was smashed by a ");
					else
						bprint (" was electrocuted by a ");
				}
				else
				if (attacker.classname == "monster_tarbaby")
				{
					// DRESK
					// Additional Death Messages
					if(fDamageType == DAMAGETYPE_MONSTER_TARBABY_EXPLOSION)
						bprint (" was caught in the explosion of a ");
					else
						bprint (" was slimed by a ");
				}
				else
				if (attacker.classname == "monster_wizard")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_WIZARD_ALTMISSILE)
						bprint (" ate the chest-burster of a ");
					else
						bprint (" was scragged by a ");
				}
				else
				if (attacker.classname == "monster_zombie")
					bprint (" choked on the gibs from a ");
				// DRESK - HIPNOTIC SUPPORT
				else
				if (attacker.classname == "monster_gremlin")
					bprint (" was outsmarted by a ");
				else
				if (attacker.classname == "monster_scourge")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_SCOURGE_TAILMELEE)
						bprint (" was stung by a ");
					else
						bprint (" was nailed by a ");
				}
				else
				if (attacker.classname == "monster_armagon")
					bprint (" was outgunned by ");
				else
				if (attacker.classname == "trap_spike_mine")
					bprint (" was blasted by a ");
				// DRESK - ROGUE SUPPORT
				else
				if(attacker.classname == "monster_eel")
					bprint (" was electrified by an ");
				else
				// DRESK
				// Check Wrath Damagetypes in case it was removed
				if(fDamageType == DAMAGETYPE_MONSTER_WRATH_MISSILE || fDamageType == DAMAGETYPE_MONSTER_WRATH_DEATHEXPLOSION)
				// if (attacker.classname == "monster_wrath")
					bprint (" was disintegrated by a ");
				else
				if (attacker.classname == "monster_super_wrath")
					bprint (" was obliterated by an ");
				else
				if (attacker.classname == "monster_sword")
					bprint (" was slit open by a ");
				else
				if (attacker.classname == "monster_morph")
					bprint (" was crushed by a ");
				else
				if (attacker.classname == "monster_lava_man")
					bprint (" was fried by ");
				else
				if(attacker.classname == "monster_mummy")
					bprint (" was embalmed by a ");
				// KLESHIK MONSTER SUPPORT
				else
				if(attacker.classname == "monster_kleshik_babydragon")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_BABYDRAGON_MISSILE)
						bprint(" was fried by a ");
					else
					if(fDamageType == DAMAGETYPE_MONSTER_BABYDRAGON_MELEE)
					{
						bprint(" had ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his") );
						bprint(" ", SG_GetSexVerbiage(targ.nPlayerModelSex, "organs"), " removed by a ");
					}
				}
				else
				if(attacker.classname == "monster_kleshik_flisker")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_FLISKER_LEAPTOUCH)
						bprint(" was stomped on by a ");
					else
					if(fDamageType == DAMAGETYPE_MONSTER_FLISKER_MELEE)
						bprint(" was chewed to death by a ");
				}
				else
				if(attacker.classname == "monster_kleshik_firefiend")
				{
					if(fDamageType == DAMAGETYPE_MONSTER_FIREFIEND_MISSILE)
						bprint(" sucked on the fireball from a ");
					else
					if(fDamageType == DAMAGETYPE_MONSTER_FIREFIEND_MELEE)
					bprint(" was slashed up by a ");
				}
				// TRAVAIL SUPPORT
				#ifdef COMPILE_MODSUPPORT_TRAVAIL
				else
				if(attacker.classname == "monster_ubs")
					bprint (" was put down by the ");
				else
				if(attacker.classname == "monster_spider")
					bprint (" had ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " throat punctured by a ");
				else
				if(attacker.classname == "monster_juggernaut")
					bprint (" became the bitch of a ");
				#endif
				// DRESK
				// Unknown Monster?
				else
					bprint (" was killed by a ");
					
				// Print Monster Display Name
				bprint("^1");
				bprint(attacker.strMonsterDisplayName);
				bprint("\n");

				return;
			}
			
			// DRESK
			// Support Falling Death
			if(fDamageType == DAMAGETYPE_MISC_FALLING)
			{
				targ.deathtype = "";
				bprint (" ^1fell^7 to ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " death\n");
				return;
			}

			// tricks and traps
			// DRESK
			// Support Exploding Item Box
			if (attacker.classname == "exploding_item_box")
			{ // Exploding Item Box
				fRandom = random();
					
				if(fRandom < 0.25)
					bprint (" exploded whilst ^1seeking treasures within\n");
				else
				if(fRandom < 0.50)
					bprint (" was too close to the ^1exploding item box\n");
				else
					bprint (" blew up all over an ^1item\n");
				return;
			}
			if (attacker.classname == "explo_box")
			{
				bprint (" detonated over an ^1exploding box\n");
				return;
			}
			if (attacker.solid == SOLID_BSP && attacker != world)
			{
				// DRESK
				// Additional Death Messages
				local string strSquishMessage;
				// Generate Squishing Object
				if(fDamageType == DAMAGETYPE_ENVIRONMENT_PLATFORM_CRUSH)
					strSquishMessage = "by a platform";
				else
				if(fDamageType == DAMAGETYPE_ENVIRONMENT_TRAIN_CRUSH)
					strSquishMessage = "by a hostile object";
				else
				if(fDamageType == DAMAGETYPE_ENVIRONMENT_SECRETBLOCKED)
					strSquishMessage = "by a secret door";
				else
				if(fDamageType == DAMAGETYPE_ENVIRONMENT_DOORBLOCKED)
					strSquishMessage = "by a door";
				else
				if(fDamageType == DAMAGETYPE_ENVIRONMENT_ROTATINGDOOR_CRUSH)
					strSquishMessage = "by a rotating door";
				else
					strSquishMessage = "";
					
				bprint (" was ^1crushed^7 ");
				bprint (strSquishMessage);
				bprint("\n");
				// bprint (" was ^1squished\n");
				return;
			}
			// DRESK
			// Support Hurt Trigger Death
			if(attacker.classname == "trigger_hurt")
			{
				bprint(" was ^1killed^7 by a hostile location\n");
				return;
			}
			// DRESK
			// TRAVAIL SUPPORT
			#ifdef COMPILE_MODSUPPORT_TRAVAIL
			if(attacker.classname == "trigger_void")
			{
				bprint(" was ^1lost^7 to the void\n");
				return;
			}
			#endif
			if (attacker.classname == "trap_shooter" || attacker.classname == "trap_spikeshooter")
			{
				bprint (" was ^1spiked\n");
				return;
			}
			if (attacker.classname == "fireball")
			{
				bprint (" ate a ^1lavaball\n");
				return;
			}
			if (attacker.classname == "trigger_changelevel")
			{
				bprint (" tried to leave\n");
				return;
			}
			// DRESK - ROGUE SUPPORT
			if (attacker.classname == "ltrail_start" || 
				attacker.classname == "ltrail_relay")
			{
				bprint (" rode the ^1lightning\n");
				return;
			}
			if (attacker.classname == "pendulum")
			{
				bprint (" was ^1cleaved^7 in two\n");
				return;
			}
			if (attacker.classname == "buzzsaw")
			{
				bprint (" was ^1sliced^7 to pieces\n");
				return;
			}
			if (attacker.classname == "plasma")
			{
				bprint ( " was turned to ^1plasma\n");
				return;
			}

			// in-water deaths
			rnum = targ.watertype;
			if (rnum == -3)
			{
				if (random() < 0.5)
					bprint (" sleeps with the ^1fishes\n");
				else
					bprint (" sucks it ^1down\n");
				return;
			}
			else if (rnum == -4)
			{
				if (random() < 0.5)
					bprint (" gulped a load of ^1slime\n");
				else
					bprint (" can't exist on ^1slime^7 alone\n");
				return;
			}
			else if (rnum == -5)
			{
				if (targ.health < -15)
				{
					bprint (" burst into ^1flames\n");
					return;
				}
				if (random() < 0.5)
					bprint (" turned into ^1hot slag\n");
				else
					bprint (" visits the ^1Volcano God\n");
				return;
			}

			// fell to their death?
			if (targ.deathtype == "falling")
			{
				targ.deathtype = "";
				bprint (" ^1fell^7 to ", SG_GetSexVerbiage(targ.nPlayerModelSex, "his"), " death\n");
				return;
			}

			// hell if I know; he's just dead!!!
			bprint (" died\n");
		}
	}
}