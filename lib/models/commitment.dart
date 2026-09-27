import 'dart:convert';

/// A single daily commitment the user is trying to stay consistent with
/// (e.g. "Gym", "Read 10 pages", "No junk food").
class Commitment {
  final String id;
  String title;
  String emoji;
  int currentStreak;
  int bestStreak;

  /// Calendar-day string (yyyy-MM-dd) of the last day a proof was captured.
  String? lastProofDate;

  /// Every captured proof: date -> local file path of the photo.
  Map<String, String> proofsByDate;

  Commitment({
    required this.id,
    required this.title,
    required this.emoji,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastProofDate,
    Map<String, String>? proofsByDate,
  }) : proofsByDate = proofsByDate ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'emoji': emoji,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'lastProofDate': lastProofDate,
        'proofsByDate': proofsByDate,
      };

  factory Commitment.fromJson(Map<String, dynamic> json) => Commitment(
        id: json['id'] as String,
        title: json['title'] as String,
        emoji: json['emoji'] as String,
        currentStreak: json['currentStreak'] as int? ?? 0,
        bestStreak: json['bestStreak'] as int? ?? 0,
        lastProofDate: json['lastProofDate'] as String?,
        proofsByDate: Map<String, String>.from(
          json['proofsByDate'] as Map? ?? {},
        ),
      );

  static String encodeList(List<Commitment> list) =>
      jsonEncode(list.map((c) => c.toJson()).toList());

  static List<Commitment> decodeList(String raw) {
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((e) => Commitment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
