import 'package:project/core/network/api_service.dart';
import 'package:project/features/booking/data/models/hall_model.dart';
import '../models/showtime_model.dart';
import '../models/seat_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<String>> getAvailableDates(String movieId);
  Future<List<HallModel>> getAvailableHalls(String movieId, String date);
  Future<List<ShowtimeModel>> getShowtimes(String movieId, String date);
  Future<List<SeatModel>> getSeatMap(String showtimeId);
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
      return hallsData.map((e) => HallModel.fromJson(e)).toList();
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
}
