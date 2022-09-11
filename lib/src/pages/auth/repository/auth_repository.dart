import 'package:greengrocer/src/constants/endpoint.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class AuthRepository {

  final HttpManager _httpManager = HttpManager();

  Future signin({required String email, required String password}) async {
   final result = await _httpManager.restRequest(
      url: Endpoint.signin, 
      method: HttpMethods.post,
      body: {
        'email': email,
        'password': password
      }
    );

    if(result['result'] != null) {
      final user = UserModel.fromMap(result['result']);

      print(user.cpf);
    }  else {
      print('signin não funcionou');
      print(result['error']);
    }
  } 
}