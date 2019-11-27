/* Earthquake QuickC program
   By Jim Dose'  9/13/96
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/
//JIM
float hip_earthquake_time;
float hip_quakeactive;

void Hipnotic_StopEarthQuake()
{
	hip_earthquake_time = 0;
}

void Hipnotic_EarthQuakeTime(float value)
{
	value = value + time;
	if ( value > hip_earthquake_time )
	{
		hip_earthquake_time = value;
	}
}

void Hipnotic_earthquake_prethink()
{
	//   if ( lastearthquake )
	//      {
	//      self.view_ofs_z = self.savedz;
	//      lastearthquake = 0;
	//      }
}

void Hipnotic_earthquake_postthink()
{
	if ( hip_earthquake_time > time )
	{
		if (hip_quakeactive == 0)
		{
			sound (self, CHAN_VOICE, "misc/quake.wav", 1, ATTN_NONE);
			hip_quakeactive = 1;
		}
		//      lastearthquake = 1;
		//      self.savedz = self.view_ofs_z;
		if ( self.flags & FL_ONGROUND )
		{
			//         self.view_ofs_z = self.view_ofs_z - 5 + random() * 10;
			self.velocity = self.velocity + (random() * '0 0 150');
		}
	}
	else
	{
		if (hip_quakeactive == 1)
		{
			sound (self, CHAN_VOICE, "misc/quakeend.wav", 1, ATTN_NONE);
			hip_quakeactive = 0;
		}
	}
}

void Hipnotic_earthquake_use()
{
	Hipnotic_EarthQuakeTime( self.dmg );
}

/*QUAKED func_earthquake (0 0 0.5) (0 0 0) (32 32 32)
Causes an earthquake.  Triggers targets.

"dmg" is the duration of the earthquake.  Default is 0.8 seconds.
*/

void func_earthquake()
{
	// DRESK
	// Game Mode Feature Detection - Hipnotic
	GameModeFeatureDetected_Hipnotic();
	
	hip_quakeactive = 0;
	precache_sound("misc/quake.wav");
	precache_sound("misc/quakeend.wav");
	self.classname = "earthquake";
	self.use = Hipnotic_earthquake_use;
	self.think = SUB_Null;
	
	if ( !self.dmg )
	{
		self.dmg = 0.8;
	}
}
