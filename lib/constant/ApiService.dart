import 'dart:convert';

import 'package:pretty_http_logger/pretty_http_logger.dart';


import '../model/common/CommonResponseModel.dart';
import '../utils/session_manager.dart';
import 'api_end_point.dart';
import 'global_context.dart';

class ApiService {
  static Future<dynamic> fetchData() async {
    SessionManager sessionManager = SessionManager();
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(checkToken);

    Map<String, String> jsonBody = {};
    final response = await http.post(url, body: jsonBody, headers: {"Authorization": sessionManager.getAccessToken().toString().trim()});
    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> apiResponse = jsonDecode(body);
    var dataResponse = CommonResponseModel.fromJson(apiResponse);
    if (statusCode == 200 )
    {
      return dataResponse;
    }
    else
    {
      //invalidTokenRedirection(NavigationService.navigatorKey.currentContext);
    }
  }
}