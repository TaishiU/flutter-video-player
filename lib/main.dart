import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Butterfly Video'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
          ),
          _ProgressText(controller: _controller),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                child: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _controller
                        .seekTo(Duration.zero)
                        .then((_) => _controller.pause());
                  });
                },
              ),
              FloatingActionButton(
                child: _controller.value.isPlaying
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                    //_controller.play();
                  });
                },
              ),
              // FloatingActionButton(
              //   child: Icon(Icons.pause),
              //   onPressed: () {
              //     setState(() {
              //       _controller.pause();
              //     });
              //   },
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressText extends StatefulWidget {
  final VideoPlayerController controller;

  const _ProgressText({Key? key, required this.controller}) : super(key: key);

  @override
  __ProgressTextState createState() => __ProgressTextState();
}

class __ProgressTextState extends State<_ProgressText> {
  late VoidCallback _listener;

  __ProgressTextState() {
    _listener = () {
      setState(() {});
    };
  }

  @override
  initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    widget.controller.removeListener(_listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final String position =
        '${widget.controller.value.position.inHours.toString()}:${widget.controller.value.position.inMinutes.toString()}:${widget.controller.value.position.inSeconds.toString()}';
    final String duration =
        '${widget.controller.value.position.inHours.toString()}:${widget.controller.value.duration.inMinutes.toString()}:${widget.controller.value.duration.inSeconds.toString()}';
    return Text('${position} / ${duration}');
  }
}
