class X2WOTCCH_UIScreenListener_ShellSplash extends UIScreenListener config(Game);

var config bool bEnableVersionDisplay;

var localized string strLWHLVersion;
var localized string strCHLVersion;

event OnInit(UIScreen Screen)
{
	local UIShell ShellScreen;
	local X2StrategyElementTemplateManager Manager;
	local X2StrategyElementTemplate CHElem;
	local CHXComGameVersionTemplate CHVersion;
	local string VersionString;

	local UIText VersionText;
	local int iMajor, iMinor, iPatch;

	if(UIShell(Screen) == none || !bEnableVersionDisplay)  // this captures UIShell and UIFinalShell
		return;

	ShellScreen = UIShell(Screen);

	Manager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	CHElem = Manager.FindStrategyElementTemplate('CHXComGameVersion');

	VersionString = "";
	
	if (CHElem != none)
	{
		CHVersion = CHXComGameVersionTemplate(CHElem);
		VersionString = strCHLVersion;
		iMajor = CHVersion.MajorVersion;
		iMinor = CHVersion.MinorVersion;
		iPatch = CHVersion.PatchVersion;
	}
	VersionString = Repl(VersionString, "%MAJOR", iMajor);
	VersionString = Repl(VersionString, "%MINOR", iMinor);
	VersionString = Repl(VersionString, "%PATCH", iPatch);

	`log("X2CH SCREEN LISTENER ON SPLASH" @ VersionString);
	VersionText = ShellScreen.Spawn(class'UIText', ShellScreen);
	VersionText.InitText('theVersionText');
	VersionText.SetText(VersionString, OnTextSizeRealized);
	// This code aligns the version text to the Main Menu Ticker
	VersionText.AnchorBottomRight();
	VersionText.SetY(-ShellScreen.TickerHeight + 10);
}

function OnTextSizeRealized()
{
	local UIText VersionText;
	local UIShell ShellScreen;

	ShellScreen = UIShell(`SCREENSTACK.GetFirstInstanceOf(class'UIShell'));
	VersionText = UIText(ShellScreen.GetChildByName('theVersionText'));
	VersionText.SetX(-10 - VersionText.Width);
	// this makes the ticker shorter -- if the text gets long enough to interfere, it will automatically scroll
	ShellScreen.TickerText.SetWidth(ShellScreen.Movie.m_v2ScaledFullscreenDimension.X - VersionText.Width - 20);
	
}

defaultProperties
{
    ScreenClass = none
}
