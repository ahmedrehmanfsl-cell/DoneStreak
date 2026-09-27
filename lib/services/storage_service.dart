import 'package:shared_preferences/shared_preferences.dart';
import '../models/commitment.dart';

/// Everything this app stores lives only on-device via SharedPreferences
/// (a simple local key-value file) and the app's own documents folder for
/// photos. There is no server, no analytics pipeline, and no third-party
/// SDK involved anywhere in this class.
class StorageService {
  static const _key = 'donestreak_commitments_v1';

  Future<List<Commitment>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) {
      return _seedDefaults();
    }
    try {
      return Commitment.decodeList(raw);
    } catch (_) {
      return _seedDefaults();
    }
  }

  Future<void> save(List<Commitment> commitments) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, Commitment.encodeList(commitments));
  }

  List<Commitment> _seedDefaults() => [
        Commitment(id: 'c1', title: 'Gym', emoji: '🏋️'),
        Commitment(id: 'c2', title: 'Study 1 hour', emoji: '📚'),
        Commitment(id: 'c3', title: 'No junk food', emoji: '🥗'),
      ];
}
