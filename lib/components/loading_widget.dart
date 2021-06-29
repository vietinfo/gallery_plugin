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

Widget noImage(){
  return Image.asset('assets/noimg.png', fit: BoxFit.cover, package: 'flutter_plugin_gallery',);
}