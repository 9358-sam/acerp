import 'package:acerp/models/stf_student_list_model.dart';
import 'package:acerp/widgets/elevated_card.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';

class StfAttendanceReportScreen extends StatefulWidget {
  final AttendanceReport attendanceReport;

  const StfAttendanceReportScreen({Key key, @required this.attendanceReport})
      : super(key: key);

  @override
  _StfAttendanceReportScreenState createState() =>
      _StfAttendanceReportScreenState();
}

enum SortType { USN, AUID }

class _StfAttendanceReportScreenState extends State<StfAttendanceReportScreen> {
  List<Student> students;
  List<Student> separated = [];
  List<Student> unSeparated = [];
  SortType sortType;
  bool disableSwitch = false;
  bool showAbsenteesOnly = false;

  @override
  void initState() {
    super.initState();
    students = [...widget.attendanceReport.students];
    debugPrint('${students[0].usn} ${students[0].auid}');
    if (students[0].usn == null) {
      disableSwitch = true;
      sortType = SortType.AUID;
      students = sortStudents(SortType.AUID, students);
    } else {
      sortType = SortType.USN;
      students = sortStudents(SortType.USN, students);
    }
  }

  List<Student> sortStudents(SortType type, List<Student> list) {
    if (type == SortType.AUID)
      list.sort((st1, st2) => st1.auid.compareTo(st2.auid));
    else
      list.sort((st1, st2) => st1.usn.compareTo(st2.usn));
    return list;
  }

  List<Student> separateAbsentees(bool toSeparate, List<Student> list) {
    List<Student> result = [];
    if (toSeparate) {
      result.addAll(list.where((st) => st.presentStatus == "A").toList());
      result.addAll(list.where((st) => st.presentStatus != "A").toList());
    } else {
      result.addAll(sortStudents(sortType, list));
    }
    return result;
  }

  bool sortByUSN = true;
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableScrollbar.semicircle(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, i) {
            var index = i - 2;
            if (i == 0) {
              return ElevatedCard(
                child: SwitchListTile(
                  selected: sortByUSN,
                  onChanged: disableSwitch
                      ? null
                      : (_bool) {
                          setState(() {
                            sortByUSN = _bool;
                            sortType = _bool ? SortType.USN : SortType.AUID;
                            showAbsenteesOnly = false;
                            students = separateAbsentees(false, students);
                            students = sortStudents(sortType, students);
                          });
                        },
                  value: sortByUSN,
                  title: Text('Sort list by USN'),
                ),
              );
            }
            if (i == 1) {
              return ElevatedCard(
                child: SwitchListTile(
                  value: showAbsenteesOnly,
                  selected: showAbsenteesOnly,
                  title: Text("Sort by Present Status"),
                  onChanged: (_bool) {
                    setState(() {
                      debugPrint(students.toString());
                      showAbsenteesOnly = _bool;
                      if (_bool)
                        students = separateAbsentees(true, students);
                      else
                        students = separateAbsentees(false, students);
                    });
                  },
                ),
              );
            }
            Student student = students[index];
            return ElevatedCard(
              child: ListTile(
                title: sortType == SortType.USN
                    ? _buildFriendlyReg('USN - ${student.usn}')
                    : _buildFriendlyReg('AUID - ${student.auid}'),
                subtitle: Text(
                    'NAME - ${student.studentName}${sortType == SortType.USN ? "\nAUID - ${student.auid}" : ""} '),
                isThreeLine: sortType == SortType.USN,
                trailing: Text(
                  '${student.presentStatus}',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
          itemCount: students.length,
        ),
      ),
    );
  }

  Widget _buildFriendlyReg(String reg) {
    String id = reg.substring(reg.length - 3);
    String root = reg.substring(0, reg.length - 3);
    return Row(
      children: <Widget>[
        Text('$root'),
        Text(
          '  $id',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 21),
        )
      ],
    );
  }
}
