import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constant/colors.dart';
import 'base_class.dart';

class FullScreenImageZoom extends StatefulWidget {
  final String imageUrl;
  final List<String>? images;
  // List<String>? captions = [];
  int selectedIndex;

  FullScreenImageZoom(this.imageUrl, this.images, this.selectedIndex, {Key? key}) : super(key: key);

  @override
  _FullScreenImageZoom createState() => _FullScreenImageZoom();
}

class _FullScreenImageZoom extends BaseState<FullScreenImageZoom> {
  String imageUrl = "";
  // List<String>? images = [];
  // List<String>? captions = [];
  int selectedIndex = 0;
  bool isLoading = false;
  late PageController controller;
  List<String>? images = [];

  @override
  void initState() {
    imageUrl = (widget as FullScreenImageZoom).imageUrl;
    images = (widget as FullScreenImageZoom).images;
    // captions = (widget as FullScreenImageZoom).captions;
    selectedIndex = (widget as FullScreenImageZoom).selectedIndex;
    controller = PageController(initialPage: selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(true);
        },
      child: Scaffold(
          backgroundColor: appBG,
          body: Container(
            color: white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PhotoViewGallery.builder(
                  itemCount: images!.length,
                  pageController: controller,
                  onPageChanged: (int index) {
                    selectedIndex = index;
                  },
                  loadingBuilder: (context, event) => Image.asset('assets/images/bg_gray.jpeg', fit: BoxFit.contain),
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(images![index]),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  backgroundDecoration: const BoxDecoration(color: white),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 42, right: 12),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close_rounded),
                    color: black,
                    iconSize: 32,
                  ),
                ),
                Visibility(
                  visible: images!.length > 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(18),
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: images!.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: black,
                        dotColor: Colors.grey,
                        // strokeWidth: 5,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: white,
                      elevation: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ))
    );
  }

  @override
  void castStatefulWidget() {
    widget is FullScreenImageZoom;
  }
}
