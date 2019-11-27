// DRESK
// View Draw Stationary Model

// Definitions

// Constants

// Fields
entity	g_enViewStationaryModel;
float	g_fViewStationaryModel_Alpha;
float	g_fViewStationaryModel_Distance;
string	g_strViewStationaryModel_PreviousModel;
string	g_strViewStationaryModel_Model;

void UpdateViewDrawStationaryModel()
{
	vector vOrigin;
	vector vDestination;
	
	if(!g_enViewStationaryModel)
	{ // Spawn Model
		g_enViewStationaryModel = spawn();
		// Set Render Flags
		g_enViewStationaryModel.drawmask = MASK_NORMAL;
		
		// Assign Default Alpha
		g_fViewStationaryModel_Alpha = 1;
		// Assign Default Model
		g_strViewStationaryModel_Model = "Models/Weapons/FlechetteCannon/ExternalWeapon.mdl";
		// Assign Default Distance
		g_fViewStationaryModel_Distance = 25;
		// g_enViewStationaryModel.renderflags = RF_VIEWMODEL;
		g_enViewStationaryModel.effects = EF_NOSHADOW;
	}
	// Update Model
	if(g_strViewStationaryModel_Model != g_strViewStationaryModel_PreviousModel)
	{ // New Model
		setmodel(g_enViewStationaryModel, g_strViewStationaryModel_Model);
	}
	// Update Alpha
	g_enViewStationaryModel.alpha = g_fViewStationaryModel_Alpha;
	
	// Get Vectors of Local Inputs
	makevectors(input_angles);
	// Acquire Origin
	vOrigin = pmove_org;
	// Calculate Destination
	vDestination = vOrigin + (v_forward * g_fViewStationaryModel_Distance);
	// Update Origin
	traceline(vOrigin, vDestination, FALSE, self);
	setorigin(g_enViewStationaryModel, trace_endpos);
}