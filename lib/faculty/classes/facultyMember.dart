import 'package:instiapp/utilities/facultyConfig.dart';

/// A single faculty member and the office they sit in.
class FacultyMember {
  String name;
  String department;
  String office;
  String email;
  String phone;

  FacultyMember({
    this.name,
    this.department,
    this.office,
    this.email,
    this.phone,
  });

  /// Builds a member from one row of the configured Google Sheet.
  factory FacultyMember.fromSheetRow(List row) {
    String cell(int index) {
      if (index < row.length && row[index] != null) {
        return row[index].toString().trim();
      }
      return '';
    }

    return FacultyMember(
      name: cell(FacultyConfig.colName),
      department: cell(FacultyConfig.colDepartment),
      office: cell(FacultyConfig.colOffice),
      email: cell(FacultyConfig.colEmail),
      phone: cell(FacultyConfig.colPhone),
    );
  }

  /// True if [query] appears in the name, department or office.
  bool matches(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        department.toLowerCase().contains(q) ||
        office.toLowerCase().contains(q);
  }
}
