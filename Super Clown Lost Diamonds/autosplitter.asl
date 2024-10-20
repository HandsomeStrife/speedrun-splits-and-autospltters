state("Clown2-Win64-Shipping")
{
    int gameState : 0x4348B20;
}

init {
    vars.level = 0;
    vars.in_level = false;
}

update
{
    if (current.gameState >= 2400) {
        vars.in_level = true;
    }
    if (current.gameState == 2389) {
        vars.in_level = false;
    }
}

start
{
    return old.gameState != 2390 && current.gameState == 2390;
}


split
{
    // Any time you return to the overworld from being in a level, split. Unless its from the main menu.
    if (old.gameState < 2390) {
        return false;
    }
    if (vars.in_level && current.gameState == 2390) {
        vars.in_level = false;
        return true;
    }
    return false;
}

onReset
{
    vars.in_level = false;
}