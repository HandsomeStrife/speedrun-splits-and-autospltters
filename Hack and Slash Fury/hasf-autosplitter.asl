state("Hack And Slash Fury")
{}

init
{
    old.activeScene = null;
    old.loadingScene = null;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Hack and Slash Fury";
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
    return current.activeScene == "Cinemática De Video 1";
}


split
{
    return old.activeScene != current.activeScene && current.activeScene == "Z cargando cinemática";
}