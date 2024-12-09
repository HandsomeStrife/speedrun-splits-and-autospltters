state("SuperClownAdventures-Win64-Shipping")
{
    int startState : 0x43A8960;
    int gameState : 0x44DE184;
}

update
{
    if (current.gameState != null && old.gameState != current.gameState) {
        print(current.gameState.ToString());
    }
    if (current.startState != null && old.startState != current.startState) {
        //print(current.startState.ToString());
    }
}

start
{
    return old.startState == 2384 && current.startState == 2383;
}

split
{
    if (old.gameState != 3 && current.gameState == 3) {
        return true;
    }
    return false;
}