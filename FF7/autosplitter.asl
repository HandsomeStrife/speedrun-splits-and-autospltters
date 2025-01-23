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

    // Define battle splits (GameMoment + ExitBattleStatus checks)
    vars.BattleSplits = new Dictionary<int, string> {
        {15, "GS_B"},     // Guard Scorpion
        {206, "APS_B"},   // Aps
        {221, "RENO_B"},  // Reno
        {260, "MG_B"},    // Mighty Grunts
        {278, "SH_B"},    // Sample:H0512
        {311, "GUN_B"},   // Gunners
        {314, "RUFUS_B"}, // Rufus
        {332, "MB_B"}     // Motor Ball
    };

    // Define field transition splits (CurrentField changes)
    vars.FieldSplits = new Dictionary<string, string> {
        {"146:any", "S7"},           // Arrive in Sector 7
        {"192:156", "GS"},          // Guard Skip
        {"144:213", "SWRS"},        // Sewers
        {"146:145", "TGY"}          // Train Graveyard
    };
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
    // Check battle-based splits
    if (current.ExitBattleStatus == 32 && vars.BattleSplits.ContainsKey(current.GameMoment))
    {
        string splitId = vars.BattleSplits[current.GameMoment];
        if (!vars.CompletedSplits.Contains(splitId) && settings[splitId] && vars.CompletedSplits.Add(splitId))
        {
            return true;
        }
    }

    // Check field transition splits
    string currentTransition = current.CurrentField + ":" + old.CurrentField;
    string anyTransition = current.CurrentField + ":any";
    
    if (vars.FieldSplits.ContainsKey(currentTransition))
    {
        string splitId = vars.FieldSplits[currentTransition];
        if (!vars.CompletedSplits.Contains(splitId) && settings[splitId] && vars.CompletedSplits.Add(splitId))
        {
            return true;
        }
    }
    else if (vars.FieldSplits.ContainsKey(anyTransition))
    {
        string splitId = vars.FieldSplits[anyTransition];
        if (!vars.CompletedSplits.Contains(splitId) && settings[splitId] && vars.CompletedSplits.Add(splitId))
        {
            return true;
        }
    }

    return false;
}