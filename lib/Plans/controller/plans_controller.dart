// lib/controllers/plans_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/Plans/model/plans_model.dart';
import 'package:matrimony/apiEndPoint.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class PlansController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var plans = <Plan>[].obs;
  var isPaymentLoading = false.obs; // 🆕 New observable for payment loading state
  late Razorpay _razorpay;
  var isPaymentSuccess = false.obs; // 🆕 Post-payment success Lottie


  @override
  void onInit() {
    super.onInit();
    fetchPlans();
    _initRazorpay();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay.clear(); // cleanup
    super.onClose();
  }

  Future<void> fetchPlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await http.get(
        Uri.parse(ApiEndPoint.getPlansApiEndPoint),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'Success') {
          final List<dynamic> planList = data['plans'];
          plans.value = planList.map((e) => Plan.fromJson(e)).toList();
        } else {
          errorMessage.value = data['message'] ?? 'Unknown error';
        }
      } else {
        errorMessage.value = 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching plans: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void startPayment(Plan plan) async {
    try {
      final cleanedPrice = plan.price.replaceAll(RegExp(r'[^0-9.]'), '');
      final double price = double.tryParse(cleanedPrice) ?? 0.0;
      if (price <= 0) {
        Get.snackbar(
          'Error',
          'Invalid plan price for ${plan.name}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      // Razorpay expects the amount in paise (1 INR = 100 paise)
      final int amountInPaise = (price * 100).toInt();
      var options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag',
        'amount': amountInPaise,
        'name': 'Maithreya Matrimony',
        'description': '${plan.name} Plan Subscription',
        /*'prefill': {
          'contact': '9505909402',
          'email': 'prasanthkumartera@gmail.com',
        },*/
        'theme.color': '#9FA8DA',
        'currency': 'INR',
      };

      isPaymentLoading.value = true;
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to start payment: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      // 🆕 Ensure loading is reset on error
      isPaymentLoading.value = false;
    }
  }

  // 🟢 Payment success callback
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    isPaymentLoading.value = false;
    isPaymentSuccess.value = true; // Show success Lottie

    Get.snackbar(
      'Payment Successful',
      'Payment ID: ${response.paymentId}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Don't hide automatically — user will close manually
  }



  // 🔴 Payment failed callback
  void _handlePaymentError(PaymentFailureResponse response) {
    // 🆕 Reset payment loading state
    isPaymentLoading.value = false;
    Get.snackbar(
      'Payment Failed',
      'Reason: ${response.message}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // 🟡 External wallet callback
  void _handleExternalWallet(ExternalWalletResponse response) {
    // 🆕 Reset payment loading state
    isPaymentLoading.value = false;
    Get.snackbar(
      'External Wallet Selected',
      'Wallet: ${response.walletName}',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }
}