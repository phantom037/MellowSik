import 'package:flutter/foundation.dart';

class Song {
  String title;
  String singer;
  String url;
  String coverUrl;
  String info;
  String cover;

  Song(
      {Key key,
      @required this.title,
      @required this.singer,
      @required this.url,
      @required this.coverUrl,
      @required this.info,
      @required this.cover});

  factory Song.fromJson(Map<String, dynamic> json) => Song(
      title: json['title'],
      singer: json['singer'],
      url: json['url'],
      coverUrl: json['coverUrl'],
      info: json['info'],
      cover: json['cover']);

  Map<String, dynamic> toJson() => {
        'title': title,
        'singer': singer,
        'url': url,
        'coverUrl': coverUrl,
        'info': info,
        'cover': cover
      };
}
