import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/messMenu/classes/labelDrawer.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/utilities/measureSize.dart';
import 'package:instiapp/utilities/constants.dart';

class MessMenuBaseDrawer extends StatefulWidget {
  var reload;
  MessMenuBaseDrawer(Function f) {
    this.reload = f;
  }

  @override
  _MessMenuBaseDrawerState createState() => _MessMenuBaseDrawerState();
}

class _MessMenuBaseDrawerState extends State<MessMenuBaseDrawer> {
  List sizes = [];
  Timer timer;
  int location = 0;

  @override
  void initState() {
    super.initState();
    widget.reload();
    location = 0;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      sizes.add(Size(0, 0));
    }
  }

  Widget buildTray() {
    List<Widget> ret = [];
    double originalPad = 10;
    double pad = originalPad;
    double spacing = 0;

    double imageHeight = ScreenSize.size.width * 0.3;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      if (dataContainer.mess.foodItems['list'][i].trim() == '-') {
        continue;
      }
      ret.add(
        Positioned(
          left: pad,
          top: 0,
          child: Container(
            color: Colors.black.withAlpha(100),
            width: imageHeight,
            height: imageHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Image.asset(
                'assets/images/plate.png',
              ),
            ),
          ),
        ),
      );
      ret.add(
        Positioned(
          left: pad + imageHeight / 8,
          top: imageHeight / 8,
          child: (dataContainer.mess.foodIllustration[
                      dataContainer.mess.foodItems['list'][i]] !=
                  null)
              ? Container(
                  width: imageHeight * 3 / 4,
                  height: imageHeight * 3 / 4,
                  child: CachedNetworkImage(
                    imageUrl: dataContainer.mess.foodIllustration[
                        dataContainer.mess.foodItems['list'][i]],
                    placeholder: (context, url) {
                      return Image.asset('assets/images/taco.png', scale: 20);
                    },
                    // scale: 20,
                  ),
                )
              : Image.asset('assets/images/taco.png', scale: 20),
        ),
      );

      if (imageHeight < sizes[i].width) {
        pad += imageHeight + spacing;
      } else {
        pad += imageHeight + spacing;
      }
    }
    pad = originalPad;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      if (dataContainer.mess.foodItems['list'][i].trim() == '-') {
        continue;
      }
      ret.add(
        Positioned(
          left: pad + imageHeight / 2 - sizes[i].width / 2,
          top: 0,
          child: label(dataContainer.mess.foodItems['list'][i], (size) {
            sizes[i] = size;
          }),
        ),
      );
      if (imageHeight < sizes[i].width) {
        pad += imageHeight + (sizes[i].width - imageHeight) / 3 + spacing;
      } else {
        pad += imageHeight + spacing;
      }
    }
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            width: (imageHeight + 50) *
                dataContainer.mess.foodItems['list'].length,
            height: imageHeight,
            child: Stack(children: ret)),
        scrollDirection: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildTray());
  }
}
