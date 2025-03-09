class UserModel {
  String? studentId;
  String? studentName;
  String? email;
  String? phoneNumber;
  String? dob;
  final String? gender;
  final String? bloodGroup;
  final String? department;
  final int? currentSemester;
  final String? admissionNumber;
  final String? rollNumber;
  final String? admisssionYear;
  final String? admissionDate;
  final String? nationality;
  final String? religion;
  final String? category;
  final String? cast;
  final String? address;
  final String? city;
  final String? district;
  final String? state;
  final String? pincode;

  UserModel({
    required this.studentId,
    required this.studentName,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.department,
    required this.currentSemester,
    required this.admissionNumber,
    required this.rollNumber,
    required this.admisssionYear,
    required this.admissionDate,
    required this.nationality,
    required this.religion,
    required this.category,
    required this.cast,
    required this.address,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      studentId: map['student_id'],
      studentName: map['student_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      bloodGroup: map['blood_group'] ?? '',
      department: map['department'] ?? '',
      currentSemester: map['current_semester'],
      admissionNumber: map["admission_number"],
      rollNumber: map['roll_no'],
      admisssionYear: map['admission_year'],
      admissionDate: map['admission_date'],
      nationality: map['nationality'] ?? '',
      religion: map['religion'] ?? '',
      category: map['category'] ?? '',
      cast: map['cast'] ?? '',
      address: map['house_name'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'email': email,
      'phone_number': phoneNumber,
      'dob': dob,
      'gender': gender,
      'blood_group': bloodGroup,
      'department': department,
      'current_semester': currentSemester,
      'admission_number': admissionNumber,
      'roll_no': rollNumber,
      'admission_year': admisssionYear,
      'admission_date': admissionDate,
      'nationality': nationality,
      'religion': religion,
      'category': category,
      'cast': cast,
      'address': address,
      'city': city,
      'district': district,
      'state': state,
      'pincode': pincode,
    };
  }
}
