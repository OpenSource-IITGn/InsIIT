/// Central configuration for the in-app "Report a Bug" flow.
///
/// Everything repository-related lives here and nowhere else, so the rest of
/// the app never hard-codes GitHub details and there is a single, obvious place
/// to update them.
///
/// NOTE ON SAFETY: this is a public, client-side app, so it must never contain
/// tokens, keys or any other secret. Nothing here is sensitive — it is only the
/// public repository name and a URL builder. Issue creation is handed off to
/// GitHub itself (the user submits it in their browser), which is why no
/// credential is needed on the device.
class GitHubConfig {
  /// Owner (user or organisation) of the repository that hosts issues.
  static const String owner = 'OpenSource-IITGn';

  /// Repository that hosts issues.
  static const String repo = 'InsIIT';

  /// Label applied to bug reports so they are easy to filter.
  static const String bugLabel = 'bug';

  /// Builds a GitHub "new issue" URL with the title and body pre-filled.
  ///
  /// GitHub renders this page; the signed-in user reviews it and submits, so
  /// the issue is created under their own account and can be tracked/closed
  /// like any other.
  static String newIssueUrl({String title, String body}) {
    final String base =
        'https://github.com/$owner/$repo/issues/new';
    final Map<String, String> params = <String, String>{
      'title': title ?? '',
      'body': body ?? '',
      'labels': bugLabel,
    };
    final String query = params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$base?$query';
  }
}
