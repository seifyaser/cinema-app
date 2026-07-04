import 'package:flutter/material.dart';

class ScreenCurve extends StatelessWidget {
  final String imageUrl;

  const ScreenCurve({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 280,
      child: ClipPath(
        clipper: _ScreenClipper(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, 0, size.width, size.height);
    path.lineTo(size.width, size.height - 30);
    path.quadraticBezierTo(size.width / 2, -30, 0, size.height - 30);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
