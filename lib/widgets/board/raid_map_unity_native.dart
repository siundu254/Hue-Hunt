// ignore_for_file: unused_element, depend_on_referenced_packages
//
// After Unity export:
//   1. flutter pub add flutter_unity_widget
//   2. UnityBoardBridge.useUnity = true  (change const in unity_board_bridge.dart)
//   3. Uncomment the block below and call RaidMapUnityNative.embed from RaidMapUnityView
//
// import 'package:flutter/material.dart';
// import 'package:flutter_unity_widget/flutter_unity_widget.dart';
// import 'package:hue_hunt/services/unity_board_bridge.dart';
//
// abstract final class RaidMapUnityNative {
//   static Widget embed({
//     required void Function(UnityWidgetController) onCreated,
//     required void Function(dynamic) onMessage,
//   }) {
//     return UnityWidget(
//       onUnityCreated: (c) {
//         UnityBoardBridge.attachPostMessage((go, method, msg) => c.postMessage(go, method, msg));
//         onCreated(c);
//       },
//       onUnityMessage: onMessage,
//       fullscreen: false,
//       useAndroidViewSurface: true,
//     );
//   }
// }
