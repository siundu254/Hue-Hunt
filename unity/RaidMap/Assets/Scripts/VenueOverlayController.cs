using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Swaps quadrant materials / decals per venue overlay.
/// Assign 4 quadrant renderers + optional vault rim text mesh.
/// </summary>
public class VenueOverlayController : MonoBehaviour
{
    [System.Serializable]
    public class VenueTheme
    {
        public string venueId;
        public Color[] quadrantColors = new Color[4];
        public Material overlayMaterial;
    }

    public Renderer[] quadrants = new Renderer[4];
    public List<VenueTheme> themes = new List<VenueTheme>();

    static readonly Color[] HomeFallback =
    {
        new(0.91f, 0.45f, 0.15f),
        new(0.91f, 0.45f, 0.15f),
        new(0.35f, 0.65f, 0.45f),
        new(0.35f, 0.65f, 0.45f),
    };

    public void ApplyVenue(string venueId)
    {
        VenueTheme theme = null;
        foreach (var t in themes)
        {
            if (t.venueId == venueId) { theme = t; break; }
        }

        for (var i = 0; i < quadrants.Length; i++)
        {
            if (quadrants[i] == null) continue;
            var col = theme != null && i < theme.quadrantColors.Length
                ? theme.quadrantColors[i]
                : HomeFallback[i % HomeFallback.Length];
            quadrants[i].material.color = col;
            if (theme?.overlayMaterial != null)
                quadrants[i].material = theme.overlayMaterial;
        }
    }
}
