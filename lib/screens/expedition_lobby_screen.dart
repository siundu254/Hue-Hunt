import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/models/venue_archetype.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/screens/chapter_session_screen.dart';
import 'package:hue_hunt/screens/join_expedition_screen.dart';
import 'package:hue_hunt/services/expedition_room_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/utils/lan_ip.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Host lobby — room code, QR join, then start chapter.
class ExpeditionLobbyScreen extends StatefulWidget {
  const ExpeditionLobbyScreen({super.key});

  @override
  State<ExpeditionLobbyScreen> createState() => _ExpeditionLobbyScreenState();
}

class _ExpeditionLobbyScreenState extends State<ExpeditionLobbyScreen> {
  String? _roomCode;
  String? _hostIp;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    _bootRoom();
  }

  Future<void> _bootRoom() async {
    final expedition = context.read<ExpeditionProvider>();
    if (!expedition.roomHosting || expedition.forgeFormat == null) return;

    final code = ExpeditionRoomService.instance.generateCode();
    final ip = await resolveLanHostIp();
    await ExpeditionRoomService.instance.startHost(
      roomCode: code,
      format: expedition.forgeFormat!,
      expedition: expedition,
      hostIp: ip,
    );
    expedition.setRoomHosting(true);
    expedition.syncRoomIfHosting();
    if (!mounted) return;
    setState(() {
      _roomCode = code;
      _hostIp = ip;
    });
  }

  @override
  void dispose() {
    ExpeditionRoomService.instance.stop();
    super.dispose();
  }

  Future<void> _startChapter() async {
    setState(() => _starting = true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const ChapterSessionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expedition = context.watch<ExpeditionProvider>();
    final format = expedition.forgeFormat ?? ExpeditionFormat.digitalForge;
    final joinUrl = ExpeditionRoomService.instance.joinUrl;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expedition room'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const JoinExpeditionScreen()),
            ),
            child: const Text('Join instead'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${format.emoji} ${format.label}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${expedition.chapter.length} missions forged · ${expedition.forgeVenue?.label ?? 'Room'}',
            ),
            const SizedBox(height: 20),
            if (_roomCode != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    const Text('ROOM CODE', style: TextStyle(letterSpacing: 2, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(
                      _roomCode!,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 6),
                    ),
                    if (_hostIp != null) ...[
                      const SizedBox(height: 8),
                      Text('Host IP: $_hostIp:${ExpeditionRoomService.defaultPort}'),
                    ],
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: joinUrl ?? _roomCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Join link copied')),
                        );
                      },
                      child: const Text('Copy join link'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (joinUrl != null)
                Center(
                  child: QrImageView(
                    data: joinUrl,
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ),
              const SizedBox(height: 12),
              const Text(
                'Team phones: join as Team · Audience phones: join as Spectator and vote on finds.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.35),
              ),
            ] else
              const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _starting ? null : _startChapter,
              icon: const Icon(Icons.play_arrow_rounded),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(_starting ? 'Launching…' : 'Start chapter on this device'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
