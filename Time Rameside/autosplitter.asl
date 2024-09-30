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
    if ((old.map == null || old.map.ToLower() == "/engine/maps/entry") && current.map != null && current.map.ToLower() == "/game/maps/hallway") {
        vars.level = 2;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/hallway5" && current.map != null && current.map.ToLower() == "/game/maps/hallway5") {
        vars.level = 3;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/beginninggame" && current.map != null && current.map.ToLower() == "/game/maps/beginninggame") {
        vars.level = 4;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/masterlevel1stlevel" && current.map != null && current.map.ToLower() == "/game/maps/masterlevel1stlevel") {
        vars.level = 5;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/building" && current.map != null && current.map.ToLower() == "/game/maps/building") {
        vars.level = 6;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/city" && current.map != null && current.map.ToLower() == "/game/maps/city") {
        vars.level = 7;
        return true;
    }
    if (old.map != null && old.map.ToLower() != "/game/maps/sewers" && current.map != null && current.map.ToLower() == "/game/maps/sewers") {
        vars.level = 8;
        return true;
    }
    if (vars.level == 8 && current.map != null && (current.map.ToLower() == "shooterentry" || current.map.ToLower() == "/game/maps/menu3")) {
        vars.level = 0;
        return true;
    }
}

