state("BearlyDelivered")
{
    byte gameStarted: 0x5CB22EC;
    byte loadingIndicator: 0x5CB5C00, 0x900, 0x0, 0x1D8;
    byte level: 0x5CAF540, 0x310, 0x188, 0x18, 0x68, 0x28, 0x38;
}

start
{
    return old.gameStarted == 4 && current.gameStarted == 7;
}

split
{
    return (old.level != current.level && current.level > 0) || (current.level == 20 && current.gameStarted == 4)
}

isLoading
{
    return current.loadingIndicator == 1;
}

reset
{
    return old.gameStarted != 4 && current.gameStarted == 4 && current.level != 20;
}