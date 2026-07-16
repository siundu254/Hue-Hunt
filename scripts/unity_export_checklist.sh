#!/usr/bin/env bash
# Pre-flight checklist before embedding Unity export into Flutter.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UNITY_DIR="$ROOT/unity/RaidMap"
SCRIPTS="$UNITY_DIR/Assets/Scripts"
EDITOR="$UNITY_DIR/Assets/Editor"

echo "== Hunt-Hue Box · Unity export checklist =="
echo ""

missing=0
for f in RaidMapController.cs FlutterBridge.cs ChaosCompassSpin.cs VenueOverlayController.cs BeamPath.cs BoardSceneBuilder.cs CameraOrbitController.cs BoardTapRelay.cs; do
  if [[ -f "$SCRIPTS/$f" ]]; then echo "✓ $f"; else echo "✗ MISSING $f"; missing=1; fi
done

if [[ -f "$EDITOR/RaidMapSceneWizard.cs" ]]; then
  echo "✓ RaidMapSceneWizard.cs (Editor one-click scene)"
else
  echo "○ RaidMapSceneWizard.cs not found"
fi

echo ""
if [[ ! -d "$UNITY_DIR/ProjectSettings" ]]; then
  echo "○ Unity project not created yet:"
  echo "  1. Unity Hub → New 2022 LTS → folder: unity/RaidMap"
  echo "  2. Copy Assets/Scripts + Assets/Editor into the project"
  echo "  3. Menu: Hunt-Hue → Create Raid Map Scene"
else
  echo "✓ Unity ProjectSettings present"
fi

echo ""
echo "Flutter embed (after Unity export):"
echo "  1. flutter pub add flutter_unity_widget"
echo "  2. Export iOS/Android per flutter_unity_widget docs"
echo "  3. Uncomment lib/widgets/board/raid_map_unity_native.dart"
echo "  4. Set UnityBoardBridge.useUnity = true"
echo ""
echo "Orbit 3D (works now, no Unity): Raid Table → orbit icon (drag to rotate board)"
echo "Browser: Board-Deck.html?table=1"
echo ""

exit $missing
