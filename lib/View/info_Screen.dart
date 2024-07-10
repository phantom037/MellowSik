import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palpitate/Constant/themeColor.dart';
import 'package:url_launcher/url_launcher.dart';


class InfoPage extends StatelessWidget {
  const InfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Thanks for using the app, if you have any questions, press the button to contact!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
              SizedBox(height: 50,),
              Container(
                width: 300,
                child: MaterialButton(
                  color: themeColor,
                    onPressed: (){
                  launch("https://dlmocha.com/contact");
                },
                child: Text("Contact"),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 300,
                child: MaterialButton(
                  color: themeColor,
                  onPressed: (){
                    launch("https://dlmocha.com/app/mellowsik");
                  },
                  child: Text("About"),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 300,
                child: MaterialButton(
                  color: themeColor,
                  onPressed: (){
                    launch("https://dlmocha.com/privacy");
                  },
                  child: Text("Privacy"),
                ),
              )
            ],
      ),),),
    );
  }
}
