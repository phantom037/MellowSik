import 'dart:math';

import 'package:palpitate/Model/Album.dart';
import 'package:palpitate/Widget/songScroll.dart';

Random random = new Random();
final allAlbums = <Album>[
  Album(
      id: 1,
      title: "Music Box",
      urlImage: CoverList[random.nextInt(5)],
      link: "musicbox"),
  Album(
      id: 2,
      title: "Piano",
      urlImage: CoverList[random.nextInt(5) + 5],
      link: "piano"),
  Album(
      id: 3,
      title: "Violin",
      urlImage: CoverList[random.nextInt(5) + 10],
      link: "violin"),
  Album(
      id: 4,
      title: "Guitar",
      urlImage: CoverList[random.nextInt(5) + 15],
      link: "guitar"),
  Album(
      id: 5,
      title: "Mix Instrument",
      urlImage: CoverList[random.nextInt(5) + 20],
      link: "mixInstrument"),
  Album(
      id: 6,
      title: "Anime",
      urlImage: CoverList[random.nextInt(5) + 25],
      link: "anime"),
  Album(
      id: 7,
      title: "K-Drama",
      urlImage: CoverList[random.nextInt(5) + 30],
      link: "kdrama"),
  Album(
      id: 8,
      title: "Pop Song",
      urlImage: CoverList[random.nextInt(5) + 35],
      link: "popSong"),
  Album(
      id: 9,
      title: "Classical",
      urlImage: CoverList[random.nextInt(5) + 40],
      link: "classical"),
  Album(
      id: 10,
      title: "Cafe",
      urlImage: CoverList[random.nextInt(5) + 45],
      link: "cafe"),
  Album(
      id: 11,
      title: "Study",
      urlImage: CoverList[random.nextInt(5) + 50],
      link: "study"),
  Album(
      id: 12,
      title: "Relax",
      urlImage: CoverList[random.nextInt(5) + 55],
      link: "relax"),
  Album(
      id: 14,
      title: "Travel",
      urlImage: CoverList[random.nextInt(5) + 60],
      link: "travel"),
];
