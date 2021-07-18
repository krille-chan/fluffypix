import 'package:http/testing.dart';

import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart';

/// A mock http client for testing purposes.
class MockHttpClient extends MockClient {
  static final calledEndpoints = <String, List<dynamic>>{};
  static int eventCounter = 0;

  MockHttpClient()
      : super((request) async {
          // Collect data from Request
          var action = request.url.path;
          if (request.url.path.contains('/_matrix')) {
            action = request.url.path.split('/_matrix').last +
                '?' +
                request.url.query;
          }

          if (action.endsWith('?')) {
            action = action.substring(0, action.length - 1);
          }
          if (action.endsWith('/')) {
            action = action.substring(0, action.length - 1);
          }
          final method = request.method;
          final data =
              method == 'GET' ? request.url.queryParameters : request.body;
          dynamic res = {};
          var statusCode = 200;

          print('\$method request to $action with Data: $data');

          return Response.bytes(utf8.encode(json.encode(res)), statusCode);
        });
}
