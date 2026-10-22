/// Central configuration for the Faculty Office directory.
///
/// The directory is entirely data-driven: it reads a Google Sheet through the
/// same `GSheet` client used by every other sheet-backed feature in the app.
/// Nothing here is sensitive — it is just the location and shape of the data,
/// kept in one place so the rest of the feature never hard-codes it.
///
/// >>> MAINTAINERS: to switch this feature on, create a Google Sheet whose
/// first sheet is named `Faculty`, with a header row and these columns:
///
///     | Name | Department | Office | Email | Phone |
///
/// Share that sheet with the app's service account (the same one used by the
/// other sheets), then paste its spreadsheet ID into [spreadsheetId] below.
/// Until an ID is set, the directory shows a friendly "not set up yet"
/// message instead of failing.
class FacultyConfig {
  /// The Google Sheet that holds faculty office data.
  /// Leave this empty to keep the feature disabled.
  static const String spreadsheetId = '';

  /// Sheet name and column range, e.g. "Faculty!A:E".
  static const String sheetRange = 'Faculty!A:E';

  // Column order in the sheet (0-based). Adjust these if your columns differ,
  // without touching any other file.
  static const int colName = 0;
  static const int colDepartment = 1;
  static const int colOffice = 2;
  static const int colEmail = 3;
  static const int colPhone = 4;

  /// True once a spreadsheet ID has been provided.
  static bool get isConfigured => spreadsheetId.trim().isNotEmpty;
}
