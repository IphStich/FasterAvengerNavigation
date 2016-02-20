class Camera_FAN extends XComHeadquartersCamera;

function StartRoomViewNamed( name RoomName, float fInterpTime, optional bool bSkipBaseViewTransition )
{
	Super.StartRoomViewNamed(RoomName, fInterpTime * 0.001f, bSkipBaseViewTransition);
}

protected function OnCameraInterpolationComplete()
{
	`log("------------------------------------------------------------------------ on camera interpolation complete");
	super.OnCameraInterpolationComplete();
}

function StartStrategyShellView()
{
	`log("------------------------------------------------------------------------ function StartStrategyShellView()");
	super.StartStrategyShellView();
}

function StartHeadquartersView()
{
	`log("------------------------------------------------------------------------ function StartHeadquartersView()");
	super.StartHeadquartersView();
}

function StartRoomView( name RoomName, float InterpTime )
{
	`log("------------------------------------------------------------------------ function StartRoomView( name RoomName, float InterpTime )");
	super.StartRoomView( RoomName, InterpTime );
}

function TriggerKismetEvent(name RoomName)
{
	`log("------------------------------------------------------------------------ kismet event"@RoomName);
	super.TriggerKismetEvent(RoomName);
}

function FocusOnFacility(name RoomName)
{
	`log("------------------------------------------------------------------------ focus facility");
	super.FocusOnFacility(RoomName);
}