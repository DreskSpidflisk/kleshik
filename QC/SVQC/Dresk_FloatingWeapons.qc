// DRESK - Floating Weapons
// Provides functions and support for the Client Floating Weapons

// Field Definitions
.entity		enFloatingWeapon;

void CheckFloatingWeapon(entity enPlayer)
{ // Check Floating Weapon
	local float nDisplay;
		nDisplay = cvar(CVAR_ITEM_DISPLAYFLOATINGWEAPONABOVEPLAYER);
	if(nDisplay && !deathmatch)
	{ // Display Floating Weapon
		local string strWeapon;
			strWeapon = "";
		
		if(enPlayer.deadflag)
			strWeapon = "";
		else
			strWeapon = enPlayer.enCurrentWeaponEntity.strWeaponEntity_ExternalWeaponModel;
				
		if(strWeapon != "")
		{ // Valid Weapon
			if(!enPlayer.enFloatingWeapon)
			{ // Spawn Floating Weapon
				// bprint("Player Model : ", enPlayer.model, ", Mins : ", vtos(enPlayer.mins), ", Maxs : ", vtos(enPlayer.maxs), "\n");
				enPlayer.enFloatingWeapon = spawn();
				enPlayer.enFloatingWeapon.scale = 0.6;
				enPlayer.enFloatingWeapon.alpha = 0.4;
				enPlayer.enFloatingWeapon.effects = EF_FULLBRIGHT | EF_NOMODELFLAGS;
				// setorigin(enPlayer.enFloatingWeapon, '-3 0 0' + enPlayer.maxs_z * '0 0 0.5');
				setorigin(enPlayer.enFloatingWeapon, '0 0 15');
				enPlayer.enFloatingWeapon.angles = '0 90 0';
				// Assign Attachment
				setattachment(enPlayer.enFloatingWeapon, enPlayer, "");
			}
			// Assign Model
			setmodel(enPlayer.enFloatingWeapon, strWeapon);
			// Remove No Draw Effect
			if(enPlayer.enFloatingWeapon.effects & EF_NODRAW)
				enPlayer.enFloatingWeapon.effects = enPlayer.enFloatingWeapon.effects - (enPlayer.enFloatingWeapon.effects & EF_NODRAW);
		}
		else
		if(enPlayer.enFloatingWeapon)
			// Disable Drawing (Network Send) of Weapon
			enPlayer.enFloatingWeapon.effects = enPlayer.enFloatingWeapon.effects | EF_NODRAW;
	}
}