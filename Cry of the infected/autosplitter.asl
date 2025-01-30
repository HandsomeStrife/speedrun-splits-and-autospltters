state("COTI") {
    string64 level: "EnhancementsFREE.dll", 0xCDD13;
    byte zero_when_loading: "DBProODEDebug.dll", 0x77A98;
    byte menu_loaded: 0x17428;
}

startup {
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Cry of the Infected";
    vars.Helper.AlertLoadless();
}

update {
    if (old.menu_loaded != current.menu_loaded) {
        print(current.menu_loaded.ToString());
    }
}

start {
    return old.menu_loaded < 100 && current.menu_loaded > 100;
}

split {
    if (old.level == null || !old.level.ToLower().StartsWith("level") || !old.level.ToLower().EndsWith(".zip")) {
        return false;
    }
    return current.level != old.level;
}

isLoading {
    return current.zero_when_loading == 0;
}

onStart {
    timer.IsGameTimePaused = true;
}
