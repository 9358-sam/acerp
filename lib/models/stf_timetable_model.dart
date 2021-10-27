class StfTimetableFetchModel {
  List<StfTimetableClass> data;

  StfTimetableFetchModel({this.data});

  StfTimetableFetchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StfTimetableClass>();
      json['data'].forEach((v) {
        data.add(new StfTimetableClass.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StfTimetableClass {
  String timeTableId;
  String empId;
  String contractEmpId;
  String interval;
  String currentYear;
  String currentSem;
  String selectedDate;
  String courseShortName;
  String courseBranchShortName;
  String sectionShortName;
  String subjectNameShort;

  StfTimetableClass(
      {this.timeTableId,
      this.empId,
      this.contractEmpId,
      this.interval,
      this.currentYear,
      this.currentSem,
      this.selectedDate,
      this.courseShortName,
      this.courseBranchShortName,
      this.sectionShortName,
      this.subjectNameShort});

  StfTimetableClass.fromJson(Map<String, dynamic> json) {
    timeTableId = json['time_table_id'];
    empId = json['emp_id'];
    contractEmpId = json['contract_emp_id'];
    interval = json['interval'];
    currentYear = json['current_year'];
    currentSem = json['current_sem'];
    selectedDate = json['selected_date'];
    courseShortName = json['course_short_name'];
    courseBranchShortName = json['course_branch_short_name'];
    sectionShortName = json['section_short_name'];
    subjectNameShort = json['subject_name_short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time_table_id'] = this.timeTableId;
    data['emp_id'] = this.empId;
    data['contract_emp_id'] = this.contractEmpId;
    data['interval'] = this.interval;
    data['current_year'] = this.currentYear;
    data['current_sem'] = this.currentSem;
    data['selected_date'] = this.selectedDate;
    data['course_short_name'] = this.courseShortName;
    data['course_branch_short_name'] = this.courseBranchShortName;
    data['section_short_name'] = this.sectionShortName;
    data['subject_name_short'] = this.subjectNameShort;
    return data;
  }
}
