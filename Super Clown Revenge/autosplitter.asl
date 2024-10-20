state("clown3-Win64-Shipping")
{
    int started: 0x44ECAD0;
    int overworld: 0x44EF56C;
}

init 
{
    vars.in_level = false;
}

update
{
    if (current.overworld == 5 && current.started != 1) {
        vars.in_level = true;
    }
    if (current.started == 1) {
        vars.in_level = false;
    }
}

start 
{
    return old.started == 1 && current.started == 2;
}

split
{
    if (vars.in_level && current.overworld == 15 && old.overworld != current.overworld) {
        vars.in_level = false;
        return true;
    }
    return false;
}

onReset
{
    vars.in_level = false;
}