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

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
              padding: const EdgeInsets.only(top: 10.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main Content Container (bottom layer in stack)
                  Positioned(
                    top: 50.0, // Matches the height of the tab's bounding box
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
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
                      selectedIndex: _selectedIndex,
                      onChanged: _onTabChanged,
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
