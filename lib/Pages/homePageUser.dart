

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local/Helpers/locationServices.dart';
import 'package:local/services/currenLocation.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Helpers/styleConst.dart';
import '../profile/updateProfilePage.dart';
import 'package:http/http.dart' as http;

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  LocationService locationService = LocationService();
  TextEditingController _searchOriginController = TextEditingController();
  TextEditingController _searchDestinationController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController googleMapController ;
  String name='';
  String email='';
  String phone='';
  String image='';
  String status='';

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId("kGooglePlex"),
    infoWindow: InfoWindow(title: "Google Plex"),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: LatLng(27.7172, 85.3240),
  );

  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [
      LatLng(27.7172, 85.3240),
      LatLng(28.7171, 85.4242),
    ],
    width: 2,
  );
  String org='';
  String des='';
  double orgLat = 0.0;
  double orgLng = 0.0;
  double destLat = 0.0;
  double destLng = 0.0;

  double current_lat =0.0;
  double current_lng= 0.0;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 14.4746,
  );

  Set<Marker> _markers =  Set<Marker>();
  Set<Polygon> _polygons =  Set<Polygon>();
  Set<Polyline> _polyline =  Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCount = 1;
  int _polylineIdCount = 1;

  String sessionToken = '1234';

  String? origin ;
  String? destination;
  String location ='Null, Press Button';
  String OrgAddress = 'Search';
  String destAddress = 'Search';

  Future<void> GetOrgAddressFromLatLong(lat,lng)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,lng );
    print(placemarks);
    Placemark place = placemarks[0];
    OrgAddress = '${place.street}, ${place.subLocality}, ${place.locality}';
    log(OrgAddress.toString());
    setState(()  {
    });
  }
  Future<void> GetDestAddressFromLatLong(lat,lng)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat,lng );
    print(placemarks);
    Placemark place = placemarks[0];
    destAddress = '${place.street}, ${place.subLocality}, ${place.locality}';
    log(destAddress.toString());
    setState(()  {
    });
  }



  @override
  void initState() {
    _orgtextcontroller.addListener(() {
      onChangeOrigin();
    });

    _desttextcontroller.addListener(() {
      onChangeDest();
    });


    // TODO: implement initState
    super.initState();

    catchUserDetails();


    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );
    FirebaseMessaging.onMessage.listen(
          (message) {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data}");
          // LocalNotificationService.display(message);

        }
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        log("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data22 ${message.data['_id']}");
        }
      },
    );

    currentLocation();

  }

  var uuid = Uuid();
  List<dynamic> originPlaceList = [];
  List<dynamic> destinationPlaceList = [];

  void onChangeOrigin(){
    if (sessionToken == null){
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    getSuggestionOrigin(_orgtextcontroller.text);
  }
  void onChangeDest(){
    if (sessionToken == null){
      setState(() {
        sessionToken = uuid.v4();
      });
    }

    getSuggestionDest(_desttextcontroller.text);
  }


  void getSuggestionOrigin(String input)async {

    String keyApi='AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E';
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseUrl?input=$input&key=$keyApi&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(request));
    log(response.body.toString());
    if(response.statusCode==200){
      setState(() {
        originPlaceList = jsonDecode(response.body.toString())['predictions'];
      });

    }else{

    }


  }
  void getSuggestionDest(String input)async {

    String keyApi='AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E';
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseUrl?input=$input&key=$keyApi&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(request));
    log(response.body.toString());
    if(response.statusCode==200){
      setState(() {
        destinationPlaceList = jsonDecode(response.body.toString())['predictions'];
      });

    }else{

    }


  }

  void _setMarker(LatLng point){
    if (this.mounted) {
      setState(() {
        _markers.add(
          Marker(markerId: MarkerId("marker"),position: point),
        );
      });
    }


  }

  void setPolygon(){
    final String polygonIdVal = 'polygon_$_polygonIdCount';
    _polygonIdCount ++ ;
    _polygons.add(Polygon(polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent
    ));

  }

  void setPolyline(List <PointLatLng>points) {
    final String polylineIdVal = 'polyline_$_polylineIdCount';
    _polylineIdCount++;
    _polyline.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((point) => LatLng(point.latitude, point.longitude)).toList()));
  }

  final TextEditingController _orgtextcontroller = TextEditingController();
  final TextEditingController _desttextcontroller = TextEditingController();

  @override
  void dispose() {
    _orgtextcontroller.dispose();
    _desttextcontroller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: SafeArea(

        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title:Text("Book Your Ride",style: appBarTextStyle,),

            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,

          ),
          drawer: Drawer(

            child: ListView(

              padding: EdgeInsets.zero,
              children: [
                 DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: const Color(0xFF778899),
                        backgroundImage: NetworkImage(
                          '$image',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Text('$name'.toUpperCase(),style: drawerTextStyle,),
                      ),

                    ],
                  ),
                ),
                ListTile(
                  title:  Row(
                    children: [
                      Icon(Icons.person),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text('Profile',style: drawerTextStyle,),
                      ),
                    ],
                  ),
                  onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfile(userName: name,
                      // email: email,
                      // phone: phone,
                      // image: image,
                      // status:status)));

                  },
                ),
                Divider(
                  color: Colors.red,
                  endIndent: 20,
                  indent: 20,
                ),
                ListTile(
                  title:  Row(
                    children: [
                      Icon(Icons.settings),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text('Setting',style: drawerTextStyle,),
                      ),
                    ],
                  ),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
                Divider(
                    color: Colors.red,
                    endIndent: 20,
                    indent: 20
                ),
                ListTile(
                  title:  Row(
                    children: [
                      Icon(Icons.question_answer),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text('FAQ',style: drawerTextStyle,),
                      ),
                    ],
                  ),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
                Divider(
                    color: Colors.red,
                    endIndent: 20,
                    indent: 20
                ),
                ListTile(
                  title:  Row(
                    children: [
                      Icon(Icons.headphones),
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: Text('Support',style: drawerTextStyle,),
                      ),
                    ],
                  ),
                  onTap: () {

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Column(

            children: [
              Container(
                height: MediaQuery.of(context).size.height/2,

                child: GoogleMap(
                  markers: _markers,
                  polygons: _polygons,
                  polylines: _polyline,
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,

                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    googleMapController = controller;

                  },
                  onTap: (point){
                    polygonLatLngs.add(point);
                    setPolygon();
                  },

                ),


              ),

              TextField(
                controller: _orgtextcontroller,
                onTap: () async {

                },

                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                  ),
                  hintText: OrgAddress,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
              TextField(
                controller: _desttextcontroller,
                onTap: () async {

                },

                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                  ),
                  hintText: destAddress,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                ),
              ),
              Expanded(child: ListView.builder(
                itemCount: originPlaceList.length,
                  itemBuilder: (context,index){
                  return ListTile(
                    onTap: ()async{
                      List<Location> locations = await locationFromAddress(originPlaceList[index]['description']);

                      googleMapController.animateCamera(
                                    CameraUpdate.newLatLng(
                                       LatLng( locations.last.latitude,locations.last.longitude)
                                    )
                                );
                      origin= originPlaceList[index]['description'];
                      _setMarker(LatLng( locations.last.latitude,locations.last.longitude));
                      orgLat =  locations.last.latitude;
                      orgLng =  locations.last.longitude;
                        GetOrgAddressFromLatLong(locations.last.latitude,locations.last.longitude);
                      org=originPlaceList[index]['description'];


                      log(locations.last.latitude.toString()+locations.last.longitude.toString());
                      _orgtextcontroller.clear();

                      log("origin lat:"+locations.last.latitude.toString());
                      log("origin lat:"+locations.last.longitude.toString());



                    },
                    title: Text(originPlaceList[index]['description']),

                  );
                  }
              )),

              Expanded(child: ListView.builder(
                  itemCount: destinationPlaceList.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      onTap: ()async{
                        List<Location> locations = await locationFromAddress(destinationPlaceList[index]['description']);

                        googleMapController.animateCamera(
                            CameraUpdate.newLatLng(
                                LatLng( locations.last.latitude,locations.last.longitude)
                            )
                        );
                        destination= destinationPlaceList[index]['description'];
                        _setMarker(LatLng( locations.last.latitude,locations.last.longitude));
                        destLat =  locations.last.latitude;
                        destLng =  locations.last.longitude;
                        GetDestAddressFromLatLong(locations.last.latitude,locations.last.longitude);


                        log(locations.last.latitude.toString()+locations.last.longitude.toString());
                        _desttextcontroller.clear();
                        des=destinationPlaceList[index]['description'];

                        log("dest lat:"+locations.last.latitude.toString());
                        log("dest lng:"+locations.last.longitude.toString());



                      },
                      title: Text(destinationPlaceList[index]['description']),

                    );
                  }
              )),

              // Padding(
              //   padding: const EdgeInsets.only(top:10.0),
              //   child: SearchMapPlaceWidget(
              //     bgColor: Colors.blue.shade50,
              //     hasClearButton: true,
              //     textColor: Colors.black,
              //     placeType: PlaceType.address,
              //     placeholder: "Enter the origin",
              //     apiKey: "AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E",
              //     onSelected: (Place place)async{
              //
              //       Geolocation? geolocation =await place.geolocation;
              //       if(!mounted) return;
              //         setState(() {
              //           org = place.description.toString();
              //         });
              //
              //
              //       log("org---------------------"+org);
              //       log("org latitude::::::"+geolocation!.coordinates.latitude.toString());
              //       log("org longitude::::::"+geolocation!.coordinates.longitude.toString());
              //       locationService.getPlaceOrg(place.placeId.toString());
              //
              //       googleMapController.animateCamera(
              //           CameraUpdate.newLatLng(
              //               geolocation!.coordinates
              //           )
              //       );
              //       googleMapController.animateCamera(
              //         CameraUpdate.newLatLngBounds(geolocation.bounds, 0),
              //
              //       );
              //       // _setMarker(LatLng(, lng));
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top:10.0),
              //   child: SearchMapPlaceWidget(
              //     bgColor: Colors.blue.shade50,
              //     textColor: Colors.black,
              //     hasClearButton: true,
              //     placeType: PlaceType.address,
              //     placeholder: "Enter the destination",
              //     apiKey: "AIzaSyDjTJsc1uhHKEeaRl7I_xvuT4sDR9vDf6E",
              //     onSelected: (Place place)async{
              //       Geolocation? geolocation =await place.geolocation;
              //      if(!mounted) return;
              //        setState(() {
              //          des = place.description.toString();
              //        });
              //
              //       log("dest latitude::::::"+geolocation!.coordinates.latitude.toString());
              //       log("dest longitude::::::"+geolocation!.coordinates.longitude.toString());
              //       locationService.getPlaceDest(place.placeId.toString());
              //       googleMapController.animateCamera(
              //           CameraUpdate.newLatLng(
              //               geolocation!.coordinates
              //           )
              //       );
              //       googleMapController.animateCamera(
              //           CameraUpdate.newLatLngBounds(geolocation.bounds, 0)
              //       );
              //     },
              //   ),
              // ),

              SizedBox(height: 5,),
              org==''&&des==''?ElevatedButton(
                onPressed: () {

                  Fluttertoast.showToast(msg: "Please select your origin and desination");

                },
                child: Text("Find a Driver"),
                style: ElevatedButton.styleFrom(
                    primary: org==''&&des==''?Colors.grey:Colors.red,
                    textStyle: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ))),
              ):
              ElevatedButton(
                onPressed: () async{
                  _markers.clear();
                  _polyline.clear();


                  var directions= await locationService.getDirection(org, des);

                  _goToTheOriginPlace(
                    directions['end_location']['lat'],
                    directions['end_location']['lng'],
                    directions['bounds_ne'],
                    directions['bounds_sw'],
                  );
                  setPolyline(directions['polyline_decoded']);
                },
                child: Text("Find a Driver"),
                style: ElevatedButton.styleFrom(
                    primary: org==''&&des==''?Colors.grey:Colors.red,
                    textStyle: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          15,
                        ))),
              ),
            ],
          )

        ),
      ),
    );
  }


  Future<void> _goToTheOriginPlace(
      // Map<String,dynamic> place
      double lat,
      double lng,
      Map<String,dynamic> boundsNe,
      Map<String,dynamic> boundsSw,
      ) async {
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat,lng),zoom: 16),
    ));

    controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(boundsSw['lat'],boundsSw['lng']),
          northeast: LatLng(boundsNe['lat'],boundsNe['lng']),
        ),
        25
    ));

    _setMarker(LatLng(lat, lng));
  }

  Future<Position> _determinePosition()async{
    bool serviceEnabled ;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled)
    {
      return Future.error("error");
    }
    permission = await Geolocator.checkPermission();

    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission==LocationPermission.denied){
        return Future.error("Permission denied!");
      }
    }
    if(permission==LocationPermission.deniedForever){
      return Future.error("Location Permission denied forever!");
    }

    Position position = await Geolocator.getCurrentPosition();

// lat and lng

    current_lat = position.latitude;
    current_lng = position.longitude;
    // _setMarker(LatLng(Geolocator.));
    return position;




  }

  Future currentLocation()async{
    Position position = await _determinePosition();
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude,position.longitude),
        zoom: 16
    )));
    _markers.clear();

    _markers.add(Marker(markerId: MarkerId('currentLocation'),position: LatLng(
        position.latitude,position.longitude
    )));
    saveCurrentLocation(current_lat, current_lng);
    if (this.mounted) {
      setState(() {

      });
    }

  }


  Future<bool> exitAppConfirm(BuildContext context) async{
    bool exitApp = await showDialog(
      barrierColor: Colors.black38,

      context: context,

      builder: (context) => Dialog(
        backgroundColor: Colors.indigo.shade50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(child: Text("Are you sure want to Exit?",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),)),
                    Container(
                      child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop(false);
                          },
                          style: ElevatedButton.styleFrom(
                            // primary: Colors.red,
                              minimumSize: const Size.fromHeight(30),

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              )
                            // maximumSize: const Size.fromHeight(56),
                          ),
                          child:  Text(
                            "No",
                            style: TextStyle(
                              color: Colors.white,
                              // fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                          // handleTick();
                          // data['content'][index]['isFinished'].toString()=="false"? Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanProgressPageInventoryPatch(id: data['content'][index]['id'],))):Fluttertoast.showToast(msg: "Task Completed");
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xff018324),
                            minimumSize: const Size.fromHeight(30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                          // maximumSize: const Size.fromHeight(56),
                        ),
                        child:  Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),

                  ],
                ),
              ),
            ),
            Positioned(
                top:-35,

                child: CircleAvatar(
                  child: Icon(Icons.book_outlined,size: 40,),
                  radius: 40,
                )),
          ],
        ),
      ),

    );
    return exitApp?? false;
  }
  Future<void> catchUserDetails() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString("name").toString() ;
    email = pref.getString("email").toString() ;
    phone = pref.getString("phone").toString() ;
    status = pref.getString("status").toString() ;
    image = pref.getString("image").toString() ;

  }

}

