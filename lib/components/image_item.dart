part of flutter_plugin_gallery;

class ImageItem extends StatelessWidget {
  final ImageModel imageModel;
  ImageItem({this.imageModel}); // final ThumbOption option;

  @override
  Widget build(BuildContext context) {
    return _buildImageWidget();
  }

  Widget _buildImageWidget() {
    if (imageModel.assetEntity.type == AssetType.image)
      return Image.memory(
        imageModel.uint8list,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => noImage(),
      );
    else
      return Stack(
        children: [
          Image.memory(
            imageModel.uint8list,
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
  }
}
