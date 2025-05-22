import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV en Vivo',
      theme: ThemeData.dark(),
      home: const StreamMenuPage(),
    );
  }
}

class StreamMenuPage extends StatelessWidget {
  const StreamMenuPage({super.key});

  final List<Map<String, String>> streams = const [
    {
      'title': 'Andorra TV (1080p)',
      'url': 'https://live-edge-eu-1.cdn.enetres.net/56495F77FD124FECA75590A906965F2C022/live-3000/index.m3u8',
    },
    {
      'title': 'ATV (720p)',
      'url': 'https://videos.rtva.ad/live/rtva/playlist.m3u8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canales de TV en Vivo')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: streams.length,
        itemBuilder: (context, index) {
          final stream = streams[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(
                      title: stream['title']!,
                      videoUrl: stream['url']!,
                    ),
                  ),
                );
              },
              child: Text(stream['title']!, style: const TextStyle(fontSize: 18)),
            ),
          );
        },
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String title;
  final String videoUrl;

  const VideoPage({
    required this.title,
    required this.videoUrl,
    super.key,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Usamos networkUrl con la URL en formato Uri
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
