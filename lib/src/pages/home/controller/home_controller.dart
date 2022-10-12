import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

import '../../../models/item_model.dart';
import '../result/home_result.dart';

class HomeController extends GetxController {

  final homeRepository = HomeRepository();

  bool isLoading = false;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  @override 
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();

    getAllProducts();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    HomeResult<CategoryModel> homeResult = await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(
      sucess: (data) {
        allCategories.assignAll(data);

        if(allCategories.isEmpty) return;

        selectCategory(allCategories.first);
      }, 
      error: (message) {
        UtilsServices.showToast(message: message, isError: true);
      }
    );
  }

  Future<void> getAllProducts() async {
    setLoading(true);

    final body = {
      'page': 0,
      'title': null,
      'categoryId': '5mjkt5ERRo',
      'itemsPerPage': 0
    };

    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);

    setLoading(false); 

    result.when(
      sucess: (data) {
        print(data);
      }, 
      error: (message) {
        UtilsServices.showToast(message: message, isError: true);
      }
    );
  }
}