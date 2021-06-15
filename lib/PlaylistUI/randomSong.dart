import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:palpitate/PlaylistUI/custom_list_title.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Album/songData.dart';
import 'package:audio_service/audio_service.dart';

MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

Music songData = Music();
String currentTitle = "";
String currentCover = "";
String currentSinger = "";
String currentSubSinger = "";
String currentLink = "";
int currentIndex = 0;
Duration duration = new Duration();
Duration position = new Duration();
bool isPlaying = false, isStreaming = false;
int range = 0;
//Player UI Data
IconData btnIcon = Icons.pause_circle_filled_outlined;

//Audio Player
AudioPlayer audioPlayer = new AudioPlayer();

class MusicApp extends StatefulWidget {
  static String id = "Random_Song";
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  List musicList = songData.getList();

  String currentSong = "";

  play(List dataList, int currentIndex) async {
    int result = await audioPlayer.play(dataList[currentIndex]['url']);
    if (result == 1) {
      print('Success: is playing');
    } else {
      print('Error on audio play');
    }

    audioPlayer.onPlayerCompletion.listen((event) {
      if (currentIndex < dataList.length - 1) {
        currentIndex = currentIndex + 1;
        currentTitle = musicList[currentIndex]['title'];
        currentCover = musicList[currentIndex]['coverUrl'];
        currentSinger = musicList[currentIndex]['singer'];
        nextTrack(dataList, currentIndex);
        print("NEXT AUDIO! $currentIndex");
      } else {
        print("AUDIO COMPLETED PLAYING");
      }
    });
  }

  void nextTrack(List dataList, int currentIndex) {
    play(dataList, currentIndex);
  }

  void playMusic(String url) async {
    if (isPlaying && currentSong != url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  openURL() {
    String url = currentLink;
    launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://i.pinimg.com/564x/08/f4/0a/08f40a5475f8929dbeff698da466edba.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Palpitate",
            style: TextStyle(
              color: Color(0xff55efc4),
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            //Song playlist
            Expanded(
              child: ListView.builder(
                  itemCount: musicList.length,
                  itemBuilder: (context, index) => customListTile(
                        ontap: () {
                          setState(() {
                            AudioService.currentMediaItem;
                            currentIndex = index;
                            playMusic(musicList[index]['url']);
                            nextTrack(musicList, index);
                            currentTitle = musicList[currentIndex]['title'];
                            currentCover = musicList[currentIndex]['coverUrl'];
                            currentSinger = musicList[currentIndex]['singer'];
                            currentSubSinger = musicList[currentIndex]['cover'];
                            currentLink = musicList[currentIndex]['info'];
                            isPlaying = true;
                          });
                        },
                        tile: musicList[index]['title'],
                        singer: musicList[index]['singer'] + '\n',
                        cover: musicList[index]['coverUrl'],
                      )),
            ),
            //Player
            Container(
              child: isStreaming ? SongStreamingUI() : MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget MiniPlayer() {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        foregroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xff6c5ce7),
          boxShadow: [
            BoxShadow(
              color: Color(0x55212121),
              blurRadius: 8.0,
            ), //BoxShadow
          ],
          image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/564x/0c/6f/4b/0c6f4b0660daa900f95d974948676118.jpg"),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(50.0),
        ), //BoxDecoration
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        image: DecorationImage(
                          image: NetworkImage(currentCover),
                        ) //DecorationImage
                        ), //BoxDecoration
                  ), //Container
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        setState(() {
                          isStreaming = true;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            currentTitle,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ), //Text
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            currentSinger,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), //Column
                ],
              ), //Row
            ) //Padding
          ],
        ), //Column
      ),
    ); //Container
  }

  // ignore: non_constant_identifier_names
  Widget SongStreamingUI() {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://i.pinimg.com/564x/0c/6f/4b/0c6f4b0660daa900f95d974948676118.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x55212121),
              blurRadius: 8.0,
            ), //BoxShadow
          ]), //BoxDecoration
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Container(
              width: 280.0,
              height: 280.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(
                    image: NetworkImage(currentCover),
                  )),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Center(
              child: Text(
                currentTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              child: Text(
                currentSinger,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Text(
            currentSubSinger,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            child: SizedBox(
              height: 20.0,
              child: SliderTheme(
                child: Slider(
                  value: duration.inSeconds.toDouble() >
                          position.inSeconds.toDouble()
                      ? position.inSeconds.toDouble()
                      : 0,
                  min: 0.0,
                  max: duration.inSeconds.toDouble() > 0
                      ? duration.inSeconds.toDouble()
                      : 1,
                  activeColor: Color(0xff00cec9),
                  inactiveColor: Color(0xff81ecec),
                  onChanged: (double value) {},
                ), //Slider.adaptive
                data: SliderTheme.of(context).copyWith(
                    trackHeight: 8,
                    thumbColor: Colors.transparent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0)),
              ),
            ),
          ), //Container
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: IconButton(
                      iconSize: 80.0,
                      icon: Icon(Icons.skip_previous_outlined),
                      color: Color(0xff81ecec),
                      onPressed: () {
                        try {
                          setState(() {
                            currentIndex--;
                            playMusic(musicList[currentIndex]['url']);
                            currentTitle = musicList[currentIndex]['title'];
                            currentCover = musicList[currentIndex]['coverUrl'];
                            currentSinger = musicList[currentIndex]['singer'];
                            currentSubSinger = musicList[currentIndex]['cover'];
                            currentLink = musicList[currentIndex]['info'];
                            isPlaying = true;
                          });
                        } catch (error, stackTrace) {}
                      },
                    ),
                  ),
                ), //PreviousButton
                Center(
                  child: GestureDetector(
                    child: IconButton(
                      iconSize: 80.0,
                      color: Color(0xff81ecec),
                      icon: Icon(isPlaying
                          ? btnIcon = Icons.pause_circle_filled_outlined
                          : btnIcon = Icons.play_circle_fill_outlined),
                      onPressed: () {
                        //Pause
                        if (isPlaying) {
                          audioPlayer.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          audioPlayer.resume();
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                    ),
                  ),
                ), //PlayButton
                Center(
                  child: GestureDetector(
                    child: IconButton(
                      iconSize: 80.0,
                      icon: Icon(Icons.skip_next_outlined),
                      color: Color(0xff81ecec),
                      onPressed: () {
                        setState(() {
                          currentIndex++;
                          playMusic(musicList[currentIndex]['url']);
                          currentTitle = musicList[currentIndex]['title'];
                          currentCover = musicList[currentIndex]['coverUrl'];
                          currentSinger = musicList[currentIndex]['singer'];
                          currentSubSinger = musicList[currentIndex]['cover'];
                          currentLink = musicList[currentIndex]['info'];
                          isPlaying = true;
                        });
                      },
                    ),
                  ),
                ), //NextButton
              ],
            ), //Row
          ), //Padding
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: IconButton(
                  iconSize: 30.0,
                  icon: Icon(Icons.info_outline_rounded),
                  color: Color(0xff00cec9),
                  onPressed: () {
                    openURL();
                  },
                ),
              ), //DropdownButton
              SizedBox(width: 200.0),
              GestureDetector(
                child: IconButton(
                  iconSize: 50.0,
                  icon: Icon(Icons.arrow_drop_down_rounded),
                  color: Color(0xff00cec9),
                  onPressed: () {
                    setState(() {
                      isStreaming = false;
                    });
                  },
                ),
              ), //DropdownButton
            ],
          ),
        ],
      ), //Column
    ); //Container
  }
}
