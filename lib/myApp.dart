//@dart = 2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mainscreen.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      routes: {
        "/main": (_) => new MainScreen(),
      },
    );
  }
}
