import 'package:flutter/material.dart';
import 'package:instiapp/faculty/classes/facultyMember.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:url_launcher/url_launcher.dart';

/// A card showing one faculty member's office, with call/email shortcuts.
class FacultyCard {
  final FacultyMember member;

  FacultyCard(this.member);

  Future<void> _launch(String command) async {
    if (await canLaunch(command)) {
      await launch(command);
    }
  }

  Widget build(BuildContext context) {
    return Card(
      color: theme.cardBgColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.textHeadingColor,
                    ),
                  ),
                  (member.department.isNotEmpty)
                      ? Text(
                          member.department,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textSubheadingColor,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on,
                          size: 16, color: theme.iconColorLite),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          member.office.isNotEmpty
                              ? member.office
                              : 'Office not listed',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.textHeadingColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            (member.phone.isNotEmpty)
                ? IconButton(
                    icon: Icon(Icons.phone, color: theme.iconColor),
                    tooltip: 'Call',
                    onPressed: () => _launch('tel:${member.phone}'),
                  )
                : Container(),
            (member.email.isNotEmpty)
                ? IconButton(
                    icon: Icon(Icons.email, color: theme.iconColor),
                    tooltip: 'Email',
                    onPressed: () => _launch('mailto:${member.email}'),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
