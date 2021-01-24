#if defined STANDALONE_BUILD
#include <sourcemod>
#include <sdktools>

#include <store>
#include <zephstocks>

#include <sdkhooks>
#endif

enum GrenadeTrail
{
	String:GrenadeTrailMaterial[PLATFORM_MAX_PATH],
	String:GrenadeTrailWidth[16],
	String:GrenadeTrailColor[16],
	Float:GrenadeTrailfWidth,
	GrenadeTrailiColor[4],
	GrenadeTrailiSlot,
	GrenadeTrailiCacheID
}

new g_eGrenadeTrails[STORE_MAX_ITEMS][GrenadeTrail];

new g_iGrenadeTrails = 0;

#if defined STANDALONE_BUILD
public OnPluginStart()
#else
public GrenadeTrails_OnPluginStart()
#endif
{
#if !defined STANDALONE_BUILD
	// This is not a standalone build, we don't want grenade trails to kill the whole plugin for us	
	if(GetExtensionFileStatus("sdkhooks.ext")!=1)
	{
		LogError("SDKHooks isn't installed or failed to load. Grenade Trails will be disabled. Please install SDKHooks. (https://forums.alliedmods.net/showthread.php?t=106748)");
		return;
	}
#endif
	
	Store_RegisterHandler("grenadetrail", "material", GrenadeTrails_OnMapStart, GrenadeTrails_Reset, GrenadeTrails_Config, GrenadeTrails_Equip, GrenadeTrails_Remove, true);
}

public GrenadeTrails_OnMapStart()
{
	for(new i=0;i<g_iGrenadeTrails;++i)
	{
		g_eGrenadeTrails[i][GrenadeTrailiCacheID] = PrecacheModel2(g_eGrenadeTrails[i][GrenadeTrailMaterial], true);
		Downloader_AddFileToDownloadsTable(g_eGrenadeTrails[i][GrenadeTrailMaterial]);
	}
}

public GrenadeTrails_Reset()
{
	g_iGrenadeTrails = 0;
}

public GrenadeTrails_Config(&Handle:kv, itemid)
{
	Store_SetDataIndex(itemid, g_iGrenadeTrails);
	KvGetString(kv, "material", g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailMaterial], PLATFORM_MAX_PATH);
	KvGetString(kv, "width", g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailWidth], 16, "10.0");
	g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailfWidth] = KvGetFloat(kv, "width", 10.0);
	KvGetString(kv, "color", g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailColor], 16, "255 255 255 255");
	KvGetColor(kv, "color", g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailiColor][0], g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailiColor][1], g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailiColor][2], g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailiColor][3]);
	g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailiSlot] = KvGetNum(kv, "slot");
	
	if(FileExists(g_eGrenadeTrails[g_iGrenadeTrails][GrenadeTrailMaterial], true))
	{
		++g_iGrenadeTrails;
		return true;
	}
	
	return false;
}

public GrenadeTrails_Equip(client, id)
{
	return 0;
}

public GrenadeTrails_Remove(client, id)
{
	return 0;
}

#if defined STANDALONE_BUILD
public OnEntityCreated(entity, const String:classname[])
#else
public GrenadeTrails_OnEntityCreated(entity, const String:classname[])
#endif
{
	if(g_iGrenadeTrails == 0)
		return;
	if(StrContains(classname, "_projectile")>0)
		SDKHook(entity, SDKHook_SpawnPost, GrenadeTrails_OnEntitySpawnedPost);		
}

public GrenadeTrails_OnEntitySpawnedPost(entity)
{
	new client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	
	if(!(0<client<=MaxClients))
		return;
	
	new m_iEquipped = Store_GetEquippedItem(client, "grenadetrail", 0);
	
	if(m_iEquipped < 0)
		return;
		
	new m_iData = Store_GetDataIndex(m_iEquipped);

	// Ugh...
	decl m_iColor[4];
	m_iColor[0] = g_eGrenadeTrails[m_iData][GrenadeTrailiColor][0];
	m_iColor[1] = g_eGrenadeTrails[m_iData][GrenadeTrailiColor][1];
	m_iColor[2] = g_eGrenadeTrails[m_iData][GrenadeTrailiColor][2];
	m_iColor[3] = g_eGrenadeTrails[m_iData][GrenadeTrailiColor][3];
	TE_SetupBeamFollow(entity, g_eGrenadeTrails[m_iData][GrenadeTrailiCacheID], 0, 2.0, g_eGrenadeTrails[m_iData][GrenadeTrailfWidth], g_eGrenadeTrails[m_iData][GrenadeTrailfWidth], 10, m_iColor);
	TE_SendToAll();
}