import 'package:dio/dio.dart';
import 'package:quiz_app/models/session_token.dart';

class SessionTokenService {
  Dio dio = Dio();
  Future<String> getSessionToken() async {
    String url = 'https://opentdb.com/api_token.php?command=request';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      return Token.fromJson(response.data).token;
    }
    return "session_token";
  }

  Future<String> resetSessionToken({required String token}) async {
    String url = 'https://opentdb.com/api_token.php?command=reset&token=$token';
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      return Token.fromJson(response.data).token;
    }
    return "session_token";
  }
}
