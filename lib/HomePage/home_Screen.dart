import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palpitate/HomePage/piano.dart';
import 'package:palpitate/HomePage/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'songScroll.dart';
import 'package:palpitate/Support/instruction.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int dateIndex = 0, r = 0, timeIndex = 0;
  Random rand = new Random();
  String weekDate = "sunday";
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    backgroundGenerate();
  }

  void backgroundGenerate() {
    dateIndex = rand.nextInt(3) + 1;
    r = rand.nextInt(3) + 1;
    var time = DateTime.now();

    if (time.hour >= 5 && time.hour < 11) {
      timeIndex = 1;
    } else if (time.hour >= 11 && time.hour <= 17) {
      timeIndex = 2;
    } else {
      timeIndex = 3;
    }

    if (time.weekday == 1) {
      weekDate = "monday";
    } else if (time.weekday == 2) {
      weekDate = "tuesday";
    } else if (time.weekday == 3) {
      weekDate = "wednesday";
    } else if (time.weekday == 4) {
      weekDate = "thursday";
    } else if (time.weekday == 5) {
      weekDate = "friday";
    } else if (time.weekday == 6) {
      weekDate = "saturday";
    } else {
      weekDate = "sunday";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "MellowSik",
            style: TextStyle(
              color: Color(0xff55efc4),
              fontFamily: 'Amatic',
              fontSize: 25.0,
              fontWeight: FontWeight.w900,
            ),
          ),
          leading: Container(),
        ),
        backgroundColor: Colors.black,
        body: Container(
          child: Stack(children: <Widget>[
            Column(children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: new DecorationImage(
                          image: NetworkImage(
                              "https://dlmocha.com/app/MellowSik_Images/background.jpeg"),
                          fit: BoxFit.fill)),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 160,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              mainAlbum(weekDate, dateIndex, "popSong"),
                              SizedBox(width: 10),
                              mainAlbum("daytime", timeIndex, "relax"),
                              SizedBox(width: 10),
                              mainAlbum("random", r, "popSong"),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                      SongScroll()
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.home_rounded,
                          color: Color(0xff00cec9),
                        ),
                        onPressed: () {
                          setState(() {});
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Color(0xff00cec9),
                        ),
                        onPressed: () {
                          launch("https://dlmocha.com/app/mellowsik");
                        }),
                    IconButton(
                        icon: Icon(Icons.help_center_outlined,
                            color: Color(0xff00cec9)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Instruction();
                          }));
                        }),
                    IconButton(
                        icon: Icon(Icons.search, color: Color(0xff00cec9)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SearchScreen();
                          }));
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget mainAlbum(String type, int index, String playlist) {
    return Container(
      width: 250,
      color: Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Piano(
                    type: playlist,
                  );
                }));
              },
              padding: EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage(
                      "https://acrosshorizon.github.io/palpitate/album/${type}/$index.jpg"), //eventImg[rand.nextInt(6)]
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}
