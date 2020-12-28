import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/feed/classes/commentModel.dart';
import 'package:instiapp/feed/classes/postModel.dart';
import 'package:instiapp/utilities/columnBuilder.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'package:instiapp/globalClasses/user.dart';

class FullPostPage extends StatefulWidget {
  PostModel post;
  FullPostPage({this.post});

  @override
  _FullPostPageState createState() => _FullPostPageState();
}

class _FullPostPageState extends State<FullPostPage> {
  String comment = '';
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void postComment(String commentText) async {
    var commentObj = CommentModel(
        poster: User(
            name: dataContainer.auth.user.name,
            imageUrl: dataContainer.auth.user.imageUrl,
            uid: dataContainer.auth.user.uid),
        text: commentText,
        timestamp: dateFormat.format(DateTime.now()),
        timeText: 'now');
    widget.post.comments.add(commentObj);
    setState(() {});

    ///postComment?api_key=NIKS&feed_id=5eba443934175d4e208e9058
    var queryParameters = {
      'api_key': 'NIKS',
      'feed_id': widget.post.postId.toString(),
    };
    var uri = Uri.https(baseUrl, '/postComment', queryParameters);
    print("PINGING:" + uri.toString());
    var jsonComment = jsonEncode(commentObj.toJson());
    print("SENDING: " + jsonComment.toString());
    var response =
        await http.post(uri, body: jsonComment, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    print('RECEIVED: ' + response.statusCode.toString());
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PostWidget(
                post: widget.post,
                showMore: true,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  controller: controller,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  onChanged: (value) {
                    comment = value;
                  },
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: 'Comment...',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (comment.trim().length > 0) {
                            postComment(comment);
                            controller.clear();
                          }

                          FocusScope.of(context).unfocus();
                        },
                      ),
                      prefixText: ' ',
                      suffixStyle: const TextStyle(color: Colors.green)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ColumnBuilder(
                    itemBuilder: (context, index) {
                      return buildComment(widget.post.comments[index]);
                    },
                    itemCount: widget.post.comments.length),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildComment(CommentModel comment) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
    child: Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
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
                    comment.poster.imageUrl,
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
                      comment.poster.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      comment.timeText,
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Text(comment.text),
            )
          ],
        ),
      ),
    ),
  );
}
