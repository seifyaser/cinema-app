import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'package:project/core/widgets/failure_widget.dart';
import '../widgets/animated_movie_background.dart';
import '../widgets/animated_top_tabs.dart';
import '../widgets/clickedTabView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return FailureWidget(
              type: state.type,
              message: state.message,
              onRetry: () => context.read<HomeCubit>().fetchMovies(),
            );
          }

          if (state is HomeLoaded) {
            return ValueListenableBuilder<int>(
              valueListenable: _selectedIndexNotifier,
              builder: (context, selectedIndex, _) {
                final movies = selectedIndex == 1
                    ? state.nowPlayingMovies
                    : state.comingSoonMovies;

                if (movies.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies available.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                // Ensure _cinemaIndex is within bounds when switching tabs
                if (_cinemaIndex >= movies.length) {
                  _cinemaIndex = 0;
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: colorScheme.surface),
                    AnimatedMovieBackground(
                      imageUrl: movies[_cinemaIndex].imageurl,
                      animationKey: _cinemaIndex,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
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
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    ClickedTabView(
                                      movies: state.comingSoonMovies,
                                      showDate: false,
                                      onIndexChanged: (index) {
                                        if (selectedIndex == 0) {
                                          setState(() => _cinemaIndex = index);
                                        }
                                      },
                                    ),
                                    ClickedTabView(
                                      movies: state.nowPlayingMovies,
                                      showDate: true,
                                      onIndexChanged: (index) {
                                        if (selectedIndex == 1) {
                                          setState(() => _cinemaIndex = index);
                                        }
                                      },
                                    ),
                                  ],
                                ),
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
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
