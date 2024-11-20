state("Santa is Real")
{
    int CurrentLevel: "mono-2.0-bdwgc.dll", 0x007390F8, 0x70, 0xAD0, 0xD8;
    byte InHouse: "UnityPlayer.dll", 0x01E050C8, 0x30, 0xFA0, 0x184;
    byte LevelFinished: "UnityPlayer.dll", 0x01F03148, 0x50, 0xFA4;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    vars.currentScene = null;
    vars.isLoading = false;
    vars.Helper.AlertLoadless();
}

update
{
    if (current.CurrentLevel != old.CurrentLevel) {
        vars.Log("Level: " + current.CurrentLevel.ToString());
    }
    if (current.LevelFinished != old.LevelFinished) {
        vars.Log("Level Finished: " + current.LevelFinished.ToString());
    }
    if (current.InHouse != old.InHouse) {
         vars.Log("In House: " + current.InHouse.ToString());
    }
}

isLoading
{
    return vars.Helper.IsLoading;
}

start
{
    return old.CurrentLevel == 0 && current.CurrentLevel == 1;
}

split
{
    return old.LevelFinished == 0 && current.LevelFinished == 1 && old.InHouse == 1;
}

reset
{
    return old.CurrentLevel != 0 && current.CurrentLevel == 0;
}