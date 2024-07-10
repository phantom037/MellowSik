import 'package:flutter/material.dart';
import 'package:palpitate/View/SettingPage.dart';
import 'package:palpitate/View/pomodoro.dart';
import 'package:palpitate/View/search_page.dart';

import '../Constant/themeColor.dart';
import 'home_Screen.dart';
import 'instruction.dart';
class MainScreen extends StatefulWidget {

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// @variable pageIndex (int): represent the index of the current screen  controlled by the bottom navbar
/// @variable screen (List): contains all the screens controlled by the bottom navbar
class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  List screen = [HomePage(), SearchScreen(), Instruction(), Pomodoro(), SettingPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting, // Shifting
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: pageIndex,
        // update the current screen index then navigate to a new screen
        onTap: (int newIndex){
          setState(() {
            pageIndex = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.help_center_outlined), label: "Help", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.timer_rounded), label: "Pomodoro", backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting", backgroundColor: Colors.black),
        ],
      ),
    );
  }
}
