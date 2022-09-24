import 'package:greengrocer/src/constants/endpoint.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  getAllCategories() async {
    final result = await _httpManager.restRequest(
      url: Endpoint.getAllCategories, 
      method: HttpMethods.post,
    );

    if(result['result'] != null) {

    } else {
      
    }
  }
}