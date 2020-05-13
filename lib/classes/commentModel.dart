import 'package:instiapp/utilities/constants.dart';

class CommentModel {
  Person poster;
  String text;
  String timestamp;
  CommentModel({this.poster, this.text, this.timestamp});
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
    return CommentModel(
        poster: Person(
            name: json['posted_by']['full_name'],
            imageUrl: json['posted_by']['image_link'],
            uid: json['posted_by']['user_id']),
        text: json['content'],
        timestamp: timediff);
  }
}

class Person {
  String name;
  String imageUrl;
  String uid;
  Person({this.name, this.imageUrl, this.uid});
}
