import 'package:project/core/network/api_service.dart';
import 'package:project/features/tickets/data/models/ticket_model.dart';

abstract class TicketRemoteDataSource {
  Future<List<TicketModel>> getMyTickets();
}

class TicketRemoteDataSourceImpl implements TicketRemoteDataSource {
  final ApiService _apiService;

  TicketRemoteDataSourceImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<TicketModel>> getMyTickets() async {
    final response = await _apiService.get('/bookings/my-bookings');

    if (response.data != null && response.data['data'] != null && response.data['data']['bookings'] != null) {
      final List<dynamic> bookingsData = response.data['data']['bookings'];
      return bookingsData
          .map((json) => TicketModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
