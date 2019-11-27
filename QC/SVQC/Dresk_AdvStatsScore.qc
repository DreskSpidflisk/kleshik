// DRESK - Advanced Statistics / Scoring
// Provides definitions and default values for advanced scoring / statistics.

#define ADVANCEDSTATISTIC_PRINT_NAME_LENGTH					25
#define ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH				10

#define ADVANCEDSTATISTIC_TYPE_MONSTER						1
#define ADVANCEDSTATISTIC_TYPE_HEALTHARMORAMMO				2
#define ADVANCEDSTATISTIC_TYPE_WEAPON						3
#define ADVANCEDSTATISTIC_TYPE_POWERUP						4
#define ADVANCEDSTATISTIC_TYPE_OTHER						5

// Field / Global Definitions
float		nGameStatistic_Monster_Total[30];
float		nGameStatistic_Monster_Killed[30];
string		strGameStatistic_Monster_Name[30];

float		nGameStatistic_HealthArmorAmmo_Total[15];
float		nGameStatistic_HealthArmorAmmo_Found[15];
string		strGameStatistic_HealthArmorAmmo_Name[15];

float		nGameStatistic_Weapon_Total[15];
float		nGameStatistic_Weapon_Found[15];
string		strGameStatistic_Weapon_Name[15];

float		nGameStatistic_Powerup_Total[10];
float		nGameStatistic_Powerup_Found[10];
string		strGameStatistic_Powerup_Name[10];

float		nGameStatistic_Other_Total[30];
float		nGameStatistic_Other_Found[30];
string		strGameStatistic_Other_Name[30];

.float		nGameStatistic_ArrayPositionReference;
.float		nGameStatistic_StatisticType;
.float		nGameStatistic_StatisticIncrementCount;

string GetDisplayNameFromEntity(entity enEntity)
{ // Return Display Name from Classname
	local string strReturn;
	
	// Acquire Classname
	local string strClassname;
		strClassname = enEntity.classname;
		
	// Perform Monster Check
	if(enEntity.flags & FL_MONSTER)
		strReturn = enEntity.strMonsterDisplayName;
	else
	// Perform Weapon Check
	if(enEntity.touch == weapon_touch)
		strReturn = SG_GetWeaponNameFromID(enEntity.nCSQCStat_Weapons);
	else
	// Items - Health / Armor
	if(strClassname == "item_health")
		strReturn = "Health";
	else
	if(strClassname == "item_armor1")
		strReturn = "Green Armor";
	else
	if(strClassname == "item_armor2")
		strReturn = "Yellow Armor";
	else
	if(strClassname == "item_armorInv")
		strReturn = "Red Armor";
	else
	// Items - Ammo
	if(strClassname == "item_shells")
		strReturn = "Ammo - Shells";
	else
	if(strClassname == "item_spikes")
		strReturn = "Ammo - Nails";
	else
	if(strClassname == "item_rockets")
		strReturn = "Ammo - Rockets";
	else
	if(strClassname == "item_cells")
		strReturn = "Ammo - Cells";
	else
	// Items - Artifacts
	if(strClassname == "item_artifact_invulnerability")
		strReturn = "Pentagram";
	else
	if(strClassname == "item_artifact_invisibility")
		strReturn = "Ring of Shadows";
	else
	if(strClassname == "item_artifact_envirosuit")
		strReturn = "Biosuit";
	else
	if(strClassname == "item_artifact_super_damage")
		strReturn = "Quad Damage";
	// ******************************************
	// HIPNOTIC SUPPORT
	else
	if(strClassname == "item_artifact_wetsuit")
		strReturn = "Wetsuit";
	else
	if(strClassname == "item_hornofconjuring")
		strReturn = "Horn on Conjuring";
	else
	if(strClassname == "item_artifact_empathy_shields")
		strReturn = "Empathy Shields";
	// END HIPNOTIC SUPPORT
	// ******************************************
	else
	if(strClassname == "item_sigil")
		strReturn = "Sigil";
	else
	// Items - Keys
	if(strClassname == "item_key1")
		strReturn = "Silver Key";
	else
	if(strClassname == "item_key2")
		strReturn = "Gold Key";
	else
	if(strClassname == "func_spawn" || strClassname == "func_spawn_small")
		strReturn = "Monster Spawn";
	else
	if(strClassname == "func_spawn_multimonster")
		strReturn = "Multi Monster Spawn";
	else
	if(strClassname == "func_spawn_random")
		strReturn = "Random Monster Spawn";
	else
	if(strClassname == "func_spawn_nonmonster")
		strReturn = "Entity Spawn";
	else
	if(strClassname == "func_button")
		strReturn = "Button";
	else
	if(strClassname == "trigger_secret")
		strReturn = "Secret";
	else
	if(strClassname == "trigger_teleport")
		strReturn = "Teleporter";
	else
	if(strClassname == "trigger_multiple" || strClassname == "trigger_once")
		strReturn = "Damage Trigger";
	else
	if(strClassname == "door")
		strReturn = "Damage Door";
	else
		// Default; Use Classname
		strReturn = strClassname;
		
	// Return Name
	return strReturn;
}

void PrintAdvancedStatistics(entity enPlayer, float bIntermission)
{ // Print Advanced Statistics
	if(deathmatch)
		// Disable Statistics for Deathmatch
		return;
		
	local string strMessage;
	local string strCountMessage;
	local float nCnt;
	local float nSpacingCnt;
	local float	nSpacingNeeded;
	local float nCount1;
	local float	nCount2;
	local string strCnt;
	
	strMessage = "\bKLESHIK ADVANCED STATISTICS / SCORING\b\n\n";
	
	// **************************************************************************
	// PRINT MONSTERS KILLED
	
	strMessage = strcat(strMessage, "\bMONSTERS KILLED\b\n");
	for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS; nCnt++)
	{ // Cycle through Array
		strCnt = ftos(nCnt);
		if(strGameStatistic_Monster_Name[nCnt] != "")
		{ // Valid Monster
			// Assign Counts
			nCount1 = nGameStatistic_Monster_Killed[nCnt];
			nCount2 = nGameStatistic_Monster_Total[nCnt];
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_NAME_LENGTH - (strlen(strGameStatistic_Monster_Name[nCnt]) + 2 );
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strMessage = strcat(strMessage, " ");
					
			// Determine Line Color
			if(nCount1 >= nCount2)
				strMessage = strcat(strMessage, "^2");
			else
				strMessage = strcat(strMessage, "^7");
			strMessage = strcat(strMessage, strGameStatistic_Monster_Name[nCnt]);
			strMessage = strcat(strMessage, " : ");
			
			// Generate Count Message
			strCountMessage = strcat( ftos(nGameStatistic_Monster_Killed[nCnt]), " / ");
			strCountMessage = strcat(strCountMessage, ftos(nGameStatistic_Monster_Total[nCnt]));
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH - strlen(strCountMessage);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strCountMessage = strcat(strCountMessage, " ");
			// Append Count Message
			strMessage = strcat(strMessage, strCountMessage);
			
			// Begin Next Line
			strMessage = strcat(strMessage, "\n");
		}
		else
			// End Loop
			nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS;
	}
	
	// **************************************************************************
	// PRINT HEALTH / ARMOR /AMMO FOUND
	
	strMessage = strcat(strMessage, "\n^7\n\bHEALTH / ARMOR / AMMO FOUND\b\n");
	for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO; nCnt++)
	{ // Cycle through Array
		strCnt = ftos(nCnt);
		if(strGameStatistic_HealthArmorAmmo_Name[nCnt] != "")
		{ // Valid
			// Assign Counts
			nCount1 = nGameStatistic_HealthArmorAmmo_Found[nCnt];
			nCount2 = nGameStatistic_HealthArmorAmmo_Total[nCnt];
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_NAME_LENGTH - (strlen(strGameStatistic_HealthArmorAmmo_Name[nCnt]) + 2);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strMessage = strcat(strMessage, " ");
			// Determine Line Color
			if(nCount1 >= nCount2)
				strMessage = strcat(strMessage, "^2");
			else
				strMessage = strcat(strMessage, "^7");
			strMessage = strcat(strMessage, strGameStatistic_HealthArmorAmmo_Name[nCnt], " : ");
			
			// Generate Count Message
			strCountMessage = strcat( ftos(nGameStatistic_HealthArmorAmmo_Found[nCnt]), " / ");
			strCountMessage = strcat(strCountMessage, ftos(nGameStatistic_HealthArmorAmmo_Total[nCnt]));
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH - strlen(strCountMessage);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strCountMessage = strcat(strCountMessage, " ");
			// Append Count Message
			strMessage = strcat(strMessage, strCountMessage);
			
			// Begin Next Line
			strMessage = strcat(strMessage, "\n");
		}
		else
			// End Loop
			nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO;
	}
	
	// **************************************************************************
	// PRINT WEAPONS FOUND
	
	strMessage = strcat(strMessage, "\n^7\n\bWEAPONS FOUND\b\n");
	for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS; nCnt++)
	{ // Cycle through Array
		strCnt = ftos(nCnt);
		if(strGameStatistic_Weapon_Name[nCnt] != "")
		{ // Valid Item
			// Assign Counts
			nCount1 = nGameStatistic_Weapon_Found[nCnt];
			nCount2 = nGameStatistic_Weapon_Total[nCnt];
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_NAME_LENGTH - (strlen(strGameStatistic_Weapon_Name[nCnt]) + 2);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strMessage = strcat(strMessage, " ");
			// Determine Line Color
			if(nCount1 >= nCount2)
				strMessage = strcat(strMessage, "^2");
			else
				strMessage = strcat(strMessage, "^7");
			strMessage = strcat(strMessage, strGameStatistic_Weapon_Name[nCnt], " : ");
			
			// Generate Count Message
			strCountMessage = strcat( ftos(nGameStatistic_Weapon_Found[nCnt]), " / ");
			strCountMessage = strcat(strCountMessage, ftos(nGameStatistic_Weapon_Total[nCnt]));
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH - strlen(strCountMessage);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strCountMessage = strcat(strCountMessage, " ");
			// Append Count Message
			strMessage = strcat(strMessage, strCountMessage);
			
			// Begin Next Line
			strMessage = strcat(strMessage, "\n");
		}
		else
			// End Loop
			nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS;
	}
	
	// **************************************************************************
	// PRINT POWERUPS FOUND
	
	strMessage = strcat(strMessage, "\n^7\n\bPOWERUPS FOUND\b\n");
	for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS; nCnt++)
	{ // Cycle through Array
		strCnt = ftos(nCnt);
		if(strGameStatistic_Powerup_Name[nCnt] != "")
		{ // Valid Item
			// Assign Counts
			nCount1 = nGameStatistic_Powerup_Found[nCnt];
			nCount2 = nGameStatistic_Powerup_Total[nCnt];
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_NAME_LENGTH - (strlen(strGameStatistic_Powerup_Name[nCnt]) + 2);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strMessage = strcat(strMessage, " ");
			// Determine Line Color
			if(nCount1 >= nCount2)
				strMessage = strcat(strMessage, "^2");
			else
				strMessage = strcat(strMessage, "^7");
			strMessage = strcat(strMessage, strGameStatistic_Powerup_Name[nCnt], " : ");
			
			// Generate Count Message
			strCountMessage = strcat( ftos(nGameStatistic_Powerup_Found[nCnt]), " / ");
			strCountMessage = strcat(strCountMessage, ftos(nGameStatistic_Powerup_Total[nCnt]));
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH - strlen(strCountMessage);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strCountMessage = strcat(strCountMessage, " ");
			// Append Count Message
			strMessage = strcat(strMessage, strCountMessage);
			
			// Begin Next Line
			strMessage = strcat(strMessage, "\n");
		}
		else
			// End Loop
			nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS;
	}
	
	// **************************************************************************
	// PRINT OTHERS FOUND
	
	strMessage = strcat(strMessage, "\n^7\n\bOTHERS FOUND\b\n");
	for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_OTHER; nCnt++)
	{ // Cycle through Array
		strCnt = ftos(nCnt);
		if(strGameStatistic_Other_Name[nCnt] != "")
		{ // Valid Item
			// Assign Counts
			nCount1 = nGameStatistic_Other_Found[nCnt];
			nCount2 = nGameStatistic_Other_Total[nCnt];
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_NAME_LENGTH - (strlen(strGameStatistic_Other_Name[nCnt]) + 2);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strMessage = strcat(strMessage, " ");
			// Determine Line Color
			if(nCount1 >= nCount2)
				strMessage = strcat(strMessage, "^2");
			else
				strMessage = strcat(strMessage, "^7");
			strMessage = strcat(strMessage, strGameStatistic_Other_Name[nCnt], " : ");
			
			// Generate Count Message
			strCountMessage = strcat( ftos(nGameStatistic_Other_Found[nCnt]), " / ");
			strCountMessage = strcat(strCountMessage, ftos(nGameStatistic_Other_Total[nCnt]));
			// Append Spacing
				nSpacingNeeded = ADVANCEDSTATISTIC_PRINT_COUNT_LENGTH - strlen(strCountMessage);
				for(nSpacingCnt = 0; nSpacingCnt < nSpacingNeeded; nSpacingCnt++)
					strCountMessage = strcat(strCountMessage, " ");
			// Append Count Message
			strMessage = strcat(strMessage, strCountMessage);
			
			// Begin Next Line
			strMessage = strcat(strMessage, "\n");
		}
		else
			// End Loop
			nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_OTHER;
	}
	
	// Display to Entity
	if(bIntermission)
		WriteString(MSG_ALL, strMessage);
	else
	{
		// Centerprint
		centerprint(enPlayer, strMessage);
		// Play Sound
		stuffcmd(enPlayer, "play2 sound/misc/menu2\n");
	}
}


void CheckUpdatedAdvancedStatistics()
{ // Check Updated Advanced Statistics
	if(deathmatch)
		// Disable Statistics for Deathmatch
		return;
		
	local float nPos;
		nPos = self.nGameStatistic_ArrayPositionReference;
		
	if(self.nGameStatistic_StatisticType == ADVANCEDSTATISTIC_TYPE_MONSTER)
	{ // Monster
		if(self.nGameStatistic_StatisticIncrementCount == 0)
		{ // Increment Statistic
			// Increment Current Kills
			nGameStatistic_Monster_Killed[nPos] = nGameStatistic_Monster_Killed[nPos] + 1;
			// Increment Counter
			self.nGameStatistic_StatisticIncrementCount = self.nGameStatistic_StatisticIncrementCount + 1;
		}
	}
	else
	if(self.nGameStatistic_StatisticType == ADVANCEDSTATISTIC_TYPE_HEALTHARMORAMMO)
	{ // Health / Armor / Ammo
		if(self.nGameStatistic_StatisticIncrementCount == 0)
		{ // Increment Statistic
			nPos = self.nGameStatistic_ArrayPositionReference;
			// Increment Current Found
			nGameStatistic_HealthArmorAmmo_Found[nPos] = nGameStatistic_HealthArmorAmmo_Found[nPos] + 1;
			// Increment Counter
			self.nGameStatistic_StatisticIncrementCount = self.nGameStatistic_StatisticIncrementCount + 1;
		}
	}
	else
	if(self.nGameStatistic_StatisticType == ADVANCEDSTATISTIC_TYPE_WEAPON)
	{ // Weapon
		if(self.nGameStatistic_StatisticIncrementCount == 0)
		{ // Increment Statistic
			// Increment Current Found
			nGameStatistic_Weapon_Found[nPos] = nGameStatistic_Weapon_Found[nPos] + 1;
			// Increment Counter
			self.nGameStatistic_StatisticIncrementCount = self.nGameStatistic_StatisticIncrementCount + 1;
		}
	}
	else
	if(self.nGameStatistic_StatisticType == ADVANCEDSTATISTIC_TYPE_POWERUP)
	{ // Powerup
		if(self.nGameStatistic_StatisticIncrementCount == 0)
		{ // Increment Statistic
			// Increment Current Found
			nGameStatistic_Powerup_Found[nPos] = nGameStatistic_Powerup_Found[nPos] + 1;
			// Increment Counter
			self.nGameStatistic_StatisticIncrementCount = self.nGameStatistic_StatisticIncrementCount + 1;
		}
	}
	else
	if(self.nGameStatistic_StatisticType == ADVANCEDSTATISTIC_TYPE_OTHER)
	{ // Other
		if(self.nGameStatistic_StatisticIncrementCount == 0)
		{ // Increment Statistic
			// bprint( strcat("^1OTHER INCREMENT^7 : ^2", self.classname, "\n") );
			// Increment Current Found
			nGameStatistic_Other_Found[nPos] = nGameStatistic_Other_Found[nPos] + 1;
			// Increment Counter
			self.nGameStatistic_StatisticIncrementCount = self.nGameStatistic_StatisticIncrementCount + 1;
		}
	}
}

void RegisterAdvancedGameStatistic(float fType)
{ // Register Advanced Game Statistic

	if(deathmatch)
		// Disable Statistics for Deathmatch
		return;
		
	// NOTE: Assumed scope is entity to register.
	local float nCnt;
	local string strStatName;
		strStatName = GetDisplayNameFromEntity(self);
		
	// Assign Type
	self.nGameStatistic_StatisticType = fType;
	
	if(fType == ADVANCEDSTATISTIC_TYPE_MONSTER)
	{ // Monster Statistic
		// Acquire 
		for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS; nCnt++)
		{ // Cycle through Array
			if(strGameStatistic_Monster_Name[nCnt] == "")
			{ // End of Array; Create New Statistic
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Monster_Total[nCnt] = nGameStatistic_Monster_Total[nCnt] + 1;
				// Assign Name
				strGameStatistic_Monster_Name[nCnt] = strStatName;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS;
			}
			else
			if(strGameStatistic_Monster_Name[nCnt] == strStatName)
			{ // Monster Found
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Monster_Total[nCnt] = nGameStatistic_Monster_Total[nCnt] + 1;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_MONSTERS;
			}
		}
	}
	else
	if(fType == ADVANCEDSTATISTIC_TYPE_HEALTHARMORAMMO)
	{ // Health / Armor / Ammo
		for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO; nCnt++)
		{ // Cycle through Array
			if(strGameStatistic_HealthArmorAmmo_Name[nCnt] == "")
			{ // End of Array; Create New Statistic
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_HealthArmorAmmo_Total[nCnt] = nGameStatistic_HealthArmorAmmo_Total[nCnt] + 1;
				// Assign Name
				strGameStatistic_HealthArmorAmmo_Name[nCnt] = strStatName;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO;
			}
			else
			if(strGameStatistic_HealthArmorAmmo_Name[nCnt] == strStatName)
			{ // Monster Found
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_HealthArmorAmmo_Total[nCnt] = nGameStatistic_HealthArmorAmmo_Total[nCnt] + 1;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_HEALTHARMORAMMO;
			}
		}
	}
	else
	if(fType == ADVANCEDSTATISTIC_TYPE_WEAPON)
	{ // Weapon
		for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS; nCnt++)
		{ // Cycle through Array
			if(strGameStatistic_Weapon_Name[nCnt] == "")
			{ // End of Array; Create New Statistic
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Weapon_Total[nCnt] = nGameStatistic_Weapon_Total[nCnt] + 1;
				// Assign Name
				strGameStatistic_Weapon_Name[nCnt] = strStatName;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS;
			}
			else
			if(strGameStatistic_Weapon_Name[nCnt] == strStatName)
			{ // Monster Found
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Weapon_Total[nCnt] = nGameStatistic_Weapon_Total[nCnt] + 1;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_WEAPONS;
			}
		}
	}
	else
	if(fType == ADVANCEDSTATISTIC_TYPE_POWERUP)
	{ // Powerup
		for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS; nCnt++)
		{ // Cycle through Array
			if(strGameStatistic_Powerup_Name[nCnt] == "")
			{ // End of Array; Create New Statistic
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Powerup_Total[nCnt] = nGameStatistic_Powerup_Total[nCnt] + 1;
				// Assign Name
				strGameStatistic_Powerup_Name[nCnt] = strStatName;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS;
			}
			else
			if(strGameStatistic_Powerup_Name[nCnt] == strStatName)
			{ // Monster Found
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Powerup_Total[nCnt] = nGameStatistic_Powerup_Total[nCnt] + 1;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_POWERUPS;
			}
		}
	}
	else
	if(fType == ADVANCEDSTATISTIC_TYPE_OTHER)
	{ // Other
		for(nCnt = 0; nCnt < ADVANCEDSTATISTICS_ARRAYSIZE_OTHER; nCnt++)
		{ // Cycle through Array
			if(strGameStatistic_Other_Name[nCnt] == "")
			{ // End of Array; Create New Statistic
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Other_Total[nCnt] = nGameStatistic_Other_Total[nCnt] + 1;
				// Assign Name
				strGameStatistic_Other_Name[nCnt] = strStatName;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_OTHER;
			}
			else
			if(strGameStatistic_Other_Name[nCnt] == strStatName)
			{ // Monster Found
				// Assign Array Position Indice
				self.nGameStatistic_ArrayPositionReference = nCnt;
				// Increment Total
				nGameStatistic_Other_Total[nCnt] = nGameStatistic_Other_Total[nCnt] + 1;
				
				// End Loop
				nCnt = ADVANCEDSTATISTICS_ARRAYSIZE_OTHER;
			}
		}
	}
}