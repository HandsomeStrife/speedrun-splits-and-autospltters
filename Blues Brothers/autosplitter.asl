state("retroarch")
{
    byte started: "mesen_libretro.dll", 0x126ACA, 0x0;
}

init
{
    print(current.started.ToString());
}
