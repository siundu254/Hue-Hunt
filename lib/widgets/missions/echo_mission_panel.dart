import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/widgets/mission_prompt_card.dart';

enum _EchoStep { search, reveal, vote }

class EchoMissionPanel extends StatefulWidget {
  const EchoMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final MissionCompleteCallback onComplete;

  @override
  State<EchoMissionPanel> createState() => _EchoMissionPanelState();
}

class _EchoMissionPanelState extends State<EchoMissionPanel> {
  _EchoStep _step = _EchoStep.search;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('ECHO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.echo, neutral: widget.profile.neutralCopy)),
        const SizedBox(height: 12),
        MissionPromptCard(mission: widget.mission, profile: widget.profile),
        const SizedBox(height: 12),
        if (_step == _EchoStep.search) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: const Text(
              'Find a real object in the room that matches the prompt.\n'
              'No drawing — hold it up when you are ready.',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => setState(() => _step = _EchoStep.reveal),
            icon: const Icon(Icons.search),
            label: const Text('Found my object'),
          ),
        ] else if (_step == _EchoStep.reveal) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
            ),
            child: const Column(
              children: [
                Icon(Icons.visibility, size: 36),
                SizedBox(height: 8),
                Text(
                  'Reveal your object to the group.\nLet teammates guess your logic!',
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => setState(() => _step = _EchoStep.vote),
            child: const Text('Group is ready to guess'),
          ),
        ] else ...[
          const Text('Did the group guess your object?'),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final stars in [1, 2, 3])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilledButton(
                      onPressed: () => widget.onComplete(
                        meterGain: stars * 10,
                        success: stars >= 2,
                      ),
                      child: Text('★' * stars),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
