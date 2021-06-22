part of flutter_plugin_gallery;

class Gallery extends StatefulWidget {
  final String groupName;
  final Color iconColor;
  final Color titleColor;
  final String title;
  final Color headerColor;
  final Color primaryColor;
  final bool isSelectMulti;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  final GalleryController galleryController;
  final SlidingUpPanelController panelController;
  final Widget child;
  final bool isVideo;
  final int qualityImage;

  Gallery(
      {required this.child,
      required this.galleryController,
      this.qualityImage = 30,
      this.groupName = '',
      this.title = 'Thư viện',
      this.iconColor = Colors.blue,
      this.titleColor = Colors.black,
      this.headerColor = Colors.white,
      this.primaryColor = Colors.blue,
      this.isSelectMulti = true,
      required this.imagesChoice,
      required this.panelController,
      this.isVideo = false});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  @override
  void initState() {
    
    widget.galleryController.isVideo = widget.isVideo;
    widget.galleryController.quality = widget.qualityImage;
    widget.panelController.addListener(() {
      if (widget.panelController.status == SlidingUpPanelStatus.hidden)
        widget.galleryController.imageChoiceList.clear();
      if (widget.panelController.status == SlidingUpPanelStatus.expanded)
        widget.galleryController.isRoll.value = true;
      else
        widget.galleryController.isRoll.value = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.galleryController.isVideo = widget.isVideo;
    return Stack(
      children: [
        widget.child,
        SlideUpPanelWidget(
          header: Container(
            decoration: BoxDecoration(
              color: widget.headerColor,
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
                      color: widget.iconColor,
                    ),
                  ),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.titleColor),
                ),
                Spacer(),
                (widget.isSelectMulti)
                    ? Obx(() => (widget.galleryController.imageChoiceList.length > 0)
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    widget.imagesChoice(
                                        widget.galleryController.imageChoiceList);
                                    widget.panelController.hide();
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            widget.primaryColor),
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
                                          color: widget.primaryColor,
                                          border: Border.all(
                                              color: Colors.white, width: 3)),
                                      child: Center(
                                        child: Text(
                                          '${widget.galleryController.imageChoiceList.length}',
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
            child: Obx(() => (widget.galleryController.isLoading.value)
                ? GridView.builder(
                    // controller: scrollController,
                    physics: (widget.galleryController.isRoll.value)
                        ? null
                        : NeverScrollableScrollPhysics(),
                    itemCount: widget.galleryController.imageList.length,
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
    if (widget.galleryController.imageList.length - 9 == index)
      widget.galleryController.loadMoreItem();

    final ImageModel imageModel = widget.galleryController.imageList[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            widget.galleryController.currentIndex.value = index;
            var result = await Get.to(() => ImageDetail(
              galleryController: widget.galleryController,
                  isSelectMulti: widget.isSelectMulti,
                  imageList: widget.galleryController.imageList,
                  initIndex: index,
                  primaryColor: widget.primaryColor,
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
                        widget.galleryController
                            .actionImageChoiceList(imageModel.assetEntity!);
                      },
                      child: (widget.galleryController
                              .checkImageChoice(imageModel.assetEntity!))
                          ? Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.primaryColor),
                              child: Center(
                                child: Text(
                                  '${widget.galleryController.getIndexImageChoice(imageModel.assetEntity!)}',
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
                                      Border.all(color: widget.primaryColor, width: 3),
                                  color: Colors.transparent),
                            ),
                    )))
            : SizedBox.shrink()
      ],
    );
  }
}
