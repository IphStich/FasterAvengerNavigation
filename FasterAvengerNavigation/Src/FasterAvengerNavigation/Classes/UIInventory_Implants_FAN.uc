class UIInventory_Implants_FAN extends UIInventory_Implants;

simulated function InstallImplant()
{
	local XComGameState UpdatedState;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Item UpdatedImplant;
	local XComGameState_HeadquartersXCom UpdatedHQ;

	UpdatedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Install Personal Combat Sim");

	UnitRef = UIArmory_MainMenu(Movie.Pres.ScreenStack.GetScreen(class'UIArmory_MainMenu_FAN')).GetUnit().GetReference();
	UpdatedHQ = XComGameState_HeadquartersXCom(UpdatedState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UpdatedUnit = XComGameState_Unit(UpdatedState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
	UpdatedState.AddStateObject(UpdatedHQ);

	UpdatedHQ.GetItemFromInventory(UpdatedState, Implants[List.SelectedIndex].GetReference(), UpdatedImplant);
	
	UpdatedUnit.AddItemToInventory(UpdatedImplant, eInvSlot_CombatSim, UpdatedState);
	UpdatedState.AddStateObject(UpdatedUnit);
	
	`XEVENTMGR.TriggerEvent('PCSApplied', UpdatedUnit, UpdatedImplant, UpdatedState);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Strategy_UI_PCS_Equip");

	`GAMERULES.SubmitGameState(UpdatedState);
}