import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/First%20Registration%20Process/ProfilePage/model/profile_model.dart';
import 'package:matrimony/apiEndPoint.dart';

class MaritalDetailsController extends ChangeNotifier {
  final MaritalDetailsModel _model = MaritalDetailsModel();

  // Getters for model properties
  String get maritalStatus => _model.maritalStatus;
  String get height => _model.height;
  String get educationalDetails => _model.educationalDetails;
  String get foodType => _model.foodType;

  // Text controllers for non-dropdown fields
  final TextEditingController heightController = TextEditingController();
  final TextEditingController educationalDetailsController = TextEditingController();

  // Dropdown options
  final List<String> maritalStatusOptions = ['Single', 'Divorced', 'Other', 'Prefer not to say'];
  final List<String> foodTypeOptions = ['Veg', 'Non-veg', 'Veg/Non-veg', 'Prefer not to say'];

  // Setters with notification
  set maritalStatus(String value) {
    _model.maritalStatus = value;
    notifyListeners();
  }

  set foodType(String value) {
    _model.foodType = value;
    notifyListeners();
  }

  void initListeners() {
    heightController.addListener(() {
      _model.height = heightController.text;
      notifyListeners();
    });

    educationalDetailsController.addListener(() {
      _model.educationalDetails = educationalDetailsController.text;
      notifyListeners();
    });
  }

  bool validate() {
    return _model.maritalStatus.isNotEmpty &&
        _model.height.isNotEmpty &&
        _model.educationalDetails.isNotEmpty &&
        _model.foodType.isNotEmpty;
  }

  /*Future<void> handleContinue(
      BuildContext context,
      String userId,
      String name,
      String dateOfBirth,
      String gender,
      String age,) async {
    if (!validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiEndPoint.profileApiEndPoint),
      );

      request.fields['user_id'] = userId;
      request.fields['name'] = name;
      request.fields['date_of_birth'] = dateOfBirth;
      request.fields['gender'] = gender;
      request.fields['age'] = age;

      request.fields['marital_status'] = _model.maritalStatus;
      request.fields['height'] = _model.height;
      request.fields['education_details'] = _model.educationalDetails;
      request.fields['food_type'] = _model.foodType;


      request.headers['Accept'] = 'application/json';

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      Navigator.of(context).pop(); // Dismiss loader

      final result = jsonDecode(responseBody);
      if (response.statusCode == 200 && result['status'] == 'success') {
        print("✅ Marital details uploaded successfully.");


      } else {
        print("❌ API failed: ${result['message'] ?? 'Unknown error'}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to submit data')),
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss loader
      print('❌ Exception during API call: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }*/
  @override
  void dispose() {
    heightController.dispose();
    educationalDetailsController.dispose();
    super.dispose();
  }
}