// import 'dart:async';
import 'dart:async';

import 'package:PhotoFilters/screens/screens.dart';
import 'package:PhotoFilters/utilities/show_error_dialog.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  List<CameraDescription> _cameras;

  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    _getCameras();
    Timer(Duration(seconds: 3), () => setState(() => _isTimerDone = true));
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
    return _isTimerDone && _cameras != null
        ? CameraScreen(_cameras)
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Developed with ♥ by:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0, top: 10),
                      child: GestureDetector(
                        onTap: () async {
                          const url = 'https://Edenik.com';
                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: true,
                              forceWebView: true,
                              enableJavaScript: true,
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          'Edenik.Com',
                          style:
                              TextStyle(fontSize: 55, fontFamily: 'Billabong'),
                        ),
                      ),
                    ),
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'PhotoFilters',
                      style: TextStyle(fontSize: 70, fontFamily: 'Billabong'),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
