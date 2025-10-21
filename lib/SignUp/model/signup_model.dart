class SignupModel {
  String name = '';
  String username = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  String gender = 'Male';
  DateTime? dob;
  String address = '';
  bool agreeTerms = false;
  bool isLoading = false;
  String? errorMessage;
}