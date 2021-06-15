import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'randomSong.dart';

void main() {
  runApp(Playlist());
}

class Playlist extends StatelessWidget {
  static String id = "Playlist_Screen";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: MusicApp()),
    );
  }
}
