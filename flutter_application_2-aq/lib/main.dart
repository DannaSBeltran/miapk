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
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const StreamMenuPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StreamMenuPage extends StatelessWidget {
  const StreamMenuPage({super.key});

  static const List<Map<String, String>> streams = [
    {
      'title': 'Andorra TV (1080p)',
      'url': 'https://live-edge-eu-1.cdn.enetres.net/56495F77FD124FECA75590A906965F2C022/live-3000/index.m3u8',
    },
    {
      'title': 'TVE La 1 (España)',
      'url': 'https://rtvelivestream.akamaized.net/rtve/la1_main_dvr.m3u8',
    },
    {
      'title': 'Canal 24h RTVE',
      'url': 'https://rtvelivestream.akamaized.net/rtve/24h_main_dvr.m3u8',
    },
    {
      'title': 'Aragón TV',
      'url': 'https://cdnlive.shooowit.net/aragontelevision/live.stream/index.m3u8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📺 Canales de TV en Vivo')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: streams.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final stream = streams[index];
          return Card(
            color: Colors.indigo[700],
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: const Icon(Icons.live_tv, size: 32, color: Colors.white),
              title: Text(
                stream['title']!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.play_circle_outline, size: 30, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPage(
                      title: stream['title']!,
                      videoUrl: stream['url']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        setState(() => _hasError = true);
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
        child: _hasError
            ? const Text('❌ Error al cargar el canal')
            : _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
      ),
      floatingActionButton: _controller.value.isInitialized
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
