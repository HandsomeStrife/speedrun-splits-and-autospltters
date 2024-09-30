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
    if (current.map != null && old.map != current.map) {
        print(current.map.ToString());
    }
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
    if (current.map == null) return false;

    string oldMapLower = old.map != null ? old.map.ToLower() : null;
    string currentMapLower = current.map.ToLower();

    if ((oldMapLower == null || oldMapLower == "/engine/maps/entry") && currentMapLower == "/game/maps/hallway") {
        vars.level = 2;
        return true;
    }
    if (oldMapLower != "/game/maps/hallway5" && currentMapLower == "/game/maps/hallway5") {
        vars.level = 3;
        return true;
    }
    if (oldMapLower != "/game/maps/beginninggame" && currentMapLower == "/game/maps/beginninggame") {
        vars.level = 4;
        return true;
    }
    if (oldMapLower != "/game/maps/masterlevel1stlevel" && currentMapLower == "/game/maps/masterlevel1stlevel") {
        vars.level = 5;
        return true;
    }
    if (oldMapLower != "/game/maps/building" && currentMapLower == "/game/maps/building") {
        vars.level = 6;
        return true;
    }
    if (oldMapLower != "/game/maps/city" && currentMapLower == "/game/maps/city") {
        vars.level = 7;
        return true;
    }
    if (oldMapLower != "/game/maps/sewers" && currentMapLower == "/game/maps/sewers") {
        vars.level = 8;
        return true;
    }
    if (vars.level == 8 && (currentMapLower == "shooterentry" || currentMapLower == "/game/maps/menu3")) {
        vars.level = 0;
        return true;
    }
}

