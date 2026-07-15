import 'package:project/core/network/api_service.dart';
import 'package:project/features/booking/data/models/hall_model.dart';
import '../models/showtime_model.dart';
import '../models/seat_model.dart';
import '../models/hold_seats_request.dart';

abstract class BookingRemoteDataSource {
  Future<List<String>> getAvailableDates(String movieId);
  Future<List<HallModel>> getAvailableHalls(String movieId, String date);
  Future<List<ShowtimeModel>> getShowtimes(String movieId, String date);
  Future<List<SeatModel>> getSeatMap(String showtimeId);
  Future<Map<String, dynamic>> holdSeats(HoldSeatsRequest request);
  Future<String> createPaymentIntention(String bookingId);
  Future<String> getPaymentStatus(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final ApiService _apiService;

  BookingRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<String>> getAvailableDates(String movieId) async {
    final response = await _apiService.get('/movies/$movieId/available-dates');
    if (response.data != null && response.data['data'] != null) {
      final List<dynamic> datesData = response.data['data']['dates'];
      return datesData.map((e) => e.toString()).toList();
    }
    return [];
  }

  @override
  Future<List<HallModel>> getAvailableHalls(String movieId, String date) async {
    final response = await _apiService.get('/movies/$movieId/available-halls?date=$date');
    if (response.data != null && response.data['data'] != null) {
      final List<dynamic> hallsData = response.data['data']['halls'];
      return hallsData.map((e) => HallModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<List<ShowtimeModel>> getShowtimes(String movieId, String date) async {
    final response = await _apiService.get('/movies/$movieId/showtimes?date=$date');
    if (response.data != null && response.data['data'] != null) {
      final List<dynamic> showtimesData = response.data['data']['showtimes'];
      return showtimesData
          .map((json) => ShowtimeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<SeatModel>> getSeatMap(String showtimeId) async {
    final response = await _apiService.get('/showtimes/$showtimeId/seats');
    if (response.data != null && response.data['data'] != null) {
      final List<dynamic> seatsData = response.data['data']['seats'];
      return seatsData
          .map((json) => SeatModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<Map<String, dynamic>> holdSeats(HoldSeatsRequest request) async {
    final response = await _apiService.post('/bookings/hold', data: request.toJson());
    return response.data['data'] as Map<String, dynamic>? ?? {};
  }

  @override
  Future<String> createPaymentIntention(String bookingId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      'payments/intention',
      data: {'bookingId': bookingId},
    );
    final body = response.data ?? {};
    final data = body['data'] as Map<String, dynamic>? ?? body;
    final clientSecret =
        data['client_secret'] as String? ?? data['clientSecret'] as String? ?? '';
    if (clientSecret.isEmpty) {
      throw Exception('Failed to get payment client secret from server.');
    }
    return clientSecret;
  }

  @override
  Future<String> getPaymentStatus(String bookingId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      'payments/booking/$bookingId',
    );
    final body = response.data ?? {};
    final data = body['data'] as Map<String, dynamic>? ?? body;
    return data['status']?.toString() ?? '';
  }
}
