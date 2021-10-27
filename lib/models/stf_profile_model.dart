class StfProfileResponseModel {
  bool success;
  StaffProfileModel data;

  StfProfileResponseModel({this.success, this.data});

  StfProfileResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new StaffProfileModel.fromJson(json['data']) : null;
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

class StaffProfileModel {
  String employeeName;
  String instituteName;
  String branchName;
  String email;
  String mobile;
  String photo;
  String photoAttach;
  String dateOfJoining;
  String employeeCode;
  String designation;
  String jobType;

  StaffProfileModel(
      {this.employeeName,
      this.instituteName,
      this.branchName,
      this.email,
      this.mobile,
      this.photo,
      this.photoAttach});

  StaffProfileModel.fromJson(Map<String, dynamic> json) {
    employeeName = json['employee_name'];
    instituteName = json['institute_name'];
    branchName = json['branch_name'];
    email = json['email'];
    mobile = json['mobile'];
    photo = json['photo'];
    photoAttach = json['photo_attach'];
    dateOfJoining = json['dateofjoining'];
    employeeCode = json['empcode'];
    designation = json['designation'];
    jobType = json['job_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employee_name'] = this.employeeName;
    data['institute_name'] = this.instituteName;
    data['branch_name'] = this.branchName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['photo'] = this.photo;
    data['photo_attach'] = this.photoAttach;
    return data;
  }
}
