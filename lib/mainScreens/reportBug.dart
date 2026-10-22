import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/githubConfig.dart';

/// Lets a user describe a bug and file it as a GitHub issue.
///
/// The screen collects the report, then hands off to GitHub's "new issue" page
/// with the fields pre-filled. This replaces the old Google Form so reports are
/// trackable and closable instead of piling up in a spreadsheet.
class ReportBugPage extends StatefulWidget {
  @override
  _ReportBugPageState createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();

  bool _opening = false;
  String _error;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  /// Minimal, best-effort environment details, appended so maintainers do not
  /// have to ask. Deliberately small — no personal data is collected.
  String _environment() {
    return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
  }

  String _buildBody() {
    final String description = _descriptionController.text.trim();
    final String steps = _stepsController.text.trim();

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('**Describe the bug**');
    buffer.writeln(description.isEmpty ? '_Not provided_' : description);
    buffer.writeln();
    buffer.writeln('**To Reproduce**');
    buffer.writeln(steps.isEmpty ? '_Not provided_' : steps);
    buffer.writeln();
    buffer.writeln('**Environment**');
    buffer.writeln('- ${_environment()}');
    buffer.writeln();
    buffer.writeln('_Reported from the InsIIT app._');
    return buffer.toString();
  }

  Future<void> _submit() async {
    final String title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Please add a short title for the bug.');
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      setState(() => _error = 'Please describe the bug.');
      return;
    }

    setState(() {
      _error = null;
      _opening = true;
    });

    final String url = GitHubConfig.newIssueUrl(
      title: title,
      body: _buildBody(),
    );

    try {
      if (await canLaunch(url)) {
        await launch(url, forceSafariVC: false);
      } else {
        setState(() => _error = 'Could not open GitHub. Please check your browser.');
      }
    } catch (e) {
      setState(() => _error = 'Could not open GitHub: $e');
    } finally {
      if (mounted) {
        setState(() => _opening = false);
      }
    }
  }

  Widget _field({
    String label,
    TextEditingController controller,
    String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: theme.textHeadingColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: theme.textHeadingColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.textSubheadingColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.appBarColor,
        title: Text(
          'Report a Bug',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textHeadingColor,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Found something broken? Describe it below and submit. A GitHub '
              'issue will open in your browser, pre-filled and ready to post.',
              style: TextStyle(color: theme.textSubheadingColor),
            ),
            SizedBox(height: 20),
            _field(
              label: 'Title',
              controller: _titleController,
              hint: 'Short summary of the bug',
            ),
            SizedBox(height: 16),
            _field(
              label: 'Description',
              controller: _descriptionController,
              hint: 'What went wrong?',
              maxLines: 5,
            ),
            SizedBox(height: 16),
            _field(
              label: 'Steps to reproduce',
              controller: _stepsController,
              hint: '1. Go to...\n2. Tap...\n3. See error',
              maxLines: 4,
            ),
            if (_error != null) ...[
              SizedBox(height: 16),
              Text(
                _error,
                style: TextStyle(color: theme.downvoteColor),
              ),
            ],
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                color: theme.buttonColor,
                onPressed: _opening ? null : _submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Text(
                    _opening ? 'Opening GitHub...' : 'Submit bug report',
                    style: TextStyle(color: theme.buttonContentColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
