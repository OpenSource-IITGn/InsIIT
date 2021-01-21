import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instiapp/feed/classes/postModel.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin<FeedPage> {
  List<PostModel> posts = [];
  bool loading = true;
  bool reloading = false;
  int offset = 0;
  int numberOfPosts = 3;
  ScrollController _controller = new ScrollController();
  void refresh() {
    setState(() {
      loading = true;
      reloading = false;
    });
    posts = [];
    offset = 0;
    getPosts();
  }

  void getPosts() async {
    var queryParameters = {
      'api_key': 'NIKS',
      'start_from': offset.toString(),
    };
    var uri = Uri.https(baseUrl, '/getFeeds', queryParameters);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (responseJson['success'] == true) {
        numberOfPosts = responseJson['results'].length;
        for (int i = 0; i < numberOfPosts; i++) {
          posts.add(PostModel.fromJson(responseJson, i));
        }
      }
    }
    setState(() {
      loading = false;
      reloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();

    _controller.addListener(() {
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = 200.0; // or something else..
      if (maxScroll - currentScroll <= delta &&
          numberOfPosts != 0 &&
          reloading == false) {
        reloading = true;
        setState(() {});
        offset += 3;
        getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hashtags');
              },
              child: Icon(Icons.sort_rounded)),
          body: (loading == true)
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: theme.iconColor,
                ))
              : RefreshIndicator(
                  onRefresh: () {
                    refresh();
                    return Future.value(true);
                  },
                  child: ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (reloading == true && index == posts.length) {
                        return Center(
                            child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                          child: CircularProgressIndicator(
                            backgroundColor: theme.iconColor,
                          ),
                        ));
                      }
                      return PostWidget(post: posts[index]);
                    },
                    itemCount:
                        (reloading == true) ? posts.length + 1 : posts.length,
                  ),
                )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
