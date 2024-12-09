state("Abermore"){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Abermore";
    vars.Helper.LoadSceneManager = true;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        //MissionManager
        vars.Helper["missionTitle"] = mono.MakeString("MissionManager", "instance", "missionTitle");
        return true;
    });
    old.activeScene = "";
    old.loadingScene = "";
    old.missionTitle = "";
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

    if (current.missionTitle != old.missionTitle)
    {
        vars.Log("Mission: " + current.missionTitle);
    }
}