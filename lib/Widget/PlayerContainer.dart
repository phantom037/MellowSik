import 'package:flutter/material.dart';
class PlayerContainer extends StatefulWidget {
  //const PlayerContainer({Key? key}) : super(key: key);

  @override
  State<PlayerContainer> createState() => _PlayerContainerState();
}

class _PlayerContainerState extends State<PlayerContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.red,
    );
  }
}
