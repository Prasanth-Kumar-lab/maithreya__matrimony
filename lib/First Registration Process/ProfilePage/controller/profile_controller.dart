// Updated lib/controller/profile_controller.dart
import 'package:get/get.dart';
import '../model/profile_model.dart';

class ProfileController extends GetxController {
  late ProfileModel profile;
  var isLoaded = false.obs;

  ProfileController({required String userId, required String userName}) {
    profile = ProfileModel(
      userId: userId,
      firstName: userName
          .split(' ')
          .first,
      lastName: userName
          .split(' ')
          .length > 1 ? userName.split(' ').sublist(1).join(' ') : '',
      gender: "Male",
      dob: '',
      age: 0,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }
}