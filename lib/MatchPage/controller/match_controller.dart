import '../../First Registration Process/ProfilePage/model/profile_model.dart';


class MatchesController {
  // Sample data – normally fetched from backend
  final List<ProfileModel> likedProfiles = [
    ProfileModel(
      name: "Alice",
      age: 25,
      location: "New York",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Bob",
      age: 28,
      location: "Chicago",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Clara",
      age: 30,
      location: "Los Angeles",
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];

  final List<ProfileModel> myProfileLikedProfiles = [
    ProfileModel(
      name: "David",
      age: 27,
      location: "Boston",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Eve",
      age: 26,
      location: "Miami",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Frank",
      age: 29,
      location: "Seattle",
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];

  final List<ProfileModel> shortlistedProfiles = [
    ProfileModel(
      name: "Grace",
      age: 24,
      location: "Denver",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Heidi",
      age: 31,
      location: "San Diego",
      imageUrl: "https://via.placeholder.com/150",
    ),
    ProfileModel(
      name: "Ivan",
      age: 32,
      location: "Austin",
      imageUrl: "https://via.placeholder.com/150",
    ),
  ];
}
