import 'package:flutter/material.dart';
import 'package:hue_hunt/data/mission_repository.dart';
import 'package:hue_hunt/models/hunt_category.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/services/color_math.dart';

/// Print-layout reference: all Hunt-Hue Box cards (48) for retail / playtesting.
class BoxCardGalleryScreen extends StatefulWidget {
  const BoxCardGalleryScreen({super.key});

  @override
  State<BoxCardGalleryScreen> createState() => _BoxCardGalleryScreenState();
}

class _BoxCardGalleryScreenState extends State<BoxCardGalleryScreen> {
  final _repo = MissionRepository();
  List<MissionDefinition> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _repo.allBoxCards().then((cards) {
      if (!mounted) return;
      setState(() {
        _cards = cards;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Box card gallery')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    '${_cards.length} cards · print reference 63×88mm (poker size)',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _cards.length,
              itemBuilder: (context, i) => _CardTile(card: _cards[i], index: i + 1),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.index});
  final MissionDefinition card;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = card.targetColor;
    final headline = card.isScavengerHunt ? card.huntHeadline : card.hueName;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              alignment: Alignment.center,
              child: Text(card.picture, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${card.boxCardId ?? 'Card'} · ${missionTypeLabel(card.type)}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  if (card.type == MissionType.hunt)
                    Text(
                      card.huntCategory.label,
                      style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  const SizedBox(height: 4),
                  Text(headline, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Text(card.clue, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), height: 1.3)),
                  if (!card.isScavengerHunt)
                    Text(ColorMath.toHex(color), style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
            Text('#$index', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
          ],
        ),
      ),
    );
  }
}
