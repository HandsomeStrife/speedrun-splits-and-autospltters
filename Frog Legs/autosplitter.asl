state("FPSCPP-Win64-Shipping")
{
    // Define the world pointer directly in the state
    ulong worldPtr : 0x6831510;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "Frog Legs";
}

init
{
    var baseAddress = modules.First().BaseAddress;
    vars.Log("Module base: " + baseAddress.ToString("X"));
    
    // Get FNames address for name resolution
    IntPtr fNames = IntPtr.Zero;
    
    try {
        fNames = vars.Helper.ScanRel(13, "89 5C 24 ?? 89 44 24 ?? 74 ?? 48 8D 15");
        vars.Log("Found FNames via signature: " + (fNames != IntPtr.Zero ? "YES - " + fNames.ToString("X") : "NO"));
    } catch (Exception e) {
        vars.Log("FNames signature scan failed: " + e.Message);
    }
    
    // If signature scan fails, fall back to offset from GUETool
    if (fNames == IntPtr.Zero) {
        fNames = baseAddress + 0x6635800;
        vars.Log("Using FNames from offset: " + fNames.ToString("X"));
    }
    
    vars.FNames = fNames;
    
    // Define the FName conversion function
    vars.FNameToString = (Func<ulong, string>)(fName =>
    {
        try {
            if (fName == 0) return "None";
            
            var nameIdx = (fName & 0x000000000000FFFF) >> 0x00;
            var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
            var number = (fName & 0xFFFFFFFF00000000) >> 0x20;
            
            if (nameIdx > 100000 || chunkIdx > 1000) {
                return "Invalid";
            }

            IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
            if (chunk == IntPtr.Zero) {
                return "None";
            }
            
            IntPtr entry = chunk + (int)nameIdx * sizeof(short);
            
            short header = vars.Helper.Read<short>(entry);
            int length = header >> 6;
            if (length <= 0 || length > 1024) {
                return "Invalid";
            }
            
            string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));
            return number == 0 ? name : name + "_" + number;
        }
        catch (Exception e) {
            vars.Log("FNameToString error: " + e.Message);
            return "Error";
        }
    });
    
    // Function to get a UObject name - the correct way to read the world name
    vars.GetUObjectName = (Func<ulong, string>)(objPtr =>
    {
        try {
            if (objPtr == 0) return "None";
            
            // In UE5, UObject name is stored at offset 0x18
            ulong nameValue = vars.Helper.Read<ulong>((IntPtr)objPtr + 0x18);
            return vars.FNameToString(nameValue);
        }
        catch (Exception e) {
            vars.Log("GetUObjectName error: " + e.Message);
            return "Error";
        }
    });
    
    current.World = null;
    
    // Do an initial read of the world name
    try {
        // worldPtr is a pointer to the UObject, read its name from offset 0x18
        string worldName = vars.GetUObjectName(current.worldPtr);
        vars.Log("Initial world name: " + worldName);
        current.World = worldName;
    }
    catch (Exception e) {
        vars.Log("Error reading initial world: " + e.Message);
    }
}

update
{
    vars.Helper.Update();
    
    // Read the world name from the UObject pointer
    string worldName = vars.GetUObjectName(current.worldPtr);
    if (!string.IsNullOrEmpty(worldName) && worldName != "None" && worldName != "Error" && worldName != "Invalid") {
        current.World = worldName;
        if (old.World != current.World) {
            vars.Log("World changed: " + old.World + " -> " + current.World);
        }
    }
}

