state("Mr Sanna Clozz")
{
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Mr Sanna Clozz";
    print("Startup");
    // vars.Helper.LoadSceneManager = true;
    vars.initial = false;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        // Use MakeList to create a manageable list from the pointer structure
        vars.Helper["levelsRaw"] = mono.MakeList<IntPtr>("global", "gInstance", "allLevels");
        vars.Helper["justLeftLevel"] = mono.MakeString("global", "gInstance", "justLeftLevel");
        vars.Helper["enteredHub"] = mono.MakeString("global", "gInstance", "GAME_enteredHub");
        vars.Helper["leavingHubworld"] = mono.MakeString("global", "gInstance", "leavingHubworld");
        return true;
    });

    current.levelsCompleted = 0;
    current.portalsOpened = 0;
    current.justLeftLevel = "";
}

update
{
    // Access the raw list created in `init`
    current.levelsCompleted = ((List<IntPtr>)current.levelsRaw)
        .Select(address =>
        {
            // Read the `completed` field from the structure
            return vars.Helper.Read<bool>(address + 0x1C); // Adjust offset if needed
        })
        .Count(isCompleted => isCompleted); // Adjust condition based on "completed" definition
    if (current.levelsCompleted != old.levelsCompleted)
    {
        vars.Log("Levels completed: " + current.levelsCompleted);
    }

    current.portalsOpened = ((List<IntPtr>)current.levelsRaw)
        .Select(address =>
        {
            // Read the `opened` field from the structure
            return vars.Helper.Read<bool>(address + 0x1D); // Adjust offset if needed
        })
        .Count(isOpened => isOpened); // Adjust condition based on "opened" definition
    if (current.portalsOpened != old.portalsOpened)
    {
        vars.Log("Portals opened: " + current.portalsOpened);
    }

    if (current.justLeftLevel != old.justLeftLevel)
    {
        vars.Log("Just left level: " + current.justLeftLevel);
    }
}


