import 'package:camera/camera.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:ivypod/src/screens/cameraWidget.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import 'package:chewie/chewie.dart';

class HomeScreen extends StatefulWidget {
  CameraDescription camera;

  HomeScreen({this.camera});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController _controller;
  double _currentSliderValue = 0;
  Future<void> _initializeVideoPlayerFuture;
  bool isFullScreen = false;
  ChewieController _chewieController;
  DragController dragController = DragController();

  // ChewieController? _chewieController;
  @override
  void initState() {
    initializePlayer();
    super.initState();
  }

  Future<void> initializePlayer() async {
    _controller = VideoPlayerController.network(
        // 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
        // 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4'
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'
        // 'https//flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        );
    await Future.wait(
        [_initializeVideoPlayerFuture = _controller.initialize()]);
    // _controller.setLooping(true);

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      showControls: false,
      // fullScreenByDefault: true

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Hello World'),
      // ),
      body: SafeArea(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the VideoPlayerController has finished initialization, use
              // the data it provides to limit the aspect ratio of the video.
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    child: _chewieController != null &&
                            _chewieController
                                .videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            // height: size.height,
                            // width: size.width,
                            aspectRatio: size.width / size.height,

                            // fit: BoxFit.contain,

                            child: Chewie(
                              controller: _chewieController,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Loading'),
                            ],
                          ),
                  ),
                  DraggableWidget(
                    bottomMargin: 50,
                    topMargin: 20,
                    intialVisibility: true,
                    horizontalSapce: 20,
                    shadowBorderRadius: 50,
                    child: Container(
                        height: 100,
                        width: 200,
                        child: CameraWidget(
                          camera: widget.camera,
                        )),
                    initialPosition: AnchoringPosition.bottomLeft,
                    dragController: dragController,
                  ),

                  // ),
                  Positioned(
                      bottom: 10,
                      left: 10,
                      child: Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: 100,
                          // divisions: 5,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              _controller.setVolume(_currentSliderValue * 0.01);
                            });
                          })),

                  Center(
                      child: IconButton(
                          icon: _controller.value.isPlaying
                              ? Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                )
                              : Icon(Icons.play_arrow_outlined,
                                  color: Colors.white),
                          onPressed: () {
                            setState(() {
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                // If the video is paused, play it.
                                _controller.play();
                              }
                            });
                          })),

                  Positioned(
                      bottom: 20,
                      right: 10,
                      child: IconButton(
                          icon: Icon(
                            Icons.skip_next,
                            color: Colors.blue,
                            size: 40,
                          ),
                          onPressed: () {
                            _chewieController.seekTo(
                                _controller.value.position +
                                    Duration(seconds: 10));
                          })),

                  Positioned(
                      bottom: 20,
                      right: 60,
                      child: IconButton(
                          icon: Icon(
                            Icons.skip_previous,
                            color: Colors.blue,
                            size: 40,
                          ),
                          onPressed: () {
                            _chewieController.seekTo(
                                _controller.value.position -
                                    Duration(seconds: 10));
                          })),
                ],
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Wrap the play or pause in a call to `setState`. This ensures the
      //     // // correct icon is shown.
      //     // setState(() {
      //     //   isFullScreen = !isFullScreen;
      //     // });
      //     // _chewieController.enterFullScreen();
      //   },
      //   // Display the correct icon depending on the state of the player.
      //   child: Icon(isFullScreen ? Icons.fullscreen : Icons.screen_rotation),
      // ),
    );
  }
}
