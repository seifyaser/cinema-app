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
  int _selectedIndex = 0;
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
    _selectedIndex = 1;

    _tabController.animation!.addListener(() {
      int newIndex = _tabController.animation!.value.round();
      if (_selectedIndex != newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    // Calculate perfectly responsive dimensions to maintain SVG aspect ratio
    final double tabWidth = screenWidth * 0.6;
    // Making the top bar slightly taller by increasing the virtual height from 66 to 80
    final double tabHeight = tabWidth * (80.0 / 336.0);

    // Position the main container to overlap underneath the curve
    final double overlap = 5.0; // Ensures no 1px anti-aliasing cracks
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
                  // Main Content Container (bottom layer in stack)
                  Positioned(
                    top: containerTopOffset,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                          topLeft: _selectedIndex == 1
                              ? const Radius.circular(40)
                              : Radius.zero,
                          topRight: _selectedIndex == 0
                              ? const Radius.circular(40)
                              : Radius.zero,
                        ),
                      ),
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
                  ),

                  // Top Tabs (top layer in stack) - draws *over* the container
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
