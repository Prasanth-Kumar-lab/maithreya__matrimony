import 'package:flutter/material.dart';
class AppColors{
  static final animatedContainer = Colors.black;
  static final boxShadow = BoxShadow(color: Colors.white.withOpacity(0.4),
    blurRadius: 12,
    spreadRadius: 14,
    offset:
    Offset(0, -5),
  );
  static const onboardingCircleAvatars = Colors.black;
  static const fontWeight = FontWeight.bold;
  static const textColor = Colors.black;
  static const iconColor = Colors.white;
  static const profileIconsColor = Colors.black;
  static const textFieldIconColor = Colors.black;
  static const plansCardColor = Colors.white;
  static const currencyUniCode = '\u20B9';
  static const appBarIconColor = Colors.black;
  static const buttonColor = Colors.orange;
  static const forgotPassword = Colors.blue;
  static const textfieldLable = Colors.grey;
  static final bgThemeColor = Colors.indigo.shade200;
  static const appBarThemeColor = Colors.orange;
  static const textAnimateColor = Colors.white;
  static final onboardingContainers = Colors.indigo.shade100;
  static final loginSignUpTheme = Colors.indigo.shade100;
  static final registrationProcess = Colors.indigo.shade100;
  static const buttonIconColor = Colors.black;
  static final selectableChipBg = Colors.indigo.withOpacity(0.6);
  static final swipeGridCardsTextStyle = TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,);
  static const swipeGridCardsSubTextStyle = TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,);
  static const profileSectionCard = Colors.white;
  static const listPhotosActionButtonsColors = Colors.black54;
  static final listPhotosHighlightColor = Colors.white.withOpacity(0.5);
  static const listPhotoshoverColor = Colors.white;
  static const tabBackgroundColorbtmNavBar = Colors.white;
  static const subscriptionsPlansCard = Colors.blueAccent;
  static const subscriptionsPlansCardGradient = Colors.blue;
  static const subscriptionTitleColor = Colors.white;
  static const clockBorderSide = Border(
   top: BorderSide(color: Colors.green, width: 2),
  bottom: BorderSide(color: Colors.green, width: 2),
  );

}

class ActionButtonIcons{
  static const closeIcon = Icons.close;
  static const refreshIcon = Icons.sync;
  static const favouriteIcon = Icons.favorite_rounded;
  static const sendIcon = Icons.send;
  static const callIcon = Icons.call;
  static const majorActionButtonColors = Colors.greenAccent;
  static const minorActionButtonColors = Colors.white;
}
class Chips{
  static const selectableChipTextStyle = TextStyle(fontFamily: 'Poppins', fontSize: 16,fontWeight: FontWeight.bold);
  static const formTextfieldHeight = SizedBox(height: 18,);
  static const formButtonHeight = SizedBox(height: 25,);
}


class LottieAssets {
  static const registrationLottie = 'assets/Stream of Hearts.json';
  static const fetchingProfile = 'assets/fetching.json';
  static const paymentLoading ='assets/payment_loading.json';
  static const paymentSuccess = 'assets/payment_success.json';
}


class RegistrationTitles{
  static const registrationSubTitle = 'Let us know you better';
}


class ProgressIndicatorTiles{
  static final tiles = [
    'Profile',
    'Location',
    'Marital',
    'Professional',
    'Family',
    'Lifestyle',
    'About',
  ];
  static const activeText = Colors.indigo;
  static const inactiveText = Colors.grey;
  static const currentText = Colors.white;
}
