import 'dart:ui' as prefix0;

import 'package:acerp/modules/stf_attendance/stf_attendance.dart';
import 'package:acerp/modules/stf_attendance/stf_attendance_report_screen.dart';
import 'package:acerp/widgets/custom_alert_dialog.dart';
import 'package:acerp/widgets/custom_app_bar.dart';
import 'package:acerp/widgets/custom_paginated_data_table.dart';
import 'package:acerp/widgets/elevated_card.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StfAttendanceScreen extends StatefulWidget {
  final String timeTableId;
  final String date;
  final semesterAndClass;

  const StfAttendanceScreen(
      {Key key,
      @required this.timeTableId,
      @required this.date,
      @required this.semesterAndClass})
      : super(key: key);

  @override
  _StfAttendanceScreenState createState() => _StfAttendanceScreenState();
}

class _StfAttendanceScreenState extends State<StfAttendanceScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<StfAttendanceBloc>(context).dispatch(
      FetchStudents(timeTableId: widget.timeTableId),
    );
  }

  var navigatorState = GlobalKey<NavigatorState>();

  _shouldPop() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomAlertDialog(
        titleTextStyle: Theme.of(context).textTheme.subhead,
        title: Text('Are you sure you want to leave?'),
        actions: <Widget>[
          FlatButton(
            child: Text('YES'),
            onPressed: () {
              BlocProvider.of<StfAttendanceBloc>(context).dispatch(
                UnInitialize(),
              );
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            splashColor: Colors.redAccent.shade100,
            highlightColor: Colors.redAccent.shade100,
            child: Text(
              'NO',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _shouldPop();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          title: 'Mark Attendance',
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black.withOpacity(0.6),
            ),
            onPressed: () async {
              if (await _shouldPop()) Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder(
          bloc: BlocProvider.of<StfAttendanceBloc>(context),
          builder: (BuildContext context, StfAttendanceState state) {
            if (state is StfAttendanceReportReady) {
              if (state.attendanceReport.attendanceStatus == "2") {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) async {
                    showDialog(
                      context: context,
                      builder: (context) => ErrorDialog(
                        title: 'Note',
                        buttonTitle: 'VIEW REPORT',
                        error:
                            'Attendance Report is ready. But the Lesson Plan needs to be updated on the ERP Website',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                );
              }
              return StfAttendanceReportScreen(
                attendanceReport: state.attendanceReport,
              );
            }
            if (state is StfAttendanceStateHasData) {
              return StfAttendanceRegister(
                studentList: state.studentList,
                timeTableId: widget.timeTableId,
                date: widget.date,
                semesterAndClass: widget.semesterAndClass,
              );
            }
            if (state is StfAttendanceStateHasError) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) async {
                  print('${state.error}');
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ErrorDialog(
                      title: 'Note',
                      buttonTitle: 'GO BACK',
                      error: state.error,
                      onPressed: () async {
                        Navigator.of(context).pop(true);
                        BlocProvider.of<StfAttendanceBloc>(context).dispatch(
                          UnInitialize(),
                        );
                      },
                    ),
                  );
                  Navigator.of(context).pop();
                },
              );
            }
            if (state is StfAttendanceSubmitSuccessful) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) async {
                  await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) => ErrorDialog(
                      title: 'Success',
                      buttonTitle: 'Go Back',
                      error: 'Attendance has been submitted to the ERP',
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        BlocProvider.of<StfAttendanceBloc>(context).dispatch(
                          UnInitialize(),
                        );
                      },
                    ),
                  );
                  Navigator.of(context).pop();
                },
              );
            }
            return Stack(
              children: <Widget>[
                StfAttendanceRegister(
                  studentList: [],
                  timeTableId: widget.timeTableId,
                  showSubmit: false,
                ),
                BackdropFilter(
                  filter: prefix0.ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class StfAttendanceRegister extends StatefulWidget {
  List<StfStudentModel> studentList;
  String timeTableId;
  bool showSubmit;
  String date, semesterAndClass;

  StfAttendanceRegister({
    @required this.studentList,
    @required this.timeTableId,
    this.showSubmit = true,
    this.date,
    this.semesterAndClass,
  });

  @override
  _StfAttendanceRegisterState createState() => _StfAttendanceRegisterState();
}

class _StfAttendanceRegisterState extends State<StfAttendanceRegister> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<int> _avaliableRowsPerPage = [10, 25, 50];
  StudentDataSource studentDataSource;
  SortType sortType;

  @override
  initState() {
    super.initState();
//    if (widget.studentList[0].usn == null)
//      sortType = SortType.AUID;
//    else
    sortType = SortType.USN;
    studentDataSource =
        StudentDataSource(studentList: widget.studentList, sortType: sortType);
    _rowsPerPage =
        widget.studentList.length == 0 ? 9 : widget.studentList.length;
    _avaliableRowsPerPage.add(_rowsPerPage);
    dataColumn = [
      DataColumn(
        label: studentDataSource.studentList.length != 0 &&
                studentDataSource.studentList[0].auid == null
            ? Text('AUID')
            : Text('USN'),
      ),
      DataColumn(
        label: Text('Name'),
      ),
      DataColumn(
        label: Icon(Icons.check),
      ),
      DataColumn(
        label: studentDataSource.studentList.length != 0 &&
                studentDataSource.studentList[0].auid == null
            ? Text('USN')
            : Text('AUID'),
      ),
    ];
  }

  List<DataColumn> dataColumn;
  ScrollController _scrollController = ScrollController();
  bool sortByUSN = true;
  bool sortByName = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DraggableScrollbar.semicircle(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          children: [
            ElevatedCard(
              child: SwitchListTile(
                  title: Text("Sort list by Name"),
                  value: sortByName,
                  onChanged: (_bool) {
                    setState(() {
                      sortByName = _bool;
                    });
                    if (_bool) {
                      studentDataSource.sortList(SortType.NAME);
                    } else {
                      studentDataSource.sortList(SortType.USN);
                    }
                  }),
            ),
            ElevatedCard(
              child: SwitchListTile(
                title: Text("Sort list by USN"),
                value: sortByUSN,
                onChanged: studentDataSource.studentList.length != 0 &&
                        studentDataSource.studentList[0].auid != null
                    ? (_bool) {
                        print(studentDataSource.studentList[0].auid.toString());
                        setState(
                          () {
                            sortByUSN = _bool;
                            sortType = _bool ? SortType.USN : SortType.AUID;
                            dataColumn = [
                              DataColumn(
                                label: sortType == SortType.USN
                                    ? Text('USN')
                                    : Text('USN'),
                              ),
                              DataColumn(
                                label: Text('Name'),
                              ),
                              DataColumn(
                                label: Icon(Icons.check),
                              ),
                              DataColumn(
                                label: sortType == SortType.USN
                                    ? Text('AUID')
                                    : Text('AUID'),
                              ),
                            ];
                            studentDataSource.sortList(sortType);
//                    studentDataSource.swapUSNAUID();
                          },
                        );
                      }
                    : null,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: CustomPaginatedDataTable(
                  actions: <Widget>[
                    FlatButton(
                      child: Text('SUBMIT'),
                      onPressed:
                          widget.showSubmit ? _showConfirmationDialog : null,
                    )
                  ],
                  header: ListTile(
                    title: Text('Mark students absent'),
                    subtitle: Text(
                        '${widget.date ?? "DD-MM-YYYY"}  ${widget.semesterAndClass ?? 'X Sem, Y'}'),
                  ),
                  columns: dataColumn,
                  source: studentDataSource,
                  onSelectAll: studentDataSource.selectAll,
                  availableRowsPerPage: _avaliableRowsPerPage,
                  rowsPerPage: _rowsPerPage,
                  onRowsPerPageChanged: (int value) {
                    setState(() {
                      _rowsPerPage = value;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CustomAlertDialog(
        title: Text(
          'Confirm submitting attendance to the ERP?',
        ),
        titleTextStyle: Theme.of(context).textTheme.subhead,
        actions: <Widget>[
          FlatButton(
            child: Text('SUBMIT'),
            onPressed: () {
              BlocProvider.of<StfAttendanceBloc>(context).dispatch(
                SubmitAttendance(
                  submitAttendanceData: SubmitAttendanceModel(
                    studentList: studentDataSource.studentList,
                    timeTableId: widget.timeTableId,
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            splashColor: Colors.redAccent.shade100,
            highlightColor: Colors.redAccent.shade100,
            child: Text(
              'CLOSE',
              style: TextStyle(color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              return true;
            },
          ),
        ],
      ),
    );
    return await Future.value(false);
  }
}

enum SortType { USN, AUID, NAME }

class StudentDataSource extends DataTableSource {
  static bool isSwapped = false;
  List<StfStudentModel> studentList;
  final SortType sortType;

  StudentDataSource({@required this.studentList, @required this.sortType}) {
    selectAll(false);
    sortList(sortType);
    if (studentList.length != 0 && studentList[0].usn == null) swapUSNAUID();
  }

  int absentCount = 0;

  void sortList(SortType sortType) {
    debugPrint('SORT CALL $sortType');

    if (sortType == SortType.AUID) {
      if (studentList.length != 0 && studentList[0].auid != null)
        studentList.sort((st1, st2) => st1.auid?.compareTo(st2?.auid));
    } else if (sortType == SortType.USN) {
      if (studentList.length != 0 && studentList[0].usn != null)
        studentList.sort((st1, st2) => st1.usn?.compareTo(st2?.usn));
    } else {
      if (studentList.length != 0 && studentList[0].name != null)
        studentList.sort((st1, st2) => st1.name?.compareTo(st2?.name));
    }
    notifyListeners();
  }

  void swapUSNAUID() {
    studentList = studentList
        .map((st1) => StfStudentModel(
              auid: st1.usn,
              studentId: st1.studentId,
              name: st1.name,
              usn: st1.auid,
              isAbsent: st1.isAbsent,
            ))
        .toList();
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index > studentList.length) return null;
    final StfStudentModel studentData = studentList[index];
    return DataRow.byIndex(
        index: index,
        selected: studentData.isAbsent,
        onSelectChanged: (b) {
          if (studentData.isAbsent != b) {
            absentCount += !b ? -1 : 1;
            assert(absentCount >= 0);
            studentData.isAbsent = b;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text(
              '${sortType == SortType.USN ? studentData.usn : studentData.auid}')),
          DataCell(Text('${studentData.name}')),
          DataCell(Text(studentData.isAbsent ? 'A' : 'P')),
          DataCell(Text(
              '${sortType == SortType.USN ? studentData.auid : studentData.usn}')),
        ]);
  }

  void selectAll(b) {
    for (StfStudentModel studentData in studentList ?? [])
      studentData.isAbsent = b;
    absentCount = !b ? 0 : studentList.length;
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => studentList.length;

  @override
  int get selectedRowCount => absentCount;
}
