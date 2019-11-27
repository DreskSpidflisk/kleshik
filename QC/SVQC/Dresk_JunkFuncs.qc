// DRESK - JunkFuncs
// Provides junk functions and values to prevent compiler warnings.

void JunkFunction()
{ // Junk Function!
	local entity enJunk;
	
	enJunk.exteriormodeltoclient = world;
	enJunk.glow_color = 0;
	enJunk.glow_trail = 0;
	enJunk.glow_size = 0;
	enJunk.viewmodelforclient = world;
	enJunk.tag_entity = world;
	enJunk.tag_index = 0;
	enJunk.pitch_speed = 0;
	enJunk.clientcolors = 0;
	enJunk.drawonlytoclient = world;
	enJunk.nodrawtoclient = world;
	enJunk.movement = '0 0 0';
	enJunk.viewzoom = 0;
	enJunk.color = '0 0 0';
	enJunk.cursor_active = 0;
	enJunk.cursor_screen = '0 0 0';
	enJunk.cursor_trace_start = '0 0 0';
	enJunk.cursor_trace_endpos = '0 0 0';
	enJunk.pflags = 0;
	enJunk.playermodel = "";
	enJunk.cursor_trace_ent = world;
	enJunk.playerskin = "";
	enJunk.punchvector = '0 0 0';
	enJunk.ping = 0;
	enJunk.buttonchat = 0;
	enJunk.buttonuse = 0;
	enJunk.button3 = 0;
	enJunk.button4 = 0;
	enJunk.button5 = 0;
	enJunk.button6 = 0;
	enJunk.button7 = 0;
	enJunk.button8 = 0;
	
	enJunk.wad = "";
	enJunk.light_lev = 0;
	enJunk.dest = '0 0 0';
	enJunk.waitmax = 0;
	enJunk.distance = 0;
	enJunk.volume = 0;
	enJunk.glowmod = '0 0 0';
	
	enJunk.disableclientprediction = 0;
	enJunk.netaddress = "127.0.0.1";
	enJunk.modelflags = 0;
	trace_dphittexturename = "duh";
	
	enJunk.customizeentityforclient = JunkFunction;
	enJunk.dphitcontentsmask = 0;
	// trace_dphittexturename = "";
	
	trace_dpstartcontents = 0;
	trace_dphitcontents = 0;
	trace_dphitq3surfaceflags = 0;
	
	local float fFloat;
	fFloat = empty_float;
	
	gettaginfo_parent = 0;
	gettaginfo_name = "";
	gettaginfo_offset = '0 0 0';
	gettaginfo_forward = '0 0 0';
	gettaginfo_right = '0 0 0';
	gettaginfo_up = '0 0 0';
	
	enJunk.bouncefactor = 0;
	enJunk.bouncestop = 0;
	
	worldstatus = "";
	enJunk.clientstatus = "";
	
	// HIPNOTIC SUPPORT
	// enJunk.strPlayerSounds = "";
	damage_inflictor = world;
	enJunk.empathy_sound = 0;
	enJunk.last_teleport_time = 0;
	// enJunk.enUnderwaterBubbleEntities = world;
	// enJunk.strAmbientOneShotSound_Sound = "";
}