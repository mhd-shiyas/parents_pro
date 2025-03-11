import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class FeesController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Razorpay _razorpay;
  String? _studentId;
  int? _semester;

  FeesController() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// 🟢 Start Payment for Selected Semester
  void startPayment(int amount, String studentId, int semester) {
    _studentId = studentId;
    _semester = semester;

    var options = {
      'key': 'rzp_test_LDkB24Y4OzbOZa', // Replace with your actual Razorpay key
      'amount': amount * 100, // Convert to paise
      'name': 'College Fees Payment',
      'description': 'Semester Fee Payment - Semester $semester',
      'prefill': {'email': 'test@example.com'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error opening Razorpay: $e");
    }
  }

  /// ✅ Handle Successful Payment
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment Successful: ${response.paymentId}");
    if (_studentId == null || _semester == null) {
      print("Error: Missing student ID or semester");
      return;
    }

    try {
      await _updatePaymentStatus(_studentId!, _semester!, response.paymentId!);
      notifyListeners();
      print("Payment status updated successfully!");
    } catch (e) {
      print("Error updating payment status: $e");
    }
  }

  /// ❌ Handle Failed Payment
  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment failed: ${response.message}");
  }

  /// 🔄 Handle External Wallet Selection
  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
  }

  /// 🔄 Update Firebase Payment Status for the Selected Semester
  Future<void> _updatePaymentStatus(
      String studentId, int semester, String paymentId) async {
    try {
      String semesterKey = "semester_$semester";
      DocumentReference studentRef =
          _firestore.collection('students').doc(studentId);

      await studentRef.update({
        "semester_fees.$semesterKey.paid": true,
        "semester_fees.$semesterKey.payment_id": paymentId,
      });

      print("Payment status successfully updated in Firebase!");
    } catch (e) {
      print("Error updating payment status: $e");
    }
  }

  /// 🔄 Fetch Semester Fees from Firebase
  Future<List<Map<String, dynamic>>> fetchSemesterFees(String studentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> studentSnapshot =
          await _firestore.collection('students').doc(studentId).get();

      if (!studentSnapshot.exists ||
          !studentSnapshot.data()!.containsKey('semester_fees')) {
        return []; // No fees found
      }

      Map<String, dynamic> feesData = studentSnapshot.data()!['semester_fees'];
      List<Map<String, dynamic>> semesterFees = [];

      feesData.forEach((semesterKey, feeDetails) {
        if (feeDetails is Map<String, dynamic>) {
          semesterFees.add({
            'semester':
                int.parse(semesterKey.split('_')[1]), // Extract semester number
            'amount': feeDetails['amount'] ?? 0,
            'paid': feeDetails['paid'] ?? false,
          });
        }
      });

      return semesterFees;
    } catch (e) {
      print("Error fetching semester fees: $e");
      return [];
    }
  }

  /// 🛑 Dispose Razorpay Instance
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class FeesController extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final Razorpay _razorpay = Razorpay();

//   Map<String, dynamic> semesterFees = {};
//   bool isLoading = true;

//   String? _studentId;
//   int? _semester;

//   FeesController(String id) {
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     fetchFees(id);
//   }

//   final id = FirebaseAuth.instance.currentUser;

//   // Fetch Semester Fees from Firestore
//   Future<void> fetchFees(String id) async {
//     try {
//       DocumentSnapshot snapshot =
//           await _firestore.collection('students').doc(id).get();
//       if (snapshot.exists) {
//         semesterFees = snapshot['semester_fees'] ?? {};
//       }
//     } catch (e) {
//       print("Error fetching fees: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }

//   void startPayment(int amount, String studentId, int semester) {
//     _studentId = studentId;
//     _semester = semester;

//     var options = {
//       'key': 'rzp_test_LDkB24Y4OzbOZa',
//       'amount': amount * 100, // Convert to paise
//       'name': 'College Fees',
//       'description': 'Semester Fee Payment',
//       'prefill': {'email': 'test@example.com'},
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   // Pay Fees using Razorpay
//   // void payFees(String semester, int amount) {
//   //   var options = {
//   //     'key': 'rzp_test_LDkB24Y4OzbOZa',
//   //     'amount': amount * 100, // Razorpay expects amount in paise
//   //     'name': 'College Fees',
//   //     'description': 'Semester $semester Fees',
//   //     'prefill': {'contact': '9876543210', 'email': 'student@email.com'},
//   //     'external': {
//   //       'wallets': ['paytm']
//   //     }
//   //   };

//   //   try {
//   //     _razorpay.open(options);
//   //   } catch (e) {
//   //     print("Error: $e");
//   //   }
//   // }

//   // Handle Payment Success
//   // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//   //   print("Payment Successful: ${response.paymentId}");
//   //   await _updatePaymentStatus(response.paymentId ?? '');
//   // }
//   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//     print("Payment Successful: ${response.paymentId}");

//     // Ensure studentId and semester are available
//     if (_studentId == null || _semester == null) {
//       print("Error: Missing student ID or semester");
//       return;
//     }

//     try {
//       await _updatePaymentStatus(_studentId!, _semester!, response.paymentId!);
//       print("Payment status updated successfully!");
//     } catch (e) {
//       print("Error updating payment status: $e");
//     }
//   }

//   // Handle Payment Failure
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Payment Failed: ${response.message}");
//   }

//   // Handle External Wallet Payment
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("External Wallet Selected: ${response.walletName}");
//   }

//   // Update Payment Status in Firestore
//   // Future<void> _updatePaymentStatus(String paymentId) async {
//   //   try {
//   //     await _firestore.collection('students').doc(id!.uid).update({
//   //       'semester_fees.semester_2.paid': true,
//   //     });
//   //     fetchFees(id!.uid); // Refresh data
//   //   } catch (e) {
//   //     print("Error updating payment status: $e");
//   //   }
//   // }
//   Future<void> _updatePaymentStatus(
//       String studentId, int semester, String paymentId) async {
//     try {
//       String semesterKey = "semester_$semester";

//       DocumentReference studentRef =
//           FirebaseFirestore.instance.collection('students').doc(studentId);

//       await studentRef.update({
//         "semester_fees.$semesterKey.paid": true, // Mark fee as paid
//         "semester_fees.$semesterKey.payment_id": paymentId, // Store Payment ID
//       });

//       print("Payment status successfully updated in Firebase!");
//     } catch (e) {
//       print("Error updating payment status: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
// }
