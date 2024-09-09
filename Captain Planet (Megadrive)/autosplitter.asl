state("Fusion")
{
    byte started_indicator: 0x1A1738;
    byte level_indicator: 0xE714035;
    byte difficulty: 0x276244;
    byte on_off_toggle: 0x1B6F8A;
}

start
{
    return old.started_indicator == 4 && current.started_indicator == 0 && current.difficulty == 49;
}
