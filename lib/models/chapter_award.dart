/// End-of-chapter recognition title.
class ChapterAward {
  const ChapterAward({
    required this.title,
    required this.emoji,
    required this.recipient,
    required this.reason,
  });

  final String title;
  final String emoji;
  final String recipient;
  final String reason;
}
