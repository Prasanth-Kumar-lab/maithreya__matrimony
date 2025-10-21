class UserProfile {
  final String userId;
  final String name;
  final String? lastname;
  final String? email;
  final String? phone;
  final String? gender;
  final String? dateOfBirth;
  final String? age;
  final String? image;
  final String? nativePlace;
  final String? stateName;
  final String? city;
  final String? maritalStatus;
  final String? height;
  final String? educationDetails;
  final String? foodType;
  final String? income;
  final String? profession;
  final String? organization;
  final String? role;
  final String? motherName;
  final String? fatherName;
  final String? birthTime;
  final String? noOfSisters;
  final String? noOfBrothers;
  final String? hobbies;
  final String? favouriteMovies;
  final String? favouriteBooks;
  final String? otherInterests;
  final String? about;

  UserProfile({
    required this.userId,
    required this.name,
    this.lastname,
    this.email,
    this.phone,
    this.gender,
    this.dateOfBirth,
    this.age,
    this.image,
    this.nativePlace,
    this.stateName,
    this.city,
    this.maritalStatus,
    this.height,
    this.educationDetails,
    this.foodType,
    this.income,
    this.profession,
    this.organization,
    this.role,
    this.motherName,
    this.fatherName,
    this.birthTime,
    this.noOfSisters,
    this.noOfBrothers,
    this.hobbies,
    this.favouriteMovies,
    this.favouriteBooks,
    this.otherInterests,
    this.about,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['user_id'] ?? '',
    name: json['name'] ?? '',
    lastname: json['lastname'],
    email: json['email'],
    phone: json['phone'],
    gender: json['gender'],
    dateOfBirth: json['date_of_birth'],
    age: json['age'],
    image: json['image'],
    nativePlace: json['native'],
    stateName: json['state_name'],
    city: json['city'],
    maritalStatus: json['marital_status'],
    height: json['height'],
    educationDetails: json['education_details'],
    foodType: json['food_type'],
    income: json['income'],
    profession: json['profession'],
    organization: json['organization'],
    role: json['role'],
    motherName: json['mothername'],
    fatherName: json['fathername'],
    birthTime: json['birth_time'],
    noOfSisters: json['no_of_sisters'],
    noOfBrothers: json['no_of_brothers'],
    hobbies: json['hobbies'],
    favouriteMovies: json['favourite_movies'],
    favouriteBooks: json['favourite_books'],
    otherInterests: json['other_intrests'],
    about: json['about'],
  );
}

