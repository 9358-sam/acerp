import 'package:acerp/models/stf_student_list_model.dart';
import 'package:meta/meta.dart';

abstract class StfAttendanceEvent {}

class FetchStudents extends StfAttendanceEvent {
  final String timeTableId;

  FetchStudents({@required this.timeTableId});
}

class SubmitAttendance extends StfAttendanceEvent {
  final SubmitAttendanceModel submitAttendanceData;

  SubmitAttendance({@required this.submitAttendanceData});
}

class UnInitialize extends StfAttendanceEvent {}
