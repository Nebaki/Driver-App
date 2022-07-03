import 'package:driverapp/repository/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:driverapp/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmergencyReportBloc
    extends Bloc<EmergencyReportEvent, EmergencyReportState> {
  final EmergencyReportRepository emergencyReportRepository;

  EmergencyReportBloc({required this.emergencyReportRepository})
      : super(EmergencyInitialState());

  @override
  Stream<EmergencyReportState> mapEventToState(
      EmergencyReportEvent event) async* {
    if (event is EmergencyReportCreate) {
      yield EmergencyReportCreating();
      try {
        await emergencyReportRepository
            .createEmergencyReport(event.emergencyReport);
        yield EmergencyReportCreated();
      } catch (e) {
         if (e.toString().split(" ")[1] == "401") {
          yield EmergencyReportUnAuthorised();
        } else {
          yield EmergencyReportOperationFailur();
        }
      }
    }
  }
}

class EmergencyReportEvent extends Equatable {
  const EmergencyReportEvent();
  @override
  List<Object?> get props => [];
}

class EmergencyReportCreate extends EmergencyReportEvent {
  final EmergencyReport emergencyReport;

  const EmergencyReportCreate(this.emergencyReport);
  @override
  List<Object> get props => [emergencyReport];

  @override
  String toString() => 'Report Created {user: $emergencyReport}';
}

class EmergencyReportState extends Equatable {
  const EmergencyReportState();
  @override
  List<Object?> get props => [];
}

class EmergencyReportCreating extends EmergencyReportState {}

class EmergencyReportCreated extends EmergencyReportState {}

class EmergencyInitialState extends EmergencyReportState {}

class EmergencyReportOperationFailur extends EmergencyReportState {}

class EmergencyReportUnAuthorised extends EmergencyReportState {}
