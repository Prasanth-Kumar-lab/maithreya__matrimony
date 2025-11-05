import 'package:flutter/material.dart';
import '../model/otp_model.dart';

class OtpController {
  final OtpModel otpModel = OtpModel();
  final TextEditingController mobileController = TextEditingController();

  bool get isMobileValid => mobileController.text.length == 10;

  void setMobileNumber(String number) {
    otpModel.mobileNumber = number;
  }

  void setOtp(String otp) {
    otpModel.otp = otp;
  }

  void sendOtp(Function(String) showMessage) {
    if (isMobileValid) {
      setMobileNumber(mobileController.text);
      showMessage("OTP sent to ${otpModel.mobileNumber}");
    } else {
      showMessage("Please enter a valid 10-digit mobile number");
    }
  }

  void verifyOtp(Function(String) showMessage) {
    showMessage("Entered OTP: ${otpModel.otp}");
    // Add API call to verify OTP here
  }

  void clear() {
    mobileController.clear();
    otpModel.mobileNumber = '';
    otpModel.otp = '';
  }
}
