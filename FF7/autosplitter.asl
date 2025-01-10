state("LiveSplit")
{
    byte tmp: 0x0;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/emu-help-v2")).CreateInstance("PS1");
    vars.Helper.Load = (Func<dynamic, bool>)(emu => 
    {
        emu.Make<byte>("GameStarted", 0x8009d89f);
        emu.Make<uint>("IGT", 0x8009D264);
        emu.Make<byte>("GameMoment", 0x8009D288);
        emu.Make<byte>("StepID", 0x8009C540);
        emu.Make<byte>("StepFraction", 0x8009C6D8);
        emu.Make<byte>("ExitBattleStatus", 0x800F83C6);
        emu.Make<byte>("CurrentField", 0x8009A05C);
        return true;
    });

    settings.Add("GS_B", true, "Guard Scorpion");
    settings.Add("S7", true, "Arrive in Sector 7");
    settings.Add("GS", true, "Guard Skip");
    settings.Add("APS_B", true, "Aps");
    settings.Add("SWRS", true, "Sewers");
    settings.Add("TGY", true, "Train Graveyard");
    settings.Add("RENO_B", true, "Reno");
    settings.Add("MG_B", true, "Mighty Grunts");
    settings.Add("SH_B", true, "Sample:H0512");
    settings.Add("GUN_B", true, "Gunners");
    settings.Add("RUFUS_B", true, "Rufus");
    settings.Add("MB_B", true, "Motor Ball");

    vars.CompletedSplits = new HashSet<string>();
}

start
{
    return current.GameStarted == 1 && old.GameStarted == 0;
}

update
{
    if (old.CurrentField != current.CurrentField) {
        print("CurrentField: " + current.CurrentField.ToString());
    }
    if (old.GameMoment != current.GameMoment) {
        print("GameMoment: " + current.GameMoment.ToString());
    }
    if (old.ExitBattleStatus != current.ExitBattleStatus) {
        print("ExitBattleStatus: " + current.ExitBattleStatus.ToString());
    }
}

split
{
    if (current.GameMoment == 15 && current.ExitBattleStatus == 32) {
        return settings["GS_B"] && vars.CompletedSplits.Add("GS_B");
    }

    if (current.CurrentField == 146 && old.CurrentField != 146) {
        return settings["S7"] && vars.CompletedSplits.Add("S7");
    }

    if (current.CurrentField == 192 && old.CurrentField == 156) {
        return settings["GS"] && vars.CompletedSplits.Add("GS");
    }

    if (current.GameMoment == 206 && current.ExitBattleStatus == 32) {
        return settings["APS_B"] && vars.CompletedSplits.Add("APS_B");
    }

    if (current.CurrentField == 144 && old.CurrentField == 213) {
        return settings["SWRS"] && vars.CompletedSplits.Add("SWRS");
    }

    if (current.CurrentField == 146 && old.CurrentField == 145) {
        return settings["TGY"] && vars.CompletedSplits.Add("TGY");
    }

    if (current.GameMoment == 221 && current.ExitBattleStatus == 32) {
        return settings["RENO_B"] && vars.CompletedSplits.Add("RENO_B");
    }

    if (current.GameMoment == 260 && current.ExitBattleStatus == 32) {
        return settings["MG_B"] && vars.CompletedSplits.Add("MG_B");
    }

    if (current.GameMoment == 278 && current.ExitBattleStatus == 32) {
        return settings["SH_B"] && vars.CompletedSplits.Add("SH_B");
    }

    if (current.GameMoment == 311 && current.ExitBattleStatus == 32) {
        return settings["GUN_B"] && vars.CompletedSplits.Add("GUN_B");
    }

    if (current.GameMoment == 314 && current.ExitBattleStatus == 32) {
        return settings["RUFUS_B"] && vars.CompletedSplits.Add("RUFUS_B");
    }

    if (current.GameMoment == 332 && current.ExitBattleStatus == 32) {
        return settings["MB_B"] && vars.CompletedSplits.Add("MB_B");
    }

}