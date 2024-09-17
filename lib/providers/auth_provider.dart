import 'package:chat_hub/models/user_model.dart';
import 'package:chat_hub/utilites/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isSuccessful = false;
  String? _uid;
  String? _phoneNumber;
  UserModel? _userModel;
  bool get isLoading => _isLoading;
  bool get isSuccessful => _isSuccessful;
  String? get uid => _uid;
  String? get phoneNumber => _phoneNumber;
  UserModel? get userModel => _userModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //Sign in with phone number
  Future<void> signInWithPhone({required String phoneNumber, required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value)async {
          _uid = value.user!.uid;
          _phoneNumber = value.user!.phoneNumber;
          _isLoading = false;
          _isSuccessful = true;
          notifyListeners();
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        _isSuccessful = false;
        _isLoading = false;
        notifyListeners();
        showSnackBar(context, e.toString()); // ScaffoldMessenger.of(context).showSnackBar(snackBar)
      },
      codeSent: (String verificationId, int? resendToken) {
        _isLoading = false;
        notifyListeners();
        //navigate to OTP screen
        print('navigate to OTP screen');

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _isLoading = false;
        notifyListeners();}
    );
  }


}