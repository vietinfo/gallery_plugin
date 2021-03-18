part of flutter_plugin_gallery;

class Gallery extends StatefulWidget {
  final String groupName;
  final ValueChanged<List<AssetEntity>> imagesChoice;
  final SlidingUpPanelController panelController;
  final Widget child;
  final bool isVideo;
  Gallery({
    @required this.child,
    Key key,
    this.groupName,
    @required this.imagesChoice,
    @required this.panelController,
    this.isVideo = false
  }) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryController _galleryController;
  ScrollController scrollController;

  @override
  void initState() {
    _galleryController = Get.put(GalleryController(isVideo: widget.isVideo));
    widget.panelController.addListener(() {
      if (widget.panelController.status == SlidingUpPanelStatus.hidden)
        _galleryController.imageChoiceList.clear();
    });
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >= Get.width/3*5) {
        widget.panelController.expand();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.panelController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        SlideUpPanelWidget(
          header: Container(
            height: 50,
            width: Get.width,
            child: Row(
              children: [
                BackButton(
                  onPressed: () => widget.panelController.hide(),
                ),
                Text(
                  'Chọn ảnh, video',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Spacer(),
                Obx(() => (_galleryController.imageChoiceList.length > 0)
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
                              shape: BoxShape.circle, color: Colors.blue),
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
              ],
            ),
          ),
          body: Container(
            child: Obx(() => (_galleryController.isLoading.value)
                ? GridView.builder(
                controller: scrollController,
                itemCount: _galleryController.listFolder[0].assetCount,
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
    if (_galleryController.imageList.length - 6 == index)
      _galleryController.loadMoreItem();

    if (index > _galleryController.imageList.length - 1) {
      return loadWidget(10);
    }

    final ImageModel imageModel = _galleryController.imageList[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () async{
            _galleryController.currentIndex.value = index;
            var result =  await Get.to(() => ImageDetail(
                  imageList: _galleryController.imageList,
                  initIndex: index,
                  groupName: widget.groupName,
                  imagesChoice: widget.imagesChoice,
                ));
            if(result != null)
              widget.panelController.hide();
          },
          child: ImageItem(
            imageModel: imageModel,
          ),
        ),
        Positioned(
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
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.transparent),
                        ),
                )))
      ],
    );
  }
}
