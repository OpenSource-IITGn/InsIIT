import 'dart:convert';

import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/feed/classes/hashtagModel.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:http/http.dart' as http;

class FeedContainer {
  List hashTags = [];
  String logPrefix = 'HASHTAGS';

  Future<bool> loadHashtags() async {
    hashTags = [];
    log("Loading hashtags for user ${currentUser['uid']}", logPrefix);
    Map<String, String> queryParameters = {
      'api_key': 'NIKS',
      'user_id': currentUser['uid'],
    };
    var uri =
        Uri.https(dataContainer.baseUrl, '/getAllHashTags', queryParameters);
    log("PINGING: ${uri}", logPrefix);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      log("RESPONSE OK", logPrefix);
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['success'] == true) {
        log("${responseJson['results']}", logPrefix);
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
    log("Adding hashtag $id for user ${currentUser['uid']}", logPrefix);
    Map<String, String> queryParameters = {
      'api_key': 'NIKS',
      'user_id': currentUser['uid'],
    };
    var uri;
    if (following == true) {
      uri = Uri.https(
          dataContainer.baseUrl, '/addUserForHashTag', queryParameters);
    } else {
      uri = Uri.https(
          dataContainer.baseUrl, '/removeUserForHashTag', queryParameters);
    }

    log("POSTREQ: ${uri}", logPrefix);
    var response = await http.post(uri, body: {"hash_tag_id": id});
    if (response.statusCode == 200) {
      log("RESPONSE OK", logPrefix);
      return true;
    }
    return false;
  }
}
