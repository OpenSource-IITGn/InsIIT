import 'dart:math';

/// A quote of the day with a bundled fallback.
///
/// The home screen used to fetch its quote from the free `quotes.rest`
/// endpoint, which is rate-limited and frequently unavailable. When that call
/// failed, the quote card simply went blank — which is the "quotes don't always
/// show up" bug. We keep a small local list here so there is always something
/// to show, and the live quote only replaces it when it actually arrives.
class Quotes {
  static const List<List<String>> _fallback = <List<String>>[
    <String>[
      'The best way to predict the future is to invent it.',
      'Alan Kay'
    ],
    <String>['Simplicity is the soul of efficiency.', 'Austin Freeman'],
    <String>[
      'Whether you think you can or you think you can\'t, you\'re right.',
      'Henry Ford'
    ],
    <String>['It always seems impossible until it\'s done.', 'Nelson Mandela'],
    <String>[
      'The only way to do great work is to love what you do.',
      'Steve Jobs'
    ],
    <String>['Talk is cheap. Show me the code.', 'Linus Torvalds'],
    <String>['In the middle of difficulty lies opportunity.', 'Albert Einstein'],
    <String>[
      'Do not go where the path may lead, go instead where there is no path '
          'and leave a trail.',
      'Ralph Waldo Emerson'
    ],
    <String>[
      'Success is the sum of small efforts repeated day in and day out.',
      'Robert Collier'
    ],
    <String>['Learning never exhausts the mind.', 'Leonardo da Vinci'],
  ];

  /// A random quote from the bundled list, as `{quote, author}`.
  static Map<String, String> fallback() {
    final List<String> entry = _fallback[Random().nextInt(_fallback.length)];
    return <String, String>{'quote': entry[0], 'author': entry[1]};
  }
}
