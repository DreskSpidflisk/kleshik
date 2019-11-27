// Powerups

// Definitions

// Prototypes

// Fields

// Functions
float GetPowerupDuration(float nPowerup)
{ // Return Powerup Duration
	local float tReturn;
	
	switch(nPowerup)
	{
		case POWERUP_INVISIBILITY:
			tReturn = getstatf(STAT_KLESHIK_POWERUPENDTIME_INVISIBILITY);
			break;
		case POWERUP_INVULNERABILITY:
			tReturn = getstatf(STAT_KLESHIK_POWERUPENDTIME_INVULNERABILITY);
			break;
		case POWERUP_BIOSUIT:
			tReturn = getstatf(STAT_KLESHIK_POWERUPENDTIME_BIOSUIT);
			break;
		case POWERUP_QUADDAMAGE:
			tReturn = getstatf(STAT_KLESHIK_POWERUPENDTIME_QUADDAMAGE);
			break;
		case POWERUP_EMPATHYSHIELDS:
			tReturn = getstatf(STAT_KLESHIK_POWERUPENDTIME_EMPATHYSHIELDS);
			break;
	}
	return ceil(tReturn - time);
	// return min(ceil(tReturn - time), 99);
}