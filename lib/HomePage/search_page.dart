import 'dart:async';
import 'dart:ui';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:palpitate/HomePage/home_Screen.dart';
import 'package:palpitate/Widget/SearchWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/Support/instruction.dart';
import 'package:palpitate/Data/Song.dart';
import 'package:palpitate/Data/SongAPI.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isPlaying = false;
  num curIndex = 0;
  bool maximizeUI = false;
  bool hasInternet = true;
  String title, singer, url, coverUrl, info, cover;
  String fullTitle = "Not Playing", singCover = " ";

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

  playMusic(Song song) async {
    //await audioPlayer.play(url);
    AudioManager.instance
        .start(song.url, song.title, desc: song.cover, cover: song.coverUrl);
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
                        Container(
                          height: 20.0,
                          child: SizedBox(
                            height: 20.0,
                          ),
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
                          child: MiniPlayer(songs),
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
                      color: Colors.greenAccent,
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
            fullTitle = "${song.title} (${song.singer})";
            singCover = song.cover;
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
              child: FlatButton(
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
                            child: fullTitle.length > 20
                                ? Marquee(
                                    text: fullTitle,
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
                                      fullTitle,
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
                              singCover,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.home_rounded,
                      color: Color(0xff00cec9),
                    ),
                    onPressed: () {
                      setState(() {
                        AudioManager.instance.audioList.clear();
                        AudioManager.instance.release();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return HomePage();
                        }));
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Color(0xff00cec9),
                    ),
                    onPressed: () {
                      launch("https://dlmocha.com/app/mellowsik");
                    }),
                IconButton(
                  icon: Icon(Icons.help_center_outlined,
                      color: Color(0xff00cec9)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Instruction();
                    }));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xff00cec9),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ), //Column
      ),
    ); //Container
  }
}
