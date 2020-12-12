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
  Widget label(String text) {
    return Center(
      child: Container(
        decoration: ShapeDecoration(
          color: popupColor,
          shape: LabelBorder(arrowArc: 0.1),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  final String rawSvg = '''<svg viewBox="...">...</svg>''';

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: ScreenSize.size.width,
        // decoration: BoxDecoration(
        //     color: Colors.grey,
        //     border: Border.all(),
        //     borderRadius: BorderRadius.all(Radius.circular(20))),
        // child: SvgPicture.asset(
        //   'assets/images/plate.svg',
        // ),
        child: CustomPaint(
            size: Size(50, 50), //2
            // painter: ProfileCardPainter(color: profileColor), //3
            painter: PlatePainter()),
        // child: Table(
        //   columnWidths: {
        //     0: FlexColumnWidth(1),
        //     1: FlexColumnWidth(1),
        //   },
        //   children: [
        //     TableRow(children: [
        //       TableCell(
        //           child: Center(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Container(
        //               height: ScreenSize.size.height * 0.25 / 3,
        //               width: ScreenSize.size.height / 6,
        //               decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   border: Border.all(),
        //                   borderRadius: BorderRadius.all(Radius.circular(20))),
        //               child: label('Curd')),
        //         ),
        //       )),
        //       TableCell(child: label('Egg Bhurji')),
        //     ]),
        //     TableRow(children: [
        //       TableCell(child: label('Bread')),
        //       TableCell(child: label('Panneer Paratha')),
        //     ]),
        //   ],
        // ),
        height: ScreenSize.size.height * 0.25);
  }
}
