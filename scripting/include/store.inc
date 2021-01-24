#if defined _store_included
	#endinput
#endif
#define _store_included

new g_cvarChatTag = -1;
#define CHAT_TAG g_eCvars[g_cvarChatTag][sCache]

#define ITEM_NAME_LENGTH 64
#define STORE_MAX_ITEMS 2048
#define STORE_MAX_HANDLERS 64
#define STORE_MAX_PLANS 8
#define STORE_MAX_SLOTS 4

enum Item_Plan
{
	String:ItmPlan_szName[ITEM_NAME_LENGTH],
	ItmPlan_iPrice,
	ItmPlan_iTime
}

enum Store_Item
{
	String:Store_ItemName[ITEM_NAME_LENGTH],
	String:Store_ItemUniqueId[PLATFORM_MAX_PATH],
	String:Store_ItemShortcut[64],
	Store_ItemiId,
	Store_ItemiPrice,
	Store_ItemiParent,
	Store_ItemiHandler,
	Store_ItemiFlagBits,
	Store_ItemiData,
	Store_ItemiPlans,
	bool:Store_ItembBuyable,
	bool:Store_ItembIgnoreVIP,
	Handle:Store_ItemhAttributes
}

enum Type_Handler
{
	String:szType[64],
	String:szUniqueKey[32],
	bool:bEquipable,
	bool:bRaw,
	Handle:hPlugin,
	Function:fnMapStart,
	Function:fnReset,
	Function:fnConfig,
	Function:fnUse,
	Function:fnRemove
}

enum Client_Item
{
	Client_ItemiId,
	Client_ItemiUniqueId,
	bool:Client_ItembSynced,
	bool:Client_ItembDeleted,
	Client_ItemiDateOfPurchase,
	Client_ItemiDateOfExpiration,
	Client_ItemiPriceOfPurchase,
}

native Store_RegisterHandler(String:type[], String:uniquekey[], Function:mapstart, Function:reset, Function:config, Function:use, Function:remove, bool:equipable = true, bool:raw = false);
native Store_RegisterMenuHandler(String:identifier[], Function:menu, Function:handler);
native Store_SetDataIndex(itemid, index);
native Store_GetDataIndex(itemid);
native Store_GetEquippedItem(client, String:type[], slot=0);
native Store_IsClientLoaded(client);
native Store_DisplayPreviousMenu(client);
native Store_SetClientMenu(client, num);
native Store_GetClientCredits(client);
native Store_SetClientCredits(client, credits);
native Store_IsClientVIP(client);
native Store_IsItemInBoughtPackage(client, itemid, uid=-1);
native Store_ShouldConfirm();
native Store_DisplayConfirmMenu(client, String:title[], Function:callback, data);
native Store_GetItem(itemid, output[Store_Item]);
native Store_GetHandler(index, output[Type_Handler]);
native Store_GiveItem(client, itemid, purchase=0, expiration=0, price=0);
native Store_RemoveItem(client, itemid);
native Store_GetClientItem(client, itemid, output[Client_Item]);
native Store_GetClientTarget(client);
native Store_GiveClientItem(client, recipient, itemid);
native Store_HasClientItem(client, itemid);
native Store_IterateEquippedItems(client, &start, bool:attributes=false);

forward Store_OnClientModelChanged(client, String:model[]);

public Extension:__ext_store_sm =
{
	name = "Store - The Resurrection",
	file = "store_sm.ext",
#if defined AUTOLOAD_EXTENSIONS
	autoload = 1,
#else
	autoload = 0,
#endif
	required = 0,
};