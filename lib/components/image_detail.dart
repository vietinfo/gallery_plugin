part of flutter_plugin_gallery;

class ImageDetail extends StatelessWidget {
  final Color primaryColor;
  final String groupName;
  final List<AssetEntity> mediaList;
  final int initIndex;
  final bool hasCaption;
  late final bool isSelectMulti;
  final GalleryController galleryController;
  final TextEditingController textEditingControllerCaption;
  ImageDetail(
      {required this.mediaList,
      required this.initIndex,
      required this.hasCaption,
        required this.textEditingControllerCaption,
      required this.galleryController,
      this.primaryColor = Colors.blue,
      this.groupName = '',
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
                                  color: primaryColor),
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
      body: hasCaption
          ? Stack(
              children: [
               buildImage(galleryController),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    if (galleryController.mediaChoiceList.length > 0)
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          // borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: null,
                                controller: textEditingControllerCaption,
                                style: TextStyle(fontSize: 18, color: Colors.white),
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    hintText: 'Nhập ghi chú...',
                                    hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                                    contentPadding:
                                    EdgeInsets.fromLTRB(16, 0, 8, 0),
                                    border: InputBorder.none),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back(result: galleryController.mediaChoiceList);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: primaryColor),
                                  child: Center(
                                    child: Icon(
                                      Icons.send_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    else
                      return SizedBox.shrink();
                  }),
                )
              ],
            )
          : Stack(
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
                                Get.back(
                                    result: galleryController.mediaChoiceList);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
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
                            AssetEntity imageSelect =
                                galleryController.mediaList[
                                    galleryController.currentIndex.value];
                            Get.back(result: [imageSelect]);
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
