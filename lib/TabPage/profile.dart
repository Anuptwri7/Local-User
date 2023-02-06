import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:local/profile/updateProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfilePage extends StatefulWidget {



  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  String userName='';

  String email='';
  String image='';
  String phone='';
  String status='';
  String dob='';
  String gender='';

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding:  EdgeInsets.only(left: 0, right: 0),
        color: Colors.white,
        constraints:  BoxConstraints.expand(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Stack(
                alignment: Alignment.topCenter,
                children: [

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2.75,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),

                        color: Colors.yellow
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child: Stack(
                                    children:[
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(65),
                                          child: Image.network(
                                            image==''?'https://media.istockphoto.com/id/1226886130/photo/3d-illustration-of-smiling-happy-man-with-laptop-sitting-in-armchair-cartoon-businessman.jpg?s=1024x1024&w=is&k=20&c=Kt68hwB6KIIw3kgvs0MQOrFvuFbHmpnJ82DlxRFRGiM=':image,
                                            fit: BoxFit.fill,
                                          )

                                      ),
                                      Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                              padding: EdgeInsets.all(7.5),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.white
                                                  ),
                                                  borderRadius: BorderRadius.circular(90.0),
                                                  color: status=="Active"?Colors.green:Colors.red
                                              )
                                          )
                                      )
                                    ]
                                ),

                              ),
                              Text(
                                "${userName}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${email}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),

                              Container(
                                height: MediaQuery.of(context).size.height/2,
                                margin: const EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
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
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceAround,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Name ",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${userName} ",
                                                style: const TextStyle(
                                                    color: Colors.black,fontSize: 16),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Phone Number ",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${phone} ",
                                                style: const TextStyle(
                                                    color: Colors.black,fontSize: 16),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.email,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Email ",
                                                style: const TextStyle(
                                                    color: Colors.black,fontSize: 16),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${email} ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.signal_wifi_statusbar_null_rounded,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Status ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${status} ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "DOB ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${dob} ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left:20,top: 15),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.transgender_sharp,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Gender ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              SizedBox(width: 100,),
                                              Text(
                                                "${gender} ",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),

                                            ],
                                          ),
                                        ),


                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                  color: Colors.black12,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateUserProfile(userName: userName, email: email, image: image, phone: phone, status: status)));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,

                        padding: EdgeInsets.only(top: 0, ),
                        child: Center(
                          child: Text(
                            "Update",
                            style: const TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }


  Future getDetails()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("name").toString();
    email = sharedPreferences.getString("email").toString();
    phone = sharedPreferences.getString("phone").toString();
    image = sharedPreferences.getString("image").toString();
    status = sharedPreferences.getString("status").toString();
    gender = sharedPreferences.getString("gender").toString();
    dob = sharedPreferences.getString("dob").toString();


  }

}
