import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:instiapp/schedule/classes/eventClass.dart';

/// Schedules local notifications that remind the user shortly before a class.
///
/// This reuses the same approach already used for shuttle-bus reminders
/// (see `lib/shuttle/screens/shuttle.dart`): the `flutter_local_notifications`
/// plugin with the existing `app_icon` drawable. No new dependencies are
/// introduced and no data leaves the device.
class ClassReminder {
  /// How long before a class the reminder fires.
  static const int defaultMinutesBefore = 10;

  static const String _channelId = 'class_reminders';
  static const String _channelName = 'Class reminders';
  static const String _channelDescription =
      'Reminders for your upcoming classes';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialised = false;

  static Future<void> _ensureInitialised() async {
    if (_initialised) return;
    var androidSettings = AndroidInitializationSettings('app_icon');
    var iosSettings = IOSInitializationSettings();
    var settings = InitializationSettings(androidSettings, iosSettings);
    await _plugin.initialize(settings);
    _initialised = true;
  }

  /// The next date/time at which [event] occurs.
  ///
  /// Classes recur weekly, so this takes the event's weekday and time and rolls
  /// forward to the next occurrence that is still in the future.
  static DateTime nextOccurrence(Event event, {DateTime from}) {
    final DateTime now = from ?? DateTime.now();
    DateTime next = DateTime(
        now.year, now.month, now.day, event.startTime.hour, event.startTime.minute);
    while (!next.isAfter(now)) {
      next = next.add(Duration(days: 7));
    }
    return next;
  }

  /// Schedules (or replaces) a reminder for [event].
  ///
  /// Returns `false` if the reminder time would already be in the past (for
  /// example, the class is starting within [minutesBefore]).
  static Future<bool> schedule(
    Event event, {
    int minutesBefore = defaultMinutesBefore,
    String title,
    String body,
  }) async {
    await _ensureInitialised();

    final DateTime when =
        nextOccurrence(event).subtract(Duration(minutes: minutesBefore));
    if (!when.isAfter(DateTime.now())) {
      return false;
    }

    var androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDescription,
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'class-reminder',
    );
    var iosDetails = IOSNotificationDetails();
    var details = NotificationDetails(androidDetails, iosDetails);

    await _plugin.schedule(
      _idFor(event),
      title ?? 'Upcoming class',
      body ?? '${event.name} starts in $minutesBefore minutes.',
      when,
      details,
      payload: event.name,
    );
    return true;
  }

  /// Cancels a previously scheduled reminder for [event], if any.
  static Future<void> cancel(Event event) async {
    await _ensureInitialised();
    await _plugin.cancel(_idFor(event));
  }

  /// A stable, deterministic id per class so that re-setting a reminder
  /// replaces the previous one instead of stacking duplicates.
  static int _idFor(Event event) {
    final String key = '${event.name}-${event.startTime.weekday}-'
        '${event.startTime.hour}-${event.startTime.minute}';
    int hash = 0;
    for (int i = 0; i < key.length; i++) {
      hash = (hash * 31 + key.codeUnitAt(i)) & 0x7fffffff;
    }
    return hash;
  }
}
