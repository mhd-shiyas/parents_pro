import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parent_pro/teacher/model/teacher_model.dart';

class DepartmentDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<Teacher>> fetchDepartmentTeachers(String department) async {
    try {
      print("Fetching teachers for department: $department");
      QuerySnapshot snapshot = await _firestore
          .collection('teachers')
          .where('department', isEqualTo: department)
          .get();
      print("Fetched ${snapshot.docs.length} teachers");
      return snapshot.docs
          .map((doc) => Teacher.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching students: $e");
      return [];
    }
  }
}
