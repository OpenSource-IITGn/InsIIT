import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
  Size imageSize = Size(0, 0);
  List sizes = [];
  List imageSizes = [];
  Timer timer;
  int location = 0;

  @override
  void initState() {
    super.initState();
    widget.reload();
    location = 0;
    for (int i = 0; i < dataContainer.mess.foodItems['list'].length; i++) {
      sizes.add(Size(0, 0));
      imageSizes.add(Size(0, 0));
    }
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
            child: (dataContainer.mess.foodIllustration[
                        dataContainer.mess.foodItems['list'][i]] !=
                    null)
                ? CachedNetworkImage(
                    imageUrl: dataContainer.mess.foodIllustration[
                        dataContainer.mess.foodItems['list'][i]],
                    placeholder: (context, url) {
                      return Image.asset('assets/images/taco.png', scale: 20);
                    },
                    // scale: 20,
                  )
                : Image.asset('assets/images/taco.png', scale: 20),
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
          child: label(dataContainer.mess.foodItems['list'][i], (size) {
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
            width: (imageSize.width + 50) *
                dataContainer.mess.foodItems['list'].length,
            height: imageSize.height,
            child: Stack(children: ret)),
        scrollDirection: Axis.horizontal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: buildTray());
  }
}
