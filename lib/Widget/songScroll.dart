import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:marquee/marquee.dart';
import 'package:palpitate/View/piano.dart';
import 'dart:math';

import 'MyRoute.dart';

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

  "https://dlmocha.com/app/MellowSik_Images/cello/1.jpg", //Cello
  "https://dlmocha.com/app/MellowSik_Images/cello/2.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cello/3.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cello/4.jpg",
  "https://dlmocha.com/app/MellowSik_Images/cello/5.jpg",
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
              const Text(
                "Instrumental",
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 65], " Cello", "cello"),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 5], " Piano", "piano"),
                    AlbumContainer(
                        CoverList[random.nextInt(5)], " Music Box", "musicbox"),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 10], " Violin", "violin"),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 15], " Guitar", "guitar"),
                    AlbumContainer(CoverList[random.nextInt(5) + 20],
                        " Mix Instrument", "mixInstrument"),
                  ],
                ),
              ), //Album1
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Category",
                style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 22.0,
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
                    AlbumContainer(CoverList[random.nextInt(5) + 30],
                        " K-Drama", "kdrama"),
                    AlbumContainer(CoverList[random.nextInt(3) + 35],
                        " Pop Song", "popSong"),
                    AlbumContainer(CoverList[random.nextInt(5) + 40],
                        " Classical", "classical"),
                  ],
                ),
              ), //Album2
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Activity",
                style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 22.0,
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
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 50], " Study", "study"),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 55], " Relax", "relax"),
                    AlbumContainer(
                        CoverList[random.nextInt(5) + 60], " Travel", "travel"),
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
        height: 150,
        width: 160,
        //color: Color(0xff2d3436),
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          //splashColor: Colors.transparent,
          //highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              Navigator.push(context, MyRoute(builder: (context) {
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
                    child: AspectRatio(
                      aspectRatio: 1.6,
                      child: BlurHash(hash: "T+N,i5RPR*_NS2n%NGt7j[V@V@bH", image: CoverUrl,),
                    ),),//Image.network(CoverUrl)),
              ),
              SizedBox(
                height: 12.0,
              ),
              Container(
                //color: Colors.blue,
                height: 20,
                width: 150,
                child: Title.length > 10
                    ? Marquee(
                        text: Title,
                        blankSpace: 15,
                        style: TextStyle(
                            fontFamily: 'Tourney',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 17),
                        scrollAxis: Axis.horizontal,
                      )
                    : Text(Title,
                        style: TextStyle(
                            fontFamily: 'Tourney',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 17)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
