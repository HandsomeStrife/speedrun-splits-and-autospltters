state("EMULATOR")
{
    byte level_identifier_one: "EMULATOR.EXE", 0x1AA8B4, 0x1E;
    byte level_identifier_two: "EMULATOR.EXE", 0xCF0060;
}

split
{
    return current.level_identifier_one != 0 && current.level_identifier_one != 17 && current.level_identifier_one != old.level_identifier_one;
}
