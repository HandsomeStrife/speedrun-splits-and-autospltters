state("Clown2-Win64-Shipping")
{
    int gameState : 0x43485D8;
    int otherGameState: 0x4348B20;
}

init {
    vars.level = 0;
    vars.in_level = false;
}

update
{
    if (current.gameState != 6 && current.gameState != 2 && current.gameState != 0) {
        vars.in_level = true;
    }
    if (current.gameState != old.gameState) {
        print(current.gameState.ToString());
    }
}

start
{
    return old.gameState == 0 && current.gameState == 6;
}

split
{
    if (vars.in_level && current.gameState == 2) {
        vars.in_level = false;
        return false;
    }
    if (vars.in_level && current.gameState == 6) {
        vars.in_level = false;
        return true;
    }
    return false;
}

onReset
{
    vars.in_level = false;
}