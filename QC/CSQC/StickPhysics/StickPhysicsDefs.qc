// DRESK
// StickPhysics Definitions

#define sv_gravity 800

.float ragdoll_bounce; // used on particles, recommended 1.2
.float ragdoll_friction; // used on particles, recommended 0.05
.entity ragdoll_next; // next particle/stick in list
.entity ragdoll_particlelist; // first entity in particle list of this body
.entity ragdoll_sticklist; // first entity in stick list of this body
.entity ragdoll_p1; // particle 1 of this stick (start)
.entity ragdoll_p2; // particle 2 of this stick (end)
.entity ragdoll_p3; // particle 3 of this stick (rotation)
.float ragdoll_mass;
.float ragdoll_inversemass;
.float ragdoll_preferredlength; // preferred length of this stick
.float ragdoll_lockdown;

.float	lefty;
.float	ltime;
.float	dmg;
.vector dest;
.float forcescale;
.void() knockedloosefunc;

.void(vector vMaxParticleVelocity, vector vOrigin) fpImpactFunction;