import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:hris/src/helper/style.dart";
import "package:hris/src/widgets/cached_network_image.dart";

class ViewFullScreenImage extends StatelessWidget {
  final String? imageUrl;
  
  const ViewFullScreenImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    //Transformation Controller of Interactive Viewer
    final transformationController = TransformationController();
    late TapDownDetails doubleTapDetails;

    void handleDoubleTapDown(TapDownDetails details) {
      doubleTapDetails = details;
    }

    void handleDoubleTap() {
      if (transformationController.value != Matrix4.identity()) {
        transformationController.value = Matrix4.identity();
      } else {
        final position = doubleTapDetails.localPosition;
        // For a 3x zoom
        transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
        // Fox a 2x zoom
        // ..translate(-position.dx, -position.dy)
        // ..scale(2.0);
      }
    }

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: black,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right : 8.0.w),
            child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              icon: Icon(Icons.clear, size: 20.sp,)
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: InteractiveViewer(
            transformationController: transformationController,//Required to transform image i.e zoom in and out
            child: GestureDetector(
              onDoubleTapDown: handleDoubleTapDown,//Required to zoom out
              onDoubleTap: handleDoubleTap,//Required to zoom out
              child: Hero(
                tag: imageUrl!,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  placeholder: (context, url) => const CustomShimmer(),
                  imageUrl: imageUrl.toString(),                
                  errorWidget: (context, url,_) => placeHolder(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  placeHolder() {
    return Image.asset(
      'assets/images/noProfileImg.jpg',
      // width: widget.width,
      // height: widget.height,
      fit: BoxFit.contain,
    );
  }
}