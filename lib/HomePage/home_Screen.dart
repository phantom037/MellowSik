import 'package:flutter/material.dart';
import 'songScroll.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  static String id = "Home_Screen";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text(
              "Palpitate",
              style: TextStyle(
                color: Color(0xff55efc4),
                fontSize: 25.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          backgroundColor: Colors.black,
          body: ListView(
            children: [SongScroll()],
          )),
    );
  }
}
