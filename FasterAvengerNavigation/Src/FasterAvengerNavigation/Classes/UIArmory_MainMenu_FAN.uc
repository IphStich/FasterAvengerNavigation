class UIArmory_MainMenu_FAN extends UIArmory_MainMenu
	dependson(UIDialogueBox)
	dependson(UIUtilities_Strategy);

simulated function InitArmory(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false, optional XComGameState InitCheckGameState)
{
	SuperInitArmory (UnitRef,,,,,, true);
}

simulated function SuperInitArmory(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false, optional XComGameState InitCheckGameState)
{
	local float InterpTime;

	// ORIGINAL UIARMORY
	IsSoldierEligible = CanCycleTo;
	CheckGameState = InitCheckGameState;
	DisplayEvent = DispEvent;
	SoldierSpawnEvent = SoldSpawnEvent;
	HideMenuEvent = HideEvent;
	RemoveMenuEvent = RemoveEvent;
	NavigationBackEvent = NavBackEvent;

	if (SoldierSpawnEvent != '' || DisplayEvent != '')
	{
		WorldInfo.RemoteEventListeners.AddItem(self);
	}

	if (DisplayEvent == '')
	{
		InterpTime = `HQINTERPTIME;

		if(bInstant)
		{
			InterpTime = 0;
		}

		class'UIUtilities'.static.DisplayUI3D(DisplayTag, name(CameraTag), InterpTime);
	}
	else
	{
		if(bIsIn3D) UIMovie_3D(Movie).HideAllDisplays();
	}

	Header = Spawn(class'UISoldierHeader', self).InitSoldierHeader(UnitRef, CheckGameState);

	SetUnitReference(UnitRef);

	`XCOMGRI.DoRemoteEvent('CIN_HideArmoryStaff'); //Hide the staff in the armory so that they don't overlap with the soldiers
	
	/*if(bUseNavHelp)
	{
		if(XComHQPresentationLayer(Movie.Pres) != none)
			NavHelp = XComHQPresentationLayer(Movie.Pres).m_kAvengerHUD.NavHelp;
		else
			NavHelp = Movie.Pres.GetNavHelp();

		UpdateNavHelp();
	}*/

	// ORIGINAL MAIN MENU
	List = Spawn(class'UIList', self).InitList('armoryMenuList');
	List.OnItemClicked = OnItemClicked;
	List.OnSelectionChanged = OnSelectionChanged;

	CreateSoldierPawn();
	PopulateData();
	CheckForCustomizationPopup();
}