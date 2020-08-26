import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const TYPE_APPLICATION_JSON = 'application/json';
const TYPE_MULTIPART_FORM_DATA = 'multipart/form-data';
const TYPE_X_AUTHORIZATION = 'x-authorization';

const Map<String, String> jsonHeaders = {
  HttpHeaders.contentTypeHeader: TYPE_APPLICATION_JSON,
  HttpHeaders.acceptHeader: TYPE_APPLICATION_JSON,
};

const Duration DEFAULT_TIMEOUT_DURATION = Duration(seconds: 30);

Future<http.Response> getCall({
  String tag,
  String url,
  Map<String, String> headers = jsonHeaders,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  final response = await http.get(url, headers: headers).timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: GET'
        '\nRequest Headers: ${headers.toString()}'
        '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
    '\nRequest Method: GET'
    '\nResponse Code: ${response.statusCode}'
    '\nResponse Body: ${response.body}',
  );

  return response;
}

Future<http.Response> postCall({
  String tag,
  String url,
  Map<String, String> headers = jsonHeaders,
  dynamic body,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  final response = await http.post(url, headers: headers, body: body).timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: POST'
        '\nRequest Headers: ${headers.toString()}'
        '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
    '\nRequest Method: POST'
    '\nRequest Headers: ${headers.toString()}'
    '\nRequest Body: $body'
    '\nResponse Code: ${response.statusCode}'
    '\nResponse Body: ${response.body}',
  );

  return response;
}

Future<dynamic> postCallForFile({
  String tag,
  String url,
  Map<String, String> headers,
  String key,
  File file,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));
  request.headers.addAll(headers);
  request.files.add(await http.MultipartFile.fromPath(
    key,
    file.path,
    filename: file.path.split('/').last,
    contentType: MediaType('application', 'x-tar'),
  ));

  var response = await request.send().timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: POST'
        '\nRequest Headers: $headers'
        '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
    '\nRequest Method: POST'
    '\nRequest Headers: $headers'
    '\nRequest Key: $key'
    '\nRequest File: ${file.path}'
    '\nResponse Code: ${response.statusCode}'
    '\nResponse Body: ${response.toString()}',
  );

  return response;
}

Future<http.Response> putCall({
  String tag,
  String url,
  Map<String, String> headers,
  dynamic body,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  final response = await http.put(url, headers: headers, body: body).timeout(
    timeoutDuration,
    onTimeout: () {
      myLog(
        tag,
        '\nRequest URL: $url'
        '\nRequest Method: PUT'
        '\nRequest Timeout: $url',
      );

      return null;
    },
  );

  myLog(
    tag,
    '\nRequest URL: $url'
    '\nRequest Method: PUT'
    '\nRequest Body: $body'
    '\nResponse Code: ${response.statusCode}'
    '\nResponse Body: ${response.body}',
  );

  return response;
}

Future<http.Response> deleteCall({
  String tag,
  String url,
  Map<String, String> headers,
  dynamic body,
  Duration timeoutDuration = DEFAULT_TIMEOUT_DURATION,
}) async {
  final response = await http
      .delete(url, headers: headers)
      .timeout(timeoutDuration, onTimeout: () {
    myLog(
      tag,
      '\nRequest URL: $url'
      '\nRequest Method: DELETE'
      '\nRequest Timeout: $url',
    );

    return null;
  });

  myLog(
    tag,
    '\nRequest URL: $url'
    '\nRequest Method: DELETE'
    '\nRequest Body: $body'
    '\nResponse Code: ${response.statusCode}'
    '\nResponse Body: ${response.body}',
  );

  return response;
}

void myLog(String tag, String msg) {
  if (kReleaseMode) {
    return;
  }

  log('$tag: $msg');
}
