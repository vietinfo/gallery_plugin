part of flutter_plugin_gallery;

class MediaItemGirdView extends StatefulWidget {
  final AssetEntity assetEntity;
  final int quality;
  MediaItemGirdView({required this.assetEntity, required this.quality});
  @override
  _MediaItemGirdViewState createState() => _MediaItemGirdViewState();
}

class _MediaItemGirdViewState extends State<MediaItemGirdView> {
  Rx<Uint8List> uint8List = Uint8List(0).obs;

  @override
  void initState() {
    getUint8List();
    super.initState();
  }

  void getUint8List() {
    widget.assetEntity
        .thumbDataWithOption(
            ThumbOption(width: 200, height: 200, quality: widget.quality))
        .then((value) {
      if (value != null) uint8List.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageWidget();
  }

  Widget _buildImageWidget() {
    return Obx(() {
      if (uint8List.value.length > 0) {
        if (widget.assetEntity.type == AssetType.image)
          return Image.memory(
            uint8List.value,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => noImage(),
          );
        else
          return Stack(
            children: [
              Image.memory(
                uint8List.value,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => noImage(),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ))
            ],
          );
      } else
        return noImage();
    });
  }
}
