import 'package:palpitate/PlaylistUI/randomSong.dart';
import 'package:flutter/material.dart';
import 'package:palpitate/PlaylistUI/playlist.dart';

List<String> CoverList = [
  //Instrument
  "https://i.pinimg.com/474x/68/b1/db/68b1db8cb2b3ca1fe77cf2d484600bf2.jpg",
  "https://i.pinimg.com/564x/0e/f8/72/0ef872801be82d593c5e635eea752fdf.jpg",
  "https://i.pinimg.com/564x/aa/7e/07/aa7e07fbdf8d0396cd63f4701f18c07c.jpg",
  "https://i.pinimg.com/564x/de/ac/63/deac63cb14ff7180d7e3bc79fd4ba5be.jpg",
  "https://i.pinimg.com/564x/bb/ea/ca/bbeaca01ea982b459ac88ef03ab7d0e7.jpg",
  //Type
  "https://i.pinimg.com/564x/55/6a/90/556a90461357fca9a425ae8cb4075405.jpg",
  "https://i.pinimg.com/564x/02/eb/ac/02ebac2ba52eda2828446a992271c0a1.jpg",
  "https://i.pinimg.com/474x/17/07/c4/1707c418c6a6305e306ff9a3c77cce10.jpg",
  "https://i.pinimg.com/564x/8e/1f/4a/8e1f4a38209ca83f853662b02cdf8bea.jpg"
];

class SongScroll extends StatefulWidget {
  static String id = "Menu";
  @override
  _SongScrollState createState() => _SongScrollState();
}

class _SongScrollState extends State<SongScroll> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: new DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/564x/b2/70/d9/b270d96b704103fd08b19646c0e87992.jpg"),
              fit: BoxFit.fill)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 25.0),
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
                height: 20.0,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(CoverList[0], "Music Box"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[1], "Piano"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[2], "Violin"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[3], "Guitar"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[4], "Harp"),
                    SizedBox(
                      width: 28.0,
                    ),
                  ],
                ),
              ), //Album1
              Text(
                "Type",
                style: TextStyle(
                    color: Color(0xff55efc4),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(CoverList[5], "Anime"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[6], "K-Drama"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[7], "Morning Cafe"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[8], "Travel"),
                    SizedBox(
                      width: 28.0,
                    ),
                  ],
                ),
              ), //Album2
              Text(
                "New Music",
                style: TextStyle(
                    color: Color(0xff55efc4),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    AlbumContainer(CoverList[3], "CoverName"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[4], "CoverName"),
                    SizedBox(
                      width: 28.0,
                    ),
                    AlbumContainer(CoverList[5], "CoverName"),
                    SizedBox(
                      width: 28.0,
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

  Widget AlbumContainer(String CoverUrl, String Title) {
    return Container(
      child: InkWell(
        onTap: () {
          print("Press Key");
          setState(() {
            Navigator.pushNamed(context, MusicApp.id);
          });
        },
        child: SizedBox(
          height: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              Text(
                Title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 22.0),
              ),
              SizedBox(
                height: 12.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
