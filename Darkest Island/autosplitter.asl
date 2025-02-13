state("Data") {
    string64 level: "Enhancements.dll", 0x2E9FB;
    byte one_when_loading_part_one: 0x111CC, 0x7F8;
    byte one_when_loading_part_two: 0x111CC, 0x804;
    uint status_indicator: 0x11188;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Darkest Island";
    vars.Helper.AlertLoadless();
}

init {
    vars.switching_exes = false;
}

start {
    return old.status_indicator == 19769 && (current.status_indicator == 11301 || current.status_indicator == 11287);
}

update {
    if (current.level != old.level) {
        print(current.level);
    }
}

split {
    // First do the basic validation checks
    if (old.level == null || !old.level.ToLower().StartsWith("level") || !old.level.ToLower().EndsWith(".zip")) {
        return false;
    }

    if (current.level == "level1.zip" && vars.switching_exes) {
        vars.switching_exes = false;
    }

    if (current.level == "level5.zip" && current.status_indicator == 19999 && !vars.switching_exes) {
        vars.switching_exes = true;
        return true;
    }

    // If level hasn't changed, don't split
    if (current.level == old.level) {
        return false;
    }

    // Extract level numbers using string operations
    string oldNum = old.level.ToLower().Replace("level", "").Replace(".zip", "");
    string newNum = current.level.ToLower().Replace("level", "").Replace(".zip", "");

    // Try to parse the numbers
    int oldLevel, newLevel;
    if (int.TryParse(oldNum, out oldLevel) && int.TryParse(newNum, out newLevel)) {
        // Only split if new level is exactly one more than old level
        return newLevel == oldLevel + 1;
    }

    return false;
}

isLoading {
    return current.one_when_loading_part_one == 1
    || current.one_when_loading_part_two == 1
    || current.level == null
    || vars.switching_exes;
}

onStart {
    timer.IsGameTimePaused = true;
}

onReset {
    vars.LevelList.Clear();
}
