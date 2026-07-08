import 'package:project/core/network/api_service.dart';
import '../models/showtime_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<String>> getAvailableDates(String movieId);
  Future<List<ShowtimeModel>> getShowtimes(String movieId, String date);
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
}
