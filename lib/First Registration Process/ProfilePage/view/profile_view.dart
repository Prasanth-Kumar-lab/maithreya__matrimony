import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:matrimony/apiEndPoint.dart';
import '../../../constants/constants.dart';
import '../../ProgressIndicator/status_indicator.dart';
import '../../widgets/selectable_options.dart';
import '../../widgets/textfield.dart';
import '../../../HomeScreen/controller/home_screen_controller.dart';
import '../../../UserProfile/model/userProfile_model.dart';
import '../../LocationDetails/controller/location_controller.dart';
import '../../MaritalDetails/controller/marital_controller.dart';
import '../../../HomeScreen/view/home_screen_view.dart';

class CompleteProfileScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final int initialStep;

  const CompleteProfileScreen({
    Key? key,
    required this.userId,
    required this.userName,
    this.initialStep = 1,
  }) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with TickerProviderStateMixin {
  late int currentStep;

  late TextEditingController _firstNameController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _ageController;
  final Rx<File?> selectedImage = Rx<File?>(null);
  String? imageUrl;
  bool _isSubmitting = false;

  // Location
  late LocationController locationController;
  final TextEditingController _addressController = TextEditingController();

  // Marital
  late MaritalDetailsController maritalController;

  // Professional
  late TextEditingController annualIncomeController;
  late TextEditingController professionController;
  late TextEditingController workingOrganizationController;
  late TextEditingController roleController;
  bool showAnnualIncomeOther = false;
  bool showProfessionOther = false;
  bool showHobbiesOther = false;
  bool showInterestsOther = false;
  // Multiple select for hobbies and interests
  Set<String> selectedHobbies = <String>{};
  Set<String> selectedInterests = <String>{};
  late TextEditingController hobbiesOtherController;
  late TextEditingController interestsOtherController;

  // Family
  late TextEditingController motherNameController;
  late TextEditingController fatherNameController;
  late TextEditingController birthTimeController;
  late TextEditingController sistersController;
  late TextEditingController brothersController;

  // Lifestyle
  late TextEditingController hobbiesController;
  late TextEditingController moviesController;
  late TextEditingController booksController;
  late TextEditingController interestsController;
  late TextEditingController religionController;

  // About
  late TextEditingController aboutController;
  final RxList<File> selectedPhotosList = RxList<File>([]);

  // Zodiac, Caste, Subcaste
  String? selectedZodiacSign;
  String? selectedCaste;
  String? selectedSubCaste;
  final List<Map<String, dynamic>> _casteList = [];
  final List<Map<String, dynamic>> _subCasteList = [];
  final List<Map<String, dynamic>> _allSubCasteList = [];
  String? selectedCasteId;

  final HomeController _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchCastes();
      await _fetchSubCastes(); // Now fetches ALL subcastes once
      await _fetchProfileData();
    });
  }

  void _initializeControllers() {
    // Profile
    _firstNameController =
        TextEditingController(text: widget.userName.split(' ').first);
    _dobController = TextEditingController();
    _genderController = TextEditingController();
    _ageController = TextEditingController();
    _dobController.addListener(_updateAge);

    // Professional
    annualIncomeController = TextEditingController();
    professionController = TextEditingController();
    workingOrganizationController = TextEditingController();
    roleController = TextEditingController();

    // Family
    motherNameController = TextEditingController();
    fatherNameController = TextEditingController();
    birthTimeController = TextEditingController();
    sistersController = TextEditingController();
    brothersController = TextEditingController();

    // Lifestyle (remove hobbiesController and interestsController)
    moviesController = TextEditingController();
    booksController = TextEditingController();

    // About
    aboutController = TextEditingController();

    // Location
    locationController = LocationController();
    religionController = TextEditingController();

    // Multiple select controllers
    hobbiesOtherController = TextEditingController();
    interestsOtherController = TextEditingController();

    // Marital
    maritalController = MaritalDetailsController();
    maritalController.initListeners();
  }

  // ──────────────────────────────────────
  // Image helpers
  Future<void> _pickMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        selectedPhotosList.addAll(images.map((img) => File(img.path)));
      });
    }
  }

  Future<void> _captureImageForPhotosList() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedPhotosList.add(File(image.path));
      });
    }
  }

  Future<void> _fetchCastes() async {
    try {
      final resp = await http.get(Uri.parse(ApiEndPoint.getCasteApiEndPoint));
      if (resp.statusCode != 200) return;

      final dynamic json = jsonDecode(resp.body);
      List<Map<String, dynamic>> list = [];

      if (json is Map<String, dynamic> && json['status'] == 'success') {
        final data = json['castes'];
        if (data is List) {
          list = data.cast<Map<String, dynamic>>();
        }
      }

      if (mounted) {
        setState(() {
          _casteList.clear();
          _casteList.addAll(list);
        });
      }
    } catch (e) {
      debugPrint('fetch castes error: $e');
    }
  }

  // ── FETCH SUB-CASTES (filtered by caste_name) ─────
  Future<void> _fetchSubCastes() async {
    // This now fetches ALL subcastes once (no parameter needed)
    try {
      final uri = Uri.parse(ApiEndPoint.getSubCasteApiEndPoint); // Remove ?name= param
      final resp = await http.get(uri);
      if (resp.statusCode != 200) return;

      final dynamic json = jsonDecode(resp.body);
      List<Map<String, dynamic>> list = [];

      if (json is Map<String, dynamic> && json['status'] == 'success') {
        final data = json['subcastes'];
        if (data is List) {
          list = data.cast<Map<String, dynamic>>();
        }
      }

      if (mounted) {
        setState(() {
          _allSubCasteList.clear();
          _allSubCasteList.addAll(list);

          // If a caste is already selected (e.g., when editing profile), filter immediately
          if (selectedCasteId != null) {
            _filterSubCastesByCasteId(selectedCasteId!);
          } else {
            _subCasteList.clear();
          }
        });
      }
    } catch (e) {
      debugPrint('fetch all sub-castes error: $e');
    }
  }

  void _filterSubCastesByCasteId(String casteId) {
    final filtered = _allSubCasteList
        .where((sub) => sub['caste_id'].toString() == casteId)
        .toList();

    setState(() {
      _subCasteList.clear();
      _subCasteList.addAll(filtered);
    });
  }

  Future<void> _fetchProfileData() async {
    try {
      UserProfile? profile =
      await _homeController.fetchMyProfile(widget.userId);
      if (profile != null && mounted) {
        setState(() {
          _firstNameController.text =
          profile.name?.isNotEmpty == true ? profile.name! : widget.userName;
          _dobController.text = profile.dateOfBirth ?? '';
          _genderController.text = profile.gender ?? '';
          _ageController.text = profile.age ?? '';
          imageUrl = profile.image;
        });
        if (profile.image != null && profile.image!.startsWith('http')) {
          try {
            selectedImage.value = await _downloadImage(profile.image!);
          } catch (e) {
            debugPrint('Error downloading image: $e');
          }
        }

        // Location
        locationController.nativePlaceController.text = profile.nativePlace ?? '';
        locationController.setSelectedState(profile.stateName ?? '');
        locationController.cityController.text = profile.city ?? '';
        _addressController.text = profile.address ?? '';

        // Marital
        maritalController.maritalStatus = profile.maritalStatus ?? '';
        maritalController.heightController.text = profile.height ?? '';
        maritalController.educationalDetailsController.text =
            profile.educationDetails ?? '';
        maritalController.foodType = profile.foodType ?? '';

        // Professional
        annualIncomeController.text = profile.income ?? '';
        if (profile.income != null &&
            !['2L+', '3L+', '5L+', '7L+', '10L+'].contains(profile.income!) &&
            profile.income!.isNotEmpty) {
          showAnnualIncomeOther = true;
        }
        professionController.text = profile.profession ?? '';
        if (profile.profession != null &&
            !['Teacher', 'Doctor', 'Nurse', 'Software', 'Business']
                .contains(profile.profession!) &&
            profile.profession!.isNotEmpty) {
          showProfessionOther = true;
        }
        workingOrganizationController.text = profile.organization ?? '';
        roleController.text = profile.role ?? '';

        // Family
        motherNameController.text = profile.motherName ?? '';
        fatherNameController.text = profile.fatherName ?? '';
        birthTimeController.text = profile.birthTime ?? '';
        sistersController.text = profile.noOfSisters ?? '';
        brothersController.text = profile.noOfBrothers ?? '';

        // Lifestyle
        hobbiesController.text = profile.hobbies ?? '';
        // Lifestyle
        if (profile.hobbies != null && profile.hobbies!.isNotEmpty) {
          final hobbyList = profile.hobbies!.split(',').map((h) => h.trim()).where((h) => h.isNotEmpty);
          selectedHobbies.addAll(hobbyList);
          if (selectedHobbies.any((h) => !['Reading', 'Traveling', 'Music', 'Sports', 'Cooking', 'Dancing'].contains(h))) {
            showHobbiesOther = true;
          }
        }
        moviesController.text = profile.favouriteMovies ?? '';
        booksController.text = profile.favouriteBooks ?? '';
        if (profile.otherInterests != null && profile.otherInterests!.isNotEmpty) {
          final interestList = profile.otherInterests!.split(',').map((i) => i.trim()).where((i) => i.isNotEmpty);
          selectedInterests.addAll(interestList);
          if (selectedInterests.any((i) => !['Fitness', 'Movies', 'Yoga', 'Gaming', 'Art'].contains(i))) {
            showInterestsOther = true;
          }
        }

        // About
        aboutController.text = profile.about ?? '';
        religionController.text = profile.religion ?? '';

        // Zodiac, Caste, Subcaste
        selectedZodiacSign = profile.zodiacSign;
        selectedCaste = profile.caste;
        selectedSubCaste = profile.subCaste;
        if (selectedCaste != null && selectedCaste!.isNotEmpty) {
          await _fetchSubCastes();
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<File> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/profile_image_${widget.userId}.jpg');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download image');
    }
  }

  // ──────────────────────────────────────
  // Age calculation
  void _updateAge() {
    final dobStr = _dobController.text;
    if (dobStr.isEmpty) return;
    final parts = dobStr.split('-');
    if (parts.length != 3) return;
    try {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < month || (now.month == month && now.day < day)) age--;
      _ageController.text = age.toString();
    } catch (_) {
      _ageController.text = '';
    }
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
      '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  Future<XFile?> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> _captureImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    return picker.pickImage(source: ImageSource.camera);
  }

  // ──────────────────────────────────────
  // Upload helpers
  Future<bool> _uploadProfileData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      if (selectedImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          selectedImage.value!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Profile upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadLocationData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['native'] = locationController.nativePlaceController.text;
      request.fields['state_name'] =
      locationController.selectedState.value.isNotEmpty
          ? locationController.selectedState.value
          : '';
      request.fields['city'] = locationController.cityController.text;
      request.fields['address'] = _addressController.text;
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Location upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadMaritalData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['marital_status'] = maritalController.maritalStatus;
      request.fields['height'] = maritalController.heightController.text;
      request.fields['education_details'] =
          maritalController.educationalDetailsController.text;
      request.fields['food_type'] = maritalController.foodType;
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Marital upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadProfessionalData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['income'] = annualIncomeController.text.trim();
      request.fields['profession'] = professionController.text.trim();
      request.fields['organization'] =
          workingOrganizationController.text.trim();
      request.fields['role'] = roleController.text.trim();
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Professional upload error: $e');
      return false;
    }
  }

  // UPDATED – Zodiac, Caste, Subcaste upload
  Future<bool> _uploadZodiacData() async {
    if (selectedZodiacSign == null ||
        selectedCaste == null ||
        selectedSubCaste == null) return false;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['zodiac_sign'] = selectedZodiacSign!;
      request.fields['caste'] = selectedCaste!;
      request.fields['subcaste'] = selectedSubCaste!;
      request.fields['religion'] = religionController.text;
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Zodiac/Caste upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadFamilyData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['mothername'] = motherNameController.text.trim();
      request.fields['fathername'] = fatherNameController.text.trim();
      request.fields['birth_time'] = birthTimeController.text.trim();
      request.fields['no_of_sisters'] = sistersController.text.trim();
      request.fields['no_of_brothers'] = brothersController.text.trim();
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Family upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadLifestyleData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['hobbies'] = selectedHobbies.join(', ');
      request.fields['favourite_movies'] = moviesController.text.trim();
      request.fields['favourite_books'] = booksController.text.trim();
      request.fields['other_intrests'] = selectedInterests.join(', ');
      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Lifestyle upload error: $e');
      return false;
    }
  }

  Future<bool> _uploadAboutData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );
      request.fields['user_id'] = widget.userId;
      request.fields['name'] = _firstNameController.text;
      request.fields['date_of_birth'] = _dobController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['age'] = _ageController.text;
      request.fields['about'] = aboutController.text.trim();

      for (int i = 0; i < selectedPhotosList.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photos_list[$i]',
            selectedPhotosList[i].path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('About upload error: $e');
      return false;
    }
  }

  // ──────────────────────────────────────
  // Determine next incomplete step
  Future<int> _determineNextStep() async {
    UserProfile? profile = await _homeController.fetchMyProfile(widget.userId);
    if (profile == null) return 1;

    // 1 Profile
    if (profile.name == null ||
        profile.name!.isEmpty ||
        profile.dateOfBirth == null ||
        profile.dateOfBirth!.isEmpty ||
        profile.gender == null ||
        profile.gender!.isEmpty ||
        profile.age == null ||
        profile.age!.isEmpty ||
        profile.image == null ||
        profile.image!.isEmpty) {
      return 1;
    }
    // 2 Location
    if (profile.nativePlace == null ||
        profile.nativePlace!.isEmpty ||
        profile.stateName == null ||
        profile.stateName!.isEmpty ||
        profile.city == null ||
        profile.city!.isEmpty ||
        profile.address == null ||
        profile.address!.isEmpty) {
      return 2;
    }
    // 3 Marital
    if (profile.maritalStatus == null ||
        profile.maritalStatus!.isEmpty ||
        profile.height == null ||
        profile.height!.isEmpty ||
        profile.educationDetails == null ||
        profile.educationDetails!.isEmpty ||
        profile.foodType == null ||
        profile.foodType!.isEmpty) {
      return 3;
    }
    // 4 Professional
    if (profile.income == null ||
        profile.income!.isEmpty ||
        profile.profession == null ||
        profile.profession!.isEmpty ||
        profile.organization == null ||
        profile.organization!.isEmpty ||
        profile.role == null ||
        profile.role!.isEmpty) {
      return 4;
    }
    // 5 Caste, Subcaste, Zodiac
    if (profile.caste == null ||
        profile.caste!.isEmpty ||
        profile.subCaste == null ||
        profile.subCaste!.isEmpty ||
        profile.zodiacSign == null ||
        profile.zodiacSign!.isEmpty||
    profile.religion == null||
      profile.religion!.isEmpty) {
      return 5;
    }
    // 6 Family
    if (profile.motherName == null ||
        profile.motherName!.isEmpty ||
        profile.fatherName == null ||
        profile.fatherName!.isEmpty ||
        profile.birthTime == null ||
        profile.birthTime!.isEmpty ||
        profile.noOfSisters == null ||
        profile.noOfSisters!.isEmpty ||
        profile.noOfBrothers == null ||
        profile.noOfBrothers!.isEmpty) {
      return 6;
    }
    // 7 Lifestyle
    if (profile.hobbies == null ||
        profile.hobbies!.isEmpty ||
        profile.favouriteMovies == null ||
        profile.favouriteMovies!.isEmpty ||
        profile.favouriteBooks == null ||
        profile.favouriteBooks!.isEmpty ||
        profile.otherInterests == null ||
        profile.otherInterests!.isEmpty) {
      return 7;
    }
    // 8 About
    if (profile.about == null || profile.about!.isEmpty) {
      return 8;
    }
    return 0;
  }

  // ──────────────────────────────────────
  // Continue button handler
  Future<void> _onContinue() async {
    if (currentStep == 1) {
      if (selectedImage.value == null &&
          (imageUrl == null || imageUrl!.isEmpty)) {
        _showSnack('Please select an image');
        return;
      }
      if (_firstNameController.text.isEmpty ||
          _dobController.text.isEmpty ||
          _genderController.text.isEmpty ||
          _ageController.text.isEmpty) {
        _showSnack('Please fill all fields');
        return;
      }
      _showLoading();
      bool success = await _uploadProfileData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 2) {
      if (!locationController.validateInputs() ||
          _addressController.text.isEmpty) {
        _showSnack('Please fill all location fields');
        return;
      }
      _showLoading();
      bool success = await _uploadLocationData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 3) {
      if (maritalController.maritalStatus.isEmpty ||
          maritalController.heightController.text.isEmpty ||
          maritalController.educationalDetailsController.text.isEmpty ||
          maritalController.foodType.isEmpty) {
        _showSnack('Please fill all marital fields');
        return;
      }
      _showLoading();
      bool success = await _uploadMaritalData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 4) {
      if (annualIncomeController.text.trim().isEmpty ||
          professionController.text.trim().isEmpty ||
          workingOrganizationController.text.trim().isEmpty ||
          roleController.text.trim().isEmpty) {
        _showSnack('Please fill all professional fields');
        return;
      }
      _showLoading();
      bool success = await _uploadProfessionalData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 5) {
      // Zodiac, Caste, Subcaste
      if (selectedZodiacSign == null ||
          selectedCaste == null ||
          selectedSubCaste == null||
          religionController == null) {


        _showSnack('Please select your caste, subcaste and zodiac sign');
        return;
      }
      _showLoading();
      bool success = await _uploadZodiacData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 6) {
      // Family
      if (motherNameController.text.trim().isEmpty ||
          fatherNameController.text.trim().isEmpty ||
          birthTimeController.text.trim().isEmpty ||
          sistersController.text.trim().isEmpty ||
          brothersController.text.trim().isEmpty) {
        _showSnack('Please fill all family fields');
        return;
      }
      _showLoading();
      bool success = await _uploadFamilyData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 7) {
      // Lifestyle
      if (selectedHobbies.isEmpty ||
          moviesController.text.trim().isEmpty ||
          booksController.text.trim().isEmpty ||
          selectedInterests.isEmpty) {
        _showSnack('Please fill all lifestyle fields');
        return;
      }
      _showLoading();
      bool success = await _uploadLifestyleData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    } else if (currentStep == 8) {
      // About
      if (aboutController.text.trim().isEmpty) {
        _showSnack('Please fill the about field');
        return;
      }
      if (selectedPhotosList.isEmpty) {
        _showSnack('Please select at least one photo');
        return;
      }
      _showLoading();
      bool success = await _uploadAboutData();
      if (mounted) Navigator.pop(context);
      if (success) _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    int nextStep = await _determineNextStep();
    if (nextStep == 0) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(userId: widget.userId),
          ),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          currentStep = nextStep;
        });
      }
    }
  }

  void _showLoading() {
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'Complete Your Profile';
      case 2:
        return 'Complete Your Location Details';
      case 3:
        return 'Complete Your Marital Details';
      case 4:
        return 'Complete Your Professional Details';
      case 5:
        return 'Select Your Caste & Zodiac Sign';
      case 6:
        return 'Complete Your Family Details';
      case 7:
        return 'Complete Your Lifestyle Details';
      case 8:
        return 'Tell Us About Yourself';
      default:
        return '';
    }
  }

  // ──────────────────────────────────────
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            const SizedBox(height: 0),
            Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Lottie.asset(
                    LottieAssets.registrationLottie,
                    fit: BoxFit.cover,
                    repeat: false,
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 8),
                    RegistrationProgressIndicator(
                      currentStep: currentStep,
                      totalSteps: 8,
                      stepTitles: ProgressIndicatorTiles.tiles
                          .where((t) => t != 'Caste Details')
                          .toList(),
                    ),
                    Text(
                      _getStepTitle(currentStep),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      RegistrationTitles.registrationSubTitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.registrationProcess,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> anim) {
                    final offsetAnim = Tween<Offset>(
                        begin: const Offset(1.0, 0.0), end: Offset.zero)
                        .animate(
                        CurvedAnimation(parent: anim, curve: Curves.easeInOut));
                    return SlideTransition(position: offsetAnim, child: child);
                  },
                  child: _buildFormForStep(currentStep),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormForStep(int step) {
    switch (step) {
      case 1:
        return _buildProfileForm();
      case 2:
        return _buildLocationForm();
      case 3:
        return _buildMaritalForm();
      case 4:
        return _buildProfessionalForm();
      case 5:
        return _buildZodiacForm(); // UPDATED
      case 6:
        return _buildFamilyForm();
      case 7:
        return _buildLifestyleForm();
      case 8:
        return _buildAboutForm();
      default:
        return const SizedBox.shrink();
    }
  }

  // ──────────────────────────────────────
  // 1 Profile
  Widget _buildProfileForm() {
    return SingleChildScrollView(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                Obx(() => CircleAvatar(
                  radius: 60,
                  backgroundImage: selectedImage.value != null
                      ? FileImage(selectedImage.value!)
                      : imageUrl != null && imageUrl!.isNotEmpty
                      ? NetworkImage(imageUrl!)
                      : const AssetImage('assets/default.jpg')
                  as ImageProvider,
                )),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.image,
                            size: 20, color: Colors.deepPurple),
                        onPressed: () async {
                          final XFile? img = await _pickImageFromGallery();
                          if (img != null) {
                            selectedImage.value = File(img.path);
                            imageUrl = null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 20, color: Colors.deepPurple),
                        onPressed: () async {
                          final XFile? img = await _captureImageFromCamera();
                          if (img != null) {
                            selectedImage.value = File(img.path);
                            imageUrl = null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Chips.formButtonHeight,
          CustomTextField(controller: _firstNameController, label: 'First Name'),
          Chips.formTextfieldHeight,
          CustomTextField(
            controller: _dobController,
            label: 'Date of birth',
            readOnly: true,
            onTap: _pickDate,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            controller: _ageController,
            readOnly: true,
            label: 'Age',
          ),
          Chips.formTextfieldHeight,
          _buildGenderSelection(),
          Chips.formButtonHeight,
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Gender', style: Chips.selectableChipTextStyle),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: [
            buildSelectableChip(
              label: 'Male',
              icon: Icons.male,
              isSelected: _genderController.text == 'Male',
              onTap: () => setState(() => _genderController.text = 'Male'),
            ),
            buildSelectableChip(
              label: 'Female',
              icon: Icons.female,
              isSelected: _genderController.text == 'Female',
              onTap: () => setState(() => _genderController.text = 'Female'),
            ),
            buildSelectableChip(
              label: 'Other',
              icon: Icons.transgender,
              isSelected: _genderController.text == 'Other',
              onTap: () => setState(() => _genderController.text = 'Other'),
            ),
            buildSelectableChip(
              label: 'Prefer not to say',
              icon: Icons.help_outline,
              isSelected: _genderController.text == 'Prefer not to say',
              onTap: () => setState(
                      () => _genderController.text = 'Prefer not to say'),
            ),
          ],
        ),
      ],
    );
  }

  // ──────────────────────────────────────
  // 2 Location
  Widget _buildLocationForm() {
    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
              label: 'Birth Place',
              controller: locationController.nativePlaceController),
          Chips.formTextfieldHeight,
          DropdownButtonFormField<String>(
            value: locationController.selectedState.isNotEmpty &&
                locationController.states
                    .contains(locationController.selectedState.value)
                ? locationController.selectedState.value
                : null,
            decoration: InputDecoration(
              labelText: 'State Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: locationController.states
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) =>
                setState(() => locationController.setSelectedState(v ?? '')),
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
              label: 'City Name', controller: locationController.cityController),
          Chips.formTextfieldHeight,
          CustomTextField(label: 'Full Address', controller: _addressController),
          Chips.formButtonHeight,
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // 3 Marital
  Widget _buildMaritalForm() {
    return SingleChildScrollView(
      key: const ValueKey(3),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Marital Status', style: Chips.selectableChipTextStyle),
          const SizedBox(height: 5),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 4,
            children: maritalController.maritalStatusOptions
                .map((status) => buildSelectableChip(
              label: status,
              icon: Icons.person_outline,
              isSelected: maritalController.maritalStatus == status,
              onTap: () => setState(
                      () => maritalController.maritalStatus = status),
            ))
                .toList(),
          ),
          Chips.formTextfieldHeight,
          const Text('Food Type', style: Chips.selectableChipTextStyle),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 4,
            children: maritalController.foodTypeOptions
                .map((food) => buildSelectableChip(
              label: food,
              icon: Icons.restaurant_outlined,
              isSelected: maritalController.foodType == food,
              onTap: () =>
                  setState(() => maritalController.foodType = food),
            ))
                .toList(),
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
              label: 'Height', controller: maritalController.heightController),
          Chips.formTextfieldHeight,
          CustomTextField(
              label: 'Educational Details',
              controller: maritalController.educationalDetailsController),
          const SizedBox(height: 32),
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // 4 Professional
  Widget _buildProfessionalForm() {
    return SingleChildScrollView(
      key: const ValueKey(4),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Annual Income
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Annual Income (LPA)',
                  style: Chips.selectableChipTextStyle),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3,
                children: ['2L+', '3L+', '5L+', '7L+', '10L+', 'Other']
                    .map((income) {
                  final isSelected = annualIncomeController.text == income ||
                      (income == 'Other' && showAnnualIncomeOther);
                  return buildSelectableChip(
                    label: income,
                    icon: Icons.currency_rupee_outlined,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (income == 'Other') {
                          showAnnualIncomeOther = true;
                          annualIncomeController.text = '';
                        } else {
                          showAnnualIncomeOther = false;
                          annualIncomeController.text = income;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (showAnnualIncomeOther)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: annualIncomeController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Enter Annual Income',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() {
                      showAnnualIncomeOther = val.isNotEmpty;
                    }),
                  ),
                ),
            ],
          ),
          Chips.formTextfieldHeight,
          // Profession
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select Profession',
                  style: Chips.selectableChipTextStyle),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3,
                children: [
                  'Teacher',
                  'Doctor',
                  'Nurse',
                  'Software',
                  'Business',
                  'Other'
                ].map((profession) {
                  IconData icon;
                  switch (profession) {
                    case 'Teacher':
                      icon = Icons.school_outlined;
                      break;
                    case 'Software':
                      icon = Icons.computer_outlined;
                      break;
                    case 'Doctor':
                      icon = Icons.local_hospital_outlined;
                      break;
                    case 'Nurse':
                      icon = Icons.medical_services_outlined;
                      break;
                    case 'Business':
                      icon = Icons.store_outlined;
                      break;
                    default:
                      icon = Icons.work_outline;
                  }
                  final isSelected = professionController.text == profession ||
                      (profession == 'Other' && showProfessionOther);
                  return buildSelectableChip(
                    label: profession,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (profession == 'Other') {
                          showProfessionOther = true;
                          professionController.text = '';
                        } else {
                          showProfessionOther = false;
                          professionController.text = profession;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (showProfessionOther)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: professionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: 'Enter Profession',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) => setState(() {
                      showProfessionOther = val.isNotEmpty;
                    }),
                  ),
                ),
            ],
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Working Organization Name',
            controller: workingOrganizationController,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Role',
            controller: roleController,
          ),
          Chips.formButtonHeight,
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // 5 Zodiac, Caste, Subcaste (UPDATED)
  Widget _buildZodiacForm() {
    final zodiacs = [
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces'
    ];

    return SingleChildScrollView(
      key: const ValueKey(5),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),

          // ---------- ZODIAC ----------
          const Text('Select Your Zodiac Sign',
              style: Chips.selectableChipTextStyle),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 3,
            children: zodiacs.map((sign) => buildSelectableChip(
              label: sign,
              icon: Icons.star_outline,
              isSelected: selectedZodiacSign == sign,
              onTap: () => setState(() => selectedZodiacSign = sign),
            )).toList(),
          ),
          const SizedBox(height: 32),

          // ---------- CASTE ----------
          const Text('Select Your Caste',
              style: Chips.selectableChipTextStyle),
          const SizedBox(height: 12),
          _casteList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 3,
            children: _casteList.map((caste) {
              final name = caste['caste_name']?.toString() ?? '';
              return buildSelectableChip(
                label: name,
                icon: Icons.groups_outlined,
                isSelected: selectedCaste == name,
                onTap: () {
                  final String casteId = caste['id'].toString();
                  setState(() {
                    selectedCaste = name;
                    selectedCasteId = casteId;
                    selectedSubCaste = null;
                    _subCasteList.clear();
                  });
                  _filterSubCastesByCasteId(casteId);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // ---------- SUB-CASTE ----------
          if (selectedCaste != null && selectedCaste!.isNotEmpty) ...[
            const Text('Select Your Sub-Caste',
                style: Chips.selectableChipTextStyle),
            const SizedBox(height: 12),
            _subCasteList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : (_subCasteList.isNotEmpty
                ? GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 3,
              children: _subCasteList.map((sub) {
                final name = sub['subcaste_name']?.toString() ?? '';
                return buildSelectableChip(
                  label: name,
                  icon: Icons.group_add_outlined,
                  isSelected: selectedSubCaste == name,
                  onTap: () => setState(() => selectedSubCaste = name),
                );
              }).toList(),
            )
                : const SizedBox(
                height: 100,
                child: Center(
                  child: Text('No subcastes available',
                      style: TextStyle(color: Colors.grey)),
                ))),
          ],
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Religion',
            controller: religionController,
          ),
          const SizedBox(height: 40),
          _buildContinueButton(),
        ],
      ),
    );
  }

  // 6 Family
  Widget _buildFamilyForm() {
    return SingleChildScrollView(
      key: const ValueKey(6),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          CustomTextField(
            label: 'Mother Name',
            controller: motherNameController,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Father Name',
            controller: fatherNameController,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Birth Time',
            controller: birthTimeController,
            readOnly: true,
            onTap: () async {
              String initialText = birthTimeController.text;
              int initialHour = DateTime.now().hour;
              int initialMinute = DateTime.now().minute;
              int initialSecond = 0;
              bool isPM = false;

              if (initialText.isNotEmpty) {
                try {
                  // Parse format like "3:45:00 PM" or "03:45:00 PM"
                  final regex = RegExp(r'(\d{1,2}):(\d{2}):(\d{2})\s*(AM|PM)');
                  final match = regex.firstMatch(initialText);
                  if (match != null) {
                    initialHour = int.parse(match.group(1)!);
                    initialMinute = int.parse(match.group(2)!);
                    initialSecond = int.parse(match.group(3)!);
                    isPM = match.group(4) == 'PM';
                    if (isPM && initialHour != 12) initialHour += 12;
                    else if (!isPM && initialHour == 12) initialHour = 0;
                  }
                } catch (e) {
                  // Fallback to now
                }
              }
              // Convert to 12-hour for display
              int displayHour = initialHour % 12;
              if (displayHour == 0) displayHour = 12;
              int? selectedHour, selectedMinute, selectedSecond;
              String? selectedPeriod;
              // Set initial selections
              selectedHour = displayHour;
              selectedMinute = initialMinute;
              selectedSecond = initialSecond;
              selectedPeriod = isPM ? 'PM': 'AM';
              await showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setDialogState) => AlertDialog(
                    title: Text('Select Birth Time'),
                    content: SizedBox(
                      height: 250,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: AppColors.clockBorderSide,
                              ),
                              child: Row(
                                children: [
                                  // Hours (1-12)
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                      controller: FixedExtentScrollController(initialItem: displayHour - 1),
                                      itemExtent: 50,
                                      physics: const FixedExtentScrollPhysics(),
                                      childDelegate: ListWheelChildBuilderDelegate(
                                        builder: (context, index) {
                                          final hour = index + 1;
                                          final isSelected = selectedHour == hour;
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                              hour.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.blue : Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: 12,
                                      ),
                                      onSelectedItemChanged: (index) {
                                        setDialogState(() {
                                          selectedHour = index + 1;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    ':',
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  ),
                                  // Minutes (00-59)
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                      controller: FixedExtentScrollController(initialItem: initialMinute),
                                      itemExtent: 50,
                                      physics: const FixedExtentScrollPhysics(),
                                      childDelegate: ListWheelChildBuilderDelegate(
                                        builder: (context, index) {
                                          final min = index;
                                          final isSelected = selectedMinute == min;
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                              min.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.blue : Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: 60,
                                      ),
                                      onSelectedItemChanged: (index) {
                                        setDialogState(() {
                                          selectedMinute = index;
                                        });
                                      },
                                    ),
                                  ),
                                  const Text(
                                    ':',
                                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                  ),
                                  // Seconds (00-59)
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                      controller: FixedExtentScrollController(initialItem: initialSecond),
                                      itemExtent: 50,
                                      physics: const FixedExtentScrollPhysics(),
                                      childDelegate: ListWheelChildBuilderDelegate(
                                        builder: (context, index) {
                                          final sec = index;
                                          final isSelected = selectedSecond == sec;
                                          return Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Text(
                                              sec.toString().padLeft(2, '0'),
                                              style: TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? Colors.blue : Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: 60,
                                      ),
                                      onSelectedItemChanged: (index) {
                                        setDialogState(() {
                                          selectedSecond = index;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // AM/PM selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                label: const Text('AM'),
                                selected: selectedPeriod == 'AM',
                                onSelected: (selected) {
                                  if (selected) {
                                    setDialogState(() {
                                      selectedPeriod = 'AM';
                                    });
                                  }
                                },
                              ),
                              const SizedBox(width: 16),
                              ChoiceChip(
                                label: const Text('PM'),
                                selected: selectedPeriod == 'PM',
                                onSelected: (selected) {
                                  if (selected) {
                                    setDialogState(() {
                                      selectedPeriod = 'PM';
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Preview
                          if (selectedHour != null && selectedMinute != null && selectedSecond != null && selectedPeriod != null)
                            Text(
                              '${selectedHour!.toString().padLeft(2, '0')}:${selectedMinute!.toString().padLeft(2, '0')}:${selectedSecond!.toString().padLeft(2, '0')} ${selectedPeriod}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (selectedHour != null && selectedMinute != null && selectedSecond != null && selectedPeriod != null) {
                            int hour24 = selectedHour!;
                            if (selectedPeriod == 'PM' && hour24 != 12) hour24 += 12;
                            else if (selectedPeriod == 'AM' && hour24 == 12) hour24 = 0;
                            final formatted = '${hour24.toString().padLeft(2, '0')}:${selectedMinute!.toString().padLeft(2, '0')}:${selectedSecond!.toString().padLeft(2, '0')} ${selectedPeriod}';
                            Navigator.pop(context);
                            if (mounted) {
                              birthTimeController.text = formatted;
                              setState(() {});
                            }
                          }
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              );

              // If no selection, keep initial
              if (birthTimeController.text.isEmpty && initialText.isNotEmpty) {
                birthTimeController.text = initialText;
              }
            },
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'No. Of Sisters',
            controller: sistersController,
            keyboardType: TextInputType.number,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'No. Of Brothers',
            controller: brothersController,
            keyboardType: TextInputType.number,
          ),
          Chips.formButtonHeight,
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // 7 Lifestyle
  // ──────────────────────────────────────
  // 7 Lifestyle
  Widget _buildLifestyleForm() {
    return SingleChildScrollView(
      key: const ValueKey(7),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          // Hobbies
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hobbies', style: Chips.selectableChipTextStyle),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3,
                children: [
                  'Reading',
                  'Traveling',
                  'Music',
                  'Sports',
                  'Cooking',
                  'Dancing',
                  'Other'
                ].map((hobby) {
                  IconData icon;
                  switch (hobby) {
                    case 'Reading':
                      icon = Icons.menu_book;
                      break;
                    case 'Traveling':
                      icon = Icons.travel_explore;
                      break;
                    case 'Music':
                      icon = Icons.music_note;
                      break;
                    case 'Sports':
                      icon = Icons.sports;
                      break;
                    case 'Cooking':
                      icon = Icons.restaurant;
                      break;
                    case 'Dancing':
                      icon = Icons.directions_run;
                      break;
                    default:
                      icon = Icons.add;
                  }
                  final isSelected = selectedHobbies.contains(hobby) ||
                      (hobby == 'Other' && showHobbiesOther);
                  return buildSelectableChip(
                    label: hobby,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (hobby == 'Other') {
                          showHobbiesOther = !showHobbiesOther;
                          if (!showHobbiesOther) {
                            hobbiesOtherController.clear();
                          }
                        } else {
                          if (selectedHobbies.contains(hobby)) {
                            selectedHobbies.remove(hobby);
                          } else {
                            selectedHobbies.add(hobby);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (showHobbiesOther)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: hobbiesOtherController,
                    decoration: InputDecoration(
                      labelText: 'Enter your hobbies (comma-separated)',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final value = hobbiesOtherController.text.trim();
                          if (value.isNotEmpty) {
                            final customs = value.split(',').map((v) => v.trim()).where((v) => v.isNotEmpty);
                            setState(() {
                              selectedHobbies.addAll(customs);
                              hobbiesOtherController.clear();
                              showHobbiesOther = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Chips.formTextfieldHeight,
          // Other Interests
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Other Interests',
                  style: Chips.selectableChipTextStyle),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 3,
                children: [
                  'Fitness',
                  'Movies',
                  'Yoga',
                  'Gaming',
                  'Art',
                  'Other'
                ].map((interest) {
                  IconData icon;
                  switch (interest) {
                    case 'Fitness':
                      icon = Icons.accessibility;
                      break;
                    case 'Movies':
                      icon = Icons.movie_creation_outlined;
                      break;
                    case 'Yoga':
                      icon = Icons.self_improvement;
                      break;
                    case 'Gaming':
                      icon = Icons.videogame_asset;
                      break;
                    case 'Art':
                      icon = Icons.palette;
                      break;
                    default:
                      icon = Icons.add;
                  }
                  final isSelected = selectedInterests.contains(interest) ||
                      (interest == 'Other' && showInterestsOther);
                  return buildSelectableChip(
                    label: interest,
                    icon: icon,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        if (interest == 'Other') {
                          showInterestsOther = !showInterestsOther;
                          if (!showInterestsOther) {
                            interestsOtherController.clear();
                          }
                        } else {
                          if (selectedInterests.contains(interest)) {
                            selectedInterests.remove(interest);
                          } else {
                            selectedInterests.add(interest);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              if (showInterestsOther)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    controller: interestsOtherController,
                    decoration: InputDecoration(
                      labelText: 'Enter other interests (comma-separated)',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final value = interestsOtherController.text.trim();
                          if (value.isNotEmpty) {
                            final customs = value.split(',').map((v) => v.trim()).where((v) => v.isNotEmpty);
                            setState(() {
                              selectedInterests.addAll(customs);
                              interestsOtherController.clear();
                              showInterestsOther = false;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Favourite Movies',
            controller: moviesController,
          ),
          Chips.formTextfieldHeight,
          CustomTextField(
            label: 'Favourite Books',
            controller: booksController,
          ),
          Chips.formButtonHeight,
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // 8 About
  Widget _buildAboutForm() {
    return SingleChildScrollView(
      key: const ValueKey(8),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          CustomTextField(
            label: 'Tell Us About Yourself',
            controller: aboutController,
          ),
          const SizedBox(height: 8),
          const Text(
            'Briefly describe your background, interests, profession, and anything you’d like to share.',
            style: TextStyle(
                fontSize: 12, color: Colors.grey, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 16),
          // Photos list
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Photos', style: Chips.selectableChipTextStyle),
              const SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...selectedPhotosList.map((file) => Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(file),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(
                                  () => selectedPhotosList.remove(file)),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),
                  GestureDetector(
                    onTap: _pickMultipleImages,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add_a_photo,
                          color: Colors.grey),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.image,
                          size: 20, color: Colors.deepPurple),
                      onPressed: _pickMultipleImages,
                    ),
                  ),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt,
                          size: 20, color: Colors.deepPurple),
                      onPressed: _captureImageForPhotosList,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildContinueButton(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────
  // Common button
  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _onContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Continue",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: AppColors.textColor),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    annualIncomeController.dispose();
    professionController.dispose();
    workingOrganizationController.dispose();
    roleController.dispose();
    motherNameController.dispose();
    fatherNameController.dispose();
    birthTimeController.dispose();
    sistersController.dispose();
    brothersController.dispose();
    // Remove: hobbiesController.dispose(); interestsController.dispose();
    moviesController.dispose();
    booksController.dispose();
    hobbiesOtherController.dispose();
    interestsOtherController.dispose();
    aboutController.dispose();
    religionController.dispose();
    maritalController.dispose();
    super.dispose();
  }
}
