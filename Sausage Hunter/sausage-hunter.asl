state("Sausage Hunter")
{
    byte level: "Sausage Hunter.exe", 0x64E608
}v

state("Hand_Cat (3)")
{
    byte level: "Hand_Cat (3).exe", 0x64E608
}

update
{
    print(current.level.ToString());
}

start
{
    return current.level == 1;
}

split
{
    return current.level > 1 && current.level > old.level;
}