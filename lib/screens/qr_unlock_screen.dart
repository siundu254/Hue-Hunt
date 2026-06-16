import 'package:flutter/material.dart';
import 'package:hue_hunt/services/unlock_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Scan Hunt-Hue Box or venue QR to unlock bonus chapter.
class QrUnlockScreen extends StatefulWidget {
  const QrUnlockScreen({super.key});

  @override
  State<QrUnlockScreen> createState() => _QrUnlockScreenState();
}

class _QrUnlockScreenState extends State<QrUnlockScreen> {
  bool _handled = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    final ok = await UnlockService.tryUnlockFromPayload(raw);
    if (!ok) return;
    _handled = true;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bonus chapter unlocked'),
        content: const Text(
          'Spirit Expedition bonus missions are now available from Hunt-Hue Box.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context, true);
            },
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan box QR')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Point at the QR on your Hunt-Hue Box or facilitator sheet. '
              'Valid codes unlock the Spirit Expedition bonus chapter.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: MobileScanner(onDetect: _onDetect),
          ),
          TextButton(
            onPressed: () async {
              await UnlockService.unlockBonusForDemo();
              if (context.mounted) Navigator.pop(context, true);
            },
            child: const Text('Demo unlock (no QR)'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
