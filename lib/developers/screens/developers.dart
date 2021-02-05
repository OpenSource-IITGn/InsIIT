import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/constants.dart';

class DevModel {
  String login;
  String name;
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  String avatar_url;
  String profile;
  List<String> contributions;
  DevModel({
    this.login,
    this.name,
    // ignore: non_constant_identifier_names
    this.avatar_url,
    this.profile,
    this.contributions,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'name': name,
      'avatar_url': avatar_url,
      'profile': profile,
      'contributions': contributions,
    };
  }

  factory DevModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DevModel(
      login: map['login'],
      name: map['name'],
      avatar_url: map['avatar_url'],
      profile: map['profile'],
      contributions: List<String>.from(map['contributions']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DevModel.fromJson(String source) =>
      DevModel.fromMap(json.decode(source));
}

class DevelopersPage extends StatefulWidget {
  DevelopersPage({Key key}) : super(key: key);

  @override
  _DevelopersPageState createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {
  bool loading = true;
  List<DevModel> devs = [];

  void refresh() {
    loading = true;
    devs = [];
    setState(() {});
    http
        .get(
            "https://raw.githubusercontent.com/praveenVnktsh/IITGN-Institute-App/dev/.all-contributorsrc")
        .then((value) {
      List body = jsonDecode(value.body)['contributors'];
      for (int i = 0; i < body.length; i++) {
        devs.add(DevModel.fromMap(body[i]));
      }
      loading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.github),
            onPressed: () {
              launch('https://github.com/praveenVnktsh/IITGN-Institute-App');
            },
          ),
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: theme.iconColor,
              ),
              onPressed: () {
                refresh();
              })
        ],
        centerTitle: true,
        title: Text('Team InsIIT',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: theme.textHeadingColor)),
      ),
      body: (loading == true)
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: theme.iconColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: devs.length,
                itemBuilder: (context, index) {
                  return GridTile(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.black,
                          child: InkWell(
                            onTap: () {
                              launch(devs[index].profile);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                    height: ScreenSize.size.width / 2 - 16,
                                    width: ScreenSize.size.width / 2 - 16,
                                    child: CachedNetworkImage(
                                        imageUrl: devs[index].avatar_url)),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    color: Colors.white.withAlpha(200),
                                    width: ScreenSize.size.width / 2 - 16,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: 8),
                                        Text(
                                          devs[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          devs[index].login,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
