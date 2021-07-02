part of flutter_plugin_gallery;

class Gallery extends StatefulWidget {
  final String groupName;
  final Color iconColor;
  final Color titleColor;
  final String title;
  final Color headerColor;
  final Color primaryColor;
  final bool isSelectMulti;
  final int itemInOnePage;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  final GalleryController galleryController;
  final SlidingUpPanelController panelController;
  final Widget child;
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
      this.itemInOnePage = 21});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    widget.galleryController.quality = widget.qualityImage;
    widget.galleryController.itemInOnePage = widget.itemInOnePage;
    widget.panelController.addListener(() {
      if (widget.panelController.status == SlidingUpPanelStatus.hidden)
        widget.galleryController.mediaChoiceList.clear();
      if (widget.panelController.status == SlidingUpPanelStatus.expanded)
        widget.galleryController.isRoll.value = true;
      else
        widget.galleryController.isRoll.value = false;
    });
    _scrollController.addListener(listenScrollGirdView);
    super.initState();
  }

  @override
  void dispose() {
    widget.panelController.dispose();
    _scrollController.dispose();
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
                    ? Obx(() =>
                        (widget.galleryController.mediaChoiceList.length > 0)
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.panelController.hide();
                                        widget.imagesChoice(widget
                                            .galleryController.mediaChoiceList);
                                      },
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.primaryColor),
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
                                                  color: Colors.white,
                                                  width: 3)),
                                          child: Center(
                                            child: Text(
                                              '${widget.galleryController.mediaChoiceList.length}',
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Obx(() => (!widget.galleryController.isLoading.value)
                ? (widget.galleryController.mediaList.isNotEmpty)
                    ? GridView.builder(
                        controller: _scrollController,
                        physics: (widget.galleryController.isRoll.value)
                            ? null
                            : NeverScrollableScrollPhysics(),
                        itemCount: widget.galleryController.mediaList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: _buildMediaItem)
                    : Center(
                        child: Text(
                          'Không có dữ liệu',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                : loadWidget(20)),
          ),
          panelController: widget.panelController,
          enableOnTap: true, //Enable the onTap callback for control bar.
        ),
      ],
    );
  }

  Widget _buildMediaItem(BuildContext context, int index) {
    final AssetEntity assetEntity = widget.galleryController.mediaList[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            widget.galleryController.currentIndex.value = index;
            final result = await Get.to(() => ImageDetail(
                  galleryController: widget.galleryController,
                  isSelectMulti: widget.isSelectMulti,
                  mediaList: widget.galleryController.mediaList,
                  initIndex: index,
                  primaryColor: widget.primaryColor,
                  groupName: widget.groupName,
                  imagesChoice: widget.imagesChoice,
                ));
            if (result ?? false) Get.back();
          },
          child: MediaItemGirdView(
            assetEntity: assetEntity,
            quality: widget.qualityImage,
          ),
        ),
        (widget.isSelectMulti)
            ? Positioned(
                top: 3,
                right: 3,
                child: Obx(() => GestureDetector(
                      onTap: () {
                        widget.galleryController
                            .actionImageChoiceList(assetEntity);
                      },
                      child: (widget.galleryController
                              .checkImageChoice(assetEntity))
                          ? Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.primaryColor),
                              child: Center(
                                child: Text(
                                  '${widget.galleryController.getIndexImageChoice(assetEntity)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: widget.primaryColor, width: 3.5),
                                  color: Colors.transparent),
                            ),
                    )))
            : SizedBox.shrink()
      ],
    );
  }

  void listenScrollGirdView() {
    if (!widget.galleryController.isLoadMore) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange)
      widget.galleryController.loadMoreMedia();
  }
}
