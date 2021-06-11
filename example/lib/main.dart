import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool showPerformance = false;

  onSettingCallback() {
    setState(() {
      showPerformance = !showPerformance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Sliding up panel Example';
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        showPerformanceOverlay: showPerformance,
        home: HomePage());
  }
}
