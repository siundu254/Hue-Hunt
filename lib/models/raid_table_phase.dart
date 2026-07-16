/// Turn ritual for The Raid Map — players cycle Brief → Raid → Reveal → Vault.
enum RaidTablePhase {
  brief('Brief', 'Draw from Mission Altar · read to all corners'),
  raid('Raid', 'Hunt in the real room · crucible timer running'),
  reveal('Reveal', 'Show finds at your deed · group vote confirms'),
  vault('Vault', 'Advance beam tokens · hit ★ ⚡ 💀 spaces');

  const RaidTablePhase(this.label, this.hint);
  final String label;
  final String hint;

  RaidTablePhase get next => RaidTablePhase.values[(index + 1) % RaidTablePhase.values.length];
}
