import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenuPressed;
  final VoidCallback? onVipPressed;
  final VoidCallback? onPlusPressed;
  final String title;
  final Key? plusIconKey;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.onMenuPressed,
    this.onVipPressed,
    this.onPlusPressed,
    this.plusIconKey,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo,
      title: Text(title, style: GoogleFonts.playfairDisplay(fontSize: 20, color: Colors.white)),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Row(
          children: [
            IconButton(
              key: plusIconKey,
              icon: Icon(Icons.add, color: Colors.white,size: 30,),
              onPressed: onPlusPressed,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              visualDensity: VisualDensity.compact,
            ),
            // SizedBox(width: 2),
            Container(
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber, width: 1),
              ),
              child: TextButton(
                onPressed: onVipPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 2),
                    GestureDetector(
                      onTap: onVipPressed,
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          'GoVIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
