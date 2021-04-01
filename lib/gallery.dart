part of flutter_plugin_gallery;

class Gallery extends StatefulWidget {
  final String groupName;
  final Color iconColor;
  final Color titleColor;
  final String title;
  final Color headerColor;
  final bool isSelectMulti;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  final SlidingUpPanelController panelController;
  final Widget child;
  final bool isVideo;
  final int qualityImage;
  Gallery(
      {@required this.child,
      Key key,
      this.qualityImage,
      this.groupName,
      this.title,
      this.iconColor,
      this.titleColor,
      this.headerColor,
      this.isSelectMulti = true,
      @required this.imagesChoice,
      @required this.panelController,
      this.isVideo = false})
      : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryController _galleryController;
  // ScrollController scrollController;

  @override
  void initState() {
    _galleryController = Get.put(GalleryController(
        isVideo: widget.isVideo, quality: widget.qualityImage));
    widget.panelController.addListener(() {
      if (widget.panelController.status == SlidingUpPanelStatus.hidden)
        _galleryController.imageChoiceList.clear();
      if (widget.panelController.status == SlidingUpPanelStatus.expanded)
        _galleryController.isRoll.value = true;
      else
        _galleryController.isRoll.value = false;
    });
    // scrollController = ScrollController();
    // scrollController.addListener(() {
    //   if (scrollController.offset <=
    //       scrollController.position.minScrollExtent&&
    //       !scrollController.position.outOfRange ) {
    //     widget.panelController.hide();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    widget.panelController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        SlideUpPanelWidget(
          header: Container(
            decoration: BoxDecoration(
              color: widget.headerColor ?? Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            height: 50,
            width: Get.width,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.panelController.hide(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16),
                    child: Icon(
                      Icons.clear,
                      color: widget.iconColor ?? Colors.black,
                    ),
                  ),
                ),
                Text(
                  widget.title ?? 'Thư viện',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.titleColor ?? Colors.black),
                ),
                Spacer(),
                (widget.isSelectMulti)
                    ? Obx(() => (_galleryController.imageChoiceList.length > 0)
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.imagesChoice(
                                        _galleryController.imageChoiceList);
                                    widget.panelController.hide();
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue),
                                    child: Center(
                                      child: Icon(
                                        Icons.send_outlined,
                                        size: 22,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                          border: Border.all(
                                              color: Colors.white, width: 3)),
                                      child: Center(
                                        child: Text(
                                          '${_galleryController.imageChoiceList.length}',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          )
                        : SizedBox.shrink())
                    : SizedBox.shrink()
              ],
            ),
          ),
          body: Container(
            child: Obx(() => (_galleryController.isLoading.value)
                ? GridView.builder(
                    // controller: scrollController,
                    physics: (_galleryController.isRoll.value)
                        ? null
                        : NeverScrollableScrollPhysics(),
                    itemCount: _galleryController.imageList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: _buildImage)
                : loadWidget(20)),
            color: Colors.white,
          ),
          anchor: 0.4,
          panelController: widget.panelController,
          enableOnTap: true, //Enable the onTap callback for control bar.
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    if (_galleryController.imageList.length - 9 == index)
      _galleryController.loadMoreItem();

    final ImageModel imageModel = _galleryController.imageList[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            _galleryController.currentIndex.value = index;
            var result = await Get.to(() => ImageDetail(
                  isSelectMulti: widget.isSelectMulti,
                  imageList: _galleryController.imageList,
                  initIndex: index,
                  groupName: widget.groupName,
                  imagesChoice: widget.imagesChoice,
                ));
            if (result != null) widget.panelController.hide();
          },
          child: ImageItem(
            imageModel: imageModel,
          ),
        ),
        (widget.isSelectMulti)
            ? Positioned(
                top: 5,
                right: 5,
                child: Obx(() => GestureDetector(
                      onTap: () {
                        _galleryController
                            .actionImageChoiceList(imageModel.assetEntity);
                      },
                      child: (_galleryController
                              .checkImageChoice(imageModel.assetEntity))
                          ? Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              child: Center(
                                child: Text(
                                  '${_galleryController.getIndexImageChoice(imageModel.assetEntity)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                    )))
            : SizedBox.shrink()
      ],
    );
  }
}
