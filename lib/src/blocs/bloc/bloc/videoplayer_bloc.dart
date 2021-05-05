import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'videoplayer_event.dart';
part 'videoplayer_state.dart';

class VideoplayerBloc extends Bloc<VideoplayerEvent, VideoplayerState> {
  VideoplayerBloc() : super(VideoplayerInitial());

  @override
  Stream<VideoplayerState> mapEventToState(
    VideoplayerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
