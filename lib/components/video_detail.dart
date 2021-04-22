part of flutter_plugin_gallery;

class VideoDetail extends StatefulWidget {
  late final bool looping;
  late final bool autoPlay;
  final File file;

  VideoDetail({
    required this.file,
    this.looping = false,
    this.autoPlay = true,
  });

  @override
  _VideoDetailState createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {

  late ChewieController _chewieController;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.file);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9/16,
      autoInitialize: true,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
