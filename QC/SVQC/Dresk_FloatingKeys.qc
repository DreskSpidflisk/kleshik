// DRESK - Floating Keys
// Provides functions and support for the Client Floating Keys

// Field Definitions
.entity		enFloatingKey1;
.entity		enFloatingKey2;

void SetFloatingKeyModel(entity enKey, float fKeyNum)
{ // Set Floating Key Model
	// NOTE : Logic copied from items.qc
	if(world.worldtype == 0)
	{
		if(fKeyNum == 1)
			setmodel (enKey, "progs/w_s_key.mdl");
		else
			setmodel (enKey, "progs/w_g_key.mdl");
			
	}
	else
	if(world.worldtype == 1)
	{
		if(fKeyNum == 1)
			setmodel (enKey, "progs/m_s_key.mdl");
		else
			setmodel (enKey, "progs/m_g_key.mdl");
	}
	else
	if (world.worldtype == 2)
	{
		if(fKeyNum == 1)
			setmodel (enKey, "progs/b_s_key.mdl");
		else
			setmodel (enKey, "progs/b_g_key.mdl");
	}
}
entity SpawnFloatingKey(entity enPlayer, float fKeyNum, vector vOffset)
{ // Spawn Floating Key
	// bprint("Player Model : ", enPlayer.model, ", Mins : ", vtos(enPlayer.mins), ", Maxs : ", vtos(enPlayer.maxs), "\n");
	local entity enSpawn;
	enSpawn = spawn();
	SetFloatingKeyModel(enSpawn, fKeyNum);
	enSpawn.scale = 0.4;
	enSpawn.alpha = 0.3;
	enSpawn.effects = EF_FULLBRIGHT | EF_NOMODELFLAGS;

	setorigin(enSpawn, vOffset + enPlayer.maxs_z * '0 0 1');
	enSpawn.angles = '0 0 0';
	// Assign Attachment
	setattachment(enSpawn, enPlayer, "");
	
	return enSpawn;
}
void CheckFloatingKeys(entity enPlayer)
{ // Check Floating Keys
	// UPDATED NOTE: Function no longer ran every frame.  Ran only when necessary now.
	// NOTE: Function is ran EVERY frame.  Currently Removing CVar check for performance reasons.
	if( cvar(CVAR_ITEM_DISPLAYFLOATINGKEYSABOVEPLAYER) )
	{ // Floating Keys Enabled
		local vector vOffset;
		if(enPlayer.nCSQCStat_Keys & KEY_SILVER && enPlayer.deadflag == DEAD_NO)
		{ // Key 1 Necessary; Check
			if(!enPlayer.enFloatingKey1)
			{ // Key Spawn Necessary
				// Generate Offset
				vOffset_x = -3;
				vOffset_y = 10;
				vOffset_z = -8;
				// Spawn Key
				enPlayer.enFloatingKey1 = SpawnFloatingKey(enPlayer, 1, vOffset);
			}
			else
				// Remove No Draw Effect
				enPlayer.enFloatingKey1.effects = enPlayer.enFloatingKey1.effects - (enPlayer.enFloatingKey1.effects & EF_NODRAW);
		}
		else
		if(enPlayer.enFloatingKey1)
		{ // Remove Key
			// bprint("Removing Key 1\n");
			// setattachment(enPlayer.enFloatingKey1, world, "");
			
			// Assign No Draw
			enPlayer.enFloatingKey1.effects = enPlayer.enFloatingKey1.effects | EF_NODRAW;
			
			// remove(enPlayer.enFloatingKey1);
			// enPlayer.enFloatingKey1 = world;
		}
			
		if(enPlayer.nCSQCStat_Keys & KEY_GOLD && enPlayer.deadflag == DEAD_NO)
		{ // Key 2 Necessary; Check
			if(!enPlayer.enFloatingKey2)
			{ // Key Spawn Necessary
				// Generate Offset
				vOffset_x = -3;
				vOffset_y = -10;
				vOffset_z = -8;
				// Spawn Key
				enPlayer.enFloatingKey2 = SpawnFloatingKey(enPlayer, 2, vOffset);
			}
			else
				// Remove No Draw Effect
				enPlayer.enFloatingKey2.effects = enPlayer.enFloatingKey2.effects - (enPlayer.enFloatingKey2.effects & EF_NODRAW);
		}
		else
		if(enPlayer.enFloatingKey2)
		{ // Remove Key
			// bprint("Removing Key 2\n");
			// setattachment(enPlayer.enFloatingKey2, world, "");
			
			// Assign No Draw
			enPlayer.enFloatingKey2.effects = enPlayer.enFloatingKey2.effects | EF_NODRAW;
			
			// remove(enPlayer.enFloatingKey2);
			// enPlayer.enFloatingKey2 = world;
		}
	}
}