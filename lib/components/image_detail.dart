part of flutter_plugin_gallery;

class ImageDetail extends StatelessWidget {
  final String groupName;
  final List<ImageModel> imageList;
  final int initIndex;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  final bool isSelectMulti;
  ImageDetail(
      {this.imageList,
      this.initIndex,
      this.groupName,
      this.imagesChoice,
      this.isSelectMulti});

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
                            .assetEntity),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: (_galleryController.checkImageChoice(
                              imageList[_galleryController.currentIndex.value]
                                  .assetEntity))
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
          PageView(
            controller: PageController(initialPage: initIndex),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              _galleryController.currentIndex.value = index;
            },
            children: buildImage(),
          ),
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
                              shape: BoxShape.circle, color: Colors.blue),
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
                          .assetEntity;
                      imagesChoice([imageSelect]);
                      Get.back(result: true);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
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

  List<Widget> buildImage() {
    List<Widget> widgets = <Widget>[];
    imageList.forEach((element) {
      widgets.add(FutureBuilder<File>(
        future: element.assetEntity.file,
        builder: (_, snapshot) {
          if (snapshot.data == null) {
            return Container(
                height: Get.height, width: Get.width, child: loadWidget(30));
          } else if (element.assetEntity.type == AssetType.image)
            return Container(
              height: Get.height,
              width: Get.width,
              child: PhotoView(
                  loadingBuilder: (context, event) => loadWidget(30),
                  imageProvider: FileImage(
                    snapshot.data,
                  )),
            );
          else {
            return Container(
                height: Get.height,
                width: Get.width,
                child: VideoDetail(
                  looping: false,
                  autoPlay: true,
                  file: snapshot.data,
                ));
          }
        },
      ));
    });
    return widgets;
  }
}
