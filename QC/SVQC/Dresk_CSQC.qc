// DRESK
// CSQC Functions

// Standard CSQC Requirements
.float()	SendEntity;
.float		Version;

// Fields

// Definitions

// Fields

// Functions
void WeaponCSQCTemporaryEntity(float nEdictNum, float nWeaponID, float nFiringMode, float nExtendedData, vector vOrigin, vector vForward)
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TEMPORARYENTITY_WEAPONFIRE);
	
	// Write Edict Num (Entity Firing Weapon)
	// HACK : If edict is greater than 255, just send 255 since it'll never be a player edict.
	// As of now, we really only care about nEdictNum for playing a sound on the client as ATTN_NONE.
	nEdictNum = min(255, nEdictNum);
	WriteByte(MSG_BROADCAST, nEdictNum);
	// Write Weapon ID
	WriteByte(MSG_BROADCAST, GetByteEncodedWeaponID(nWeaponID) );
	// Write Firing Mode
	WriteByte(MSG_BROADCAST, nFiringMode);
	// Write Extended Data
	WriteByte(MSG_BROADCAST, nExtendedData);
	// Write Origin
	WriteCoord(MSG_BROADCAST, vOrigin_x);
	WriteCoord(MSG_BROADCAST, vOrigin_y);
	WriteCoord(MSG_BROADCAST, vOrigin_z);
	// Write Forward Vector
	local vector vByteForward;
		vByteForward_x = (vForward_x + 1.0) * 127.5;
		vByteForward_y = (vForward_y + 1.0) * 127.5;
		vByteForward_z = (vForward_z + 1.0) * 127.5;
	WriteByte(MSG_BROADCAST, vByteForward_x);
	WriteByte(MSG_BROADCAST, vByteForward_y);
	WriteByte(MSG_BROADCAST, vByteForward_z);
}
void CSQC_DumbFunc()
{
	local entity enDumb;
		enDumb.SendEntity = __NULL__;
		enDumb.Version = 1;
}