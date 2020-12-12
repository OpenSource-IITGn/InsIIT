import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instiapp/messMenu/labelDrawer.dart';
import 'package:instiapp/messMenu/plateDraw.dart';
import 'package:instiapp/utilities/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'messConstants.dart';

class MessMenuBaseDrawer extends StatefulWidget {
  MessMenuBaseDrawer({Key key}) : super(key: key);

  @override
  _MessMenuBaseDrawerState createState() => _MessMenuBaseDrawerState();
}

class _MessMenuBaseDrawerState extends State<MessMenuBaseDrawer> {
  final String rawSvg = '''<svg viewBox="...">...</svg>''';
  List visible = [false, false, false, false, false, false, false];
  Timer timer;
  int location = 0;
  void handleTimer(timer) {
    print('TIMER');
    print(location);
    visible[location] = true;
    location += 1;
    if (location == visible.length - 1) {
      timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    location = 0;
    timer = Timer.periodic(Duration(milliseconds: 500), handleTimer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: ScreenSize.size.width,
        // color: Colors.blue.withAlpha(50),
        // decoration: BoxDecoration(
        //     color: Colors.grey,
        //     border: Border.all(),
        //     borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/images/plate.svg',
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                // color: Colors.indigo.withAlpha(100),
                width: ScreenSize.size.width - 32,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          label('Chinese Salad', visible[0]),
                          label('Hakka Noodles', visible[1]),
                          label('Hakka Noodles', visible[2]),
                        ]),
                    SizedBox(height: 50),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          label('Mango', visible[3]),
                          label('Dry Manchurian', visible[4]),
                          label('Hakka Noodles', visible[5]),
                        ]),
                  ],
                ),
              ),
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
        height: ScreenSize.size.height * 0.3);
  }
}
