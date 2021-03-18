import 'package:flutter/material.dart';
import 'package:flutter_plugin_gallery/flutter_plugin_gallery.dart';
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: MaterialButton(
                color: Colors.yellow,
                onPressed: ()=> panelController.anchor(),
                child: Text('Click'),
              ),
            ),
            Gallery(
              panelController: panelController,
              imagesChoice: (images){
                print(images.length);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    panelController.dispose();
    super.dispose();
  }
}