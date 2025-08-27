import 'package:flutter/material.dart';
import 'drawer/InternshipCreationPage.dart';
import 'drawer/JobCreationPage.dart';

Future<void> handlePlusIconClick({
  required BuildContext context,
  required GlobalKey iconKey, // For icon position reference
  double topPadding = 0.0,
  double rightPadding = 0.0,
  double leftPadding = 0.0,
  double dialogWidth = 200,
  double dialogHeight = 100,
}) async {
  final RenderBox iconBox = iconKey.currentContext?.findRenderObject() as RenderBox;
  final Offset iconOffset = iconBox.localToGlobal(Offset.zero);

  // Calculate top and left relative to screen and padding
  final double menuTop = iconOffset.dy + iconBox.size.height + topPadding;
  final double screenWidth = MediaQuery.of(context).size.width;

  // Calculate left or right to position dialog; use either leftPadding or rightPadding for customization
  // Priority to use leftPadding if provided else calculate right
  double? menuLeft;
  double? menuRight;
  if (leftPadding > 0) {
    menuLeft = leftPadding;
  } else {
    menuRight = screenWidth - iconOffset.dx - iconBox.size.width + rightPadding;
  }

  String? selected = await showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (dialogContext) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(dialogContext).pop(),
        child: Stack(
          children: [
            Positioned(
              top: menuTop,
              left: menuLeft,
              right: menuRight,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: dialogWidth,
                  height: dialogHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(dialogContext).pop('job'),
                        child: Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('For Job', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.of(dialogContext).pop('internship'),
                        child: Container(
                          height: 40,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('For Internship', style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  if (selected == 'job') {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => JobCreationPage()),
    );
  } else if (selected == 'internship') {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => InternshipCreationPage()),
    );
  }
}
