using UnityEngine;

/// <summary>
/// Curved beam path — assign 11 waypoint transforms per team (0=HQ … 10=Crown).
/// </summary>
public class BeamPath : MonoBehaviour
{
    public Transform[] waypoints = new Transform[11];

    public Vector3 PositionAt(int space)
    {
        if (waypoints == null || waypoints.Length == 0) return transform.position;
        var idx = Mathf.Clamp(space, 0, waypoints.Length - 1);
        return waypoints[idx] != null ? waypoints[idx].position : transform.position;
    }

    public Quaternion RotationAt(int space)
    {
        if (waypoints == null || waypoints.Length < 2) return transform.rotation;
        var idx = Mathf.Clamp(space, 0, waypoints.Length - 1);
        var next = Mathf.Min(idx + 1, waypoints.Length - 1);
        if (waypoints[idx] == null || waypoints[next] == null) return transform.rotation;
        var dir = waypoints[next].position - waypoints[idx].position;
        return dir.sqrMagnitude > 0.001f ? Quaternion.LookRotation(dir, Vector3.up) : transform.rotation;
    }
}
