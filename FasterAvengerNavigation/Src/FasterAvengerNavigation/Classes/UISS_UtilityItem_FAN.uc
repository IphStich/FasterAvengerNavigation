class UISS_UtilityItem_FAN extends UISquadSelect_UtilityItem;

simulated function GoToUtilityItem()
{
	`HQPRES.UIArmory_Loadout(UISquadSelect_ListItem(GetParent(class'UISS_ListItem_FAN')).GetUnitRef());
	UIArmory_Loadout(Movie.Stack.GetScreen(class'UIArmory_Loadout')).SelectItemSlot(SlotType, SlotIndex);
}