import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AssessmentController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAssessment({
    required String teacherId,
    required String subject,
    required int semester,
    required String paperCode,
    required String type,
    required String name,
    required DateTime dueDate,
  }) async {
    try {
      String semesterKey = "semester_$semester";
      QuerySnapshot studentSnapshot = await _firestore
          .collection('students')
          .where('assigned_subjects', arrayContains: subject)
          .get();

      for (var doc in studentSnapshot.docs) {
        String studentId = doc.id;

        await _firestore.collection('students').doc(studentId).set({
          'assessments': {
            semesterKey: FieldValue.arrayUnion([
              {
                'type': type,
                'name': name,
                'due_date': dueDate.toIso8601String(),
                'subject': subject,
                'paper_code': paperCode,
                'submitted': false,
              }
            ])
          }
        }, SetOptions(merge: true));
        // 🔹 Fetch Parent's FCM Token
        DocumentSnapshot studentDoc =
            await _firestore.collection('students').doc().get();
        String? parentFcmToken =
            studentDoc['fcm_token']; // Store FCM token in Firestore

        // 🔹 Send Push Notification to Parent
        if (parentFcmToken != null && parentFcmToken.isNotEmpty) {
          await sendPushNotification(
            token: parentFcmToken,
            title: "New Assessment Added",
            body: "A new $type '$name' has been assigned. Due: $dueDate",
          );
        }

        print("Assessment added & notification sent!");
      }

      print("Assessment added successfully for students.");
    } catch (e) {
      print("Error adding assessment: $e");
    }
  }

  /// 📌 **Function to Send FCM Push Notification**
  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'AAAAODpdCpk:APA91bFViaKYjlW4ZGp2ua9fwTmeuyswR2Oy305-QmFl5xME8V8aTK9vjVMx85swhh0KWUBdogoW3XQ0TkExA7U_ckQKv_7U-PgkJZSdurR5pAQIVn_TZBRBsRxKDnf_-XLS0HUNOEaG', // 🔹 Replace with your Firebase Server Key
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'priority': 'high',
        }),
      );
      print("Push notification sent successfully!");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

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
        return List<Map<String, dynamic>>.from(assessmentsData[semesterKey]);
      }

      return [];
    } catch (e) {
      print("Error fetching assessments: $e");
      return [];
    }
  }

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
}
