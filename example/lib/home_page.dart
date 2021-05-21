import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'test.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: ()=> Get.to(Test()),
          child: Text('Click'),
        ),
      ),
    );
  }
}
