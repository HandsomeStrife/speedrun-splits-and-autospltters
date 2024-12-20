state("Christmas Hell")
{
    byte started: 0x23D20BC;
    byte isLoading: 0x23DFD7C;
    byte mainMenu: 0x23D48C8, 0x0;
    byte missionAccomplished: 0x23CE238, 0x538, 0x24;
    byte presentCounter: 0x023D7BC0, 0x100, 0x108, 0x10, 0x58, 0x20, 0x8;
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
    return old.mainMenu != 4 && current.mainMenu == 4;
}

split
{
    return (old missionAccomplished != 21 && current missionAccomplished == 21) || (vars.currentLevel == 6 && current.presentCounter == 3);
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
