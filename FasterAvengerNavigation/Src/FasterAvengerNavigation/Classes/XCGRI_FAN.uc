class XCGRI_FAN extends XComGameReplicationInfo;

simulated function DoRemoteEvent(name evt, optional bool bRunOnClient)
{
	if (evt == 'PreM_GoToSoldier') return;

	super.DoRemoteEvent (evt, bRunOnClient);
}