import 'dart:convert';

import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/feed/classes/hashtagModel.dart';
import 'package:http/http.dart' as http;

class FeedContainer {
  List hashTags = [];

  Future<bool> loadHashtags() async {
    hashTags = [];
    Map<String, String> queryParameters = {
      'api_key': 'NIKS',
      'user_id': dataContainer.auth.user.uid,
    };
    var uri =
        Uri.https(dataContainer.baseUrl, '/getAllHashTags', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['success'] == true) {
        hashTags = responseJson['results']
            .map((item) => HashtagModel.fromJson(item))
            .toList();
        hashTags.sort((a, b) {
          if (a.following == true) {
            return -1;
          } else if (b.following == true) {
            return 1;
          }
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      }
      return true;
    }
    return false;
  }

  Future<bool> addRemoveUserForHashtag(id, following) async {
    Map<String, String> queryParameters = {
      'api_key': 'NIKS',
      'user_id': dataContainer.auth.user.uid,
    };
    var uri;
    if (following == true) {
      uri = Uri.https(
          dataContainer.baseUrl, '/addUserForHashTag', queryParameters);
    } else {
      uri = Uri.https(
          dataContainer.baseUrl, '/removeUserForHashTag', queryParameters);
    }

    var response = await http.post(uri, body: {"hash_tag_id": id});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
