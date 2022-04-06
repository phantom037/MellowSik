import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:palpitate/HomePage/home_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palpitate/Support/splash_Screen.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  //await SharedPreferences.getInstance();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MellowSik());
}

class MellowSik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = true;
  @override
  void initState() {
    super.initState();
    //Check Internet Connection
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    checkVersion();
  }

  void checkVersion() async {
    var url = Uri.parse('https://dlmocha.com/app/appUpdate.json');
    http.Response response = await http.get(url);
    var update = jsonDecode(response.body)['MellowSik']['version'];
    var version = "2.0.2";
    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersion(
      iOSId: 'com.leotran9x.palpitate',
      androidId: 'com.leotran9x.palpitate',
    );
    final status = await newVersion.getVersionStatus();
    if (update != version) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dismissButtonText: "Skip",
        dialogTitle: 'New Version Available',
        dialogText:
            'The new app version $update is available now. Please update to have a better experience.'
            '\nIf you already updated please skip.',
      );
    }
    /*
    print("ME : " + status.localVersion);
    print("STORE : " + status.storeVersion);
     */
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: hasInternet
          ? SplashScreen()
          : Scaffold(
              backgroundColor: Colors.black54,
              body: Center(
                child: Text(
                  "No Internet Connection 😭",
                  style: TextStyle(
                    fontFamily: 'Amatic',
                    fontSize: 30.0,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ),
    );
  }
}
