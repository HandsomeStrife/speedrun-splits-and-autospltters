state("HundredFires (Episode 3)"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hundred Fires: The Rising of Red Star - Episode 3";
    vars.Helper.LoadSceneManager = true;
    vars.isLoading = false;
    vars.Helper.AlertLoadless();
}

init
{
    old.activeScene = "";
    old.loadingScene = "";
    vars.paused = true;
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
    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO0")
    {
        vars.paused = false;
        return true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO1")
    {
        return true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO2")
    {
        return true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO3")
    {
        return true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO4")
    {
        return true;
    }
}

isLoading
{
    return current.activeScene == "ESCENA LOADING BARRA" || vars.paused;
}

onReset
{
    timer.IsGameTimePaused = false;
}
