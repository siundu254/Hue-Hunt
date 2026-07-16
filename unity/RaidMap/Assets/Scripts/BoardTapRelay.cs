using UnityEngine;

/// <summary>
/// Raycasts taps on quadrants and vault — forwards to RaidMapController.
/// </summary>
public class BoardTapRelay : MonoBehaviour
{
    RaidMapController _controller;
    Camera _cam;

    void Awake()
    {
        _controller = GetComponent<RaidMapController>();
        _cam = Camera.main;
    }

    void Update()
    {
        if (_controller == null || _cam == null) return;
        if (!Input.GetMouseButtonUp(0)) return;

        var ray = _cam.ScreenPointToRay(Input.mousePosition);
        if (!Physics.Raycast(ray, out var hit, 40f)) return;

        var name = hit.collider.gameObject.name;
        if (name.StartsWith("Quadrant_"))
        {
            var idx = int.Parse(name.Substring("Quadrant_".Length));
            _controller.OnCornerClicked(idx);
            return;
        }

        if (name.Contains("Vault") || name.Contains("Crown"))
        {
            _controller.OnVaultZoneClicked("vault");
        }
    }
}
