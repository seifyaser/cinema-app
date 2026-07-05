import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/movie_data.dart';
import '../widgets/animated_movie_background.dart';
import '../widgets/animated_top_tabs.dart';
import '../widgets/now_playing_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  // ValueNotifier avoids rebuilding the whole screen during tab swipe.
  // Only the corner-radius Container subscribes via ValueListenableBuilder.
  final ValueNotifier<int> _selectedIndexNotifier = ValueNotifier(1);
  int _cinemaIndex = 0;

  final List<String> _tabs = const ["Coming Soon", "Now Playing"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 1,
    );

    _tabController.animation!.addListener(() {
      final newIndex = _tabController.animation!.value.round();
      if (_selectedIndexNotifier.value != newIndex) {
        _selectedIndexNotifier.value = newIndex;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final double tabWidth = screenWidth * 0.6;
    final double tabHeight = tabWidth * (80.0 / 336.0);
    final double overlap = 5.0;
    final double containerTopOffset = tabHeight - overlap;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: colorScheme.surface),

          AnimatedMovieBackground(
            imageUrl: MovieData.mockMovies[_cinemaIndex].imageurl,
            animationKey: _cinemaIndex,
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // ValueListenableBuilder rebuilds ONLY this Container on tab
                  // swipe — AnimatedMovieBackground is fully unaffected.
                  ValueListenableBuilder<int>(
                    valueListenable: _selectedIndexNotifier,
                    builder: (context, selectedIndex, child) {
                      return Positioned(
                        top: containerTopOffset,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: selectedIndex == 1
                                  ? const Radius.circular(40)
                                  : Radius.zero,
                              topRight: selectedIndex == 0
                                  ? const Radius.circular(40)
                                  : Radius.zero,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPlaceholderContent("Coming Soon"),
                        NowPlayingView(
                          onIndexChanged: (index) {
                            setState(() => _cinemaIndex = index);
                          },
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedTopTabs(
                      tabs: _tabs,
                      controller: _tabController,
                      tabWidth: tabWidth,
                      tabHeight: tabHeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontFamily: GoogleFonts.sora().fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
