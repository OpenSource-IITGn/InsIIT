import 'package:flutter/material.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/themeing/notifier.dart';

class HashtagPage extends StatefulWidget {
  HashtagPage({Key key}) : super(key: key);

  @override
  _HashtagPageState createState() => _HashtagPageState();
}

class _HashtagPageState extends State<HashtagPage> {
  bool loading = true;
  bool error = false;

  void reload() {
    setState(() {
      loading = true;
    });
    dataContainer.feed.loadHashtags().then((success) {
      setState(() {
        loading = false;
        error = !success;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text('Explore Topics',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              onPressed: () {
                reload();
              },
            )
          ],
        ),
        body: (loading == true)
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: theme.iconColor,
              ))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var hashTag = dataContainer.feed.hashTags[index];
                    return Card(
                      color: (hashTag.following == true)
                          ? Colors.green.withAlpha(60)
                          : Colors.white,
                      child: InkWell(
                        onTap: () {
                          dataContainer.feed.hashTags[index].following =
                              !dataContainer.feed.hashTags[index].following;
                          dataContainer.feed.addRemoveUserForHashtag(hashTag.id,
                              dataContainer.feed.hashTags[index].following);
                          setState(() {});
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("#" + hashTag.name),
                        ),
                      ),
                    );
                  },
                  itemCount: dataContainer.feed.hashTags.length,
                ),
              ),
      ),
    );
  }
}
