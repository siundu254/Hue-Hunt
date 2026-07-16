using System.Runtime.InteropServices;
using UnityEngine;

/// <summary>
/// Sends events from Unity to Flutter via flutter_unity_widget.
/// Attach to the same GameObject as RaidMapController.
/// </summary>
public class FlutterBridge : MonoBehaviour
{
    public void SendToFlutter(string eventName, string payloadJson = "{}")
    {
#if UNITY_IOS && !UNITY_EDITOR
        NativeAPI.SendMessageToFlutter(eventName, payloadJson);
#elif UNITY_ANDROID && !UNITY_EDITOR
        using (var unityPlayer = new AndroidJavaClass("com.xraph.plugin.flutter_unity_widget.UnityPlayerUtils"))
        {
            unityPlayer.CallStatic("onUnityMessage", eventName + "|" + payloadJson);
        }
#else
        Debug.Log($"[FlutterBridge] {eventName} {payloadJson}");
#endif
    }

    public void NotifyReady() => SendToFlutter("ready");

    public void NotifyCornerTapped(int teamIndex) =>
        SendToFlutter("cornerTapped", $"{{\"teamIndex\":{teamIndex}}}");

    public void NotifyVaultTapped(string zoneId) =>
        SendToFlutter("vaultTapped", $"{{\"zoneId\":\"{zoneId}\"}}");
}

#if UNITY_IOS && !UNITY_EDITOR
public static class NativeAPI
{
    [DllImport("__Internal")]
    public static extern void SendMessageToFlutter(string eventName, string payload);
}
#endif
