import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/ticket_cubit.dart';
import '../cubit/ticket_state.dart';
import '../widgets/ticket_card.dart';
import 'package:project/core/widgets/failure_widget.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "My Tickets",
          style: TextStyle(
            fontFamily: 'Sora',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFEAB308),
          labelColor: const Color(0xFFEAB308),
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "Active"),
            Tab(text: "Past"),
          ],
        ),
      ),
      body: BlocBuilder<TicketCubit, TicketState>(
        builder: (context, state) {
          if (state is TicketLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFEAB308)),
            );
          } else if (state is TicketError) {
            return FailureWidget(
              type: state.type,
              message: state.message,
              onRetry: () => context.read<TicketCubit>().fetchMyTickets(),
            );
          } else if (state is TicketLoaded) {
            final activeTickets = state.tickets
                .where(
                  (t) =>
                      t.status.toLowerCase() != 'expired' &&
                      t.status.toLowerCase() != 'cancelled',
                )
                .toList();
            final pastTickets = state.tickets
                .where(
                  (t) =>
                      t.status.toLowerCase() == 'expired' ||
                      t.status.toLowerCase() == 'cancelled',
                )
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildTicketList(activeTickets, "No active tickets found."),
                _buildTicketList(pastTickets, "No past tickets found."),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTicketList(List tickets, String emptyMessage) {
    Widget content;
    if (tickets.isEmpty) {
      content = ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: Text(
                emptyMessage,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      content = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return TicketCard(
            ticket: ticket,
            onTap: () {
              // Later: View Barcode / E-ticket details
            },
          );
        },
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFEAB308),
      backgroundColor: const Color(0xFF2A2A2A),
      onRefresh: () async {
        await context.read<TicketCubit>().fetchMyTickets();
      },
      child: content,
    );
  }
}
