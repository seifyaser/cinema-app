import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/widgets/failure_widget.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/widgets/animated_movie_background.dart';
import 'package:project/features/home/presentation/widgets/cinema_deck.dart';

import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/search_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  MovieEntity? _selectedMovie;
  int _selectedIndex = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {}); // Trigger rebuild for animation
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        context.read<SearchCubit>().searchMovies(query);
      }
    });
  }

  bool get _isSearching => _searchController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      // Set resizeToAvoidBottomInset to false so keyboard doesn't squish the deck
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is SearchLoaded && state.movies.isNotEmpty) {
            setState(() {
              _selectedMovie = state.movies.first;
              _selectedIndex = 0;
            });
          } else if (state is SearchInitial ||
              (state is SearchLoaded && state.movies.isEmpty)) {
            setState(() {
              _selectedMovie = null;
              _selectedIndex = 0;
            });
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // 1. Animated Background
              if (_selectedMovie != null)
                AnimatedMovieBackground(
                  imageUrl: _selectedMovie!.imageurl,
                  animationKey: _selectedIndex,
                )
              else
                Container(color: const Color(0xFF131313)),

              // 2. Content
              SafeArea(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      height: _isSearching ? 20 : MediaQuery.of(context).size.height * 0.45,
                    ),
                    // Search Bar
                    SearchBarWidget(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                    ),

                    // Results
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn,
                        opacity: _isSearching ? 1.0 : 0.0,
                        child: _isSearching ? _buildResults(state) : const SizedBox.shrink(),
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

  Widget _buildResults(SearchState state) {
    if (state is SearchLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFEAB308)),
      );
    } else if (state is SearchError) {
      return Center(
        child: FailureWidget(
          type: state.type,
          message: state.message,
          onRetry: () =>
              context.read<SearchCubit>().searchMovies(_searchController.text),
        ),
      );
    } else if (state is SearchLoaded) {
      if (state.movies.isEmpty) {
        return const Center(
          child: Text(
            'No movies found.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 18,
              fontFamily: 'Manrope',
            ),
          ),
        );
      }
      return CinemaDeck(
        itemCount: state.movies.length,
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
            _selectedMovie = state.movies[index];
          });
        },
        itemBuilder: (context, index) {
          final movie = state.movies[index];
          return GestureDetector(
            onTap: () {
              context.push(AppRouter.movieDetailsRoute, extra: movie);
            },
            child: SearchResultCard(movie: movie),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
