using UnityEngine;

/// <summary>
/// Elegant orbit camera focused on the vault — drag to rotate, scroll to zoom.
/// </summary>
public class CameraOrbitController : MonoBehaviour
{
    public Transform focus;
    public float distance = 5.5f;
    public float minDistance = 3.2f;
    public float maxDistance = 8f;
    public float yaw = 35f;
    public float pitch = 42f;
    public float rotateSpeed = 180f;
    public float zoomSpeed = 2f;
    public float smooth = 8f;

    float _targetYaw;
    float _targetPitch;
    float _targetDistance;
    Vector3 _focus = Vector3.zero;

    void Start()
    {
        _targetYaw = yaw;
        _targetPitch = pitch;
        _targetDistance = distance;
        if (focus != null) _focus = focus.position;
        Apply();
    }

    void LateUpdate()
    {
        if (focus != null) _focus = focus.position;

        if (Input.GetMouseButton(0))
        {
            _targetYaw += Input.GetAxis("Mouse X") * rotateSpeed * Time.deltaTime;
            _targetPitch -= Input.GetAxis("Mouse Y") * rotateSpeed * Time.deltaTime;
            _targetPitch = Mathf.Clamp(_targetPitch, 18f, 72f);
        }

        var scroll = Input.mouseScrollDelta.y;
        if (Mathf.Abs(scroll) > 0.01f)
        {
            _targetDistance -= scroll * zoomSpeed;
            _targetDistance = Mathf.Clamp(_targetDistance, minDistance, maxDistance);
        }

        yaw = Mathf.LerpAngle(yaw, _targetYaw, Time.deltaTime * smooth);
        pitch = Mathf.Lerp(pitch, _targetPitch, Time.deltaTime * smooth);
        distance = Mathf.Lerp(distance, _targetDistance, Time.deltaTime * smooth);
        Apply();
    }

    void Apply()
    {
        var rot = Quaternion.Euler(pitch, yaw, 0f);
        var offset = rot * new Vector3(0f, 0f, -distance);
        transform.position = _focus + offset;
        transform.LookAt(_focus + Vector3.up * 0.15f);
    }

    public void FocusVault(Transform vault)
    {
        focus = vault;
    }
}
