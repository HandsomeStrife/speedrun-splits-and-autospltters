state("Moldbreaker")
{}

state("Moldbreaker Rise of the Loaf")
{}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Moldbreaker: Rise of the Loaf";
    vars.Helper.LoadSceneManager = true;
    vars.initial = false;
}

init
{
    vars.completedLevels = new List<string>();
    old.activeScene = null;
    old.loadingScene = null;
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? old.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? old.loadingScene;
}

start
{
    return old.activeScene == "Menu" && current.activeScene == "Loading";
}

split
{
    if (old.loadingScene == "PARKOUR_1" && current.loadingScene == "ENTRANCE_1" && !vars.completedLevels.Contains("PARKOUR_1"))
    {
        vars.completedLevels.Add("PARKOUR_1");
        return true;
    }

    if (old.loadingScene == "PARKOUR_2" && current.loadingScene == "ENTRANCE_2" && !vars.completedLevels.Contains("PARKOUR_2"))
    {
        vars.completedLevels.Add("PARKOUR_2");
        return true;
    }

    if (old.loadingScene == "PARKOUR_3" && current.loadingScene == "CREDITS" && !vars.completedLevels.Contains("PARKOUR_3")) 
    {
        vars.completedLevels.Add("PARKOUR_3");
        return true;
    }
}

isLoading
{
    return current.activeScene == "Loading";
}

onReset
{
    vars.completedLevels = new List<string>();
}
