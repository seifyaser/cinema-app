import 'package:dartz/dartz.dart';
import 'package:project/core/error/failure.dart';
import '../entities/ticket_entity.dart';

abstract class TicketRepository {
  Future<Either<Failure, List<TicketEntity>>> getMyTickets();
}
