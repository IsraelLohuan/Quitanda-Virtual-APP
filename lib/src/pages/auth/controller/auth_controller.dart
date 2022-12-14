import 'package:get/get.dart';
import 'package:greengrocer/src/constants/storage_keys.dart';
import 'package:greengrocer/src/models/user_model.dart';
import 'package:greengrocer/src/pages/auth/repository/auth_repository.dart';
import 'package:greengrocer/src/pages/auth/result/auth_result.dart';
import 'package:greengrocer/src/pages_routes/app_pages.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class AuthController extends GetxController {

  RxBool isLoading = false.obs;

  final utilsServices = UtilsServices();
  final authRepository = AuthRepository();

  UserModel user = UserModel();

  @override 
  void onInit() {
    super.onInit();
    validateToken();
  }

  Future<void> validateToken() async {
    final String? token = await utilsServices.getLocalData(key: StorageKeys.token);
   
    if(token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();  
      }, 
      error: (message) {
        signOut();
      }
    );
  }

  Future<void> signOut() async {
    user = UserModel();
    await utilsServices.removeLocalData(key: StorageKeys.token);
    Get.offAllNamed(PagesRoutes.signInRoute);
  }

  void saveTokenAndProceedToBase() {
    utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);
    Get.offAllNamed(PagesRoutes.baseRoute);  
  }

  Future<void> signUp() async {
    isLoading.value = true;

    AuthResult result = await authRepository.signUp(user);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      }, 
      error: (message) => UtilsServices.showToast(message: message, isError: true)
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    AuthResult result = await authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProceedToBase();
      }, 
      error: (message) => UtilsServices.showToast(message: message, isError: true)
    );
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    isLoading.value = true;

    final result = await authRepository.changePassword(
      email: user.email!, 
      currentPassword: currentPassword, 
      newPassword: newPassword, 
      token: user.token!
    );

    isLoading.value = false;

    if(result) {  
      UtilsServices.showToast(message: 'Senha foi atualizada com sucesso!');
      signOut();
    } else {
      UtilsServices.showToast(message: 'Senha atual est?? incorreta!', isError: true);
    }
  }
}