import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dog_food_app/models/educational.content.model.dart';

class EducationalContentView extends StatelessWidget {
  const EducationalContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Educational Content"),
      ),
      body: ListView.builder(
        itemCount: educationalContentList.length,
        itemBuilder: (context, index) {
          final content = educationalContentList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(content.title),
              subtitle: Text(content.description),
              onTap: () => _navigateToDetail(context, content),
            ),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, EducationalContent content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducationalContentDetailView(content: content),
      ),
    );
  }
}

class EducationalContentDetailView extends StatelessWidget {
  final EducationalContent content;

  const EducationalContentDetailView({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(content.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (content.type == ContentType.video)
              EducationalVideoPlayer(url: content.contentUrl),
            _buildArticleOrGuideContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleOrGuideContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.description,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Text(
          'Read more at: ${content.contentUrl}',
          style: const TextStyle(color: Colors.blue),
        ),
      ],
    );
  }
}

class EducationalVideoPlayer extends StatefulWidget {
  final String url;

  const EducationalVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  _EducationalVideoPlayerState createState() => _EducationalVideoPlayerState();
}

class _EducationalVideoPlayerState extends State<EducationalVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Update the UI after initialization
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(child: CircularProgressIndicator()),
        VideoProgressIndicator(_controller, allowScrubbing: true),
        IconButton(
          icon: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
        ),
      ],
    );
  }
}
