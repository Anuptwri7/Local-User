import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Helpers/stringConst.dart';
import '../../Pages/homePageUser.dart';
import '../../tabPage.dart';

class LoginServices{
  Future<void> login(BuildContext context,String email,String password,String token) async {


    var response = await http.post(
      Uri.parse(ApiConstant.baseUrl +  ApiConstant.loginUser),
      body: ({
        'email': email,
        'password':password
      }),
    );
    log(response.body);
    if (response.statusCode == 200||response.statusCode==201) {
      final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      sharedPreferences.setString("access_token",
          json.decode(response.body)['data']['access_token']);
      sharedPreferences.setString("name",
          json.decode(response.body)['data']['user']['name']);
      sharedPreferences.setString("email",
          json.decode(response.body)['data']['user']['email']);
      sharedPreferences.setString("phone",
          json.decode(response.body)['data']['user']['phone']??'#');
      sharedPreferences.setString("image",
          json.decode(response.body)['data']['user']['image']);
      sharedPreferences.setString("status",
          json.decode(response.body)['data']['user']['status']);
      sharedPreferences.setString("gender",
          json.decode(response.body)['data']['user']['gender']);
      sharedPreferences.setString("dob",
          json.decode(response.body)['data']['user']['dob']);

      (sharedPreferences.getString("access_token").toString());
      sendDeviceToken(token);
      log(sharedPreferences.getString("access_token").toString());
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) =>  TabPage()));
    } else {
      Fluttertoast.showToast(msg: "${json.decode(response.body)}");
    }
  }
  Future sendDeviceToken(String deviceToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String,String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${sharedPreferences.get("access_token")}'
    };

    Map<String,String> msg = {
    'device_token':deviceToken

      // "ownerPhoto":filename
    };
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(ApiConstant.baseUrl + ApiConstant.storeDeviceToken),
    );

    log("kdsjhfldkj"+msg.toString());
    request.headers.addAll(headers);
    request.fields.addAll(msg);
    // request.files.add(
    //   http.MultipartFile.fromBytes(
    //     "ownerPhoto",
    //     File(imageFile.path).readAsBytesSync(),
    //     filename: imageFile.path,
    //   ),
    // );
    request.send().then((response) {

      log("jlkj"+response.statusCode.toString());

      try {

      } catch (e) {

        throw Exception(e);
      }
    });
  }
}

  // Future<void> sendDeviceToken(String deviceToken) async {
  //   var response = await http.post(
  //     Uri.parse(ApiConstant.baseUrl +  ApiConstant.storeDeviceToken),
  //     body: {
  //       'device_token': deviceToken,
  //
  //     },
  //   );
  //   log(response.body);
  //   if (response.statusCode == 200||response.statusCode==201) {
  //
  //   } else {
  //     Fluttertoast.showToast(msg: "${json.decode(response.body)}");
  //   }
  // }
