import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  VideoPlayerController _controller;
  double _currentSliderValue = 0;
  Future<void> _initializeVideoPlayerFuture;
  bool isFullScreen = false;
  @override
  void initState() {
    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello World'),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return Stack(
              children: [
                Center(
                  child: Transform.rotate(
                    angle: isFullScreen ? -math.pi / 2.0 : 0,
                    child: Container(
                      // height: isFullScreen
                      //     ? MediaQuery.of(context).size.width
                      //     : MediaQuery.of(context).size.height,
                      // width: isFullScreen
                      //     ? MediaQuery.of(context).size.height
                      //     : MediaQuery.of(context).size.width,
                      child: AspectRatio(
                        // aspectRatio: _controller.value.aspectRatio,
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ),
                Positioned(
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
                Positioned(
                    right: 10,
                    child: IconButton(
                        icon: _controller.value.isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow_outlined),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              // If the video is paused, play it.
                              _controller.play();
                            }
                          });
                        }))
              ],
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            isFullScreen = !isFullScreen;
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(isFullScreen ? Icons.fullscreen : Icons.screen_rotation),
      ),
    );
  }
}
