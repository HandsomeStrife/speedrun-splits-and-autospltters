state("Christmas Hell")
{
    byte isLoading: 0x23DFD7C;
    byte level: 0x23D48C8, 0x0;
    byte started: 0x23D20BC;
    byte scene: 0x23DD6B0, 0xB8, 0xBE8;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Christmas Hell";
    vars.currentLevel = 0;
    vars.Helper.AlertLoadless();
}


start
{
    return old.started == 0 && current.started != 0;
}

isLoading
{
    return current.isLoading == 1;
}

reset
{
    return old.level != 4 && current.level == 4;
}

split
{
    return old.scene != 21 && current.scene == 21;
}

onSplit
{
    vars.currentLevel++;
}

onStart
{
    vars.currentLevel = 1;
}

onReset
{
    vars.currentLevel = 0;
}
