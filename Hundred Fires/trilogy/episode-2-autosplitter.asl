state("HundredFires (Episode2)"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hundred Fires: The Rising of Red Star - Episode 2";
    vars.Helper.LoadSceneManager = true;
    vars.isLoading = false;
    vars.Helper.AlertLoadless();
}

init
{
    old.activeScene = "";
    old.loadingScene = "";
    vars.paused = true;
    vars.visitedLeft = false;
    vars.visitedRight = false;
    vars.visitedBoth = false;
    vars.finalScreen = false;
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? old.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? old.loadingScene;

    if (current.activeScene != old.activeScene)
    {
        vars.Log("Active Scene: " + current.activeScene);
    }

    if (current.loadingScene != old.loadingScene)
    {
        vars.Log("Loading Scene: " + current.loadingScene);
    }
}

split
{
    if (vars.visitedLeft && vars.visitedRight)
    {
        vars.visitedBoth = true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep2 ESCENARIO2")
    {
        vars.paused = false;
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO2" && current.activeScene != "ep2 ESCENARIO2")
    {
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO CENTRAL" && current.activeScene != "ep2 ESCENARIO3_NUCLEO CENTRAL" && !vars.finalScreen)
    {
        if (vars.visitedBoth) {
            vars.finalScreen = true;
        }
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO ESTE" && current.activeScene != "ep2 ESCENARIO3_NUCLEO ESTE")
    {
        vars.visitedLeft = true;
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO OESTE" && current.activeScene != "ep2 ESCENARIO3_NUCLEO OESTE")
    {
        vars.visitedRight = true;
        return true;
    }
}

isLoading
{
    return current.activeScene == "ESCENA LOADING BARRA" || vars.paused;
}

exit
{
    timer.IsGameTimePaused = true;
}

onReset
{
    timer.IsGameTimePaused = false;
}
