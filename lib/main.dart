import 'dart:async';

import 'package:PhotoFilters/screens/screens.dart';
import 'package:PhotoFilters/utilities/show_error_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CameraDescription> _cameras;

  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    _getCameras();
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
  }

  Widget _getScreenId() {
    return _isTimerDone && _cameras != null
        ? CameraScreen(_cameras)
        : SplashScreen();
  }

  void _getCameras() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (_) {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Cant get cameras!', context: context);
    }
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
