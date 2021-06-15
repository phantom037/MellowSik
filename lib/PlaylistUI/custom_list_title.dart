import 'package:flutter/material.dart';

Widget customListTile({String tile, String singer, String cover, ontap}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Container(
            height: 78.0,
            width: 78.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                  image: NetworkImage(cover),
                ) //DecorationImage
                ), //BoxDecoration
          ), //Container
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tile,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xfff1f2f6),
                ),
              ), //Text
              SizedBox(
                height: 5.0,
              ),
              Text(
                singer,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
