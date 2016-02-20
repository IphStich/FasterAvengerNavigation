// The room --> main base transition is controlled by UIFacilityGrid, so we can't disable it from XComHQ_FAN

class UIFacilityGrid_Listener_FAN extends UIScreenListener;

function OnInit(UIScreen screen)
{
    UIFacilityGrid(screen).bInstantInterp = true;
}

function OnLoseFocus(UIScreen screen)
{
    UIFacilityGrid(screen).bInstantInterp = true;
}

defaultproperties
{
    ScreenClass = 'UIFacilityGrid'
}