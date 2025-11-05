import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:lottie/lottie.dart';
import 'package:matrimony/constants/constants.dart';

import '../controller/otp_controller.dart';

class OtpLogin extends StatefulWidget {
  @override
  _OtpLoginState createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  final OtpController _controller = OtpController();
  bool _showOtpField = false;

  void _sendOtp() {
    _controller.sendOtp((msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      if (_controller.isMobileValid) {
        setState(() {
          _showOtpField = true;
        });
      }
    });
  }

  void _verifyOtp(String otp) {
    _controller.setOtp(otp);
    _controller.verifyOtp((msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgThemeColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Back Arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Lottie.asset(
              'assets/onboarding2.json',
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 80),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.loginSignUpTheme,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  border: Border.all(
                    color: AppColors.animatedContainer,
                    width: 1,
                  ),
                  boxShadow: [AppColors.boxShadow],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!_showOtpField) ...[
                        Text(
                          "Enter your mobile number:",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: _controller.mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: "Mobile Number",
                            labelStyle: TextStyle(color: AppColors.textColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            prefixIcon: Icon(Icons.phone, color: AppColors.textFieldIconColor),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor.shade400,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                      ] else ...[
                        Text(
                          "Enter OTP sent to ${_controller.mobileController.text}",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: AppColors.textColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        PinCodeTextField(
                          appContext: context,
                          length: 4,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.white,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.grey[200]!,
                            activeColor: Colors.black,
                            selectedColor: Colors.green,
                            inactiveColor: Colors.black,
                          ),
                          enableActiveFill: true,
                          onChanged: (value) {},
                          onCompleted: _verifyOtp,
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showOtpField = false;
                              _controller.clear();
                            });
                          },
                          child: Text(
                            "Edit Mobile Number",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: AppColors.forgotPassword,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
