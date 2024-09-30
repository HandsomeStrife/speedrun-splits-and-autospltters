state("DarkApes")
{
    byte level: 0x16E18;
    byte loading: 0x16AB4;
}

isLoading
{
    return current.loading == 1;
}

start
{
    return current.level != 0;
}

split
{
    return current.level > old.level;
}

reset
{
    return current.level == 0;
}
