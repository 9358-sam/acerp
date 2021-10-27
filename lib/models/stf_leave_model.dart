class StfLeaveApplyModel {
  bool success;
  List<StfLeaveDetails> data;

  StfLeaveApplyModel({this.success, this.data});

  StfLeaveApplyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<StfLeaveDetails>();
      json['data'].forEach((v) {
        data.add(new StfLeaveDetails.fromJson(v));
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

class StfLeaveDetails {
  List<LeaveType> leaveType;
  List<EmpDetails> empList;
  List<HodDetails> hodDetails;

  StfLeaveDetails({this.leaveType, this.empList, this.hodDetails});

  StfLeaveDetails.fromJson(Map<String, dynamic> json) {
    if (json['leave_type'] != null) {
      leaveType = new List<LeaveType>();
      json['leave_type'].forEach((v) {
        leaveType.add(new LeaveType.fromJson(v));
      });
    }
    if (json['emp_list'] != null) {
      empList = new List<EmpDetails>();
      json['emp_list'].forEach((v) {
        empList.add(new EmpDetails.fromJson(v));
      });
    }
    if (json['hod_details'] != null) {
      hodDetails = new List<HodDetails>();
      json['hod_details'].forEach((v) {
        hodDetails.add(new HodDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leaveType != null) {
      data['leave_type'] = this.leaveType.map((v) => v.toJson()).toList();
    }
    if (this.empList != null) {
      data['emp_list'] = this.empList.map((v) => v.toJson()).toList();
    }
    if (this.hodDetails != null) {
      data['hod_details'] = this.hodDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveType {
  int leaveId;
  String leaveName;
  String leaveNameShort;
  String remainingDaysLeft;
  String limit;

  LeaveType(
      {this.leaveId,
      this.leaveName,
      this.leaveNameShort,
      this.remainingDaysLeft});

  LeaveType.fromJson(Map<String, dynamic> json) {
    leaveId = json['leave_id'];
    leaveName = json['leave_name'];
    leaveNameShort = json['leave_name_short'];
    remainingDaysLeft = json['remaining_days_left'].toString();
    limit = json['no_of_leave_applied'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leave_id'] = this.leaveId;
    data['leave_name'] = this.leaveName;
    data['leave_name_short'] = this.leaveNameShort;
    data['remaining_days_left'] = this.remainingDaysLeft;
    data['no_of_leave_applied'] = this.limit;
    return data;
  }
}

class EmpDetails {
  String name;
  String empId;
  String email;
  String mobile;

  EmpDetails({this.name, this.empId, this.email, this.mobile});

  EmpDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    empId = json['emp_id'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['emp_id'] = this.empId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    return data;
  }
}

class HodDetails {
  String hodName;
  String hodEmpId;
  String hodEmail;
  String hodMobile;

  HodDetails({this.hodName, this.hodEmpId, this.hodEmail, this.hodMobile});

  HodDetails.fromJson(Map<String, dynamic> json) {
    hodName = json['hod_name'];
    hodEmpId = json['hod_emp_id'];
    hodEmail = json['hod_email'];
    hodMobile = json['hod_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hod_name'] = this.hodName;
    data['hod_emp_id'] = this.hodEmpId;
    data['hod_email'] = this.hodEmail;
    data['hod_mobile'] = this.hodMobile;
    return data;
  }
}

