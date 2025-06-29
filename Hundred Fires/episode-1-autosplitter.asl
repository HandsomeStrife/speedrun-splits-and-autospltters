state("HundredFires (Episode1)"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hundred Fires: The Rising of Red Star";
    vars.Helper.LoadSceneManager = true;
    vars.isLoading = false;
    vars.Helper.AlertLoadless();
}

init
{
    old.activeScene = "";
    old.loadingScene = "";
    vars.currentScene = 0;
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

start
{
    return old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ESCENARIO0";
}

split
{
    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ESCENARIO1")
    {
        return true;
    }
    
    if (old.activeScene == "ESCENARIO1" && current.activeScene != "ESCENARIO1")
    {
        return true;
    }
}

isLoading
{
    return current.activeScene == "ESCENA LOADING BARRA";
}

onReset
{
    vars.currentScene = 0;
}