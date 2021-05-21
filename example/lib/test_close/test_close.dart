import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
import 'package:get/get.dart';

class TestClose extends StatelessWidget {
  const TestClose({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            child: Text(Get.find<GalleryController>().quality.toString())));
  }
}
