import 'package:dartz/dartz.dart';
import 'package:project/core/error/failure.dart';
import '../entities/ticket_entity.dart';
import '../repositories/ticket_repository.dart';

class GetMyTickets {
  final TicketRepository repository;

  GetMyTickets(this.repository);

  Future<Either<Failure, List<TicketEntity>>> call() async {
    return await repository.getMyTickets();
  }
}
