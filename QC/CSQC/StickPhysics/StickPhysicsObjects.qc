// DRESK
// StickPhysics Objects

entity Ragdoll_ThrowCasing(vector org1, vector vel1, vector org2, vector vel2, string modelname, float fScale, float tTime)
{
	precache_model(modelname);
	local entity r, p1, p2, s;
	r = Ragdoll_Spawn(tTime, self);
	p1 = Ragdoll_AddParticle(r, org1, vel1, '-1 -1 -1', '1 1 1', 1, 6, 1.65, 0.65);
	p2 = Ragdoll_AddParticle(r, org2, vel2, '-1 -1 -1', '1 1 1', 1, 6, 1.65, 0.65);
	s = Ragdoll_AddStick(r, p1, p2, world, modelname);
	s.solid = SOLID_CORPSE;
	s.scale = fScale;
	setsize(s, '-3 -3 -1', '3 3 1');
	#ifdef QC_CLIENTSIDE
	s.drawmask = MASK_NORMAL;
	#endif
	return r;
};