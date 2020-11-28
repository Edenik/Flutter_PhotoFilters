import 'package:PhotoFilters/screens/screens.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PhotoFilters',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Colors.white, primaryColor: Colors.blueGrey),
      home: SplashScreen(),
    );
  }
}
