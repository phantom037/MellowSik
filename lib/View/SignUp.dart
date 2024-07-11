import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:palpitate/View/home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constant/themeColor.dart';
import '../Widget/alert.dart';
import 'login.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  //const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  ///Initialize default FirebaseAuth.instance and SharedPreferences objects
  SharedPreferences preferences;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  ///Create an user object that store data of the firebase authenticate user
  User currentUser;
  bool showSpin = false, isVerified = false; //set default value for the login status and loading circular progress status
  String email = "", password = "", errorMessage = "", name = ""; //empty strings control the entered email, password and display the error (if has)
  Timer timer;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();

  /**
   * This function keep continously checking the email verification status of user
   * */
  void verifyEmail(User user) {
    if (!(user.emailVerified)) {
      user.sendEmailVerification();
      //Fluttertoast.showToast(msg: "Check your email to verify account");
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified(user));
      setState(() {
        errorMessage = "Check email to verify!";
      });
    }
  }

  /**
   * This function check if user has verified email or not
   */
  Future checkEmailVerified(User user) async {
    //FirebaseAuth.instance.currentUser?.reload();

    //print("Run checkEmailVerified");
    //print("verify: ${FirebaseAuth.instance.currentUser?.emailVerified}");
    setState(() {
      user.reload();
      isVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false; //user!.emailVerified;
    });

    if (isVerified) {
      timer?.cancel();
      checkLoginInStatus(user);
    }
  }

  /**
   * This function decide whether registration is valid
   * and assign default information to user
   * @return: navigate to the HomePage
   */
  Future checkLoginInStatus(User user) async {
    preferences = await SharedPreferences.getInstance();


    ///Non Use Check if user has verify account
    if (user != null && !user.emailVerified) {
      //await user.sendEmailVerification();
      Fluttertoast.showToast(msg: "Check your email to verify account");
    }
    ///Check if Register Success
    if (user != null) {
      final QuerySnapshot resultQuery = await FirebaseFirestore.instance
          .collection("user")
          .where("id", isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documentSnapshots = resultQuery.docs;

      ///New User write data to Firebase
      if (documentSnapshots.length == 0) {
        String convert =
        user.displayName.toString().toLowerCase().replaceAll(' ', '');
        var arraySearchID = List.filled(convert.length, "");
        if (user.displayName != null) {
          for (int i = 0; i < convert.length; i++) {
            arraySearchID[i] =
                convert.substring(0, i + 1).toString().toLowerCase();
          }
        } else {
          String newUnknownUserName = "user" + user.uid.substring(0, 9);
          arraySearchID = new List.filled(newUnknownUserName.length, "");
          for (int i = 0; i < newUnknownUserName.length; i++) {
            arraySearchID[i] =
                newUnknownUserName.substring(0, i + 1).toString().toLowerCase();
          }
        }
        FirebaseFirestore.instance.collection("user").doc(user.uid).set({
          "name": name != null
              ? name
              : "User " + user.uid.substring(0, 9),
          "photoUrl": user.photoURL != null
              ? user.photoURL
              : "https://dlmocha.com/app/Ume-Talk/userDefaultAvatar.jpeg",
          "id": user.uid,
          "createdAt": DateTime.now().toString(),
          "streamMap": null,
        });
        //Write data to Local
        currentUser = user;

        await preferences.setString("id", currentUser.uid);
        await preferences.setString("name", name != null ? name : ("User " + user.uid.substring(0, 9)));
        await preferences.setString(
            "photoUrl",
            currentUser.photoURL.toString() != null
                ? currentUser.photoURL.toString()
                : "https://dlmocha.com/app/Ume-Talk/userDefaultAvatar.jpeg");
        await preferences.setString("about", "None");

        Fluttertoast.showToast(msg: "Register Success");
        await Future.delayed(const Duration(seconds: 3));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MainScreen();
        }));
      }
      setState(() {
        showSpin = false;
      });
      preferences.setString("id", user.uid);
    } else {
      ///SignIn fail
      Fluttertoast.showToast(msg: "Fail to Register. Please try again.");
      setState(() {
        showSpin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                color: backgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 150.0,
                    ),
                    const Flexible(child:
                    Text("MellowSik",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),)),
                    const SizedBox(
                      height: 200.0,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        name = value;
                      },
                      focusNode: nameFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Full Name",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:  EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border:  OutlineInputBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(19.0)),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black45, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(19.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(19.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      focusNode: emailFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:  EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border:  OutlineInputBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(19.0)),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black45, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(19.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(19.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      textAlign: TextAlign.start,
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      focusNode: passwordFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(32.0)),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black45, width: 1.0),
                          borderRadius:  BorderRadius.all(Radius.circular(19.0)),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 2.0),
                          borderRadius:  BorderRadius.all(Radius.circular(19.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Center(child: showAlert(errorMessage)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Material(
                          borderRadius: const BorderRadius.all(Radius.circular(19.0)),
                          elevation: 5.0,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(19.0),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(19.0),
                              onTap: () async {
                                setState(() {
                                  showSpin = true;
                                });
                                try {
                                  User newUser = (await firebaseAuth.createUserWithEmailAndPassword(
                                      email: email, password: password)).user;
                                  if (newUser != null) {
                                    verifyEmail(newUser);
                                  }
                                  setState(() {
                                    showSpin = false;
                                  });
                                } on FirebaseAuthException catch (error) {
                                  switch (error.code) {
                                    case "invalid-email":
                                      errorMessage = "Email is badly formatted.";
                                      break;
                                    case "weak-password":
                                      errorMessage = "Password requires at least 6 letters.";
                                      break;
                                    case "email-already-in-use":
                                      errorMessage = "This email has already been used.";
                                      break;
                                    case "too-many-requests":
                                      errorMessage = "Too many requests. Try again later.";
                                      break;
                                    default:
                                      errorMessage = "An undefined Error happened.";
                                  }
                                  setState(() {
                                    Fluttertoast.showToast(msg: "Fail to register. Please try again.");
                                    showSpin = false;
                                  });
                                }
                              },
                              child: Container(
                                width: 150.0,
                                height: 50.0,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[ Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                              child: const Text(
                                "By continue you agree with",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () {}),
                        ), GestureDetector(child:
                        const Text(" policy", style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w900,

                        ),),
                            onTap: (){launchUrl(Uri.parse("https://dlmocha.com/privacy"));})
                        ]),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 60,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Have an account? ", style: TextStyle(fontSize: 15, color: Colors.white),),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                            child: const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context, MaterialPageRoute(builder: (context){
                                return LoginScreen();
                              }));
                            }),
                      ),
                    ],),
                )),
          ]),
    );
  }
}
