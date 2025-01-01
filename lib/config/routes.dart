import 'package:flutter/material.dart';
import 'package:pure_noise/screens/home_screen.dart';
import 'package:pure_noise/screens/player_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => HomeScreen(),
  '/player': (context) => PlayerScreen(),
};