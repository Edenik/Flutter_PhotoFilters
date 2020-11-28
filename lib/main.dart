import 'dart:async';

import 'package:PhotoFilters/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
  }

  Widget _getScreenId() {
    return _isTimerDone ? CameraScreen() : SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PhotoFilters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getScreenId(),
    );
  }
}
