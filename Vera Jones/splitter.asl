state("ClimberGirl")
{
    byte loading : 0x264F24;
    byte level : 0x2638E0;
    byte menu_open: 0x25DB79;
    byte press_any_key: 0x26CC65;
}

start
{
    return old.press_any_key > 0 && current.press_any_key == 0;
}

isLoading
{
    return current.loading == 0;
}

split
{
    return old.level != current.level;
}
