import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:palpitate/View/pomodoro.dart';
import 'package:palpitate/View/info_Screen.dart';

import '../Constant/themeColor.dart';
import '../Test/activity.dart';
import '../View/home_Screen.dart';
import '../View/piano.dart';
import '../View/search_page.dart';
import '../View/instruction.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  void dispose(){
    super.dispose();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screen = [HomePage(), Pomodoro(), SearchScreen(), Instruction()
    //, InfoPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: _page,
          height: 70,
          color: Colors.black,
          backgroundColor: themeColor,
          buttonBackgroundColor: Colors.transparent,
          items: <Widget>[
            Icon(Icons.home_rounded, color: (_page == 0) ? Colors.black : themeColor),
            Icon(Icons.timer, color: (_page == 1) ? Colors.black : themeColor),
            Icon(Icons.search, color: (_page == 2) ? Colors.black : themeColor),
            Icon(Icons.help_center_outlined, color: (_page == 3) ? Colors.black : themeColor),
            //Icon(Icons.info, color: (_page == 4) ? Colors.black : themeColor),
          ],
          onTap: (index) {
            setState(() {
              if(_page == 1){AudioManager.instance.release();}
              _page = index;
            });
          },
        ),
        body: screen[_page]);
  }
}