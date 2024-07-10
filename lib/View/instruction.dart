import 'package:flutter/material.dart';

import '../Constant/themeColor.dart';

class Instruction extends StatefulWidget {
  const Instruction({Key key}) : super(key: key);

  @override
  _InstructionState createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: themeColor.withAlpha(60),
              blurRadius: 6.0,
              spreadRadius: 0.0,
              offset: const Offset(0.0, 3.0),
            ),
          ]),
          child: Text(
            'Support Center',
            style: TextStyle(
              color: themeColor,
              fontFamily: 'Amatic',
              fontSize: 25.0,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        //HomePage,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(scrollDirection: Axis.vertical, children: [
                  Container(
                    width: 300.0,
                    height: 500.0,
                    child: Image(
                      image: AssetImage('images/img1.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '► This is your home screen, where you could find our music playlist categories.\n'
                                  '► Scroll and slide to find your favorite playlist. Then Tap on it.\n'
                                  '► If you need more information about our app, user\'s policy, etc tap '),
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.info_outline,
                                color: themeColor,
                              ),
                            ),
                          ),
                          TextSpan(text: ' it will reach you to our website.'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 300.0,
                    height: 500.0,
                    child: Image(
                      image: AssetImage('images/img2.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '► A playlist of your chosen category will be generated to you.\n'
                                  '► If you want to change your category tap '),
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.home,
                                color: themeColor,
                              ),
                            ),
                          ),
                          TextSpan(
                              text:
                                  '\n► You can press the home button to enjoy the music and browse the internet together or just lock your phone and play when screen-off.\n'
                                  '► Tap the mini player bar to see the detail of the song as shown below.\n'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 300.0,
                    height: 500.0,
                    child: Image(
                      image: AssetImage('images/img3.png'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(
                              text:
                                  '► As credit, we use the names of the cover artists as well as links to their performances '),
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.insert_link,
                                color: themeColor,
                              ),
                            ),
                          ),
                          TextSpan(
                              text:
                                  '\n► You can search your song by tapping the button'),
                          WidgetSpan(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.search,
                                color: themeColor,
                              ),
                            ),
                          ),
                          TextSpan(
                              text: '. All of our songs are displayed here.\n'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 300.0,
                    height: 500.0,
                    child: Image(
                      image: AssetImage('images/img4.png'),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      "Please note that some features are still in development mode.",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ), //Expanded
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
