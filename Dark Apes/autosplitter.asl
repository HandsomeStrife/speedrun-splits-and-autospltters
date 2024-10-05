state("DarkApes")
{
    byte cutscene: "visionP71.dll", 0x15807B;
    byte loading: 0x16AB4;
    byte deathsScreencheck: "visionP71.dll", 0x261F20;
}

isLoading
{
    return current.loading == 1;
}

start
{
    return old.cutscene == 0 && current.cutscene == 1;
}

split
{
    return old.cutscene == 0 && current.cutscene == 1 && current.deathsScreencheck != 79;
}

