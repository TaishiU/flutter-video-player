// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('HomeScreen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('HomeScreen'),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => VideoPlayerScreen()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(
//       'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     );
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Butterfly Video'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             FutureBuilder(
//               future: _initializeVideoPlayerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: Stack(
//                       children: [
//                         VideoPlayer(_controller),
//                         Positioned(
//                           bottom: 0,
//                           height: 10,
//                           width: _controller.value.size.width,
//                           child: VideoProgressIndicator(
//                             _controller,
//                             allowScrubbing: true,
//                             colors: VideoProgressColors(
//                               playedColor: Colors.red,
//                               bufferedColor: Colors.white.withOpacity(0.5),
//                               backgroundColor: Colors.black.withOpacity(0.2),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//             // VideoProgressIndicator(
//             //   _controller,
//             //   allowScrubbing: true,
//             // ),
//             _ProgressText(controller: _controller),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 FloatingActionButton(
//                   child: Icon(Icons.refresh),
//                   onPressed: () {
//                     setState(() {
//                       _controller
//                           .seekTo(Duration.zero)
//                           .then((_) => _controller.pause());
//                     });
//                   },
//                 ),
//                 FloatingActionButton(
//                   child: _controller.value.isPlaying
//                       ? Icon(Icons.pause)
//                       : Icon(Icons.play_arrow),
//                   onPressed: () {
//                     setState(() {
//                       if (_controller.value.isPlaying) {
//                         _controller.pause();
//                       } else {
//                         _controller.play();
//                       }
//                       //_controller.play();
//                     });
//                   },
//                 ),
//                 // FloatingActionButton(
//                 //   child: Icon(Icons.pause),
//                 //   onPressed: () {
//                 //     setState(() {
//                 //       _controller.pause();
//                 //     });
//                 //   },
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _ProgressText extends StatefulWidget {
//   final VideoPlayerController controller;
//
//   const _ProgressText({Key? key, required this.controller}) : super(key: key);
//
//   @override
//   __ProgressTextState createState() => __ProgressTextState();
// }
//
// class __ProgressTextState extends State<_ProgressText> {
//   late VoidCallback _listener;
//
//   __ProgressTextState() {
//     _listener = () {
//       setState(() {});
//     };
//   }
//
//   @override
//   initState() {
//     super.initState();
//     widget.controller.addListener(_listener);
//   }
//
//   @override
//   void deactivate() {
//     widget.controller.removeListener(_listener);
//     super.deactivate();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String position =
//         '${widget.controller.value.position.inHours.toString()}:${widget.controller.value.position.inMinutes.toString()}:${widget.controller.value.position.inSeconds.toString()}';
//     final String duration =
//         '${widget.controller.value.position.inHours.toString()}:${widget.controller.value.duration.inMinutes.toString()}:${widget.controller.value.duration.inSeconds.toString()}';
//     return Text('${position} / ${duration}');
//   }
// }

import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chewie Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chewie'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Next'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      // Try playing around with some of these other options:

      //showControls: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.black,
      ),
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chewie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
