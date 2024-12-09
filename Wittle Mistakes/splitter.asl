state("TheGameWeAreMaking")
{
    byte started: 0x7188C4D;
    byte isLoading: 0x730AF48;
}

start
{
    return old.started != 0 && current.started == 0;
}

isLoading
{
    return current.isLoading != 0;   
}

split
{
    
}

reset
{
    return old.started == 0 && current.started != 0;
}
