import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local/Auth/services/loginServices.dart';
import 'package:local/Auth/services/registerServices.dart';

import '../../Helpers/styleConst.dart';
import '../../Pages/homePageUser.dart';


class UserRegisterPage extends StatefulWidget {

  UserRegisterPage({Key? key}) : super(key: key);

  @override
  _UserRegisterPageState createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();
  TextEditingController confirmpasswordtextEditingController = TextEditingController();
  TextEditingController phonetextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  bool isFinished = false;
  bool isChecked = false;
  bool _passwordVisible = false;
RegisterServices registerServices = RegisterServices();
  void validateForm() async {
    if (kDebugMode) {
    }
    if (nametextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Email Address Invalid");

    } else if (passwordtextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is Required.");
    } else {
      // login();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.white;
    }

    return Scaffold(
      backgroundColor: Color(0xfff9fdff),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: MediaQuery.of(context).size.height,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top:30,left: 70),
                  child: Image.asset("asset/image/logo.png",height: 200,),
                ),

                //
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 0),
                    child: const Text(
                      "Register Yourself as User",
                      style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40,right: 40),
                  decoration: textBoxDecoration,
                  child: TextField(
                    controller: nametextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: hintStyle,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40,right: 40),
                  decoration: textBoxDecoration,
                  child: TextField(
                    controller: emailtextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: hintStyle,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40,right: 40),
                  decoration:   textBoxDecoration,
                  child: TextField(
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: passwordtextEditingController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),

                        hintText: 'Enter your Password',
                        hintStyle: hintStyle,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40,right: 40),
                  decoration:   textBoxDecoration,
                  child: TextField(
                    obscureText: !_passwordVisible,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: confirmpasswordtextEditingController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),

                        hintText: 'Confirm your password',
                        hintStyle: hintStyle,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 40,right: 40),
                  decoration: textBoxDecoration,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: phonetextEditingController,
                    decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        hintStyle: hintStyle,
                        contentPadding: const EdgeInsets.all(15),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                const SizedBox(
                  height: 35.0,
                ),

                Container(
                  padding: const EdgeInsets.only(left: 120, right: 120),
                  child: ElevatedButton(
                      onPressed: () async {
                        registerServices.RegisterUser(context, nametextEditingController.text,
                            emailtextEditingController.text,
                            passwordtextEditingController.text,
                            phonetextEditingController.text);

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade400,
                        minimumSize: const Size.fromHeight(30),
                        // maximumSize: const Size.fromHeight(56),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )),
                ),





              ],
            ),
          ),
        ),
      ),
    );
  }
//   Future<void> login() async {
//     List<String> getCodeName =[];
//     List<String> getSuperUser = [];
//     log(nametextEditingController.text.toString());
//     log(passwordtextEditingController.text.toString());
//     var response = await http.post(
//       Uri.parse(ApiConstant.baseUrl + ApiConstant.login),
//       body: (json.encode({
//         'username': nametextEditingController.text,
//         'password': passwordtextEditingController.text,
//       })),
//     );
// log(response.body);
//     if (response.statusCode == 200) {
//       final SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();
//       sharedPreferences.setString("access_token",
//           json.decode(response.body)['tokens']['access_token'] ?? '#');
//       sharedPreferences.setString("refresh_token",
//           json.decode(response.body)['tokens']['refresh_token'] ?? '#');
//
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => const TabPage()));
//     } else {
//       Fluttertoast.showToast(msg: "${json.decode(response.body)}");
//     }
//   }
}

