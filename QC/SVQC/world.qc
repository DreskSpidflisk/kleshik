void main()
{
	dprint ("main function\n");
	
// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");

// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");
	
	// DRESK - HIPNOTIC SUPPORT
	/*
	precache_file ("maps/hip1m1.bsp");
	precache_file ("maps/hip1m2.bsp");
	precache_file ("maps/hip1m3.bsp");
	precache_file ("maps/hip1m4.bsp");
	precache_file ("maps/hip1m5.bsp");
	precache_file ("maps/hip2m1.bsp");
	precache_file ("maps/hip2m2.bsp");
	precache_file ("maps/hip2m3.bsp");
	precache_file ("maps/hip2m4.bsp");
	precache_file ("maps/hip2m5.bsp");
	precache_file ("maps/hip2m6.bsp");
	precache_file ("maps/hip3m1.bsp");
	precache_file ("maps/hip3m2.bsp");
	precache_file ("maps/hip3m3.bsp");
	precache_file ("maps/hip3m4.bsp");
	precache_file ("maps/hipdm1.bsp");
	precache_file ("maps/hipend.bsp");
	precache_file ("maps/zoo.bsp");
	precache_file ("maps/mark.bsp");
	   */

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};


entity	lastspawn;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
void worldspawn()
{
	lastspawn = world;
	InitBodyQue ();

// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

	// DRESK
	// Check for Invalid Worldtype
	if(world.worldtype < 0 || world.worldtype > 2)
		world.worldtype = 0;
		
	// Prepare Server CVars
	// PrepareServerCVars();
	
	// Prepare Cooperative Shared Ammo Pool
	PrepareCooperativeSharedAmmoPool();
	// Prepare Map Load CVars
	PrepareMapLoadCVars();
	// Prepare Starting Items
	PrepareStartingItems();
	// Prepare Monster Frame System
	PrepareMonsterFrameSystem();
	// Prepare Kleshik Sounds
	PrepareKleshikSounds();
	// Prepare Darkness Light Pulsation Entity
	PrepareDarknessLightPulsationEntity();
	// Prepare "Night and Day" Light Entity
	PrepareNightAndDayLightEntity();
	// Prepare CSQCStats
	PrepareCSQCStats();
	// Prepare HUD Stinger Controllers
	PrepareRandomHUDStingerEntity();
	
	// Prepare Global Weapon Entities
	SG_WeaponEntity_PrepareGlobalWeaponEntities();

// player precaches	
	W_Precache ();			// get weapon precaches

// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches allways needed
	// precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_sound ("items/damage3.wav");

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// ax sounds	
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming
	
	// DRESK - HIPNOTIC SUPPORT
	if(g_bHipnoticEnabled)
	{ // Hipnotic Enabled
		// Precache Sounds
		precache_sound ("misc/flys.wav");
		precache_sound ("misc/shortexp.wav");
		precache_sound ("misc/longexpl.wav");
		
		/*if(g_bHipnoticFootsteps)
		{
			precache_sound ("misc/foot1.wav");
			precache_sound ("misc/foot2.wav");
			precache_sound ("misc/foot3.wav");
			precache_sound ("misc/foot4.wav");
			precache_sound ("misc/foot5.wav");
			precache_sound ("misc/foot6.wav");
			precache_sound ("misc/foot7.wav");
		}*/
		
		// Precache Models
		precache_model ("progs/playham.mdl");
		precache_model ("progs/v_laserg.mdl");
		precache_model ("progs/v_hammer.mdl");
		precache_model ("progs/v_prox.mdl");
		precache_model ("progs/proxbomb.mdl");
		precache_model ("progs/lasrspik.mdl");
		
		// Precache Additional Models
		precache_model ("progs/g_laserg.mdl");
		precache_model ("progs/g_prox.mdl");
		precache_model ("progs/g_hammer.mdl");
		
		// Precache Empathy Shields
		precache_model("progs/empathy.mdl");
		precache_sound("hipitems/empathy.wav");
		precache_sound("hipitems/empathy2.wav");
		precache_sound ("items/suit2.wav");
		
		// Initialize Bullet Holes
		// NOTE: Deferred
		// InitBulletHoles();
		
		// Stop Earthquake
		Hipnotic_StopEarthQuake();
	}
	// DRESK - ROGUE SUPPORT
	if(g_bRogueEnabled)
	{ // Rogue Enabled
		// Precache Sounds
		precache_sound ("enforcer/enfstop.wav");    // shield impact
		precache_sound ("plasma/explode.wav");
		precache_sound ("plasma/flight.wav");
		precache_sound ("shield/hit.wav");
		precache_sound ("belt/use.wav");
		precache_sound ("items/damage2.wav");
		
		// Precache Models
		precache_model ("progs/v_lava.mdl");
		precache_model ("progs/v_lava2.mdl");
		precache_model ("progs/v_multi.mdl");
		precache_model ("progs/v_multi2.mdl");
		precache_model ("progs/mervup.mdl");
		precache_model ("progs/rockup.mdl");
		precache_model ("progs/rockup_d.mdl");
		precache_model ("progs/lspike.mdl");
		precache_model ("progs/shield.mdl");
		precache_model ("progs/p_shield.mdl");
		precache_model ("progs/plasma.mdl");
		precache_model ("progs/v_plasma.mdl");
		
		precache_model ("progs/hook.mdl");
		precache_model ("progs/v_grpple.mdl");
	}

	precache_model ("progs/player.mdl");
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bubble.spr");	// drowning bubbles
	precache_model ("progs/s_explod.spr");	// sprite explosion

	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");
	
	// DRESK
	// Additional External Weapons
	#ifdef WEAPONENTITIES_USEAXEANDSHOTGUNEXTERNALMODELS
	precache_model("progs/g_shotgun.mdl");
	precache_model("progs/g_axe.mdl");
	#endif
	
	// Precache Throwable Flare
	precache_model("Models/Objects/ThrowableFlare/ThrowableFlare.mdl");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing
	
	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");
	
	precache_model ("progs/g_shot.mdl");
	precache_model ("progs/g_nail.mdl");
	precache_model ("progs/g_nail2.mdl");
	precache_model ("progs/g_rock.mdl");
	precache_model ("progs/g_rock2.mdl");
	precache_model ("progs/g_light.mdl");
	precache_model ("progs/invulner.mdl");
	// Precache All Key Models
	precache_model ("progs/w_s_key.mdl");
	precache_model ("progs/m_s_key.mdl");
	precache_model2 ("progs/b_s_key.mdl");
	precache_model ("progs/w_g_key.mdl");
	precache_model ("progs/m_g_key.mdl");
	precache_model2 ("progs/b_g_key.mdl");
	// Precache Additional Sounds
	precache_sound ("buttons/switch04.wav");
	precache_sound ("buttons/switch21.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("boss1/sight1.wav");
	precache_sound2 ("shalrath/pain.wav");
	precache_sound ("items/protect.wav");
	precache_sound ("sound/misc/menu2.wav");
	precache_sound ("misc/secret.wav");
	// Precache Quad Damage Sounds
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	
	// DRESK
	// Precache Exploding Boxes Here
	precache_model ("maps/b_explob.bsp");
	precache_model2 ("maps/b_exbox2.bsp");
	
	// DRESK
	// Global Precaches
	PerformGlobalPrecaches();
	

//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	// DRESK
	// Support Normal Lightmap Brightness
	lightstyle(0, cvar_string(CVAR_WORLD_NORMALLIGHTMAPANIMATION) );
	// lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// DRESK
	// TRAVAIL SUPPORT
	#ifdef COMPILE_MODSUPPORT_TRAVAIL
	if(g_bTravailEnabled)
		lightstyle(12, "m");
	#endif
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");
}

void StartFrame()
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;
	
	// DRESK
	// Check for Previous Skill Change
	if(skill != nPreviousSkill)
		// New Skill; Sync
		CSQCStat_SyncSkill();
	// Update Previous Skill
	nPreviousSkill = skill;
	
	// DRESK
	// Performance Increase
	// Check for Deathmatch
	if(deathmatch)
		CheckRules();
	
	// DRESK
	// Run Monster Frame
	#ifndef MONSTERFRAMESYSTEM_USETHINKENTITY
	MonsterFrame();
	#endif
	
	// DRESK
	// Run GyroPhysics
	if(g_bGyroPhysicsEnabled && (gyro_objectlist_head || gyro_forcelist_head) )
		Gyro_Run();
	
	// DRESK
	// Check World Light Pulsation
	if(g_bWorldLightPulsation_LightPulsationActive)
	{ // Pulsation Active
		if(time == g_tWorldLightPulsation_LightPulsationSoundTime)
		{ // Play Sound
			sound(world, CHAN_AUTO, g_strWorldLightPulsation_LightPulsationSound, 1, ATTN_NONE);
		}
		if(time >= g_tWorldLightPulsation_LightPulsationEndTime)
		{ // Purge Pulsation
			if(g_enNightAndDayLightEntity)
			{ // Night and Day Entity
				lightstyle(0, substring(g_enNightAndDayLightEntity.strNightAndDayLightString, g_enNightAndDayLightEntity.nNightAndDayLightEntityLightLevel, 1) );
			}
			else
			{ // Assign Normal Lightstyle from CVar
				lightstyle(0, cvar_string(CVAR_WORLD_NORMALLIGHTMAPANIMATION) );
			}
			g_bWorldLightPulsation_LightPulsationActive = FALSE;
			// Play Main End Sound
			sound(world, CHAN_AUTO, SOUND_KLESHIK_AMBIENCE_EVENTS_DARKNESSLIGHTPULSATIONEND, 1, ATTN_NONE);
		}
	}
	// Check for Coop Teleport Number of Frames Force Print
	if(g_nPersonalTeleporter_NumFramesForcePrint > 0)
		g_nPersonalTeleporter_NumFramesForcePrint = g_nPersonalTeleporter_NumFramesForcePrint - 1;
	
};