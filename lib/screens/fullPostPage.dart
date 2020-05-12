import 'package:flutter/material.dart';
import 'package:instiapp/classes/postModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';

class FullPostPage extends StatefulWidget {
  PostModel post;
  FullPostPage({this.post});

  @override
  _FullPostPageState createState() => _FullPostPageState();
}

class _FullPostPageState extends State<FullPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post")),
      body: SingleChildScrollView(
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
              GestureDetector(
                  onDoubleTap: () {
                    widget.post.isLike = true;
                    setState(() {});
                  },
                  child: Container(child: Text(widget.post.mainText))),
              SizedBox(height: 10),
              Container(
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
                    onPressed: () {}),
              ]),
              Divider(),
              ColumnBuilder(
                  itemBuilder: (context, index) {
                    return buildComment();
                  },
                  itemCount: 10)
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildComment() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
    child: Container(
      decoration: BoxDecoration(
          color: primaryColor.withAlpha(10),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  minRadius: 20,
                  maxRadius: 20,
                  child: ClipOval(
                      child: Image.network(
                    gSignIn.currentUser.photoUrl,
                    fit: BoxFit.cover,
                    width: 90.0,
                    height: 90.0,
                  )),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Praveen Venkatesh",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1d",
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
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Text("Awesome work dude! Keep it up. At this rate you are gonna be stupid"),
            )
          ],
        ),
      ),
    ),
  );
}
