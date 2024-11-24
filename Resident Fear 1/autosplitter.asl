state("Resident Fear")
{
    byte cutscenePlaying: "MSAudDecMFT.dll", 0xD85CC;
    byte cutsceneBackup: "nvwgf2umx.dll", 0x3FB3B90;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Resident Fear";
    vars.Helper.LoadSceneManager = true;
}

init
{
    vars.level = 0;
    vars.introWatched = false;
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var sl = mono["HFPS.Systems.SceneLoader"];
        vars.Helper["LevelName"] = sl.MakeString("CurrentInfo");

        var pm = mono["HFPS.Systems.Inventory"];
        vars.Helper["inventoryInitialised"] = pm.Make<bool>("IsInitialized");

        // var obm = mono["HFPS.Systems.DynamicObject"];
        // foreach (var field in obm)
        // {
        //     vars.Log(field.Name);
        // }
        // vars.Helper["cutsceneRunning"] = obm.Make<float>("distance");
        return true;
    });
}


update
{
    if (current.LevelName == "NGIntro" && !vars.introWatched)
    {
        vars.introWatched = true;
        vars.Log("Intro Watched");
    }

    if (current.LevelName != old.LevelName)
    {
        vars.Log("Level: " + current.LevelName);
    }

    if (current.LevelName != old.LevelName)
    {
        vars.Log("Level: " + current.LevelName);
    }

    if (current.inventoryInitialised != old.inventoryInitialised)
    {
        vars.Log("Inventory: " + current.inventoryInitialised);
    }

    if (current.cutscenePlaying != old.cutscenePlaying)
    {
        vars.Log("Cutscene: " + current.cutscenePlaying.ToString());
    }

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
    return vars.introWatched && current.LevelName == "Map" && current.inventoryInitialised;
}

split
{
    if (current.activeScene == "Map_2" && vars.level == 1) {
        vars.level++;
        return true;
    }

    if (current.activeScene == "Map_3" && vars.level == 2) {
        vars.level++;
        return true;
    }

    if (current.activeScene == "Lab" && vars.level == 3) {
        vars.level++;
        return true;
    }

    if (current.activeScene == "Terrace" && vars.level == 4) {
        return true;
    }
}

isLoading
{
    return !current.inventoryInitialised || (current.cutscenePlaying == 1 && vars.level == 2);
}

reset
{
    return old.activeScene != "MainMenu" && current.activeScene == "MainMenu";
}

onReset
{
    vars.level = 0;
    vars.introWatched = false;
}

onStart
{
    vars.level = 1;
}