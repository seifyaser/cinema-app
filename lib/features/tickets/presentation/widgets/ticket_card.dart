import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../domain/entities/ticket_entity.dart';
import 'ticket_barcode.dart';
import 'ticket_icon_text.dart';
import 'ticket_shape_border.dart';
import 'ticket_tear_line.dart';

class TicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final VoidCallback onTap;
  final bool isActive;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    this.isActive = true,
  });

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('d MMM').format(date);
    } catch (_) {
      return isoString;
    }
  }

  Color _getStatusColor() {
    switch (ticket.status.toLowerCase()) {
      case 'confirmed':
        return Colors.greenAccent;
      case 'expired':
      case 'cancelled':
      case 'refused':
        return Colors.redAccent;
      case 'pending':
      default:
        return const Color(0xFFEAB308); // Gold
    }
  }

  @override
  Widget build(BuildContext context) {
    // The active ticket is fully opaque and styled, the adjacent ones are dimmed and scaled down (scaling handled by PageView).
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.6,
        child: RepaintBoundary(
          child: SizedBox.expand(
            child: Center(
              child: AspectRatio(
                aspectRatio: 254 / 465, // matches the SVG dimensions
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Native Flutter Shape Background (Replaces SVG)
                    Container(
                      decoration: ShapeDecoration(
                        color: isActive
                            ? const Color(0xFF201F1F) // surface-container
                            : const Color(0xFF1C1B1B), // surface-container-low
                        shape: const TicketShapeBorder(
                          cornerRadius: 16,
                          cutoutRadius: 16,
                          cutoutPositionRatio: 0.716, // matches SVG (333 / 465)
                        ),
                      ),
                    ),

                    // Ticket Divider perfectly aligned with the shape cutouts
                    Positioned(
                      left: 20.0,
                      right: 20.0,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: const FractionalOffset(0.5, 0.716),
                        child: const TicketTearLine(),
                      ),
                    ),

                    // Content Overlay
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 24.0,
                        bottom: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Status Badge at top center
                          Center(
                            child: SizedBox(
                              height: 26,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _getStatusColor().withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ticket.status.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'Manrope',
                                        color: _getStatusColor(),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Movie Poster
                          Expanded(
                            flex: 4, // Pushes data down towards the divider
                            child: SizedBox.expand(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  ticket.moviePoster,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const ColoredBox(
                                        color: Colors.white10,
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.white54,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Info Rows
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32.0,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TicketIconText(
                                      icon: Icons.calendar_today,
                                      text: _formatDate(ticket.date),
                                    ),
                                    TicketIconText(
                                      icon: Icons.person,
                                      text: '${ticket.totalSeats} Seats',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TicketIconText(
                                      icon: Icons.account_balance_wallet,
                                      text: '₹${ticket.totalPrice.toInt()}',
                                    ),
                                    TicketIconText(
                                      icon: Icons.meeting_room,
                                      text: ticket.hallName,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Push barcode to the bottom
                          const Spacer(),

                          // Static Fake Barcode Section
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const TicketBarcode(),
                              const SizedBox(height: 8),
                              if (ticket.selectedSeats.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.center,
                                  children: ticket.selectedSeats.map((label) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAB308)
                                            .withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFEAB308)
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: Text(
                                        label,
                                        style: const TextStyle(
                                          color: Color(0xFFEAB308),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )
                              else
                                Text(
                                  ticket.id,
                                  style: const TextStyle(
                                    fontFamily: 'Manrope',
                                    color: Colors.white54,
                                    fontSize: 12,
                                    letterSpacing: 2,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
