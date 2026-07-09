import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_tickets.dart';
import 'ticket_state.dart';

class TicketCubit extends Cubit<TicketState> {
  final GetMyTickets _getMyTickets;

  TicketCubit({required GetMyTickets getMyTickets})
      : _getMyTickets = getMyTickets,
        super(TicketInitial());

  Future<void> fetchMyTickets() async {
    emit(TicketLoading());
    final result = await _getMyTickets();
    result.fold(
      (failure) => emit(TicketError(type: failure.type, message: failure.message)),
      (tickets) => emit(TicketLoaded(tickets: tickets)),
    );
  }
}
