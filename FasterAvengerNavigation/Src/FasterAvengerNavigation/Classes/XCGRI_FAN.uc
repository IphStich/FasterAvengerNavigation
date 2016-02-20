class XCGRI_FAN extends XComGameReplicationInfo;

simulated function DoRemoteEvent(name evt, optional bool bRunOnClient)
{
	local PlayerController Controller;

	`log("-----------------------------------------------------------------"@evt);
	if (evt == 'PreM_GoToSoldier') return;

	Controller = GetALocalPlayerController();
	if (Controller != none)
	{
		Controller.RemoteEvent(evt, bRunOnClient);
	}
}