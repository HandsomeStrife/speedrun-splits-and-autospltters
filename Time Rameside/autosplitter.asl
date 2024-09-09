state("ShooterGame-Win32-Shipping")
{
    byte level: 0x1C5023C, 0xA8, 0x4E0, 0x4C8;
}

isLoading
{
    return current.level == 0;
}

start
{
    return old.level == 234 && current.level == 0;
}

onStart
{
    timer.IsGameTimePaused = true;
}

split
{
    if (old.level == 0 && current.level == 221) {
        return true;
    }

    if (old.level == 0 && current.level == 96) {
        return true;
    }

    if (old.level == 0 && current.level == 67) {
        return true;
    }

    if (old.level == 0 && current.level == 92) {
        return true;
    }

    if (old.level == 0 && current.level == 178) {
        return true;
    }

    if (old.level == 0 && current.level == 98) {
        return true;
    }

    if (old.level == 0 && current.level == 207) {
        return true;
    }

    if (old.level == 0 && current.level == 234) {
        return true;
    }
}
