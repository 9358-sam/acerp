import 'dart:collection';
import 'dart:convert';

import 'package:acerp/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

export 'package:acerp/constants.dart';

/// Sends a ***HTTP GET*** request to the specified url with the given headers
///
/// Tokens passed as [String] is injected into the header.
Future<Map> getRequest(String url,
    {Map<String, String> headers, String token}) async {
  print('getting $url');
  if (token != null) {
    if (headers == null)
      headers = {'token': token};
    else
      headers['token'] = token;
  }

  http.Response response = await http.get(url, headers: headers);
  return jsonDecode(response.body);
}

/// Sends a ***HTTP POST*** request to the specified url with the given headers
/// the specified request body
///
/// The body is `jsonEncoded` by default and the header is set to
///
///
/// ```content-type: application/json```
///
/// Token passed as [String] is injected into the header.
Future<Map> postRequest(String url,
    {Map<String, dynamic> body,
    Map<String, String> headers,
    String token, bool ignoreErrors = false}) async {
  if (headers == null) headers = {};
  if (token != null) headers['token'] = token;
  headers['content-type'] = 'application/json';
  String jsonBody = jsonEncode(body);
  print(jsonBody);
  print('posting $url');
  http.Response response =
      await http.post(url, body: jsonBody, headers: headers);
  print(response.body);
  return jsonDecode(response.body);
}

/// Handles errors by throwing it up the call stack if the http request to the
/// server has failed.
///
/// **throws** `[customError]` if ```{jsonResponse['error']}``` is `null`
///
/// **throws** `[UnAuthenticate]` if `{jsonResponse['unauth']}` is `true`
void handleFetchError(Map jsonResponse, String customError) {
  print(jsonResponse.toString());
  if (jsonResponse['unauth'] != null && jsonResponse['unauth']) throw UnAuthenticate();
  if (jsonResponse['success'] == null || jsonResponse['success'] == false) {
    if (jsonResponse['error'] != null)
      throw jsonResponse['error'];
    else
      throw '$customError';
  }
}

String hashRequest({String url, Map header, Map body}) {
  String urlHash = generateHash(url);
  String headerHash = generateHash(sortMap(header).toString());
  String bodyHash = generateHash(sortMap(body).toString());
  return generateHash(urlHash + headerHash + bodyHash);
}

SplayTreeMap sortMap(Map map) {
  return new SplayTreeMap.from (map, (a, b) => a.compareTo(b));
}

String generateHash(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

