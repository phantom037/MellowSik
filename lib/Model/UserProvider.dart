import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  String username = "User";
  Map<String, int> streaming;

  UserProvider({
    this.username = "User",
    this.streaming = const {}
  });

  void updateStreaming({
    Map<String, int> newStreaming,
  }) async{
    this.streaming = newStreaming;
    notifyListeners();
  }
}