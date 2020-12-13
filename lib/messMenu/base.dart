import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instiapp/messMenu/labelDrawer.dart';
import 'package:instiapp/messMenu/plateDraw.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instiapp/utilities/measureSize.dart';
import 'messConstants.dart';

class MessMenuBaseDrawer extends StatefulWidget {
  MessMenuBaseDrawer({Key key}) : super(key: key);

  @override
  _MessMenuBaseDrawerState createState() => _MessMenuBaseDrawerState();
}

class _MessMenuBaseDrawerState extends State<MessMenuBaseDrawer> {
  List visible = [false, false, false, false, false, false, false];
  Size imageSize = Size(0, 0);
  List sizes = [
    Size(0, 0),
    Size(0, 0),
    Size(0, 0),
    Size(0, 0),
    Size(0, 0),
    Size(0, 0),
    Size(0, 0),
  ];
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
    timer = Timer.periodic(Duration(milliseconds: 100), handleTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: ScreenSize.size.width,
      color: Colors.blue.withAlpha(50),
      height: ScreenSize.size.height * 0.3,
      // decoration: BoxDecoration(
      //     color: Colors.grey,
      //     border: Border.all(),
      //     borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Stack(
        children: [
          MeasureSize(
            onChange: (Size size) {
              imageSize = size;
              print("SVG = $imageSize");
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: SvgPicture.asset(
                'assets/images/plate.svg',
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: imageSize.width / 6 - (sizes[0].width / 2),
            child: label('Chinese Salad', visible[0], (size) {
              sizes[0] = size;
            }),
          ),
          Positioned(
            top: 0,
            left: imageSize.width / 2 - (sizes[1].width / 2),
            child: label('White Matar Masala', visible[1], (size) {
              sizes[1] = size;
            }),
          ),
          Positioned(
            top: 0,
            right: imageSize.width / 6 - (sizes[0].width / 2),
            child: label('Mangosteen', visible[2], (size) {
              sizes[2] = size;
            }),
          ),
          Positioned(
            top: imageSize.height * (1 / 3 + 1 / 12),
            right: imageSize.width / 6 - (sizes[3].width / 2),
            child: label('Maggi', visible[3], (size) {
              sizes[3] = size;
            }),
          ),

          // Positioned(
          //     left: ScreenSize.size.width / 5,
          //     child: ),
          // Positioned(left: 120, child: label('Dry\nManchurian')),
          // Positioned(
          //   right: 43,
          //   child: label('Chinese\nSalad'),
          // ),
        ],
      ),
    );
  }
}
