part of flutter_plugin_gallery;

Widget loadWidget(double size){
  return Center(
    child: SizedBox.fromSize(
      size: Size.square(size),
      child: (Platform.isIOS || Platform.isMacOS)
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(),
    ),
  );
}