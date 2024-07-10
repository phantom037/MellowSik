import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:palpitate/View/home_Screen.dart';
import 'package:palpitate/View/main_screen.dart';

import 'login.dart';


class KeepLogin extends StatefulWidget {
  @override
  _KeepLoginState createState() => _KeepLoginState();
}

class _KeepLoginState extends State<KeepLogin> {
  User user;

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    // if (userCred == null) {return;}
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return user == null ? LoginScreen() : MainScreen();
  }
}
