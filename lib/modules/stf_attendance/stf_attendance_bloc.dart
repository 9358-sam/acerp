import 'package:acerp/models/stf_student_list_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/scheduler.dart';
import 'package:meta/meta.dart';
import 'package:acerp/modules/stf_attendance/stf_attendance.dart';
import 'package:acerp/common.dart' show UnAuthenticate;
import 'package:acerp/repositories/repository.dart';
export 'package:acerp/models/stf_student_list_model.dart';

class StfAttendanceBloc extends Bloc<StfAttendanceEvent, StfAttendanceState> {
  final StaffRepository staffRepository;

  final UserRepository userRepository;

  StfAttendanceBloc({this.staffRepository, this.userRepository});

  @override
  StfAttendanceState get initialState => StfAttendanceStateUninit();

  @override
  Stream<StfAttendanceState> mapEventToState(StfAttendanceEvent event) async* {
    if (event is FetchStudents) {
      print('DISPATCHEDDDD');
      yield StfAttendanceStateLoading();
      try {
        List<StfStudentModel> studentList =
            await staffRepository.fetchStudentList(
          authToken: await userRepository.getAuthToken(),
          timeTableId: event.timeTableId,
        );
        yield StfAttendanceStateHasData(studentList: studentList);
      } on AttendanceReportReady {
        print('\n\n\n\nTF');
        AttendanceReport attendanceReport =
            await staffRepository.fetchAttendanceReport(
          token: await userRepository.getAuthToken(),
          timeTableId: event.timeTableId,
        );
        yield StfAttendanceReportReady(attendanceReport: attendanceReport);
      } on UnAuthenticate {
        yield StfAttendanceStateUnauth();
      } on FormatException {
        yield StfAttendanceStateHasError(
            error:
                "Server error while fetching student-list [ E-FormatException ]");
      } catch (e) {
        yield StfAttendanceStateHasError(error: e);
      }
    }
    if (event is SubmitAttendance) {
      print('DISPATCHEDDDDxxx');

      yield StfAttendanceStateLoading();
      try {
        bool success = await staffRepository.submitAttendance(
          submitAttendanceData: event.submitAttendanceData,
          authToken: await userRepository.getAuthToken(),
        );
        if (success) {
          yield StfAttendanceSubmitSuccessful();
        }
      } on UnAuthenticate {
        yield StfAttendanceStateUnauth();
      } on FormatException {
        yield StfAttendanceStateHasError(
            error:
                "Server error while submitting-attendance. Please report this. E-FormatException");
      } catch (e) {
        yield StfAttendanceStateHasError(error: e);
      }
    }
    if (event is UnInitialize) {
      yield StfAttendanceStateUninit();
    }
  }
}
