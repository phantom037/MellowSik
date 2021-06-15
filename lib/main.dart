import 'package:flutter/material.dart';
import 'package:palpitate/HomePage/songScroll.dart';
import 'package:palpitate/PlaylistUI/randomSong.dart';
import 'package:palpitate/HomePage/home_Screen.dart';
import 'package:palpitate/PlaylistUI/playlist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        SongScroll.id: (context) => SongScroll(),
        MusicApp.id: (context) => MusicApp(),
        Playlist.id: (context) => Playlist(),
      },
    );
  }
}
