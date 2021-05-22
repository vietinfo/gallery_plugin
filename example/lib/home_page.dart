import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
import 'package:flutter_plugin_gallery_example/test2.dart';
import 'package:get/get.dart';

import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    Get.create(() => GalleryController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () => Get.to(Test()),
              child: Text('Click test 1'),
            ),
            MaterialButton(
              onPressed: () => Get.to(Test2()),
              child: Text('Click test 2'),
            ),
          ],
        ),
      ),
    );
  }
}
