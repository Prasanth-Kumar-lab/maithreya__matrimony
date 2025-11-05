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
  final String? address; // Added address field
  List<String>? photosList;
  final List<String>? deviceToken;
  final String? caste;
  final String? subCaste;
  final String? zodiacSign;


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
    this.address, // Added to constructor
    this.photosList,
    this.deviceToken,
    this.caste,
    this.subCaste,
    this.zodiacSign
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['user_id'] ?? '',
    name: json['name'] ?? '',
    lastname: json['lastname'],
    email: json['email'],
    phone: json['number'],
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
    address: json['address'], // Added to fromJson
    photosList: json['photos_list'] != null ? List<String>.from(json['photos_list']) : null,
    deviceToken: json['device_token'] != null
        ? List<String>.from(json['device_token'])
        : [],
    caste: json['caste'],
    subCaste: json['subcaste'],
      zodiacSign: json['zodiac_sign']
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'lastname': lastname,
    'email': email,
    'number': phone,
    'gender': gender,
    'date_of_birth': dateOfBirth,
    'age': age,
    'image': image,
    'native': nativePlace,
    'state_name': stateName,
    'city': city,
    'marital_status': maritalStatus,
    'height': height,
    'education_details': educationDetails,
    'food_type': foodType,
    'income': income,
    'profession': profession,
    'organization': organization,
    'role': role,
    'mothername': motherName,
    'fathername': fatherName,
    'birth_time': birthTime,
    'no_of_sisters': noOfSisters,
    'no_of_brothers': noOfBrothers,
    'hobbies': hobbies,
    'favourite_movies': favouriteMovies,
    'favourite_books': favouriteBooks,
    'other_intrests': otherInterests,
    'about': about,
    'address': address, // Added to toJson
    'photos_list':photosList,
    'device_token': deviceToken ?? [],
    'caste': caste,
    'subcaste': subCaste,
    'zodiac_sign': zodiacSign
  };
}