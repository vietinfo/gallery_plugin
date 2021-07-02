part of flutter_plugin_gallery;

class ImageDetail extends StatelessWidget {
  final Color primaryColor;
  final String groupName;
  final List<AssetEntity> mediaList;
  final int initIndex;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  late final bool isSelectMulti;
  final GalleryController galleryController;
  ImageDetail(
      {required this.mediaList,
      required this.initIndex,
      required this.galleryController,
      this.primaryColor = Colors.blue,
      this.groupName = '',
      required this.imagesChoice,
      this.isSelectMulti = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(groupName),
        actions: [
          (isSelectMulti)
              ? Obx(() {
                  if (galleryController.mediaChoiceList.length > 0)
                    return Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          color: Colors.transparent),
                      child: Center(
                        child: Text(
                          '${galleryController.mediaChoiceList.length}',
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
                    onTap: () => galleryController.actionImageChoiceList(
                        mediaList[galleryController.currentIndex.value]),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: (galleryController.checkImageChoice(
                              mediaList[galleryController.currentIndex.value]))
                          ? Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
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
                                      Border.all(color: Colors.white, width: 3),
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
          buildImage(galleryController),
          Positioned(
            bottom: 20,
            right: 10,
            child: (isSelectMulti)
                ? Obx(() {
                    if (galleryController.mediaChoiceList.length > 0)
                      return GestureDetector(
                        onTap: () {
                          imagesChoice(galleryController.mediaChoiceList);
                          galleryController.mediaChoiceList.clear();
                          Get.back(result: true);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: primaryColor),
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
                      AssetEntity imageSelect = galleryController
                          .mediaList[galleryController.currentIndex.value];
                      imagesChoice([imageSelect]);
                      Get.back(result: true);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
                      child: Center(
                        child: Icon(
                          Icons.send_outlined,
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
          future: mediaList[index].file,
          builder: (context, AsyncSnapshot<File?> snapshot) {
            final File? file = snapshot.data;
            if (file == null) {
              return Container(
                  height: Get.height, width: Get.width, child: loadWidget(30));
            } else if (mediaList[index].type == AssetType.image)
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
      itemCount: mediaList.length,
      onPageChanged: (int index) {
        _galleryController.currentIndex.value = index;
      },
      controller: PageController(
        initialPage: initIndex,
      ),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget _image(File file) {
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
                  minScale: 1,
                  animationMinScale: 0.7,
                  maxScale: 3.0,
                  animationMaxScale: 4,
                  speed: 1.0,
                  inertialSpeed: 100.0,
                  initialScale: 1.0,
                  inPageView: true,
                  cacheGesture: true,
                  initialAlignment: InitialAlignment.center,
                );
              },
            );
          default:
            return loadWidget(30);
        }
      },
    );
  }
}
