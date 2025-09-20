#pragma semicolon 1

#include <sourcemod>
#include <discord>

public Plugin myinfo = {
	name = "Discord Join Event",
	author = "Spaenny, DNA.styx",
	description = "Announces fully joined players in the Discord",
	version = "1.0.1",
	url = "github.com/Spaenny"
};

ConVar p_cvEnabled;
ConVar p_cvChannel;

public void OnPluginStart() {
	HookEvent("player_connect", Event_PlayerConnect);
	HookEvent("player_disconnect", Event_PlayerDisconnect);
	p_cvEnabled = CreateConVar("discord_enable", "1", "Sets whether Discord-Join is enabled");
	p_cvChannel = CreateConVar("discord_channel", "global", "Sets the channel to send to, according to the discord.cfg");
}

public Action:Event_PlayerConnect(Event event, const char[] name, bool dontBroadcast) {	
	new enabled = GetConVarInt(p_cvEnabled);
	decl ConVar:convar; 
	decl String:nick[64];
	decl String:hostname[512];
	new bot;

	if(enabled != 1) 
		return Plugin_Handled;

	bot = GetEventInt(event, "bot");
	if(bot == 1)
		return Plugin_Handled;

	convar = FindConVar("hostname");
	GetEventString(event, "name", nick, sizeof(nick));

	if(!GetConVarString(convar, hostname, sizeof(hostname)))
		hostname = "UNKOWN SERVER:";

	char sChannel[64];
	GetConVarString(p_cvChannel, sChannel, sizeof(sChannel));	
	
	char sMessage[512];
	
	Format(sMessage, sizeof(sMessage), "**%s** has joined", nick);
	SendMessageToDiscord(sChannel, sMessage);
	
	return Plugin_Continue;
}

public Action:Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast) {	
	new enabled = GetConVarInt(p_cvEnabled);
	decl ConVar:convar; 
	decl String:nick[64];
	decl String:hostname[512];
	decl String:reason[64];
	new bot;

	if(enabled != 1) 
		return Plugin_Handled;

	bot = GetEventInt(event, "bot");
	if(bot == 1)
		return Plugin_Handled;

	convar = FindConVar("hostname");

	GetEventString(event, "name", nick, sizeof(nick));
	if(!GetEventString(event, "reason", reason, sizeof(reason)))
		reason = "UNKOWN REASON";

	if(!GetConVarString(convar, hostname, sizeof(hostname)))
		hostname = "UNKOWN SERVER:";

	char sChannel[64];
	GetConVarString(p_cvChannel, sChannel, sizeof(sChannel));

	char sMessage[512];
	
	Format(sMessage, sizeof(sMessage), "**%s** has disconnected (%s)", nick, reason);
	SendMessageToDiscord(sChannel, sMessage);
	
	return Plugin_Continue;
}
