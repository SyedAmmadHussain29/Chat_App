// //--------
// import 'package:chat_app/API/api.dart';
// import 'package:chat_app/view/screens/mainscreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   double screenHeight = 0;
//   double screenWidth = 0;
//   double bottom = 0;

//   String otpPin = "";
//   String countryDial = "+1";
//   String verificationId = "";

//   int screenState = 0;

//   Color blue = const Color(0xff8cccff);

//   Future<void> verifyPhone(String number) async {
//     await APIs.auth.verifyPhoneNumber(
//       phoneNumber: number,
//       timeout: const Duration(seconds: 20),
//       verificationCompleted: (PhoneAuthCredential credential) {
//         showSnackBarText("Authentication completed!");
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         showSnackBarText("Authentication failed!");
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         showSnackBarText("OTP sent!");
//         setState(() {
//           screenState = 1;
//           this.verificationId = verificationId;
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         showSnackBarText("OTP auto-retrieval timeout!");
//       },
//     );
//   }

//   Future<void> verifyOTP() async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: verificationId,
//         smsCode: otpPin,
//       );
//       await APIs.auth.signInWithCredential(credential);
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => MainScreen(),
//         ),
//       );
//     } catch (e) {
//       showSnackBarText("Invalid OTP. Please try again.");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;
//     bottom = MediaQuery.of(context).viewInsets.bottom;

//     return WillPopScope(
//       onWillPop: () {
//         setState(() {
//           screenState = 0;
//         });
//         return Future.value(false);
//       },
//       child: Scaffold(
//         backgroundColor: blue,
//         body: SizedBox(
//           height: screenHeight,
//           width: screenWidth,
//           child: Stack(
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(top: screenHeight / 8),
//                   child: Column(
//                     children: [
//                       Text(
//                         "JOIN US",
//                         style: TextStyle(
//                           // Update with your custom style
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         "Create an account today!",
//                         style: TextStyle(
//                           // Update with your custom style
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: circle(5),
//               ),
//               Transform.translate(
//                 offset: const Offset(30, -30),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: circle(4.5),
//                 ),
//               ),
//               Center(
//                 child: circle(3),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: AnimatedContainer(
//                   height: bottom > 0 ? screenHeight : screenHeight / 2,
//                   width: screenWidth,
//                   color: Colors.white,
//                   duration: const Duration(milliseconds: 800),
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       left: screenWidth / 12,
//                       right: screenWidth / 12,
//                       top: bottom > 0 ? screenHeight / 12 : 0,
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         screenState == 0 ? stateRegister() : stateOTP(),
//                         GestureDetector(
//                           onTap: () {
//                             if (screenState == 0) {
//                               if (usernameController.text.isEmpty) {
//                                 showSnackBarText("Username is still empty!");
//                               } else if (phoneController.text.isEmpty) {
//                                 showSnackBarText(
//                                     "Phone number is still empty!");
//                               } else {
//                                 verifyPhone(countryDial + phoneController.text);
//                               }
//                             } else {
//                               if (otpPin.length == 6) {
//                                 verifyOTP();
//                               } else {
//                                 showSnackBarText("Enter OTP correctly!");
//                               }
//                             }
//                           },
//                           child: Container(
//                             height: 50,
//                             width: screenWidth,
//                             margin: EdgeInsets.only(bottom: screenHeight / 12),
//                             decoration: BoxDecoration(
//                               color: blue,
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 "CONTINUE",
//                                 style: TextStyle(
//                                   // Update with your custom style
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 1.5,
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showSnackBarText(String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//       ),
//     );
//   }

//   Widget stateRegister() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "Username",
//           style: TextStyle(
// // Update with your custom style
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(
//           height: 8,
//         ),
//         TextFormField(
//           controller: usernameController,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 16,
//         ),
//         Text(
//           "Phone number",
//           style: TextStyle(
// // Update with your custom style
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         IntlPhoneField(
//           controller: phoneController,
//           showCountryFlag: false,
//           showDropdownIcon: false,
//           initialValue: countryDial,
//           onCountryChanged: (country) {
//             setState(() {
//               countryDial = "+" + country.dialCode;
//             });
//           },
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget stateOTP() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: "We just sent a code to ",
//                 style: TextStyle(
//                   // Update with your custom style
//                   color: Colors.black87,
//                   fontSize: 18,
//                 ),
//               ),
//               TextSpan(
//                 text: countryDial + phoneController.text,
//                 style: TextStyle(
//                   // Update with your custom style
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               TextSpan(
//                 text: "\nEnter the code here and we can continue!",
//                 style: TextStyle(
//                   // Update with your custom style
//                   color: Colors.black87,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         PinCodeTextField(
//           appContext: context,
//           length: 6,
//           onChanged: (value) {
//             setState(() {
//               otpPin = value;
//             });
//           },
//           pinTheme: PinTheme(
//             activeColor: blue,
//             selectedColor: blue,
//             inactiveColor: Colors.black26,
//           ),
//         ),
//         const SizedBox(
//           height: 20,
//         ),
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: "Didn't receive the code? ",
//                 style: TextStyle(
//                   // Update with your custom style
//                   color: Colors.black87,
//                   fontSize: 12,
//                 ),
//               ),
//               WidgetSpan(
//                 child: GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       screenState = 0;
//                     });
//                   },
//                   child: Text(
//                     "Resend",
//                     style: TextStyle(
//                       // Update with your custom style
//                       color: Colors.black87,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget circle(double size) {
//     return Container(
//       height: screenHeight / size,
//       width: screenHeight / size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.white,
//       ),
//     );
//   }
// }
