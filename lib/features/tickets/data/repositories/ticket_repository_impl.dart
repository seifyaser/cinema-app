import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:project/core/error/dio_mapper.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/features/tickets/domain/entities/ticket_entity.dart';
import 'package:project/features/tickets/domain/repositories/ticket_repository.dart';
import '../datasources/ticket_remote_data_source.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketRemoteDataSource _remoteDataSource;

  TicketRepositoryImpl({required TicketRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<TicketEntity>>> getMyTickets() async {
    try {
      final ticketModels = await _remoteDataSource.getMyTickets();
      final ticketEntities = ticketModels.map((model) => model.toEntity()).toList();
      return Right(ticketEntities);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(Failure(type: FailureType.serverError, message: e.toString()));
    }
  }
}
