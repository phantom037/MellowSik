import 'package:flutter/cupertino.dart';

class Album {
  final int id;
  final String title;
  final String urlImage;
  final String link;

  const Album(
      {@required this.id,
      @required this.title,
      @required this.urlImage,
      @required this.link});
}
