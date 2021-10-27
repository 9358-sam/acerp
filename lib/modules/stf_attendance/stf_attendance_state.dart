import 'package:acerp/models/stf_student_list_model.dart';
import 'package:meta/meta.dart';

abstract class StfAttendanceState {}

class StfAttendanceStateLoading extends StfAttendanceState {}

class StfAttendanceStateUninit extends StfAttendanceState {}

class StfAttendanceStateHasData extends StfAttendanceState {
  final List<StfStudentModel> studentList;

  StfAttendanceStateHasData({@required this.studentList});
}

class StfAttendanceStateHasError extends StfAttendanceState {
  final error;

  StfAttendanceStateHasError({@required this.error});
}

class StfAttendanceSubmitSuccessful extends StfAttendanceState {}

class StfAttendanceSubmitError extends StfAttendanceState {
  final error;

  StfAttendanceSubmitError({@required this.error});

}

class StfAttendanceReportReady extends StfAttendanceState {
 final AttendanceReport attendanceReport;

  StfAttendanceReportReady({@required this.attendanceReport});
}

class StfAttendanceStateUnauth extends StfAttendanceState {}

