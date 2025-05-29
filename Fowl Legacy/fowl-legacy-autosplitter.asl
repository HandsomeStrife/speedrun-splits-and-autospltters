state("Fowl Legacy")
{}

init
{
    old.activeScene = null;
    old.loadingScene = null;
    
    // Initialize stage variables explicitly
    old.stage1_1 = false;
    old.stage1_2 = false;
    old.stage1_3 = false;
    old.stage2_1 = false;
    old.stage2_2 = false;
    old.stage2_3 = false;
    old.stage3_1 = false;
    old.stage3_2 = false;
    old.stage3_3 = false;
    old.stage4_1 = false;
    old.stage4_2 = false;
    old.stage4_3 = false;
    old.stage5 = false;
    
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        // Set up stage variable lookups using loops
        for (int stage = 1; stage <= 4; stage++) {
            for (int collectible = 1; collectible <= 3; collectible++) {
                string varName = "stage" + stage + "_" + collectible;
                vars.Helper[varName] = mono.Make<bool>("PlayerCollectibleManager", "instance", varName);
            }
        }
        vars.Helper["stage5"] = mono.Make<bool>("PlayerCollectibleManager", "instance", "stage5");
        return true;
    });
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Fowl Legacy";
    vars.Helper.LoadSceneManager = true;
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? old.activeScene; 

    if (old.activeScene != current.activeScene) {
        vars.Log(current.activeScene);
    }
}

start
{
    return old.activeScene == "Main Menu" && current.activeScene == "Stage 0 - Tutorial";
}

split
{
    // Stage 1 collectibles
    if (old.stage1_1 == false && current.stage1_1 == true) return true;
    if (old.stage1_2 == false && current.stage1_2 == true) return true;
    if (old.stage1_3 == false && current.stage1_3 == true) return true;
    
    // Stage 2 collectibles
    if (old.stage2_1 == false && current.stage2_1 == true) return true;
    if (old.stage2_2 == false && current.stage2_2 == true) return true;
    if (old.stage2_3 == false && current.stage2_3 == true) return true;
    
    // Stage 3 collectibles
    if (old.stage3_1 == false && current.stage3_1 == true) return true;
    if (old.stage3_2 == false && current.stage3_2 == true) return true;
    if (old.stage3_3 == false && current.stage3_3 == true) return true;
    
    // Stage 4 collectibles
    if (old.stage4_1 == false && current.stage4_1 == true) return true;
    if (old.stage4_2 == false && current.stage4_2 == true) return true;
    if (old.stage4_3 == false && current.stage4_3 == true) return true;

    if (old.stage5 == false && current.stage5 == true) return true;
    
    return false;
}

reset
{
    return current.activeScene == "Main Menu" && old.activeScene != "Main Menu";
}