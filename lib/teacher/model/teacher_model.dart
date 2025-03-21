class Teacher {
  String? id;
  String? name;
  String? department;
  String? role;
  String? email;
  String? phone;
  String? photoUrl;
  bool isApproved;
  List<Map<String, dynamic>> assignedPeriods; // Store assigned periods

  Teacher({
    required this.id,
    required this.name,
    required this.department,
    required this.role,
    required this.email,
    required this.phone,
    required this.photoUrl,
    this.isApproved = false,
    this.assignedPeriods = const [], // Default empty list
  });

  // Convert Firestore Document to Teacher Model
  factory Teacher.fromMap(Map<String, dynamic> data) {
    return Teacher(
      id: data["id"] ?? '',
      name: data['name'] ?? '',
      department: data['department'],
      role: data["role"],
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['imageUrl'] ?? '',
      isApproved: data['isApproved'] ?? false,
      assignedPeriods: (data['assigned_periods'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  // Convert Teacher Model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'department': department,
      'role': role,
      'phone': phone,
      'imageUrl': photoUrl,
      'isApproved': isApproved,
      'assigned_periods': assignedPeriods, // Store assigned periods
    };
  }
}
