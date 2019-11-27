// DRESK - Raw Stuffcmd to Client Support

// Globals
float RawStuffCmdToClient_nClientListSize;
entity RawStuffCmdToClient_enClientList[32];

// Functions
void RawStuffCmdToClient_SendAliases(entity enClient)
{ // Raw Stuff Cmd to Client - Send Aliases
	stuffcmd(enClient, "alias rstf \"cmd RawStuffCmdToClient $*\"\n");
	// Add Alias for RCON prvm_edictset
	stuffcmd(enClient, "alias rds \"rcon prvm_edictset server $*\"\n");
}
void RawStuffCmdToClient_GenerateClientList()
{ // Raw StuffCmd to Client - Generate Client List
	local entity enClient;
	
	RawStuffCmdToClient_nClientListSize = 0;
	// Acquire Initial Client
	enClient = world;
	enClient = findchainflags(flags, FL_CLIENT);
	// enClient = find(enClient, classname, "player");
	
	while(enClient)
	{ // Print Client
		if( clienttype(enClient) == CLIENTTYPE_REAL)
		{ // Client is Real
			// Assign Client to Client List
			RawStuffCmdToClient_enClientList[RawStuffCmdToClient_nClientListSize] = enClient;
			// Increment Counter
			RawStuffCmdToClient_nClientListSize = RawStuffCmdToClient_nClientListSize + 1;
		}
		
		// Acquire Next Client
		enClient = enClient.chain;
	}
}
void RawStuffCmdToClient_SendStuffCmd()
{ // Raw StuffCmd to Client - Send Stuff Cmd
	local entity enClient;
	local string strReport;
	local float nCnt;
	
	local float nClientID;
	local string strStuffCmd;
	local string strAppend;
	
	{ // Client is Administrator
		// Generate Client List
		RawStuffCmdToClient_GenerateClientList();
		
		if( argv(1) == "" || argv(1) == "$1")
		{ // No Client Specified; Print Usage and List
			local string strCnt;
			
			strReport = "Usage : ^1RawStuffCmdToClient^7 ClientID ^3My Stuff Cmd^7\n^2$^7 is replaced with ^2\"^7\nClientID List\n";
			
			// Display Clients
			for(nCnt = 0; nCnt < RawStuffCmdToClient_nClientListSize; nCnt++)
			{ // Cycle through Client List
				strCnt = ftos(nCnt);
				strReport = strcat(strReport, strCnt, " : ", RawStuffCmdToClient_enClientList[nCnt].netname, "^7\n");
			}
		}
		else
		{ // Client Specified
			// Acquire Client ID
			nClientID = stof(argv(1) );
			
			// Acquire Client
			enClient = RawStuffCmdToClient_enClientList[nClientID];
				
			if(enClient)
			{ // Valid Client
				// Acquire Full Command
				strStuffCmd = "";
				nCnt = 2;
				while( argv(nCnt) != "")
				{ // Append Command
					if(nCnt > 2)
						// Append Space
						strStuffCmd = strcat(strStuffCmd, " ");
					// Replace % with "
					strAppend = argv(nCnt);
					strAppend = strreplace("$", "\"", strAppend);
					// Append to Command
					strStuffCmd = strcat(strStuffCmd, strAppend);
					
					// Increment counter
					nCnt = nCnt + 1;
				}
				
				// Generate Report Message
				strReport = strcat("Sending Raw StuffCmd to Client '", enClient.netname, "^7' : '", strStuffCmd, "'\n");
				
				// Append Return to Command
				strStuffCmd = strcat(strStuffCmd, "\n");
				// Execute Command
				stuffcmd(enClient, strStuffCmd);
			}
			else
				strReport = "^1ERROR^7 : Cannot Find Client\n";
		}
			
		// Send Report
		sprint(self, strReport);
	}
}