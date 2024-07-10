import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpitate/View/home_Screen.dart';
import 'package:palpitate/View/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/View/instruction.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../Constant/themeColor.dart';
import '../Widget/MyRoute.dart';

class FocusMode extends StatefulWidget {
  final String type;
  FocusMode({Key key, @required this.type}) : super(key: key);
  @override
  _FocusModeState createState() => _FocusModeState();
}

class _FocusModeState extends State<FocusMode> {
  SharedPreferences preferences;
  bool isPlaying = false;
  Duration _duration;
  Duration _position;
  double _slider;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;
  bool maximizeUI = false;
  List<AudioInfo> _list = [];
  bool hasInternet = true;

  final list = [
    {
      'title': "Intro",
      'singer': "Welcome to MellowSik",
      'url':
      "https://assets.mixkit.co/sfx/preview/mixkit-relaxing-harp-sweep-2628.mp3",
      'coverUrl': "https://dlmocha.com/GameImages/MellowSik.png",
      'info': "https://dlmocha.com/app/mellowsik",
      'cover': "Mixkit Library"
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.bottom, //This line is used for showing the bottom bar
    ]);
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    initializePreference();
    loadFile();
    setupAudio();
    playIntro();
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    super.dispose();
  }

  @override
  void playIntro() {
    AudioManager.instance.play(index: 0);
  }

  void loadFile() async {
    List<int> numberList = [];
    Random random = new Random();
    var url = Uri.parse(
        'https://dlmocha.com/app/MellowSikSongAPI/${widget.type}.json');
    http.Response response = await http.get(url);
    var numSong = jsonDecode(response.body)['numSong'];
    var range = numSong;
    if (range > 100) {
      range = 100;
    }
    if (response.statusCode == 200) {
      String data = response.body;
      for (int i = 0; numberList.length < range; i++) {
        int num = random.nextInt(numSong);
        if (!numberList.contains(num)) {
          numberList.add(num);
          var decodeTitle = jsonDecode(data)['api'][num]['title'];
          var decodeSinger = jsonDecode(data)['api'][num]['singer'];
          var decodeUrl = jsonDecode(data)['api'][num]['url'];
          var decodeCoverURL = jsonDecode(data)['api'][num]['coverUrl'];
          var decodeCover = jsonDecode(data)['api'][num]['cover'];
          var decodeInfo = jsonDecode(data)['api'][num]['info'];

          list.add({
            'title': decodeTitle,
            'singer': decodeSinger,
            'url': decodeUrl,
            'coverUrl': decodeCoverURL,
            'cover': jsonDecode(data)['api'][num]['cover'],
            'info': decodeInfo,
          });
          AudioInfo info = AudioInfo(decodeUrl,
              title: decodeTitle, desc: decodeSinger, coverUrl: decodeCoverURL);
          AudioManager.instance.audioList.add(info);
        }
      }
    }
    setState(() {
      AudioManager.instance.play(index: 0);
    });
  }

  void setupAudio() {
    list.forEach((item) => _list.add(AudioInfo(item["url"],
        title: item["title"],
        desc: item["singer"],
        coverUrl: item["coverUrl"])));
    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);

    AudioManager.instance.onEvents((events, args) {
      curIndex = AudioManager.instance.curIndex;
      //print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
        /*
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
           */
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          _slider = 0;
          setState(() {});
          break;
        case AudioManagerEvents.ready:
        //print("ready to play");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          //print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
        //print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          //AudioManager.instance.updateLrc(args["desc"].toString());
          break;
        case AudioManagerEvents.error:
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => playIntro);
    return WillPopScope(
      onWillPop: () async => false,
      child: hasInternet
          ?  SafeArea(
        child: Scaffold(
          extendBody: true,
          appBar: maximizeUI ? null : AppBar(
            toolbarHeight: 50,
            backgroundColor: Colors.transparent,
            title: Text("Your playlist", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            leading: IconButton(icon: Icon(Icons.arrow_back_ios_sharp, color: themeColor,),
              onPressed: (){
                AudioManager.instance.release();
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,),
          ),
          backgroundColor: Color(0xff1f222b),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //Text(widget.type, style: TextStyle(fontSize: 18.0, color: Colors.white),),
                    //Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return new ListTile(
                                title: Text(
                                  list[index]["title"].length < 25
                                      ? list[index]["title"]
                                      : list[index]["title"]
                                      .substring(0, 23) +
                                      "...",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                                subtitle: Text(
                                  list[index]["singer"],
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                leading: Container(
                                  height: 78.0,
                                  width: 78.0,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(16.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            list[index]["coverUrl"]),
                                      ) //DecorationImage
                                  ), //BoxDecoration
                                ), //Container
                                onTap: () => AudioManager.instance
                                    .play(index: index));
                          },
                          separatorBuilder:
                              (BuildContext context, int index) =>
                              Divider(),
                          itemCount: list.length),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      )
          :

      Scaffold(
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
