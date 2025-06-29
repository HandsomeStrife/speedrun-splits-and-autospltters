state("HundredFires (Episode1)"){}
state("HundredFires (Episode2)"){}
state("HundredFires (Episode 3)"){}

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
    vars.transitioning = false;
}

update
{
    if (vars.Helper.Scenes.Loaded.Length > 0) {
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
    } else {
        vars.transitioning = true;
    }
}

start
{
    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ESCENARIO0")
    {
        vars.transitioning = false;
        return true;
    }
    return false;
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

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep2 ESCENARIO2")
    {
        vars.transitioning = false;
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO2" && current.activeScene != "ep2 ESCENARIO2")
    {
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO CENTRAL" && current.activeScene != "ep2 ESCENARIO3_NUCLEO CENTRAL")
    {
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO ESTE" && current.activeScene != "ep2 ESCENARIO3_NUCLEO ESTE")
    {
        return true;
    }

    if (old.activeScene == "ep2 ESCENARIO3_NUCLEO OESTE" && current.activeScene != "ep2 ESCENARIO3_NUCLEO OESTE")
    {
        return true;
    }

    if (old.activeScene == "ESCENA LOADING BARRA" && current.activeScene == "ep3 ESCENARIO0")
    {
        vars.transitioning = false;
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
    return current.activeScene == "ESCENA LOADING BARRA" || vars.transitioning;
}

onReset
{
    vars.transitioning = false;
}