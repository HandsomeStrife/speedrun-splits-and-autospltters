state("The_Dev-Win64-Shipping")
{
    byte started: 0x6BB1A55;
    byte noClue: 0x6B38898;
}

init
{
    vars.level = 0;
}

onStart
{
    vars.level = 1;
}

start
{
    return current.started != old.started;
}

split
{
    if (vars.level >= 4 && old.noClue != current.noClue) {
        vars.level = vars.level + 1;
        return true;
    }

    if (old.noClue == 1 && current.noClue == 2) {
        vars.level = vars.level + 1;
        return true;
    }
}

