import 'package:flutter/material.dart';
import 'package:palpitate/Constant/themeColor.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12.0),
    child: const CircularProgressIndicator(
      valueColor: const AlwaysStoppedAnimation(themeColor),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12.0),
    child: SizedBox(
      height: 15,
      width: 100,
      child: const LinearProgressIndicator(
        semanticsLabel: 'Loading Image',
        minHeight: 15,
        valueColor: const AlwaysStoppedAnimation(subThemeColor),
      ),
    ),
  );
}