using System;
using System.Collections;
using UnityEngine;

/// <summary>
/// Main board controller — receives Flutter messages and drives the 3D scene.
/// Scene hierarchy (create in Unity Editor):
///   RaidMap (this script + FlutterBridge)
///     ├── BoardRoot — quad-fold felt mesh, spot-UV beam grooves
///     ├── VaultRoot — octagon vault, altar/spotlight/chute slots
///     ├── TeamTokens[4] — meeples on curved beam paths
///     ├── ChaosCompass — spinner mesh + ChaosCompassSpin.cs
///     ├── CrownPedestal — crown snap target
///     └── VenueOverlays — swap materials per venueId
/// </summary>
public class RaidMapController : MonoBehaviour
{
    [Header("Scene refs")]
    public Transform boardRoot;
    public Transform vaultRoot;
    public Transform[] teamTokens = new Transform[4];
    public Transform chaosCompass;
    public Transform crownPedestal;
    public Animator crownAnimator;
    public VenueOverlayController venueOverlays;
    public BeamPath[] beamPaths = new BeamPath[4];

    [Header("Track")]
    public int winSpace = 10;
    public float tokenLerpSpeed = 6f;

    FlutterBridge _bridge;
    string _venueId = "home";
    readonly int[] _scores = { 0, 0, 0, 0 };

    void Awake()
    {
        _bridge = GetComponent<FlutterBridge>();
        if (_bridge == null) _bridge = gameObject.AddComponent<FlutterBridge>();
    }

    void Start()
    {
        _bridge.NotifyReady();
    }

    // flutter_unity_widget: UnityWidget.postMessage('RaidMapController', 'MethodName', 'json')
    public void loadVenue(string json)
    {
        try
        {
            var data = JsonUtility.FromJson<VenuePayload>(json);
            _venueId = string.IsNullOrEmpty(data.venueId) ? "home" : data.venueId;
            if (venueOverlays != null) venueOverlays.ApplyVenue(_venueId);
            ResetScores();
        }
        catch (Exception e)
        {
            Debug.LogWarning($"[RaidMap] loadVenue parse failed: {e.Message}");
        }
    }

    public void setScores(string json)
    {
        try
        {
            var data = JsonUtility.FromJson<ScoresPayload>(json);
            for (var i = 0; i < Mathf.Min(4, data.scores.Length); i++)
            {
                _scores[i] = Mathf.Clamp(data.scores[i], 0, winSpace);
                MoveToken(i, _scores[i]);
            }
        }
        catch (Exception e)
        {
            Debug.LogWarning($"[RaidMap] setScores failed: {e.Message}");
        }
    }

    public void spinCompass(string _)
    {
        if (chaosCompass == null) return;
        var spin = chaosCompass.GetComponent<ChaosCompassSpin>();
        if (spin != null) spin.Spin();
        else StartCoroutine(SpinFallback());
    }

    public void drawModeCard(string json)
    {
        // TODO: burst VFX + card flip at vault altar slot
        Debug.Log($"[RaidMap] mode card: {json}");
    }

    public void setPhase(string json)
    {
        // Highlight vault altar / crucible based on phase string from Flutter
        Debug.Log($"[RaidMap] phase: {json}");
    }

    public void crownWin(string json)
    {
        try
        {
            var data = JsonUtility.FromJson<CrownPayload>(json);
            if (crownAnimator != null) crownAnimator.SetTrigger("Snap");
            StartCoroutine(CrownCeremony(data.teamName));
        }
        catch (Exception e)
        {
            Debug.LogWarning($"[RaidMap] crownWin failed: {e.Message}");
        }
    }

    IEnumerator CrownCeremony(string teamName)
    {
        yield return new WaitForSeconds(0.35f);
        if (crownPedestal != null)
        {
            // Place crown on pedestal — hook to animation clip or lerp
            crownPedestal.gameObject.SetActive(true);
        }
        Debug.Log($"[RaidMap] Who Raided? {teamName} Raided!");
    }

    IEnumerator SpinFallback()
    {
        if (chaosCompass == null) yield break;
        var t = 0f;
        var start = chaosCompass.localEulerAngles.z;
        while (t < 1f)
        {
            t += Time.deltaTime * 1.2f;
            var z = start + Mathf.Lerp(0f, 720f + UnityEngine.Random.Range(0f, 360f), t);
            chaosCompass.localEulerAngles = new Vector3(0, 0, z);
            yield return null;
        }
    }

    public void OnCornerClicked(int teamIndex)
    {
        if (teamIndex < 0 || teamIndex >= 4) return;
        _bridge.NotifyCornerTapped(teamIndex);
    }

    public void OnVaultZoneClicked(string zoneId)
    {
        _bridge.NotifyVaultTapped(zoneId);
    }

    void ResetScores()
    {
        for (var i = 0; i < 4; i++)
        {
            _scores[i] = 0;
            MoveToken(i, 0);
        }
    }

    void MoveToken(int teamIndex, int space)
    {
        if (teamIndex < 0 || teamIndex >= teamTokens.Length || teamTokens[teamIndex] == null)
            return;

        Vector3 target;
        Quaternion rot = Quaternion.identity;
        if (beamPaths != null && teamIndex < beamPaths.Length && beamPaths[teamIndex] != null)
        {
            target = beamPaths[teamIndex].PositionAt(space);
            rot = beamPaths[teamIndex].RotationAt(space);
        }
        else
        {
            var angle = teamIndex * 90f + space * 8f;
            var r = 1.2f + space * 0.08f;
            var rad = angle * Mathf.Deg2Rad;
            target = new Vector3(Mathf.Cos(rad) * r, 0.05f, Mathf.Sin(rad) * r);
        }

        StartCoroutine(LerpToken(teamIndex, target, rot));
    }

    IEnumerator LerpToken(int teamIndex, Vector3 target, Quaternion rot)
    {
        var t = teamTokens[teamIndex];
        while (Vector3.Distance(t.position, target) > 0.01f)
        {
            t.position = Vector3.Lerp(t.position, target, Time.deltaTime * tokenLerpSpeed);
            t.rotation = Quaternion.Slerp(t.rotation, rot, Time.deltaTime * tokenLerpSpeed);
            yield return null;
        }
        t.position = target;
        t.rotation = rot;
    }

    [Serializable]
    class VenuePayload { public string venueId; }

    [Serializable]
    class ScoresPayload { public int[] scores = new int[4]; }

    [Serializable]
    class CrownPayload { public string teamName; }
}
