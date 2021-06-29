part of flutter_plugin_gallery;

enum GalleryType {image, video, videoAndImage}

class GalleryController extends GetxController {
  List<AssetPathEntity> listFolder = <AssetPathEntity>[];
  RxList<AssetEntity> mediaChoiceList = <AssetEntity>[].obs;
  RxList<AssetEntity> mediaList = <AssetEntity>[].obs;

  int quality = 30;
  int currentIndex = 0;

  RxBool isRoll = false.obs;
  RxBool isLoading = true.obs;
  bool isLoadMore = true;

  int page = 0;
  int itemInOnePage = 21;

  late GalleryType galleryType;

  Future<void> getMedia({required GalleryType galleryType}) async {
    this.galleryType = galleryType;
    page = 0;
    isLoadMore = true;
    isLoading(true);
    var result = await PhotoManager.requestPermission();
    if (result) {
      switch(galleryType){
        case GalleryType.image:
          listFolder = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            hasAll: true,
            onlyAll: true,
          );
          break;
        case GalleryType.video:
          listFolder = await PhotoManager.getAssetPathList(
            type: RequestType.video,
            hasAll: true,
            onlyAll: true,
          );
          break;
        case GalleryType.videoAndImage:
          listFolder = await PhotoManager.getAssetPathList(
            type: RequestType.common,
            hasAll: true,
            onlyAll: true,
          );
          break;
        default:
          isLoadMore = false;
          isLoading(false);
          return;
      }
    }
    else {
      isLoadMore = false;
      isLoading(false);
      return;
    }

    mediaList.value = await listFolder[0].getAssetListPaged(0, itemInOnePage);

    isLoading(false);
  }

  bool checkImageChoice(AssetEntity media) {
    return mediaChoiceList.contains(media);
  }

  void actionImageChoiceList(AssetEntity media) {
    if (mediaChoiceList.contains(media))
      mediaChoiceList.remove(media);
    else
      mediaChoiceList.add(media);
  }

  int getIndexImageChoice(AssetEntity image) {
    return mediaChoiceList.indexOf(image) + 1;
  }

  Future<void> loadMoreMedia() async {
    page++;
    late List<AssetEntity> images;
      images = await listFolder[0].getAssetListPaged(page, itemInOnePage);
    if(images.isNotEmpty)
      mediaList.addAll(images);
    else isLoadMore = false;
  }


  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
