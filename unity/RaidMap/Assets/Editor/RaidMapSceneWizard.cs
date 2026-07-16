using UnityEngine;

#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;

/// <summary>Menu: Hunt-Hue → Create Raid Map Scene</summary>
public static class RaidMapSceneWizard
{
    [MenuItem("Hunt-Hue/Create Raid Map Scene")]
    public static void CreateScene()
    {
        var scene = EditorSceneManager.NewScene(NewSceneSetup.DefaultGameObjects, NewSceneMode.Single);
        var root = new GameObject("RaidMap");
        root.AddComponent<FlutterBridge>();
        root.AddComponent<BoardSceneBuilder>();
        root.AddComponent<RaidMapController>();

        var cam = Camera.main;
        if (cam != null)
        {
            cam.transform.position = new Vector3(3.5f, 4.2f, -3.5f);
            cam.transform.LookAt(Vector3.zero);
            cam.gameObject.AddComponent<CameraOrbitController>();
        }

        root.GetComponent<BoardSceneBuilder>().Build();

        var path = "Assets/Scenes/RaidMap.unity";
        System.IO.Directory.CreateDirectory("Assets/Scenes");
        EditorSceneManager.SaveScene(scene, path);
        Debug.Log($"[RaidMap] Scene saved → {path}. Export via flutter_unity_widget.");
    }
}
#endif
