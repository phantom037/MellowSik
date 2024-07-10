import 'dart:async';
import 'dart:ui';
import 'package:audio_manager/audio_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpitate/View/home_Screen.dart';
import 'package:palpitate/Widget/MyRoute.dart';
import 'package:palpitate/Widget/SearchWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/View/instruction.dart';
import 'package:palpitate/Model/Song.dart';
import 'package:palpitate/Controller/SongAPI.dart';

import '../Constant/themeColor.dart';
import 'pomodoro.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isPlaying = false;
  num curIndex = 0;
  bool maximizeUI = false;
  bool hasInternet = true;
  //Empty strings control song title, singer of the song,
  // streaming url, image cover url, source url, artist cover name;
  String titleDisplay = "Not Playing",
      cover = " ",
      singer,
      coverUrl,
      info,
      title;
  //Empty list of songs store the matching song from query
  List<Song> songs = [];
  String query = ' ';
  Timer debouncer;

  @override
  void initState() {
    super.initState();
    init();
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.bottom, //This line is used for showing the bottom bar
    ]);
    InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
  }

  ///From Internet
  @override
  void dispose() {
    AudioManager.instance.release();
    debouncer?.cancel();
    super.dispose();
  }

  /**
   * Let Audio Marager stream the given selected song
   * @Parameter: the song need to stream
   */
  playMusic(Song song) async {
    //await audioPlayer.play(url);
    AudioManager.instance
        .start(song.url, song.title, desc: song.cover, cover: song.coverUrl);
    setState(() {
      isPlaying = true;
    });
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 200),
  }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  void init() async {
    final songs = await SongApi.getSongs(query);

    setState(() => this.songs = songs);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: hasInternet
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                            height: 20.0,
                          ),

                        Container(
                          child: buildSearch(),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
                              return buildSong(song, index);
                            },
                          ),
                        ),
                        Container(
                          child: maximizeUI && isPlaying
                              ? DetailMusicPlayer(context)
                              : MiniPlayer(songs),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Scaffold(
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
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Artist',
        onChanged: searchSong,
      );

  /**
   * @parameter query: the input enterd by user in textfield
   * Set the query matching the requirement string entered by users
   */
  Future searchSong(String query) async => debounce(() async {
        final songs = await SongApi.getSongs(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.songs = songs;
        });
      });

  Widget buildSong(Song song, int songIndex) => ListTile(
        leading: Container(
          height: 100.0,
          width: 100.0,
          child: Image.network(
            song.coverUrl,
            height: 70.0,
            width: 70.0,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(
          song.singer,
          style: TextStyle(
              fontSize: 15.0, fontWeight: FontWeight.w300, color: Colors.white),
        ),
        onTap: () {
          setState(() {
            title = song.title;
            cover = song.cover;
            coverUrl = song.coverUrl;
            info = song.info;
            singer = song.singer;
            titleDisplay = title + " ($singer)";
            playMusic(song);
          });
        },
      );

  Widget MiniPlayer(List<Song> songs) {
    return GestureDetector(
      child: Container(
        color: Colors.black,
        //alignment: Alignment.topRight,
        child: Column(
          children: <Widget>[
            Container(
              //alignment: Alignment.topRight,
              color: Color(0xff2f3542),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    //maximizeUI = true;
                  });
                },
                child: Row(
                  // .evenly if error
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      //alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 20,
                            child: titleDisplay.length > 20
                                ? Marquee(
                                    text: titleDisplay,
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
                                      titleDisplay,
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
                              cover,
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
              ),
            ), //Row

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
            //       icon: Icon(
            //         Icons.search,
            //         color: themeColor,
            //       ),
            //     ),
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
            //           Navigator.push(context, MyRoute(builder: (context) {
            //             return Pomodoro();
            //           }));
            //         }),
            //   ],
            // ),
            //
            // SizedBox(
            //   height: 10.0,
            // ),
          ],
        ), //Column
      ),
    ); //Container
  }

  Widget DetailMusicPlayer(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height / 1.2;
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
                            coverUrl,
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
                            title,
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
                          singer,
                          style: TextStyle(
                            fontFamily: 'Amatic',
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ), //Text
                        SizedBox(height: 8.0),
                        Text(
                          cover,
                          style: TextStyle(
                            fontFamily: 'Amatic',
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ), //Text
                        Container(),
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
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildWidgetBackgroundCoverAlbum(
      double widthScreen, double heightScreen) {
    return Container(
      width: widthScreen,
      height: heightScreen / 2,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(coverUrl),
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
