import 'package:flutter/material.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';

import '../model/home_screen_model.dart';


class HomeController extends ChangeNotifier {
  final CardController cardController = CardController();

  final List<UserProfiles> users = [
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
    UserProfiles(
      imagePath: 'assets/anushka.jpg',
      name: 'Anushka',
      age: 26,
      location: 'Hyderabad, India',
    ),
    UserProfiles(
      imagePath: 'assets/Rashmika.jpg',
      name: 'Rashmika Mandana',
      age: 28,
      location: 'Mumbai, India',
    ),
    UserProfiles(
      imagePath: 'assets/srileela.jpg',
      name: 'Sri leela',
      age: 24,
      location: 'Bangalore, India',
    ),
    UserProfiles(
      imagePath: 'assets/kajal.jpg',
      name: 'Kaja Agarwal',
      age: 30,
      location: 'Delhi, India',
    ),
  ];

  int currentIndex = 0;

  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void swipeLeft() {
    cardController.triggerLeft();
  }

  void swipeRight() {
    cardController.triggerRight();
  }

  void swipeUp() {
    cardController.triggerUp();
  }
}
