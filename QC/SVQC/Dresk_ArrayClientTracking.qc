// DRESK - Array-Based Client Tracking
// Provides definitions and default values for array-based client tracking.

#define ARRAYBASEDCLIENTTACKING_ARRAYSIZE							32

void AddClientToArray(entity enClient)
{ // Add Client to Array
	if(enClients[nClientCnt] == world)
	{ // Append Client to Array
		enClients[nClientCnt] = enClient;
		nClientCnt = nClientCnt + 1;
	}
	else
		bprint("ERROR: AddClientToArray Position NOT World!\n");
}

void RemoveClientFromArray(entity enClient)
{ // Remove Client from Array
	local float nCnt;
	
	for(nCnt = 0; nCnt < ARRAYBASEDCLIENTTACKING_ARRAYSIZE; nCnt++)
	{ // Cycle through Array
		if(enClients[nCnt] == enClient)
		{ // Client Found
			
		}
	}
}

void PrintClientsFromArray(entity enCaller)
{ // Print Clients from Array
	local float nCnt;
	local string strCnt;
	local string strMessage;
		strMessage = "";
	
	for(nCnt = 0; nCnt < ARRAYBASEDCLIENTTACKING_ARRAYSIZE; nCnt++)
	{ // Cyle Clients Array
		strCnt = ftos(nCnt);
		strMessage = strcat(strMessage, "enClients[", strCnt, "] : ");
		if(enClients[nCnt] == world)
			strMessage = strcat(strMessage, "WORLD\n");
		else
			strMessage = strcat(strMessage, enClients[nCnt].netname, "\n");
	}
	
	// Print Clients
	sprint(enCaller, strMessage);
}