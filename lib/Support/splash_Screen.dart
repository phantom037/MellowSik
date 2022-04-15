import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palpitate/HomePage/home_Screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
        } else {
          // Loading is done, return the app:
          return HomePage();
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Scaffold(
      backgroundColor: lightMode
          ? const Color(0xff55efc4).withOpacity(1.0)
          : const Color(0x00042a49).withOpacity(1.0),
      body: Center(
          child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: lightMode
                  ? Image.asset('images/lottie.PNG')
                  : Image.asset('images/lottie.PNG'))),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
