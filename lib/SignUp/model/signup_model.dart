class SignupModel {
  String name = '';
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String gender = 'Male'; // Default
  DateTime? dob;
  bool agreeTerms = false;
  bool isLoading = false;
  String? errorMessage;
}