import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTopTabs extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;
  final double tabWidth;
  final double tabHeight;

  const AnimatedTopTabs({
    super.key,
    required this.tabs,
    required this.controller,
    required this.tabWidth,
    required this.tabHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: tabHeight,
      // ONE AnimatedBuilder driving the entire layer, perfectly synced with the TabBarView!
      child: AnimatedBuilder(
        animation: controller.animation!,
        builder: (context, child) {
          final animationValue = controller.animation!.value.clamp(0.0, 1.0);
          
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. BASE LAYER: Static unselected texts
              _buildStaticText(tabs[0], true, animationValue),
              _buildStaticText(tabs[1], false, animationValue),

              // 2. HIGHLIGHT LAYER: Moving components (Shape + Text)
              _buildTabComponent(
                text: tabs[0],
                isLeft: true,
                animationValue: animationValue,
              ),
              _buildTabComponent(
                text: tabs[1],
                isLeft: false,
                animationValue: animationValue,
              ),

              // 3. TRANSPARENT HIT AREAS
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.animateTo(0),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.animateTo(1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStaticText(String text, bool isLeft, double animationValue) {
    final double slideDistance = tabWidth * 0.1; // Responsive slide distance

    double slideOffset = isLeft
        ? -slideDistance * animationValue
        : slideDistance * (1.0 - animationValue);

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(slideOffset, 0),
        child: SizedBox(
          width: tabWidth,
          height: tabHeight,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: GoogleFonts.manrope().fontFamily,
                    color: Colors.grey, // Static unselected color (inactive)
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabComponent({
    required String text,
    required bool isLeft,
    required double animationValue,
  }) {
    final double slideDistance = tabWidth * 0.1; // Matches static text slide
    double clipFactor = isLeft ? (1.0 - animationValue) : animationValue;

    double slideOffset = isLeft
        ? -slideDistance * animationValue
        : slideDistance * (1.0 - animationValue);

    Alignment wipeAlignment = isLeft
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(slideOffset, 0),
        child: SizedBox(
          width: tabWidth,
          height: tabHeight,
          // Highlight + Text clip together perfectly
          child: Align(
            alignment: wipeAlignment,
            child: ClipRect(
              child: Align(
                alignment: wipeAlignment,
                widthFactor: clipFactor.clamp(0.0, 1.0),
                child: SizedBox(
                  width: tabWidth,
                  height: tabHeight,
                  child: Stack(
                    children: [
                      // Highlight Shape
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(tabWidth, tabHeight),
                          painter: isLeft
                              ? const LeftHighlightPainter()
                              : const RightHighlightPainter(),
                        ),
                      ),
                      // Text perfectly attached and centered inside the highlight
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              text,
                              style: TextStyle(
                                fontFamily: GoogleFonts.manrope().fontFamily,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeftHighlightPainter extends CustomPainter {
  const LeftHighlightPainter();

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / 336.0;
    double scaleY = size.height / 66.0;
    canvas.scale(scaleX, scaleY);

    canvas.translate(336.0, 0.0);
    canvas.scale(-1.0, 1.0);

    Path path = _getBasePath();

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawPath(path, paintFill);

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RightHighlightPainter extends CustomPainter {
  const RightHighlightPainter();

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / 336.0;
    double scaleY = size.height / 66.0;
    canvas.scale(scaleX, scaleY);

    Path path = _getBasePath();

    Paint paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawPath(path, paintFill);

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;
    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Path _getBasePath() {
  Path path_0 = Path();
  path_0.moveTo(327.582, 15);
  path_0.lineTo(330.582, 19.5);
  path_0.lineTo(335.082, 25);
  path_0.lineTo(335.082, 65);
  path_0.lineTo(0.0821991, 65);
  path_0.lineTo(3.0822, 64.5);
  path_0.lineTo(6.5822, 62.5);
  path_0.lineTo(12.5822, 59);
  path_0.lineTo(18.0822, 54.5);
  path_0.lineTo(21.5822, 50);
  path_0.lineTo(24.5822, 45.5);
  path_0.lineTo(27.5822, 41);
  path_0.lineTo(30.0822, 37);
  path_0.lineTo(32.0822, 33);
  path_0.lineTo(36.5822, 25);
  path_0.lineTo(39.5822, 21);
  path_0.lineTo(42.5822, 16.5);
  path_0.lineTo(44.5822, 13.5);
  path_0.lineTo(47.0822, 10.5);
  path_0.lineTo(53.0822, 5.5);
  path_0.lineTo(56.5822, 3.5);
  path_0.lineTo(62.5822, 0.5);
  path_0.lineTo(66.5822, 0.5);
  path_0.lineTo(94.0822, 0.5);
  path_0.lineTo(131.582, 0.5);
  path_0.lineTo(163.582, 0.5);
  path_0.lineTo(195.082, 0.5);
  path_0.lineTo(249.582, 0.5);
  path_0.lineTo(263.082, 0.5);
  path_0.lineTo(277.582, 0.5);
  path_0.lineTo(292.082, 0.5);
  path_0.lineTo(302.582, 0.5);
  path_0.lineTo(308.582, 2.5);
  path_0.lineTo(313.582, 4.5);
  path_0.lineTo(319.582, 7.5);
  path_0.lineTo(324.082, 11.5);
  path_0.lineTo(327.582, 15);
  path_0.close();
  return path_0;
}
