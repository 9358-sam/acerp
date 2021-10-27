class StfStudentListFetchModel {
  bool success;
  List<StfStudentModel> data;

  StfStudentListFetchModel({this.success, this.data});

  StfStudentListFetchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StfStudentModel>();
      json['data'].forEach((v) {
        data.add(new StfStudentModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StfStudentModel {
  String usn;
  String auid;
  String name;
  String studentId;
  bool isAbsent = true;

  StfStudentModel({this.usn, this.auid, this.name, this.studentId, this.isAbsent});

  StfStudentModel.fromJson(Map<String, dynamic> json) {
    usn = json['usn'];
    auid = json['auid'];
    name = json['student_name'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usn'] = this.usn;
    data['auid'] = this.auid;
    data['student_name'] = this.name;
    data['student_id'] = this.studentId;
    return data;
  }

  int usnToInt() {
    if(this.usn == null) return 0;
    return int.parse(this.usn?.replaceAll(RegExp(r"[A-Za-z]"), ''));
  }
}

class SubmitAttendanceModel {
  final List<StfStudentModel> studentList;
  final String timeTableId;

  SubmitAttendanceModel({this.studentList, this.timeTableId});
}

class StfAttendanceReportModel {
  bool success;
  AttendanceReport data;

  StfAttendanceReportModel({this.success, this.data});

  StfAttendanceReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new AttendanceReport.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AttendanceReport {
  List<Student> students;
  String attendanceStatus;

  AttendanceReport({this.students, this.attendanceStatus});

  AttendanceReport.fromJson(Map<String, dynamic> json) {
    if (json['students'] != null) {
      students = new List<Student>();
      json['students'].forEach((v) {
        students.add(new Student.fromJson(v));
      });
    }
    attendanceStatus = json['attendance_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.students != null) {
      data['students'] = this.students.map((v) => v.toJson()).toList();
    }
    data['attendance_status'] = this.attendanceStatus;
    return data;
  }
}

class Student {
  String usn;
  String auid;
  String studentName;
  String presentStatus;

  Student({this.usn, this.auid, this.studentName, this.presentStatus});

  Student.fromJson(Map<String, dynamic> json) {
    usn = json['usn'];
    auid = json['auid'];
    studentName = json['student_name'];
    presentStatus = json['present_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usn'] = this.usn;
    data['auid'] = this.auid;
    data['student_name'] = this.studentName;
    data['present_status'] = this.presentStatus;
    return data;
  }
}

