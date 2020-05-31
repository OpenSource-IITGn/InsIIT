import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:instiapp/utilities/googleSheets.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:instiapp/utilities/constants.dart';

class MapInfoWindow {
   String imagePath;
   LatLng location;
   String locationName;
   String timing;
   String descriptionOne;
   String descriptionTwo;

   MapInfoWindow({
      this.imagePath,
      this.location,
      this.locationName,
      this.timing,
      this.descriptionOne,
      this.descriptionTwo});
}

var keywordList = [];
var locationList = [];

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  Location _locationTracker = Location();

  StreamSubscription _locationSubscription;

  Marker marker;

  Circle circle;

  static const LatLng _center = const LatLng(23.212838, 72.684738);

  GSheet sheet = GSheet('1dEsbM4uTo7VeOZyJE-8AmSWJv_XyHjNSVsKpl1GBaz8');

  Set<Marker> _markers = {};

  BitmapDescriptor customIcon;

  double mapInfoWindowPosition = -370;

  MapInfoWindow currentWindow = MapInfoWindow(
    imagePath: '',
    location: LatLng(0,0),
    locationName: '',
    timing: '',
    descriptionOne: '',
    descriptionTwo: '');

  var mapInfoWindowList = [];

  String _mapStyle;

  @override
  void initState() {
    super.initState();
    setCustomIcon();
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
    _mapStyle = string;
    });
  }

  void updateMarkerAndCircle(LocationData newLocalData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("User"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: customIcon);
      _markers.add(marker);
      circle = Circle(
          circleId: CircleId("Accuracy"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {

      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }


      _locationSubscription = _locationTracker.onLocationChanged.listen((LocationData newLocalData) {
          updateMarkerAndCircle(newLocalData);
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  void setCustomIcon() async {
   customIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/mark.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setState(() {
      _markerSet();
    });
    getCurrentLocation();
    controller.setMapStyle(_mapStyle);
  }

  MapType _currentMapType = MapType.hybrid;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.hybrid
          : MapType.normal;
    });
  }

  _markerSet() async{
    sheet.getData('map!A:J').listen((data){
      var mapData = data;
      mapInfoWindowList = [];
      locationList = [];
      keywordList = [];
      mapData.removeAt(0);
      mapData.forEach((location) {
        locationList.add(location[1]);
        keywordList.add(location[1] + location[8]);
        mapInfoWindowList.add(MapInfoWindow(
          locationName: location[1],
          location: LatLng(double.parse(location[3]), double.parse(location[4])),
          imagePath: location[9],
          timing: location[5],
          descriptionOne: location[6],
          descriptionTwo: location[7],
        ));
        _markers.add(Marker(
          markerId: MarkerId(location[1]),
          position: LatLng(double.parse(location[3]), double.parse(location[4])),
          infoWindow: InfoWindow(
            title: location[1],
            snippet: location[5],
          ),
          onTap: () {
              setState(() {
                currentWindow = mapInfoWindowList[int.parse(location[0])];
                mapInfoWindowPosition = -170;
              });
          },
          icon: customIcon,
        ));
       });
    });
    return _markers;
  }

  moveCamera(CameraPosition position) async{
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void launchMap(double lat, double long) async{
      String url = "https://www.google.com/maps/search/?api=1&query=$lat,$long";
      if (await canLaunch(url)) {
        print("Can launch");
        void initState(){
          canLaunch( url);
        }

        await launch(url);
      } else {
        print("Could not launch");
        throw 'Could not launch Maps';
      }
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              mapType: _currentMapType,
              padding: EdgeInsets.only(top: 55.0),
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              scrollGesturesEnabled: true,
              rotateGesturesEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: _onMapCreated,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                  new Factory<OneSequenceGestureRecognizer>(() => new EagerGestureRecognizer(),),
              ].toSet(),
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 17.2,
                tilt: 30.0,
                bearing: 180.0,
              ),
              markers: _markers,
              circles: Set.of((circle != null) ? [circle] : []),
              onTap: (LatLng location) {
                  setState(() {
                  mapInfoWindowPosition = -370;
               });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearch(),
                        ).then((value) => setState((){
                            currentWindow = mapInfoWindowList[int.parse(value)];
                            mapInfoWindowPosition = -170;
                            moveCamera(CameraPosition(
                                        target: currentWindow.location,
                                        zoom: 17.2,
                                        tilt: 30.0,
                                        bearing: 180.0,
                            ));
                          }));
                      },
                      heroTag: "btn1",
                      backgroundColor: Colors.white,
                      tooltip: 'Search',
                      child: Icon(Icons.search, color: Colors.black45),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      onPressed: _onMapTypeButtonPressed,
                      heroTag: "btn2",
                      backgroundColor: Colors.white,
                      tooltip: 'Layers',
                      child: Icon(Icons.layers, color: Colors.black45),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: mapInfoWindowPosition,
              left: 0,
              right: 0,
              duration: Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                          mapInfoWindowPosition = 0;
                        });
                    }, 
                    onVerticalDragDown: (details) {
                      setState(() {
                          mapInfoWindowPosition = 0;
                        });
                    },   
                    onDoubleTap: (){
                      setState(() {
                          mapInfoWindowPosition = -170;
                        });
                    },
                    child: Container(
                        margin: EdgeInsets.all(15),
                        height: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 15,
                                  offset: Offset.zero,
                                  color: Colors.black.withOpacity(0.4)
                            )]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)
                                ),
                                child: Image(
                                  image: NetworkImage(currentWindow.imagePath),
                                  height: 100,
                                  width: 1040,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(top: 0),
                              child: 
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                currentWindow.locationName,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              Text(
                                                currentWindow.timing,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ), 
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(22),
                                        child: CircleAvatar(
                                          radius: 33,
                                          backgroundColor: primaryColor,
                                          foregroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              launchMap(currentWindow.location.latitude, currentWindow.location.longitude);
                                            },
                                            tooltip: 'Directions',
                                            icon: Icon(Icons.directions),
                                          ),
                                        ), 
                                      ),
                                    ],
                                  ),                        
                            ),
                            Container(
                              height: 150,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                currentWindow.descriptionOne,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ), 
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 40.0,
                                    thickness: 0.9,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20, right: 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                currentWindow.descriptionTwo,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ), 
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomSearch extends SearchDelegate<String>{

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   assert(context != null);
  //   final ThemeData theme = Theme.of(context);
  //   assert(theme != null);
  //   return theme.copyWith(
  //     inputDecorationTheme: InputDecorationTheme(
  //           hintStyle: TextStyle(color: theme.primaryTextTheme.headline6.color.withOpacity(0.6))),
  //       primaryColor: theme.primaryColor,
  //       primaryIconTheme: theme.primaryIconTheme,
  //       primaryColorBrightness: theme.primaryColorBrightness,
  //       primaryTextTheme: theme.primaryTextTheme,
  //       textTheme: theme.textTheme.copyWith(
  //           headline6: theme.textTheme.headline6
  //               .copyWith(color: theme.primaryTextTheme.headline6.color))
  //   );
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,        
        ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty){
      return Container(
        margin: EdgeInsets.all(15),
        height: 425,
        decoration: BoxDecoration(
            color: Colors.white10,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/images/map_search.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  "This location search is powered by a comprehensive list of keywords. For example, if you search 'library', Academic Block-3 will come up as that's where our library is.",
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
      final suggestions = locationList.where((p) => keywordList[locationList.indexOf(p)].toLowerCase().contains(query.toLowerCase())).toList();
      print(locationList);
      return ListView.builder(
        itemBuilder: (context, index) =>ListTile(
          onTap: (){
            close(context, locationList.indexOf(suggestions[index]).toString());
          },
          leading: Icon(Icons.location_city),
          title: Text(suggestions[index]),
          ),
        itemCount: suggestions.length,
        );
    }
    
  }

}