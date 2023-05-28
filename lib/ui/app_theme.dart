import 'package:flutter/material.dart';

final Map<bool, ThemeData> appThemes = {
  false: ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      focusColor: Colors.black),
  true: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor:  Colors.blueGrey.shade900,
      focusColor: Colors.white),
};
