import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivypod/src/app.dart';
import 'package:ivypod/src/blocs/bloc/bloc/videoplayer_bloc.dart';

void main() {
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoplayerBloc>(
          create: (BuildContext context) => VideoplayerBloc(),
        ),
      ],
      child: MyApp(),
    );
  }
}
