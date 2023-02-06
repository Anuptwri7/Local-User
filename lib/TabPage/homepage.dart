import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/Pages/homePageUser.dart';

import '../Helpers/styleConst.dart';
import '../services/currenLocation.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
// var location = '';


String location ='Null, Press Button';
String currentAddress = 'Searching';
Future<Position> _getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {

    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}
Future<void> GetAddressFromLatLong(Position position)async {
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  print(placemarks);
  Placemark place = placemarks[0];
  currentAddress = '${place.street}, ${place.subLocality}, ${place.locality}';
  log(currentAddress.toString());


  setState(()  {
  });
}

// void getCurrentLocation()async{
//   var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   var lastposition = await Geolocator.getLastKnownPosition();
//   log(position.toString());
//   getAddressFromLatLng(position);
//
//
// }
//
// Future<void> getAddressFromLatLng(Position position)async{
//   List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
//   log(placemark.toString());
//
// }
var currentLat=0.0;
var currentLng=0.0;

  void get() async{
    Position position = await _getGeoLocationPosition();
    location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    saveCurrentLocation(position.latitude,position.longitude);

    log(position.longitude.toString());

  }

@override
  void initState() {
  super.initState();
  get();



  // getCurrentLocation();
    // TODO: implement initState

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: [

            ],
            leading: const Icon(
              Icons.location_on_rounded,
              color: Colors.black,
            ),
            title: Text(
              currentAddress=='Search'? "Loading...":currentAddress,
              style: TextStyle(color: Colors.black, fontSize: 12,),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 00.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap:()=>{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePageUser()))        
              },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width/4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children:  [
                                Icon(Icons.directions_bike,size: 30,color: homeTabPageOptionIconColor,),

                                SizedBox(height: 5,),
                                Text(
                                  "Bike",
                                  style: homeTabPageOptionText
                                ),

                              ],
                            ),
                          ),
                          decoration: homeTabPageOptionDecoration
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width/4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children:  [
                              Icon(Icons.car_rental,size: 30,color:homeTabPageOptionIconColor,),

                              SizedBox(height: 5,),
                              Text(
                                "Car",
                                style: homeTabPageOptionText
                              ),

                            ],
                          ),
                        ),
                        decoration: homeTabPageOptionDecoration
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        height: 70,
                        width: MediaQuery.of(context).size.width/4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children:  [
                              Icon(Icons.bike_scooter_outlined,size: 30,color: homeTabPageOptionIconColor,),

                              SizedBox(height: 5,),
                              Text(
                                "E-Ricksaw",
                                style: homeTabPageOptionText
                              ),

                            ],
                          ),
                        ),
                        decoration: homeTabPageOptionDecoration
                      ),
                    ),
                    // ),



                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Quick Ride",style: homeTabPageOptionText,),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Container(

                width: MediaQuery.of(context).size.width,
                // height: 70,

                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x155665df),
                      spreadRadius: 5,
                      blurRadius: 17,
                      offset: Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            // height: 70,
                            // width: MediaQuery.of(context).size.width/4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:  [
                                  Icon(Icons.home,size: 20,color: homeTabPageOptionIconColor,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0,top:10),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Home",
                                            style: homeTabPageOptionText
                                        ),
                                        Text(
                                            "Select Address",
                                            style: homeTabPageOptionText
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            decoration: homeTabPageOptionDecoration
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            // height: 70,
                            // width: MediaQuery.of(context).size.width/4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:  [
                                  Icon(Icons.work,size: 20,color: homeTabPageOptionIconColor,),
                                  Padding(
                                    padding: const EdgeInsets.only(top:10.0,left: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Office",
                                            style: homeTabPageOptionText
                                        ),
                                        Text(
                                            "Set Address",
                                            style: homeTabPageOptionText
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            decoration: homeTabPageOptionDecoration
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )



          ],
        ),
      ),
    );
  }

}


