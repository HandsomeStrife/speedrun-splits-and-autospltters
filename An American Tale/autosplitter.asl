state("LiveSplit") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).CreateInstance("PS2");

    vars.Helper.Load = (Func<dynamic, bool>)(emu => 
    {
        emu.Make<byte>("DoSplit", 0x5BECFB);
        emu.Make<byte>("Started", 0x3FC394);
        emu.Make<byte>("Loading", 0x33805E);
        return true;
    });

    vars.sixtysix_seen = false;
}

update
{
    print(vars.sixtysix_seen.ToString());
    if (old.DoSplit == 66 && current.DoSplit == 0 && old.Started == 1) {
        vars.sixtysix_seen = true;
    }
}

start
{
    return old.Started == 0 && current.Started == 1;
}

split
{
    return old.DoSplit == 0 && current.DoSplit != 0 && old.Started == 1 && vars.sixtysix_seen;
}


