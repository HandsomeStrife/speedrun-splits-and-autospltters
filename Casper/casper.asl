state("pcsx2-qt")
{
    byte loaded: "pcsx2-qt.exe", 0x1445560, 0x193A0;
    byte level_6_arches: "pcsx2-qt.exe", 0x2FD0F10, 0x1BCCA6C;
}

start
{
    return current.loaded == 64;
}

reset
{
    return current.loaded == 0;
}

split
{
    if (current.loaded != old.loaded) {
        if (old.loaded == 136 && current.loaded == 96) {
            return true;
        }
        if (old.loaded == 64 && current.loaded == 136) {
            return true;
        }
    }
    if (current.level_6_arches == 0 && old.level_6_arches == 44) {
        return true;
    }
    return false;
}
