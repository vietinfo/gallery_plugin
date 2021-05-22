import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
import 'package:get/get.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Gallery(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: MaterialButton(
                  color: Colors.yellow,
                  onPressed: () => panelController.anchor(),
                  child: Text('Show Gallery Test 1'),
                ),
              ),
            ],
          ),
          isSelectMulti: true,
          isVideo: true,
          qualityImage: 70,
          panelController: panelController,
          imagesChoice: (images) {
            print('Test');
            print(images.first.id);
            print('Test');
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
