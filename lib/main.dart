import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivypod/src/app.dart';
import 'package:ivypod/src/blocs/bloc/bloc/videoplayer_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[1];

  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(RootApp(camera: firstCamera));
  });
}

class RootApp extends StatelessWidget {
  final CameraDescription camera;

  const RootApp({Key key, this.camera}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoplayerBloc>(
          create: (BuildContext context) => VideoplayerBloc(),
        ),
      ],
      child: MyApp(camera),
    );
  }
}
