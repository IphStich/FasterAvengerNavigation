class XComHQ_FAN extends XComHQPresentationLayer;

function UIArmory_MainMenu(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false)
{
	if(ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(ScreenStack.Push(Spawn(class'UIArmory_MainMenu', self), Get3DMovie())).InitArmory(UnitRef, , SoldSpawnEvent, , HideEvent, RemoveEvent, true);
}

/*reliable client function CAMLookAtEarth( vector2d v2Location, optional float fZoom = 1.0f, optional float fInterpTime = 0.75f )
{
	fInterpTime *= 0.001f;

	XComHeadquartersCamera(XComHeadquartersController(Owner).PlayerCamera).NewEarthView(fInterpTime);
	`EARTH.SetViewLocation(v2Location);
	`EARTH.SetCurrentZoomLevel(fZoom);

	//m_kCamera.LookAtEarth( v2Location, fZoom, bCut );
	//GetCamera().FocusOnEarthLocation(v2Location, fZoom, fInterpTime);
}*/

reliable client function CAMLookAtNamedLocation( string strLocation, optional float fInterpTime = 2, optional bool bSkipBaseViewTransition )
{
	fInterpTime *= 0.001f;
	GetCamera().StartRoomViewNamed(name(strLocation), fInterpTime, bSkipBaseViewTransition);
}

/*function CAMLookAtRoom(XComGameState_HeadquartersRoom RoomStateObject, optional float fInterpTime = 2 )
{
	super.CAMLookAtRoom (RoomStateObject, fInterpTime * 0.001f);
}*/

reliable client function CAMLookAtHQTile( int x, int y, optional float fInterpTime = 2 )
{
	super.CAMLookAtHQTile (x, y, fInterpTime * 0.001f);
}