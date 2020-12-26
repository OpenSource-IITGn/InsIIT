import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/globalClasses/user.dart';

class CommentModel {
  User poster;
  String text;
  String timestamp;
  String timeText;
  CommentModel({this.poster, this.text, this.timestamp, this.timeText});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {
      'posted_by': poster.toJson(),
      'content': text,
      'timestamp': timestamp,
      "reactions": {"like": 0, "insightful": 0, "celebrate": 0, "haha": 0},
      "reacted_by": [],
    };
    return ret;
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    DateTime post = dateFormat.parse(json['timestamp']);
    Duration difference = DateTime.now().difference(post);
    String timediff = '';
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        timediff = difference.inMinutes.toString() + 'm';
      } else {
        timediff = difference.inHours.toString() + 'h';
      }
    } else {
      timediff = difference.inDays.toString() + 'd';
    }
    // print(json);
    return CommentModel(
        poster: User(
            name: json['posted_by']['full_name'],
            imageUrl: json['posted_by']['image_link'],
            uid: json['posted_by']['user_id']),
        text: json['content'],
        timeText: timediff,
        timestamp: json['timestamp']);
  }
}
