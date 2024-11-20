state(){}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;

    // Create a flag to track if the inspection has been completed
    vars.InspectionDone = false;

    // Specify the file path for saving the inspection results
    vars.OutputFilePath = "asl_helper_inspection.txt";
}

update
{
    if (!vars.InspectionDone)
    {
        print("Doing");
        vars.InspectionDone = true; // Set the flag to true to ensure this runs only once

        // Initialize a list to store the inspection results
        var inspectionResults = new List<string>();

        // Inspect vars.Helper
        if (vars.Helper != null)
        {
            inspectionResults.Add("Inspecting vars.Helper:");
            foreach (var property in vars.Helper.GetType().GetProperties())
            {
                inspectionResults.Add("Property: " + property.Name + " (Type: " + property.PropertyType.Name + ")");
            }
            foreach (var method in vars.Helper.GetType().GetMethods())
            {
                inspectionResults.Add("Method: " + method.Name);
            }
            inspectionResults.Add("");
        }

        // Inspect vars.Helper.Scenes
        if (vars.Helper.Scenes != null)
        {
            inspectionResults.Add("Inspecting vars.Helper.Scenes:");
            foreach (var property in vars.Helper.Scenes.GetType().GetProperties())
            {
                inspectionResults.Add("Property: " + property.Name + " (Type: " + property.PropertyType.Name + ")");
            }
            foreach (var method in vars.Helper.Scenes.GetType().GetMethods())
            {
                inspectionResults.Add("Method: " + method.Name);
            }
            inspectionResults.Add("");
        }

        // Inspect vars.Helper.Scenes.Active
        if (vars.Helper.Scenes.Active != null)
        {
            inspectionResults.Add("Inspecting vars.Helper.Scenes.Active:");
            foreach (var property in vars.Helper.Scenes.Active.GetType().GetProperties())
            {
                inspectionResults.Add("Property: " + property.Name + " (Type: " + property.PropertyType.Name + ")");
            }
            foreach (var method in vars.Helper.Scenes.Active.GetType().GetMethods())
            {
                inspectionResults.Add("Method: " + method.Name);
            }
            inspectionResults.Add("");
        }

        // Save the inspection results to a file
        System.IO.File.WriteAllLines(vars.OutputFilePath, inspectionResults.ToArray());

        var fullPath = System.IO.Path.GetFullPath(vars.OutputFilePath);
        print("Inspection results saved to: " + fullPath);

        print("Done");
    }
}
