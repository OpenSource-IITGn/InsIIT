import 'package:instiapp/faculty/classes/facultyMember.dart';
import 'package:instiapp/utilities/facultyConfig.dart';
import 'package:instiapp/utilities/googleSheets.dart';

/// Loads faculty office data from a Google Sheet.
///
/// Mirrors the other sheet-backed containers (see `ImportantContactsContainer`):
/// it caches through `GSheet` and exposes a plain list for the UI. The sheet ID
/// and column layout live in [FacultyConfig], so nothing here is hard-coded.
///
/// If no spreadsheet is configured yet, [faculty] stays empty and
/// [isConfigured] is false, letting the UI show a setup hint instead of
/// throwing.
class FacultyContainer {
  List<FacultyMember> faculty = [];
  GSheet sheet;

  bool get isConfigured => FacultyConfig.isConfigured;

  FacultyContainer() {
    if (FacultyConfig.isConfigured) {
      sheet = GSheet(FacultyConfig.spreadsheetId);
    }
  }

  Future<void> initializeCache() async {
    if (sheet != null) {
      await sheet.initializeCache();
    }
  }

  void getData({forceRefresh: false}) {
    if (sheet == null) return;
    sheet
        .getData(FacultyConfig.sheetRange, forceRefresh: forceRefresh)
        .listen((cache) {
      List rows = [];
      for (int i = 0; i < cache.length; i++) {
        rows.add(cache[i]);
      }
      buildFacultyList(rows);
    });
  }

  void buildFacultyList(List rows) {
    faculty = [];
    if (rows == null || rows.isEmpty) return;

    // Row 0 is the header.
    for (int i = 1; i < rows.length; i++) {
      List row = rows[i];
      if (row == null || row.length == 0) continue;
      FacultyMember member = FacultyMember.fromSheetRow(row);
      if (member.name.isEmpty) continue;
      faculty.add(member);
    }

    faculty.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
