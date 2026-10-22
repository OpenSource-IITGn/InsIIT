import 'package:shared_preferences/shared_preferences.dart';

/// The student's own details, entered once and kept on the device.
///
/// This is the first step of issue #22 ("collect biodata during onboarding"):
/// instead of every feature asking for the same information again, it is
/// captured in one place here and can be read from anywhere later.
///
/// The data stays on the device (SharedPreferences) and is never uploaded.
class BiodataStore {
  static const String _kName = 'biodata_name';
  static const String _kRoll = 'biodata_roll';
  static const String _kProgramme = 'biodata_programme';
  static const String _kMobile = 'biodata_mobile';
  static const String _kBio = 'biodata_bio';

  /// Loads everything currently stored, with empty strings for missing fields.
  static Future<Map<String, String>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return <String, String>{
      'name': prefs.getString(_kName) ?? '',
      'roll': prefs.getString(_kRoll) ?? '',
      'programme': prefs.getString(_kProgramme) ?? '',
      'mobile': prefs.getString(_kMobile) ?? '',
      'bio': prefs.getString(_kBio) ?? '',
    };
  }

  /// Persists the given details, replacing any previous values.
  static Future<void> save(Map<String, String> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, data['name'] ?? '');
    await prefs.setString(_kRoll, data['roll'] ?? '');
    await prefs.setString(_kProgramme, data['programme'] ?? '');
    await prefs.setString(_kMobile, data['mobile'] ?? '');
    await prefs.setString(_kBio, data['bio'] ?? '');
  }

  /// True if nothing useful has been filled in yet.
  ///
  /// Used to decide whether onboarding still needs to ask for these details.
  static Future<bool> isEmpty() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String mobile = prefs.getString(_kMobile) ?? '';
    final String bio = prefs.getString(_kBio) ?? '';
    return mobile.isEmpty && bio.isEmpty;
  }
}
