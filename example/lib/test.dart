import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
import 'package:get/get.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SlidingUpPanelController panelController = SlidingUpPanelController();
  GalleryController galleryController = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Gallery(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                  color: Colors.yellow,
                  onPressed: () async {
                    await galleryController.refreshGalleryList();
                    panelController.anchor();
                  },
                  child: Text('Show image'),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  color: Colors.yellow,
                  onPressed: () async {
                    await galleryController.refreshGalleryList(onlyVideo: true);
                    panelController.anchor();
                  },
                  child: Text('Show video'),
                ),
              ),
            ],
          ),
          isSelectMulti: true,
          isVideo: false,
          qualityImage: 70,
          panelController: panelController,
          imagesChoice: (images) {},
          galleryController: galleryController,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
