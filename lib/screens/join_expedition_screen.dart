import 'package:flutter/material.dart';
import 'package:hue_hunt/models/expedition_room.dart';
import 'package:hue_hunt/screens/player_client_screen.dart';
import 'package:hue_hunt/services/expedition_room_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class JoinExpeditionScreen extends StatefulWidget {
  const JoinExpeditionScreen({super.key});

  @override
  State<JoinExpeditionScreen> createState() => _JoinExpeditionScreenState();
}

class _JoinExpeditionScreenState extends State<JoinExpeditionScreen> {
  final _codeController = TextEditingController();
  final _hostController = TextEditingController();
  final _nameController = TextEditingController(text: 'Player');
  PlayerRole _role = PlayerRole.spectator;
  int _teamIndex = 0;
  bool _joining = false;

  @override
  void dispose() {
    _codeController.dispose();
    _hostController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = _codeController.text.trim();
    final host = _hostController.text.trim();
    if (code.length < 6 || host.isEmpty) return;
    setState(() => _joining = true);

    final ok = await ExpeditionRoomService.instance.joinRoom(
      host: host,
      port: ExpeditionRoomService.defaultPort,
      roomCode: code,
      playerName: _nameController.text.trim().isEmpty ? 'Player' : _nameController.text.trim(),
      role: _role,
      teamIndex: _role == PlayerRole.team ? _teamIndex : null,
    );

    if (!mounted) return;
    setState(() => _joining = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not join — check code, Wi‑Fi, and host IP')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => PlayerClientScreen(
          host: host,
          port: ExpeditionRoomService.defaultPort,
          roomCode: code,
          playerName: _nameController.text.trim(),
          role: _role,
          teamIndex: _teamIndex,
        ),
      ),
    );
  }

  void _onQr(BarcodeCapture capture) {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || !raw.startsWith('huehunt://join')) return;
    final uri = Uri.parse(raw);
    _codeController.text = uri.queryParameters['code'] ?? '';
    _hostController.text = uri.queryParameters['host'] ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join expedition')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(onDetect: _onQr),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Scan host QR, or enter manually (same Wi‑Fi).'),
            const SizedBox(height: 16),
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Host IP address',
                hintText: '192.168.1.12',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Room code',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Join as', style: TextStyle(fontWeight: FontWeight.bold)),
            SegmentedButton<PlayerRole>(
              segments: const [
                ButtonSegment(value: PlayerRole.team, label: Text('Team phone')),
                ButtonSegment(value: PlayerRole.spectator, label: Text('Spectator')),
              ],
              selected: {_role},
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),
            if (_role == PlayerRole.team) ...[
              const SizedBox(height: 12),
              DropdownMenu<int>(
                label: const Text('Team'),
                initialSelection: _teamIndex,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: 'Team 1'),
                  DropdownMenuEntry(value: 1, label: 'Team 2'),
                ],
                onSelected: (v) => setState(() => _teamIndex = v ?? 0),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _joining ? null : _join,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.backgroundDark,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(_joining ? 'Joining…' : 'Join expedition'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
