import 'package:greengrocer/src/constants/endpoint.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_errors.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class AuthRepository {

  final HttpManager _httpManager = HttpManager();

  Future<AuthResult> signIn({required String email, required String password}) async {
   final result = await _httpManager.restRequest(
      url: Endpoint.signin, 
      method: HttpMethods.post,
      body: {
        'email': email,
        'password': password
      }
    );

    if(result['result'] != null) {
      return AuthResult.success(UserModel.fromJson(result['result']));
    } 

    return AuthResult.error(authErrorsString(result['error']));
  } 
}