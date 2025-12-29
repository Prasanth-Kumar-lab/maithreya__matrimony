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
  final String? address;
  List<String>? photosList;
  final String? deviceToken;
  final String? caste;
  final String? subCaste;
  final String? zodiacSign;
  final String? religion;

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
    this.address,
    this.photosList,
    this.deviceToken,
    this.caste,
    this.subCaste,
    this.zodiacSign,
    this.religion,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    userId: json['user_id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
    lastname: json['lastname']?.toString(),
    email: json['email']?.toString(),
    phone: json['number']?.toString(),
    gender: json['gender']?.toString(),
    dateOfBirth: json['date_of_birth']?.toString(),
    age: json['age']?.toString(),
    image: json['image']?.toString(),
    nativePlace: json['native']?.toString(),
    stateName: json['state_name']?.toString(),
    city: json['city']?.toString(),
    maritalStatus: json['marital_status']?.toString(),
    height: json['height']?.toString(),
    educationDetails: json['education_details']?.toString(),
    foodType: json['food_type']?.toString(),
    income: json['income']?.toString(),
    profession: json['profession']?.toString(),
    organization: json['organization']?.toString(),
    role: json['role']?.toString(),
    motherName: json['mothername']?.toString(),
    fatherName: json['fathername']?.toString(),
    birthTime: json['birth_time']?.toString(),
    noOfSisters: json['no_of_sisters']?.toString(),
    noOfBrothers: json['no_of_brothers']?.toString(),
    hobbies: json['hobbies']?.toString(),
    favouriteMovies: json['favourite_movies']?.toString(),
    favouriteBooks: json['favourite_books']?.toString(),
    otherInterests: json['other_intrests']?.toString(),
    about: json['about']?.toString(),
    address: json['address']?.toString(),
    photosList: json['photos_list'] != null ? List<String>.from(json['photos_list']) : null,
    deviceToken: json['device_token']?.toString(),
    caste: json['caste']?.toString(),
    subCaste: json['subcaste']?.toString(),
    zodiacSign: json['zodiac_sign']?.toString(),
    religion: json['religion']?.toString(),
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
    'address': address,
    'photos_list': photosList,
    'device_token': deviceToken,
    'caste': caste,
    'subcaste': subCaste,
    'zodiac_sign': zodiacSign,
    'religion': religion,
  };

  UserProfile copyWith({
    String? userId,
    String? name,
    String? lastname,
    String? email,
    String? phone,
    String? gender,
    String? dateOfBirth,
    String? age,
    String? image,
    String? nativePlace,
    String? stateName,
    String? city,
    String? maritalStatus,
    String? height,
    String? educationDetails,
    String? foodType,
    String? income,
    String? profession,
    String? organization,
    String? role,
    String? motherName,
    String? fatherName,
    String? birthTime,
    String? noOfSisters,
    String? noOfBrothers,
    String? hobbies,
    String? favouriteMovies,
    String? favouriteBooks,
    String? otherInterests,
    String? about,
    String? address,
    List<String>? photosList,
    String? deviceToken,
    String? caste,
    String? subCaste,
    String? zodiacSign,
    String? religion,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age ?? this.age,
      image: image ?? this.image,
      nativePlace: nativePlace ?? this.nativePlace,
      stateName: stateName ?? this.stateName,
      city: city ?? this.city,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      height: height ?? this.height,
      educationDetails: educationDetails ?? this.educationDetails,
      foodType: foodType ?? this.foodType,
      income: income ?? this.income,
      profession: profession ?? this.profession,
      organization: organization ?? this.organization,
      role: role ?? this.role,
      motherName: motherName ?? this.motherName,
      fatherName: fatherName ?? this.fatherName,
      birthTime: birthTime ?? this.birthTime,
      noOfSisters: noOfSisters ?? this.noOfSisters,
      noOfBrothers: noOfBrothers ?? this.noOfBrothers,
      hobbies: hobbies ?? this.hobbies,
      favouriteMovies: favouriteMovies ?? this.favouriteMovies,
      favouriteBooks: favouriteBooks ?? this.favouriteBooks,
      otherInterests: otherInterests ?? this.otherInterests,
      about: about ?? this.about,
      address: address ?? this.address,
      photosList: photosList ?? this.photosList,
      deviceToken: deviceToken ?? this.deviceToken,
      caste: caste ?? this.caste,
      subCaste: subCaste ?? this.subCaste,
      zodiacSign: zodiacSign ?? this.zodiacSign,
      religion: religion ?? this.religion,
    );
  }
}