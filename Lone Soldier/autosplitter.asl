state("LiveSplit") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).CreateInstance("PS1");

    vars.Helper.Load = (Func<dynamic, bool>)(emu => 
    {
        emu.Make<byte>("Level", 0x80084014);
        emu.Make<byte>("Loading", 0x8006b990);
        return true;
    });

    vars.latestLevel = 0;
}

start
{
    return current.Level == 0 && old.Level == 255;
}

split
{
    if (current.Level != 0 
        && current.Level < 56
        && current.Level != vars.latestLevel 
        && current.Loading == 3)
    {
        print(vars.latestLevel.ToString());
        vars.latestLevel = current.Level;
        print(vars.latestLevel.ToString());
        return true;
    }
    return false;
}

reset
{
    return current.Level == 56;
}