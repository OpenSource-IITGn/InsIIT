import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instiapp/messMenu/labelDrawer.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instiapp/utilities/measureSize.dart';

class MessMenuBaseDrawer extends StatefulWidget {
  var foodItems;
  MessMenuBaseDrawer(meal) {
    this.foodItems = meal;
  }
  @override
  _MessMenuBaseDrawerState createState() => _MessMenuBaseDrawerState();
}

class _MessMenuBaseDrawerState extends State<MessMenuBaseDrawer> {
  List visible = [];
  Size imageSize = Size(0, 0);
  List sizes = [];
  List imageSizes = [];
  Timer timer;
  int location = 0;
  void handleTimer(timer) {
    visible[location] = true;
    location += 1;
    if (location == visible.length - 1) {
      timer.cancel();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    location = 0;

    for (int i = 0; i < widget.foodItems['list'].length; i++) {
      visible.add(false);
      sizes.add(Size(0, 0));
      imageSizes.add(Size(0, 0));
    }
    timer = Timer.periodic(Duration(milliseconds: 100), handleTimer);
  }

  Widget buildTray() {
    List<Widget> ret = [];
    double prevLeftPadding = 0;
    double prevTopPadding = 0;
    for (int i = 0; i < widget.foodItems['list'].length; i++) {
      ret.add(Positioned(
        left: prevLeftPadding,
        top: prevTopPadding,
        child: MeasureSize(
          onChange: (Size size) {
            imageSize = size;
            print("SVG = $imageSize");
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Image.asset(
              'assets/images/plate.png',
              scale: 6,
            ),
          ),
        ),
      ));
      ret.add(
        Positioned(
          left: prevLeftPadding + imageSize.width / 2 - imageSizes[i].width / 2,
          top: prevTopPadding + imageSize.height / 2 - imageSizes[i].height / 2,
          child: MeasureSize(
            onChange: (Size size) {
              imageSizes[i] = size;
            },
            child: Image.asset(
              'assets/images/avatar.png',
              scale: 10,
            ),
          ),
        ),
      );
      ret.add(
        Positioned(
          top: prevTopPadding,
          left: prevLeftPadding + imageSize.width / 2 - sizes[i].width / 2,
          child: label(widget.foodItems['list'][i], visible[i], (size) {
            sizes[i] = size;
          }),
        ),
      );
      print("${widget.foodItems['list'][i]} = $prevTopPadding");
      prevLeftPadding += imageSize.width + 20;
      if (prevLeftPadding >= ScreenSize.size.width * 9 / 10) {
        prevLeftPadding = 0;
        prevTopPadding += imageSize.height + 20;
      }
    }

    return Stack(children: ret);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: ScreenSize.size.width,
        // color: Colors.blue.withAlpha(50),
        height: ScreenSize.size.height * 0.3,
        width: ScreenSize.size.width,
        // decoration: BoxDecoration(
        //     color: Colors.grey,
        //     border: Border.all(),
        //     borderRadius: BorderRadius.all(Radius.circular(20))),
        child: buildTray());
  }
}
