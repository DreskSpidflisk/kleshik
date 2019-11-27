// Definitions
#define etof(a)														num_for_edict(a)

// AutoCVars
#define SG_AUTOCVAR(cvar) autocvar_##cvar

#define SG_CONCAT(x, y) x ## y
#define SG_AUTOCVAR2(cvar) SG_CONCAT(autocvar_, cvar)
#define SG_AUTOCVAR_INIT(cvar) SG_CONCAT(autocvar_, cvar)

// Misc. Functions
float SG_MathModulus(float a, float b)
{ // Math Modulus Operation
	return (a - (floor(a / b) * b) );
}

void SG_CheckEmptyCustomCVar(string strCVar, string strDefaultValue)
{ // Check Empty Custom CVar
	local string strCVarValue;
	local string strCommand;
	
	// Acquire CVar
	strCVarValue = cvar_string(strCVar);
	
	if(strCVarValue == "")
	{ // Blank CVar; Fill Value
		// Generate String
		// Assign Command for Dedicated Servers
		strCommand = strcat("set ", strCVar, " \"", strDefaultValue, "\"\n");
		// Execute Command
		localcmd(strCommand);
		// Assign Command for Clients
		strCommand = strcat("seta ", strCVar, " \"", strDefaultValue, "\"\n");
		// Execute Command
		localcmd(strCommand);
	}
}
string SG_GetSkillNameFromSkillNum(float nSkillNum)
{ // Return Skill Name
	local string strReturn;
	
	switch(nSkillNum)
	{
		case 0:
			strReturn = "Easy";
			break;
		case 1:
			strReturn = "Normal";
			break;
		case 2:
			strReturn = "Hard";
			break;
		case 3:
			strReturn = "Nightmare";
			break;
		default:
			strReturn = "Unknown Skill";
			break;
	}
	return strReturn;
}
string SG_GetFormattedTimeStringZoned(float tTime)
{ // Return Formatted Time
	// Acquire Int Version of Time
	local float nTime;
		nTime = rint(tTime);
		
	local string strTime;
	// Calculate Minutes
	local float nMinutes;
		nMinutes = floor(nTime / 60);
		
	// Append Minutes to String
	/*
	if(nMinutes < 10)
		// Append Additional 0
		strTime = strcat("0", ftos(nMinutes) );
	else
	*/
		strTime = ftos(nMinutes);
	// Append :
	strTime = strcat(strTime, ":");
	
	// Calculate Seconds
	local float nSeconds;
		nSeconds = SG_MathModulus(nTime, 60);
	// Append Seconds to String
	if(nSeconds < 10)
		// Append Additional 0
		strTime = strcat(strTime, "0", ftos(nSeconds) );
	else
		strTime = strcat(strTime, ftos(nSeconds) );
	
	// Zone String
	strTime = strzone(strTime);
	
	// Return String
	return strTime;
}
string SG_GetFormattedTimeStringUnZoned(float tTime)
{ // Return Formatted Time
	// Acquire Int Version of Time
	local float nTime;
		nTime = rint(tTime);
		
	local string strTime;
	// Calculate Minutes
	local float nMinutes;
		nMinutes = floor(nTime / 60);
		
	// Append Minutes to String
	/*
	if(nMinutes < 10)
		// Append Additional 0
		strTime = strcat("0", ftos(nMinutes) );
	else
	*/
		strTime = ftos(nMinutes);
	// Append :
	strTime = strcat(strTime, ":");
	
	// Calculate Seconds
	local float nSeconds;
		nSeconds = SG_MathModulus(nTime, 60);
	// Append Seconds to String
	if(nSeconds < 10)
		// Append Additional 0
		strTime = strcat(strTime, "0", ftos(nSeconds) );
	else
		strTime = strcat(strTime, ftos(nSeconds) );
	
	// Return String
	return strTime;
}
string SG_GetSpacedStringZoned(string strInput, float nLength, float bCountColors)
{ // Return Spaced String Zoned
	local string strOutput;
		strOutput = strInput;
	local float nCnt;
	// Acquire Length of Input String
	local float nStringLength;
		if(bCountColors)
			nStringLength = strlen(strInput);
		else
			nStringLength = strlennocol(strInput);
	// Calculate Spaces Needed
	local float nSpacesNeeded;
		nSpacesNeeded = nLength - nStringLength;
		
	for(nCnt = 0; nCnt < nSpacesNeeded; nCnt++)
	{ // Append Spaces
		strOutput = strcat(strOutput, " ");
	}
	
	// Zone String
	strOutput = strzone(strOutput);
	
	// Return String
	return strOutput;
}
float SG_crandom()
{
	return 2*(random() - 0.5);
}