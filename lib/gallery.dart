part of flutter_plugin_gallery;

class Gallery extends StatefulWidget {
  final String groupName;
  final Color iconColor;
  final Color titleColor;
  final String title;
  final bool hasCaption;
  final Color headerColor;
  final Color primaryColor;
  final bool isSelectMulti;
  final int itemInOnePage;
  final int totalImageSelect;
  final int totalVideoSelect;
  final int maxSizeFileMB;
  final ValueChanged<MediaDataModel> imagesChoice;
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
      this.totalImageSelect = 20,
      this.totalVideoSelect = 5,
      this.maxSizeFileMB = 100,
      this.iconColor = Colors.blue,
      this.titleColor = Colors.black,
      this.headerColor = Colors.white,
      this.primaryColor = Colors.blue,
      this.isSelectMulti = true,
      this.hasCaption = false,
      required this.imagesChoice,
      required this.panelController,
      this.itemInOnePage = 21});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  ScrollController _scrollController = ScrollController();

  final TextEditingController _textEditingControllerCaption =
      TextEditingController();

  @override
  void initState() {
    widget.galleryController.quality = widget.qualityImage;
    widget.galleryController.itemInOnePage = widget.itemInOnePage;

    widget.galleryController.totalImageSelect = widget.totalImageSelect;
    widget.galleryController.totalVideoSelect = widget.totalVideoSelect;
    widget.galleryController.maxFileSize = widget.maxSizeFileMB;

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
    _textEditingControllerCaption.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Column(
          children: [
            Expanded(
              child: SlideUpPanelWidget(
                header: Container(
                  decoration: BoxDecoration(
                    color: widget.headerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  height: 55,
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              (widget.galleryController.mediaChoiceList.length >
                                      0)
                                  ? Row(
                                      children: [
                                        Text(
                                            '${widget.galleryController.mediaChoiceList.length}/${widget.galleryController.totalTemp}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black)),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink())
                          : SizedBox.shrink(),
                      Spacer(),
                      Obx(() =>
                          (widget.galleryController.mediaChoiceList.length > 0)
                              ? GestureDetector(
                                  onTap: () {
                                    widget.imagesChoice(MediaDataModel(
                                        listMedia: widget.galleryController
                                            .mediaChoiceList));
                                    widget.panelController.hide();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.primaryColor),
                                    child: Center(
                                      child: Icon(
                                        Icons.send_outlined,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()),
                      const SizedBox(
                        width: 10,
                      )
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
                              itemCount:
                                  widget.galleryController.mediaList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: _buildMediaItem)
                          : Text(
                              'Không có dữ liệu',
                              style: TextStyle(color: Colors.blue),
                            )
                      : loadWidget(20)),
                ),
                panelController: widget.panelController,
                enableOnTap: true, //Enable the onTap callback for control bar.
              ),
            ),
            if (widget.hasCaption)
              Obx(() {
                if (widget.galleryController.mediaChoiceList.isNotEmpty)
                  return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _textEditingControllerCaption,
                            maxLines: null,
                            style: TextStyle(fontSize: 18),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                hintText: 'Nhập ghi chú...',
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 0, 8, 0),
                                border: InputBorder.none),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: GestureDetector(
                            onTap: () {
                              widget.imagesChoice(MediaDataModel(
                                  listMedia:
                                      widget.galleryController.mediaChoiceList,
                                  caption: _textEditingControllerCaption.text));
                              _textEditingControllerCaption.clear();
                              widget.panelController.hide();
                            },
                            child: Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.primaryColor),
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
                return const SizedBox.shrink();
              })
          ],
        )
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
                  hasCaption: widget.hasCaption,
                  textEditingControllerCaption: _textEditingControllerCaption,
                ));
            if (result != null) {
              widget.imagesChoice(MediaDataModel(
                  listMedia: result,
                  caption: _textEditingControllerCaption.text));
              widget.panelController.hide();
              _textEditingControllerCaption.clear();
            }
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
