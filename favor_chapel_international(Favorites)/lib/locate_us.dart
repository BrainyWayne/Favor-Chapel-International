import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class LocateUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Favor Chapel International',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();



}

class MapSampleState extends State<MapSample> {



  @override
  void initState() {
    _goToTheLake();

    super.initState();
  }



  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(6.6735341,-1.633525),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {




    return new Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kLake,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,

          ),

          Positioned(
            right: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.blue
              ),
              margin: EdgeInsets.only(right: 20, top: 50),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.decelerate,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    InkWell(
                      child: Row(
                        children: <Widget>[
                          Text('Open with Maps', style: TextStyle(fontSize: 17, color: Colors.white),),
                          SizedBox(width: 5,),
                          CircleAvatar(
                            radius: 17,
                            child: Icon(Icons.map, size: 17,),
                          ),


                        ],
                      ),
                      onTap: (){
                        _launchURL();
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ] ,
      ),



      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Navigate to Favor Chapel International'),
        icon: Icon(Icons.play_arrow),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  _launchURL() async {
    const url = "google.navigation:q=${6.6735341},${-1.633525}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


}

