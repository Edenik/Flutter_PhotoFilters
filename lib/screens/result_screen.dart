import 'dart:io';

import 'package:PhotoFilters/screens/screens.dart';
import 'package:flutter/material.dart';

class ResultPhotoScreen extends StatelessWidget {
  final File imageFile;
  final String filterTitle;
  ResultPhotoScreen({@required this.imageFile, @required this.filterTitle});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20),
          Text('Filter: $filterTitle', style: TextStyle(fontSize: 30.0)),
          SizedBox(height: 20),
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () => _reset(context),
            color: Colors.black26,
            child: Text(
              'Reset',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      )),
    );
  }

  void _reset(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
  }
}
