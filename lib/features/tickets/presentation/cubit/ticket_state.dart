import 'package:equatable/equatable.dart';
import 'package:project/core/error/failure_type.dart';
import '../../domain/entities/ticket_entity.dart';

abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final List<TicketEntity> tickets;

  const TicketLoaded({required this.tickets});

  @override
  List<Object?> get props => [tickets];
}

class TicketError extends TicketState {
  final FailureType type;
  final String message;

  const TicketError({required this.type, required this.message});

  @override
  List<Object?> get props => [type, message];
}
