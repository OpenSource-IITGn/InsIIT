import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:instiapp/feed/classes/commentModel.dart';
import 'package:instiapp/feed/screens/fullPostPage.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:instiapp/utilities/slider.dart';
import 'package:http/http.dart' as http;

//TODO: Implement bio on server side
//TODO: Implement Reactions on comments
//TODO: Implement full screen photo view

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
  Map<String, dynamic> reactions = {
    'like': 1,
    'celebrate': 2,
    'insightful': 3,
    'haha': 4
  };
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
    this.reactions,
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

    // log(json['results'][index]);
    // log(json['results'][index]['posted_by']);
    return PostModel(
        postId: json['results'][index]["_id"],
        postPerson: json['results'][index]['posted_by']["full_name"],
        postPersonUrl: json['results'][index]['posted_by']['image_link'],
        mainText: json['results'][index]['content'],
        postPersonBio: "B.Tech, EE, 2nd year",
        timeElapsed: timediff,
        comments: commentsList,
        imageUrls: imageurls,
        reactions: json['results'][index]['reactions'] as Map<String, dynamic>);
  }
}

class PostWidget extends StatefulWidget {
  PostModel post;
  bool showMore;
  PostWidget({this.post, this.showMore}) {
    if (showMore != null) {
      post.isShowingMore = true;
    } else {
      post.isShowingMore = (post.mainText.length > 400) ? false : true;
    }
    post.isLike = false;
  }

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  void updateLikes() async {
    widget.post.reactions['like'] += (widget.post.isLike == true) ? 1 : -1;
    setState(() {});
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
    int change = (widget.post.isLike == true) ? 1 : -1;
    var jsonbody = jsonEncode({"where": "like", "change": change});
    print(jsonbody);
    var response = await http
        .post(uri, body: jsonbody.toString(), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print("SUCCESS: " + jsonDecode(response.body)['success'].toString());
    print(jsonDecode(response.body)['results'][0]['reactions']);

    print(widget.post.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withAlpha(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 1),
        child: GestureDetector(
          onDoubleTap: () {
            widget.post.isLike = true;
            updateLikes();
            setState(() {});
          },
          onTap: () {
            if (widget.showMore == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullPostPage(post: widget.post)),
              );
            }
          },
          child: Card(
              elevation: 0,
              borderOnForeground: true,
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.post.postPersonBio,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.post.timeElapsed,
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
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
                                    text:
                                        widget.post.mainText.substring(0, 400)),
                                TextSpan(
                                    text: '\nRead More... ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    )),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.thumb_up,
                                ),
                                SizedBox(width: 10),
                                Text("${widget.post.reactions['like']}"),
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
                                Icon(Icons
                                    .comment), //, color: secondaryTextColor),
                                SizedBox(width: 10),
                                Text("${widget.post.comments.length}"),
                              ],
                            ),
                            onPressed: null,
                          )
                        ]),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
