part of flutter_plugin_gallery;

class ImageDetail extends StatelessWidget {
  final Color? primaryColor;
  final String? groupName;
  final List<ImageModel> imageList;
  final int initIndex;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  late final bool isSelectMulti;
  ImageDetail(
      {required this.imageList,
      required this.initIndex,
        this.primaryColor,
      this.groupName, required this.imagesChoice,
      this.isSelectMulti = true});

  @override
  Widget build(BuildContext context) {
    GalleryController _galleryController = Get.find<GalleryController>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(groupName ?? ' '),
        actions: [
          (isSelectMulti)
              ? Obx(() {
                  if (_galleryController.imageChoiceList.length > 0)
                    return Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          color: Colors.transparent),
                      child: Center(
                        child: Text(
                          '${_galleryController.imageChoiceList.length}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  else
                    return SizedBox.shrink();
                })
              : SizedBox.shrink(),
          (isSelectMulti)
              ? Obx(() {
                  return GestureDetector(
                    onTap: () => _galleryController.actionImageChoiceList(
                        imageList[_galleryController.currentIndex.value]
                            .assetEntity!),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: (_galleryController.checkImageChoice(
                              imageList[_galleryController.currentIndex.value]
                                  .assetEntity!))
                          ? Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  color: Colors.blue),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  color: Colors.transparent),
                            ),
                    ),
                  );
                })
              : SizedBox.shrink()
        ],
      ),
      body: Stack(
        children: [
          buildImage(_galleryController),
          Positioned(
            bottom: 20,
            right: 10,
            child: (isSelectMulti)
                ? Obx(() {
                    if (_galleryController.imageChoiceList.length > 0)
                      return GestureDetector(
                        onTap: () {
                          imagesChoice(_galleryController.imageChoiceList);
                          _galleryController.imageChoiceList.clear();
                          Get.back(result: true);
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: primaryColor ?? Colors.blue),
                          child: Center(
                            child: Icon(
                              Icons.send_outlined,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    else
                      return SizedBox.shrink();
                  })
                : GestureDetector(
                    onTap: () {
                      AssetEntity imageSelect = _galleryController
                          .imageList[_galleryController.currentIndex.value]
                          .assetEntity!;
                      imagesChoice([imageSelect]);
                      Get.back(result: true);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor ?? Colors.blue),
                      child: Center(
                        child: Icon(
                          Icons.check,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
  // PhotoViewGallery

  Widget buildImage(GalleryController _galleryController) {
    return ExtendedImageGesturePageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: imageList[index].assetEntity?.file,
          builder: (context, AsyncSnapshot<File?> snapshot) {
            final File? file = snapshot.data;
            if (file == null) {
              return Container(
                  height: Get.height, width: Get.width, child: loadWidget(30));
            } else if (imageList[index].assetEntity?.type == AssetType.image)
              return Container(
                height: Get.height,
                width: Get.width,
                child: _image(file),
              );
            else {
              return Container(
                  height: Get.height,
                  width: Get.width,
                  child: VideoDetail(
                    looping: false,
                    autoPlay: true,
                    file: file,
                  ));
            }
          },
        );
      },
      itemCount: imageList.length,
      onPageChanged: (int index) {
        _galleryController.currentIndex.value = index;
      },
      controller: PageController(
        initialPage: initIndex,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _image(File file){
    return ExtendedImage.file(
      file,
      fit: BoxFit.contain,
      enableMemoryCache: true,
      mode: ExtendedImageMode.gesture,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return loadWidget(30);
          case LoadState.completed:
            return ExtendedImage.file(
              file,
              fit: BoxFit.contain,
              enableMemoryCache: true,
              mode: ExtendedImageMode.gesture,
              initGestureConfigHandler: (state) {
                return GestureConfig(
                  minScale: 0.9,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 3.5,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: true,
                  cacheGesture: false,
                  initialAlignment: InitialAlignment.center,
                );
              },
            );
            break;
          default:
            return loadWidget(30);
        }
      },
      initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 3.0,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: true,
          cacheGesture: false,
          initialAlignment: InitialAlignment.center,
        );
      },
    );
  }
}
