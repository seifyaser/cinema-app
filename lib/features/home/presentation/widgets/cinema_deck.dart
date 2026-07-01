import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A movie-app specific stacked card deck.
///
/// This is intentionally not a reusable deck engine. It is a focused,
/// production-quality interaction for the cinema screen:
///
/// - vertical drag only
/// - swipe up and swipe down both advance to the next movie
/// - the sign of the drag only changes the top-card exit direction
/// - visible cards are frozen during a transition
/// - the deck index is incremented only after the exit animation finishes
class CinemaDeck extends StatefulWidget {
  const CinemaDeck({
    required this.itemCount,
    required this.itemBuilder,
    this.onIndexChanged,
    this.viewportFraction = 0.82,
    this.borderRadius = 24.0,
    super.key,
  }) : assert(itemCount >= 0);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onIndexChanged;
  final double viewportFraction;
  final double borderRadius;

  @override
  State<CinemaDeck> createState() => _CinemaDeckState();
}

class _CinemaDeckState extends State<CinemaDeck>
    with SingleTickerProviderStateMixin {
  static const int _backgroundCount = 3;

  // One extra card is kept just outside the visible stack so it can move into
  // the third background slot while the front card exits.
  static const int _snapshotCount = _backgroundCount + 2;

  static const double _stackSpacing = 26.0;
  static const double _scaleStep = 0.04;
  static const double _swipeThreshold = 0.22;
  static const double _flingVelocityThreshold = 720.0;

  late final AnimationController _controller;
  final ValueNotifier<double> _dragPixels = ValueNotifier(0.0);
  late final Listenable _animationListenable;

  // Logical index is intentionally unbounded. The movie index is derived with
  // modulo, but physical card identity remains stable across wrap-around.
  int _currentLogicalIndex = 0;

  // Frozen while dragging/animating. This prevents the logical deck from being
  // rebuilt halfway through a transition.
  List<int>? _frozenLogicalIndices;

  double _cardHeight = 1.0;
  int _exitDirection = -1; // -1 = exits up, 1 = falls down
  bool _isDragging = false;
  bool _isAnimating = false;

  // Caching layer to avoid rebuilding MovieCards and static decorations
  final Map<int, Widget> _cardCache = {};
  double _lastWidth = 0.0;
  double _lastHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this);
    _animationListenable = Listenable.merge([_controller, _dragPixels]);
  }

  @override
  void didUpdateWidget(covariant CinemaDeck oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the parent rebuilds CinemaDeck (e.g., due to updated movie data, 
    // new itemBuilder, or external state change), we clear the cache to 
    // ensure the new data is rendered. 
    // Since drag and animation updates are isolated to internal ValueNotifiers,
    // they NEVER trigger didUpdateWidget, preserving our O(1) scroll performance!
    _cardCache.clear();

    if (widget.itemCount == 0) {
      _currentLogicalIndex = 0;
      _frozenLogicalIndices = null;
      return;
    }

    if (oldWidget.itemCount != widget.itemCount) {
      widget.onIndexChanged?.call(_movieIndexFor(_currentLogicalIndex));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _dragPixels.dispose();
    super.dispose();
  }

  void _clearCacheIfConstraintsChanged(double width, double height) {
    if (width != _lastWidth || height != _lastHeight) {
      _cardCache.clear();
      _lastWidth = width;
      _lastHeight = height;
    }
  }

  void _evictOldCards(List<int> visibleIndices) {
    if (_cardCache.length > _snapshotCount * 2) {
      _cardCache.removeWhere((key, _) => !visibleIndices.contains(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final cardWidth = width * widget.viewportFraction;
          final cardHeight = height * 0.85;
          _cardHeight = math.max(cardHeight, 1.0);

          _clearCacheIfConstraintsChanged(width, height);

          return AnimatedBuilder(
            animation: _animationListenable,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: _buildCards(cardWidth, cardHeight),
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildCards(double cardWidth, double cardHeight) {
    final logicalIndices = _visibleLogicalIndices();
    _evictOldCards(logicalIndices);

    final progress = _promotionProgress();
    final cards = <Widget>[];

    // Build deepest to nearest so the active card is painted last.
    for (int depth = logicalIndices.length - 1; depth >= 0; depth--) {
      final logicalIndex = logicalIndices[depth];
      
      Widget? cachedCard = _cardCache[logicalIndex];
      if (cachedCard == null) {
        final movieIndex = _movieIndexFor(logicalIndex);
        final child = widget.itemBuilder(context, movieIndex);
        
        cachedCard = RepaintBoundary(
          key: ValueKey<int>(logicalIndex),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x73000000),
                  blurRadius: 28.0,
                  spreadRadius: -8.0,
                  offset: Offset(0.0, 22.0),
                ),
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 48.0,
                  spreadRadius: -18.0,
                  offset: Offset(0.0, 44.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: SizedBox(width: cardWidth, height: cardHeight, child: child),
            ),
          ),
        );
        _cardCache[logicalIndex] = cachedCard;
      }

      cards.add(
        Transform(
          transform: _matrixFor(depth, progress, cardHeight),
          alignment: Alignment.center,
          child: Opacity(
            opacity: _opacityFor(depth, progress),
            child: cachedCard,
          ),
        ),
      );
    }

    return cards;
  }

  Matrix4 _matrixFor(int depth, double progress, double cardHeight) {
    if (depth == 0) {
      return _frontCardMatrix(progress, cardHeight);
    }

    // Every background card moves one slot toward the front as progress moves
    // from 0 -> 1. Depth 1 therefore lands exactly at top-card geometry.
    final visualDepth = math.max(0.0, depth - progress);
    final scale = 1.0 - (_scaleStep * visualDepth);
    final translateY = -_stackSpacing * visualDepth;

    return Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..translate(0.0, translateY, 0.0)
      ..scale(scale, scale, 1.0);
  }

  Matrix4 _frontCardMatrix(double progress, double cardHeight) {
    final signedDragProgress = _dragPixels.value / math.max(cardHeight, 1.0);
    final activeDirection = _isDragging
        ? (signedDragProgress < 0.0 ? -1 : 1)
        : _exitDirection;

    final signedProgress = activeDirection * progress;
    final downwardFall = activeDirection > 0 ? progress * progress * 72.0 : 0.0;
    final translateY = signedProgress * cardHeight * 1.12 + downwardFall;
    final rotation = activeDirection > 0 ? 0.10 * progress : -0.055 * progress;
    final scale = activeDirection > 0 ? 1.0 - (0.018 * progress) : 1.0;

    return Matrix4.identity()
      ..setEntry(3, 2, 0.0014)
      ..translate(0.0, translateY + cardHeight * 0.48, 0.0)
      ..rotateZ(rotation)
      ..translate(0.0, -cardHeight * 0.48, 0.0)
      ..scale(scale, scale, 1.0);
  }

  double _opacityFor(int depth, double progress) {
    if (depth <= _backgroundCount) {
      return 1.0;
    }

    // The entering card starts hidden and becomes the third background card as
    // the old top card leaves.
    return progress.clamp(0.0, 1.0);
  }

  double _promotionProgress() {
    if (_isAnimating) {
      return _controller.value.clamp(0.0, 1.0);
    }

    if (_isDragging) {
      return (_dragPixels.value / math.max(_cardHeight, 1.0)).abs().clamp(0.0, 1.0);
    }

    return 0.0;
  }

  List<int> _visibleLogicalIndices() {
    return _frozenLogicalIndices ?? _createSnapshot();
  }

  List<int> _createSnapshot() {
    return List<int>.generate(
      _snapshotCount,
      (depth) => _currentLogicalIndex + depth,
      growable: false,
    );
  }

  void _freezeVisibleCards() {
    _frozenLogicalIndices ??= _createSnapshot();
  }

  int _movieIndexFor(int logicalIndex) {
    final count = widget.itemCount;
    if (count == 0) return 0;
    final remainder = logicalIndex % count;
    return remainder < 0 ? remainder + count : remainder;
  }

  void _handleDragStart(DragStartDetails details) {
    if (_isAnimating || widget.itemCount == 0) return;

    _controller.stop();
    _controller.value = 0.0;
    _freezeVisibleCards();

    setState(() {
      _isDragging = true;
      _dragPixels.value = 0.0;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging || _isAnimating) return;

    // Directly updating the ValueNotifier avoids a full widget tree rebuild
    // via setState, keeping the animation ultra-smooth.
    _dragPixels.value += details.primaryDelta ?? 0.0;
    _exitDirection = _dragPixels.value < 0.0 ? -1 : 1;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_isDragging || _isAnimating) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final dragFraction = (_dragPixels.value / math.max(_cardHeight, 1.0)).abs();
    final shouldAdvance =
        dragFraction > _swipeThreshold ||
        velocity.abs() > _flingVelocityThreshold;

    _exitDirection = _resolveExitDirection(velocity);
    setState(() {
      _isDragging = false;
    });

    if (shouldAdvance) {
      unawaited(_animateToNext(velocity));
    } else {
      unawaited(_animateBack(velocity));
    }
  }

  int _resolveExitDirection(double velocity) {
    if (velocity.abs() > 80.0) {
      return velocity < 0.0 ? -1 : 1;
    }

    if (_dragPixels.value.abs() > 1.0) {
      return _dragPixels.value < 0.0 ? -1 : 1;
    }

    return -1;
  }

  Future<void> _animateToNext(double velocity) async {
    _freezeVisibleCards();

    final start = (_dragPixels.value / math.max(_cardHeight, 1.0)).abs().clamp(
      0.0,
      1.0,
    );
    final velocityInProgress = math.max(
      1.4,
      velocity.abs() / math.max(_cardHeight, 1.0),
    );

    setState(() {
      _isAnimating = true;
      _controller.value = start;
    });

    try {
      await _controller.animateWith(
        SpringSimulation(
          const SpringDescription(mass: 1.0, stiffness: 420.0, damping: 38.0),
          start,
          1.0,
          velocityInProgress,
          tolerance: const Tolerance(distance: 0.001, velocity: 0.001),
        ),
      );
    } on TickerCanceled {
      return;
    }

    if (!mounted) return;

    setState(() {
      _currentLogicalIndex += 1;
      _dragPixels.value = 0.0;
      _controller.value = 0.0;
      _frozenLogicalIndices = null;
      _isAnimating = false;
    });

    widget.onIndexChanged?.call(_movieIndexFor(_currentLogicalIndex));
  }

  Future<void> _animateBack(double velocity) async {
    final start = (_dragPixels.value / math.max(_cardHeight, 1.0)).abs().clamp(
      0.0,
      1.0,
    );
    final velocityInProgress = -velocity.abs() / math.max(_cardHeight, 1.0);

    setState(() {
      _isAnimating = true;
      _controller.value = start;
    });

    try {
      await _controller.animateWith(
        SpringSimulation(
          const SpringDescription(mass: 1.0, stiffness: 520.0, damping: 42.0),
          start,
          0.0,
          velocityInProgress,
          tolerance: const Tolerance(distance: 0.001, velocity: 0.001),
        ),
      );
    } on TickerCanceled {
      return;
    }

    if (!mounted) return;

    setState(() {
      _dragPixels.value = 0.0;
      _controller.value = 0.0;
      _frozenLogicalIndices = null;
      _isAnimating = false;
    });
  }
}

