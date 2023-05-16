import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  String _verificationId = "";

  void _signInWithPhoneNumber() async {
    String phoneNumber = _phoneNumberController.text.trim();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: 'Phone number automatically verified');
          // Perform necessary operations after verification completion
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: 'Verification failed: ${e.message}');
          // Handle verification failure, such as displaying an error message
        },
        codeSent: (String verificationId, int? resendToken) {
          Fluttertoast.showToast(msg: 'OTP sent to your phone number');
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Fluttertoast.showToast(msg: 'OTP code auto-retrieval timeout');
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      // Handle any other exceptions that may occur
    }
  }

  void _signInWithOTP() async {
    String otp = _otpController.text.trim();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      Fluttertoast.showToast(msg: 'OTP verification successful');
      // Perform necessary operations after OTP verification
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
      // Handle any other exceptions that may occur during OTP verification
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: const Text('Send OTP'),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signInWithOTP,
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
