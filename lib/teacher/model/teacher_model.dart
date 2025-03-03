class Teacher {
  String id;
  String name;
  String email;
  String phone;
  String photoUrl;
  bool isApproved;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    this.isApproved = false, // Default: Not approved
  });

  // Convert Firestore Document to Teacher Model
  factory Teacher.fromMap(Map<String, dynamic> data, String documentId) {
    return Teacher(
      id: documentId,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      isApproved: data['isApproved'] ?? false,
    );
  }

  // Convert Teacher Model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'isApproved': isApproved,
    };
  }
}
