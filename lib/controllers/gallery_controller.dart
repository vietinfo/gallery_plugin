part of flutter_plugin_gallery;

class GalleryController extends GetxController {
  List<AssetPathEntity> listFolder = <AssetPathEntity>[];

  bool isVideo = false;
  int quality = 0;

  RxList<AssetEntity> imageChoiceList = <AssetEntity>[].obs;
  RxList<ImageModel> imageList = <ImageModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isShowGallery = true.obs;
  RxInt currentIndex = 0.obs;

  RxBool isRoll = false.obs;

  ScrollController scrollController = ScrollController();
  int page = 0;
  int itemInOnePage = 21;

  Future<void> refreshGalleryList() async {
    isLoading(false);
    listFolder.clear();
    imageList.clear();

    var result = await PhotoManager.requestPermission();
    if (result)
      listFolder = await PhotoManager.getAssetPathList(
        type: isVideo ? RequestType.common : RequestType.image,
        hasAll: true,
        onlyAll: true,
      );
    else {
      return;
    }

    final images = await listFolder[0].getAssetListPaged(0, itemInOnePage);
    for (final element in images) {
      imageList.add(ImageModel(
          assetEntity: element,
          uint8list: await element.thumbDataWithOption(ThumbOption(
              width: 200,
              height: 200,
              format: ThumbFormat.jpeg,
              quality: quality))));
      if (images.length == imageList.length) {
        imageList.sort((s1, s2) => s2.assetEntity!.createDtSecond!
            .compareTo(s1.assetEntity!.createDtSecond!));
        isLoading(true);
      }
    }
  }

  bool checkImageChoice(AssetEntity image) {
    return imageChoiceList.contains(image);
  }

  void actionImageChoiceList(AssetEntity image) {
    if (imageChoiceList.contains(image))
      imageChoiceList.remove(image);
    else
      imageChoiceList.add(image);
  }

  int getIndexImageChoice(AssetEntity image) {
    return imageChoiceList.indexOf(image) + 1;
  }

  Future<void> loadMoreItem({int? sizeImage, int? qualityImage}) async {
    if (imageList.length == listFolder[0].assetCount) return;
    page++;
    final images = await listFolder[0].getAssetListPaged(page, itemInOnePage);
    for (final element in images) {
      imageList.add(ImageModel(
          assetEntity: element,
          uint8list: await element.thumbDataWithOption(ThumbOption(
              width: 200,
              height: 200,
              format: ThumbFormat.jpeg,
              quality: quality))));
    }
    imageList.sort((s1, s2) => s2.assetEntity!.createDtSecond!
        .compareTo(s1.assetEntity!.createDtSecond!));
  }

  @override
  void onInit() async {
    super.onInit();
    refreshGalleryList();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
