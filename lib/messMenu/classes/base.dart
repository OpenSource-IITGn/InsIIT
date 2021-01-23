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
  List labelSizes = [];
  Timer timer;
  int location = 0;

  @override
  void initState() {
    super.initState();
    widget.reload();
    location = 0;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      labelSizes.add(Size(0, 0));
    }
  }

  Widget buildTray() {
    List<Widget> ret = [];
    double originalPad = 10;
    double pad = originalPad;
    double spacing = 10;

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
      bool illustrationAvailable = (dataContainer.mess
                  .foodIllustration[dataContainer.mess.foodItems['list'][i]] !=
              null)
          ? true
          : false;
      ret.add(
        Positioned(
          left: (illustrationAvailable == true)
              ? pad + imageHeight / 8
              : pad + imageHeight / 4,
          top: (illustrationAvailable == true)
              ? imageHeight / 8
              : imageHeight / 4,
          child: (illustrationAvailable == true)
              ? Container(
                  width: imageHeight * 3 / 4,
                  height: imageHeight * 3 / 4,
                  child: CachedNetworkImage(
                    imageUrl: dataContainer.mess.foodIllustration[
                        dataContainer.mess.foodItems['list'][i]],
                    placeholder: (context, url) {
                      return Image.asset('assets/images/taco.png', scale: 20);
                    },
                  ),
                )
              : Image.asset('assets/images/taco.png', scale: 20),
        ),
      );

      double checkWidth = 0;
      if (i < dataContainer.mess.foodItems['list'].length - 1) {
        checkWidth = labelSizes[i + 1].width;
      }
      if (imageHeight < checkWidth) {
        pad += imageHeight + (checkWidth - imageHeight) / 2 + spacing;
      } else {
        pad += imageHeight + spacing;
      }
      checkWidth = labelSizes[i].width;
      if (imageHeight < checkWidth) {
        pad += (checkWidth - imageHeight) / 2 + spacing;
      }
    }
    pad = originalPad;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      if (dataContainer.mess.foodItems['list'][i].trim() == '-') {
        continue;
      }
      ret.add(
        Positioned(
          left: pad + imageHeight / 2 - labelSizes[i].width / 2,
          top: 0,
          child: label(dataContainer.mess.foodItems['list'][i], (size) {
            labelSizes[i] = size;
          }),
        ),
      );
      double checkWidth = 0;
      if (i < dataContainer.mess.foodItems['list'].length - 1) {
        checkWidth = labelSizes[i + 1].width;
      }
      if (imageHeight < checkWidth) {
        pad += imageHeight + (checkWidth - imageHeight) / 2 + spacing;
      } else {
        pad += imageHeight + spacing;
      }
      checkWidth = labelSizes[i].width;
      if (imageHeight < checkWidth) {
        pad += (checkWidth - imageHeight) / 2 + spacing;
      }
    }
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            width: pad, height: imageHeight, child: Stack(children: ret)),
        scrollDirection: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildTray());
  }
}
