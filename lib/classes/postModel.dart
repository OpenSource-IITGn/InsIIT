import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/screens/fullPostPage.dart';
import 'package:instiapp/utilities/constants.dart';
//TODO: Implement double tap animation

class PostModel {
  String mainText;
  String postPerson;
  String postPersonUrl;
  String timeElapsed;
  String imageUrl;
  String postPersonBio;
  String postPersonId;
  String postId;
  bool isShowingMore;
  bool isLike;
  String timestamp;
  List<String> comments;
  PostModel({
    this.mainText,
    this.postPerson,
    this.postPersonUrl,
    this.timeElapsed,
    this.imageUrl,
    this.postPersonBio,
    this.comments,
    this.postId,
    this.isShowingMore,
    this.isLike,
  });
  factory PostModel.fromJson(Map<String, dynamic> json, int index) {
    return PostModel(
      postId: json['results'][index]["_id"],
      postPerson: json['results'][index]['posted_by']["full_name"],
      postPersonUrl: json['results'][index]['posted_by']['image_link'],
      mainText: json['results'][index]['content'],
      postPersonBio: "EE",
      timeElapsed: "1d",
      imageUrl: "",
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onDoubleTap: () {
          widget.post.isLike = true;
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
                          fontSize: 14.0,
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
              (widget.post.imageUrl == null)?Container():Container(
                color: Colors.grey.withAlpha(50),
                alignment: Alignment.center,
                height: ScreenSize.size.height * 0.4,
                child: Image.network(widget.post.imageUrl),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: (widget.post.isLike == true)
                        ? primaryColor
                        : secondaryTextColor,
                  ),
                  onPressed: () {
                    widget.post.isLike = !widget.post.isLike;
                    setState(() {});
                  },
                ),
                IconButton(
                    icon: Icon(Icons.comment, color: secondaryTextColor),
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
