import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parent_pro/teacher/model/student_model.dart';

import '../repository/students_repository.dart';

class StudentController with ChangeNotifier {
  final StudentRepository _repository = StudentRepository();
  List<StudentModel> _students = [];
  List<StudentModel> get students => _students;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadAllStudents() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('students').get();
      _students = querySnapshot.docs
          .map(
              (doc) => StudentModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error loading all students: $e");
    }
  }

  Future<void> loadStudents(String department) async {
    try {
      _students = await _repository.fetchStudents(department);
      notifyListeners();
    } catch (e) {
      print("Error loading students: $e");
    }
  }

  Future<void> addStudent(StudentModel student, String password) async {
    try {
      await _repository.addStudent(student, password);
      loadStudents(
          student.department!); // Reload students after adding a new one
    } catch (e) {
      print("Error adding student: $e");
    }
  }

  Future<void> updateStudent(
      String studentId, Map<String, dynamic> updatedData) async {
    try {
      await _repository.updateStudent(studentId, updatedData);
      int index =
          _students.indexWhere((student) => student.studentId == studentId);
      if (index != -1) {
        _students[index] = StudentModel.fromMap({
          ..._students[index].toMap(),
          ...updatedData,
        });
        ;
        notifyListeners();
      } else {}
    } catch (e) {
      print("Error updating student: $e");
    }
  }

  Future<List<StudentModel>> loadStudentsBySubject(String subject) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('students')
          .where('assigned_subjects', arrayContains: subject)
          .get();

      List<StudentModel> students = querySnapshot.docs
          .map((doc) {
            try {
              return StudentModel.fromMap(doc.data());
            } catch (e) {
              print("Error parsing student data for ${doc.id}: $e");
              return null; // Skip invalid entries
            }
          })
          .whereType<StudentModel>()
          .toList(); // Removes any null values

      return students;
    } catch (e) {
      print("Error loading students by subject: $e");
      return [];
    }
  }

  Future<void> assignStudentToSubject(String studentId, String subject) async {
    try {
      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);
      await studentRef.update({
        'assigned_subjects': FieldValue.arrayUnion([subject])
      });
      print("Student $studentId assigned to subject $subject successfully");
      notifyListeners();
    } catch (e) {
      print("Error assigning student to subject: $e");
    }
  }

// Fetch student details by ID
  Future<Map<String, dynamic>?> getStudentById(String studentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (studentSnapshot.exists) {
        return studentSnapshot.data();
      }
    } catch (e) {
      print("Error fetching student details: $e");
    }
    return null;
  }

  // Fetch assessments for a student by semester
  Future<List<Map<String, dynamic>>> fetchAssessments(
      String studentId, int semester) async {
    try {
      String semesterKey = "semester_$semester";

      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists ||
          !studentSnapshot.data()!.containsKey('assessments')) {
        return []; // No assessments found
      }

      var assessmentsData = studentSnapshot.data()?['assessments'];
      if (assessmentsData is Map<String, dynamic> &&
          assessmentsData.containsKey(semesterKey)) {
        List<Map<String, dynamic>> assessments =
            List<Map<String, dynamic>>.from(assessmentsData[semesterKey]);

        print("Fetched Assessments: $assessments");
        return assessments;
      }

      return [];
    } catch (e) {
      print("Error fetching assessments: $e");
      return [];
    }
  }

  // Fetch semester fees for a student
Future<List<Map<String, dynamic>>> getSemesterFees(String studentId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
        await _firestore.collection('students').doc(studentId).get();

    if (!studentSnapshot.exists || !studentSnapshot.data()!.containsKey('semester_fees')) {
      return []; // No semester fees found
    }

    Map<String, dynamic> semesterFeesData = studentSnapshot.data()?['semester_fees'] ?? {};
    List<Map<String, dynamic>> semesterFees = [];

    // Convert the semester_fees map into a list of semester fee objects
    semesterFeesData.forEach((semester, feeData) {
      if (feeData is Map<String, dynamic>) {
        semesterFees.add({
          "semester": semester.replaceAll("semester_", ""), // Extract semester number
          "amount": feeData["amount"] ?? 0,
          "paid": feeData["paid"] ?? false,
        });
      }
    });

    print("Fetched Semester Fees: $semesterFees");
    return semesterFees;
  } catch (e) {
    print("Error fetching semester fees: $e");
    return [];
  }
}


  // Update student's semester and admission year
  Future<void> updateStudentDetails(
      String studentId, int semester, String year) async {
    try {
      await _firestore.collection('students').doc(studentId).update({
        'current_semester': semester,
        'admission_year': year,
      });
      notifyListeners();
    } catch (e) {
      print("Error updating student details: $e");
    }
  }

  // Mark an assessment as submitted
  Future<void> updateAssessmentSubmission(String studentId, int semester,
      int assessmentIndex, bool isSubmitted) async {
    try {
      String semesterKey = "semester_$semester";
      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);

      // Fetch the latest student data
      DocumentSnapshot studentSnapshot = await studentRef.get();
      if (!studentSnapshot.exists) return;

      Map<String, dynamic> studentData =
          studentSnapshot.data() as Map<String, dynamic>;
      if (!studentData.containsKey('assessments') ||
          !studentData['assessments'].containsKey(semesterKey)) return;

      List assessments = List.from(studentData['assessments'][semesterKey]);

      if (assessmentIndex >= 0 && assessmentIndex < assessments.length) {
        assessments[assessmentIndex]['submitted'] = isSubmitted;

        await studentRef.update({
          'assessments.$semesterKey':
              assessments, // Update only the assessments list
        });

        print("Assessment submission updated for student: $studentId");
      }
    } catch (e) {
      print("Error updating assessment submission: $e");
    }
  }

  // Add semester fee
  Future<void> addSemesterFee(
      String studentId, int semester, int amount) async {
    try {
      await _firestore.collection('students').doc(studentId).update({
        'semester_fees.semester_$semester': {'amount': amount, 'paid': false},
      });
      notifyListeners();
    } catch (e) {
      print("Error adding semester fee: $e");
    }
  }

  // Mark semester fee as paid
  Future<void> markFeePaid(String studentId, int semester) async {
    try {
      await _firestore.collection('students').doc(studentId).update({
        'semester_fees.semester_$semester.paid': true,
      });
      notifyListeners();
    } catch (e) {
      print("Error marking fee as paid: $e");
    }
  }

  Future<void> markSemesterFeePaid(
      String studentId, int index, bool isPaid) async {
    try {
      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);

      // Fetch the current semester fees data
      DocumentSnapshot studentSnapshot = await studentRef.get();

      if (studentSnapshot.exists && studentSnapshot.data() != null) {
        Map<String, dynamic> studentData =
            studentSnapshot.data() as Map<String, dynamic>;

        if (studentData.containsKey('semester_fees')) {
          List<dynamic> feesList = List.from(studentData['semester_fees']);

          // Ensure the index is within range
          if (index >= 0 && index < feesList.length) {
            feesList[index]['paid'] = isPaid; // Update the paid status

            // Update Firestore document
            await studentRef.update({'semester_fees': feesList});

            print("Semester fee status updated successfully.");
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print("Error updating semester fee status: $e");
    }
  }
}
