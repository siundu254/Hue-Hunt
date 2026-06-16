import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hue_hunt/models/expedition_room.dart';
import 'package:hue_hunt/providers/expedition_provider.dart';
import 'package:hue_hunt/models/expedition_format.dart';

/// Same-WiFi expedition room — host + team phones + spectator voters (HH-05 / v2.0).
class ExpeditionRoomService {
  ExpeditionRoomService._();
  static final ExpeditionRoomService instance = ExpeditionRoomService._();

  static const defaultPort = 8765;

  HttpServer? _server;
  String? _roomCode;
  String? _hostIp;
  ExpeditionRoomSnapshot? _snapshot;
  final _participants = <String, RoomParticipant>{};
  final _votes = <String, int>{};
  final _clientControllers = <StreamController<ExpeditionRoomSnapshot>>[];

  String? get roomCode => _roomCode;
  String? get hostIp => _hostIp;
  int get port => defaultPort;
  bool get isHosting => _server != null;
  ExpeditionRoomSnapshot? get latestSnapshot => _snapshot;

  String? get joinUrl {
    if (_roomCode == null || _hostIp == null) return null;
    return 'huehunt://join?code=$_roomCode&host=$_hostIp&port=$port';
  }

  String generateCode() {
    final n = Random().nextInt(900000) + 100000;
    return '$n';
  }

  Future<void> startHost({
    required String roomCode,
    required ExpeditionFormat format,
    required ExpeditionProvider expedition,
    String? hostIp,
  }) async {
    await stop();
    _roomCode = roomCode;
    _hostIp = hostIp ?? '127.0.0.1';
    _votes.clear();
    _participants.clear();
    _snapshot = ExpeditionRoomSnapshot.fromProvider(
      expedition,
      roomCode: roomCode,
      format: format,
      participants: [],
    );

    _server = await HttpServer.bind(InternetAddress.anyIPv4, defaultPort);
    _server!.listen(_handleRequest);
    debugPrint('[ExpeditionRoom] hosting $_roomCode at $_hostIp:$defaultPort');
  }

  void publish(ExpeditionProvider expedition, {required ExpeditionFormat format}) {
    if (_roomCode == null) return;
    final avg = _voteAverage();
    _snapshot = ExpeditionRoomSnapshot.fromProvider(
      expedition,
      roomCode: _roomCode!,
      format: format,
      participants: _participants.values.toList(),
      spectatorVoteAvg: avg,
      spectatorVoteCount: _votes.length,
    );
    for (final c in _clientControllers) {
      if (!c.isClosed) c.add(_snapshot!);
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    _roomCode = null;
    _snapshot = null;
    _votes.clear();
    _participants.clear();
    for (final c in _clientControllers) {
      await c.close();
    }
    _clientControllers.clear();
  }

  Future<ExpeditionRoomSnapshot?> fetchSnapshot({
    required String host,
    required int port,
    required String roomCode,
  }) async {
    try {
      final client = HttpClient();
      final request = await client.get(host, port, '/api/room');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      if (response.statusCode != 200) return null;
      final json = jsonDecode(body) as Map<String, dynamic>;
      if (json['roomCode'] != roomCode) return null;
      return ExpeditionRoomSnapshot.fromJson(json);
    } catch (e) {
      debugPrint('[ExpeditionRoom] fetch failed: $e');
      return null;
    }
  }

  Future<bool> joinRoom({
    required String host,
    required int port,
    required String roomCode,
    required String playerName,
    required PlayerRole role,
    int? teamIndex,
  }) async {
    try {
      final client = HttpClient();
      final req = await client.post(host, port, '/api/join');
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({
        'roomCode': roomCode,
        'name': playerName,
        'role': role.name,
        'teamIndex': teamIndex,
      }));
      final res = await req.close();
      return res.statusCode == 200;
    } catch (e) {
      debugPrint('[ExpeditionRoom] join failed: $e');
      return false;
    }
  }

  Future<bool> submitVote({
    required String host,
    required int port,
    required String roomCode,
    required String playerId,
    required int stars,
  }) async {
    try {
      final client = HttpClient();
      final req = await client.post(host, port, '/api/vote');
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode({
        'roomCode': roomCode,
        'playerId': playerId,
        'stars': stars.clamp(1, 5),
      }));
      final res = await req.close();
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Stream<ExpeditionRoomSnapshot> pollClient({
    required String host,
    required int port,
    required String roomCode,
  }) async* {
    while (true) {
      final snap = await fetchSnapshot(host: host, port: port, roomCode: roomCode);
      if (snap != null) yield snap;
      await Future<void>.delayed(const Duration(milliseconds: 1500));
    }
  }

  double _voteAverage() {
    if (_votes.isEmpty) return 0;
    return _votes.values.reduce((a, b) => a + b) / _votes.length;
  }

  int spectatorBonus() {
    final avg = _voteAverage();
    if (avg <= 0) return 0;
    return (avg * 2).round();
  }

  void clearVotesForMission() => _votes.clear();

  Future<void> _handleRequest(HttpRequest request) async {
    try {
      if (request.method == 'GET' && request.uri.path == '/api/room') {
        await _respondJson(request, _snapshot?.toJson() ?? {});
        return;
      }
      if (request.method == 'POST' && request.uri.path == '/api/join') {
        final body = await utf8.decoder.bind(request).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        if (json['roomCode'] != _roomCode) {
          request.response.statusCode = 404;
          await request.response.close();
          return;
        }
        final id = '${DateTime.now().millisecondsSinceEpoch}_${json['name']}';
        _participants[id] = RoomParticipant(
          id: id,
          name: json['name'] as String,
          role: PlayerRole.values.byName(json['role'] as String),
          teamIndex: json['teamIndex'] as int?,
        );
        await _respondJson(request, {'ok': true, 'playerId': id});
        return;
      }
      if (request.method == 'POST' && request.uri.path == '/api/vote') {
        final body = await utf8.decoder.bind(request).join();
        final json = jsonDecode(body) as Map<String, dynamic>;
        if (json['roomCode'] != _roomCode) {
          request.response.statusCode = 404;
          await request.response.close();
          return;
        }
        final playerId = json['playerId'] as String;
        _votes[playerId] = json['stars'] as int;
        await _respondJson(request, {'ok': true, 'avg': _voteAverage()});
        return;
      }
      request.response.statusCode = 404;
      await request.response.close();
    } catch (e) {
      request.response.statusCode = 500;
      await request.response.close();
    }
  }

  Future<void> _respondJson(HttpRequest request, Map<String, dynamic> json) async {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(json));
    await request.response.close();
  }
}
