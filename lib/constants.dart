import 'dart:ui';

import 'package:acerp/models/stf_timetable_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// The roles available for the application
enum Role { STUDENT, STAFF }

enum HTTPVerb { GET, POST }

const AcBlue = Color(0xff223881);

class Metrics {
  static const double LeadingIconSize = 30;
  static const Color LeadingIconColor = Color(0x00000099);

  static Widget buildLeadingBackButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.keyboard_backspace,
        color: Colors.black.withOpacity(0.6),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
  }
}

/// Annotation reference for easier code readability
class ServerCall {
  final String endpoint;
  final HTTPVerb verb;

  const ServerCall(this.verb, this.endpoint);
}

/// UnAuthenticate is thrown when the user needs to be logged out of the
/// application
class UnAuthenticate {}

/// When the response has no data
class NoData {}

/// A wrapper which tells the role and token for the user logged in
class AuthToken {
  Role role;
  String token;

  AuthToken({@required this.role, this.token});
}

mixin ToAlias {}

class CustomType<T> {
  T value;

  CustomType(this.value);
}

class MappedDateToClasses = CustomType<Map<DateTime, List<StfTimetableClass>>>
    with ToAlias;

class CustomIcons {
  static const IconData search = IconData(0xe900, fontFamily: "CustomICons");
  static const IconData menu = IconData(0xe901, fontFamily: "CustomICons");
}
