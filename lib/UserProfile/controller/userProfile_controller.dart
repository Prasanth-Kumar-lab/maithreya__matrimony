import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../model/userProfile_model.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileController extends GetxController {
  // User data
  late UserProfile user;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxSet<String> editingSections = <String>{}.obs;
  final isDeleting = false.obs;
  final isUpdating = false.obs;

  // TextEditingControllers managed by controller
  late TextEditingController nameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController dateOfBirthController;
  late TextEditingController ageController;
  late TextEditingController nativePlaceController;
  late TextEditingController stateNameController;
  late TextEditingController cityController;
  late TextEditingController maritalStatusController;
  late TextEditingController heightController;
  late TextEditingController educationDetailsController;
  late TextEditingController foodTypeController;
  late TextEditingController incomeController;
  late TextEditingController professionController;
  late TextEditingController organizationController;
  late TextEditingController roleController;
  late TextEditingController motherNameController;
  late TextEditingController fatherNameController;
  late TextEditingController birthTimeController;
  late TextEditingController noOfSistersController;
  late TextEditingController noOfBrothersController;
  late TextEditingController hobbiesController;
  late TextEditingController favouriteMoviesController;
  late TextEditingController favouriteBooksController;
  late TextEditingController otherInterestsController;
  late TextEditingController aboutController;
  late TextEditingController addressController;
  late TextEditingController casteController;
  late TextEditingController subCasteController;
  final RxList<File> selectedPhotos = <File>[].obs;   // local files before upload
  final RxList<String> serverPhotos = <String>[].obs;

  MyProfileController(this.user);

  @override
  void onInit() {
    super.onInit();
    _initControllers();
    serverPhotos.assignAll(user.photosList ?? []);
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _initControllers() {
    nameController = TextEditingController(text: user.name);
    lastnameController = TextEditingController(text: user.lastname ?? '');
    emailController = TextEditingController(text: user.email ?? '');
    phoneController = TextEditingController(text: user.phone ?? '');
    genderController = TextEditingController(text: user.gender ?? '');
    dateOfBirthController = TextEditingController(text: user.dateOfBirth ?? '');
    ageController = TextEditingController(text: user.age ?? '');
    nativePlaceController = TextEditingController(text: user.nativePlace ?? '');
    stateNameController = TextEditingController(text: user.stateName ?? '');
    cityController = TextEditingController(text: user.city ?? '');
    maritalStatusController = TextEditingController(text: user.maritalStatus ?? '');
    heightController = TextEditingController(text: user.height ?? '');
    educationDetailsController = TextEditingController(text: user.educationDetails ?? '');
    foodTypeController = TextEditingController(text: user.foodType ?? '');
    incomeController = TextEditingController(text: user.income ?? '');
    professionController = TextEditingController(text: user.profession ?? '');
    organizationController = TextEditingController(text: user.organization ?? '');
    roleController = TextEditingController(text: user.role ?? '');
    motherNameController = TextEditingController(text: user.motherName ?? '');
    fatherNameController = TextEditingController(text: user.fatherName ?? '');
    birthTimeController = TextEditingController(text: user.birthTime ?? '');
    noOfSistersController = TextEditingController(text: user.noOfSisters ?? '');
    noOfBrothersController = TextEditingController(text: user.noOfBrothers ?? '');
    hobbiesController = TextEditingController(text: user.hobbies ?? '');
    favouriteMoviesController = TextEditingController(text: user.favouriteMovies ?? '');
    favouriteBooksController = TextEditingController(text: user.favouriteBooks ?? '');
    otherInterestsController = TextEditingController(text: user.otherInterests ?? '');
    aboutController = TextEditingController(text: user.about ?? '');
    addressController = TextEditingController(text: user.address ?? '');
    casteController = TextEditingController(text: user.caste ?? '');
    subCasteController = TextEditingController(text: user.subCaste ?? '');
  }

  void _disposeControllers() {
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();
    ageController.dispose();
    nativePlaceController.dispose();
    stateNameController.dispose();
    cityController.dispose();
    maritalStatusController.dispose();
    heightController.dispose();
    educationDetailsController.dispose();
    foodTypeController.dispose();
    incomeController.dispose();
    professionController.dispose();
    organizationController.dispose();
    roleController.dispose();
    motherNameController.dispose();
    fatherNameController.dispose();
    birthTimeController.dispose();
    noOfSistersController.dispose();
    noOfBrothersController.dispose();
    hobbiesController.dispose();
    favouriteMoviesController.dispose();
    favouriteBooksController.dispose();
    otherInterestsController.dispose();
    aboutController.dispose();
    addressController.dispose();
    casteController.dispose();
    subCasteController.dispose();
  }

  // Image picker logic
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      await _uploadImage();
    }
  }
  // ---- inside MyProfileController ----
  Future<void> pickMultipleImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      selectedPhotos.addAll(picked.map((x) => File(x.path)));
    }
  }

  Future<void> captureImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) selectedPhotos.add(File(img.path));
  }
  void removeLocalPhoto(File file) => selectedPhotos.remove(file);
  Future<void> _uploadImage() async {
    if (selectedImage.value == null) return;

    final data = <String, dynamic>{
      'user_id': user.userId.toString(),
      'image': selectedImage.value!,
    };

    final success = await updateProfile(data);
    if (success) {
      selectedImage.value = null;
    } else {
      selectedImage.value = null;
    }
  }

  // Section management
  void enterEditMode(String section) => editingSections.add(section);
  void exitEditMode(String section) {
    _resetSection(section);
    editingSections.remove(section);
  }

  void _resetSection(String title) {
    switch (title) {
      case 'Basic Info':
        nameController.text = user.name;
        lastnameController.text = user.lastname ?? '';
        phoneController.text = user.phone ?? '';
        genderController.text = user.gender ?? '';
        dateOfBirthController.text = user.dateOfBirth ?? '';
        ageController.text = user.age ?? '';
        maritalStatusController.text = user.maritalStatus ?? '';
        heightController.text = user.height ?? '';
        break;

      case 'Caste Info':
        casteController.text = user.caste ?? '';
        subCasteController.text = user.subCaste ?? '';
        break;

      case 'Location':
        nativePlaceController.text = user.nativePlace ?? '';
        stateNameController.text = user.stateName ?? '';
        cityController.text = user.city ?? '';
        addressController.text = user.address ?? '';
        break;

      case 'Education & Career':
        educationDetailsController.text = user.educationDetails ?? '';
        professionController.text = user.profession ?? '';
        roleController.text = user.role ?? '';
        organizationController.text = user.organization ?? '';
        incomeController.text = user.income ?? '';
        break;

      case 'Family':
        motherNameController.text = user.motherName ?? '';
        fatherNameController.text = user.fatherName ?? '';
        noOfSistersController.text = user.noOfSisters ?? '';
        noOfBrothersController.text = user.noOfBrothers ?? '';
        break;

      case 'Preferences':
        foodTypeController.text = user.foodType ?? '';
        hobbiesController.text = user.hobbies ?? '';
        favouriteMoviesController.text = user.favouriteMovies ?? '';
        favouriteBooksController.text = user.favouriteBooks ?? '';
        otherInterestsController.text = user.otherInterests ?? '';
        break;

      case 'Additional Info':
        birthTimeController.text = user.birthTime ?? '';
        aboutController.text = user.about ?? '';
        break;

      case 'Photos':
        selectedPhotos.clear();          // <-- this works now
        break;
    }
  }

  // Data collection
  Map<String, dynamic> collectFormData() {
    final data = <String, dynamic>{};
    data['user_id'] = user.userId.toString();
    data['name'] = nameController.text;
    data['lastname'] = lastnameController.text;
    data['email'] = emailController.text;
    data['number'] = phoneController.text;
    data['gender'] = genderController.text;
    data['date_of_birth'] = dateOfBirthController.text;
    data['age'] = ageController.text;
    data['native'] = nativePlaceController.text;
    data['state_name'] = stateNameController.text;
    data['city'] = cityController.text;
    data['marital_status'] = maritalStatusController.text;
    data['height'] = heightController.text;
    data['education_details'] = educationDetailsController.text;
    data['food_type'] = foodTypeController.text;
    data['income'] = incomeController.text;
    data['profession'] = professionController.text;
    data['organization'] = organizationController.text;
    data['role'] = roleController.text;
    data['mothername'] = motherNameController.text;
    data['fathername'] = fatherNameController.text;
    data['birth_time'] = birthTimeController.text;
    data['no_of_sisters'] = noOfSistersController.text;
    data['no_of_brothers'] = noOfBrothersController.text;
    data['hobbies'] = hobbiesController.text;
    data['favourite_movies'] = favouriteMoviesController.text;
    data['favourite_books'] = favouriteBooksController.text;
    data['other_intrests'] = otherInterestsController.text;
    data['about'] = aboutController.text;
    data['address'] = addressController.text;
    data['caste'] = casteController.text;
    data['subcaste'] = subCasteController.text;
    return data;
  }

  // Update profile API
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      isUpdating.value = true;

      final request = http.MultipartRequest('POST', Uri.parse(ApiEndPoint.profileApiEndPoint));

      // ---- common fields ----
      profileData.forEach((key, value) {
        if (key != 'image' && key != 'photos_list' && value != null) {
          request.fields[key] = value.toString();
        }
      });

      // ---- single profile image (if changed) ----
      if (profileData['image'] is File) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            (profileData['image'] as File).path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // ---- multiple photos (photos_list[]) ----
      if (profileData['photos_list'] is List<File>) {
        final List<File> photos = profileData['photos_list'];
        for (int i = 0; i < photos.length; i++) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photos_list[$i]',
              photos[i].path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          // update model
          final Map<String, dynamic> updated = {};
          profileData.forEach((k, v) {
            if (k == 'image' && profileData['image'] is File) {
              updated[k] = jsonData['image'] ?? user.image;
            } else if (k == 'photos_list' && profileData['photos_list'] is List<File>) {
              // server returns the new list of URLs
              updated['photos_list'] = jsonData['photos_list'] ?? user.photosList;
            } else {
              updated[k] = v?.toString().isEmpty ?? true ? null : v.toString();
            }
          });

          user = UserProfile.fromJson(updated);
          // sync reactive lists
          serverPhotos.assignAll(user.photosList ?? []);
          selectedPhotos.clear();
          update();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('updateProfile error: $e');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }
  Future<void> savePhotos() async {
    final data = collectFormData();
    if (selectedPhotos.isNotEmpty) {
      data['photos_list'] = selectedPhotos.toList(); // will be handled in updateProfile
    }
    final success = await updateProfile(data);
    if (success) {
      // optional: exit edit mode if you add one
    }
  }

  // Save section methods
  Future<void> saveBasicInfo() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Basic Info');
  }

  Future<void> saveLocation() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Location');
  }

  Future<void> saveEducationCareer() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Education & Career');
  }

  Future<void> saveFamily() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Family');
  }

  Future<void> savePreferences() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Preferences');
  }

  Future<void> saveAdditionalInfo() async {
    final data = collectFormData();
    final success = await updateProfile(data);
    if (success) exitEditMode('Additional Info');
  }

  // Utility methods
  String getDisplayName() {
    if (editingSections.contains('Basic Info')) {
      return '${nameController.text} ${lastnameController.text}'.trim();
    }
    return "${user.name} ${user.lastname ?? ''}".trim();
  }

  ImageProvider? getBackgroundImage() {
    if (selectedImage.value != null) {
      return FileImage(selectedImage.value!);
    } else if (user.image != null && user.image!.isNotEmpty) {
      return NetworkImage(user.image!);
    }
    return null;
  }

  bool get showDefaultIcon => selectedImage.value == null && (user.image == null || user.image!.isEmpty);

  // Existing methods (logout, delete) remain the same...
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('userName');
      _showSuccessSnack('You have been logged out successfully');
      Get.offAllNamed('/login');
    } catch (e) {
      _showErrorSnack('An error occurred during logout: $e');
    }
  }

  void showLogoutConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> deleteAccount() async {
    try {
      isDeleting.value = true;
      final response = await http.post(
        Uri.parse(ApiEndPoint.profileDeleteApi),
        body: {'user_id': user.userId.toString()},
      );

      if (response.statusCode == 200) {
        _showSuccessSnack('Account deleted successfully');
        Get.offAllNamed('/login');
      } else {
        _showErrorSnack('Failed to delete account');
      }
    } catch (e) {
      _showErrorSnack('An error occurred: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  void showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('No')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteAccount();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showSuccessSnack(String message) {
    Get.snackbar('Success', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white);
  }

  void _showErrorSnack(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white);
  }
}