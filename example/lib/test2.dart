import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  SlidingUpPanelController panelController = SlidingUpPanelController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Gallery(
          child: Align(
            alignment: Alignment.topCenter,
            child: MaterialButton(
              color: Colors.yellow,
              onPressed: () => panelController.anchor(),
              child: Text('Show Gallery'),
            ),
          ),
          isSelectMulti: true,
          isVideo: false,
          qualityImage: 70,
          panelController: panelController,
          imagesChoice: (images) {
            print(images.length);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // panelController.dispose();
    super.dispose();
  }
}
