class XComHQ_FAN extends XComHQPresentationLayer config(FasterAvengerNavigation);

var config float AvatarPauseMultiplier;
var config bool InstantRoomTransitions;
var config bool SkipHologlobeDissolveAnimation;

var private Vector2D DoomEntityLoc; // for doom panning

function UIArmory_MainMenu(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false)
{
	if(ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(ScreenStack.Push(Spawn(class'UIArmory_MainMenu', self), Get3DMovie())).InitArmory(UnitRef, , SoldSpawnEvent, , HideEvent, RemoveEvent, bInstant || InstantRoomTransitions);
}

reliable client function CAMLookAtNamedLocation( string strLocation, optional float fInterpTime = 2, optional bool bSkipBaseViewTransition )
{
	if(InstantRoomTransitions)
		fInterpTime *= 0.001f;
	super.CAMLookAtNamedLocation (strLocation, fInterpTime, bSkipBaseViewTransition);
}

reliable client function CAMLookAtHQTile( int x, int y, optional float fInterpTime = 2 )
{
	if(InstantRoomTransitions)
		fInterpTime *= 0.001f;
	super.CAMLookAtHQTile (x, y, fInterpTime);
}

//----------------------------------------------------
// HOLOGLOBE DISSOLVE ANIMATION
//----------------------------------------------------

function UIEnterStrategyMap(bool bSmoothTransitionFromSideView = false)
{
	if(!SkipHologlobeDissolveAnimation)
	{
		super.UIEnterStrategyMap(bSmoothTransitionFromSideView);
		return;
	}
	
	m_kAvengerHUD.ClearResources();
	m_kAvengerHUD.HideEventQueue();
	m_kAvengerHUD.Shortcuts.Hide();
	CleanupAvengerHUD();
	SetTimer(`HQINTERPTIME, false, nameof(CleanupAvengerHUD));
	
	OnRemoteEvent('FinishedTransitionIntoMap');
}

private function CleanupAvengerHUD()
{
	m_kFacilityGrid.Hide();
}

function ExitStrategyMap(bool bSmoothTransitionFromSideView = false)
{
	if(!SkipHologlobeDissolveAnimation)
	{
		super.ExitStrategyMap(bSmoothTransitionFromSideView);
		return;
	}

	m_kXComStrategyMap.ExitStrategyMap();

	OnRemoteEvent('FinishedTransitionFromMap');
}

//----------------------------------------------------
// DOOM EFFECT
//----------------------------------------------------

//---------------------------------------------------------------------------------------
function NonPanClearDoom(bool bPositive)
{
	StrategyMap2D.SetUIState(eSMS_Flight);

	if(bPositive)
	{
		StrategyMap2D.StrategyMapHUD.StartDoomRemovedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_DecreaseScreenTear_ON");
	}
	else
	{
		StrategyMap2D.StrategyMapHUD.StartDoomAddedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_IncreasedScreenTear_ON");
	}

	SetTimer(3.0f*AvatarPauseMultiplier, false, nameof(NoPanClearDoomPt2));
}

//---------------------------------------------------------------------------------------
function NoPanClearDoomPt2()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ.ClearPendingDoom();

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(AlienHQ.PendingDoomData.Length > 0)
	{
		SetTimer(4.0f*AvatarPauseMultiplier, false, nameof(NoPanClearDoomPt2));
	}
	else
	{
		SetTimer(4.0f*AvatarPauseMultiplier, false, nameof(UnPanDoomFinished));
	}
}

//---------------------------------------------------------------------------------------
function DoomCameraPan(XComGameState_GeoscapeEntity EntityState, bool bPositive, optional bool bFirstFacility = false)
{
	CAMSaveCurrentLocation();
	StrategyMap2D.SetUIState(eSMS_Flight);

	// Stop Scanning
	if(`GAME.GetGeoscape().IsScanning())
	{
		StrategyMap2D.ToggleScan();
	}

	if(bPositive)
	{
		StrategyMap2D.StrategyMapHUD.StartDoomRemovedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_DecreaseScreenTear_ON");
	}
	else
	{
		StrategyMap2D.StrategyMapHUD.StartDoomAddedEffect();
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_IncreasedScreenTear_ON");
	}

	DoomEntityLoc = EntityState.Get2DLocation();

	if(bFirstFacility)
	{
		SetTimer(3.0f*AvatarPauseMultiplier, false, nameof(StartFirstFacilityCameraPan));
	}
	else
	{
		SetTimer(3.0f*AvatarPauseMultiplier, false, nameof(StartDoomCameraPan));
	}
}

//---------------------------------------------------------------------------------------
function StartDoomCameraPan()
{
	// Pan to the location
	CAMLookAtEarth(DoomEntityLoc, 0.5f, `HQINTERPTIME);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME + 3.0f*AvatarPauseMultiplier), false, nameof(DoomCameraPanComplete));
}

//---------------------------------------------------------------------------------------
function StartFirstFacilityCameraPan()
{
	CAMLookAtEarth(DoomEntityLoc, 0.5f, `HQINTERPTIME);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME), false, nameof(FirstFacilityCameraPanComplete));
}

//---------------------------------------------------------------------------------------
function DoomCameraPanComplete()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ.ClearPendingDoom();

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(AlienHQ.PendingDoomData.Length > 0)
	{
		SetTimer(4.0f*AvatarPauseMultiplier, false, nameof(DoomCameraPanComplete));
	}
	else
	{
		SetTimer(4.0f*AvatarPauseMultiplier, false, nameof(UnpanDoomCamera));
	}
}

//---------------------------------------------------------------------------------------
function FirstFacilityCameraPanComplete()
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState NewGameState;
	local StateObjectReference EmptyRef;
	local XComGameState_MissionSite MissionState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fire First Facility Event");
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	NewGameState.AddStateObject(AlienHQ);

	if(AlienHQ.PendingDoomEvent != '')
	{
		`XEVENTMGR.TriggerEvent(AlienHQ.PendingDoomEvent, , , NewGameState);
	}

	AlienHQ.PendingDoomEvent = '';
	AlienHQ.PendingDoomEntity = EmptyRef;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.GetMissionSource().bAlienNetwork)
		{
			break;
		}
	}

	StrategyMap2D.StrategyMapHUD.StopDoomAddedEffect();
	StrategyMap2D.SetUIState(eSMS_Default);
	OnMissionSelected(MissionState, false);
}

//---------------------------------------------------------------------------------------
function UnpanDoomCamera()
{
	CAMRestoreSavedLocation();
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Camera_Whoosh");
	SetTimer((`HQINTERPTIME + 3.0f*AvatarPauseMultiplier), false, nameof(UnPanDoomFinished));
}

//---------------------------------------------------------------------------------------
function UnPanDoomFinished()
{
	StrategyMap2D.StrategyMapHUD.StopDoomRemovedEffect();
	StrategyMap2D.StrategyMapHUD.StopDoomAddedEffect();
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Doom_Increase_and_Decrease_Off");
	StrategyMap2D.SetUIState(eSMS_Default);

	if(m_bDelayGeoscapeEntryEvent)
	{
		GeoscapeEntryEvent();
	}
}