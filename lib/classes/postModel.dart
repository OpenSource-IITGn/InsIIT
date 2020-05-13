import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/classes/commentModel.dart';
import 'package:instiapp/screens/fullPostPage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/slider.dart';
import 'package:http/http.dart' as http;

//TODO: Implement double tap animation
//TODO: Implement bio on server side
//TODO: Implement Comments posting
//TODO: Implement reactions (server implementation remaining)
//TODO: Implement Reactions on comments
class PostModel {
  String mainText;
  String postPerson;
  String postPersonUrl;
  String timeElapsed;
  List<dynamic> imageUrls;
  String postPersonBio;
  String postPersonId;
  String postId;
  bool isShowingMore;
  bool isLike;
  String timestamp;
  List<dynamic> comments;
  PostModel({
    this.mainText,
    this.postPerson,
    this.postPersonUrl,
    this.timeElapsed,
    this.imageUrls,
    this.postPersonBio,
    this.comments,
    this.postId,
    this.isShowingMore,
    this.isLike,
  });
  factory PostModel.fromJson(Map<String, dynamic> json, int index) {
    var imageurls;
    if (json['results'][index]['image_urls'] == null) {
      imageurls = [''];
    } else {
      imageurls = json['results'][index]['image_urls'];
    }
    List<dynamic> commentsList = [];

    List<dynamic> commentlist = json['results'][index]['comments'];
    if (commentlist != null) {
      for (int i = 0; i < commentlist.length; i++) {
        commentsList.add(CommentModel.fromJson(commentlist[i]));
      }
    }
    DateTime post = dateFormat.parse(json['results'][index]['timestamp']);
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
    print(timediff);
    return PostModel(
      postId: json['results'][index]["_id"],
      postPerson: json['results'][index]['posted_by']["full_name"],
      postPersonUrl: json['results'][index]['posted_by']['image_link'],
      mainText: json['results'][index]['content'],
      postPersonBio: "B.Tech, EE, 2nd year",
      timeElapsed: timediff,
      comments: commentsList,
      imageUrls: imageurls,
    );
  }
}

class PostWidget extends StatefulWidget {
  PostModel post;
  PostWidget({this.post}) {
    post.isShowingMore = (post.mainText.length > 400) ? false : true;
    post.isLike = false;
  }

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void updateLikes() async {
    var queryParameters = {
      'api_key': 'NIKS',
      'feed_id': widget.post.postId,
    };
    var uri = Uri.https(
      baseUrl,
      '/feedReactionUpdate',
      queryParameters,
    );
    print('Sending like/unlike: ' + uri.toString());
    
    var jsonbody = jsonEncode(
        {"where": "like", "change": (widget.post.isLike == true) ? 1 : -1});
    var response = await http.post(
      uri,
      body: jsonbody,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onDoubleTap: () {
          widget.post.isLike = true;
          updateLikes();
          setState(() {});
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FullPostPage(post: widget.post)),
          );
        },
        child: Card(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.orange,
                        minRadius: 25,
                        maxRadius: 25,
                        child: ClipOval(
                            child: Image.network(
                          widget.post.postPersonUrl,
                          fit: BoxFit.cover,
                          width: 90.0,
                          height: 90.0,
                        )),
                      ),
                      SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.post.postPerson,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.post.postPersonBio,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.post.timeElapsed,
                            style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Divider(),
                  ),
                  (widget.post.isShowingMore == true)
                      ? Text(widget.post.mainText)
                      : RichText(
                          text: TextSpan(
                            style: TextStyle(
                              // fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.post.mainText.substring(0, 400)),
                              TextSpan(
                                  text: '\nRead More... ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: secondaryTextColor)),
                            ],
                          ),
                        ),
                  SizedBox(height: 10),
                  (widget.post.imageUrls[0] == '' ||
                          widget.post.imageUrls.length == 0)
                      ? Container()
                      : ImageSliderWidget(
                          imageUrls: widget.post.imageUrls,
                          imageBorderRadius: BorderRadius.circular(8.0),
                        ),
                  // (widget.post.imageUrl == null)
                  //     ? Container()
                  //     : Container(
                  //         color: Colors.grey.withAlpha(50),
                  //         alignment: Alignment.center,
                  //         height: ScreenSize.size.height * 0.4,
                  //         child: Image.network(widget.post.imageUrl),
                  //       ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.thumb_up,
                                color: (widget.post.isLike == true)
                                    ? primaryColor
                                    : secondaryTextColor,
                              ),
                              SizedBox(width: 10),
                              Text("Like")
                            ],
                          ),
                          onPressed: () {
                            widget.post.isLike = !widget.post.isLike;
                            updateLikes();
                            setState(() {});
                          },
                        ),
                        FlatButton(
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.comment, color: secondaryTextColor),
                                SizedBox(width: 10),
                                Text("Comment"),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FullPostPage(post: widget.post)),
                              );
                            }),
                      ])
                ],
              ),
            )),
      ),
    );
  }
}
