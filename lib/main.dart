import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:new_version/new_version.dart';
import 'package:palpitate/Constant/themeColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palpitate/View//splash_Screen.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

///@variable hasInternet (bool) : the internet connection status
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

  /***
   * This functions is used to check if device using the newest app version
   * if not it will show dialog box asking for update
   */
  void checkVersion() async {
    var url = Uri.parse('https://dlmocha.com/app/appUpdate.json');
    http.Response response = await http.get(url);
    var update = jsonDecode(response.body)['MellowSik']['version'];
    var version = "3.3.1";
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
    // String input = "Hello, World!";
    // String hash = sha256ofString(input);
    // print("Hash: $hash");
  }

  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }


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
                    color: themeColor,
                  ),
                ),
              ),
            ),
    );
  }
}
