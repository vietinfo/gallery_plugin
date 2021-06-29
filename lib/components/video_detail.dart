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

  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _futureInitVideoPlayer;

  Future<void> initVideoPlayer() async{
    await _videoPlayerController.initialize();
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.file);
    _futureInitVideoPlayer = initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
          future: _futureInitVideoPlayer,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return Center(
                child: Chewie(
                  controller: _chewieController,
                ),
              );
            return loadWidget(20);
          },
        )
    );
  }
}
