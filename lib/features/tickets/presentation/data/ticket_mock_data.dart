// TEMPORARY: Static mock data for UI development.
// Remove / replace this file when integrating with the real backend.

import '../../domain/entities/ticket_entity.dart';

class TicketMockData {
  static const List<TicketEntity> activeTickets = [
    TicketEntity(
      id: '6a4f5b...',
      movieId: 'm1', // Placeholder as it wasn't in the snippet
      movieTitle: 'Inception',
      movieSubtitle: 'Your mind is the scene of the crime',
      moviePoster:
          'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg',
      hallName: 'Hall 1',
      date: '2026-07-09T00:00:00Z',
      startTime: '8:00 PM',
      endTime: '10:30 PM',
      totalSeats: 2,
      totalPrice: 36.0,
      status: 'confirmed',
      selectedSeats: const ['A1', 'A2'],
    ),
    TicketEntity(
      id: 'mock-002',
      movieId: 'm2',
      movieTitle: 'DUNE: PART TWO',
      movieSubtitle: 'Long Live the Fighters',
      moviePoster:
          'https://image.tmdb.org/t/p/w500/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg',
      hallName: 'VIP',
      date: '2024-10-22',
      startTime: '8:30 PM',
      endTime: '11:15 PM',
      totalSeats: 2,
      totalPrice: 420.0,
      status: 'confirmed',
      selectedSeats: const ['F9', 'F10'],
    ),
    TicketEntity(
      id: 'mock-003',
      movieId: 'm3',
      movieTitle: 'OPPENHEIMER',
      movieSubtitle: 'The World Forever Changes',
      moviePoster:
          'https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg',
      hallName: 'IMAX',
      date: '2024-11-05',
      startTime: '9:00 PM',
      endTime: '12:00 AM',
      totalSeats: 1,
      totalPrice: 250.0,
      status: 'confirmed',
      selectedSeats: const ['B4'],
    ),
  ];

  static const List<TicketEntity> pastTickets = [
    TicketEntity(
      id: 'mock-004',
      movieId: 'm4',
      movieTitle: 'THE BATMAN',
      movieSubtitle: 'Vengeance',
      moviePoster:
          'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      hallName: 'IMAX',
      date: '2024-09-10',
      startTime: '7:00 PM',
      endTime: '10:07 PM',
      totalSeats: 4,
      totalPrice: 800.0,
      status: 'expired',
      selectedSeats: const ['K12', 'K13', 'K14', 'K15'],
    ),
  ];
}
