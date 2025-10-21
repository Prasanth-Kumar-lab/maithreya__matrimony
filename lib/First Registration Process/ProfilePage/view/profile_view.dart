import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';
import 'package:matrimony/constants/fade_slide_textfields.dart';
import '../../LocationDetails/View/location_view.dart';
import '../../widgets/textfield.dart';
import 'dart:io';

class ProfileDetails extends StatefulWidget {
  final String userId;
  final String userName;

  const ProfileDetails({Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController dobController;
  late TextEditingController genderController;
  late TextEditingController ageController;

  final Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.userName.split(' ').first);
    lastNameController = TextEditingController(
        text: widget.userName.split(' ').length > 1 ? widget.userName.split(' ').sublist(1).join(' ') : '');
    dobController = TextEditingController();
    genderController = TextEditingController();
    ageController = TextEditingController();

    dobController.addListener(_updateAge);
  }

  void _updateAge() {
    String dobStr = dobController.text;
    if (dobStr.isEmpty) {
      ageController.text = '';
      return;
    }

    List<String> parts = dobStr.split('-');
    if (parts.length != 3) {
      ageController.text = '';
      return;
    }

    try {
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900 || year > DateTime.now().year) {
        throw Exception('Invalid date');
      }

      DateTime birthDate = DateTime(year, month, day);
      int age = _calculateAge(birthDate);
      ageController.text = age.toString();
    } catch (e) {
      ageController.text = '';
    }
  }

  int _calculateAge(DateTime birthDate) {
    DateTime current = DateTime.now();
    int age = current.year - birthDate.year;
    bool birthdayPassed = current.month > birthDate.month || (current.month == birthDate.month && current.day >= birthDate.day);
    if (!birthdayPassed) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text =
      '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  Future<XFile?> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> _captureImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }

  @override
  void dispose() {
    dobController.removeListener(_updateAge);
    firstNameController.dispose();
    lastNameController.dispose();
    dobController.dispose();
    genderController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.bgThemeColor,
        body: SafeArea(
          bottom: false,
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
                      const SizedBox(height: 80),
                      Text(
                        'Complete Your Profile',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        RegistrationTitles.registrationSubTitle,
                        style: TextStyle(
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
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
                                    : const AssetImage('assets/default.jpg') as ImageProvider,
                              )),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.image, size: 20, color: Colors.deepPurple),
                                      onPressed: () async {
                                        final XFile? image = await _pickImageFromGallery();
                                        if (image != null) {
                                          selectedImage.value = File(image.path);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt, size: 20, color: Colors.deepPurple),
                                      onPressed: () async {
                                        final XFile? image = await _captureImageFromCamera();
                                        if (image != null) {
                                          selectedImage.value = File(image.path);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 0.0,
                          child: CustomTextField(
                            controller: firstNameController,
                            label: 'First Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.2,
                          child: CustomTextField(
                            controller: lastNameController,
                            label: 'Last Name',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.4,
                          child: TextField(
                            controller: dobController,
                            decoration: InputDecoration(
                              labelText: 'Date of birth',
                              labelStyle: const TextStyle(fontFamily: 'Poppins'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            readOnly: true,
                            onTap: _pickDate,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.6,
                          child: DropdownButtonFormField<String>(
                            value: genderController.text.isNotEmpty ? genderController.text : null,
                            items: ['Male', 'Female', 'Other'].map((String gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                genderController.text = newValue;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Gender',
                              labelStyle: const TextStyle(fontFamily: 'Poppins'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeSlideTransition(
                          delay: 0.8,
                          child: TextField(
                            controller: ageController,
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: const TextStyle(fontFamily: 'Poppins'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(height: 32),
                        FadeSlideTransition(
                          delay: 1.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedImage.value == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please select an image')),
                                );
                                return;
                              }

                              if (firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  dobController.text.isEmpty ||
                                  genderController.text.isEmpty ||
                                  ageController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please fill all fields')),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LocationDetails(userId: widget.userId,)),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, color: AppColors.textFieldIconColor),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}