import 'dart:ui';

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:palpitate/View/pomodoro.dart';
import 'package:palpitate/View/info_Screen.dart';

import '../Constant/themeColor.dart';
import 'activity.dart';
import '../View/home_Screen.dart';
import '../View/piano.dart';
import '../View/search_page.dart';
import '../View/instruction.dart';

void main() => runApp(MaterialApp(home: BottomBar()));

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  void dispose(){
    super.dispose();
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final screen = [HomePage(), FocusMode(type: "study"), SearchScreen(), Instruction(), InfoPage()];
  bool maximizeUI = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Colors.red,
              child: maximizeUI
                  ? DetailMusicPlayer(context)
                  : Container(child: TextButton(child: Text("Press here"),
                onPressed: (){
                    setState(() {
                      maximizeUI = !maximizeUI;
                    });
              },),),
            ),
            CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: _page,
            height: 60,
            color: Colors.black,
            backgroundColor: themeColor,
            buttonBackgroundColor: Colors.transparent,
            items: <Widget>[
              Icon(Icons.home_rounded, color: (_page == 0) ? Colors.black : themeColor),
              Icon(Icons.timer, color: (_page == 1) ? Colors.black : themeColor),
              Icon(Icons.search, color: (_page == 2) ? Colors.black : themeColor),
              Icon(Icons.help_center_outlined, color: (_page == 3) ? Colors.black : themeColor),
              Icon(Icons.info, color: (_page == 4) ? Colors.black : themeColor),
            ],
            onTap: (index) {
              setState(() {
                if(_page == 1){AudioManager.instance.release();}
                _page = index;
              });
            },

          ),]
        ),
        body: Stack(
          children: <Widget>[
            screen[_page], // your current screen
            Positioned.fill(
              child: Offstage(
                offstage: !maximizeUI,
                child: DetailMusicPlayer(context),
              ),
            ),
          ],
        ),);
  }

  Widget DetailMusicPlayer(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    double paddingBottom = mediaQueryData.padding.bottom;
    double paddingTop = MediaQuery.of(context).padding.top;

    return Dismissible(
      key: Key('value'),
      direction: DismissDirection.down,
      onDismissed: (DismissDirection direction) {
        setState(() {
          maximizeUI = false;
        });
      },
      child: Container(
        color: Colors.black,
        width: widthScreen,
        height: heightScreen,
        child: Stack(
          children: <Widget>[
            _buildWidgetBackgroundCoverAlbum(widthScreen, heightScreen),
            _buildWidgetContainerContent(widthScreen, heightScreen),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: widthScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 100.0),
                        Container(
                          width: 72.0,
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0)),
                          ),
                          child: Icon(Icons.keyboard_arrow_down,
                              color: themeColor),
                        ),
                        SizedBox(height: 24.0),
                        ClipRRect(
                          child: Image.network(
                            "https://dlmocha.com/GameImages/MellowSik.png",
                            width: widthScreen / 1.5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(48.0)),
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(
                          ///IOS is :15-18, Android is 18
                          height: heightScreen / 18,
                          width: widthScreen,
                          child: Text(
                            "Hello Here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Tourney',
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ), //Text
                        SizedBox(height: 10.0),
                        Text(
                          "Hello",
                          style: TextStyle(
                            fontFamily: 'Amatic',
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ), //Text
                        SizedBox(height: 8.0),
                        Text("Hello World",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), //Text

                      ],
                    ),
                  ),
                  //SizedBox(height: paddingBottom > 0 ? paddingBottom : 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetContainerContent(double widthScreen, double heightScreen) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: widthScreen,
        height: heightScreen / 1.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(48.0), topRight: Radius.circular(48.0)),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.black54]),
        ),
      ),
    );
  }

  Widget _buildWidgetBackgroundCoverAlbum(
      double widthScreen, double heightScreen) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("Hello Bro"),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          color: Colors.black12.withOpacity(0.2),
        ),
      ),
    );
  }
}