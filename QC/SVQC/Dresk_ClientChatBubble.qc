// DRESK - Client Chat Bubble Support
// Provides definitions and default values for client chat bubbles.

// Field / Global Definitions
.entity		enChatBubble;
.float		bChatBubbleVisible;

void UpdateClientChatBubble(entity enClient, float bVisible)
{ // Update Client Chat Bubble
	if(bVisible)
	{ // Enable Chat Bubble
		if(enClient.enChatBubble)
			// Chat Bubble Entity Created; Remove NODRAW Effect
			enClient.enChatBubble.effects = enClient.enChatBubble.effects - (enClient.enChatBubble.effects & EF_NODRAW);
		else
		{ // Create Chat Bubble
			local entity enBubbleSpawn;
				enBubbleSpawn = spawn();
				setmodel(enBubbleSpawn, "progs/s_bubble.spr");
				enBubbleSpawn.effects = EF_FULLBRIGHT;
				enBubbleSpawn.scale = 1.5;
				enBubbleSpawn.alpha = 0.6;
				
				enBubbleSpawn.colormod = '0 1 1';
				// Yellow
				// enBubbleSpawn.colormod = '1 1 0';
				
				// Assign Origin
				setorigin(enBubbleSpawn, enBubbleSpawn.origin + '0 0 0.5' + enClient.maxs_z * '0 0 1');
				
			// Assign Chat Bubble to Client
			enClient.enChatBubble = enBubbleSpawn;
			// Attach Bubble
			setattachment(enBubbleSpawn, enClient, "");
		}
		
		// Assign Chat Bubble Visible
		enClient.bChatBubbleVisible = TRUE;
	}
	else
	{ // Disable Chat Bubble
		if(enClient.enChatBubble)
			// Assign NODRAW Effect
			enClient.enChatBubble.effects = enClient.enChatBubble.effects | EF_NODRAW;
			
		// Assign Chat Bubble Invisible
		enClient.bChatBubbleVisible = FALSE;
	}
}
void CheckClientChatBubble(entity enClient)
{ // Check Client Chat Bubble
	if(enClient.buttonchat)
	{ // Client Currently Chatting
		if(!enClient.bChatBubbleVisible)
			// Chat Bubble Not Visible; Enable
			UpdateClientChatBubble(enClient, TRUE);
	}
	else
	{ // Client Not Chatting
		if(enClient.bChatBubbleVisible)
			// Chat Bubble Visible; Disable
			UpdateClientChatBubble(enClient, FALSE);
	}
}