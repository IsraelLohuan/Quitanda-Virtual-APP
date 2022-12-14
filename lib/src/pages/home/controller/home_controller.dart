import 'package:get/get.dart';
import 'package:greengrocer/src/models/category_model.dart';
import 'package:greengrocer/src/pages/home/repository/home_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

import '../../../models/item_model.dart';
import '../result/home_result.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {

  final homeRepository = HomeRepository();

  bool isCategoryLoading = false;
  bool isProductLoading = true;
  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;
  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  Rx<String> searchTitle = ''.obs;

  bool get isLastPage {
    if(currentCategory!.items.length < itemsPerPage) {
      return true;
    }

    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  @override 
  void onInit() {
    super.onInit();

    debounce(searchTitle, (_) => filterByTitle(), time: const Duration(milliseconds: 600));

    getAllCategories();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();

    if(currentCategory!.items.isNotEmpty) return;

    getAllProducts();
  }

  void setLoading(bool value, {bool isProduct = false}) {

    if(!isProduct) {
      isCategoryLoading = value;
    } else {
      isProductLoading = value;
    }
    
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

  void filterByTitle() {
    for(var category in allCategories) {
      category.items.clear();
      category.pagination = 0;
    }

    if(searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {

      CategoryModel? c = allCategories.firstWhereOrNull((category) => category.id == '');

      if(c == null) {
        final allProductsCategory = CategoryModel(
          title: 'Todos', 
          id: '', 
          items: [], 
          pagination: 0
        );

        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    currentCategory = allCategories.first;
    update();
    getAllProducts();
  }

  void loadMoreProducts() {
    currentCategory!.pagination ++;
    getAllProducts(canLoad: false);
  }

  Future<void> getAllProducts({bool canLoad = true}) async {

    if(canLoad) {
      setLoading(true, isProduct: true);
    }
    
    final body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      'itemsPerPage': itemsPerPage
    };

    if(searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;

      if(currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

    HomeResult<ItemModel> result = await homeRepository.getAllProducts(body);

    setLoading(false, isProduct: true); 

    result.when(
      sucess: (data) {
        currentCategory!.items.addAll(data);
      }, 
      error: (message) {
        UtilsServices.showToast(message: message, isError: true);
      }
    );
  }
}