import 'package:flutter/material.dart';

class StallMenuImages extends StatefulWidget {
  final List<dynamic> menuImages;

  StallMenuImages({super.key, required this.menuImages});

  @override
  State<StallMenuImages> createState() => _StallMenuImagesState();
}

class _StallMenuImagesState extends State<StallMenuImages> {
  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {},
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: widget.menuImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showImageDialog(widget.menuImages[index]),
          child: ClipRRect(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10),
              right: Radius.circular(10),
            ),
            child: Image.network(
              widget.menuImages[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}
