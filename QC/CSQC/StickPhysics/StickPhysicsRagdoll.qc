// DRESK
// Stick Physics Ragdoll Functions

void Ragdoll_KnockedLooseFunc()
{
	// clear parent's rest state so it will start moving again
	self.owner.dmg = FALSE;
};
entity Ragdoll_AddParticle(entity ragdoll, vector org, vector vel, vector m1, vector m2, float mas, float forcescal, float bouncefactor, float frictionfactor)
{
	local entity e;
	e = spawn();
	e.classname = "ragdoll_particle";
	e.owner = ragdoll;
	e.ragdoll_next = e.owner.ragdoll_particlelist;
	e.owner.ragdoll_particlelist = e;
	e.ragdoll_mass = mas;
	e.ragdoll_inversemass = 1.0 / mas;
	e.ragdoll_bounce = bouncefactor;
	e.ragdoll_friction = frictionfactor;
	e.forcescale = forcescal;
	#ifdef QC_SERVERSIDE
	e.takedamage = DAMAGE_YES;
	e.th_die = __NULL__;
	e.th_gib = __NULL__;
	e.th_pain = __NULL__;
	#endif
	e.knockedloosefunc = Ragdoll_KnockedLooseFunc;
	e.solid = SOLID_TRIGGER;//BBOX;
	#ifdef QC_SERVERSIDE
	e.movetype = MOVETYPE_NONE;
	#endif
	e.velocity = vel;
	setorigin(e, org);
//	setmodel(e, "progs/s_bubble.spr"); // debugging
	setsize(e, m1, m2);
	return e;
};
void Ragdoll_UpdateStickModels()
{
	local entity stick;
	local vector org1, org2, org3, offset;
	stick = self.ragdoll_sticklist;
	while (stick)
	{
		if (stick.modelindex)
		{
			org1 = stick.ragdoll_p1.origin;
			org2 = stick.ragdoll_p2.origin;
			setorigin(stick, (org1 + org2) * 0.5);
			if (stick.ragdoll_p3)
			{
				stick.angles = vectoangles(org2 - org1);
				org3 = stick.ragdoll_p3.origin;
				makevectors(stick.angles_x * '-1 0 0' + stick.angles_y * '0 1 0');
				offset = org3 - org1;
				stick.angles_z = vectoyaw((offset * v_right) * '-1 0 0' + (offset * v_up) * '0 1 0');
				//stick.angles = vectoangles2(org2 - org1, org3 - org1);
				makevectors(stick.angles_x * '-1 0 0' + stick.angles_y * '0 1 0' + stick.angles_z * '0 0 1');
				stick.angles = vectoangles2(v_forward, v_up);
				vectoangles2('0 0 1', '231 8943 0');
				vectoangles('0 0 1');
				offset = randomvec() * 360;
				offset_x = 90;
				makevectors(offset);
				vectoangles2(v_forward, v_up);
				vectoangles(v_forward);
			}
			else
				stick.angles = vectoangles(org2 - org1);
		}
		stick = stick.ragdoll_next;
	}
}
float Ragdoll_Move(float ftime, float restlimit)
{
	local entity part;
	local float t, bump, resting;
	local vector force;
	local vector vMaxParticleVelocity;
	local vector vLastParticleOrigin;
	resting = TRUE;
	part = self.ragdoll_particlelist;
	while (part)
	{
		// move particle repeatedly until the time slice is used up
		// (deals with bounces)
		part.oldorigin = part.origin;
		t = ftime;
		bump = 0;
		while (bump < 16)
		{
			bump = bump + 1;
			// check if there was an impact
			tracebox(part.origin, part.mins, part.maxs, part.origin + part.velocity * t, MOVE_NORMAL, self);
			if (trace_fraction == 1)
			{
				// ignore successful moves over short distances after the
				// first bump, as they tend to destabilize the constraints
				// no impact, update origin to the new position
				setorigin(part, trace_endpos);
				// we're done!
				break;
			}
			// impact detected
			if (part.velocity * trace_plane_normal < 0)
			{
				// DRESK
				// Update Max Particle Velocity
				if( vlen(part.velocity) > vlen(vMaxParticleVelocity) )
					vMaxParticleVelocity = part.velocity;
				// reflect the velocity off the plane (bounce)
				// BUG: ragdoll_bounce occurs in addition to the natural spring back of the sticks when flattened against a surface...
				if (trace_ent.classname == "ragdoll_particle")
				{
					// hack to make particles behave sort of spherically
					trace_plane_normal = normalize(part.origin - trace_ent.origin);
					// calculate impulse (impact force)
					force = trace_plane_normal * (trace_plane_normal * (part.velocity * part.ragdoll_mass - trace_ent.velocity * trace_ent.ragdoll_mass));
					// apply to both particles (in opposite directions)
					part.velocity = part.velocity - force * part.ragdoll_inversemass * part.ragdoll_bounce;
					trace_ent.velocity = part.velocity + force * part.ragdoll_inversemass * part.ragdoll_bounce;
				}
				else
					part.velocity = part.velocity - (trace_plane_normal * (trace_plane_normal * part.velocity)) * part.ragdoll_bounce;
				// never come to rest on a pusher
				if (trace_ent != world)
					resting = FALSE;
			}
			// reduce remaining time
			t = t * (1 - trace_fraction);
			// if at least a little progress was made, update origin
			// don't accept very short moves as they tend to cause jitter
			if (trace_fraction >= 0.0001)
			{
				// update origin to the new position
				setorigin(part, trace_endpos);
			}
		}
		if (vlen(part.origin - part.oldorigin) >= restlimit)
			resting = FALSE;
		// lock down this particle now that it has moved
		//part.ragdoll_lockdown = TRUE;
		// apply constraints again, honoring this newly locked particle
		//Ragdoll_ApplyConstraints(ftime);
		// go to the next particle
		// DRESK
		// Update Last Particle Origin
		vLastParticleOrigin = part.origin;
		
		part = part.ragdoll_next;
	}
	// DRESK
	// Call Impact Function
	if(self.fpImpactFunction)
		self.fpImpactFunction(vMaxParticleVelocity, vLastParticleOrigin);
	// if not significantly disturbed, reset the whole system back to the old
	// values, this hides minor jitter when resting
	if (resting)
	{
		part = self.ragdoll_particlelist;
		while (part)
		{
			setorigin(part, part.oldorigin);
			part = part.ragdoll_next;
		}
	}
	return resting;
}
void Ragdoll_ApplyFriction(float ftime)
{
	local entity part;
	local float f;
	local float applied;
	local vector o;
	// counteract some units of velocity based on friction for any particles
	// that are currently held against a surface by acceleration
	applied = FALSE;
	part = self.ragdoll_particlelist;
	while (part)
	{
		o = part.origin + '0 0 1' * part.mins_z;
		traceline(o, o - '0 0 1', MOVE_NORMAL, self);
		if (trace_fraction < 1)
		{
/*
			f = bound(0, 1 - part.ragdoll_friction * 0.1, 1);
			if (f > 0)
				part.velocity = part.velocity * f;
*/
			f = bound(0, vlen(part.velocity), part.ragdoll_friction * 300 * ftime);
			if (f > 0)
				part.velocity = part.velocity - normalize(part.velocity) * f;
			applied = TRUE;
		}
		// go to the next particle
		part = part.ragdoll_next;
	}

	// damping does not seem to help with unstable systems and serves no other real purpose
/*
	// if friction is applied, we also apply a damping effect to cause the
	// entire system to lose energy
	if (applied)
	{
		part = self.ragdoll_particlelist;
		while (part)
		{
			part.velocity = part.velocity * (1 - ftime);
			// go to the next particle
			part = part.ragdoll_next;
		}
	}
*/
};
void Ragdoll_ApplyConstraints(float ftime, float iterations)
{
	local float iftime, iter;
	local entity stick, p1, p2, part;
	local vector offset, diff;
	iftime = 1 / ftime;
	part = self.ragdoll_particlelist;
	while (part)
	{
		part.dest = part.origin + part.velocity * ftime;
		part = part.ragdoll_next;
	}
	iter = 0;
	while (iter < iterations)
	{
		iter = iter + 1;
		stick = self.ragdoll_sticklist;
		while (stick)
		{
			p1 = stick.ragdoll_p1;
			p2 = stick.ragdoll_p2;
			if (p1.ragdoll_lockdown)
			{
				if (!p2.ragdoll_lockdown)
				{
					diff = p2.dest - p1.dest;
					offset = normalize(diff) * stick.ragdoll_preferredlength - diff;
					p2.dest = p2.dest + offset;
				}
			}
			else if (p2.ragdoll_lockdown)
			{
				diff = p2.dest - p1.dest;
				offset = normalize(diff) * stick.ragdoll_preferredlength - diff;
				p1.dest = p1.dest - offset;
			}
			else
			{
				diff = p2.dest - p1.dest;
				offset = (normalize(diff) * stick.ragdoll_preferredlength - diff) * 0.5;
				p1.dest = p1.dest - offset;
				p2.dest = p2.dest + offset;
			}
			stick = stick.ragdoll_next;
		}
	}
	part = self.ragdoll_particlelist;
	while (part)
	{
		part.velocity = (part.dest - part.origin) * iftime;
		part = part.ragdoll_next;
	}
}
void Ragdoll_ApplyAcceleration(float fscale)
{
	local entity part;
	local float grav;
	grav = sv_gravity * fscale;
	part = self.ragdoll_particlelist;
	while (part)
	{
		part.velocity_z = part.velocity_z - grav;
		// go to the next particle
		part = part.ragdoll_next;
	}
}
void Ragdoll_ClearLockdownFlags()
{
	local entity part;
	part = self.ragdoll_particlelist;
	while (part)
	{
		part.ragdoll_lockdown = FALSE;
		// go to the next particle
		part = part.ragdoll_next;
	}
}
void Ragdoll_Remove(entity ragdoll)
{
	local entity e, next;
	e = ragdoll.ragdoll_particlelist;
	while (e)
	{
		next = e.ragdoll_next;
		remove(e);
		e = next;
	}
	e = ragdoll.ragdoll_sticklist;
	while (e)
	{
		next = e.ragdoll_next;
		remove(e);
		e = next;
	}
	remove(ragdoll);
};
void Ragdoll_Think()
{
	local float ftime;
	if (time >= self.lefty)
	{
		Ragdoll_Remove(self);
		return;
	}

	self.nextthink = time;

	while (self.ltime < time)
	{
		ftime = bound(1.0 / 1024.0, time - self.ltime, 1.0 / 128.0);
		self.ltime = self.ltime + ftime;
		if (self.dmg)
			continue;
		// prepare for an update
		// basically, we clear the lockdown flags, then apply impulses and
		// accelerations, then we constrain all the particles so that their
		// future position at the end of the frame is sensible
		// then we move each particle in turn and lock down its position,
		// altering all other particles to conform
		//
		// this method of impulse and acceleration is what I call half-step
		// velocity verlet integration, which applies half the acceleration
		// before the move and half after, giving exactly the same result as
		// standard velocity verlet if no constraints or collisions occur, but
		// allowing constraints and movement to be performed on velocity
		// rather than extrapolated position (which changes often during this)
		Ragdoll_ClearLockdownFlags();
		// add half of the acceleration before constraints and movement
		Ragdoll_ApplyAcceleration(ftime * 0.5);
		// apply constraints to the velocities
		Ragdoll_ApplyConstraints(ftime, 2);
		// apply constraints again
		//Ragdoll_ApplySequentialConstraints(ftime);
		// apply friction to any particles currently stuck to the floor
		Ragdoll_ApplyFriction(ftime);
		// move particles to new proposed locations based on velocity, and
		// deal with any impacts along the way,
		self.dmg = Ragdoll_Move(ftime, ftime * 10);
		// add the other part of the acceleration
		Ragdoll_ApplyAcceleration(ftime * 0.5);
	}
	// update stick models
	Ragdoll_UpdateStickModels();
};

entity Ragdoll_Spawn(float expirationdate, entity own)
{
	local entity e;
	e = spawn();
	e.classname = "ragdoll";
	e.think = Ragdoll_Think;
	e.nextthink = time;
	e.ltime = time;
	e.lefty = time + expirationdate;
	e.owner = own;
	e.fpImpactFunction = __NULL__;
	return e;
};

entity Ragdoll_AddStick(entity ragdoll, entity p1, entity p2, entity p3, string modelname)
{
	local entity e;
	e = spawn();
	e.classname = "ragdoll_stick";
	e.owner = ragdoll;
	e.ragdoll_next = e.owner.ragdoll_sticklist;
	e.owner.ragdoll_sticklist = e;
	e.ragdoll_p1 = p1;
	e.ragdoll_p2 = p2;
	e.ragdoll_p3 = p3;
	e.ragdoll_preferredlength = vlen(p2.origin - p1.origin);
	if (modelname != "")
		setmodel(e, modelname);
	return e;
};