import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/HomePage/piano.dart';
import 'dart:math';

List<String> CoverList = [
  //Instrument
  "https://dlmocha.com/app/MellowSik_Images/musicbox/1.jpg", //Music Box
  "https://dlmocha.com/app/MellowSik_Images/musicbox/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/musicbox/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/musicbox/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/musicbox/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/piano/1.jpg", //Piano
  "https://dlmocha.com/app/MellowSik_Images/piano/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/piano/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/piano/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/piano/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/violin/1.jpg", //Violin
  "https://dlmocha.com/app/MellowSik_Images/violin/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/violin/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/violin/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/violin/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/guitar/1.jpg", //Guitar
  "https://dlmocha.com/app/MellowSik_Images/guitar/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/guitar/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/guitar/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/guitar/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/mixInstru/1.jpg", // Mix
  "https://dlmocha.com/app/MellowSik_Images/mixInstru/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/mixInstru/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/mixInstru/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/mixInstru/5.jpg",

  //Type
  "https://dlmocha.com/app/MellowSik_Images/anime/1.jpg", //Anime
  "https://dlmocha.com/app/MellowSik_Images/anime/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/anime/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/anime/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/anime/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/kdrama/1.jpg", //K-drama
  "https://dlmocha.com/app/MellowSik_Images/kdrama/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/kdrama/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/kdrama/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/kdrama/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/pop/1.jpg", //Pop Song
  "https://dlmocha.com/app/MellowSik_Images/pop/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/pop/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/pop/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/pop/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/classical/1.jpg", //Classical
  "https://dlmocha.com/app/MellowSik_Images/classical/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/classical/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/classical/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/classical/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/cafe/1.jpg", //Cafe
  "https://dlmocha.com/app/MellowSik_Images/cafe/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cafe/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cafe/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cafe/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/study/1.jpg", // Study
  "https://dlmocha.com/app/MellowSik_Images/study/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/study/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/study/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/study/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/relax/1.jpg", //Relax
  "https://dlmocha.com/app/MellowSik_Images/relax/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/relax/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/relax/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/relax/5.jpg",

  "https://dlmocha.com/app/MellowSik_Images/travel/1.jpg", //Travel
  "https://dlmocha.com/app/MellowSik_Images/travel/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/travel/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/travel/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/travel/5.jpg",
];

class SongScroll extends StatefulWidget {
  @override
  _SongScrollState createState() => _SongScrollState();
}

class _SongScrollState extends State<SongScroll> {
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
        child: SizedBox(
          height: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Instrumental",
                style: TextStyle(
                    color: Color(0xff55efc4),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(
                        CoverList[random.nextInt(5)], " Music Box", "musicbox"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 5], " Piano", "piano"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 10], " Violin", "violin"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 15], " Guitar", "guitar"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(CoverList[random.nextInt(5) + 20],
                        " Mix Instrument", "mixInstrument"),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ), //Album1
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Category",
                style: TextStyle(
                    color: Color(0xff55efc4),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 25], " Anime", "anime"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(CoverList[random.nextInt(5) + 30],
                        " K-Drama", "kdrama"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(CoverList[random.nextInt(3) + 35],
                        " Pop Song", "popSong"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(CoverList[random.nextInt(5) + 40],
                        " Classical", "classical"),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ), //Album2
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Activity",
                style: TextStyle(
                    color: Color(0xff55efc4),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 45], " Cafe", "cafe"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 50], " Study", "study"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 55], " Relax", "relax"),
                    SizedBox(
                      width: 10.0,
                    ),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 60], " Travel", "travel"),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ), //Album3
            ],
          ),
        ),
      ),
    );
  }

  Widget AlbumContainer(String CoverUrl, String Title, String API_URL) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        height: 200,
        width: 160,
        color: Colors.black12,
        child: InkWell(
          onTap: () {
            setState(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return new Piano(type: API_URL);
              }));
            });
          },
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                    height: 140.0,
                    width: 140.0,
                    child: Image.network(CoverUrl)),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                //color: Colors.blue,
                height: 25,
                width: 150,
                child: Title.length > 10
                    ? Marquee(
                        text: Title,
                        blankSpace: 15,
                        style: TextStyle(
                            fontFamily: 'Tourney',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                        scrollAxis: Axis.horizontal,
                      )
                    : Text(Title,
                        style: TextStyle(
                            fontFamily: 'Tourney',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
