class StudentModel {
  String? studentId;
  final String? studentName;
  String? email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String? bloodGroup;
  final String? department;
  final int? currentSemester;
  final String? year;
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
  Map<String, Map<int, bool>>
      attendance; // Stores date-wise attendance with periods
  int? totalPresents;
  int? totalAbsents;

  StudentModel({
     this.studentId,
     this.studentName,
     this.email,
     this.phoneNumber,
     this.dob,
     this.gender,
     this.bloodGroup,
     this.department,
     this.currentSemester,
    required this.year,
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
    this.attendance = const {}, // Default empty attendance
    this.totalPresents = 0,
    this.totalAbsents = 0,
  });

  // Convert Firestore document to StudentModel
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      studentId: map['student_id'] ?? '',
      studentName: map['student_name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      bloodGroup: map['blood_group'] ?? '',
      department: map['department'] ?? '',
      currentSemester:
          int.tryParse(map['current_semester']?.toString() ?? '0') ??
              0, // Ensure it's an integer
      year: map['year'],
      admissionNumber: map["admission_number"],
      rollNumber: map['roll_no']?.toString() ?? '', // Ensure it's a string
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
      'year': year,
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
      'attendance': attendance.map(
        (date, periods) => MapEntry(
          date,
          periods.map((period, status) => MapEntry(period.toString(), status)),
        ),
      ),
      'total_presents': totalPresents,
      'total_absents': totalAbsents,
    };
  }
}
