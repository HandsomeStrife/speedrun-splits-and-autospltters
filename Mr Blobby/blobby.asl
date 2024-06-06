state("retroarch")
{
    byte levelId : "dosbox_pure_libretro.dll", 0xDF7C40, 0xBFCC;
}

start
{
    return current.levelId == 58;
}

split
{
    return current.levelId != 58;
}

reset
{
  return current.levelId == 0;
}

gameTime
{
    return TimeSpan.FromSeconds(3);
}
