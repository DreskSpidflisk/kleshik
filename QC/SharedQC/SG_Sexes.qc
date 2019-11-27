// Shared Game Sex Information

// Sex Types
#define SEX_MALE						0
#define SEX_FEMALE						1
#define SEX_ROBOT						2
#define SEX_OTHER						3
#define SEX_MAX							3

// Fields

// Functions
string SG_GetSexVerbiage(float nSex, string strBaseMaleString)
{ // Return Player Model Sex Verbiage
	local string strReturn;
		
	switch(strBaseMaleString)
	{ // Parse Main String
		case "his":
			switch(nSex)
			{
				case SEX_MALE:
					strReturn = "his";
					break;
				case SEX_FEMALE:
					strReturn = "her";
					break;
				case SEX_ROBOT:
				case SEX_OTHER:
					strReturn = "its";
					break;
			}
			break;
		case "injuries":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "injuries";
					break;
				case SEX_ROBOT:
					strReturn = "damages";
					break;
			}
			break;
		case "heartbeat":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "heartbeat";
					break;
				case SEX_ROBOT:
					strReturn = "CPU cycle";
					break;
			}
			break;
		case "gibbed":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "gibbed";
					break;
				case SEX_ROBOT:
					strReturn = "exploded";
					break;
			}
		case "organs":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "organs";
					break;
				case SEX_ROBOT:
					strReturn = "circuitry";
					break;
			}
			break;
		case "sweat":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "sweat";
					break;
				case SEX_ROBOT:
					strReturn = "oil";
					break;
			}
			break;
		case "skull":
			switch(nSex)
			{
				case SEX_MALE:
				case SEX_FEMALE:
				case SEX_OTHER:
					strReturn = "skull";
					break;
				case SEX_ROBOT:
					strReturn = "motherboard";
					break;
			}
			break;
		case "himself":
			switch(nSex)
			{
				case SEX_MALE:
					strReturn = "himself";
					break;
				case SEX_FEMALE:
					strReturn = "herself";
					break;
				case SEX_ROBOT:
				case SEX_OTHER:
					strReturn = "itself";
					break;
			}
			break;
		case "he":
			switch(nSex)
			{
				case SEX_MALE:
					strReturn = "he";
					break;
				case SEX_FEMALE:
					strReturn = "she";
					break;
				case SEX_ROBOT:
				case SEX_OTHER:
					strReturn = "it";
					break;
			}
			break;
	}
	
	// Return Verbiage
	return strReturn;
}
string SG_GetSexStringFromSexID(float nSex)
{ // Return Sex String from Sex ID
	local string strReturn;
	switch(nSex)
	{
		case SEX_MALE:
			strReturn = "Male";
			break;
		case SEX_FEMALE:
			strReturn = "Female";
			break;
		case SEX_ROBOT:
			strReturn = "Robot";
			break;
		default:
			strReturn = "Other";
			break;
	}
	return strReturn;
}
float SG_GetSexIDFromAbbreviatedSexString(string strSex)
{ // Return Sex ID from Abbreviated String Sex
	local float nReturn;
	switch(strSex)
	{
		case "m":
			nReturn = SEX_MALE;
			break;
		case "f":
			nReturn = SEX_FEMALE;
			break;
		case "r":
			nReturn = SEX_ROBOT;
			break;
		default:
			nReturn = SEX_OTHER;
			break;
	}
	
	return nReturn;
}
string SG_GetAbbreviatedSexStringFromSexID(float nSex)
{ // Return Abbreviated Sex String from Sex ID
	local string strReturn;
	switch(nSex)
	{
		case SEX_MALE:
			strReturn = "m";
			break;
		case SEX_FEMALE:
			strReturn = "f";
			break;
		case SEX_ROBOT:
			strReturn = "r";
			break;
		default:
			strReturn = "o";
			break;
	}
	return strReturn;
}