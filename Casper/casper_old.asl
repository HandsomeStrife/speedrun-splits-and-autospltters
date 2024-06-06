state("pcsx2-qt")
{
    byte loaded: "pcsx2-qt.exe", 0x2E8F04C;
    byte level_1_items: "pcsx2-qt.exe",     0x2FD0F10, 0xB36890;
    byte level_2_pickups: "pcsx2-qt.exe",   0x2FD0F10, 0x17411F8;
    byte level_3_laps: "pcsx2-qt.exe",      0x2FD0F10, 0x8479A4;
    byte level_4_laps: "pcsx2-qt.exe",      0x2FD0F10, 0x7F46B0;
    byte level_5_laps: "pcsx2-qt.exe",      0x2FD0F10, 0x11A3528;
    byte level_6_arches: "pcsx2-qt.exe",    0x2FD0F10, 0x1BCCA6C;
}

init
{
    vars.game_started = 0;
    vars.loading = 0;
    vars.level = 1;
}

update
{
    if (vars.game_started != 1 && current.level_1_items == 0 && current.loaded == 1)
    {
        vars.game_started = 1;
    }
}

start
{
    return vars.game_started == 1;
}

onReset
{
    vars.game_started = 0;
    vars.loading = 0;
    vars.level = 1;
}

split
{
    if (vars.game_started == 1)
    {
        if (current.loaded == 1 && vars.loading == 1)
        {
            print("Splitting");
            vars.loading = 0;
            vars.level++;
            return true;
        }

        if (vars.loading == 0)
        {
            if (vars.level == 1 && current.level_1_items == 30)
            {
                print("yoho");
                vars.loading = 1;
                return true;
            }
            if (vars.level == 2 && current.level_2_pickups == 6)
            {
                vars.loading = 1;
                return true;
            }
            if (vars.level == 3 && current.level_3_laps == 4)
            {
                vars.loading = 1;
                return true;
            }
            if (vars.level == 4 && current.level_4_laps == 4)
            {
                vars.loading = 1;
                return true;
            }
            if (vars.level == 5 && current.level_5_laps == 4)
            {
                vars.loading = 1;
                return true;
            }
            if (vars.level == 6 && current.level_6_arches == 0 && old.level_6_arches == 44)
            {
                vars.loading = 1;
                return true;
            }
        }
    }
    return false;
}