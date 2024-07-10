import 'dart:math';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palpitate/View/piano.dart';
import 'package:palpitate/View/search_page.dart';
import 'package:palpitate/Widget/MyRoute.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constant/themeColor.dart';
import 'pomodoro.dart';
import '../Widget/songScroll.dart';
import 'package:palpitate/View/instruction.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  List widgets = [HomePage(), SearchScreen(), Instruction(), Pomodoro()];
  int dateIndex = 0, recommendImgIndex = 1, timeIndex = 0;
  Random rand = new Random();
  String weekDate = "sunday",
      recommend = "relax",
      recommendPlayListName = "Loading";
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    backgroundGenerate();
  }

  void backgroundGenerate() {
    dateIndex = rand.nextInt(3) + 1;
    recommendImgIndex = rand.nextInt(5) + 1;
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

    if (time.hour >= 5 && time.hour < 21) {
      if (time.minute % 2 == 0) {
        recommend = "popSong";
        recommendPlayListName = "Pop Songs";
      } else {
        recommend = "relax";
        recommendPlayListName = "Relax Music";
      }
    } else {
      recommend = "sleep";
      recommendPlayListName = "Sleeping Meditation";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
            //extendBody: true,
            backgroundColor: Color(0xff1f222b),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      "MellowSik",
                      style: const TextStyle(
                        color: themeColor,
                        fontFamily: 'Amatic',
                        fontSize: 25.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    pinned: false,
                    floating: false,
                    leading: Container(),
                  ),
                ];
              },
              body: Container(
                child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ListView(
                        children: [
                          Container(
                            child: MaterialButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  Navigator.push(context,
                                      MyRoute(builder: (context) {
                                    return Piano(type: 'event');
                                  }));
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(
                                      "https://dlmocha.com/app/MellowSik_Images/Event/e$dateIndex.gif"),
                                  /*
                                  NetworkImage(recommend == "sleep"
                                      ? "https://dlmocha.com/app/MellowSik_Images/${recommend}/sleep$recommendImgIndex.gif"
                                      : "https://dlmocha.com/app/MellowSik_Images/album/random/${(recommendImgIndex % 4).toInt()}.jpg"),
                                  */
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Today Playlist',
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 160,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  mainAlbum(weekDate, dateIndex, "popSong"),
                                  mainAlbum("daytime", timeIndex, "relax"),
                                  mainAlbum("random", dateIndex, "popSong"),
                                  mainAlbum("sleep", dateIndex, "sleep"),
                                ],
                              ),
                            ),
                          ),
                          SongScroll()
                        ],
                      ),
                    ),
                  ),

                  // Container(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: <Widget>[
                  //       IconButton(
                  //           icon: const Icon(
                  //             Icons.home_rounded,
                  //             color: themeColor,
                  //           ),
                  //           onPressed: () {
                  //             setState(() {});
                  //           }),
                  //       IconButton(
                  //           icon: const Icon(
                  //             Icons.info_outline,
                  //             color: themeColor,
                  //           ),
                  //           onPressed: () {
                  //             launch("https://dlmocha.com/app/mellowsik");
                  //           }),
                  //       IconButton(
                  //           icon: const Icon(Icons.search, color: themeColor),
                  //           onPressed: () {
                  //             Navigator.push(context, MyRoute(builder: (context) {
                  //               return SearchScreen();
                  //             }));
                  //           }),
                  //       IconButton(
                  //           icon: const Icon(Icons.help_center_outlined,
                  //               color: themeColor),
                  //           onPressed: () {
                  //             Navigator.push(context, MyRoute(builder: (context) {
                  //               return Instruction();
                  //             }));
                  //           }),
                  //       IconButton(
                  //           icon: const Icon(Icons.timer_rounded, color: themeColor),
                  //           onPressed: () {
                  //             Navigator.push(context, MyRoute(builder: (context) {
                  //               return Pomodoro();
                  //             }));
                  //           }),
                  //     ],
                  //   ),
                  // ),
                  //
                  // const SizedBox(
                  //   height: 10.0,
                  // ),
                ]),
              ),
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
            TextButton(
              style: ButtonStyle(
                //overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
              ),
              onPressed: () {
                Navigator.push(context, MyRoute(builder: (context) {
                  return Piano(
                    type: playlist,
                  );
                }));
              },
              //padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: NetworkImage(
                      "https://dlmocha.com/app/MellowSik_Images/album/${type}/$index.jpg"), //eventImg[rand.nextInt(6)]
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ]),
    );
  }
}
