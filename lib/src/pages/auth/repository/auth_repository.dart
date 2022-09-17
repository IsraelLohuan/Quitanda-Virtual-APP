import 'package:greengrocer/src/constants/endpoint.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_errors.dart' as authError;
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class AuthRepository {

  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if(result['result'] != null) {
      return AuthResult.success(UserModel.fromJson(result['result']));
    } 

    return AuthResult.error(authError.authErrorsString(result['error']));
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.validateToken, 
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token
      }
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> signIn({required String email, required String password}) async {
   final result = await _httpManager.restRequest(
      url: Endpoint.signin, 
      method: HttpMethods.post,
      body: {
        'email': email,
        'password': password
      }
    );

    return handleUserOrError(result);  
  } 

  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.signup, 
      method: HttpMethods.post, 
      body: user.toJson() 
    );

    return handleUserOrError(result);
  }
}