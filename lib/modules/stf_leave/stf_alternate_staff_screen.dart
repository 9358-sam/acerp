import 'package:acerp/common.dart';
import 'package:acerp/widgets/custom_alert_dialog.dart';
import 'package:acerp/widgets/elevated_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acerp/modules/stf_leave/stf_leave_provider.dart';
import 'package:documents_picker/documents_picker.dart';

class StfAlternateStaffScreen extends StatefulWidget {
  GlobalKey<NavigatorState> navigator;

  StfAlternateStaffScreen(GlobalKey<NavigatorState> args) {
    this.navigator = args;
  }

  @override
  _StfAlternateStaffScreenState createState() =>
      _StfAlternateStaffScreenState();
}

class _StfAlternateStaffScreenState extends State<StfAlternateStaffScreen> {
  void _finalizeLeave() {
    StfLeaveProvider provider =
    Provider.of<StfLeaveProvider>(context, listen: false);
    try {
      provider.finalValidate();
      provider.finalRequest();
    } catch (reason) {
      showDialog(
        context: context,
        builder: (context) =>
            ErrorDialog(
                title: 'Validation Error',
                error: '$reason',
                onPressed: () => Navigator.of(context).pop(),
                buttonTitle: 'CLOSE'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _finalizeLeave, label: Text('Apply For Leave')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        children: <Widget>[
          // TODO: Format with white bg
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _customfy(
              CheckboxListTile(
                onChanged: (bool v) {
                  Provider
                      .of<StfLeaveProvider>(context)
                      .ifNoClass = v;
                },
                value: Provider
                    .of<StfLeaveProvider>(context)
                    .ifNoClass,
                title: Text('If No Class, Check'),
              ),
            ),
          ),
          _customfy(_buildEmpDetailTile(title: 'Leave Category', value: '${provider.leaveCategoriesFull[provider.leaveCategoryIndex]}')),
          _customfy(_buildEmpDetailTile(title: 'Leave Type', value: '${provider.leaveTypes[provider.leaveTypeIndex]}')),
          _customfy(_buildEmpDetailTile(
              title: 'Days Applied', value: '${provider.daysApplied}')),
          ..._buildAlternateStaffDetails(context),
          _buildButtonRow(),
          ..._filesUploaded(context)
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (!provider.ifNoClass)
            _customfy(FlatButton(
              textColor: AcBlue,
              child: Text(
                "Select alternate employee",
                style: TextStyle(
                    decoration: TextDecoration.underline, fontSize: 17),
              ),
              onPressed: () {
                widget.navigator.currentState.pushNamed(
                  'LeaveEmpList',
                );
              },
            )),
          if([4, 5, 12, 33, 35].contains(
              provider.leaveIds[provider.leaveCategoryIndex])) _customfy(
              _buildUploadFileButton()),
        ],
      ),
    );
  }

  List<Widget> _buildAlternateStaffDetails(BuildContext context) {
    StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
    List<Widget> widgets = [];
    if (!provider.ifNoClass)
      widgets.addAll(_handleAlternateStaffDetails(context));
    return widgets.toList();
  }

  List<Widget> _handleAlternateStaffDetails(BuildContext context) {
    StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
    List<Widget> widgets = [];
    if (provider.alternateEmpDetails != null) {
      widgets.add(
          _customfy(
            Column(
              children: <Widget>[
                _buildEmpDetailTile(
                    title: 'Name',
                    value: '${provider.alternateEmpDetails.name}'),
                _buildEmpDetailTile(
                    title: 'Phone',
                    value: '${provider.alternateEmpDetails.mobile}'),
                _buildEmpDetailTile(
                    title: 'Email',
                    value: '${provider.alternateEmpDetails.email}'),
                _buildEmpDetailTile(
                    title: 'EmpID',
                    value: '${provider.alternateEmpDetails.empId}')
              ],
            ),
          )
      );
    }
    return widgets.toList();
  }

  Widget _buildEmpDetailTile({String title, String value}) {
    return (
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildUploadFileButton() {
    return FlatButton(
      textColor: AcBlue,
      child: Text(
        'Upload Files',
        style: TextStyle(decoration: TextDecoration.underline, fontSize: 17),
      ),
      onPressed: () async {
        StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
        List<String> fileNames = await DocumentsPicker.pickDocuments;
        fileNames.forEach((String filePath) {
          provider.uploadFile(UploadedFile(filePath, filePath));
        });
      },
    );
  }

  RegExp regExp = RegExp(r'[^\/]*\..*$', caseSensitive: false, multiLine: true);

  List<Widget> _filesUploaded(BuildContext context) {
    List<Widget> fileNames = [];
    StfLeaveProvider provider = Provider.of<StfLeaveProvider>(context);
    if (provider.uploadedFiles.length == 0) {
      fileNames.add(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No Files Uploaded'),
        ),
      );
    }
    provider.uploadedFiles.forEach((UploadedFile file) {
      Widget widget = _customfy(Row(
        children: <Widget>[
          Text('     ${provider.uploadedFiles.indexOf(file) + 1}  '),
          Expanded(
            child: Text(
              '${regExp.stringMatch(file.fileName)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: () => provider.removeUploadedFile(file),
          )
        ],
      ));
      fileNames.add(widget);
    });
    return fileNames.toList();
  }

  Widget _customfy(Widget widget) {
    return ElevatedCard(
      margin: EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: widget,
    );
  }
}
