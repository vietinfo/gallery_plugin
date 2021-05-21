import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
import 'package:flutter_plugin_gallery_example/home_page.dart';
import 'package:get/get.dart';

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
