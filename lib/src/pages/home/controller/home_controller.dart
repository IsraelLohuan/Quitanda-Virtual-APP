import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

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
}