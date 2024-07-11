import 'dart:ffi';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
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
import 'package:crypto/crypto.dart';

import '../Constant/themeColor.dart';
import '../Widget/MyRoute.dart';

/**
 * @Attribute type: the type of the playlist
 */
class Piano extends StatefulWidget {
  final String type;
  Piano({Key key, @required this.type}) : super(key: key);
  @override
  _PianoState createState() => _PianoState();
}

class _PianoState extends State<Piano> {
  String userId; // id of the user
  SharedPreferences preferences; // cache data of the user
  // set default value for the streaming list activities
  bool isPlaying = false;
  Duration _duration;
  Duration _position;
  double _slider;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;
  bool hasInternet = true;

  bool maximizeUI = false; // default value to pitch the music playing bar
  List<AudioInfo> _list = []; // empty list store the songs of the playlist
  Map<String, int> streaming = {}; // map the playing song with number of its streaming time

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

  /**
   * Get the catch data
   */
  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
    try{
      this.streaming = preferences.getBool("streamMap") ?? {};
      this.userId = preferences.getString("id");
    }catch (e){
      preferences.setString('streamMap', jsonEncode(streaming));
    }
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    super.dispose();
  }

  /**
   * Play the first song (default MellowSik sound) in the list
   */
  @override
  void playIntro() {
    AudioManager.instance.play(index: 0);
  }

  /**
   * Fetch data from api that match the streaming songs to the list
   */
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
            'cover': decodeCover,
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
    // print("======================================================================");
    // for(var item in list){
    //   print("$item\n\n");
    // }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String> loadImageFromUrl(String imageUrl) async {
    try {
      var response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return imageUrl;
      } else {
        return "invalid";
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      return "invalid";
    }
  }

  /**
   * Load all songs from the list to AudioManager
   */
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
          String key = sha256ofString(list[curIndex]["title"] + list[curIndex]["url"]);
          streaming[key] = (streaming[key] ?? 0) + 1;
          FirebaseFirestore.instance.collection("user").doc(userId).update({
            "streamMap": this.streaming,
          });
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          //setState(() {});
          break;
        default:
          break;
      }
    });
    print("======================================================================");
    print("Streaming: " + streaming.toString());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => playIntro);
    return WillPopScope(
      onWillPop: () async => false,
      child: hasInternet
          ?  Scaffold(
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
                                      leading:
                                      Container(
                                        color: Colors.redAccent,
                                          height: 50.0,
                                          width: 50.0,
                                                child: BlurHash(hash: "T+N,i5RPR*_NS2n%NGt7j[V@V@bH", image: list[index]["coverUrl"]),
                                          ),

                                      // Container(
                                      //   height: 78.0,
                                      //   width: 78.0,
                                      //   decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(16.0),
                                      //       image: DecorationImage(image: NetworkImage(list[index]["coverUrl"]),) //DecorationImage
                                      //       ), //BoxDecoration
                                      // ), //Container
                                      onTap: () => AudioManager.instance
                                          .play(index: index));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(),
                                itemCount: list.length),
                          ),
                          Container(
                            child: MiniPlayer(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: maximizeUI
                          ? DetailMusicPlayer(context)
                          : Container(),
                    ),
                  ]),
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

  Widget MiniPlayer() {
    return GestureDetector(
      /*onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return DetailMusicPlayer(context);
          },
          isScrollControlled: true,
          isDismissible: false,
        );
      },
       */
      child: Container(
        color: Color(0xff2f3542),
        //alignment: Alignment.topRight,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
              alignment: Alignment.topRight,
              color: Color(0xff2f3542),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    maximizeUI = true;
                  });
                },
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  // .evenly if error
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      child: Image.network(list[curIndex]["coverUrl"]),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      //alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 20,
                            child: list[curIndex]["title"].length > 20
                                ? Marquee(
                                    text: list[curIndex]["title"],
                                    blankSpace: 200,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                  )
                                : Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      list[curIndex]["title"],
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              list[curIndex]["singer"],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ), //Row
            ),
            SizedBox(height: 15,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     IconButton(
            //         icon: Icon(
            //           Icons.home_rounded,
            //           color: themeColor,
            //         ),
            //         onPressed: () {
            //           setState(() {
            //             AudioManager.instance.audioList.clear();
            //             AudioManager.instance.release();
            //             Navigator.push(context, MyRoute(builder: (context) {
            //               return HomePage();
            //             }));
            //           });
            //         }),
            //     IconButton(
            //         icon: Icon(
            //           Icons.info_outline,
            //           color: themeColor,
            //         ),
            //         onPressed: () {
            //           launch("https://dlmocha.com/app/mellowsik");
            //         }),
            //     IconButton(
            //         icon: Icon(
            //           Icons.search,
            //           color: themeColor,
            //         ),
            //         onPressed: () {
            //           //Disable the 2 lines below if search and play in the playlist
            //           AudioManager.instance.audioList.clear();
            //           AudioManager.instance.release();
            //           Navigator.push(context, MyRoute(builder: (context) {
            //             return SearchScreen();
            //           }));
            //         }),
            //     IconButton(
            //       icon: Icon(Icons.help_center_outlined, color: themeColor),
            //       onPressed: () {
            //         Navigator.push(context, MyRoute(builder: (context) {
            //           return Instruction();
            //         }));
            //       },
            //     ),
            //     IconButton(
            //         icon: const Icon(Icons.timer_rounded, color: themeColor),
            //         onPressed: () {
            //           AudioManager.instance.audioList.clear();
            //           AudioManager.instance.release();
            //           Navigator.push(context, MyRoute(builder: (context) {
            //             return SearchScreen();
            //           }));
            //         }),
            //   ],
            // ),

          ],
        ), //Column
      ),
    );
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        ///IOS is :16, Android is 10
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _formatDuration(_position),
            style: TextStyle(color: Color(0xffffeedb)),
          ),
          SizedBox(width: MediaQuery.of(context).size.width / 1.7),
          Text(
            _formatDuration(_duration),
            style: TextStyle(color: Color(0xffffeedb)),
          ),
        ],
      ),

      Container(
        ///IOS is :16, Android is 7
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: getPlayModeIcon(playMode),
                onPressed: () {
                  playMode = AudioManager.instance.nextMode();
                  setState(() {});
                }),
            IconButton(

                ///IOS is :50, Android is 40
                iconSize: 50,
                icon: Icon(
                  Icons.skip_previous,
                  color: themeColor,
                ),
                onPressed: () => AudioManager.instance.previous()),
            IconButton(
              onPressed: () async {
                await AudioManager.instance.playOrPause();
                setState(() {
                  isPlaying = AudioManager.instance.isPlaying;
                });
              },
              padding: const EdgeInsets.all(0.0),
              icon: Icon(
                ///IOS is :60, Android is 50
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                size: 60.0,
                color: themeColor,
              ),
            ),
            IconButton(

                ///IOS is :50, Android is 40
                iconSize: 50,
                icon: Icon(
                  Icons.skip_next,
                  color: themeColor,
                ),
                onPressed: () => AudioManager.instance.next()),
            IconButton(
              icon: Icon(
                Icons.insert_link,
                color: themeColor,
              ),
              onPressed: () {
                setState(() {
                  openURL();
                });
              },
            ),
          ],
        ),
      ),
    ]);
  }

  Widget getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:
        return Icon(
          Icons.repeat,
          color: themeColor,
        );
      case PlayMode.shuffle:
        return Icon(
          Icons.shuffle,
          color: themeColor,
        );
      case PlayMode.single:
        return Icon(
          Icons.repeat_one,
          color: themeColor,
        );
    }
    return Container();
  }

  Widget songProgress(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  thumbColor: Colors.transparent,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 0.0,
                    enabledThumbRadius: 0.0,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                ),
                child: Slider(
                  //max: (_duration.inSeconds * 60).toDouble(),
                  value: _duration.inSeconds.toDouble() >
                          _position.inSeconds.toDouble()
                      ? _position.inSeconds.toDouble()
                      : 0,
                  min: 0.0,
                  max: _duration.inSeconds.toDouble() > 0
                      ? _duration.inSeconds.toDouble()
                      : 1,
                  activeColor: themeColor,
                  inactiveColor: subSlidingColor,
                  onChanged: (value) {
                    setState(() {
                      // _slider = value;
                    });
                  },
                  /*
                  onChangeEnd: (value) {
                    if (_duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                              (_duration.inMilliseconds * value).round());
                      AudioManager.instance.seekTo(msec);
                    }
                  },
                   */
                )),
          ),
        ),
      ],
    );
  }

  String getCover() {
    String cover = list[curIndex]["cover"];
    return cover;
  }

  void openURL() {
    String url = list[curIndex]["info"];
    launch(url);
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
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
                            list[curIndex]["coverUrl"],
                            width: widthScreen / 1.5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(48.0)),
                        ),
                        SizedBox(height: 16.0),
                        SizedBox(
                          ///IOS is :15-18, Android is 18
                          height: heightScreen / 18,
                          width: widthScreen,
                          child: AutoSizeText(
                            list[curIndex]["title"],
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
                          list[curIndex]["singer"],
                          style: TextStyle(
                            fontFamily: 'Amatic',
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ), //Text
                        SizedBox(height: 8.0),
                        Text(
                          list[curIndex]["cover"] == null
                              ? "MellowSik"
                              : list[curIndex]["cover"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ), //Text

                        bottomPanel(),
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
          image: NetworkImage(list[curIndex]["coverUrl"]),
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
