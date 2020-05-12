import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:instiapp/classes/postModel.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:http/http.dart' as http;

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String baseUrl = "serene-reaches-30469.herokuapp.com";
  List<PostModel> posts = [];
  bool loading = true;
  int offset = 0;
  ScrollController _controller = new ScrollController();
  void getPosts() async {
    var queryParameters = {
      'api_key': 'NIKS',
      'start_from': offset.toString(),
    };
    var uri = Uri.https(baseUrl, '/getFeeds', queryParameters);
    print("PINGING:" + uri.toString());
    var response = await http.get(uri);
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    print("Number of posts: ${responseJson['results'].length}");
    for (int i = 0; i < responseJson['results'].length; i++) {
      posts.add(PostModel.fromJson(responseJson, i));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();

    _controller.addListener(() {
      double maxScroll = _controller.position.maxScrollExtent;
      double currentScroll = _controller.position.pixels;
      double delta = 200.0; // or something else..
      print(maxScroll - currentScroll);
      if (maxScroll - currentScroll <= delta) {
        offset += 3;
        getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Feed")),
        body: Stack(
          children: [
            (loading == true)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      return PostWidget(post: posts[index]);
                      // return PostWidget(
                      //     post: PostModel(
                      //   imageUrl:
                      //       "https://media-exp1.licdn.com/dms/image/C5122AQGslzBQRocPAA/feedshare-shrink_800/0?e=1592438400&v=beta&t=e5KSULCqB7pDJpd6_QwhX6gFeaWO43QUgpvXXCwTZC0",
                      //   mainText:
                      //       "COVID 19 Control Room Dashboard for GNius. Back at the IITGN campus, a student run control room has been set up to contain the spread of COVID-19. Today morning I set up a small update for the GNius app (IITGNs student app) that contains useful information for students still on campus sourced directly with from the control room. Thanks to Prof Madhu Vadali for the opportunity.COVID 19 Control Room Dashboard for GNius. Back at the IITGN campus, a student run control room has been set up to contain the spread of COVID-19. Today morning I set up a small update for the GNius app (IITGNs student app) that contains useful information for students still on campus sourced directly with from the control room. Thanks to Prof Madhu Vadali for the opportunity.COVID 19 Control Room Dashboard for GNius. Back at the IITGN campus, a student run control room has been set up to contain the spread of COVID-19. Today morning I set up a small update for the GNius app (IITGNs student app) that contains useful information for students still on campus sourced directly with from the control room. Thanks to Prof Madhu Vadali for the opportunity.",
                      //   postPersonBio: "B.Tech EE, 2nd year",
                      //   timeElapsed: '1d',
                      //   postPerson: "Praveen Venkatesh",
                      //   postPersonUrl: gSignIn.currentUser.photoUrl,
                      // ));
                    },
                    itemCount: posts.length,
                  ),
            Positioned(
                top: ScreenSize.size.height / 3,
                left: ScreenSize.size.width / 6,
                child:
                    Container(color: Colors.red, child: Text("IN PROGRESS", style: TextStyle(fontSize: 40),))),
          ],
        ));
  }
}
