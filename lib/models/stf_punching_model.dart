class StfPunchingModel {
  bool success;
  StfPunchingData data;

  StfPunchingModel({this.success, this.data});

  StfPunchingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null
        ? new StfPunchingData.fromJson(json['data'])
        : null;
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

class StfPunchingData {
  String day1;
  String day2;
  String day3;
  String day4;
  String day5;
  String day6;
  String day7;
  String day8;
  String day9;
  String day10;
  String day11;
  String day12;
  String day13;
  String day14;
  String day15;
  String day16;
  String day17;
  String day18;
  String day19;
  String day20;
  String day21;
  String day22;
  String day23;
  String day24;
  String day25;
  String day26;
  String day27;
  String day28;
  String day29;
  String day30;
  String day31;
  String year;
  String month;
  List<Punching> punching;
  String payDays;
  Map<DateTime, List<String>> mapWithDate;

  StfPunchingData(
      {this.day1,
      this.day2,
      this.day3,
      this.day4,
      this.day5,
      this.day6,
      this.day7,
      this.day8,
      this.day9,
      this.day10,
      this.day11,
      this.day12,
      this.day13,
      this.day14,
      this.day15,
      this.day16,
      this.day17,
      this.day18,
      this.day19,
      this.day20,
      this.day21,
      this.day22,
      this.day23,
      this.day24,
      this.day25,
      this.day26,
      this.day27,
      this.day28,
      this.day29,
      this.day30,
      this.day31,
      this.punching,
      this.mapWithDate,
      this.payDays});

  StfPunchingData.fromJson(Map<String, dynamic> json) {
    day1 = json['day1'];
    day2 = json['day2'];
    day3 = json['day3'];
    day4 = json['day4'];
    day5 = json['day5'];
    day6 = json['day6'];
    day7 = json['day7'];
    day8 = json['day8'];
    day9 = json['day9'];
    day10 = json['day10'];
    day11 = json['day11'];
    day12 = json['day12'];
    day13 = json['day13'];
    day14 = json['day14'];
    day15 = json['day15'];
    day16 = json['day16'];
    day17 = json['day17'];
    day18 = json['day18'];
    day19 = json['day19'];
    day20 = json['day20'];
    day21 = json['day21'];
    day22 = json['day22'];
    day23 = json['day23'];
    day24 = json['day24'];
    day25 = json['day25'];
    day26 = json['day26'];
    day27 = json['day27'];
    day28 = json['day28'];
    day29 = json['day29'];
    day30 = json['day30'];
    day31 = json['day31'];
    year = json['year'];
    month = json['month'];
    if (json['punching'] != null) {
      punching = new List<Punching>();
      json['punching'].forEach((v) {
        punching.add(new Punching.fromJson(v));
      });
    }
    payDays = json['pay_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day1'] = this.day1;
    data['day2'] = this.day2;
    data['day3'] = this.day3;
    data['day4'] = this.day4;
    data['day5'] = this.day5;
    data['day6'] = this.day6;
    data['day7'] = this.day7;
    data['day8'] = this.day8;
    data['day9'] = this.day9;
    data['day10'] = this.day10;
    data['day11'] = this.day11;
    data['day12'] = this.day12;
    data['day13'] = this.day13;
    data['day14'] = this.day14;
    data['day15'] = this.day15;
    data['day16'] = this.day16;
    data['day17'] = this.day17;
    data['day18'] = this.day18;
    data['day19'] = this.day19;
    data['day20'] = this.day20;
    data['day21'] = this.day21;
    data['day22'] = this.day22;
    data['day23'] = this.day23;
    data['day24'] = this.day24;
    data['day25'] = this.day25;
    data['day26'] = this.day26;
    data['day27'] = this.day27;
    data['day28'] = this.day28;
    data['day29'] = this.day29;
    data['day30'] = this.day30;
    data['day31'] = this.day31;
    if (this.punching != null) {
      data['punching'] = this.punching.map((v) => v.toJson()).toList();
    }
    data['pay_days'] = this.payDays;
    return data;
  }
}

class Punching {
  String date;
  String startTime;
  String endTime;

  Punching({this.date, this.startTime, this.endTime});

  Punching.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}
