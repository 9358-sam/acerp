class StfSwapModel {
  bool success;
  List<StfSwapCandidate> data;

  StfSwapModel({this.success, this.data});

  StfSwapModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StfSwapCandidate>();
      json['data'].forEach((v) {
        data.add(new StfSwapCandidate.fromJson(v));
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

class StfSwapCandidate {
  String name;
  String empId;
  String branch;

  StfSwapCandidate({this.name, this.empId, this.branch});

  StfSwapCandidate.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    empId = json['emp_id'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['emp_id'] = this.empId;
    data['branch'] = this.branch;
    return data;
  }
}

class StfSwapSubjectsModel {
  bool success;
  List<StfSwapSubject> data;

  StfSwapSubjectsModel({this.success, this.data});

  StfSwapSubjectsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StfSwapSubject>();
      json['data'].forEach((v) {
        data.add(new StfSwapSubject.fromJson(v));
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

class StfSwapSubject {
  String subjectAssignmentId;
  String subjectShortName;

  StfSwapSubject({this.subjectAssignmentId, this.subjectShortName});

  StfSwapSubject.fromJson(Map<String, dynamic> json) {
    subjectAssignmentId = json['subject_assignment_id'];
    subjectShortName = json['subject_name_short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_assignment_id'] = this.subjectAssignmentId;
    data['subject_name_short'] = this.subjectShortName;
    return data;
  }
}
