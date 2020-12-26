import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instiapp/messMenu/classes/labelDrawer.dart';
import 'package:instiapp/data/dataContainer.dart';
import 'package:instiapp/utilities/measureSize.dart';

class MessMenuBaseDrawer extends StatefulWidget {
  var reload;
  MessMenuBaseDrawer(Function f) {
    this.reload = f;
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
    if (location == visible.length) {
      timer.cancel();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.reload();
    location = 0;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      visible.add(false);
      sizes.add(Size(0, 0));
      imageSizes.add(Size(0, 0));
    }
    timer = Timer.periodic(Duration(milliseconds: 100), handleTimer);
  }

  Widget buildTray() {
    List<Widget> ret = [];
    double originalPad = imageSizes[0].width / 2;
    double pad = originalPad;
    double spacing = 30;

    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      if (dataContainer.mess.foodItems['list'][i].trim() == '-') {
        continue;
      }
      ret.add(
        Positioned(
          left: pad,
          child: MeasureSize(
            onChange: (Size size) {
              imageSize = size;
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Image.asset(
                'assets/images/plate.png',
                scale: 6,
              ),
            ),
          ),
        ),
      );
      ret.add(
        Positioned(
          left: pad + imageSize.width / 2 - imageSizes[i].width / 2,
          top: imageSize.height / 2 - imageSizes[i].height / 2,
          child: MeasureSize(
            onChange: (Size size) {
              imageSizes[i] = size;
              setState(() {});
            },
            child: Image.network(
              (dataContainer.mess.foodIllustration.containsKey(dataContainer.mess.foodItems['list'][i]))
                  ? dataContainer.mess.foodIllustration[dataContainer.mess.foodItems['list'][i]]
                  : 'https://drive.google.com/uc?export=view&id=1Dgm6bIcoeZA2u5JNozcD64QpX81Y8unZ',
              scale: 20,
            ),
          ),
        ),
      );

      if (imageSize.width < sizes[i].width) {
        pad +=
            imageSize.width + (sizes[i].width - imageSize.width) / 3 + spacing;
      } else {
        pad += imageSize.width + spacing;
      }
    }
    pad = originalPad;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      if (dataContainer.mess.foodItems['list'][i].trim() == '-') {
        continue;
      }
      ret.add(
        Positioned(
          left: pad + imageSize.width / 2 - sizes[i].width / 2,
          top: 0,
          child: label(dataContainer.mess.foodItems['list'][i], visible[i], (size) {
            sizes[i] = size;
          }),
        ),
      );
      if (imageSize.width < sizes[i].width) {
        pad +=
            imageSize.width + (sizes[i].width - imageSize.width) / 3 + spacing;
      } else {
        pad += imageSize.width + spacing;
      }
    }
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            width: (imageSize.width + 50) * dataContainer.mess.foodItems['list'].length,
            height: imageSize.height,
            child: Stack(children: ret)),
        scrollDirection: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildTray());
  }
}
