state("UnrealGame-Win64-Shipping")
{
	int stateChange: 0x68D9240;
}

update
{
    print(current.stateChange.ToString());
}

start
{
    return old.stateChange == 1512 && current.stateChange != 1512;
}

split
{
    return current.stateChange != old.stateChange && current.stateChange != 1512 && current.stateChange != 1529 && old.stateChange != 1512 && old.stateChange != 1529;
}