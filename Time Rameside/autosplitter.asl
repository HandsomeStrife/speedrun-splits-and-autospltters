state("ShooterGame-Win32-Shipping")
{
  string64 map : 0x1C4E024, 0x35C, 0x0;
}

init
{
    vars.level = 0;
}

update
{
    // if (current.map != null) {
    //     print(current.map.ToString());
    //     print(vars.level.ToString());
    // }
}

isLoading
{
    return current.map == null;
}

start
{
    return (old.map == "ShooterEntry" || old.map == "/Game/Maps/menu3")
            && current.map == null;
}

onStart
{
    timer.IsGameTimePaused = true;
    vars.level = 1;
}

onReset
{
    vars.level = 0;
}

split
{
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && current.map == "/Game/Maps/hallway") {
        vars.level = 2;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && current.map == "/Game/Maps/hallway5") {
        vars.level = 3;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && current.map == "/Game/Maps/beginninggame") {
        vars.level = 4;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && current.map == "/Game/Maps/masterlevel1stlevel") {
        vars.level = 5;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && current.map == "/Game/Maps/building") {
        vars.level = 6;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && (current.map == "/Game/Maps/City" || current.map == "/Game/Maps/city")) {
        vars.level = 7;
        return true;
    }
    if ((old.map == null || old.map == "/Engine/Maps/Entry") && (current.map == "/Game/Maps/Sewers" || current.map == "/Game/Maps/sewers")) {
        vars.level = 8;
        return true;
    }
    if (vars.level == 8 && (current.map == "ShooterEntry" || current.map == "/Game/Maps/menu3")) {
        vars.level = 0;
        return true;
    }
}
