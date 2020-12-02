#include <sourcemod>
#include <cstrike>

ConVar roundsayisi = null;
public void OnPluginStart()
{
	CreateDirectory("cfg/PluginMerkezi", 3);
	roundsayisi = CreateConVar("sm_sifirlama_roundsayisi", "200", "Kaç roundda bir skor sıfırlansın?");
	AutoExecConfig(true, "skorsifirlayici", "PluginMerkezi");
	
	HookEvent("round_end", event_end);
}

public Action event_end(Event event, const char[] name, bool dontBroadcast)
{
	int ToplamRound = CS_GetTeamScore(CS_TEAM_CT) + CS_GetTeamScore(CS_TEAM_T);
	if(ToplamRound >= roundsayisi.IntValue)
	{
		PrintToChatAll("[SM] \x01%d round oynandığından dolayı skorlarınız \x07sıfırlandı.", roundsayisi.IntValue);
		CS_SetTeamScore(CS_TEAM_CT, 0);
		CS_SetTeamScore(CS_TEAM_T, 0);
		
		for(int client = 1; client <= MaxClients; client++)
		{
			if(IsClientInGame(client) && !IsFakeClient(client))
			{
				CS_SetClientAssists(client, 0);
				CS_SetClientContributionScore(client, 0);
				CS_SetMVPCount(client, 0);
				SetEntProp(client, Prop_Data, "m_iFrags", 0);
				SetEntProp(client, Prop_Data, "m_iDeaths", 0);
			}
		}
	}
}


