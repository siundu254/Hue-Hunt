import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Best-effort LAN IP for expedition room hosting.
Future<String> resolveLanHostIp() async {
  if (kIsWeb) return '127.0.0.1';
  try {
    final info = NetworkInfo();
    final wifi = await info.getWifiIP();
    if (wifi != null && wifi.isNotEmpty && wifi != '0.0.0.0') return wifi;
  } catch (_) {}
  try {
    for (final interface in await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    )) {
      for (final addr in interface.addresses) {
        if (!addr.isLoopback && addr.address.startsWith('192.168.')) {
          return addr.address;
        }
      }
    }
  } catch (_) {}
  return '127.0.0.1';
}
