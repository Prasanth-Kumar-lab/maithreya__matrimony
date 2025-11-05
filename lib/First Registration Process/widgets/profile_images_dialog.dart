import 'package:flutter/material.dart';
import '../../constants/constants.dart';
void showPhotoDialog({
  required BuildContext context,
  required List<String> photos,
  int initialIndex = 0,
}) {
  int currentIndex = initialIndex;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: const EdgeInsets.all(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photos[currentIndex],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 60),
                  ),
                ),

                if (currentIndex > 0)
                  Positioned(
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: AppColors.listPhotosActionButtonsColors,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(Icons.arrow_left, size: 28, color: AppColors.iconColor),
                        highlightColor: AppColors.listPhotosHighlightColor,
                        hoverColor: AppColors.listPhotoshoverColor,
                        onPressed: () {
                          setState(() {
                            currentIndex = (currentIndex - 1).clamp(0, photos.length - 1);
                          });
                        },
                      ),
                    ),
                  ),

                if (currentIndex < photos.length - 1)
                  Positioned(
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: AppColors.listPhotosActionButtonsColors,
                      radius: 24,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right, size: 28, color: AppColors.iconColor),
                        highlightColor: AppColors.listPhotosHighlightColor,
                        hoverColor: AppColors.listPhotoshoverColor,
                        onPressed: () {
                          setState(() {
                            currentIndex = (currentIndex + 1).clamp(0, photos.length - 1);
                          });
                        },
                      ),
                    ),
                  ),

                /*Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: AppColors.listPhotosActionButtonsColors,
                    radius: 20,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.close, size: 20, color: AppColors.iconColor),
                      highlightColor: AppColors.listPhotosHighlightColor,
                      hoverColor: AppColors.listPhotoshoverColor,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),*/
              ],
            ),
          );
        },
      );
    },
  );
}
