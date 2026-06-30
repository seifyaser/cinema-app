import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTopTabs extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const AnimatedTopTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  State<AnimatedTopTabs> createState() => _AnimatedTopTabsState();
}

class _AnimatedTopTabsState extends State<AnimatedTopTabs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    // 0.0 = Left Tab, 1.0 = Right Tab
    if (widget.selectedIndex == 1) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedTopTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      if (widget.selectedIndex == 1) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double highlightWidth = 250.0; // Fixed width for the highlight widget

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: 60, // The original SVG height
          // ONE AnimatedBuilder driving the entire layer
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Stack(
                children: [
                  // 1. BASE LAYER: Static unselected texts perfectly aligned with the highlight positions
                  _buildStaticText(
                    widget.tabs[0],
                    true,
                    highlightWidth,
                    _animation.value,
                  ),
                  _buildStaticText(
                    widget.tabs[1],
                    false,
                    highlightWidth,
                    _animation.value,
                  ),

                  // 2. HIGHLIGHT LAYER: Moving components (Shape + Text) that clip together
                  _buildTabComponent(
                    text: widget.tabs[0],
                    isLeft: true,
                    animationValue: _animation.value,
                    highlightWidth: highlightWidth,
                  ),
                  _buildTabComponent(
                    text: widget.tabs[1],
                    isLeft: false,
                    animationValue: _animation.value,
                    highlightWidth: highlightWidth,
                  ),

                  // 3. TRANSPARENT HIT AREAS
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => widget.onChanged(0),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => widget.onChanged(1),
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
      },
    );
  }

  Widget _buildStaticText(
    String text,
    bool isLeft,
    double highlightWidth,
    double animationValue,
  ) {
    const double slideDistance = 30.0;

    // Unselected tabs move AWAY from the center to create space.
    // Left tab moves to -30 when unselected (value -> 1).
    // Right tab moves to +30 when unselected (value -> 0).
    double slideOffset = isLeft
        ? -slideDistance * animationValue
        : slideDistance * (1.0 - animationValue);

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(slideOffset, 0),
        child: SizedBox(
          width: highlightWidth,
          height: 66,
          child: Center(
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
    );
  }

  Widget _buildTabComponent({
    required String text,
    required bool isLeft,
    required double animationValue,
    required double highlightWidth,
  }) {
    // Parallax slide distance creates the physical momentum of the travelling shape
    const double slideDistance = 30.0;

    // Left tab hides as value -> 1. Right tab shows as value -> 1.
    double clipFactor = isLeft ? (1.0 - animationValue) : animationValue;

    // Must perfectly match the slideOffset in _buildStaticText!
    double slideOffset = isLeft
        ? -slideDistance * animationValue
        : slideDistance * (1.0 - animationValue);

    // Wipe boundaries must remain anchored to the center of the transition
    Alignment wipeAlignment = isLeft
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Transform.translate(
        offset: Offset(slideOffset, 0),
        child: SizedBox(
          width: highlightWidth,
          height: 66,
          // Highlight + Text are one component and clip together
          child: Align(
            alignment: wipeAlignment,
            child: ClipRect(
              child: Align(
                alignment: wipeAlignment,
                widthFactor: clipFactor.clamp(0.0, 1.0),
                child: SizedBox(
                  width: highlightWidth,
                  height: 66,
                  child: Stack(
                    children: [
                      // Highlight Shape
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(highlightWidth, 66),
                          painter: isLeft
                              ? const LeftHighlightPainter()
                              : const RightHighlightPainter(),
                        ),
                      ),
                      // Text perfectly attached and centered inside the highlight
                      Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            color: Colors.white, // Selected color inside the black highlight
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

    // NOW_PLAYING_SELECTED is the exact base path but flipped horizontally
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

// The EXACT untouched user-provided path
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
