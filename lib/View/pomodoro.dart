import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/Constant/themeColor.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_Screen.dart';
import 'search_page.dart';
import 'instruction.dart';
import '../Widget/MyRoute.dart';

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  SharedPreferences preferences;
  double progress = 0.0;
  static int TimeInMinute = 25;
  int TimeInSec = TimeInMinute * 60;
  Timer _timer;
  bool isWorking = true;
  int count = 1;
  int effectiveHour = 0, totalHour = 0;

  bool isPlaying = false;
  Duration _duration;
  Duration _position;
  double _slider;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;
  List<AudioInfo> _list = [];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
    initializePreference();
    loadFile();
    setupAudio();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      startTimer();
      playIntro();
    });
    configureLocalNotification();
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (TimeInSec == 0) {
            if (isWorking && count % 4 == 0) {
              setState(() {
                progress = 0.0;
                TimeInMinute = 30;
                TimeInSec = TimeInMinute * 60;
                isWorking = false;
                count++;
                showNotification("Time for a break! Stretch your body.");
              });
            } else if (isWorking && count % 4 != 0) {
              setState(() {
                progress = 0.0;
                TimeInMinute = 5;
                TimeInSec = TimeInMinute * 60;
                isWorking = false;
                count++;
                showNotification("Let's take a short break!");
              });
            } else {
              setState(() {
                progress = 0.0;
                TimeInMinute = 25;
                TimeInSec = TimeInMinute * 60;
                isWorking = true;
                showNotification("Get back to work now!");
              });
            }
            // setState(() {
            //   timer.cancel();
            // });
          } else {
            setState(() {
              TimeInSec--;
              totalHour++;
              if (isWorking) {
                effectiveHour++;
              }
            });
          }
        } else {
          setState(() {
            _timer.cancel();
          });
        }
      },
    );
  }

  String formatTime(int time) {
    int sec = time % 60;
    int min = (time / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    progress = 1 - time / (TimeInMinute * 60);
    return "$minute : $second";
  }

  void configureLocalNotification() {
    final iosSetting = IOSInitializationSettings();
    final androidSetting = AndroidInitializationSettings('mipmap/ic_launcher');
    final settings =
        InitializationSettings(android: androidSetting, iOS: iosSetting);
    flutterLocalNotificationsPlugin.initialize(settings);
  }

  void showNotification(String messageNotification) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('com.leotran9x.palpitate', 'MellowSik',
            playSound: true,
            enableVibration: true,
            importance: Importance.max,
            channelShowBadge: true,
            icon: '@mipmap/ic_launcher'

            //styleInformation: styleInformation,
            //fullScreenIntent: true
            );
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      "MellowSik",
      messageNotification,
      notificationDetails,
      payload: null,
    );
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    _timer.cancel();
    super.dispose();
  }

  void playIntro() async{
    print("Play the intro");
    print("length: ${AudioManager.instance.audioList.length}");
    await AudioManager.instance.play(index: 0);
  }

  void loadFile() async {
    List<int> numberList = [];
    Random random = new Random();
    var url = Uri.parse('https://dlmocha.com/app/MellowSikSongAPI/study.json');
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

  void setupAudio() async{
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
          //setState(() {});
          break;
        case AudioManagerEvents.ready:
          //print("ready to play");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          //setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          //setState(() {});
          //print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          //print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          //setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          //setState(() {});
          //AudioManager.instance.updateLrc(args["desc"].toString());
          break;
        case AudioManagerEvents.error:
          //setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          //setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xff1f222b),
        appBar: new AppBar(
          backgroundColor: themeColor,
          title: new Text(
            "Working Mode",
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 18.0),
                    child: Text(
                      isWorking ? "Work" : "Break",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: themeColor),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  CircularPercentIndicator(
                    backgroundColor: Color(0xff636e72),
                    radius: 120.0,
                    lineWidth: 10.0,
                    animation: false,
                    percent: progress,
                    center: new Text(
                      formatTime(TimeInSec),
                      style: isWorking
                          ? TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.redAccent)
                          : TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0,
                              color: Colors.greenAccent),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: themeColor,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    //width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xff636e72),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0))),
                    child: Container(
                        child: Column(children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            height: 80,
                            width: 150,
                            decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Effective",
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "${(effectiveHour / 60).toInt()} min",
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          Container(
                            width: 150,
                            height: 80,
                            decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("Total",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 25,
                                ),
                                Text("${(totalHour / 60).toInt()} min",
                                    style: TextStyle(
                                        fontSize: 17, fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 80),
                    ])),
                  ),

                ]),
      ),
    );
  }
}
