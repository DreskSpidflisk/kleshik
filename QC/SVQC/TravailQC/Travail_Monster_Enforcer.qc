// DRESK
// Travail Monster

// Definitions

// Fields

// Functions
float dot(vector a, vector b)
{
	local float doot;
	doot = a_x * b_x + a_y * b_y + a_z * b_z;
	return doot;
}
void Laser2_Touch()
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_MONSTER_ENFORCER_LASER, 9);
	}
	remove(self);
}
void particlethink()
{
	if (self.wait < time)
	{
		remove(self);
		return;
	}
	particle (self.origin, self.oldorigin, 10, 4);
	particle (self.origin, self.oldorigin, 46, 6);
	self.nextthink = time + 0.05;
}

void Travail_Enforcer_FireParticleBeam()
{
	local vector org,mep;
	local	entity missile;
	local vector lead, spot;
	local float go;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	sound (self, CHAN_WEAPON, "enforcer/me_fire1.wav", 1, ATTN_NORM);

	go = vlen(self.enemy.origin - org) / 400;
	mep = self.enemy.velocity;
	mep_z = 0;
	spot = self.enemy.origin + mep * go;

	traceline(org, spot, FALSE, world);
	if (trace_fraction < 0.8 || vlen(self.origin - self.enemy.origin) > 768) {
		// Not a clear lead shot, shoot at player
		spot = self.enemy.origin;
	}
	if ( dot( normalize( spot - org ), v_forward ) < 0.75 ) {
		// Too wacky an angle, just shoot at player
		spot = self.enemy.origin;
	}
	lead = normalize(spot - org);

	missile = spawn ();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_BBOX;
	missile.effects = EF_DIMLIGHT;

	setmodel (missile, "progs/laser2.mdl");
	setorigin (missile, org);
	setsize (missile, '0 0 0', '0 0 0');

	missile.velocity = lead * 500;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = Laser2_Touch;

	missile.wait = time + 5;
	missile.nextthink = time + 0.05;
	missile.think = particlethink;
}

void enforcer_missiletouch()
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner
	if (pointcontents(self.origin) == CONTENT_SKY)	{
		remove(self);
		return;
	}

	damg = 50 + random()*20;
	if (other.health)
	{
		T_Damage (other, self, self.owner, HITLOCATION_SELFORIGIN, DAMAGETYPE_MONSTER_ENFORCER_LASER, damg);
	}
	T_RadiusDamage (self, self.owner, DAMAGETYPE_MONSTER_ENFORCER_LASER, damg, other);
	self.origin = self.origin - 8*normalize(self.velocity);

	te_explosion(self.origin);

	BecomeExplosion ();
}

void Travail_Enforcer_FireRocket()
{
	local vector org;
	local	entity missile;
	local vector mep;
	local vector lead, spot;
	local float go;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	go = vlen(self.enemy.origin - org) / 500;
	mep = self.enemy.velocity;
	mep_z = 0;
	spot = self.enemy.origin + mep * go;

	traceline(org, spot, FALSE, world);
	if (trace_fraction < 0.8)
	{
		//dprint("Not a clear lead shot, shoot at player.\n");
		spot = self.enemy.origin;
	}

	lead = normalize(spot - org);
	traceline(org, spot, FALSE, world);
	if ( trace_fraction < 0.8 ) {
		// Something got in the way, skip it
		menf_ratk9();
		return;
	}

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*12 + '0 0 8');
	missile.velocity = lead * 400;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = enforcer_missiletouch;

	// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
}

void Travail_Enforcer_FireKnight(float offset)
{
	local	vector	offang;
	local	vector	org, vec;
	local	entity	enMissile;

	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 4;

	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 12;

	// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;

	enMissile = launch_spike (org, vec);
	enMissile.classname = "knightspike";
	enMissile.touch = Laser2_Touch;
	setmodel (enMissile, "progs/k_spike.mdl");
	setsize (enMissile, VEC_ORIGIN, VEC_ORIGIN);
	enMissile.velocity = vec*400;
	sound (self, CHAN_WEAPON, "enforcer/ue_fire1.wav", 1, ATTN_NORM);
}
void Travail_Enforcer_Attack()
{
	local float edist;
	edist = vlen(self.enemy.origin - self.origin);

	if(self.nEnforcerType == 4)
	{
		if (random() < edist / 768 - 0.15)
			menf_ratk1();
		else
			menf_zatk1();
	}
	else
	if(self.nEnforcerType == 2)
	{
		if (edist < 768 && random() > 0.5)
			menf_gatk1();
		else
			menf_atk1();
	}
	else
	{
		enf_atk1();
	}
}