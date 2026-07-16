import 'package:flutter/material.dart';
import 'package:hue_hunt/models/raid_map_venue.dart';
import 'package:hue_hunt/theme/app_colors.dart';
import 'package:hue_hunt/theme/raid_ui.dart';

/// Venue selector for The Raid Map — used in board demo & Hunt-Hue Box.
class RaidMapVenuePicker extends StatelessWidget {
  const RaidMapVenuePicker({
    super.key,
    required this.selected,
    required this.onSelected,
    this.tierFilter,
    this.onTierFilterChanged,
    this.compact = false,
  });

  final RaidMapVenueId selected;
  final ValueChanged<RaidMapVenueId> onSelected;
  final RaidMapExpansionTier? tierFilter;
  final ValueChanged<RaidMapExpansionTier?>? onTierFilterChanged;
  final bool compact;

  List<RaidMapVenueProfile> get _venues => RaidMapVenues.forTier(tierFilter);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onTierFilterChanged != null) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All (${RaidMapVenues.all.length})',
                  selected: tierFilter == null,
                  onTap: () => onTierFilterChanged!(null),
                ),
                _FilterChip(
                  label: 'Core',
                  selected: tierFilter == RaidMapExpansionTier.core,
                  onTap: () => onTierFilterChanged!(RaidMapExpansionTier.core),
                ),
                _FilterChip(
                  label: 'Packs',
                  selected: tierFilter == RaidMapExpansionTier.expansionPack,
                  onTap: () => onTierFilterChanged!(RaidMapExpansionTier.expansionPack),
                ),
                _FilterChip(
                  label: 'Digital',
                  selected: tierFilter == RaidMapExpansionTier.digital,
                  onTap: () => onTierFilterChanged!(RaidMapExpansionTier.digital),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (compact)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final v in _venues)
                ChoiceChip(
                  label: Text('${v.emoji} ${v.title}'),
                  selected: selected == v.id,
                  onSelected: (_) => onSelected(v.id),
                ),
            ],
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _venues.length,
            itemBuilder: (context, i) {
              final v = _venues[i];
              final active = selected == v.id;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelected(v.id),
                  borderRadius: BorderRadius.circular(RaidUi.radiusSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: active
                        ? RaidUi.glassPanel(accent: AppColors.adventureOrange)
                        : RaidUi.statTile(),
                    child: Row(
                      children: [
                        Text(v.emoji, style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                v.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  color: active ? AppColors.adventureOrange : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                v.useCase.split('·').first.trim(),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white.withValues(alpha: 0.55),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _TierDot(tier: v.tier),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _TierDot extends StatelessWidget {
  const _TierDot({required this.tier});
  final RaidMapExpansionTier tier;

  @override
  Widget build(BuildContext context) {
    final color = switch (tier) {
      RaidMapExpansionTier.core => AppColors.treasureYellow,
      RaidMapExpansionTier.expansionPack => AppColors.adventureOrange,
      RaidMapExpansionTier.digital => AppColors.mysteryPurple,
    };
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Summary card for Hunt-Hue Box venue showcase.
class RaidMapVenueCard extends StatelessWidget {
  const RaidMapVenueCard({super.key, required this.venue, required this.onTap});

  final RaidMapVenueProfile venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RaidUi.radiusMd),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: RaidUi.statTile(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(venue.emoji, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(venue.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                venue.tagline,
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.65)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
