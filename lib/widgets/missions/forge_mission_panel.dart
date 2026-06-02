import 'package:flutter/material.dart';
import 'package:hue_hunt/models/mission.dart';
import 'package:hue_hunt/models/session_mode.dart';
import 'package:hue_hunt/services/color_math.dart';
import 'package:hue_hunt/widgets/target_hue_card.dart';

class ForgeMissionPanel extends StatefulWidget {
  const ForgeMissionPanel({
    super.key,
    required this.mission,
    required this.profile,
    required this.onComplete,
  });

  final MissionDefinition mission;
  final ModeProfile profile;
  final void Function({required int meterGain, required bool success, int? teamIndex}) onComplete;

  @override
  State<ForgeMissionPanel> createState() => _ForgeMissionPanelState();
}

class _ForgeMissionPanelState extends State<ForgeMissionPanel> {
  double _r = 128;
  double _g = 128;
  double _b = 128;

  @override
  Widget build(BuildContext context) {
    final mixed = ColorMath.fromChannels(_r.round(), _g.round(), _b.round());
    final match = ColorMath.matchPercent(mixed, widget.mission.targetColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('FORGE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(missionTypeDescription(MissionType.forge, neutral: widget.profile.neutralCopy)),
        const SizedBox(height: 12),
        TargetHueCard(mission: widget.mission, profile: widget.profile),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: mixed,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Your mix\n$match% match',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorMath.onColor(mixed),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        _slider('Red', _r, Colors.red, (v) => setState(() => _r = v)),
        _slider('Green', _g, Colors.green, (v) => setState(() => _g = v)),
        _slider('Blue', _b, Colors.blue, (v) => setState(() => _b = v)),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () {
            final gain = match >= 85 ? 30 : match >= 65 ? 22 : match >= 45 ? 12 : 5;
            widget.onComplete(meterGain: gain, success: match >= 45);
          },
          child: Text(match >= 65 ? 'Lock forge ($match%)' : 'Submit mix ($match%)'),
        ),
      ],
    );
  }

  Widget _slider(String label, double value, Color color, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0,
          max: 255,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
