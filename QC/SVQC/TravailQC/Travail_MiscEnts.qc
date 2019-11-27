// DRESK
// Travail Misc. Entities

// Definitions

// Fields

// Functions
void Travail_fireball_use()
{ // Travail Support
	if (self.nextthink == 0)
		self.nextthink = time + 0.5;
	else
		remove(self);
}
void Travail_GibFountain_Touch()
{
	if(self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
		self.think = SUB_Remove;
		self.nextthink = time + (6 * random()) + 2;
		return;
	}

	if(self.attack_finished < time)
		if( !(self.delay == 1) )
			if( pointcontents(self.origin) > -3)
			{
				sound (self, CHAN_AUTO, "gibfnt/gf_plop.wav", 1, ATTN_NORM);   //bounce sound
				self.attack_finished = time + 0.3;
			}
}
void Travail_GibFountain_TossGibs()
{
	local entity	gib1, gib2, ghead;

	gib1 = spawn();
	gib1.solid = SOLID_TRIGGER;
	gib1.velocity = '0 0 1000';
	gib1.velocity_x = (random() * 100) - 50;
	gib1.velocity_y = (random() * 100) - 50;
	gib1.velocity_z = self.speed + (random() * 200);
	gib1.classname = "fireball";
	gib1.movetype = MOVETYPE_BOUNCE;
	gib1.avelocity_x = random() * 200;
	gib1.avelocity_y = random() * 100;
	gib1.avelocity_z = random() * 300;
	setsize (gib1, '0 0 0', '0 0 0');
	setmodel (gib1, "progs/gib2.mdl");
	setorigin (gib1, self.origin);
	gib1.touch = Travail_GibFountain_Touch;

	gib2 = spawn();
	gib2.solid = SOLID_TRIGGER;
	gib2.velocity = '0 0 1000';
	gib2.velocity_x = (random() * 100) - 50;
	gib2.velocity_y = (random() * 100) - 50;
	gib2.velocity_z = self.speed + (random() * 200);
	gib2.classname = "fireball";
	gib2.movetype = MOVETYPE_BOUNCE;
	gib2.avelocity_x = random() * 100;
	gib2.avelocity_y = random() * 200;
	gib2.avelocity_z = random() * 300;
	setsize (gib2, '0 0 0', '0 0 0');
	setmodel (gib2, "progs/gib3.mdl");
	setorigin (gib2, self.origin);
	gib2.touch = Travail_GibFountain_Touch;

	ghead = spawn();
	ghead.solid = SOLID_TRIGGER;
	ghead.velocity = '0 0 1000';
	ghead.velocity_x = (random() * 100) - 50;
	ghead.velocity_y = (random() * 100) - 50;
	ghead.velocity_z = self.speed + (random() * 200);
	ghead.classname = "fireball";
	ghead.movetype = MOVETYPE_BOUNCE;
	ghead.avelocity_x = random() * 300;
	ghead.avelocity_y = random() * 200;
	ghead.avelocity_z = random() * 100;
	setsize (ghead, '0 0 0', '0 0 0');
	setmodel (ghead, "progs/h_player.mdl");
	setorigin (ghead, self.origin);
	ghead.touch = Travail_GibFountain_Touch;

	if( !(self.delay == 1) )
		sound (self, CHAN_AUTO, "gibfnt/gf_sbig.wav", 1, ATTN_NORM);
}
void Travail_GibFountain_Think()
{ // Travail Support
	local float nRandom;
	nRandom = random();
	local entity enGib;
	enGib = spawn();
	enGib.solid = SOLID_TRIGGER;
	enGib.velocity_x = (random() * 100) - 50;
	enGib.velocity_y = (random() * 100) - 50;
	enGib.velocity_z = self.speed + (random() * 200);
	enGib.classname = "gibfountaingib";
	if(nRandom < 0.15)
	{
		setmodel(enGib, "progs/gib1.mdl");
		Travail_GibFountain_TossGibs();
	}
	else
	if(nRandom < 0.45)
	{
		setmodel(enGib, "progs/gib1.mdl");
	}
	else
	if(nRandom < 0.85)
	{
		setmodel(enGib, "progs/gib2.mdl");
	}
	else
	{
		setmodel(enGib, "progs/gib3.mdl");
	}
	enGib.movetype = MOVETYPE_BOUNCE;
	enGib.avelocity = '100 200 300';

	if( !(self.delay == 1) )
	{
		if (random() < 0.5)
			sound (self, CHAN_VOICE, "gibfnt/gf_sprt1.wav", 1, ATTN_NORM);
		else
			sound (self, CHAN_VOICE, "gibfnt/gf_sprt2.wav", 1, ATTN_NORM);
	}
	
	setsize(enGib, '0 0 0', '0 0 0');
	setorigin(enGib, self.origin);
	if( !(enGib.think) )
	{
		enGib.nextthink = time + 6;
		enGib.think = SUB_Remove;
	}
	enGib.touch = Travail_GibFountain_Touch;

	self.nextthink = time + (random() * 5) + 3;
	self.think = Travail_GibFountain_Think;
}
void ambient_lavagurg()
{
	GameModeFeatureDetected_Travail();
	precache_sound ("ambience/lavagurg.wav");
	ambientsound (self.origin, "ambience/lavagurg.wav", 0.5, ATTN_STATIC);
}
void ambient_hevifals()
{
	GameModeFeatureDetected_Travail();
	precache_sound ("ambience/hevifals.wav");
	ambientsound (self.origin, "ambience/hevifals.wav", 0.5, ATTN_STATIC);
}
void ambient_bublfals()
{
	GameModeFeatureDetected_Travail();
	precache_sound ("ambience/bublfals.wav");
	ambientsound (self.origin, "ambience/bublfals.wav", 0.5, ATTN_STATIC);
}
void misc_tree1()
{
	GameModeFeatureDetected_Travail();
	precache_model ("progs/tree1.mdl");
	setmodel (self, "progs/tree1.mdl");
}

void misc_tree2()
{
	GameModeFeatureDetected_Travail();
	precache_model ("progs/tree2.mdl");
	setmodel (self, "progs/tree2.mdl");
}

void misc_tree3()
{
	GameModeFeatureDetected_Travail();
	precache_model ("progs/tree3.mdl");
	setmodel (self, "progs/tree3.mdl");
}

void misc_tree4()
{
	GameModeFeatureDetected_Travail();
	precache_model ("progs/tree4.mdl");
	setmodel (self, "progs/tree4.mdl");
}
