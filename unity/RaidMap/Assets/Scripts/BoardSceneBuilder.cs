using UnityEngine;

/// <summary>
/// Procedurally builds The Raid Map 3D scene — attach to RaidMap root in an empty scene.
/// </summary>
[ExecuteAlways]
public class BoardSceneBuilder : MonoBehaviour
{
    [Header("Scale")]
    public float boardSize = 4.8f;
    public bool buildOnAwake = true;

    [Header("Built refs (auto)")]
    public Transform boardRoot;
    public Transform vaultRoot;
    public Transform[] teamTokens = new Transform[4];
    public Transform chaosCompass;
    public Transform crownPedestal;
    public BeamPath[] beamPaths = new BeamPath[4];
    public Renderer[] quadrantRenderers = new Renderer[4];
    public Light vaultSpot;

    static readonly Color[] TeamColors =
    {
        new(0.91f, 0.45f, 0.15f),
        new(0.91f, 0.45f, 0.15f),
        new(0.35f, 0.65f, 0.45f),
        new(0.35f, 0.65f, 0.45f),
    };

    void Awake()
    {
        if (buildOnAwake && Application.isPlaying) Build();
    }

    [ContextMenu("Build Raid Map Scene")]
    public void Build()
    {
        ClearChildren();
        BuildLighting();
        boardRoot = CreateChild("BoardRoot");
        BuildFeltBoard();
        BuildHallways();
        BuildQuadrants();
        BuildBeamPaths();
        BuildVault();
        BuildTokens();
        WireController();
    }

    void ClearChildren()
    {
        for (var i = transform.childCount - 1; i >= 0; i--)
        {
            var c = transform.GetChild(i);
            if (Application.isPlaying) Destroy(c.gameObject);
            else DestroyImmediate(c.gameObject);
        }
    }

    void BuildLighting()
    {
        var key = new GameObject("KeyLight");
        key.transform.SetParent(transform, false);
        key.transform.rotation = Quaternion.Euler(52f, -28f, 0f);
        var kl = key.AddComponent<Light>();
        kl.type = LightType.Directional;
        kl.intensity = 1.1f;
        kl.color = new Color(1f, 0.95f, 0.88f);

        var vaultLightGo = new GameObject("VaultSpot");
        vaultLightGo.transform.SetParent(transform, false);
        vaultLightGo.transform.localPosition = new Vector3(0f, 2.2f, 0f);
        vaultLightGo.transform.rotation = Quaternion.Euler(90f, 0f, 0f);
        vaultSpot = vaultLightGo.AddComponent<Light>();
        vaultSpot.type = LightType.Spot;
        vaultSpot.intensity = 2.4f;
        vaultSpot.range = 6f;
        vaultSpot.spotAngle = 55f;
        vaultSpot.color = new Color(1f, 0.92f, 0.55f);

        var fill = new GameObject("FillLight");
        fill.transform.SetParent(transform, false);
        fill.transform.rotation = Quaternion.Euler(20f, 140f, 0f);
        var fl = fill.AddComponent<Light>();
        fl.type = LightType.Directional;
        fl.intensity = 0.35f;
        fl.color = new Color(0.55f, 0.75f, 0.95f);
    }

    void BuildFeltBoard()
    {
        var frame = GameObject.CreatePrimitive(PrimitiveType.Cube);
        frame.name = "MahoganyFrame";
        frame.transform.SetParent(boardRoot, false);
        frame.transform.localScale = new Vector3(boardSize + 0.35f, 0.12f, boardSize + 0.35f);
        frame.transform.localPosition = new Vector3(0f, -0.06f, 0f);
        SetColor(frame, new Color(0.35f, 0.2f, 0.1f));

        var felt = GameObject.CreatePrimitive(PrimitiveType.Cube);
        felt.name = "Felt";
        felt.transform.SetParent(boardRoot, false);
        felt.transform.localScale = new Vector3(boardSize, 0.04f, boardSize);
        SetColor(felt, new Color(0.1f, 0.3f, 0.22f));
    }

    void BuildHallways()
    {
        var hallW = boardSize * 0.06f;
        var v = GameObject.CreatePrimitive(PrimitiveType.Cube);
        v.name = "HallVertical";
        v.transform.SetParent(boardRoot, false);
        v.transform.localScale = new Vector3(hallW, 0.05f, boardSize * 0.72f);
        SetColor(v, new Color(0.18f, 0.1f, 0.06f));

        var h = GameObject.CreatePrimitive(PrimitiveType.Cube);
        h.name = "HallHorizontal";
        h.transform.SetParent(boardRoot, false);
        h.transform.localScale = new Vector3(boardSize * 0.72f, 0.05f, hallW);
        SetColor(h, new Color(0.18f, 0.1f, 0.06f));
    }

    void BuildQuadrants()
    {
        var qSize = boardSize * 0.38f;
        var offset = boardSize * 0.28f;
        var positions = new[]
        {
            new Vector3(-offset, 0.03f, offset),
            new Vector3(offset, 0.03f, offset),
            new Vector3(-offset, 0.03f, -offset),
            new Vector3(offset, 0.03f, -offset),
        };
        for (var i = 0; i < 4; i++)
        {
            var q = GameObject.CreatePrimitive(PrimitiveType.Cube);
            q.name = $"Quadrant_{i}";
            q.transform.SetParent(boardRoot, false);
            q.transform.localPosition = positions[i];
            q.transform.localScale = new Vector3(qSize, 0.02f, qSize);
            SetColor(q, TeamColors[i]);
            quadrantRenderers[i] = q.GetComponent<Renderer>();
        }
    }

    void BuildBeamPaths()
    {
        var beamsRoot = CreateChild("Beams");
        for (var team = 0; team < 4; team++)
        {
            var pathGo = new GameObject($"BeamPath_{team}");
            pathGo.transform.SetParent(beamsRoot, false);
            var path = pathGo.AddComponent<BeamPath>();
            path.waypoints = new Transform[11];
            for (var s = 0; s < 11; s++)
            {
                var wp = new GameObject($"S{s}").transform;
                wp.SetParent(pathGo.transform, false);
                wp.localPosition = BeamWaypoint(team, s);
                path.waypoints[s] = wp;

                if (s > 0)
                {
                    var seg = GameObject.CreatePrimitive(PrimitiveType.Cube);
                    seg.transform.SetParent(pathGo.transform, false);
                    var a = BeamWaypoint(team, s - 1);
                    var b = BeamWaypoint(team, s);
                    seg.transform.localPosition = (a + b) * 0.5f + Vector3.up * 0.02f;
                    seg.transform.localScale = new Vector3(0.06f, 0.015f, Vector3.Distance(a, b));
                    seg.transform.LookAt(pathGo.transform.TransformPoint(b));
                    SetColor(seg, new Color(0.9f, 0.78f, 0.28f));
                }
            }
            beamPaths[team] = path;
        }
    }

    Vector3 BeamWaypoint(int team, int space)
    {
        var t = space / 10f;
        var corner = team * 90f;
        var startR = boardSize * 0.36f;
        var endR = boardSize * 0.08f;
        var r = Mathf.Lerp(startR, endR, t);
        var ang = (corner + t * 72f) * Mathf.Deg2Rad;
        return new Vector3(Mathf.Cos(ang) * r, 0.05f, Mathf.Sin(ang) * r);
    }

    void BuildVault()
    {
        vaultRoot = CreateChild("VaultRoot");
        var vault = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        vault.name = "VaultOctagon";
        vault.transform.SetParent(vaultRoot, false);
        vault.transform.localScale = new Vector3(boardSize * 0.22f, 0.06f, boardSize * 0.22f);
        SetColor(vault, new Color(0.35f, 0.22f, 0.55f));

        var rim = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        rim.name = "VaultRim";
        rim.transform.SetParent(vaultRoot, false);
        rim.transform.localScale = new Vector3(boardSize * 0.24f, 0.01f, boardSize * 0.24f);
        rim.transform.localPosition = new Vector3(0f, 0.04f, 0f);
        SetColor(rim, new Color(0.9f, 0.78f, 0.28f));

        crownPedestal = CreateChild("CrownPedestal", vaultRoot);
        var ped = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        ped.transform.SetParent(crownPedestal, false);
        ped.transform.localScale = new Vector3(0.25f, 0.04f, 0.25f);
        ped.transform.localPosition = new Vector3(0f, 0.08f, 0f);
        SetColor(ped, new Color(0.2f, 0.12f, 0.08f));

        var crown = GameObject.CreatePrimitive(PrimitiveType.Sphere);
        crown.name = "Crown";
        crown.transform.SetParent(crownPedestal, false);
        crown.transform.localScale = new Vector3(0.18f, 0.12f, 0.18f);
        crown.transform.localPosition = new Vector3(0f, 0.16f, 0f);
        SetColor(crown, new Color(1f, 0.85f, 0.2f));

        chaosCompass = CreateChild("ChaosCompass", vaultRoot);
        chaosCompass.localPosition = new Vector3(0.35f, 0.1f, -0.2f);
        var comp = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
        comp.transform.SetParent(chaosCompass, false);
        comp.transform.localScale = new Vector3(0.2f, 0.02f, 0.2f);
        SetColor(comp, new Color(0.25f, 0.15f, 0.45f));
        chaosCompass.gameObject.AddComponent<ChaosCompassSpin>();

        var needle = GameObject.CreatePrimitive(PrimitiveType.Cube);
        needle.transform.SetParent(chaosCompass, false);
        needle.transform.localScale = new Vector3(0.02f, 0.01f, 0.14f);
        needle.transform.localPosition = new Vector3(0f, 0.03f, 0.05f);
        SetColor(needle, new Color(0.9f, 0.2f, 0.2f));
    }

    void BuildTokens()
    {
        var tokensRoot = CreateChild("TeamTokens");
        for (var i = 0; i < 4; i++)
        {
            var tok = GameObject.CreatePrimitive(PrimitiveType.Capsule);
            tok.name = $"Token_{i}";
            tok.transform.SetParent(tokensRoot, false);
            tok.transform.localScale = new Vector3(0.12f, 0.08f, 0.12f);
            SetColor(tok, TeamColors[i]);
            teamTokens[i] = tok.transform;
            if (beamPaths[i] != null)
                tok.transform.position = beamPaths[i].PositionAt(0);
        }
    }

    void WireController()
    {
        var ctrl = GetComponent<RaidMapController>();
        if (ctrl == null) ctrl = gameObject.AddComponent<RaidMapController>();
        ctrl.boardRoot = boardRoot;
        ctrl.vaultRoot = vaultRoot;
        ctrl.teamTokens = teamTokens;
        ctrl.chaosCompass = chaosCompass;
        ctrl.crownPedestal = crownPedestal;
        ctrl.beamPaths = beamPaths;

        var venue = GetComponent<VenueOverlayController>();
        if (venue == null) venue = gameObject.AddComponent<VenueOverlayController>();
        venue.quadrants = quadrantRenderers;
        ctrl.venueOverlays = venue;

        if (GetComponent<BoardTapRelay>() == null)
            gameObject.AddComponent<BoardTapRelay>();

        if (Camera.main != null && Camera.main.GetComponent<CameraOrbitController>() == null)
            Camera.main.gameObject.AddComponent<CameraOrbitController>();
    }

    Transform CreateChild(string name, Transform parent = null)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent != null ? parent : transform, false);
        return go.transform;
    }

    static void SetColor(GameObject go, Color c)
    {
        var r = go.GetComponent<Renderer>();
        if (r == null) return;
        var shader = Shader.Find("Universal Render Pipeline/Lit") ?? Shader.Find("Standard");
        r.sharedMaterial = new Material(shader) { color = c };
    }
}
