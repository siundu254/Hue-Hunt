using System.Collections;
using UnityEngine;

/// <summary>Attach to Chaos Compass transform — 2s ease-out spin.</summary>
public class ChaosCompassSpin : MonoBehaviour
{
    public float spinDuration = 1.4f;
    public float extraRotations = 3f;

    bool _spinning;

    public void Spin()
    {
        if (_spinning) return;
        StartCoroutine(DoSpin());
    }

    IEnumerator DoSpin()
    {
        _spinning = true;
        var start = transform.localEulerAngles.z;
        var end = start + 360f * extraRotations + Random.Range(0f, 360f);
        var t = 0f;
        while (t < 1f)
        {
            t += Time.deltaTime / spinDuration;
            var eased = 1f - Mathf.Pow(1f - t, 3f);
            var z = Mathf.Lerp(start, end, eased);
            transform.localEulerAngles = new Vector3(0, 0, z);
            yield return null;
        }
        _spinning = false;
    }
}
