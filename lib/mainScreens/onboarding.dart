import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class OnboardingPage extends StatefulWidget {
  @override
  OnboardingPageState createState() {
    return new OnboardingPageState();
  }
}

class OnboardingPageState extends State<OnboardingPage> {
  int _slideIndex = 0;
  // final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final List<String> images = [
    //(beta)"assets/images/slide_1.png",
    "assets/images/slide_2.png",
    "assets/images/slide_3.png",
    "assets/images/slide_4.png",
    //(beta)"assets/images/slide_5.png",
    //(beta)"assets/images/slide_6.png",
    //(beta)"assets/images/slide_7.png",
    "assets/images/slide_8.png",
    "assets/images/slide_9.png",
    ""
  ];

  final List<String> text0 = [
    //(beta)"Feed",
    "Mess Menu",
    "Campus Map",
    "Shuttle Timings",
    //(beta)"Schedule",
    //(beta)"Calendar",
    //(beta)"Booking",
    "Contacts",
    "Quick Links",
    ""
  ];

  final List<String> text1 = [
    //(beta)"View announcements and news",
    "Know what's in the mess and give feedback",
    "Search for places and get directions",
    "Know timings and set reminders",
    //(beta)"Know what's on your day",
    //(beta)"All events in one place",
    //(beta)"Book rooms, 3D printers and more",
    "Important campus contacts",
    "A collection of IITGN links",
    ""
  ];

  final IndexController controller = IndexController();
  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          if (this._slideIndex == 4 /*(beta)8*/) {
            Navigator.pop(context);
          }
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
            color: Colors.white,
            elevation: 0.0,
            textStyle: new TextStyle(color: Colors.white),
            borderRadius: new BorderRadius.circular(12.0),
            child: new Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new ParallaxContainer(
                      child: new Text(
                        text0[info.index],
                        style: new TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 34.0,
                        ),
                      ),
                      position: info.position,
                      opacityFactor: .8,
                      translationFactor: 400.0,
                    ),
                    SizedBox(
                      height: 45.0,
                    ),
                    new ParallaxContainer(
                      child: new Image.asset(
                        images[info.index],
                        fit: BoxFit.contain,
                        height: 350,
                      ),
                      position: info.position,
                      translationFactor: 400.0,
                    ),
                    SizedBox(
                      height: 45.0,
                    ),
                    new ParallaxContainer(
                      child: new Text(
                        text1[info.index],
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          color: Colors.indigo,
                          fontSize: 28.0,
                        ),
                      ),
                      position: info.position,
                      translationFactor: 300.0,
                    ),
                    SizedBox(
                      height: 55.0,
                    ),
                    new ParallaxContainer(
                      position: info.position,
                      translationFactor: 500.0,
                      child: Dots(
                        controller: controller,
                        slideIndex: _slideIndex,
                        numberOfDots: images.length - 1,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
        itemCount: 6 /*(beta)10*/);

    return Scaffold(
      backgroundColor: Colors.white,
      body: transformerPageView,
    );
  }
}

class Dots extends StatelessWidget {
  final IndexController controller;
  final int slideIndex;
  final int numberOfDots;
  Dots({this.controller, this.slideIndex, this.numberOfDots});

  List<Widget> _generateDots() {
    List<Widget> dots = [];
    for (int i = 0; i < numberOfDots; i++) {
      dots.add(i == slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  Widget _activeSlide(int index) {
    return GestureDetector(
      onTap: () {},
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
              color: Colors.indigoAccent.withOpacity(.3),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return GestureDetector(
      onTap: () {
        controller.move(index);
      },
      child: new Container(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _generateDots(),
    ));
  }
}
