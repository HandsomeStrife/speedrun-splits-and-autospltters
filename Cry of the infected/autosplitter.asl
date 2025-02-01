state("COTI") {
    string64 level: "EnhancementsFREE.dll", 0xCDD13;
    byte zero_when_loading: "DBProODEDebug.dll", 0x77A98;
    byte menu_loaded: 0x17428;
    uint status_indicator: 0x17428;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Cry of the Infected";
    vars.Helper.AlertLoadless();
}

start {
    return old.status_indicator == 21585 && current.status_indicator == 12422;
}

split {
    // Check for final split condition
    if (current.level != null && current.level.ToLower() == "level13.zip" && current.status_indicator == 21818 && old.status_indicator != 21818) {
        return true;
    }

    // First do the basic validation checks
    if (old.level == null || !old.level.ToLower().StartsWith("level") || !old.level.ToLower().EndsWith(".zip")) {
        return false;
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
    return current.zero_when_loading == 0;
}

onStart {
    timer.IsGameTimePaused = true;
}
