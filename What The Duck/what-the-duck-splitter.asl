state("WhatTheDuck")
{
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "What the Duck";
    vars.Helper.LoadSceneManager = true;
    vars.isLoading = false;
    vars.level = 1;
    vars.Helper.AlertLoadless();
}

init
{
    old.activeScene = "";
    old.loadingScene = "";
}

update
{
    current.activeScene = vars.Helper.Scenes.Active.Name ?? old.activeScene;
    current.loadingScene = vars.Helper.Scenes.Loaded[0].Name ?? old.loadingScene;

    if (current.activeScene != old.activeScene)
    {
        vars.Log("Active Scene: " + current.activeScene);
    }

    if (current.loadingScene != old.loadingScene)
    {
        vars.Log("Loading Scene: " + current.loadingScene);
    }
}

start
{
    return old.activeScene == "MainMenu" && current.activeScene == "LoadingScene";
}

split
{
    if (old.activeScene != current.activeScene)
    {
        if (vars.level == 1 && current.activeScene == "TreBlocagem") {
            vars.level = 2;
            return true;
        }

        if (vars.level == 2 && current.activeScene == "QuattroBlocagem") {
            vars.level = 3;
            return true;
        }

        if (vars.level == 3 && current.activeScene == "SetteBlocagem") {
            vars.level = 4;
            return true;
        }

        if (current.activeScene == "credits" || current.activeScene == "Credits") {
            vars.level = 0;
            return true;
        }

        // Possible other splits
        // Minigame
        // TreBlocagem
        // Sewers
        // QuattroBlocagem
        // QuattroGeneral
        // QuattroGeneralHellen
        // QuattroHellenBlocagem
    }
}

isLoading
{
    return vars.Helper.IsLoading || current.activeScene == "LoadingScene";
}

onReset
{
    vars.level = 1;
}