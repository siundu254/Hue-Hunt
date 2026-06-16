import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hue_hunt/models/expedition_format.dart';
import 'package:hue_hunt/models/expedition_room.dart';
import 'package:hue_hunt/services/expedition_room_service.dart';
import 'package:hue_hunt/theme/app_colors.dart';

/// Team or spectator client — live sync from host over LAN.
class PlayerClientScreen extends StatefulWidget {
  const PlayerClientScreen({
    super.key,
    required this.host,
    required this.port,
    required this.roomCode,
    required this.playerName,
    required this.role,
    required this.teamIndex,
  });

  final String host;
  final int port;
  final String roomCode;
  final String playerName;
  final PlayerRole role;
  final int teamIndex;

  @override
  State<PlayerClientScreen> createState() => _PlayerClientScreenState();
}

class _PlayerClientScreenState extends State<PlayerClientScreen> {
  ExpeditionRoomSnapshot? _snap;
  StreamSubscription<ExpeditionRoomSnapshot>? _sub;
  late final String _playerId;
  int? _lastVote;

  @override
  void initState() {
    super.initState();
    _playerId = '${DateTime.now().millisecondsSinceEpoch}_${widget.playerName}';
    _sub = ExpeditionRoomService.instance
        .pollClient(host: widget.host, port: widget.port, roomCode: widget.roomCode)
        .listen((s) {
      if (mounted) setState(() => _snap = s);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _vote(int stars) async {
    setState(() => _lastVote = stars);
    await ExpeditionRoomService.instance.submitVote(
      host: widget.host,
      port: widget.port,
      roomCode: widget.roomCode,
      playerId: _playerId,
      stars: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    final snap = _snap;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.role == PlayerRole.spectator ? 'Spectator' : 'Team phone'),
            Text(
              '${widget.playerName} · ${widget.roomCode}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: snap == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(snap.format.emoji, style: const TextStyle(fontSize: 48), textAlign: TextAlign.center),
                  Text(
                    snap.missionType,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mission ${snap.missionIndex + 1} / ${snap.chapterLength}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    snap.challengePrompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                  if (snap.chaosTitle != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'CHAOS: ${snap.chaosTitle}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.amber.shade200, fontWeight: FontWeight.bold),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ...snap.teams.map(
                    (t) => ListTile(
                      title: Text(t['name'] as String),
                      trailing: Text('${t['score']} pts'),
                    ),
                  ),
                  if (widget.role == PlayerRole.spectator) ...[
                    const Divider(height: 32),
                    const Text(
                      'Rate the find when teams confirm:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: FilledButton(
                                onPressed: () => _vote(i),
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      _lastVote == i ? AppColors.accent : Colors.white12,
                                ),
                                child: Text('★' * i),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (snap.spectatorVoteCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Room avg: ${snap.spectatorVoteAvg.toStringAsFixed(1)} ★ (${snap.spectatorVoteCount} votes)',
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ] else ...[
                    const Divider(height: 32),
                    const Text(
                      'Hunt in the room — host device tracks scores. '
                      'You see live mission drops here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.35),
                    ),
                    if (snap.activeTeamName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Active: ${snap.activeTeamName}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.amber.withValues(alpha: 0.9)),
                        ),
                      ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    '${snap.participants.length} devices connected',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ),
    );
  }
}
