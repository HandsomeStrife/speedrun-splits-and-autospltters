state("retroarch")
{
    byte levelId : "dosbox_pure_libretro.dll", 0xDF7C40, 0xBFCC;
}

split
{
    return current.levelId == 60;
}

