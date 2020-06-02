
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instiapp/utilities/dot_indicator.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<dynamic> imageUrls;
  final BorderRadius imageBorderRadius;
  final double imageHeight;

  const ImageSliderWidget({
    Key key,
    @required this.imageUrls,
    @required this.imageBorderRadius,
    this.imageHeight = 350.0,
  }) : super(key: key);

  @override
  ImageSliderWidgetState createState() {
    return new ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<Widget> _pages = [];

  int page = 0;

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls.map((url) {
      return _buildImagePageItem(url);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      height: 350.0,
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(width: 0, color: primaryColor),
          color: Colors.grey.withAlpha(10),
        ),
        child: Padding(
          // padding: const EdgeInsets.fromLTRB(16,0,16,0),
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: Stack(
            children: [
              _buildPagerViewSlider(),
              _buildDotsIndicatorOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (int p) {
          setState(() {
            page = p;
          });
        },
      ),
    );
  }

  Positioned _buildDotsIndicatorOverlay() {
    return Positioned(
      bottom: 20.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotsIndicator(
          controller: _controller,
          itemCount: _pages.length,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePageItem(String imgUrl) {
    return ClipRRect(
      borderRadius: widget.imageBorderRadius,
      child: Image.network(
        imgUrl,
        // placeholder: (context, url) => Center(
        //   child: Platform.isIOS
        //       ? CupertinoActivityIndicator()
        //       : CircularProgressIndicator(),
        // ),
        fit: BoxFit.contain,
      ),
    );
  }
}
