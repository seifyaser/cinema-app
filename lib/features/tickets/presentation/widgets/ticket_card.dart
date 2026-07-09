import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '../../domain/entities/ticket_entity.dart';

class TicketCard extends StatelessWidget {
  final TicketEntity ticket;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('EEE, d MMM yyyy').format(date);
    } catch (_) {
      return isoString;
    }
  }

  Color _getStatusColor() {
    switch (ticket.status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'expired':
      case 'cancelled':
        return Colors.redAccent;
      case 'pending':
      default:
        return const Color(0xFFEAB308); // Gold
    }
  }

  String _getStatusText() {
    switch (ticket.status.toLowerCase()) {
      case 'confirmed':
        return 'CONFIRMED';
      case 'expired':
        return 'EXPIRED';
      case 'cancelled':
        return 'CANCELLED';
      case 'pending':
      default:
        return 'PENDING';
    }
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 14),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Manrope',
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FakeGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 24),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          ticket.moviePoster,
                          width: 70,
                          height: 105,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 70,
                            height: 105,
                            color: Colors.white10,
                            child: const Icon(Icons.broken_image, color: Colors.white54),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ticket.movieTitle,
                                    style: const TextStyle(
                                      fontFamily: 'Sora',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Status Chip
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor().withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _getStatusColor().withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Text(
                                    _getStatusText(),
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      color: _getStatusColor(),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10,
                                      letterSpacing: 0.05,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.meeting_room,
                              ticket.hallName,
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                              Icons.calendar_today,
                              _formatDate(ticket.date),
                            ),
                            const SizedBox(height: 6),
                            _buildInfoRow(
                              Icons.access_time,
                              '${ticket.startTime} - ${ticket.endTime}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${ticket.totalSeats} Seat${ticket.totalSeats > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${ticket.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          color: Color(0xFFEAB308),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
