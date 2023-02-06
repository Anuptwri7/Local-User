import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/stringConst.dart';



class UpdateUserProfile extends StatefulWidget {
  String userName;
  String email;
  String image;
  String phone;
  String status;


  UpdateUserProfile({Key? key,required this.userName,required this.email,required this.image,required this.phone,required this.status}) : super(key: key);

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}
class _UpdateUserProfileState extends State<UpdateUserProfile> {

  @override
  void initState() {
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

                 color: Colors.red.shade200
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
                                          widget.image,
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
                                                color: widget.status=="Active"?Colors.green:Colors.red
                                            )
                                        )
                                    )
                                  ]
                                ),

                              ),
                              Text(
                                "${widget.userName}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${widget.email}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),

                              Container(
                                // height: MediaQuery.of(context).size.height/2,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Name"),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            height: 45,
                                            // width:
                                            // MediaQuery
                                            //     .of(context)
                                            //     .size
                                            //     .width / 4,
                                            child: TextField(
                                              // controller: discountPercentageController,
                                              keyboardType: TextInputType.number,
                                              decoration:  InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: '${widget.userName}',
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold),
                                                contentPadding: EdgeInsets.all(15),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    spreadRadius: 1,
                                                    // blurRadius: 2,
                                                    // offset: Offset(4, 4),
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Dob"),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            height: 45,
                                            // width:
                                            // MediaQuery
                                            //     .of(context)
                                            //     .size
                                            //     .width / 4,
                                            child: TextField(
                                              // controller: discountPercentageController,
                                              keyboardType: TextInputType.number,
                                              decoration:  InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: '${widget.email}',
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold),
                                                contentPadding: EdgeInsets.all(15),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    spreadRadius: 1,
                                                    // blurRadius: 2,
                                                    // offset: Offset(4, 4),
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Gender"),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            height: 45,
                                            // width:
                                            // MediaQuery
                                            //     .of(context)
                                            //     .size
                                            //     .width / 4,
                                            child: TextField(
                                              // controller: discountPercentageController,
                                              keyboardType: TextInputType.number,
                                              decoration:  InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.white)),
                                                filled: true,
                                                fillColor: Colors.white,
                                                hintText: '${widget.phone}',
                                                hintStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold),
                                                contentPadding: EdgeInsets.all(15),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    spreadRadius: 1,
                                                    // blurRadius: 2,
                                                    // offset: Offset(4, 4),
                                                  )
                                                ]),
                                          ),
                                        ],
                                      ),
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const Text("DOB"),
                                      //     const SizedBox(
                                      //       height: 8,
                                      //     ),
                                      //     Container(
                                      //       height: 45,
                                      //       // width:
                                      //       // MediaQuery
                                      //       //     .of(context)
                                      //       //     .size
                                      //       //     .width / 4,
                                      //       child: TextField(
                                      //         // controller: discountPercentageController,
                                      //         keyboardType: TextInputType.number,
                                      //         decoration: const InputDecoration(
                                      //           border: OutlineInputBorder(
                                      //               borderRadius: BorderRadius.all(
                                      //                   Radius.circular(10.0)),
                                      //               borderSide: BorderSide(
                                      //                   color: Colors.white)),
                                      //           filled: true,
                                      //           fillColor: Colors.white,
                                      //           hintText: '',
                                      //           hintStyle: TextStyle(
                                      //               fontSize: 14,
                                      //               color: Colors.grey,
                                      //               fontWeight: FontWeight.bold),
                                      //           contentPadding: EdgeInsets.all(15),
                                      //         ),
                                      //       ),
                                      //       decoration: BoxDecoration(
                                      //           color: Colors.white,
                                      //           borderRadius: BorderRadius.circular(15),
                                      //           boxShadow: const [
                                      //             BoxShadow(
                                      //               color: Colors.grey,
                                      //               spreadRadius: 1,
                                      //               // blurRadius: 2,
                                      //               // offset: Offset(4, 4),
                                      //             )
                                      //           ]),
                                      //     ),
                                      //   ],
                                      // ),



                                    ],
                                  ),
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
                margin: const EdgeInsets.all(10),
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
  // Future PayFine(BuildContext context) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   Map<String,String> headers = {
  //     'Content-Type': 'multipart/form-data',
  //     'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
  //   };
  //
  //   Map<String,String> msg = {
  //
  //     "name": _selectedPaymentMethod,
  //     "gender": widget.phone.toString(),
  //     "dob": widget.amount.toString(),
  //
  //   };
  //   var request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse(ApiConstant.baseUrl + ApiConstant.updateUserProfile),
  //   );
  //   log("kdsjhfldkj"+ApiConstant.baseUrl + ApiConstant.updateUserProfile);
  //   request.headers.addAll(headers);
  //   request.fields.addAll(msg);
  //   request.files.add(
  //     http.MultipartFile.fromBytes(
  //       "photo",
  //       File(imageFile.path).readAsBytesSync(),
  //       filename: imageFile.path,
  //     ),
  //   );
  //   request.send().then((response) {
  //     log("jlkj"+response.statusCode.toString());
  //     log("kj"+response.headers.toString());
  //     try {
  //       if (response.statusCode == 201||response.statusCode==200) {
  //         Fluttertoast.showToast(msg: "Paid Successfully");
  //         Navigator.pop(context);
  //         return const Text("data");
  //         // return const Text ("");
  //       }
  //     } catch (e) {
  //
  //       throw Exception(e);
  //     }
  //   });
  // }

}
