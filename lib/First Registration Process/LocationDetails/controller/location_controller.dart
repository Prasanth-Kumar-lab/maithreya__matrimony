import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ProfilePage/model/profile_model.dart';

class LocationController extends GetxController {
  final nativePlaceController = TextEditingController();
  final cityController = TextEditingController();

  var selectedState = ''.obs; // Use RxString for reactivity

  // List of states (sorted as provided)
  final List<String> states = [
    'Andhra Pradesh',
    'Telangana',
    //'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jammu and Kashmir', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
  ]..sort();

  bool validateInputs() {
    return nativePlaceController.text.isNotEmpty &&
        selectedState.value.isNotEmpty &&
        cityController.text.isNotEmpty;
  }

  // Setter to ensure valid state selection
  void setSelectedState(String? value) {
    if (value != null && states.contains(value)) {
      selectedState.value = value;
    } else {
      selectedState.value = '';
    }
  }

  LocationModel getLocationModel() {
    return LocationModel(
      nativePlace: nativePlaceController.text,
      state: selectedState.value,
      city: cityController.text,
    );
  }

  @override
  void onClose() {
    nativePlaceController.dispose();
    cityController.dispose();
    super.onClose();
  }
}