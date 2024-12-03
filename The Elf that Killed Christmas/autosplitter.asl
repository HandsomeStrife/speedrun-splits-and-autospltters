state("xmas", "The Elf Who Killed Christmas")
{
    int level: 0xC82290;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "The Elf Who Killed Christmas";
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var ls = mono["LevelContext"];
        vars.Helper["NextLevelName"] = ls.MakeString("_current", "NextLevelName");
        return true;
    });
}

start
{
    return current.level == 1 && old.level == 0;
}

split
{
    return current.level != old.level && current.level > 1 || current.NextLevelName == "Intro";
}

reset
{
    return current.level == 0 && old.level != 0;
}