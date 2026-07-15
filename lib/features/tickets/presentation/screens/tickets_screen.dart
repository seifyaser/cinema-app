import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/booking/data/models/checkout_data_model.dart';
import 'package:project/features/home/presentation/widgets/animated_movie_background.dart';
import '../../domain/entities/ticket_entity.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/ticket_card.dart';
import 'package:project/core/widgets/failure_widget.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/error/failure_type.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      extendBodyBehindAppBar: true, // Lets the background bleed under the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Tickets",
          style: TextStyle(
            fontFamily: 'Sora',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF201F1F).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: const Color(0xFFEAB308),
                borderRadius: BorderRadius.circular(24),
              ),
              labelColor: const Color(0xFF131313), // dark text on gold
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(height: 36, text: "Active"),
                Tab(height: 36, text: "Past"),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEAB308)),
            );
          } else if (state is TicketError) {
            final isUnauthorized = state.type == FailureType.unauthorized;
            return FailureWidget(
              type: state.type,
              message: state.message,
              onRetry: isUnauthorized
                  ? () => context.go(AppRouter.loginRoute)
                  : () => context.read<TicketCubit>().fetchMyTickets(),
              buttonText: isUnauthorized ? "Go to Sign In" : null,
              buttonIcon: isUnauthorized ? Icons.login : null,
            );
          } else if (state is TicketLoaded) {
            final activeTickets = state.tickets
                .where((t) =>
                    t.status.toLowerCase() != 'expired' &&
                    t.status.toLowerCase() != 'cancelled')
                .toList();
            final pastTickets = state.tickets
                .where((t) =>
                    t.status.toLowerCase() == 'expired' ||
                    t.status.toLowerCase() == 'cancelled')
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildRefreshableCarousel(activeTickets, "No active tickets found."),
                _buildRefreshableCarousel(pastTickets, "No past tickets found."),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRefreshableCarousel(List<TicketEntity> tickets, String emptyMessage) {
    return RefreshIndicator(
      color: const Color(0xFFEAB308),
      backgroundColor: const Color(0xFF2A2A2A),
      onRefresh: () async {
        await context.read<TicketCubit>().fetchMyTickets();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: TicketCarouselView(
              tickets: tickets,
              emptyMessage: emptyMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketCarouselView extends StatefulWidget {
  final List<TicketEntity> tickets;
  final String emptyMessage;

  const TicketCarouselView({
    super.key,
    required this.tickets,
    required this.emptyMessage,
  });

  @override
  State<TicketCarouselView> createState() => _TicketCarouselViewState();
}

class _TicketCarouselViewState extends State<TicketCarouselView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tickets.isEmpty) {
      return Center(
        child: Text(
          widget.emptyMessage,
          style: const TextStyle(
            fontFamily: 'Manrope',
            color: Colors.white54,
            fontSize: 16,
          ),
        ),
      );
    }

    // Protect against out of bounds if the list dynamically updates
    final safeIndex = _currentIndex < widget.tickets.length ? _currentIndex : 0;
    final currentTicket = widget.tickets[safeIndex];

    return Stack(
      children: [
        // 1. Animated Blurred Movie Poster Background
        AnimatedMovieBackground(
          imageUrl: currentTicket.moviePoster,
          animationKey: safeIndex,
        ),

        // 2. Foreground Content
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 56), // Spacing below the AppBar

              // Movie Title & Subtitle
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Column(
                  key: ValueKey<String>(currentTicket.id),
                  children: [
                    Text(
                      currentTicket.movieTitle.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    if (currentTicket.movieSubtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        currentTicket.movieSubtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Carousel of Tickets
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.tickets.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ticket = widget.tickets[index];
                    final isActive = index == _currentIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: isActive ? 0 : 40,
                        bottom: isActive ? 0 : 40,
                      ),
                      child: TicketCard(
                        ticket: ticket,
                        isActive: isActive,
                        onTap: () {
                          if (!isActive) {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                            );
                          } else {
                            if (ticket.status.toLowerCase() == 'pending') {
                              // Use the user's provided logic for navigating to checkout
                              final checkoutData = CheckoutDataModel(
                                bookingId: ticket.id,
                                expiresAt: DateTime.now(), // Fallback if missing
                                movieId: ticket.movieId,
                                movieTitle: ticket.movieTitle,
                                moviePoster: ticket.moviePoster,
                                hallId: '',
                                hallName: ticket.hallName,
                                date: ticket.date,
                                startTime: ticket.startTime,
                                endTime: ticket.endTime,
                                seats: const [], // Provided as empty per user's checkout logic
                                ticketPrice: ticket.totalSeats > 0
                                    ? ticket.totalPrice / ticket.totalSeats
                                    : 0,
                                totalSeats: ticket.totalSeats,
                                totalPrice: ticket.totalPrice,
                              );
                              context.push('/checkout', extra: checkoutData);
                            } else {
                              // View Barcode / E-ticket details for confirmed tickets
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              // Space for bottom nav bar so it doesn't overlap content
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
