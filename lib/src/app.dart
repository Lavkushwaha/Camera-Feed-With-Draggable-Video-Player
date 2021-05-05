import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ivypod/src/screens/homeScreen.dart';

class MyApp extends StatelessWidget {
  CameraDescription camera;
  MyApp(this.camera);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IVYPOD',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        camera: camera,
      ),
    );
  }
}
